Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab0CSSmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 14:42:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab0CSSmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 14:42:31 -0400
Date: Fri, 19 Mar 2010 19:40:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] kill the awful task_rq_unlock_wait() hack
Message-ID: <20100319184023.GA522@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that task->signal can't go away we can revert the horrible hack
added by ad474caca3e2a0550b7ce0706527ad5ab389a4d4.

And we can do more cleanups sched_stats.h/posix-cpu-timers.c later.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    1 -
 kernel/sched.c        |    8 --------
 kernel/exit.c         |    5 -----
 3 files changed, 14 deletions(-)

--- 34-rc1/include/linux/sched.h~10_KILL_RQ_UNLOCK_WAIT	2010-03-19 17:32:44.000000000 +0100
+++ 34-rc1/include/linux/sched.h	2010-03-19 19:17:17.000000000 +0100
@@ -265,7 +265,6 @@ extern void init_idle(struct task_struct
 extern void init_idle_bootup_task(struct task_struct *idle);
 
 extern int runqueue_is_locked(int cpu);
-extern void task_rq_unlock_wait(struct task_struct *p);
 
 extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
--- 34-rc1/kernel/sched.c~10_KILL_RQ_UNLOCK_WAIT	2010-03-15 09:42:08.000000000 +0100
+++ 34-rc1/kernel/sched.c	2010-03-19 19:18:22.000000000 +0100
@@ -957,14 +957,6 @@ static struct rq *task_rq_lock(struct ta
 	}
 }
 
-void task_rq_unlock_wait(struct task_struct *p)
-{
-	struct rq *rq = task_rq(p);
-
-	smp_mb(); /* spin-unlock-wait is not a full memory barrier */
-	raw_spin_unlock_wait(&rq->lock);
-}
-
 static void __task_rq_unlock(struct rq *rq)
 	__releases(rq->lock)
 {
--- 34-rc1/kernel/exit.c~10_KILL_RQ_UNLOCK_WAIT	2010-03-19 18:55:02.000000000 +0100
+++ 34-rc1/kernel/exit.c	2010-03-19 19:17:53.000000000 +0100
@@ -146,11 +146,6 @@ static void __exit_signal(struct task_st
 	if (sig) {
 		flush_sigqueue(&sig->shared_pending);
 		taskstats_tgid_free(sig);
-		/*
-		 * Make sure ->signal can't go away under rq->lock,
-		 * see account_group_exec_runtime().
-		 */
-		task_rq_unlock_wait(tsk);
 		tty_kref_put(tty);
 	}
 }

