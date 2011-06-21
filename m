Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab1FUU0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:26:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756679Ab1FUU0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:26:18 -0400
Date: Tue, 21 Jun 2011 22:23:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, hch@infradead.org
Subject: Re: [PATCH 6/7] ptrace: kill detah tracehooks
Message-ID: <20110621202330.GA6738@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-7-git-send-email-tj@kernel.org> <20110620193929.GA15228@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620193929.GA15228@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20, Oleg Nesterov wrote:
>
> Note! This looks very ugly, I wanted to cleanup this a long ago.
> I think we should never change ->exit_signal, and do_notify_parent()
> should return a boolean. I'll try to make the patches tomorrow.
> Then _perhaps_ this patch will become simpler.

Damn. Tomorrow (I promise ;) I'll send the full series. IMHO, we really
need to cleanup the do_notify_parent/task_detached logic, and exit_signal
should be "const"

But, to remove this tracehook, we only need the patch below and then
exit_notify() should do:

	if (unlikely(tsk->ptrace)) {
		int sig = ptrace_reparented(tsk) || task_detached(tsk) ?
					SIGCHLD : tsk->exit_signal;
		autoreap = do_notify_parent(tsk, sig);
		WARN_ON(autoreap);
	} else if (thread_group_leader(tsk)) {
		autoreap = thread_group_empty(tsk) &&
				do_notify_parent(tsk, tsk->exit_signal);
	} else {
		autoreap = true;
	}

	tsk->exit_state = autoreap ? EXIT_DEAD : EXIT_ZOMBIE;

Note the WARN_ON() above, perhaps instead we should autoreap if the
tracer is the real parent and it ignores SIGCHLD.

And. ptrace_reparented() should be changed to check same_thread_group(),
I think. This also looks fine for wait_task_zombie().

Oleg.

-----------------------------------------------------------------------------
[PATCH 3/XXX] make do_notify_parent() return bool

- change do_notify_parent() to return a boolean, true if the task should
  be reaped because its parent ignores SIGCHLD.

- update the only caller which checks the returned value, exit_notify(),
  to rely DEATH_REAP only if we do not call do_notify_parent().

  This temporary uglifies exit_notify() even more, will be cleanuped by
  the next change.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

--- ptrace/include/linux/sched.h~2_do_notify_parent_bool	2011-06-17 20:12:29.000000000 +0200
+++ ptrace/include/linux/sched.h	2011-06-21 19:18:00.000000000 +0200
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
--- ptrace/kernel/signal.c~2_do_notify_parent_bool	2011-06-20 20:40:49.000000000 +0200
+++ ptrace/kernel/signal.c	2011-06-21 20:29:57.000000000 +0200
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
--- ptrace/kernel/exit.c~2_do_notify_parent_bool	2011-06-21 18:36:24.000000000 +0200
+++ ptrace/kernel/exit.c	2011-06-21 20:37:24.000000000 +0200
@@ -821,6 +821,7 @@ static void forget_original_parent(struc
 static void exit_notify(struct task_struct *tsk, int group_dead)
 {
 	int signal;
+	bool autoreap;
 	void *cookie;
 
 	/*
@@ -859,9 +860,11 @@ static void exit_notify(struct task_stru
 
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
@@ -869,7 +872,7 @@ static void exit_notify(struct task_stru
 	write_unlock_irq(&tasklist_lock);
 
 	/* If the process is dead, release it - nobody will wait for it */
-	if (signal == DEATH_REAP)
+	if (autoreap)
 		release_task(tsk);
 }
 

