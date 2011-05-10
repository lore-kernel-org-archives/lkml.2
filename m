Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab1EJHVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:21:06 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45414 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab1EJHVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:21:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DC8E748.90505@jp.fujitsu.com>
Date: Tue, 10 May 2011 16:20:40 +0900
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
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch 04/15] sched: validate CFS quota hierarchies
References: <20110503092846.022272244@google.com> <20110503092904.806273470@google.com>
In-Reply-To: <20110503092904.806273470@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Description typos + one bug.

(2011/05/03 18:28), Paul Turner wrote:
> Add constraints validation for CFS bandwidth hierachies.

                                               hierarchies

> 
> Validate that:
>    sum(child bandwidth) <= parent_bandwidth
> 
> In a quota limited hierarchy, an unconstrainted entity

                                   unconstrained

> (e.g. bandwidth==RUNTIME_INF) inherits the bandwidth of its parent.
> 
> Since bandwidth periods may be non-uniform we normalize to the maximum allowed
> period, 1 second.
> 
> This behavior may be disabled (allowing child bandwidth to exceed parent) via
> kernel.sched_cfs_bandwidth_consistent=0
> 
> Signed-off-by: Paul Turner <pjt@google.com>
> 
> ---
(snip)
> +/*
> + * normalize group quota/period to be quota/max_period
> + * note: units are usecs
> + */
> +static u64 normalize_cfs_quota(struct task_group *tg,
> +			       struct cfs_schedulable_data *d)
> +{
> +	u64 quota, period;
> +
> +	if (tg == d->tg) {
> +		period = d->period;
> +		quota = d->quota;
> +	} else {
> +		period = tg_get_cfs_period(tg);
> +		quota = tg_get_cfs_quota(tg);
> +	}
> +
> +	if (quota == RUNTIME_INF)
> +		return RUNTIME_INF;
> +
> +	return to_ratio(period, quota);
> +}

Since tg_get_cfs_quota() doesn't return RUNTIME_INF but -1,
this function needs a fix like following.

For fixed version, feel free to add:

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Thanks,
H.Seto

---
 kernel/sched.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d2562aa..f171ba5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9465,16 +9465,17 @@ static u64 normalize_cfs_quota(struct task_group *tg,
 	u64 quota, period;
 
 	if (tg == d->tg) {
+		if (d->quota == RUNTIME_INF)
+			return RUNTIME_INF;
 		period = d->period;
 		quota = d->quota;
 	} else {
+		if (tg_cfs_bandwidth(tg)->quota == RUNTIME_INF)
+			return RUNTIME_INF;
 		period = tg_get_cfs_period(tg);
 		quota = tg_get_cfs_quota(tg);
 	}
 
-	if (quota == RUNTIME_INF)
-		return RUNTIME_INF;
-
 	return to_ratio(period, quota);
 }
 

