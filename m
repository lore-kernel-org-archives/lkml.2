Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab2IBKrR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 06:47:17 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:33590 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab2IBKrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 06:47:16 -0400
X-Originating-IP: 217.70.178.144
X-Originating-IP: 50.43.46.74
Date: Sun, 2 Sep 2012 03:47:07 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 12/23] rcu: Prevent force_quiescent_state()
 memory contention
Message-ID: <20120902104707.GD7767@leaf>
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-12-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346350718-30937-12-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:18:27AM -0700, Paul E. McKenney wrote:
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
[...]
> @@ -1824,16 +1825,35 @@ static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
>  static void force_quiescent_state(struct rcu_state *rsp)
>  {
>  	unsigned long flags;
> -	struct rcu_node *rnp = rcu_get_root(rsp);
> +	bool ret;
> +	struct rcu_node *rnp;
> +	struct rcu_node *rnp_old = NULL;
> +
> +	/* Funnel through hierarchy to reduce memory contention. */
> +	rnp = per_cpu_ptr(rsp->rda, raw_smp_processor_id())->mynode;

What makes this use of raw_smp_processor_id() safe?  (And, could you
document the answer here?)

> +	for (; rnp != NULL; rnp = rnp->parent) {
> +		ret = (ACCESS_ONCE(rsp->gp_flags) & RCU_GP_FLAG_FQS) ||
> +		      !raw_spin_trylock(&rnp->fqslock);

So, the root lock will still get trylocked by one CPU per second-level
tree node, just not by every CPU?

> @@ -2721,10 +2741,14 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
>  static void __init rcu_init_one(struct rcu_state *rsp,
>  		struct rcu_data __percpu *rda)
>  {
> -	static char *buf[] = { "rcu_node_level_0",
> -			       "rcu_node_level_1",
> -			       "rcu_node_level_2",
> -			       "rcu_node_level_3" };  /* Match MAX_RCU_LVLS */
> +	static char *buf[] = { "rcu_node_0",
> +			       "rcu_node_1",
> +			       "rcu_node_2",
> +			       "rcu_node_3" };  /* Match MAX_RCU_LVLS */

Why rename these?

- Josh Triplett
