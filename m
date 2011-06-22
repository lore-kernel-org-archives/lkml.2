Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab1FVJiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 05:38:55 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41327 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab1FVJix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 05:38:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E01B81C.2030506@jp.fujitsu.com>
Date: Wed, 22 Jun 2011 18:38:36 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 06/16] sched: add a timer to handle CFS bandwidth refresh
References: <20110621071649.862846205@google.com> <20110621071700.284687900@google.com>
In-Reply-To: <20110621071700.284687900@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/21 16:16), Paul Turner wrote:
> This patch adds a per-task_group timer which handles the refresh of the global
> CFS bandwidth pool.
> 
> Since the RT pool is using a similar timer there's some small refactoring to
> share this support.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> 
> ---
(snip)
> @@ -413,8 +444,26 @@ static void init_cfs_rq_runtime(struct c
>  	cfs_rq->runtime_enabled = 0;
>  }
>  
> +/* requires cfs_b->lock */
> +static void __start_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
> +{
> +	/*
> +	 * Handle the extremely unlikely case of trying to start the period
> +	 * timer, while that timer is in the tear-down path from having
> +	 * decided to no longer run.  In this case we must wait for the
> +	 * (tail of the) callback to terminate so that we can re-enqueue it.
> +	 */
> +	if (unlikely(hrtimer_active(&cfs_b->period_timer)))
> +		hrtimer_cancel(&cfs_b->period_timer);
> +
> +	cfs_b->timer_active = 1;
> +	start_bandwidth_timer(&cfs_b->period_timer, cfs_b->period);
> +}
> +

Nice trick :-)

(Again,)
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


Thanks,
H.Seto

