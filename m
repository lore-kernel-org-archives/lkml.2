Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0JSScg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:32:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38751 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab0JSScf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:32:35 -0400
Date: Tue, 19 Oct 2010 11:32:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] rcu,cleanup: simplify the code when cpu is dying
Message-ID: <20101019183216.GC2362@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4CBD4F56.2000601@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBD4F56.2000601@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 03:57:10PM +0800, Lai Jiangshan wrote:
> 
> When we handle cpu notify DYING, the whole system is stopped except
> current CPU, so we can touch any data, and we remove the orphan_cbs_tail
> and send the callbacks to the dest CPU directly.

I very much like the overall change!!!

Please see below for some comments.  I have provided a patch
(untested!) corresponding to my comments -- if you agree, please resubmit
your original combined with my patch, along with any needed adjustments.

							Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  rcutree.c        |   78 ++++++++++++-------------------------------------------
>  rcutree.h        |   15 ++--------
>  rcutree_plugin.h |    8 ++---
>  rcutree_trace.c  |   11 +++----
>  4 files changed, 30 insertions(+), 82 deletions(-)
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index ccdc04c..2f12c14 100644
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
> @@ -984,53 +981,28 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
>  #ifdef CONFIG_HOTPLUG_CPU
> 
>  /*
> - * Move a dying CPU's RCU callbacks to the ->orphan_cbs_list for the
> - * specified flavor of RCU.  The callbacks will be adopted by the next
> - * _rcu_barrier() invocation or by the CPU_DEAD notifier, whichever
> - * comes first.  Because this is invoked from the CPU_DYING notifier,
> - * irqs are already disabled.
> + * Move a dying CPU's RCU callbacks to online CPU's callback list.

Need a comment saying why it is safe to do this with no obvious
synchronization.

>   */
> -static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
> +static void rcu_send_cbs_to_online(struct rcu_state *rsp)
>  {
>  	int i;
> +	/* current DYING CPU is cleared in the cpu_online_mask */
> +	int recieve_cpu = cpumask_any(cpu_online_mask);

Yeah, English has some really stupid spelling rules: "receive" rather
than "recieve".  And yes, there is a list of exceptions for words adopted
from the German language.  I cannot defend the rules, but I will go crazy
staring at RCU implementation code that violates the indefensible rules,
so I must insist.  :-/

Hence my patch on your patch...

>  	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
> +	struct rcu_data *recieve_rdp = per_cpu_ptr(rsp->rda, recieve_cpu);
> 
>  	if (rdp->nxtlist == NULL)
>  		return;  /* irqs disabled, so comparison is stable. */
> -	raw_spin_lock(&rsp->onofflock);  /* irqs already disabled. */
> -	*rsp->orphan_cbs_tail = rdp->nxtlist;
> -	rsp->orphan_cbs_tail = rdp->nxttail[RCU_NEXT_TAIL];
> +
> +	*recieve_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
> +	recieve_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
> +	recieve_rdp->qlen += rdp->qlen;
> +	recieve_rdp->n_cbs_adopted += rdp->qlen;
> +
>  	rdp->nxtlist = NULL;
>  	for (i = 0; i < RCU_NEXT_SIZE; i++)
>  		rdp->nxttail[i] = &rdp->nxtlist;
> -	rsp->orphan_qlen += rdp->qlen;
> -	rdp->n_cbs_orphaned += rdp->qlen;

We need to keep the above line, otherwise it will look like the CPU
going offline ate some callbacks and the destination CPU created some
out of thin air.  Some of your changes to the tracing output code must
therefore be backed out.

>  	rdp->qlen = 0;
> -	raw_spin_unlock(&rsp->onofflock);  /* irqs remain disabled. */
> -}
> -
> -/*
> - * Adopt previously orphaned RCU callbacks.
> - */
> -static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
> -{
> -	unsigned long flags;
> -	struct rcu_data *rdp;
> -
> -	raw_spin_lock_irqsave(&rsp->onofflock, flags);
> -	rdp = this_cpu_ptr(rsp->rda);
> -	if (rsp->orphan_cbs_list == NULL) {
> -		raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
> -		return;
> -	}
> -	*rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_list;
> -	rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_tail;
> -	rdp->qlen += rsp->orphan_qlen;
> -	rdp->n_cbs_adopted += rsp->orphan_qlen;
> -	rsp->orphan_cbs_list = NULL;
> -	rsp->orphan_cbs_tail = &rsp->orphan_cbs_list;
> -	rsp->orphan_qlen = 0;
> -	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
>  }
> 
>  /*
> @@ -1081,8 +1053,6 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
>  		raw_spin_unlock_irqrestore(&rnp->lock, flags);
>  	if (need_report & RCU_OFL_TASKS_EXP_GP)
>  		rcu_report_exp_rnp(rsp, rnp);
> -
> -	rcu_adopt_orphan_cbs(rsp);
>  }
> 
>  /*
> @@ -1100,11 +1070,7 @@ static void rcu_offline_cpu(int cpu)
> 
>  #else /* #ifdef CONFIG_HOTPLUG_CPU */
> 
> -static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
> -{
> -}
> -
> -static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
> +static void rcu_send_cbs_to_online(struct rcu_state *rsp)
>  {
>  }
> 
> @@ -1702,10 +1668,7 @@ static void _rcu_barrier(struct rcu_state *rsp,
>  	 * early.
>  	 */
>  	atomic_set(&rcu_barrier_cpu_count, 1);
> -	preempt_disable(); /* stop CPU_DYING from filling orphan_cbs_list */
> -	rcu_adopt_orphan_cbs(rsp);
>  	on_each_cpu(rcu_barrier_func, (void *)call_rcu_func, 1);
> -	preempt_enable(); /* CPU_DYING can again fill orphan_cbs_list */
>  	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
>  		complete(&rcu_barrier_completion);
>  	wait_for_completion(&rcu_barrier_completion);
> @@ -1831,18 +1794,13 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
>  	case CPU_DYING:
>  	case CPU_DYING_FROZEN:
>  		/*
> -		 * preempt_disable() in _rcu_barrier() prevents stop_machine(),
> -		 * so when "on_each_cpu(rcu_barrier_func, (void *)type, 1);"
> -		 * returns, all online cpus have queued rcu_barrier_func().
> -		 * The dying CPU clears its cpu_online_mask bit and
> -		 * moves all of its RCU callbacks to ->orphan_cbs_list
> -		 * in the context of stop_machine(), so subsequent calls
> -		 * to _rcu_barrier() will adopt these callbacks and only
> -		 * then queue rcu_barrier_func() on all remaining CPUs.
> +		 * The whole machine is "stopped" except this cpu, so we can
> +		 * touch any data without introducing corruption. And we send
> +		 * the callbacks to an attribute chosen online cpu.
>  		 */
> -		rcu_send_cbs_to_orphanage(&rcu_bh_state);
> -		rcu_send_cbs_to_orphanage(&rcu_sched_state);
> -		rcu_preempt_send_cbs_to_orphanage();
> +		rcu_send_cbs_to_online(&rcu_bh_state);
> +		rcu_send_cbs_to_online(&rcu_sched_state);
> +		rcu_preempt_send_cbs_to_online();
>  		break;
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 91d4170..a6efdd0 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -203,8 +203,7 @@ struct rcu_data {
>  	long		qlen_last_fqs_check;
>  					/* qlen at last check for QS forcing */
>  	unsigned long	n_cbs_invoked;	/* count of RCU cbs invoked. */
> -	unsigned long	n_cbs_orphaned;	/* RCU cbs sent to orphanage. */

Again, we need to keep n_cbs_orphaned.

> -	unsigned long	n_cbs_adopted;	/* RCU cbs adopted from orphanage. */
> +	unsigned long   n_cbs_adopted;  /* RCU cbs adopted from dying CPU */
>  	unsigned long	n_force_qs_snap;
>  					/* did other CPU force QS recently? */
>  	long		blimit;		/* Upper limit on a processed batch */
> @@ -309,15 +308,7 @@ struct rcu_state {
>  	/* End of fields guarded by root rcu_node's lock. */
> 
>  	raw_spinlock_t onofflock;		/* exclude on/offline and */
> -						/*  starting new GP.  Also */
> -						/*  protects the following */
> -						/*  orphan_cbs fields. */
> -	struct rcu_head *orphan_cbs_list;	/* list of rcu_head structs */
> -						/*  orphaned by all CPUs in */
> -						/*  a given leaf rcu_node */
> -						/*  going offline. */
> -	struct rcu_head **orphan_cbs_tail;	/* And tail pointer. */
> -	long orphan_qlen;			/* Number of orphaned cbs. */
> +						/*  starting new GP. */
>  	raw_spinlock_t fqslock;			/* Only one task forcing */
>  						/*  quiescent states. */
>  	unsigned long jiffies_force_qs;		/* Time at which to invoke */
> @@ -390,7 +381,7 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp);
>  static int rcu_preempt_pending(int cpu);
>  static int rcu_preempt_needs_cpu(int cpu);
>  static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
> -static void rcu_preempt_send_cbs_to_orphanage(void);
> +static void rcu_preempt_send_cbs_to_online(void);
>  static void __init __rcu_init_preempt(void);
>  static void rcu_needs_cpu_flush(void);
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 9e62b01..cc6e525 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -844,11 +844,11 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
>  }
> 
>  /*
> - * Move preemptable RCU's callbacks to ->orphan_cbs_list.
> + * Move preemptable DYING RCU's callbacks to other online CPU.
>   */
> -static void rcu_preempt_send_cbs_to_orphanage(void)
> +static void rcu_preempt_send_cbs_to_online(void)
>  {
> -	rcu_send_cbs_to_orphanage(&rcu_preempt_state);
> +	rcu_send_cbs_to_online(&rcu_preempt_state);
>  }
> 
>  /*
> @@ -1072,7 +1072,7 @@ static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
>  /*
>   * Because there is no preemptable RCU, there are no callbacks to move.
>   */
> -static void rcu_preempt_send_cbs_to_orphanage(void)
> +static void rcu_preempt_send_cbs_to_online(void)
>  {
>  }
> 
> diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
> index d15430b..4bf58f7 100644
> --- a/kernel/rcutree_trace.c
> +++ b/kernel/rcutree_trace.c

And all of the changes in this file need to be reverted.

> @@ -65,8 +65,8 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
>  #endif /* #ifdef CONFIG_NO_HZ */
>  	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
>  	seq_printf(m, " ql=%ld b=%ld", rdp->qlen, rdp->blimit);
> -	seq_printf(m, " ci=%lu co=%lu ca=%lu\n",
> -		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
> +	seq_printf(m, " ci=%lu ca=%lu\n",
> +		   rdp->n_cbs_invoked, rdp->n_cbs_adopted);
>  }
> 
>  #define PRINT_RCU_DATA(name, func, m) \
> @@ -122,8 +122,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
>  #endif /* #ifdef CONFIG_NO_HZ */
>  	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
>  	seq_printf(m, ",%ld,%ld", rdp->qlen, rdp->blimit);
> -	seq_printf(m, ",%lu,%lu,%lu\n",
> -		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
> +	seq_printf(m, ",%lu,%lu\n", rdp->n_cbs_invoked, rdp->n_cbs_adopted);
>  }
> 
>  static int show_rcudata_csv(struct seq_file *m, void *unused)
> @@ -166,13 +165,13 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
> 
>  	gpnum = rsp->gpnum;
>  	seq_printf(m, "c=%lu g=%lu s=%d jfq=%ld j=%x "
> -		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld\n",
> +		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu\n",
>  		   rsp->completed, gpnum, rsp->signaled,
>  		   (long)(rsp->jiffies_force_qs - jiffies),
>  		   (int)(jiffies & 0xffff),
>  		   rsp->n_force_qs, rsp->n_force_qs_ngp,
>  		   rsp->n_force_qs - rsp->n_force_qs_ngp,
> -		   rsp->n_force_qs_lh, rsp->orphan_qlen);
> +		   rsp->n_force_qs_lh);
>  	for (rnp = &rsp->node[0]; rnp - &rsp->node[0] < NUM_RCU_NODES; rnp++) {
>  		if (rnp->level != level) {
>  			seq_puts(m, "\n");

And here is the patch:

------------------------------------------------------------------------

Fixup patch to Lai Jiangshan's orphan/adoption patch.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 86989d5..a97a061 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -985,22 +985,25 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
 
 /*
  * Move a dying CPU's RCU callbacks to online CPU's callback list.
+ * Synchronization is not required because this function executes
+ * in stop_machine() context.
  */
 static void rcu_send_cbs_to_online(struct rcu_state *rsp)
 {
 	int i;
 	/* current DYING CPU is cleared in the cpu_online_mask */
-	int recieve_cpu = cpumask_any(cpu_online_mask);
+	int receive_cpu = cpumask_any(cpu_online_mask);
 	struct rcu_data *rdp = this_cpu_ptr(rsp->rda);
-	struct rcu_data *recieve_rdp = per_cpu_ptr(rsp->rda, recieve_cpu);
+	struct rcu_data *receive_rdp = per_cpu_ptr(rsp->rda, receive_cpu);
 
 	if (rdp->nxtlist == NULL)
 		return;  /* irqs disabled, so comparison is stable. */
 
-	*recieve_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
-	recieve_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
-	recieve_rdp->qlen += rdp->qlen;
-	recieve_rdp->n_cbs_adopted += rdp->qlen;
+	*receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
+	receive_rdp->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+	receive_rdp->qlen += rdp->qlen;
+	receive_rdp->n_cbs_adopted += rdp->qlen;
+	rdp->n_cbs_orphaned += rdp->qlen;
 
 	rdp->nxtlist = NULL;
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index de97e8b..1677276 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -201,6 +201,7 @@ struct rcu_data {
 	long		qlen_last_fqs_check;
 					/* qlen at last check for QS forcing */
 	unsigned long	n_cbs_invoked;	/* count of RCU cbs invoked. */
+	unsigned long   n_cbs_orphaned; /* RCU cbs orphaned by dying CPU */
 	unsigned long   n_cbs_adopted;  /* RCU cbs adopted from dying CPU */
 	unsigned long	n_force_qs_snap;
 					/* did other CPU force QS recently? */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 031ec2c..627f7a5 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -65,8 +65,8 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
 	seq_printf(m, " ql=%ld b=%ld", rdp->qlen, rdp->blimit);
-	seq_printf(m, " ci=%lu ca=%lu\n",
-		   rdp->n_cbs_invoked, rdp->n_cbs_adopted);
+	seq_printf(m, " ci=%lu co=%lu ca=%lu\n",
+		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
 
 #define PRINT_RCU_DATA(name, func, m) \
@@ -122,7 +122,8 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
 	seq_printf(m, ",%ld,%ld", rdp->qlen, rdp->blimit);
-	seq_printf(m, ",%lu,%lu\n", rdp->n_cbs_invoked, rdp->n_cbs_adopted);
+	seq_printf(m, ",%lu,%lu,%lu\n",
+		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
 
 static int show_rcudata_csv(struct seq_file *m, void *unused)
@@ -165,13 +166,13 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 
 	gpnum = rsp->gpnum;
 	seq_printf(m, "c=%lu g=%lu s=%d jfq=%ld j=%x "
-		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu\n",
+		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld\n",
 		   rsp->completed, gpnum, rsp->signaled,
 		   (long)(rsp->jiffies_force_qs - jiffies),
 		   (int)(jiffies & 0xffff),
 		   rsp->n_force_qs, rsp->n_force_qs_ngp,
 		   rsp->n_force_qs - rsp->n_force_qs_ngp,
-		   rsp->n_force_qs_lh);
+		   rsp->n_force_qs_lh, rsp->orphan_qlen);
 	for (rnp = &rsp->node[0]; rnp - &rsp->node[0] < NUM_RCU_NODES; rnp++) {
 		if (rnp->level != level) {
 			seq_puts(m, "\n");
