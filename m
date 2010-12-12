Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab0LMAM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:12:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36094 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab0LLXqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:39 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: jslaby@suse.cz, alan@lxorguk.ukuu.org.uk, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [98/223] TTY: open/hangup race fixup
Message-Id: <20101212234638.61E93B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jiri Slaby <jslaby@suse.cz>

commit acfa747baf73922021a047f2d87a2d866f5dbab5 upstream.

Like in the "TTY: don't allow reopen when ldisc is changing" patch,
this one fixes a TTY WARNING as described in the option 1) there:
1) __tty_hangup from tty_ldisc_hangup to tty_ldisc_enable. During this
section tty_lock is held. However tty_lock is temporarily dropped in
the middle of the function by tty_ldisc_hangup.

The fix is to introduce a new flag which we set during the unlocked
window and check it in tty_reopen too. The flag is TTY_HUPPING and is
cleared after TTY_HUPPED is set.

While at it, remove duplicate TTY_HUPPED set_bit. The one after
calling ops->hangup seems to be more correct. But anyway, we hold
tty_lock, so there should be no difference.

Also document the function it does that kind of crap.

Nicely reproducible with two forked children:
static void do_work(const char *tty)
{
	if (signal(SIGHUP, SIG_IGN) == SIG_ERR) exit(1);
	setsid();
	while (1) {
		int fd = open(tty, O_RDWR|O_NOCTTY);
		if (fd < 0) continue;
		if (ioctl(fd, TIOCSCTTY)) continue;
		if (vhangup()) continue;
		close(fd);
	}
	exit(0);
}

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: <Valdis.Kletnieks@vt.edu>
Reported-by: Kyle McMartin <kyle@mcmartin.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/char/tty_io.c |   10 +++++++++-
 include/linux/tty.h   |    1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

Index: linux/drivers/char/tty_io.c
===================================================================
--- linux.orig/drivers/char/tty_io.c
+++ linux/drivers/char/tty_io.c
@@ -514,7 +514,10 @@ static void do_tty_hangup(struct work_st
 	spin_unlock(&redirect_lock);
 
 	/* inuse_filps is protected by the single kernel lock */
+
 	lock_kernel();
+	/* some functions below drop BTM, so we need this bit */
+	set_bit(TTY_HUPPING, &tty->flags);
 	check_tty_count(tty, "do_tty_hangup");
 
 	file_list_lock();
@@ -530,6 +533,10 @@ static void do_tty_hangup(struct work_st
 	}
 	file_list_unlock();
 
+	/*
+	 * it drops BTM and thus races with reopen
+	 * we protect the race by TTY_HUPPING
+	 */
 	tty_ldisc_hangup(tty);
 
 	read_lock(&tasklist_lock);
@@ -567,7 +574,6 @@ static void do_tty_hangup(struct work_st
 	tty->session = NULL;
 	tty->pgrp = NULL;
 	tty->ctrl_status = 0;
-	set_bit(TTY_HUPPED, &tty->flags);
 	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 
 	/* Account for the p->signal references we killed */
@@ -593,6 +599,7 @@ static void do_tty_hangup(struct work_st
 	 * can't yet guarantee all that.
 	 */
 	set_bit(TTY_HUPPED, &tty->flags);
+	clear_bit(TTY_HUPPING, &tty->flags);
 	tty_ldisc_enable(tty);
 	unlock_kernel();
 	if (f)
@@ -1258,6 +1265,7 @@ static int tty_reopen(struct tty_struct
 	struct tty_driver *driver = tty->driver;
 
 	if (test_bit(TTY_CLOSING, &tty->flags) ||
+			test_bit(TTY_HUPPING, &tty->flags) ||
 			test_bit(TTY_LDISC_CHANGING, &tty->flags))
 		return -EIO;
 
Index: linux/include/linux/tty.h
===================================================================
--- linux.orig/include/linux/tty.h
+++ linux/include/linux/tty.h
@@ -356,6 +356,7 @@ struct tty_struct {
 #define TTY_HUPPED 		18	/* Post driver->hangup() */
 #define TTY_FLUSHING		19	/* Flushing to ldisc in progress */
 #define TTY_FLUSHPENDING	20	/* Queued buffer flush pending */
+#define TTY_HUPPING 		21	/* ->hangup() in progress */
 
 #define TTY_WRITE_FLUSH(tty) tty_write_flush((tty))
 
