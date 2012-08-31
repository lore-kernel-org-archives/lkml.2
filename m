Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab2HaSJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:09:23 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51470 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab2HaSJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:09:21 -0400
X-Originating-IP: 217.70.178.144
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 11:09:12 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 05/15] rcu: Improve boost selection when
 moving tasks to root rcu_node
Message-ID: <20120831180912.GC4259@jtriplet-mobl1>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346352988-32444-5-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:56:18AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> The rcu_preempt_offline_tasks() moves all tasks queued on a given leaf
> rcu_node structure to the root rcu_node, which is done when the last CPU
> corresponding the the leaf rcu_node structure goes offline.  Now that
> RCU-preempt's synchronize_rcu_expedited() implementation blocks CPU-hotplug
> operations during the initialization of each rcu_node structure's
> ->boost_tasks pointer, rcu_preempt_offline_tasks() can do a better job
> of setting the root rcu_node's ->boost_tasks pointer.
> 
> The key point is that rcu_preempt_offline_tasks() runs as part of the
> CPU-hotplug process, so that a concurrent synchronize_rcu_expedited() is
> guaranteed to either have not started on the one hand (in which case there
> is no boosting on behalf of the expedited grace period) to be completely

Missing word: s/to be/or to be/

> initialized on the other (in which case, in absence of other priority

s/absence/the absence/

> boosting, all ->boost_tasks pointers will be initialized).  Therefore,
> if rcu_preempt_offline_tasks() finds that the ->boost_tasks pointer is
> equal to the ->exp_tasks pointer, it can be sure that it is correcty
> placed.
> 
> The case where there was boosting ongoing at the time that the

s/The/In the/

> synchronize_rcu_expedited() function started, different nodes might
> start boosting the tasks blocking the expedited grace period at different
> times.  In this mixed case, the root node will either be boosting tasks
> for the expedited grace period already, or it will start as soon as it
> gets done boosting for the normal grace period -- but in this latter
> case, the root node's tasks needed to be boosted in any case.
> 
> This commit therefore adds a check of the ->boost_tasks pointer against
> the ->exp_tasks pointer to the list that prevents updating ->boost_tasks.

Seems like some hint of this explanation really ought to end up in a
comment somewhere...

> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  kernel/rcutree_plugin.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index b1b4851..c930a47 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -591,7 +591,8 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
>  	/* In case root is being boosted and leaf was not. */
>  	raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
>  	if (rnp_root->boost_tasks != NULL &&
> -	    rnp_root->boost_tasks != rnp_root->gp_tasks)
> +	    rnp_root->boost_tasks != rnp_root->gp_tasks &&
> +	    rnp_root->boost_tasks != rnp_root->exp_tasks)
>  		rnp_root->boost_tasks = rnp_root->gp_tasks;
>  	raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
>  #endif /* #ifdef CONFIG_RCU_BOOST */
> -- 
> 1.7.8
> 
