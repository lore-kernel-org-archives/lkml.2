Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2HGT5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 15:57:23 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:49899 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab2HGT5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 15:57:20 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 38/41] TTY: tty3270, add tty install
Date: Tue,  7 Aug 2012 21:48:03 +0200
Message-Id: <1344368886-24033-39-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has two outcomes:
* we give the TTY layer a tty_port
* we do not find the info structure every time open is called on that
  tty

In this case ->install is the only thing we want to do. We do not need
->open at all. See the tty->count > 1 check.

And since we take a reference in ->install, we need also ->cleanup to
drop the reference to a view.

Final note, see that we leave raw3270_find_view in place. It is
because views are removed even from module_exit.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 drivers/s390/char/tty3270.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index f2b8c6c..482ee02 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -842,17 +842,14 @@ static struct raw3270_fn tty3270_fn = {
 };
 
 /*
- * This routine is called whenever a 3270 tty is opened.
+ * This routine is called whenever a 3270 tty is opened first time.
  */
-static int
-tty3270_open(struct tty_struct *tty, struct file * filp)
+static int tty3270_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	struct raw3270_view *view;
 	struct tty3270 *tp;
 	int i, rc;
 
-	if (tty->count > 1)
-		return 0;
 	/* Check if the tty3270 is already there. */
 	view = raw3270_find_view(&tty3270_fn,
 				  tty->index + RAW3270_FIRSTMINOR);
@@ -865,7 +862,7 @@ tty3270_open(struct tty_struct *tty, struct file * filp)
 		/* why to reassign? */
 		tty_port_tty_set(&tp->port, tty);
 		tp->inattr = TF_INPUT;
-		return 0;
+		return tty_port_install(&tp->port, driver, tty);
 	}
 	if (tty3270_max_index < tty->index + 1)
 		tty3270_max_index = tty->index + 1;
@@ -895,7 +892,6 @@ tty3270_open(struct tty_struct *tty, struct file * filp)
 
 	tty_port_tty_set(&tp->port, tty);
 	tty->low_latency = 0;
-	tty->driver_data = tp;
 	tty->winsize.ws_row = tp->view.rows - 2;
 	tty->winsize.ws_col = tp->view.cols;
 
@@ -915,6 +911,15 @@ tty3270_open(struct tty_struct *tty, struct file * filp)
 	kbd_ascebc(tp->kbd, tp->view.ascebc);
 
 	raw3270_activate_view(&tp->view);
+
+	rc = tty_port_install(&tp->port, driver, tty);
+	if (rc) {
+		raw3270_put_view(&tp->view);
+		return rc;
+	}
+
+	tty->driver_data = tp;
+
 	return 0;
 }
 
@@ -932,10 +937,17 @@ tty3270_close(struct tty_struct *tty, struct file * filp)
 	if (tp) {
 		tty->driver_data = NULL;
 		tty_port_tty_set(&tp->port, NULL);
-		raw3270_put_view(&tp->view);
 	}
 }
 
+static void tty3270_cleanup(struct tty_struct *tty)
+{
+	struct tty3270 *tp = tty->driver_data;
+
+	if (tp)
+		raw3270_put_view(&tp->view);
+}
+
 /*
  * We always have room.
  */
@@ -1737,7 +1749,8 @@ static long tty3270_compat_ioctl(struct tty_struct *tty,
 #endif
 
 static const struct tty_operations tty3270_ops = {
-	.open = tty3270_open,
+	.install = tty3270_install,
+	.cleanup = tty3270_cleanup,
 	.close = tty3270_close,
 	.write = tty3270_write,
 	.put_char = tty3270_put_char,
-- 
1.7.10.4


