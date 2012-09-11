Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010Ab2IKShD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:37:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:58899 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758337Ab2IKShA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:37:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,406,1344236400"; 
   d="scan'208";a="201681597"
Subject: Re: [PATCH 2/2] sched: trigger_load_balance clean up
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alex Shi <alex.shi@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, venki@google.com
Date: Tue, 11 Sep 2012 11:36:12 -0700
In-Reply-To: <1347261059-24747-2-git-send-email-alex.shi@intel.com>
References: <1347261059-24747-1-git-send-email-alex.shi@intel.com>
	 <1347261059-24747-2-git-send-email-alex.shi@intel.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1347388574.26695.135.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-10 at 15:10 +0800, Alex Shi wrote:
> Remove a redundant check for on_null_domain(cpu), and rerange the code
> that make it more readable.

hmm, but we are now doing the on_null_domain() check always,
irrespective of whether we need the load balance or not.

do we really need the on_null_domain() check there? What happens if we
just remove it?

thanks,
suresh

> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 5bbc4bf..529092d 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4934,11 +4934,13 @@ static inline int on_null_domain(int cpu)
>  void trigger_load_balance(struct rq *rq, int cpu)
>  {
>  	/* Don't need to rebalance while attached to NULL domain */
> -	if (time_after_eq(jiffies, rq->next_balance) &&
> -	    likely(!on_null_domain(cpu)))
> +	if (unlikely(on_null_domain(cpu)))
> +		return;
> +
> +	if (time_after_eq(jiffies, rq->next_balance))
>  		raise_softirq(SCHED_SOFTIRQ);
>  #ifdef CONFIG_NO_HZ
> -	if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
> +	if (nohz_kick_needed(rq, cpu))
>  		nohz_balancer_kick(cpu);
>  #endif
>  }


