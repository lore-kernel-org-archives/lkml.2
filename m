Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab1ESGJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 02:09:11 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41996 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267Ab1ESGJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 02:09:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD4B3FA.5060901@jp.fujitsu.com>
Date: Thu, 19 May 2011 15:08:58 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: yong.zhang0@gmail.com
CC: paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, oleg@redhat.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
        lizf@cn.fujitsu.com, miaox@cn.fujitsu.com
Subject: [PATCH v2 2/2] cpuset: fix cpuset_cpus_allowed_fallback() don't update
 tsk->rt.nr_cpus_allowed
References: <20110428161149.GA15658@redhat.com> <20110502194416.2D61.A69D9226@jp.fujitsu.com> <20110502195657.2D68.A69D9226@jp.fujitsu.com> <1305129929.2914.247.camel@laptop> <4DCCC61F.80408@jp.fujitsu.com> <BANLkTik_weiOC82uRKRamFan4QMi1u3s7g@mail.gmail.com> <20110515185547.GL2258@linux.vnet.ibm.com> <20110516132623.GA2058@zhy> <4DD4B358.3080705@jp.fujitsu.com>
In-Reply-To: <4DD4B358.3080705@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rule is, we have to update tsk->rt.nr_cpus_allowed if we change
tsk->cpus_allowed. Otherwise RT scheduler may confuse.

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
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
index 12211e1..fa8fe23 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1799,9 +1799,16 @@ static inline void rcu_copy_process(struct task_struct *p)
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
index 2bb8c2e..04ceb53 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2195,7 +2195,7 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
  	rcu_read_lock();
  	cs = task_cs(tsk);
  	if (cs)
-		cpumask_copy(&tsk->cpus_allowed, cs->cpus_allowed);
+		do_set_cpus_allowed(tsk, cs->cpus_allowed);
  	rcu_read_unlock();

  	/*
@@ -2222,7 +2222,7 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
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
index 8efe3b7..52f1b5b 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5826,7 +5826,7 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
  	idle->state = TASK_RUNNING;
  	idle->se.exec_start = sched_clock();

-	cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
+	do_set_cpus_allowed(idle, cpumask_of(cpu));
  	/*
  	 * We're having a chicken and egg problem, even though we are
  	 * holding rq->lock, the cpu isn't yet set to this cpu so the
@@ -5914,6 +5914,16 @@ static inline void sched_init_granularity(void)
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
@@ -5959,12 +5969,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
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



