Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab0JUII5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:08:57 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40111 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab0JUIIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:08:53 -0400
Date: Thu, 21 Oct 2010 13:38:44 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: pjt@google.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>
Subject: Re: [RFC tg_shares_up improvements - v1 01/12] sched: rewrite
	tg_shares_up
Message-ID: <20101021080844.GB3581@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20101016044349.830426011@google.com> <20101016045118.529238208@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016045118.529238208@google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 09:43:50PM -0700, pjt@google.com wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> --- kernel/sched_fair.c.orig
> +++ kernel/sched_fair.c
> @@ -417,7 +417,6 @@ int sched_proc_update_handler(struct ctl
>  	WRT_SYSCTL(sched_min_granularity);
>  	WRT_SYSCTL(sched_latency);
>  	WRT_SYSCTL(sched_wakeup_granularity);
> -	WRT_SYSCTL(sched_shares_ratelimit);
>  #undef WRT_SYSCTL
> 
>  	return 0;
> @@ -633,7 +632,6 @@ account_entity_enqueue(struct cfs_rq *cf
>  		list_add(&se->group_node, &cfs_rq->tasks);
>  	}
>  	cfs_rq->nr_running++;
> -	se->on_rq = 1;
>  }
> 
>  static void
> @@ -647,9 +645,89 @@ account_entity_dequeue(struct cfs_rq *cf
>  		list_del_init(&se->group_node);
>  	}
>  	cfs_rq->nr_running--;
> -	se->on_rq = 0;
>  }
> 
<snip>
> @@ -771,7 +849,9 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
>  	 * Update run-time statistics of the 'current'.
>  	 */
>  	update_curr(cfs_rq);
> +	update_cfs_load(cfs_rq);
>  	account_entity_enqueue(cfs_rq, se);
> +	update_cfs_shares(cfs_rq_of(se));
> 
>  	if (flags & ENQUEUE_WAKEUP) {
>  		place_entity(cfs_rq, se, 0);
> @@ -782,6 +862,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
>  	check_spread(cfs_rq, se);
>  	if (se != cfs_rq->curr)
>  		__enqueue_entity(cfs_rq, se);
> +	se->on_rq = 1;
>  }
> 
>  static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
> @@ -825,8 +906,11 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
> 
>  	if (se != cfs_rq->curr)
>  		__dequeue_entity(cfs_rq, se);
> +	se->on_rq = 0;

Since setting and un-setting of se->on_rq is completely handled within
sched_fair.c, we can remove the redundant setting and un-setting of
se->on_rq from sched.c:[en]dequeue_task. Even w/o this patch, they were
redundant I suppose.

Regards,
Bharata.
