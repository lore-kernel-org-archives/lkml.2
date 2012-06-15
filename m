Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab2FPAAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 20:00:12 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:34351 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab2FPAAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 20:00:10 -0400
X-Originating-IP: 217.70.178.141
X-Originating-IP: 50.43.46.74
Date: Fri, 15 Jun 2012 16:59:57 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 14/15] rcu: Use for_each_rcu_flavor() in
 TREE_RCU tracing
Message-ID: <20120615235957.GF7613@leaf>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339794370-28119-14-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339794370-28119-14-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:06:09PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> This commit applies the new for_each_rcu_flavor() macro to the
> kernel/rcutree_trace.c file.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree_trace.c |   95 +++++++++++++++++++-----------------------------
>  1 files changed, 38 insertions(+), 57 deletions(-)
> 
> diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
> index 057408b..c618665 100644
> --- a/kernel/rcutree_trace.c
> +++ b/kernel/rcutree_trace.c
> @@ -48,22 +48,18 @@
>  
>  static void print_rcubarrier(struct seq_file *m, struct rcu_state *rsp)
>  {
> -	seq_printf(m, "%c bcc: %d nbd: %lu\n",
> -		   rsp->rcu_barrier_in_progress ? 'B' : '.',
> +	seq_printf(m, "%s: %c bcc: %d nbd: %lu\n",
> +		   rsp->name, rsp->rcu_barrier_in_progress ? 'B' : '.',
>  		   atomic_read(&rsp->barrier_cpu_count),
>  		   rsp->n_barrier_done);
>  }
>  
>  static int show_rcubarrier(struct seq_file *m, void *unused)
>  {
> -#ifdef CONFIG_TREE_PREEMPT_RCU
> -	seq_puts(m, "rcu_preempt: ");
> -	print_rcubarrier(m, &rcu_preempt_state);
> -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> -	seq_puts(m, "rcu_sched: ");
> -	print_rcubarrier(m, &rcu_sched_state);
> -	seq_puts(m, "rcu_bh: ");
> -	print_rcubarrier(m, &rcu_bh_state);
> +	struct rcu_state *rsp;
> +
> +	for_each_rcu_flavor(rsp)
> +		print_rcubarrier(m, rsp);

Now that you call this function exactly once, I'd suggest inlining it
for clarity; I don't think having it as a separate function makes sense
anymore.

> @@ -129,24 +125,16 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
>  		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
>  }
>  
> -#define PRINT_RCU_DATA(name, func, m) \
> -	do { \
> -		int _p_r_d_i; \
> -		\
> -		for_each_possible_cpu(_p_r_d_i) \
> -			func(m, &per_cpu(name, _p_r_d_i)); \
> -	} while (0)
> -
>  static int show_rcudata(struct seq_file *m, void *unused)
>  {
> -#ifdef CONFIG_TREE_PREEMPT_RCU
> -	seq_puts(m, "rcu_preempt:\n");
> -	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data, m);
> -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> -	seq_puts(m, "rcu_sched:\n");
> -	PRINT_RCU_DATA(rcu_sched_data, print_one_rcu_data, m);
> -	seq_puts(m, "rcu_bh:\n");
> -	PRINT_RCU_DATA(rcu_bh_data, print_one_rcu_data, m);
> +	int cpu;
> +	struct rcu_state *rsp;
> +
> +	for_each_rcu_flavor(rsp) {
> +		seq_printf(m, "%s:\n", rsp->name);
> +		for_each_possible_cpu(cpu)
> +		print_one_rcu_data(m, per_cpu_ptr(rsp->rda, cpu));
> +	}

As above, I'd suggest inlining print_one_rcu_data.

Also, you need to indent the body of the for_each_possible_cpu loop.

> @@ -200,6 +188,9 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
>  
>  static int show_rcudata_csv(struct seq_file *m, void *unused)
>  {
> +	int cpu;
> +	struct rcu_state *rsp;
> +
>  	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pgp\",\"pq\",");
>  	seq_puts(m, "\"dt\",\"dt nesting\",\"dt NMI nesting\",\"df\",");
>  	seq_puts(m, "\"of\",\"qll\",\"ql\",\"qs\"");
> @@ -207,14 +198,11 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
>  	seq_puts(m, "\"kt\",\"ktl\"");
>  #endif /* #ifdef CONFIG_RCU_BOOST */
>  	seq_puts(m, ",\"b\",\"ci\",\"co\",\"ca\"\n");
> -#ifdef CONFIG_TREE_PREEMPT_RCU
> -	seq_puts(m, "\"rcu_preempt:\"\n");
> -	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data_csv, m);
> -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> -	seq_puts(m, "\"rcu_sched:\"\n");
> -	PRINT_RCU_DATA(rcu_sched_data, print_one_rcu_data_csv, m);
> -	seq_puts(m, "\"rcu_bh:\"\n");
> -	PRINT_RCU_DATA(rcu_bh_data, print_one_rcu_data_csv, m);
> +	for_each_rcu_flavor(rsp) {
> +		seq_printf(m, "\"%s:\"\n", rsp->name);
> +		for_each_possible_cpu(cpu)
> +			print_one_rcu_data_csv(m, per_cpu_ptr(rsp->rda, cpu));
> +	}

