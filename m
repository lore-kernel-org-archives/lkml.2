Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab0JTTZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:25:09 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50294 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028Ab0JTTZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:25:07 -0400
Date: Wed, 20 Oct 2010 12:25:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] rcu,cleanup: simplify the code when cpu is dying
Message-ID: <20101020192503.GH2386@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4CBE8872.1010905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBE8872.1010905@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 02:13:06PM +0800, Lai Jiangshan wrote:
> When we handle cpu notify DYING, the whole system is stopped except
> current CPU, so we can touch any data, and we remove the orphan_cbs_tail
> and send the callbacks to the dest CPU directly.

Queued along with the documentation/comment patch below, thank you!!!
(Of course, please let me know if you see problems with my patch.)

One remaining question...  You use cpumask_any() to select the destination
CPU, which sounds good until you look at its definition.  The problem
is that cpumask_any() always chooses the lowest-numbered online CPU.
So imagine a (say) 64-CPU system and suppose that CPU 0 remains online.
Suppose further that the other 63 CPUs each execute some workload that
generates lots of RCU callbacks (perhaps creating then removing a large
source tree), and periodically go offline and come back online.

All of the RCU callbacks from CPUs 1-63 could easily end up getting
dumped onto CPU 0's callback lists.  It is easy to imagine that CPU 0
might not be able to invoke these callbacks as fast as the other CPUs
could generate them.

Or am I missing something?

