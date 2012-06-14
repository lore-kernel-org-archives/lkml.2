Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab2FNX6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:58:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45919 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab2FNX6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:58:15 -0400
Message-Id: <20120614235645.163459203@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, AnilKumar Ch <anilkumar@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [ 10/20] can: c_can: fix race condition in c_can_open()
In-Reply-To: <20120614235648.GA6552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AnilKumar Ch <anilkumar@ti.com>

commit f461f27a4436dbe691908fe08b867ef888848cc3 upstream.

Fix the issue of C_CAN interrupts getting disabled forever when canconfig
utility is used multiple times. According to NAPI usage we disable all
the hardware interrupts in ISR and re-enable them in poll(). Current
implementation calls napi_enable() after hardware interrupts are enabled.
If we get any interrupts between these two steps then we do not process
those interrupts because napi is not enabled. Mostly these interrupts
come because of STATUS is not 0x7 or ERROR interrupts. If napi_enable()
happens before HW interrupts enabled then c_can_poll() function will be
called eventual re-enabling.

This patch moves the napi_enable() call before interrupts enabled.

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
Acked-by: Wolfgang Grandegger <wg@grandegger.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/c_can/c_can.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -1066,10 +1066,11 @@ static int c_can_open(struct net_device
 		goto exit_irq_fail;
 	}
 
+	napi_enable(&priv->napi);
+
 	/* start the c_can controller */
 	c_can_start(dev);
 
-	napi_enable(&priv->napi);
 	netif_start_queue(dev);
 
 	return 0;


