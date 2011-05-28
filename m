Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab1E1QgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 12:36:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:32836 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312Ab1E1QgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 12:36:16 -0400
Date: Sat, 28 May 2011 16:35:56 GMT
From: tip-bot for KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Message-ID: <tip-1e1b6c511d1b23cb7c3b619d82fc7bd9f620565d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
        kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
In-Reply-To: <4DD4B3FA.5060901@jp.fujitsu.com>
References: <4DD4B3FA.5060901@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] cpuset: Fix cpuset_cpus_allowed_fallback(), don't update tsk->rt.nr_cpus_allowed
Git-Commit-ID: 1e1b6c511d1b23cb7c3b619d82fc7bd9f620565d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 16:35:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e1b6c511d1b23cb7c3b619d82fc7bd9f620565d
Gitweb:     http://git.kernel.org/tip/1e1b6c511d1b23cb7c3b619d82fc7bd9f620565d
Author:     KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
AuthorDate: Thu, 19 May 2011 15:08:58 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 May 2011 17:02:57 +0200

cpuset: Fix cpuset_cpus_allowed_fallback(), don't update tsk->rt.nr_cpus_allowed

The rule is, we have to update tsk->rt.nr_cpus_allowed if we change
tsk->cpus_allowed. Otherwise RT scheduler may confuse.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4DD4B3FA.5060901@jp.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/cpuset.h |    2 +-
 include/linux/sched.h  |    7 +++++++
 kernel/cpuset.c        |    4 ++--
 kernel/kthread.c       |    4 ++--
 kernel/sched.c         |   19 ++++++++++++-------
 5 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index f20eb8f..e9eaec5 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -146,7 +146,7 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
 
 static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
 {
-	cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
+	do_set_cpus_allowed(p, cpu_possible_mask);
 	return cpumask_any(cpu_active_mask);
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index dc88712..8da84b7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1841,9 +1841,16 @@ static inline void rcu_copy_process(struct task_struct *p)
 #endif
 
 #ifdef CONFIG_SMP
+extern void do_set_cpus_allowed(struct task_struct *p,
+			       const struct cpumask *new_mask);
+
 extern int set_cpus_allowed_ptr(struct task_struct *p,
 				const struct cpumask *new_mask);
 #else
+static inline void do_set_cpus_allowed(struct task_struct *p,
+				      const struct cpumask *new_mask)
+{
+}
 static inline int set_cpus_allowed_ptr(struct task_struct *p,
 				       const struct cpumask *new_mask)
 {
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 1ceeb04..9c9b754 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2190,7 +2190,7 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 	rcu_read_lock();
 	cs = task_cs(tsk);
 	if (cs)
-		cpumask_copy(&tsk->cpus_allowed, cs->cpus_allowed);
+		do_set_cpus_allowed(tsk, cs->cpus_allowed);
 	rcu_read_unlock();
 
 	/*
@@ -2217,7 +2217,7 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 		 * Like above we can temporary set any mask and rely on
 		 * set_cpus_allowed_ptr() as synchronization point.
 		 */
-		cpumask_copy(&tsk->cpus_allowed, cpu_possible_mask);
+		do_set_cpus_allowed(tsk, cpu_possible_mask);
 		cpu = cpumask_any(cpu_active_mask);
 	}
 
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 3b34d27..4ba7ccc 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -202,8 +202,8 @@ void kthread_bind(struct task_struct *p, unsigned int cpu)
 		return;
 	}
 
-	p->cpus_allowed = cpumask_of_cpu(cpu);
-	p->rt.nr_cpus_allowed = 1;
+	/* It's safe because the task is inactive. */
+	do_set_cpus_allowed(p, cpumask_of(cpu));
 	p->flags |= PF_THREAD_BOUND;
 }
 EXPORT_SYMBOL(kthread_bind);
diff --git a/kernel/sched.c b/kernel/sched.c
index a80ee91..cbb3a0e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5860,7 +5860,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	idle->state = TASK_RUNNING;
 	idle->se.exec_start = sched_clock();
 
-	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
+	do_set_cpus_allowed(idle, cpumask_of(cpu));
 	/*
 	 * We're having a chicken and egg problem, even though we are
 	 * holding rq->lock, the cpu isn't yet set to this cpu so the
@@ -5948,6 +5948,16 @@ static inline void sched_init_granularity(void)
 }
 
 #ifdef CONFIG_SMP
+void do_set_cpus_allowed(struct task_struct *p, const struct cpumask *new_mask)
+{
+	if (p->sched_class && p->sched_class->set_cpus_allowed)
+		p->sched_class->set_cpus_allowed(p, new_mask);
+	else {
+		cpumask_copy(&p->cpus_allowed, new_mask);
+		p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
+	}
+}
+
 /*
  * This is how migration works:
  *
@@ -5993,12 +6003,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 		goto out;
 	}
 
-	if (p->sched_class->set_cpus_allowed)
-		p->sched_class->set_cpus_allowed(p, new_mask);
-	else {
-		cpumask_copy(&p->cpus_allowed, new_mask);
-		p->rt.nr_cpus_allowed = cpumask_weight(new_mask);
-	}
+	do_set_cpus_allowed(p, new_mask);
 
 	/* Can the task run on the task's current CPU? If so, we're done */
 	if (cpumask_test_cpu(task_cpu(p), new_mask))
