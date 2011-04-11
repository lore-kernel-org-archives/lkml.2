Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1DKRWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:22:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab1DKRWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:22:15 -0400
Date: Mon, 11 Apr 2011 19:21:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] signal: sigprocmask: narrow the scope of ->sigloc
Message-ID: <20110411172109.GD32469@redhat.com>
References: <20110411171957.GA32469@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110411171957.GA32469@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes, preparation to simplify the review of the next change.

1. We can read current->block lockless, nobody else can ever change this mask.

2. Calculate the resulting sigset_t outside of ->siglock into the temporary
   variable, then take ->siglock and change ->blocked.

Also, kill the stale comment about BKL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

--- sigprocmask/kernel/signal.c~3_cleanup_sigprocmask	2011-04-10 21:54:24.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-04-10 21:57:42.000000000 +0200
@@ -2101,12 +2101,6 @@ long do_no_restart_syscall(struct restar
 }
 
 /*
- * We don't need to get the kernel lock - this is all local to this
- * particular thread.. (and that's good, because this is _heavily_
- * used by various programs)
- */
-
-/*
  * This is also useful for kernel threads that want to temporarily
  * (or permanently) block certain signals.
  *
@@ -2116,30 +2110,32 @@ long do_no_restart_syscall(struct restar
  */
 int sigprocmask(int how, sigset_t *set, sigset_t *oldset)
 {
-	int error;
+	struct task_struct *tsk = current;
+	sigset_t newset;
 
-	spin_lock_irq(&current->sighand->siglock);
 	if (oldset)
-		*oldset = current->blocked;
+		*oldset = tsk->blocked;
 
-	error = 0;
 	switch (how) {
 	case SIG_BLOCK:
-		sigorsets(&current->blocked, &current->blocked, set);
+		sigorsets(&newset, &tsk->blocked, set);
 		break;
 	case SIG_UNBLOCK:
-		signandsets(&current->blocked, &current->blocked, set);
+		signandsets(&newset, &tsk->blocked, set);
 		break;
 	case SIG_SETMASK:
-		current->blocked = *set;
+		newset = *set;
 		break;
 	default:
-		error = -EINVAL;
+		return -EINVAL;
 	}
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	tsk->blocked = newset;
 	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	spin_unlock_irq(&tsk->sighand->siglock);
 
-	return error;
+	return 0;
 }
 
 /**

