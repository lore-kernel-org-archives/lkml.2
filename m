Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab1HTTbv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 15:31:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54793 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab1HTTbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 15:31:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-sh@vger.kernel.org
Subject: [PATCH 2/2] sh-sci / PM: Use power.irq_safe
Date: Sat, 20 Aug 2011 21:33:09 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
References: <201108202131.19479.rjw@sisk.pl>
In-Reply-To: <201108202131.19479.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108202133.09222.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since sci_port_enable() and sci_port_disable() may be run with
interrupts off and they execute pm_runtime_get_sync() and
pm_runtime_put_sync(), respectively, the SCI device's
power.irq_safe flags has to be used to indicate that it is safe
to execute runtime PM callbacks for this device with interrupts off.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/tty/serial/sh-sci.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux/drivers/tty/serial/sh-sci.c
===================================================================
--- linux.orig/drivers/tty/serial/sh-sci.c
+++ linux/drivers/tty/serial/sh-sci.c
@@ -1582,11 +1582,15 @@ static int sci_startup(struct uart_port
 
 	dev_dbg(port->dev, "%s(%d)\n", __func__, port->line);
 
+	pm_runtime_irq_safe(port->dev);
+
 	sci_port_enable(s);
 
 	ret = sci_request_irq(s);
-	if (unlikely(ret < 0))
+	if (unlikely(ret < 0)) {
+		pm_runtime_irq_unsafe(port->dev);
 		return ret;
+	}
 
 	sci_request_dma(port);
 
@@ -1609,6 +1613,8 @@ static void sci_shutdown(struct uart_por
 	sci_free_irq(s);
 
 	sci_port_disable(s);
+
+	pm_runtime_irq_unsafe(port->dev);
 }
 
 static unsigned int sci_scbrr_calc(unsigned int algo_id, unsigned int bps,

