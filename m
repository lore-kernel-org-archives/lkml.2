Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab0JVTat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:30:49 -0400
Received: from kroah.org ([198.145.64.141]:41843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758337Ab0JVSVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:21:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/49] serial: Add CONSOLE_POLL support for uartlite
Date: Fri, 22 Oct 2010 11:20:43 -0700
Message-Id: <1287771688-14805-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

CONSOLE_POLL support for uartlite enables
KGDB debugging over serial line.

Signed-off-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/uartlite.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
index 9b03d7b..c4bf54b 100644
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -322,6 +322,26 @@ static int ulite_verify_port(struct uart_port *port, struct serial_struct *ser)
 	return -EINVAL;
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+static int ulite_get_poll_char(struct uart_port *port)
+{
+	if (!(ioread32be(port->membase + ULITE_STATUS)
+						& ULITE_STATUS_RXVALID))
+		return NO_POLL_CHAR;
+
+	return ioread32be(port->membase + ULITE_RX);
+}
+
+static void ulite_put_poll_char(struct uart_port *port, unsigned char ch)
+{
+	while (ioread32be(port->membase + ULITE_STATUS) & ULITE_STATUS_TXFULL)
+		cpu_relax();
+
+	/* write char to device */
+	iowrite32be(ch, port->membase + ULITE_TX);
+}
+#endif
+
 static struct uart_ops ulite_ops = {
 	.tx_empty	= ulite_tx_empty,
 	.set_mctrl	= ulite_set_mctrl,
@@ -338,7 +358,11 @@ static struct uart_ops ulite_ops = {
 	.release_port	= ulite_release_port,
 	.request_port	= ulite_request_port,
 	.config_port	= ulite_config_port,
-	.verify_port	= ulite_verify_port
+	.verify_port	= ulite_verify_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char	= ulite_get_poll_char,
+	.poll_put_char	= ulite_put_poll_char,
+#endif
 };
 
 /* ---------------------------------------------------------------------
-- 
1.7.2

