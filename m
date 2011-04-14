Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab1DNS2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:28:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:38044 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932959Ab1DNRqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Andi Kleen <ak@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 053/209] TTY: restore tty_ldisc_wait_idle
Date: Thu, 14 Apr 2011 13:41:23 -0400
Message-Id: <1302803039-9400-54-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/tty_ldisc.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 500e740..df5e7db 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -47,6 +47,7 @@
 
 static DEFINE_SPINLOCK(tty_ldisc_lock);
 static DECLARE_WAIT_QUEUE_HEAD(tty_ldisc_wait);
+static DECLARE_WAIT_QUEUE_HEAD(tty_ldisc_idle);
 /* Line disc dispatch table */
 static struct tty_ldisc_ops *tty_ldiscs[NR_LDISCS];
 
@@ -83,6 +84,7 @@ static void put_ldisc(struct tty_ldisc *ld)
 		return;
 	}
 	local_irq_restore(flags);
+	wake_up(&tty_ldisc_idle);
 }
 
 /**
@@ -530,6 +532,23 @@ static int tty_ldisc_halt(struct tty_struct *tty)
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
@@ -632,8 +651,17 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
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
@@ -667,6 +695,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	tty_ldisc_put(o_ldisc);
 
+enable:
 	/*
 	 *	Allow ldisc referencing to occur again
 	 */
-- 
1.7.4.4

