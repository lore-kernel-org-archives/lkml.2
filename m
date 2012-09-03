Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab2ICJ4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:56:11 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39880 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab2ICJ4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:56:10 -0400
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.46.74
Date: Mon, 3 Sep 2012 02:56:01 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 23/23] rcu: Simplify quiescent-state
 detection
Message-ID: <20120903095601.GL5574@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-23-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-23-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:38AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> The current quiescent-state detection algorithm is needlessly
> complex.  It records the grace-period number corresponding to
> the quiescent state at the time of the quiescent state, which
> works, but it seems better to simply erase any record of previous
> quiescent states at the time that the CPU notices the new grace
> period.  This has the further advantage of removing another piece
> of RCU for which lockless reasoning is required.
> 
> Therefore, this commit makes this change.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcutree.c        |   27 +++++++++++----------------
>  kernel/rcutree.h        |    2 --
>  kernel/rcutree_plugin.h |    2 --
>  kernel/rcutree_trace.c  |   12 +++++-------
>  4 files changed, 16 insertions(+), 27 deletions(-)
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 44609c3..d39ad5c 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -176,8 +176,6 @@ void rcu_sched_qs(int cpu)
>  {
>  	struct rcu_data *rdp = &per_cpu(rcu_sched_data, cpu);
>  
> -	rdp->passed_quiesce_gpnum = rdp->gpnum;
> -	barrier();
>  	if (rdp->passed_quiesce == 0)
>  		trace_rcu_grace_period("rcu_sched", rdp->gpnum, "cpuqs");
>  	rdp->passed_quiesce = 1;
> @@ -187,8 +185,6 @@ void rcu_bh_qs(int cpu)
>  {
>  	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
>  
> -	rdp->passed_quiesce_gpnum = rdp->gpnum;
> -	barrier();
>  	if (rdp->passed_quiesce == 0)
>  		trace_rcu_grace_period("rcu_bh", rdp->gpnum, "cpuqs");
>  	rdp->passed_quiesce = 1;
> @@ -897,12 +893,8 @@ static void __note_new_gpnum(struct rcu_state *rsp, struct rcu_node *rnp, struct
>  		 */
>  		rdp->gpnum = rnp->gpnum;
>  		trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpustart");
> -		if (rnp->qsmask & rdp->grpmask) {
> -			rdp->qs_pending = 1;
> -			rdp->passed_quiesce = 0;
> -		} else {
> -			rdp->qs_pending = 0;
> -		}
> +		rdp->passed_quiesce = 0;
> +		rdp->qs_pending = !!(rnp->qsmask & rdp->grpmask);
>  		zero_cpu_stall_ticks(rdp);
>  	}
>  }
> @@ -982,10 +974,13 @@ __rcu_process_gp_end(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
>  		 * our behalf. Catch up with this state to avoid noting
>  		 * spurious new grace periods.  If another grace period
>  		 * has started, then rnp->gpnum will have advanced, so
> -		 * we will detect this later on.
> +		 * we will detect this later on.  Of course, any quiescent
> +		 * states we found for the old GP are now invalid.
>  		 */
> -		if (ULONG_CMP_LT(rdp->gpnum, rdp->completed))
> +		if (ULONG_CMP_LT(rdp->gpnum, rdp->completed)) {
>  			rdp->gpnum = rdp->completed;
> +			rdp->passed_quiesce = 0;
> +		}
>  
>  		/*
>  		 * If RCU does not need a quiescent state from this CPU,
> @@ -1357,7 +1352,7 @@ rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
>   * based on quiescent states detected in an earlier grace period!
>   */
>  static void
> -rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastgp)
> +rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp)
>  {
>  	unsigned long flags;
>  	unsigned long mask;
> @@ -1365,7 +1360,8 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long las
>  
>  	rnp = rdp->mynode;
>  	raw_spin_lock_irqsave(&rnp->lock, flags);
> -	if (lastgp != rnp->gpnum || rnp->completed == rnp->gpnum) {
> +	if (rdp->passed_quiesce == 0 || rdp->gpnum != rnp->gpnum ||
> +	    rnp->completed == rnp->gpnum) {
>  
>  		/*
>  		 * The grace period in which this quiescent state was
> @@ -1424,7 +1420,7 @@ rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
>  	 * Tell RCU we are done (but rcu_report_qs_rdp() will be the
>  	 * judge of that).
>  	 */
> -	rcu_report_qs_rdp(rdp->cpu, rsp, rdp, rdp->passed_quiesce_gpnum);
> +	rcu_report_qs_rdp(rdp->cpu, rsp, rdp);
>  }
>  
>  #ifdef CONFIG_HOTPLUG_CPU
> @@ -2599,7 +2595,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
>  			rdp->completed = rnp->completed;
>  			rdp->passed_quiesce = 0;
>  			rdp->qs_pending = 0;
> -			rdp->passed_quiesce_gpnum = rnp->gpnum - 1;
>  			trace_rcu_grace_period(rsp->name, rdp->gpnum, "cpuonl");
>  		}
>  		raw_spin_unlock(&rnp->lock); /* irqs already disabled. */
> diff --git a/kernel/rcutree.h b/kernel/rcutree.h
> index 8f0293c..935dd4c 100644
> --- a/kernel/rcutree.h
> +++ b/kernel/rcutree.h
> @@ -246,8 +246,6 @@ struct rcu_data {
>  					/*  in order to detect GP end. */
>  	unsigned long	gpnum;		/* Highest gp number that this CPU */
>  					/*  is aware of having started. */
> -	unsigned long	passed_quiesce_gpnum;
> -					/* gpnum at time of quiescent state. */
>  	bool		passed_quiesce;	/* User-mode/idle loop etc. */
>  	bool		qs_pending;	/* Core waits for quiesc state. */
>  	bool		beenonline;	/* CPU online at least once. */
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index f1e06f6..4bc190a 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -137,8 +137,6 @@ static void rcu_preempt_qs(int cpu)
>  {
>  	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
>  
> -	rdp->passed_quiesce_gpnum = rdp->gpnum;
> -	barrier();
>  	if (rdp->passed_quiesce == 0)
>  		trace_rcu_grace_period("rcu_preempt", rdp->gpnum, "cpuqs");
>  	rdp->passed_quiesce = 1;
> diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
> index f54f0ce..bd4df13 100644
> --- a/kernel/rcutree_trace.c
> +++ b/kernel/rcutree_trace.c
> @@ -86,12 +86,11 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
>  {
>  	if (!rdp->beenonline)
>  		return;
> -	seq_printf(m, "%3d%cc=%lu g=%lu pq=%d pgp=%lu qp=%d",
> +	seq_printf(m, "%3d%cc=%lu g=%lu pq=%d qp=%d",
>  		   rdp->cpu,
>  		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
>  		   rdp->completed, rdp->gpnum,
> -		   rdp->passed_quiesce, rdp->passed_quiesce_gpnum,
> -		   rdp->qs_pending);
> +		   rdp->passed_quiesce, rdp->qs_pending);
>  	seq_printf(m, " dt=%d/%llx/%d df=%lu",
>  		   atomic_read(&rdp->dynticks->dynticks),
>  		   rdp->dynticks->dynticks_nesting,
> @@ -150,12 +149,11 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
>  {
>  	if (!rdp->beenonline)
>  		return;
> -	seq_printf(m, "%d,%s,%lu,%lu,%d,%lu,%d",
> +	seq_printf(m, "%d,%s,%lu,%lu,%d,%d",
>  		   rdp->cpu,
>  		   cpu_is_offline(rdp->cpu) ? "\"N\"" : "\"Y\"",
>  		   rdp->completed, rdp->gpnum,
> -		   rdp->passed_quiesce, rdp->passed_quiesce_gpnum,
> -		   rdp->qs_pending);
> +		   rdp->passed_quiesce, rdp->qs_pending);
>  	seq_printf(m, ",%d,%llx,%d,%lu",
>  		   atomic_read(&rdp->dynticks->dynticks),
>  		   rdp->dynticks->dynticks_nesting,
> @@ -186,7 +184,7 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
>  	int cpu;
>  	struct rcu_state *rsp;
>  
> -	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pgp\",\"pq\",");
> +	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pq\",");
>  	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
>  	seq_puts(m, "\"of\",\"qll\",\"ql\",\"qs\"");
>  #ifdef CONFIG_RCU_BOOST
> -- 
> 1.7.8
> 
