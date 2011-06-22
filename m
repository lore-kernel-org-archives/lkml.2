Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab1FVVLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:11:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758888Ab1FVVLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:11:04 -0400
Date: Wed, 22 Jun 2011 23:08:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org
Subject: [PATCH 2/8] kill tracehook_notify_death()
Message-ID: <20110622210834.GC20549@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-7-git-send-email-tj@kernel.org> <20110622210757.GA20549@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622210757.GA20549@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill tracehook_notify_death(), reimplement the logic in its caller,
exit_notify().

This also fixes a minor bug, if the exiting task is the group_leader
and it is traced by its real_parent, tracehook_notify_death() returns
task->exit_signal or SIGCHLD depending on thread_group_empty(), this
looks strange.

Also, change the exec_id check to use thread_group_leader() instead
of task_detached(), this looks more clear.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/tracehook.h |   34 ----------------------------------
 kernel/exit.c             |   19 +++++++++++--------
 2 files changed, 11 insertions(+), 42 deletions(-)

--- ptrace/include/linux/tracehook.h~2_kill_notify_death	2011-06-22 22:47:04.000000000 +0200
+++ ptrace/include/linux/tracehook.h	2011-06-22 22:47:11.000000000 +0200
@@ -152,40 +152,6 @@ static inline void tracehook_signal_hand
 		ptrace_notify(SIGTRAP);
 }
 
-#define DEATH_REAP			-1
-#define DEATH_DELAYED_GROUP_LEADER	-2
-
-/**
- * tracehook_notify_death - task is dead, ready to notify parent
- * @task:		@current task now exiting
- * @death_cookie:	value to pass to tracehook_report_death()
- * @group_dead:		nonzero if this was the last thread in the group to die
- *
- * A return value >= 0 means call do_notify_parent() with that signal
- * number.  Negative return value can be %DEATH_REAP to self-reap right
- * now, or %DEATH_DELAYED_GROUP_LEADER to a zombie without notifying our
- * parent.  Note that a return value of 0 means a do_notify_parent() call
- * that sends no signal, but still wakes up a parent blocked in wait*().
- *
- * Called with write_lock_irq(&tasklist_lock) held.
- */
-static inline int tracehook_notify_death(struct task_struct *task,
-					 void **death_cookie, int group_dead)
-{
-	if (task_detached(task))
-		return task->ptrace ? SIGCHLD : DEATH_REAP;
-
-	/*
-	 * If something other than our normal parent is ptracing us, then
-	 * send it a SIGCHLD instead of honoring exit_signal.  exit_signal
-	 * only has special meaning to our real parent.
-	 */
-	if (thread_group_empty(task) && !ptrace_reparented(task))
-		return task->exit_signal;
-
-	return task->ptrace ? SIGCHLD : DEATH_DELAYED_GROUP_LEADER;
-}
-
 #ifdef TIF_NOTIFY_RESUME
 /**
  * set_notify_resume - cause tracehook_notify_resume() to be called
--- ptrace/kernel/exit.c~2_kill_notify_death	2011-06-22 22:47:11.000000000 +0200
+++ ptrace/kernel/exit.c	2011-06-22 22:47:11.000000000 +0200
@@ -818,9 +818,7 @@ static void forget_original_parent(struc
  */
 static void exit_notify(struct task_struct *tsk, int group_dead)
 {
-	int signal;
 	bool autoreap;
-	void *cookie;
 
 	/*
 	 * This does two things:
@@ -851,16 +849,21 @@ static void exit_notify(struct task_stru
 	 * we have changed execution domain as these two values started
 	 * the same after a fork.
 	 */
-	if (tsk->exit_signal != SIGCHLD && !task_detached(tsk) &&
+	if (thread_group_leader(tsk) && tsk->exit_signal != SIGCHLD &&
 	    (tsk->parent_exec_id != tsk->real_parent->self_exec_id ||
 	     tsk->self_exec_id != tsk->parent_exec_id))
 		tsk->exit_signal = SIGCHLD;
 
-	signal = tracehook_notify_death(tsk, &cookie, group_dead);
-	if (signal >= 0)
-		autoreap = do_notify_parent(tsk, signal);
-	else
-		autoreap = (signal == DEATH_REAP);
+	if (unlikely(tsk->ptrace)) {
+		int sig = thread_group_leader(tsk) && !ptrace_reparented(tsk)
+			? tsk->exit_signal : SIGCHLD;
+		autoreap = do_notify_parent(tsk, sig);
+	} else if (thread_group_leader(tsk)) {
+		autoreap = thread_group_empty(tsk) &&
+			do_notify_parent(tsk, tsk->exit_signal);
+	} else {
+		autoreap = true;
+	}
 
 	tsk->exit_state = autoreap ? EXIT_DEAD : EXIT_ZOMBIE;
 

