Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab1JSVpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 17:45:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:9459 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab1JSVpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 17:45:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="64883074"
Subject: [Patch] Idle balancer: cache align nohz structure to improve idle
 load balancing scalability
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venki Pallipadi <venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Oct 2011 14:45:37 -0700
Message-ID: <1319060737.2604.38.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Idle load balancing makes use of a global structure nohz to keep track
of the cpu doing the idle load balancing, first and second busy cpu and
the cpus that are idle.  This leads to scalability issue.

For workload that has processes waking up and going to sleep often, the 
load_balancer, first_pick_cpu, second_cpu and idle_cpus_mask in the
no_hz structure get updated very frequently. This causes lots of cache
bouncing and slowing down the idle and wakeup path for large system with
many cores/sockets.  This is evident from up to 41% of cpu cycles spent
in the function select_nohz_load_balancer from a test work load I ran.
By putting these fields in their own cache line, the problem can be
mitigated.

The test workload has multiple pairs of processes. Within a process
pair, each process receive and then send message back and forth to the
other process via a pipe connecting them. So at any one time, half the
processes are active.

I found that for 32 pairs of processes, I got an increase of the rate of
context switching between the processes by 37% and by 24% for 64 process
pairs. The test was run on a 8 socket 64 cores NHM-EX system, where
hyper-threading has been turned on.

Tim

Workload cpu cycle profile on vanilla kernel:
41.19%          swapper  [kernel.kallsyms]          [k] select_nohz_load_balancer   
   - select_nohz_load_balancer                                                       
      + 54.91% tick_nohz_restart_sched_tick                                         
      + 45.04% tick_nohz_stop_sched_tick     
18.96%          swapper  [kernel.kallsyms]          [k] mwait_idle_with_hints        
 3.50%          swapper  [kernel.kallsyms]          [k] tick_nohz_restart_sched_tick 
 3.36%          swapper  [kernel.kallsyms]          [k] tick_check_idle              
 2.96%          swapper  [kernel.kallsyms]          [k] rcu_enter_nohz               
 2.40%          swapper  [kernel.kallsyms]          [k] _raw_spin_lock               
 2.11%          swapper  [kernel.kallsyms]          [k] tick_nohz_stop_sched_tick    


Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index bc8ee99..26ea877 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3639,10 +3639,10 @@ static inline void init_sched_softirq_csd(struct call_single_data *csd)
  *   load balancing for all the idle CPUs.
  */
 static struct {
-	atomic_t load_balancer;
-	atomic_t first_pick_cpu;
-	atomic_t second_pick_cpu;
-	cpumask_var_t idle_cpus_mask;
+	atomic_t load_balancer ____cacheline_aligned;
+	atomic_t first_pick_cpu ____cacheline_aligned;
+	atomic_t second_pick_cpu ____cacheline_aligned;
+	cpumask_var_t idle_cpus_mask ____cacheline_aligned;
 	cpumask_var_t grp_idle_mask;
 	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned;











