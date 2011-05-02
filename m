Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab1EBK4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 06:56:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45484 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476Ab1EBK4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 06:56:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 2/2] sched, cpuset: introduce do_set_cpus_allowed() helper function
Cc: kosaki.motohiro@jp.fujitsu.com, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>
In-Reply-To: <20110502194416.2D61.A69D9226@jp.fujitsu.com>
References: <20110428161149.GA15658@redhat.com> <20110502194416.2D61.A69D9226@jp.fujitsu.com>
Message-Id: <20110502195736.2D6C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Mon,  2 May 2011 19:56:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we have five task->cpus_allowed writer.

1) sched_rt.c: set_cpus_allowed_rt()
2) sched.c: set_cpus_allowed_ptr()
3) sched.c: init_idle()
4) kthread.c kthread_bind()
5) cpuset.c: cpuset_cpus_allowed_fallback()

And, now (3), (4), (5) don't check p->sched_class->set_cpus_allowed.
It's ok, We have a implicit gurantee that it's safe. However they
theorically slightly bad habit. If any scheduler class will add to
implement ->set_cpus_allowed in future, they may not work.

Then, it would be nice to make good helper function and cleanup.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/cpuset.h |    3 +--
 include/linux/sched.h  |    7 +++++++
 kernel/cpuset.c        |    5 ++---
 kernel/kthread.c       |    4 ++--
 kernel/sched.c         |   19 ++++++++++++-------
 5 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 42dcbdc..e9eaec5 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -146,8 +146,7 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
 
 static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
 {
-	cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
-	p->rt.nr_cpus_allowed = cpumask_weight(&p->cpus_allowed);
+	do_set_cpus_allowed(p, cpu_possible_mask);
 	return cpumask_any(cpu_active_mask);
 }
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3f7d3f9..fc7964d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1823,9 +1823,16 @@ static inline void rcu_copy_process(struct task_struct *p)
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
index 6e5bbe8..9c9b754 100644
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
@@ -2217,10 +2217,9 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 		 * Like above we can temporary set any mask and rely on
 		 * set_cpus_allowed_ptr() as synchronization point.
 		 */
-		cpumask_copy(&tsk->cpus_allowed, cpu_possible_mask);
+		do_set_cpus_allowed(tsk, cpu_possible_mask);
 		cpu = cpumask_any(cpu_active_mask);
 	}
-	tsk->rt.nr_cpus_allowed = cpumask_weight(&tsk->cpus_allowed);
 
 	return cpu;
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
index bfcd219..7867e47 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5819,7 +5819,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	idle->state = TASK_RUNNING;
 	idle->se.exec_start = sched_clock();
 
-	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
+	do_set_cpus_allowed(idle, cpumask_of(cpu));
 	/*
 	 * We're having a chicken and egg problem, even though we are
 	 * holding rq->lock, the cpu isn't yet set to this cpu so the
@@ -5910,6 +5910,16 @@ static inline void sched_init_granularity(void)
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
@@ -5953,12 +5963,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
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
-- 
1.7.3.1



