Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab1ESGG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 02:06:28 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50368 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab1ESGG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 02:06:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD4B358.3080705@jp.fujitsu.com>
Date: Thu, 19 May 2011 15:06:16 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: yong.zhang0@gmail.com
CC: paulmck@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, oleg@redhat.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
        lizf@cn.fujitsu.com, miaox@cn.fujitsu.com
Subject: [PATCH v2 1/2] rcu: don't bind offline cpu
References: <20110428161149.GA15658@redhat.com> <20110502194416.2D61.A69D9226@jp.fujitsu.com> <20110502195657.2D68.A69D9226@jp.fujitsu.com> <1305129929.2914.247.camel@laptop> <4DCCC61F.80408@jp.fujitsu.com> <BANLkTik_weiOC82uRKRamFan4QMi1u3s7g@mail.gmail.com> <20110515185547.GL2258@linux.vnet.ibm.com> <20110516132623.GA2058@zhy>
In-Reply-To: <20110516132623.GA2058@zhy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I've made new patch. Is this acceptable to you?


==============================================================
While discussing cpuset_cpus_allowed_fallback() fix, we've found
rcu subsystem don't use kthread_bind() correctly.

The detail is, typical subsystem wake up a kthread at CPU_ONLINE
notifier (ie. _after_ cpu is onlined), but rcu subsystem wake up
a kthread at CPU_UP_PREPARE notifier (ie. _before_ cpu is onlined).
Because otherwise RCU grace periods in CPU_ONLINE notifiers will
never complete.

This makes big different result. if we fix cpuset_cpus_allowed_fallback(),
sched load balancer run before scheduler smp initialize and makes
kernel crash. (see below)

   kernel_init();
     smp_init();
       _cpu_up();
         __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
           rcu_cpu_notify();
             rcu_online_kthreads();
               rcu_spawn_one_node_kthread();
                 wake_up_process();
                   try_to_wake_up();
                     select_task_rq();
                       select_fallback_rq();
                         cpuset_cpus_allowed_fallback();
                           /* here the rcu_thread's cpus_allowed will
			   * be set to cpu_possible_mask, but now
			   * we only have the boot cpu online, so it
			   * will run on the boot cpu p->rt.nr_cpus_allowed
			   * will be set to cpumask_weight(cpu_possible_mask);
			   */
               sched_setscheduler_nocheck(t, SCHED_FIFO, &sp);
                 __sched_setscheduler();
                   check_class_changed();
                     p->sched_class->switched_to(rq, p); /* rt_class */
                       push_rt_task();
                         find_lock_lowest_rq();
                           find_lowest_rq();
			   /* crash here because local_cpu_mask is uninitialized */

The right way is, explicit two phase cpu bindings (1) bind boot
(or any other online) cpu at CPU_UP_PREPARE (2) bind correct
target cpu at CPU_ONLINE. This patch does it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
  kernel/rcutree.c |   11 +++++++++--
  1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5616b17..924b0cd 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1645,6 +1645,7 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
  {
  	struct sched_param sp;
  	struct task_struct *t;
+	int bound_cpu;

  	if (!rcu_kthreads_spawnable ||
  	    per_cpu(rcu_cpu_kthread_task, cpu) != NULL)
@@ -1652,8 +1653,14 @@ static int __cpuinit rcu_spawn_one_cpu_kthread(int cpu)
  	t = kthread_create(rcu_cpu_kthread, (void *)(long)cpu, "rcuc%d", cpu);
  	if (IS_ERR(t))
  		return PTR_ERR(t);
-	kthread_bind(t, cpu);
-	per_cpu(rcu_cpu_kthread_cpu, cpu) = cpu;
+	/*
+	 * The target cpu isn't online yet and can't be bound the rcuc kthread.
+	 * Thus we bind it to another online cpu temporary.
+	 * rcu_cpu_kthread_should_stop() rebind it to target cpu later.
+	 */
+	bound_cpu = cpumask_any(cpu_online_mask);
+	kthread_bind(t, bound_cpu);
+	per_cpu(rcu_cpu_kthread_cpu, cpu) = bound_cpu;
  	WARN_ON_ONCE(per_cpu(rcu_cpu_kthread_task, cpu) != NULL);
  	per_cpu(rcu_cpu_kthread_task, cpu) = t;
  	wake_up_process(t);
-- 
1.7.3.1



