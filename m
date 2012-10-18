Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab2JRUb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:31:58 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56796 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab2JRU0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:26:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 10/21] TTY: n_tty, remove bogus checks
Date: Thu, 18 Oct 2012 22:26:36 +0200
Message-Id: <1350592007-9216-11-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* BUG_ON(!tty) in n_tty_set_termios -- it cannot be called with tty ==
  NULL. It is called from two call sites. First, from n_tty_open where
  we have a valid tty. Second, as ld->ops->set_termios from
  tty_set_termios. But there we have a valid tty too.
* if (!tty) in n_tty_open -- why would the TTY layer call ldisc's
  open with an invalid TTY? No it indeed does not. All call sites have
  a tty and dereference that.
* BUG_ON(!tty->read_buf) in n_tty_read -- this used to be a valid
  check. The ldisc handling was broken some time ago when I added the
  check to ensure everything is OK. It still can catch the case, but
  no later than we move the buffer to ldisc data. Then there will be
  no read_buf in tty_struct, i.e. nothing to check for.
* if (!tty->read_buf) in n_tty_receive_buf -- this should never
  happen. All callers of ldisc->ops->receive_ops should hold a
  reference to an ldisc and close (which frees read_buf) cannot be
  called until the reference is dropped.
* if (WARN_ON(!tty->read_buf)) in n_tty_read -- the same as in the
  previous case.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/n_tty.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index f27289d..ceae074 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1375,9 +1375,6 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	char	buf[64];
 	unsigned long cpuflags;
 
-	if (!tty->read_buf)
-		return;
-
 	if (tty->real_raw) {
 		spin_lock_irqsave(&tty->read_lock, cpuflags);
 		i = min(N_TTY_BUF_SIZE - tty->read_cnt,
@@ -1471,7 +1468,6 @@ int is_ignored(int sig)
 static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
 	int canon_change = 1;
-	BUG_ON(!tty);
 
 	if (old)
 		canon_change = (old->c_lflag ^ tty->termios.c_lflag) & ICANON;
@@ -1579,9 +1575,6 @@ static void n_tty_close(struct tty_struct *tty)
 
 static int n_tty_open(struct tty_struct *tty)
 {
-	if (!tty)
-		return -EINVAL;
-
 	/* These are ugly. Currently a malloc failure here can panic */
 	tty->read_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
 	tty->echo_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
@@ -1736,10 +1729,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 	int packet;
 
 do_it_again:
-
-	if (WARN_ON(!tty->read_buf))
-		return -EAGAIN;
-
 	c = job_control(tty, file);
 	if (c < 0)
 		return c;
@@ -1825,7 +1814,6 @@ do_it_again:
 			/* FIXME: does n_tty_set_room need locking ? */
 			n_tty_set_room(tty);
 			timeout = schedule_timeout(timeout);
-			BUG_ON(!tty->read_buf);
 			continue;
 		}
 		__set_current_state(TASK_RUNNING);
-- 
1.7.12.3


