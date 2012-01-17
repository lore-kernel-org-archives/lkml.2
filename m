Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab2AQCvt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 21:51:49 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:60980 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2AQCvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 21:51:48 -0500
Message-ID: <4F14DFE0.7050402@linux.vnet.ibm.com>
Date: Tue, 17 Jan 2012 10:41:36 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] sched: Accelerate "pick_next_entity" under special
 condition
References: <4F13EFBE.1030002@linux.vnet.ibm.com> <1326707503.2442.219.camel@twins> <4F14DEAE.60702@linux.vnet.ibm.com>
In-Reply-To: <4F14DEAE.60702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011702-5564-0000-0000-000000F99FF6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter

I sent this v2 patch with more description, suppose to explain
what's in my mind clearly.

Please tell me if my understanding on the logic is wrong, I really
need your help to realize the issue.

Best regards
Michael Wang

On 01/17/2012 10:36 AM, Michael Wang wrote:

> From: wangyun <wangyun@linux.vnet.ibm.com>
> 
> In original code, we get the next entity in this way:
> 
> 	if(condition1)
> 		result=value1;
> 	if(condition2)
> 		result=value2;
> 	if(condition3)
> 		result=value3;
> 	return result;
> 
> So if condition3 is true, we will get value3, but still
> need to check condition1 and condition2, this will waste
> our time.
> 
> This patch will change the way like:
> 
> 	if(condition3) {
> 		result=value3;
> 		goto out;
> 	}
> 	if(condition2) {
> 		result=value2;
> 		goto out;
> 	}
> 	if(condition1) {
> 		result=value1;
> 		goto out;
> 	}
> 
> 	out:
> 	return result;
> 
> So we can avoid check condition2 and condition1 when
> condition3 is true now.
> 
> v2:
> 	1. do not use ugly macro any more.
> 	2. add more description.
> 
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  kernel/sched/fair.c |   26 +++++++++++++++-----------
>  1 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 84adb2d..e8a72b2 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1308,29 +1308,33 @@ static struct sched_entity
> *pick_next_entity(struct cfs_rq *cfs_rq)
>  	struct sched_entity *left = se;
> 
>  	/*
> -	 * Avoid running the skip buddy, if running something else can
> -	 * be done without getting too unfair.
> +	 * Someone really wants this to run. If it's not unfair, run it.
>  	 */
> -	if (cfs_rq->skip == se) {
> -		struct sched_entity *second = __pick_next_entity(se);
> -		if (second && wakeup_preempt_entity(second, left) < 1)
> -			se = second;
> +	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
> +		se = cfs_rq->next;
> +		goto out;
>  	}
> 
>  	/*
>  	 * Prefer last buddy, try to return the CPU to a preempted task.
>  	 */
> -	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1)
> +	if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1) {
>  		se = cfs_rq->last;
> +		goto out;
> +	}
> 
>  	/*
> -	 * Someone really wants this to run. If it's not unfair, run it.
> +	 * Avoid running the skip buddy, if running something else can
> +	 * be done without getting too unfair.
>  	 */
> -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1)
> -		se = cfs_rq->next;
> +	if (cfs_rq->skip == se) {
> +		struct sched_entity *second = __pick_next_entity(se);
> +		if (second && wakeup_preempt_entity(second, left) < 1)
> +			se = second;
> +	}
> 
> +out:
>  	clear_buddies(cfs_rq, se);
> -
>  	return se;
>  }
> 


