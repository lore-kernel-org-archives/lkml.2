Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab0LMANt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:13:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36079 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab0LLXqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:35 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: jslaby@suse.cz, torvalds@linux-foundation.org, bigeasy@breakpoint.cc,
        ak@linux.intel.com, alan@linux.intel.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [94/223] TTY: restore tty_ldisc_wait_idle
Message-Id: <20101212234634.268C4B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jiri Slaby <jslaby@suse.cz>

commit 100eeae2c5ce23b4db93ff320ee330ef1d740151 upstream.

It was removed in 65b770468e98 (tty-ldisc: turn ldisc user count into
a proper refcount), but we need to wait for last user to quit the
ldisc before we close it in tty_set_ldisc.

Otherwise weird things start to happen. There might be processes
waiting in tty_read->n_tty_read on tty->read_wait for input to appear
and at that moment, a change of ldisc is fatal. n_tty_close is called,
it frees read_buf and the waiting process is still in the middle of
reading and goes nuts after it is woken.

Previously we prevented close to happen when others are in ldisc ops
by tty_ldisc_wait_idle in tty_set_ldisc. But the commit above removed
that. So revoke the change and test whether there is 1 user (=we), and
allow the close then.

We can do that without ldisc/tty locks, because nobody else can open
the device due to TTY_LDISC_CHANGING bit set, so we in fact wait for
everybody to leave.

I don't understand why tty_ldisc_lock would be needed either when the
counter is an atomic variable, so this is a lockless
tty_ldisc_wait_idle.

On the other hand, if we fail to wait (timeout or signal), we have to
reenable the halted ldiscs, so we take ldisc lock and reuse the setup
path at the end of tty_set_ldisc.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: Sebastian Andrzej Siewior <bigeasy@breakpoint.cc>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20101031104136.GA511@Chamillionaire.breakpoint.cc>
LKML-Reference: <1287669539-22644-1-git-send-email-jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_ldisc.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

Index: linux/drivers/char/tty_ldisc.c
===================================================================
--- linux.orig/drivers/char/tty_ldisc.c
+++ linux/drivers/char/tty_ldisc.c
@@ -47,6 +47,7 @@
 
 static DEFINE_SPINLOCK(tty_ldisc_lock);
 static DECLARE_WAIT_QUEUE_HEAD(tty_ldisc_wait);
+static DECLARE_WAIT_QUEUE_HEAD(tty_ldisc_idle);
 /* Line disc dispatch table */
 static struct tty_ldisc_ops *tty_ldiscs[NR_LDISCS];
 
@@ -83,6 +84,7 @@ static void put_ldisc(struct tty_ldisc *
 		return;
 	}
 	local_irq_restore(flags);
+	wake_up(&tty_ldisc_idle);
 }
 
 /**
@@ -530,6 +532,23 @@ static int tty_ldisc_halt(struct tty_str
 }
 
 /**
+ *	tty_ldisc_wait_idle	-	wait for the ldisc to become idle
+ *	@tty: tty to wait for
+ *
+ *	Wait for the line discipline to become idle. The discipline must
+ *	have been halted for this to guarantee it remains idle.
+ */
+static int tty_ldisc_wait_idle(struct tty_struct *tty)
+{
+	int ret;
+	ret = wait_event_interruptible_timeout(tty_ldisc_idle,
+			atomic_read(&tty->ldisc->users) == 1, 5 * HZ);
+	if (ret < 0)
+		return ret;
+	return ret > 0 ? 0 : -EBUSY;
+}
+
+/**
  *	tty_set_ldisc		-	set line discipline
  *	@tty: the terminal to set
  *	@ldisc: the line discipline
@@ -632,8 +651,17 @@ int tty_set_ldisc(struct tty_struct *tty
 
 	flush_scheduled_work();
 
+	retval = tty_ldisc_wait_idle(tty);
+
 	mutex_lock(&tty->ldisc_mutex);
 	lock_kernel();
+
+	/* handle wait idle failure locked */
+	if (retval) {
+		tty_ldisc_put(new_ldisc);
+		goto enable;
+	}
+
 	if (test_bit(TTY_HUPPED, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
 		   the ldisc data and closed the ldisc down */
@@ -667,6 +695,7 @@ int tty_set_ldisc(struct tty_struct *tty
 
 	tty_ldisc_put(o_ldisc);
 
+enable:
 	/*
 	 *	Allow ldisc referencing to occur again
 	 */
