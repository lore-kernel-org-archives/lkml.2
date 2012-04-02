Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab2DBL4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:56:15 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:48061 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab2DBLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Karsten Keil <isdn@linux-pingi.de>
Subject: [PATCH 17/69] TTY: isdn, define tty_port_operations
Date: Mon,  2 Apr 2012 13:54:01 +0200
Message-Id: <1333367693-3244-18-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add there .carrier_raised. It is taken from current block_til_ready.
We will need tty_port->ops->carrier_raised for
tty_port_block_til_ready helper.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Karsten Keil <isdn@linux-pingi.de>
---
 drivers/isdn/i4l/isdn_tty.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 50d7246..b41a80a 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1485,6 +1485,7 @@ isdn_tty_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
  * isdn_tty_open() and friends
  * ------------------------------------------------------------
  */
+
 static int
 isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *info)
 {
@@ -1552,7 +1553,7 @@ isdn_tty_block_til_ready(struct tty_struct *tty, struct file *filp, modem_info *
 			break;
 		}
 		if (!(port->flags & ASYNC_CLOSING) &&
-		    (do_clocal || (info->msr & UART_MSR_DCD))) {
+		    (do_clocal || tty_port_carrier_raised(port))) {
 			break;
 		}
 		if (signal_pending(current)) {
@@ -1848,6 +1849,16 @@ static const struct tty_operations modem_ops = {
 	.tiocmset = isdn_tty_tiocmset,
 };
 
+static int isdn_tty_carrier_raised(struct tty_port *port)
+{
+	modem_info *info = container_of(port, modem_info, port);
+	return info->msr & UART_MSR_DCD;
+}
+
+static const struct tty_port_operations isdn_tty_port_ops = {
+	.carrier_raised = isdn_tty_carrier_raised,
+};
+
 int
 isdn_tty_modem_init(void)
 {
@@ -1884,6 +1895,7 @@ isdn_tty_modem_init(void)
 		}
 #endif
 		tty_port_init(&info->port);
+		info->port.ops = &isdn_tty_port_ops;
 		spin_lock_init(&info->readlock);
 		sprintf(info->last_cause, "0000");
 		sprintf(info->last_num, "none");
-- 
1.7.9.2


