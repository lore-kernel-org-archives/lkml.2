Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1CWKkA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:40:00 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50926 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753848Ab1CWKj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:39:59 -0400
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+lz40QpCilq6eSsNCx+jWr6JDVi0YZdpkPTqfniu
	giPfVTqBU0AV/1
Date: Wed, 23 Mar 2011 11:39:06 +0100
From: torbenh <torbenh@gmx.de>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 02/15] sched: validate CFS quota hierarchies
Message-ID: <20110323103906.GC5507@siel.b>
Mail-Followup-To: Paul Turner <pjt@google.com>,
	linux-kernel@vger.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Bharata B Rao <bharata@linux.vnet.ibm.com>,
	Dhaval Giani <dhaval.giani@gmail.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
	Srivatsa Vaddagiri <vatsa@in.ibm.com>,
	Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
	Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
References: <20110323030326.789836913@google.com>
 <20110323030448.853861319@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323030448.853861319@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 08:03:28PM -0700, Paul Turner wrote:
> Add constraints validation for CFS bandwidth hierachies.
> 
> It is checked that:
>    sum(child bandwidth) <= parent_bandwidth
> 
> In a quota limited hierarchy, an unconstrainted entity
> (e.g. bandwidth==RUNTIME_INF) inherits the bandwidth of its parent.
> 
> Since bandwidth periods may be non-uniform we normalize to the maximum allowed
> period, 5 seconds.
> 
> This behavior may be disabled (allowing child bandwidth to exceed parent) via
> kernel.sched_cfs_bandwidth_consistent=0
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> 
> ---
>  include/linux/sched.h |    8 +++
>  kernel/sched.c        |  127 +++++++++++++++++++++++++++++++++++++++++++++++---
>  kernel/sched_fair.c   |    8 +++
>  kernel/sysctl.c       |   11 ++++
>  4 files changed, 147 insertions(+), 7 deletions(-)
> 
> Index: tip/kernel/sched.c
> ===================================================================
> --- tip.orig/kernel/sched.c
> +++ tip/kernel/sched.c
> +static int tg_cfs_schedulable_down(struct task_group *tg, void *data)
> +{
> +	struct cfs_schedulable_data *d = data;
> +	struct cfs_bandwidth *cfs_b = tg_cfs_bandwidth(tg);
> +	s64 quota = 0, parent_quota = -1;
> +
> +	quota = normalize_cfs_quota(tg, d);
> +	if (!tg->parent) {
> +		quota = RUNTIME_INF;
> +	} else {
> +		struct cfs_bandwidth *parent_b = tg_cfs_bandwidth(tg->parent);
> +
> +		parent_quota = parent_b->hierarchal_quota;
> +		if (parent_quota != RUNTIME_INF) {
> +			parent_quota -= quota;
> +			/* invalid hierarchy, child bandwidth exceeds parent */
> +			if (parent_quota < 0)
> +				return -EINVAL;
> +		}
> +
> +		/* if no inherent limit then inherit parent quota */
> +		if (quota == RUNTIME_INF)
> +			quota = parent_quota;
> +		parent_b->hierarchal_quota = parent_quota;
> +	}
> +	cfs_b->hierarchal_quota = quota;
> +
> +	return 0;
> +}

I find this logic pretty weird.
As long as quota == INF i can overcommit, but as soon as there is some
quota, i can not ?

Its clear, that one needs to be able to overcommit runtime, or the
default runtime for a new cgroup would need to be 0.
The root problem imo is that runtime and shares should not be in the
same cgroup subsystem. The semantics are too different.


> +
> +static int __cfs_schedulable(struct task_group *tg, u64 period, u64 quota)
> +{
> +	int ret;
> +	struct cfs_schedulable_data data = {
> +		.tg = tg,
> +		.period = period / NSEC_PER_USEC,
> +		.quota = quota / NSEC_PER_USEC,
> +	};
> +
> +	if (!sysctl_sched_cfs_bandwidth_consistent)
> +		return 0;
> +
> +	rcu_read_lock();
> +	ret = walk_tg_tree(tg_cfs_schedulable_down, tg_nop,
> +			    &data);
> +	rcu_read_unlock();

walk_tg_tree does the rcu_read_lock itself.
not necessary to do that here.
look at __rt_schedulable there is no rcu.


> +
> +	return ret;
> +}

-- 
torben Hohn
