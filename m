Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab1FQOwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:52:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52795 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759265Ab1FQOux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:50:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=DZhnZQw1JDndxOGiC70d7NpCJnSafQSNIDzcax5Hf9MT9u7622fF45eZDjZ9XcgrF3
         UaI84zx66wZ6x899zsV05RmOtOxiAnj93T9TqH+FmscDvfLRGRHLP5Z2pgCJUy1VAo8+
         1cUiTPYsyG3pUb4xB0+LiOm1bJRFB3qhglSpo=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, oleg@redhat.com
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        hch@infradead.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/7] ptrace: kill detah tracehooks
Date: Fri, 17 Jun 2011 16:50:39 +0200
Message-Id: <1308322240-8247-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1308322240-8247-1-git-send-email-tj@kernel.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch kills tracehook_notify_death() by reimplementing the logic
in its caller - exit_notify().  I opted for re-implementation as the
existing code was a bit difficult to wrap one's head around.

The reimplemented logic yields the same result in all combinations of
task_detached(), thread_group_empty(), ptrace_reparented() and
->ptrace.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
---
 include/linux/tracehook.h |   34 ----------------------------------
 kernel/exit.c             |   28 +++++++++++++++++++++-------
 2 files changed, 21 insertions(+), 41 deletions(-)

diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index bcc4ca7..fea0d4b 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -170,40 +170,6 @@ static inline void tracehook_signal_handler(int sig, siginfo_t *info,
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
diff --git a/kernel/exit.c b/kernel/exit.c
index d49134a..f3c49ca 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -819,8 +819,7 @@ static void forget_original_parent(struct task_struct *father)
  */
 static void exit_notify(struct task_struct *tsk, int group_dead)
 {
-	int signal;
-	void *cookie;
+	bool dead = false;
 
 	/*
 	 * This does two things:
@@ -856,11 +855,26 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	     tsk->self_exec_id != tsk->parent_exec_id))
 		tsk->exit_signal = SIGCHLD;
 
-	signal = tracehook_notify_death(tsk, &cookie, group_dead);
-	if (signal >= 0)
-		signal = do_notify_parent(tsk, signal);
+	/*
+	 * Notify interested parent if the whole group is dead.  Ptracer
+	 * should always be notified.  If something other than our normal
+	 * parent is ptracing us, then send it a SIGCHLD instead of
+	 * honoring exit_signal.  exit_signal only has special meaning to
+	 * our real parent.
+	 */
+	if (!task_detached(tsk) && thread_group_empty(tsk)) {
+		if (!ptrace_reparented(tsk))
+			do_notify_parent(tsk, tsk->exit_signal);
+		else
+			do_notify_parent(tsk, SIGCHLD);
+	} else {
+		if (unlikely(tsk->ptrace))
+			do_notify_parent(tsk, SIGCHLD);
+		else if (task_detached(tsk))
+			dead = true;
+	}
 
-	tsk->exit_state = signal == DEATH_REAP ? EXIT_DEAD : EXIT_ZOMBIE;
+	tsk->exit_state = dead ? EXIT_DEAD : EXIT_ZOMBIE;
 
 	/* mt-exec, de_thread() is waiting for group leader */
 	if (unlikely(tsk->signal->notify_count < 0))
@@ -868,7 +882,7 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 	write_unlock_irq(&tasklist_lock);
 
 	/* If the process is dead, release it - nobody will wait for it */
-	if (signal == DEATH_REAP)
+	if (dead)
 		release_task(tsk);
 }
 
-- 
1.7.5.4

