Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0EaJRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 05:17:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60047 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab0EaJRY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 05:17:24 -0400
Subject: Re: [patch 0/7] sched: change nohz idle load balancing logic to
 push model
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.jf.intel.com>,
       Venkatesh Pallipadi <venki@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       "ego@in.ibm.com" <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       David Miller <davem@davemloft.net>, Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <1274486981.2840.46.camel@sbs-t61.sc.intel.com>
References: <20100517182726.089700767@sbs-t61.sc.intel.com>
	 <1274352621.5605.14017.camel@twins>
	 <1274486981.2840.46.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 31 May 2010 11:17:12 +0200
Message-ID: <1275297432.27810.21691.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 17:09 -0700, Suresh Siddha wrote:

> From: Venkatesh Pallipadi <venki@google.com>
> Subject: sched: Change nohz ilb logic from pull to push model
> 
> In the new push model, all idle CPUs indeed go into nohz mode. There is
> still the concept of idle load balancer (performing the load balancing
> on behalf of all the idle cpu's in the system). Busy CPU kicks the nohz
> balancer when any of the nohz CPUs need idle load balancing.
> The kickee CPU does the idle load balancing on behalf of all idle CPUs
> instead of the normal idle balance.
> 
> This addresses the below two problems with the current nohz ilb logic:
> * the idle load balancer continued to have periodic ticks during idle and
>   wokeup frequently, even though it did not have any rebalancing to do on
>   behalf of any of the idle CPUs.
> * On x86 and CPUs that have APIC timer stoppage on idle CPUs, this
>   periodic wakeup can result in a periodic additional interrupt on a CPU
>   doing the timer broadcast.
> 
> Also currently we are migrating the unpinned timers from an idle to the cpu
> doing idle load balancing (when all the cpus in the system are idle,
> there is no idle load balancing cpu and timers get added to the same idle cpu
> where the request was made. So the existing optimization works only on semi idle
> system).
> 
> And In semi idle system, we no longer have periodic ticks on the idle load
> balancer CPU. Using that cpu will add more delays to the timers than intended
> (as that cpu's timer base may not be uptodate wrt jiffies etc). This was
> causing mysterious slowdowns during boot etc.
> 
> For now, in the semi idle case, use the nearest busy cpu for migrating timers
> from an idle cpu.  This is good for power-savings anyway.
> 
> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---

I sorted the conflict with Venki's update_cpu_load() patch as below.

Thanks!

---
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -3446,6 +3446,9 @@ static void nohz_idle_balance(int this_c
 			break;
 		}
 
+		raw_spin_lock_irq(&rq->lock);
+		update_cpu_load(rq);
+		raw_spin_unlock_irq(&rq->lock);
 		rebalance_domains(balance_cpu, CPU_IDLE);
 
 		rq = cpu_rq(balance_cpu);
@@ -3518,40 +3521,12 @@ static void run_rebalance_domains(struct
 
 	rebalance_domains(this_cpu, idle);
 
-#ifdef CONFIG_NO_HZ
 	/*
-	 * If this cpu is the owner for idle load balancing, then do the
+	 * If this cpu has a pending nohz_balance_kick, then do the
 	 * balancing on behalf of the other idle cpus whose ticks are
 	 * stopped.
 	 */
-	if (this_rq->idle_at_tick &&
-	    atomic_read(&nohz.load_balancer) == this_cpu) {
-		struct rq *rq;
-		int balance_cpu;
-
-		for_each_cpu(balance_cpu, nohz.cpu_mask) {
-			if (balance_cpu == this_cpu)
-				continue;
-
-			/*
-			 * If this cpu gets work to do, stop the load balancing
-			 * work being done for other cpus. Next load
-			 * balancing owner will pick it up.
-			 */
-			if (need_resched())
-				break;
-
-			rq = cpu_rq(balance_cpu);
-			raw_spin_lock_irq(&rq->lock);
-			update_cpu_load(rq);
-			raw_spin_unlock_irq(&rq->lock);
-			rebalance_domains(balance_cpu, CPU_IDLE);
-
-			if (time_after(this_rq->next_balance, rq->next_balance))
-				this_rq->next_balance = rq->next_balance;
-		}
-	}
-#endif
+	nohz_idle_balance(this_cpu, idle);
 }
 
 static inline int on_null_domain(int cpu)

