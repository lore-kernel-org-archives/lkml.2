Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1GGThJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:37:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992Ab1GGThH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:37:07 -0400
Date: Thu, 7 Jul 2011 15:36:38 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
Message-ID: <20110707193638.GA6734@redhat.com>
References: <20110707053036.173186930@google.com>
 <20110707112302.GB8227@elte.hu>
 <1310049528.3282.583.camel@twins>
 <1310061588.3282.624.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310061588.3282.624.camel@twins>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 07:59:48PM +0200, Peter Zijlstra wrote:
> On Thu, 2011-07-07 at 16:38 +0200, Peter Zijlstra wrote:
> > On Thu, 2011-07-07 at 13:23 +0200, Ingo Molnar wrote:
> > > 
> > > The +1.5% increase in vanilla kernel context switching performance is 
> > > unfortunate - where does that overhead come from?
> > 
> > Looking at the asm output, I think its partly because things like:
> > 
> > @@ -602,6 +618,8 @@ static void update_curr(struct cfs_rq *c
> >                 cpuacct_charge(curtask, delta_exec);
> >                 account_group_exec_runtime(curtask, delta_exec);
> >         }
> > +
> > +       account_cfs_rq_runtime(cfs_rq, delta_exec);
> >  }
> > 
> > 
> > +static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
> > +               unsigned long delta_exec)
> > +{
> > +       if (!cfs_rq->runtime_enabled)
> > +               return;
> > +
> > +       cfs_rq->runtime_remaining -= delta_exec;
> > +       if (cfs_rq->runtime_remaining > 0)
> > +               return;
> > +
> > +       assign_cfs_rq_runtime(cfs_rq);
> > +}
> > 
> > generate a call, only to then take the first branch out, marking that
> > function __always_inline would cure the call problem. Going beyond that
> > would be using static_branch() to track if there is any bandwidth
> > tracking required at all.
> 
> Right, so that cfs_rq->runtime_enabled is almost a guaranteed cacheline
> miss as well, its at the tail end of cfs_rq, then again, the smp-load
> update will want to touch that same cacheline so its not a complete
> waste of time.
> 
> The other big addition to all the fast paths are the various throttled
> checks, those do miss a complete new cacheline.. adding a
> static_branch() to that might make sense.
> 
> compile tested only..
> 

I'm curious to see how the asm look like here for the static
branches in this case, can you post it?

thanks,

-Jason


> ---
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -71,6 +71,7 @@
>  #include <linux/ctype.h>
>  #include <linux/ftrace.h>
>  #include <linux/slab.h>
> +#include <linux/jump_label.h>
>  
>  #include <asm/tlb.h>
>  #include <asm/irq_regs.h>
> @@ -297,6 +298,7 @@ struct task_group {
>  	struct autogroup *autogroup;
>  #endif
>  
> +	int runtime_enabled;
>  	struct cfs_bandwidth cfs_bandwidth;
>  };
>  
> @@ -410,6 +412,8 @@ struct cfs_rq {
>  };
>  
>  #ifdef CONFIG_CFS_BANDWIDTH
> +static struct jump_label_key cfs_bandwidth_enabled;
> +
>  static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
>  {
>  	return &tg->cfs_bandwidth;
> @@ -9075,6 +9079,15 @@ static int tg_set_cfs_bandwidth(struct t
>  			unthrottle_cfs_rq(cfs_rq);
>  		raw_spin_unlock_irq(&rq->lock);
>  	}
> +
> +	if (runtime_enabled && !tg->runtime_enabled)
> +		jump_label_inc(&cfs_bandwidth_enabled);
> +
> +	if (!runtime_enabled && tg->runtime_enabled)
> +		jump_label_dec(&cfs_bandwidth_enabled);
> +
> +	tg->runtime_enabled = runtime_enabled;
> +
>  out_unlock:
>  	mutex_unlock(&cfs_constraints_mutex);
>  
> Index: linux-2.6/kernel/sched_fair.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_fair.c
> +++ linux-2.6/kernel/sched_fair.c
> @@ -1410,10 +1410,10 @@ static void expire_cfs_rq_runtime(struct
>  	}
>  }
>  
> -static void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
> +static __always_inline void account_cfs_rq_runtime(struct cfs_rq *cfs_rq,
>  		unsigned long delta_exec)
>  {
> -	if (!cfs_rq->runtime_enabled)
> +	if (!static_branch(&cfs_bandwidth_enabled) || !cfs_rq->runtime_enabled)
>  		return;
>  
>  	/* dock delta_exec before expiring quota (as it could span periods) */
> @@ -1433,13 +1433,13 @@ static void account_cfs_rq_runtime(struc
>  
>  static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
>  {
> -	return cfs_rq->throttled;
> +	return static_branch(&cfs_bandwidth_enabled) && cfs_rq->throttled;
>  }
>  
>  /* check whether cfs_rq, or any parent, is throttled */
>  static inline int throttled_hierarchy(struct cfs_rq *cfs_rq)
>  {
> -	return cfs_rq->throttle_count;
> +	return static_branch(&cfs_bandwidth_enabled) && cfs_rq->throttle_count;
>  }
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
