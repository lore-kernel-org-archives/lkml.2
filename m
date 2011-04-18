Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab1DRNq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:46:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390Ab1DRNqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:46:22 -0400
Date: Mon, 18 Apr 2011 15:45:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/7] signal: sigprocmask: narrow the scope of ->siglock
Message-ID: <20110418134538.GE15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418134421.GA15951@redhat.com>
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

 kernel/signal.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- sigprocmask/kernel/signal.c~4_cleanup_sigprocmask	2011-04-17 21:28:21.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-04-17 22:16:44.000000000 +0200
@@ -2116,12 +2116,6 @@ long do_no_restart_syscall(struct restar
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
@@ -2131,30 +2125,33 @@ long do_no_restart_syscall(struct restar
  */
 int sigprocmask(int how, sigset_t *set, sigset_t *oldset)
 {
-	int error;
+	struct task_struct *tsk = current;
+	sigset_t newset;
 
-	spin_lock_irq(&current->sighand->siglock);
+	/* Lockless, only current can change ->blocked, never from irq */
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