If I am not missing something, could you please adjust so that the
adopting CPU varies, perhaps by scanning across the CPUs?  Feel free
to update this patch or to send a separate patch, whichever is easiest
for you.

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  rcutree.c        |   81 ++++++++++++++-----------------------------------------
>  rcutree.h        |   16 ++--------
>  rcutree_plugin.h |    8 ++---
>  rcutree_trace.c  |    4 +-
>  4 files changed, 31 insertions(+), 78 deletions(-)
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index ccdc04c..669d7fe 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -67,9 +67,6 @@ static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
>  	.gpnum = -300, \
>  	.completed = -300, \
>  	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&structname.onofflock), \
> -	.orphan_cbs_list = NULL, \
> -	.orphan_cbs_tail = &structname.orphan_cbs_list, \
> -	.orphan_qlen = 0, \
>  	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&structname.fqslock), \
>  	.n_force_qs = 0, \
>  	.n_force_qs_ngp = 0, \
> @@ -984,53 +981,31 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
>  #ifdef CONFIG_HOTPLUG_CPU
> 
>  /*
> - * Move a dying CPU's RCU callbacks to the ->orphan_cbs_list for the
> - * specified flavor of RCU.  The callbacks will be adopted by the next
> - * _rcu_barrier() invocation or by the CPU_DEAD notifier, whichever
> - * comes first.  Because this is invoked from the CPU_DYING notifier,
> - * irqs are already disabled.
> + * Move a dying CPU's RCU callbacks to online CPU's callback list.
> + * Synchronization is not required because this function executes
> + * in stop_machine() context.
>   */
> -static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
> +static void rcu_send_cbs_to_online(struct rcu_state *rsp)
>  {
>  	int i;
> +	/* current DYING CPU is cleared in the cpu_online_mask */
> +	int receive_cpu = cpumask_any(cpu_online_mask);
>  	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
> +	struct rcu_data *receive_rdp = per_cpu_ptr(rsp->rda, receive_cpu);

------------------------------------------------------------------------

rcu: update documentation/comments for Lai's adoption patch

Lai's RCU-callback immediate-adoption patch changes the RCU tracing
output, so update tracing.txt.  Also update a few comments to clarify
the synchronization design.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 7f852db..3bb386d 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -122,7 +122,8 @@ o	"ci" is the number of RCU callbacks that have been invoked for
 	been registered in absence of CPU-hotplug activity.
 
 o	"co" is the number of RCU callbacks that have been orphaned due to
-	this CPU going offline.
+	this CPU going offline.  These orphaned callbacks have been moved
+	to an arbitrarily chosen online CPU.
 
 o	"ca" is the number of RCU callbacks that have been adopted due to
 	other CPUs going offline.  Note that ci+co-ca+ql is the number of
@@ -160,12 +161,12 @@ o	"gpnum" is the number of grace periods that have started.  It is
 
 The output of "cat rcu/rcuhier" looks as follows, with very long lines:
 
-c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6 oqlen=0
+c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6
 1/1 .>. 0:127 ^0    
 3/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
 3/3f .>. 0:5 ^0    2/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3    
 rcu_bh:
-c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0 oqlen=0
+c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0
 0/1 .>. 0:127 ^0    
 0/3 .>. 0:35 ^0    0/0 .>. 36:71 ^1    0/0 .>. 72:107 ^2    0/0 .>. 108:127 ^3    
 0/3f .>. 0:5 ^0    0/3 .>. 6:11 ^1    0/0 .>. 12:17 ^2    0/0 .>. 18:23 ^3    0/0 .>. 24:29 ^4    0/0 .>. 30:35 ^5    0/0 .>. 36:41 ^0    0/0 .>. 42:47 ^1    0/0 .>. 48:53 ^2    0/0 .>. 54:59 ^3    0/0 .>. 60:65 ^4    0/0 .>. 66:71 ^5    0/0 .>. 72:77 ^0    0/0 .>. 78:83 ^1    0/0 .>. 84:89 ^2    0/0 .>. 90:95 ^3    0/0 .>. 96:101 ^4    0/0 .>. 102:107 ^5    0/0 .>. 108:113 ^0    0/0 .>. 114:119 ^1    0/0 .>. 120:125 ^2    0/0 .>. 126:127 ^3
@@ -204,11 +205,6 @@ o	"fqlh" is the number of calls to force_quiescent_state() that
 	exited immediately (without even being counted in nfqs above)
 	due to contention on ->fqslock.
 
-o	"oqlen" is the number of callbacks on the "orphan" callback
-	list.  RCU callbacks are placed on this list by CPUs going
-	offline, and are "adopted" either by the CPU helping the outgoing
-	CPU or by the next rcu_barrier*() call, whichever comes first.
-
 o	Each element of the form "1/1 0:127 ^0" represents one struct
 	rcu_node.  Each line represents one level of the hierarchy, from
 	root to leaves.  It is best to think of the rcu_data structures
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a97a061..fa254c5 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1657,7 +1657,9 @@ static void _rcu_barrier(struct rcu_state *rsp,
 	 * decrement rcu_barrier_cpu_count -- otherwise the first CPU
 	 * might complete its grace period before all of the other CPUs
 	 * did their increment, causing this function to return too
-	 * early.
+	 * early.  Note that on_each_cpu() disables irqs, which prevents
+	 * any CPUs from coming online or going offline until each online
+	 * CPU has queued its RCU-barrier callback.
 	 */
 	atomic_set(&rcu_barrier_cpu_count, 1);
 	on_each_cpu(rcu_barrier_func, (void *)call_rcu_func, 1);
@@ -1786,9 +1788,9 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
 		/*
-		 * The whole machine is "stopped" except this cpu, so we can
-		 * touch any data without introducing corruption. And we send
-		 * the callbacks to an attribute chosen online cpu.
+		 * The whole machine is "stopped" except this CPU, so we can
+		 * touch any data without introducing corruption. We send the
+		 * dying CPU's callbacks to an arbitrarily chosen online CPU.
 		 */
 		rcu_send_cbs_to_online(&rcu_bh_state);
 		rcu_send_cbs_to_online(&rcu_sched_state);
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 0aa84ae..6341adf 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -844,7 +844,7 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
 }
 
 /*
- * Move preemptable DYING RCU's callbacks to other online CPU.
+ * Move preemptable RCU's callbacks from dying CPU to other online CPU.
  */
 static void rcu_preempt_send_cbs_to_online(void)
 {
