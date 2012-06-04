Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472Ab2FDLkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:40:25 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:44989 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab2FDLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:35:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 19/24] TTY: vt, add ->install
Date: Mon,  4 Jun 2012 13:35:33 +0200
Message-Id: <1338809738-18967-20-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.3
In-Reply-To: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to initialize the console only on the first open. This is
usually what is done in the ->install hook. vt used to do this in
->open. Now we move it to ->install and use newly added helper for
install: tty_port_install. It ensures tty->port to be set properly.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/vt/vt.c |   60 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 88a4914..7cb53c2 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2792,41 +2792,52 @@ static void con_flush_chars(struct tty_struct *tty)
 /*
  * Allocate the console screen memory.
  */
-static int con_open(struct tty_struct *tty, struct file *filp)
+static int con_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	unsigned int currcons = tty->index;
-	int ret = 0;
+	struct vc_data *vc;
+	int ret;
 
 	console_lock();
-	if (tty->driver_data == NULL) {
-		ret = vc_allocate(currcons);
-		if (ret == 0) {
-			struct vc_data *vc = vc_cons[currcons].d;
+	ret = vc_allocate(currcons);
+	if (ret)
+		goto unlock;
 
-			/* Still being freed */
-			if (vc->port.tty) {
-				console_unlock();
-				return -ERESTARTSYS;
-			}
-			tty->driver_data = vc;
-			vc->port.tty = tty;
+	vc = vc_cons[currcons].d;
 
-			if (!tty->winsize.ws_row && !tty->winsize.ws_col) {
-				tty->winsize.ws_row = vc_cons[currcons].d->vc_rows;
-				tty->winsize.ws_col = vc_cons[currcons].d->vc_cols;
-			}
-			if (vc->vc_utf)
-				tty->termios->c_iflag |= IUTF8;
-			else
-				tty->termios->c_iflag &= ~IUTF8;
-			console_unlock();
-			return ret;
-		}
+	/* Still being freed */
+	if (vc->port.tty) {
+		ret = -ERESTARTSYS;
+		goto unlock;
 	}
+
+	ret = tty_port_install(&vc->port, driver, tty);
+	if (ret)
+		goto unlock;
+
+	tty->driver_data = vc;
+	vc->port.tty = tty;
+
+	if (!tty->winsize.ws_row && !tty->winsize.ws_col) {
+		tty->winsize.ws_row = vc_cons[currcons].d->vc_rows;
+		tty->winsize.ws_col = vc_cons[currcons].d->vc_cols;
+	}
+	if (vc->vc_utf)
+		tty->termios->c_iflag |= IUTF8;
+	else
+		tty->termios->c_iflag &= ~IUTF8;
+unlock:
 	console_unlock();
 	return ret;
 }
 
+static int con_open(struct tty_struct *tty, struct file *filp)
+{
+	/* everything done in install */
+	return 0;
+}
+
+
 static void con_close(struct tty_struct *tty, struct file *filp)
 {
 	/* Nothing to do - we defer to shutdown */
@@ -2947,6 +2958,7 @@ static int __init con_init(void)
 console_initcall(con_init);
 
 static const struct tty_operations con_ops = {
+	.install = con_install,
 	.open = con_open,
 	.close = con_close,
 	.write = con_write,
-- 
1.7.10.3