As above, I'd suggest inlining print_one_rcu_data_csv.

> @@ -304,9 +292,9 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
>  	struct rcu_node *rnp;
>  
>  	gpnum = rsp->gpnum;
> -	seq_printf(m, "c=%lu g=%lu s=%d jfq=%ld j=%x "
> +	seq_printf(m, "%s: c=%lu g=%lu s=%d jfq=%ld j=%x "
>  		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld/%ld\n",
> -		   rsp->completed, gpnum, rsp->fqs_state,
> +		   rsp->name, rsp->completed, gpnum, rsp->fqs_state,
>  		   (long)(rsp->jiffies_force_qs - jiffies),
>  		   (int)(jiffies & 0xffff),
>  		   rsp->n_force_qs, rsp->n_force_qs_ngp,
> @@ -329,14 +317,10 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
>  
>  static int show_rcuhier(struct seq_file *m, void *unused)
>  {
> -#ifdef CONFIG_TREE_PREEMPT_RCU
> -	seq_puts(m, "rcu_preempt:\n");
> -	print_one_rcu_state(m, &rcu_preempt_state);
> -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> -	seq_puts(m, "rcu_sched:\n");
> -	print_one_rcu_state(m, &rcu_sched_state);
> -	seq_puts(m, "rcu_bh:\n");
> -	print_one_rcu_state(m, &rcu_bh_state);
> +	struct rcu_state *rsp;
> +
> +	for_each_rcu_flavor(rsp)
> +		print_one_rcu_state(m, rsp);

As above, I'd suggest inlining print_one_rcu_state.

> @@ -377,11 +361,10 @@ static void show_one_rcugp(struct seq_file *m, struct rcu_state *rsp)
>  
>  static int show_rcugp(struct seq_file *m, void *unused)
>  {
> -#ifdef CONFIG_TREE_PREEMPT_RCU
> -	show_one_rcugp(m, &rcu_preempt_state);
> -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> -	show_one_rcugp(m, &rcu_sched_state);
> -	show_one_rcugp(m, &rcu_bh_state);
> +	struct rcu_state *rsp;
> +
> +	for_each_rcu_flavor(rsp)
> +		show_one_rcugp(m, rsp);

As above, I'd suggest inlining show_one_rcugp.

> @@ -430,14 +413,12 @@ static void print_rcu_pendings(struct seq_file *m, struct rcu_state *rsp)
>  
>  static int show_rcu_pending(struct seq_file *m, void *unused)
>  {
> -#ifdef CONFIG_TREE_PREEMPT_RCU
> -	seq_puts(m, "rcu_preempt:\n");
> -	print_rcu_pendings(m, &rcu_preempt_state);
> -#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
> -	seq_puts(m, "rcu_sched:\n");
> -	print_rcu_pendings(m, &rcu_sched_state);
> -	seq_puts(m, "rcu_bh:\n");
> -	print_rcu_pendings(m, &rcu_bh_state);
> +	struct rcu_state *rsp;
> +
> +	for_each_rcu_flavor(rsp) {
> +		seq_printf(m, "%s:\n", rsp->name);
> +		print_rcu_pendings(m, rsp);
> +	}

As above, I'd suggest inlining print_rcu_pendings.

- Josh Triplett
