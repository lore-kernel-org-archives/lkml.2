Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab2HaR41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 13:56:27 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:41775 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab2HaR40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 13:56:26 -0400
X-Originating-IP: 217.70.178.144
X-Originating-IP: 173.246.103.110
Date: Fri, 31 Aug 2012 10:56:17 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 03/15] rcu: Properly initialize
 ->boost_tasks on CPU offline
Message-ID: <20120831175617.GA4259@jtriplet-mobl1>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346352988-32444-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:56:16AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> When rcu_preempt_offline_tasks() clears tasks from a leaf rcu_node
> structure, it does not NULL out the structure's ->boost_tasks field.
> This commit therefore fixes this issue.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  kernel/rcutree_plugin.h |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 7f3244c..b1b4851 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -584,8 +584,11 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
>  		raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
>  	}
>  
> +	rnp->gp_tasks = NULL;
> +	rnp->exp_tasks = NULL;
>  #ifdef CONFIG_RCU_BOOST
> -	/* In case root is being boosted and leaf is not. */
> +	rnp->boost_tasks = NULL;
> +	/* In case root is being boosted and leaf was not. */
>  	raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
>  	if (rnp_root->boost_tasks != NULL &&
>  	    rnp_root->boost_tasks != rnp_root->gp_tasks)
> @@ -593,8 +596,6 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
>  	raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
>  #endif /* #ifdef CONFIG_RCU_BOOST */
>  
> -	rnp->gp_tasks = NULL;
> -	rnp->exp_tasks = NULL;
>  	return retval;
>  }
>  
> -- 
> 1.7.8
> 
