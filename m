Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab0HIKHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 06:07:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34064 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab0HIKHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 06:07:38 -0400
From: Michal Simek <monstr@monstr.eu>
To: jacmet@sunsite.dk
Cc: grant.likely@secretlab.ca, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH] serial: Add CONSOLE_POLL support for uartlite
Date: Mon,  9 Aug 2010 12:07:32 +0200
Message-Id: <1281348452-26924-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONSOLE_POLL support for uartlite enables
KGDB debugging over serial line.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 drivers/serial/uartlite.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
index caf085d..ce1f3e0 100644
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -322,6 +322,26 @@ static int ulite_verify_port(struct uart_port *port, struct serial_struct *ser)
 	return -EINVAL;
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+static int ulite_get_poll_char(struct uart_port *port)
+{
+	while (!(ioread32be(port->membase + ULITE_STATUS)
+						& ULITE_STATUS_RXVALID))
+		cpu_relax();
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
1.5.5.6

