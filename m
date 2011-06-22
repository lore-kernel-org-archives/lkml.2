Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab1FVVKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:10:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758471Ab1FVVK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:10:29 -0400
Date: Wed, 22 Jun 2011 23:08:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org
Subject: [PATCH 1/8] make do_notify_parent() return bool
Message-ID: <20110622210818.GB20549@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-7-git-send-email-tj@kernel.org> <20110622210757.GA20549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622210757.GA20549@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- change do_notify_parent() to return a boolean, true if the task should
  be reaped because its parent ignores SIGCHLD.

- update the only caller which checks the returned value, exit_notify().

This temporary uglifies exit_notify() even more, will be cleanuped by
the next change.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    4 ++--
 kernel/signal.c       |   17 +++++++++--------
 kernel/exit.c         |    9 ++++++---
 3 files changed, 17 insertions(+), 13 deletions(-)

--- ptrace/include/linux/sched.h~1_do_notify_parent_bool	2011-06-22 22:47:05.000000000 +0200
+++ ptrace/include/linux/sched.h	2011-06-22 22:47:11.000000000 +0200
@@ -2146,7 +2146,7 @@ static inline int dequeue_signal_lock(st
 	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
 
 	return ret;
-}	
+}
 
 extern void block_all_signals(int (*notifier)(void *priv), void *priv,
 			      sigset_t *mask);
@@ -2161,7 +2161,7 @@ extern int kill_pid_info_as_uid(int, str
 extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
-extern int do_notify_parent(struct task_struct *, int);
+extern bool do_notify_parent(struct task_struct *, int);
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
--- ptrace/kernel/signal.c~1_do_notify_parent_bool	2011-06-22 22:47:05.000000000 +0200
+++ ptrace/kernel/signal.c	2011-06-22 22:47:11.000000000 +0200
@@ -1577,15 +1577,15 @@ ret:
  * Let a parent know about the death of a child.
  * For a stopped/continued status change, use do_notify_parent_cldstop instead.
  *
- * Returns -1 if our parent ignored us and so we've switched to
- * self-reaping, or else @sig.
+ * Returns true if our parent ignored us and so we've switched to
+ * self-reaping.
  */
-int do_notify_parent(struct task_struct *tsk, int sig)
+bool do_notify_parent(struct task_struct *tsk, int sig)
 {
 	struct siginfo info;
 	unsigned long flags;
 	struct sighand_struct *psig;
-	int ret = sig;
+	bool autoreap = false;
 
 	BUG_ON(sig == -1);
 
@@ -1649,16 +1649,17 @@ int do_notify_parent(struct task_struct 
 		 * is implementation-defined: we do (if you don't want
 		 * it, just use SIG_IGN instead).
 		 */
-		ret = tsk->exit_signal = -1;
+		autoreap = true;
+		tsk->exit_signal = -1;
 		if (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN)
-			sig = -1;
+			sig = 0;
 	}
-	if (valid_signal(sig) && sig > 0)
+	if (valid_signal(sig) && sig)
 		__group_send_sig_info(sig, &info, tsk->parent);
 	__wake_up_parent(tsk, tsk->parent);
 	spin_unlock_irqrestore(&psig->siglock, flags);
 
-	return ret;
+	return autoreap;
 }
 
 /**
--- ptrace/kernel/exit.c~1_do_notify_parent_bool	2011-06-22 22:47:05.000000000 +0200
+++ ptrace/kernel/exit.c	2011-06-22 22:47:11.000000000 +0200
@@ -819,6 +819,7 @@ static void forget_original_parent(struc
 static void exit_notify(struct task_struct *tsk, int group_dead)
 {
 	int signal;
+	bool autoreap;
 	void *cookie;
 
 	/*
@@ -857,9 +858,11 @@ static void exit_notify(struct task_stru
 
 	signal = tracehook_notify_death(tsk, &cookie, group_dead);
 	if (signal >= 0)
-		signal = do_notify_parent(tsk, signal);
+		autoreap = do_notify_parent(tsk, signal);
+	else
+		autoreap = (signal == DEATH_REAP);
 
-	tsk->exit_state = signal == DEATH_REAP ? EXIT_DEAD : EXIT_ZOMBIE;
+	tsk->exit_state = autoreap ? EXIT_DEAD : EXIT_ZOMBIE;
 
 	/* mt-exec, de_thread() is waiting for group leader */
 	if (unlikely(tsk->signal->notify_count < 0))
@@ -867,7 +870,7 @@ static void exit_notify(struct task_stru
 	write_unlock_irq(&tasklist_lock);
 
 	/* If the process is dead, release it - nobody will wait for it */
-	if (signal == DEATH_REAP)
+	if (autoreap)
 		release_task(tsk);
 }
 

