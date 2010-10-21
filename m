Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab0JUJwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:52:41 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:32931 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317Ab0JUJwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:52:40 -0400
Date: Thu, 21 Oct 2010 15:22:21 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: pjt@google.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Chris Friesen <cfriesen@nortel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Pierre Bourdon <pbourdon@excellency.fr>
Subject: Re: [RFC tg_shares_up improvements - v1 05/12] sched: fix
	update_cfs_load synchronization
Message-ID: <20101021095221.GC3581@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20101016044349.830426011@google.com> <20101016045118.832209343@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016045118.832209343@google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 09:43:54PM -0700, pjt@google.com wrote:
> Using cfs_rq->nr_running is not sufficient to synchronize update_cfs_load with
> the put path since nr_running accounting occurs at deactivation.
> 
> It's also not safe to make the removal decision based on load_avg as this fails
> with both high periods and low shares.  Resolve this by clipping history at 8
> foldings.
> 

Did you mean 4 foldings (and not 8) above since I see you are truncating
the load history at 4 idle periods ?


> @@ -685,9 +686,19 @@ static void update_cfs_load(struct cfs_r
>  	now = rq_of(cfs_rq)->clock;
>  	delta = now - cfs_rq->load_stamp;
> 
> +	/* truncate load history at 4 idle periods */
> +	if (cfs_rq->load_stamp > cfs_rq->load_last &&
> +	    now - cfs_rq->load_last > 4 * period) {
> +		cfs_rq->load_period = 0;
> +		cfs_rq->load_avg = 0;
> +	}
> +
>  	cfs_rq->load_stamp = now;
>  	cfs_rq->load_period += delta;
> -	cfs_rq->load_avg += delta * cfs_rq->load.weight;
> +	if (load) {
> +		cfs_rq->load_last = now;
> +		cfs_rq->load_avg += delta * load;
> +	}
> 
>  	while (cfs_rq->load_period > period) {
>  		/*
> @@ -700,10 +711,8 @@ static void update_cfs_load(struct cfs_r
>  		cfs_rq->load_avg /= 2;
>  	}
> 
> -	if (lb && !cfs_rq->nr_running) {
> -		if (cfs_rq->load_avg < (period / 8))
> -			list_del_leaf_cfs_rq(cfs_rq);
> -	}
> +	if (!cfs_rq->curr && !cfs_rq->nr_running && !cfs_rq->load_avg)
> +		list_del_leaf_cfs_rq(cfs_rq);
>  }
> 
