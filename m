Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab1JTRT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 13:19:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:7911 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829Ab1JTRT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 13:19:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="65163853"
Subject: Re: [Patch] Idle balancer: cache align nohz structure to improve
 idle load balancing scalability
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venki Pallipadi <venki@google.com>
In-Reply-To: <1319084319.8416.38.camel@edumazet-laptop>
References: <1319060737.2604.38.camel@schen9-DESK>
	 <1319084319.8416.38.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 10:19:13 -0700
Message-ID: <1319131153.2604.40.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-20 at 06:18 +0200, Eric Dumazet wrote:

> Dont you increase cache footprint, say for an Uniprocessor machine ?
> 
> (CONFIG_SMP=n)
> 
> ____cacheline_aligned_in_smp seems more suitable in this case.
> 
> 
> 
Okay, using the smp version of the cache align in this updated patch.

Thanks.

------------

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

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index bc8ee99..4ae4b7d 100644
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
+	atomic_t load_balancer ____cacheline_aligned_in_smp;
+	atomic_t first_pick_cpu ____cacheline_aligned_in_smp;
+	atomic_t second_pick_cpu ____cacheline_aligned_in_smp;
+	cpumask_var_t idle_cpus_mask ____cacheline_aligned_in_smp;
 	cpumask_var_t grp_idle_mask;
 	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned;


