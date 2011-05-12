Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab1ELNE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:04:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:48795 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab1ELNEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:04:55 -0400
Date: Thu, 12 May 2011 13:04:11 GMT
From: tip-bot for Samir Bellabes <sam@synack.fr>
Message-ID: <tip-3e51e3edfd81bfd9853ad7de91167e4ce33d0fe7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, sam@synack.fr, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, sam@synack.fr, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1305130685-1047-1-git-send-email-sam@synack.fr>
References: <1305130685-1047-1-git-send-email-sam@synack.fr>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove unused parameters from sched_fork() and wake_up_new_task()
Git-Commit-ID: 3e51e3edfd81bfd9853ad7de91167e4ce33d0fe7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 12 May 2011 13:04:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3e51e3edfd81bfd9853ad7de91167e4ce33d0fe7
Gitweb:     http://git.kernel.org/tip/3e51e3edfd81bfd9853ad7de91167e4ce33d0fe7
Author:     Samir Bellabes <sam@synack.fr>
AuthorDate: Wed, 11 May 2011 18:18:05 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 May 2011 09:36:37 +0200

sched: Remove unused parameters from sched_fork() and wake_up_new_task()

sched_fork() and wake_up_new_task() are defined with a parameter
'unsigned long clone_flags', which is unused.

This patch removes the parameters.

Signed-off-by: Samir Bellabes <sam@synack.fr>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1305130685-1047-1-git-send-email-sam@synack.fr
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    5 ++---
 kernel/fork.c         |    4 ++--
 kernel/sched.c        |    4 ++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6b4280b..12211e1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2051,14 +2051,13 @@ extern void xtime_update(unsigned long ticks);
 
 extern int wake_up_state(struct task_struct *tsk, unsigned int state);
 extern int wake_up_process(struct task_struct *tsk);
-extern void wake_up_new_task(struct task_struct *tsk,
-				unsigned long clone_flags);
+extern void wake_up_new_task(struct task_struct *tsk);
 #ifdef CONFIG_SMP
  extern void kick_process(struct task_struct *tsk);
 #else
  static inline void kick_process(struct task_struct *tsk) { }
 #endif
-extern void sched_fork(struct task_struct *p, int clone_flags);
+extern void sched_fork(struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
 extern void proc_caches_init(void);
diff --git a/kernel/fork.c b/kernel/fork.c
index aca6287..2b44d82 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1152,7 +1152,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
-	sched_fork(p, clone_flags);
+	sched_fork(p);
 
 	retval = perf_event_init_task(p);
 	if (retval)
@@ -1463,7 +1463,7 @@ long do_fork(unsigned long clone_flags,
 		 */
 		p->flags &= ~PF_STARTING;
 
-		wake_up_new_task(p, clone_flags);
+		wake_up_new_task(p);
 
 		tracehook_report_clone_complete(trace, regs,
 						clone_flags, nr, p);
diff --git a/kernel/sched.c b/kernel/sched.c
index da93381..f9778c0 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2741,7 +2741,7 @@ static void __sched_fork(struct task_struct *p)
 /*
  * fork()/clone()-time setup:
  */
-void sched_fork(struct task_struct *p, int clone_flags)
+void sched_fork(struct task_struct *p)
 {
 	unsigned long flags;
 	int cpu = get_cpu();
@@ -2823,7 +2823,7 @@ void sched_fork(struct task_struct *p, int clone_flags)
  * that must be done for every newly created context, then puts the task
  * on the runqueue and wakes it.
  */
-void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
+void wake_up_new_task(struct task_struct *p)
 {
 	unsigned long flags;
 	struct rq *rq;
