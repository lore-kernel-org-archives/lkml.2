Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab2HaST1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:19:27 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42601 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab2HaSTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:19:25 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 11:19:17 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 09/15] rcu: Avoid
 rcu_print_detail_task_stall_rnp() segfault
Message-ID: <20120831181917.GG4259@jtriplet-mobl1>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-9-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346352988-32444-9-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:56:22AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The rcu_print_detail_task_stall_rnp() function invokes
> rcu_preempt_blocked_readers_cgp() to verify that there are some preempted
> RCU readers blocking the current grace period outside of the protection
> of the rcu_node structure's ->lock.  This means that the last blocked
> reader might exit its RCU read-side critical section and remove itself
> from the ->blkd_tasks list before the ->lock is acquired, resulting in
> a segmentation fault when the subsequent code attempts to dereference
> the now-NULL gp_tasks pointer.
> 
> This commit therefore moves the test under the lock.  This will not
> have measurable effect on lock contention because this code is invoked
> only when printing RCU CPU stall warnings, in other words, in the common
> case, never.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutree_plugin.h |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 139a803..c02dc1d 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -422,9 +422,11 @@ static void rcu_print_detail_task_stall_rnp(struct rcu_node *rnp)
>  	unsigned long flags;
>  	struct task_struct *t;
>  
> -	if (!rcu_preempt_blocked_readers_cgp(rnp))
> -		return;
>  	raw_spin_lock_irqsave(&rnp->lock, flags);
> +	if (!rcu_preempt_blocked_readers_cgp(rnp)) {
> +		raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +		return;
> +	}
>  	t = list_entry(rnp->gp_tasks,
>  		       struct task_struct, rcu_node_entry);
>  	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry)

Given the small number of lines of code inside the critical section
here, I think this would look clearer without the early return and
duplicate lock release:

	raw_spin_lock_irqsave(&rnp->lock, flags);
	if (rcu_preempt_blocked_readers_cgp(rnp)) {
		...
	}
	raw_spin_unlock_irqrestore(&rnp->lock, flags);

- Josh Triplett
