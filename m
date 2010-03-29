Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab0C2Emo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 00:42:44 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33580 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab0C2Emn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 00:42:43 -0400
Date: Sun, 28 Mar 2010 21:42:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: don't call rcu_preempt_note_context_switch() in
 rcu_check_callbacks()
Message-ID: <20100329044236.GB2343@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BB014DF.9030905@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB014DF.9030905@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 10:47:59AM +0800, Lai Jiangshan wrote:
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 7bit
> 
> 
> Even though in user mode or idle mode, rcu_check_callbacks() is not
> context switch, so we don't call rcu_preempt_note_context_switch()
> in rcu_check_callbacks().
> 
> Though there is no harm that calls rcu_preempt_note_context_switch()
> in rcu_check_callbacks(), but it is waste.
> 
> rcu_check_callbacks()
>   rcu_sched_qs()
>     rcu_preempt_note_context_switch()
>        Now, ->rcu_read_lock_nesting == 0, so we just calls
>        rcu_preempt_qs(), but, rcu_preempt_check_callbacks()
>        will call it again and set the ->rcu_read_unlock_special
>        correct again.
> 
> So let rcu_preempt_check_callbacks() handle things for us.

Nice!!!

But how about naming the new function that invokes
rcu_preempt_note_context_switch() something like
rcu_sched_note_context_switch(), and then leaving the
name of rcu_sched_qs() the same (rather than changing
it to __rcu_sched_qs(), as below)?

This way, the names clearly call out what the function
is doing.

Or did I miss the point here?

						Thanx, Paul

> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index 3ec8160..c7847ba 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -95,7 +95,7 @@ static int rcu_gp_in_progress(struct rcu_state *rsp)
>   * how many quiescent states passed, just if there was at least
>   * one since the start of the grace period, this just sets a flag.
>   */
> -void rcu_sched_qs(int cpu)
> +static void __rcu_sched_qs(int cpu)
>  {
>  	struct rcu_data *rdp;
> 
> @@ -103,6 +103,11 @@ void rcu_sched_qs(int cpu)
>  	rdp->passed_quiesc_completed = rdp->gpnum - 1;
>  	barrier();
>  	rdp->passed_quiesc = 1;
> +}
> +
> +void rcu_sched_qs(int cpu)
> +{
> +	__rcu_sched_qs(cpu);
>  	rcu_preempt_note_context_switch(cpu);
>  }
> 
> @@ -1138,12 +1143,12 @@ void rcu_check_callbacks(int cpu, int user)
>  		 * a quiescent state, so note it.
>  		 *
>  		 * No memory barrier is required here because both
> -		 * rcu_sched_qs() and rcu_bh_qs() reference only CPU-local
> +		 * __rcu_sched_qs() and rcu_bh_qs() reference only CPU-local
>  		 * variables that other CPUs neither access nor modify,
>  		 * at least not while the corresponding CPU is online.
>  		 */
> 
> -		rcu_sched_qs(cpu);
> +		__rcu_sched_qs(cpu);
>  		rcu_bh_qs(cpu);
> 
>  	} else if (!in_softirq()) {
> 
