Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab1DRNrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:47:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab1DRNrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:47:14 -0400
Date: Mon, 18 Apr 2011 15:45:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] signal: sigprocmask() should do
	retarget_shared_pending()
Message-ID: <20110418134557.GF15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418134421.GA15951@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In short, almost every changing of current->blocked is wrong, or at least
can lead to the unexpected results.

For example. Two threads T1 and T2, T1 sleeps in sigtimedwait/pause/etc.
kill(tgid, SIG) can pick T2 for TIF_SIGPENDING. If T2 calls sigprocmask()
and blocks SIG before it notices the pending signal, nobody else can handle
this pending shared signal.

I am not sure this is bug, but at least this looks strange imho. T1 should
not sleep forever, there is a signal which should wake it up.

This patch moves the code which actually changes ->blocked into the new
helper, set_current_blocked() and changes this code to call
retarget_shared_pending() as exit_signals() does. We should only care about
the signals we just blocked, we use "newset & ~current->blocked" as a mask.

We do not check !sigisemptyset(newblocked), retarget_shared_pending() is
cheap unless mask & shared_pending.

Note: for this particular case we could simply change sigprocmask() to
return -EINTR if signal_pending(), but then we should change other callers
and, more importantly, if we need this fix then set_current_blocked() will
have more callers and some of them can't restart. See the next patch as a
random example.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/signal.h |    1 +
 kernel/signal.c        |   21 ++++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

--- sigprocmask/include/linux/signal.h~5_sigprocmask_retarget	2011-04-17 22:23:29.000000000 +0200
+++ sigprocmask/include/linux/signal.h	2011-04-17 22:36:41.000000000 +0200
@@ -243,6 +243,7 @@ extern long do_rt_tgsigqueueinfo(pid_t t
 				 siginfo_t *info);
 extern long do_sigpending(void __user *, unsigned long);
 extern int sigprocmask(int, sigset_t *, sigset_t *);
+extern void set_current_blocked(const sigset_t *);
 extern int show_unhandled_signals;
 
 struct pt_regs;
--- sigprocmask/kernel/signal.c~5_sigprocmask_retarget	2011-04-17 22:16:44.000000000 +0200
+++ sigprocmask/kernel/signal.c	2011-04-17 22:32:58.000000000 +0200
@@ -2115,6 +2115,21 @@ long do_no_restart_syscall(struct restar
 	return -EINTR;
 }
 
+void set_current_blocked(const sigset_t *newset)
+{
+	struct task_struct *tsk = current;
+
+	spin_lock_irq(&tsk->sighand->siglock);
+	if (signal_pending(tsk) && !thread_group_empty(tsk)) {
+		sigset_t newblocked;
+		signandsets(&newblocked, newset, &current->blocked);
+		retarget_shared_pending(tsk, &newblocked);
+	}
+	tsk->blocked = *newset;
+	recalc_sigpending();
+	spin_unlock_irq(&tsk->sighand->siglock);
+}
+
 /*
  * This is also useful for kernel threads that want to temporarily
  * (or permanently) block certain signals.
@@ -2146,11 +2161,7 @@ int sigprocmask(int how, sigset_t *set, 
 		return -EINVAL;
 	}
 
-	spin_lock_irq(&tsk->sighand->siglock);
-	tsk->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&tsk->sighand->siglock);
-
+	set_current_blocked(&newset);
 	return 0;
 }
 

