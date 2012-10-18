Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2JRU05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:26:57 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56787 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab2JRU0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:26:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 12/21] TTY: n_tty, add ldisc data to n_tty
Date: Thu, 18 Oct 2012 22:26:38 +0200
Message-Id: <1350592007-9216-13-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All n_tty related members from tty_struct will be moved here.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/n_tty.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 3ebab0c..3d1594e 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -73,6 +73,10 @@
 #define ECHO_OP_SET_CANON_COL 0x81
 #define ECHO_OP_ERASE_TAB 0x82
 
+struct n_tty_data {
+	char dummy;
+};
+
 static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
 			       unsigned char __user *ptr)
 {
@@ -1556,11 +1560,15 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 
 static void n_tty_close(struct tty_struct *tty)
 {
+	struct n_tty_data *ldata = tty->disc_data;
+
 	n_tty_flush_buffer(tty);
 	kfree(tty->read_buf);
 	kfree(tty->echo_buf);
+	kfree(ldata);
 	tty->read_buf = NULL;
 	tty->echo_buf = NULL;
+	tty->disc_data = NULL;
 }
 
 /**
@@ -1575,23 +1583,32 @@ static void n_tty_close(struct tty_struct *tty)
 
 static int n_tty_open(struct tty_struct *tty)
 {
+	struct n_tty_data *ldata;
+
+	ldata = kzalloc(sizeof(*ldata), GFP_KERNEL);
+	if (!ldata)
+		goto err;
+
 	/* These are ugly. Currently a malloc failure here can panic */
 	tty->read_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
 	tty->echo_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
 	if (!tty->read_buf || !tty->echo_buf)
 		goto err_free_bufs;
 
+	tty->disc_data = ldata;
 	reset_buffer_flags(tty);
 	tty_unthrottle(tty);
 	tty->column = 0;
 	n_tty_set_termios(tty, NULL);
 	tty->minimum_to_wake = 1;
 	tty->closing = 0;
+
 	return 0;
 err_free_bufs:
 	kfree(tty->read_buf);
 	kfree(tty->echo_buf);
-
+	kfree(ldata);
+err:
 	return -ENOMEM;
 }
 
-- 
1.7.12.3


