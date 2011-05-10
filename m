Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab1EJHTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:19:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45345 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab1EJHTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:19:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DC8E6CE.6030500@jp.fujitsu.com>
Date: Tue, 10 May 2011 16:18:38 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Subject: Re: [patch 03/15] sched: introduce primitives to account for CFS
 bandwidth tracking
References: <20110503092846.022272244@google.com> <20110503092904.720703305@google.com>
In-Reply-To: <20110503092904.720703305@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One nitpicking...

(2011/05/03 18:28), Paul Turner wrote:
> In this patch we introduce the notion of CFS bandwidth, partitioned into 
> globally unassigned bandwidth, and locally claimed bandwidth.
> 
> - The global bandwidth is per task_group, it represents a pool of unclaimed
>   bandwidth that cfs_rqs can allocate from.  
> - The local bandwidth is tracked per-cfs_rq, this represents allotments from
>   the global pool bandwidth assigned to a specific cpu.
> 
> Bandwidth is managed via cgroupfs, adding two new interfaces to the cpu subsystem:
> - cpu.cfs_period_us : the bandwidth period in usecs
> - cpu.cfs_quota_us : the cpu bandwidth (in usecs) that this tg will be allowed
>   to consume over period above.
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> Signed-off-by: Nikhil Rao <ncrao@google.com>
> Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> ---

(snip)

> @@ -369,9 +379,45 @@ struct cfs_rq {
>  
>  	unsigned long load_contribution;
>  #endif
> +#ifdef CONFIG_CFS_BANDWIDTH
> +	int runtime_enabled;
> +	s64 runtime_remaining;
> +#endif
>  #endif
>  };
>  
> +#ifdef CONFIG_CFS_BANDWIDTH
> +static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
> +{
> +	return &tg->cfs_bandwidth;
> +}
> +
> +static inline u64 default_cfs_period(void);
> +
> +static void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
> +{
> +	raw_spin_lock_init(&cfs_b->lock);
> +	cfs_b->quota = RUNTIME_INF;
> +	cfs_b->period = ns_to_ktime(default_cfs_period());
> +}
> +
> +static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq)
> +{
> +	cfs_rq->runtime_remaining = 0;
> +	cfs_rq->runtime_enabled = 0;
> +}
> +
> +static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
> +{}
> +#else
> +#ifdef CONFIG_FAIR_GROUP_SCHED
> +static void init_cfs_rq_runtime(struct cfs_rq *cfs_rq) {}
> +void init_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}

Nit: why not static?

> +static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
> +#endif /* CONFIG_FAIR_GROUP_SCHED */
> +static void start_cfs_bandwidth(struct cfs_rq *cfs_rq) {}
> +#endif /* CONFIG_CFS_BANDWIDTH */
> +
>  /* Real-Time classes' related field in a runqueue: */
>  struct rt_rq {
>  	struct rt_prio_array active;

The rest looks good for me.

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


Thanks,
H.Seto

