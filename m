Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2JRU1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:27:00 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56794 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab2JRU0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:26:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 09/21] TTY: n_tty, simplify read_buf+echo_buf allocation
Date: Thu, 18 Oct 2012 22:26:35 +0200
Message-Id: <1350592007-9216-10-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ldisc->open and close are called only once and cannot cross. So the
tests in open and close are superfluous. Remove them. (But leave sets
to NULL to ensure there is not a bug somewhere.)

And when the tests are gone, handle properly failures in open. We
leaked read_buf if allocation of echo_buf failed before. Now this is
not the case anymore.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/n_tty.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 8c0b7b4..f27289d 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1561,14 +1561,10 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 static void n_tty_close(struct tty_struct *tty)
 {
 	n_tty_flush_buffer(tty);
-	if (tty->read_buf) {
-		kfree(tty->read_buf);
-		tty->read_buf = NULL;
-	}
-	if (tty->echo_buf) {
-		kfree(tty->echo_buf);
-		tty->echo_buf = NULL;
-	}
+	kfree(tty->read_buf);
+	kfree(tty->echo_buf);
+	tty->read_buf = NULL;
+	tty->echo_buf = NULL;
 }
 
 /**
@@ -1587,17 +1583,11 @@ static int n_tty_open(struct tty_struct *tty)
 		return -EINVAL;
 
 	/* These are ugly. Currently a malloc failure here can panic */
-	if (!tty->read_buf) {
-		tty->read_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
-		if (!tty->read_buf)
-			return -ENOMEM;
-	}
-	if (!tty->echo_buf) {
-		tty->echo_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
+	tty->read_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
+	tty->echo_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
+	if (!tty->read_buf || !tty->echo_buf)
+		goto err_free_bufs;
 
-		if (!tty->echo_buf)
-			return -ENOMEM;
-	}
 	reset_buffer_flags(tty);
 	tty_unthrottle(tty);
 	tty->column = 0;
@@ -1605,6 +1595,11 @@ static int n_tty_open(struct tty_struct *tty)
 	tty->minimum_to_wake = 1;
 	tty->closing = 0;
 	return 0;
+err_free_bufs:
+	kfree(tty->read_buf);
+	kfree(tty->echo_buf);
+
+	return -ENOMEM;
 }
 
 static inline int input_available_p(struct tty_struct *tty, int amt)
-- 
1.7.12.3


