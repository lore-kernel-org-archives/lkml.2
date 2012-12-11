Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab2LKL4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 06:56:09 -0500
Received: from mga14.intel.com ([143.182.124.37]:50547 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893Ab2LKL4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 06:56:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,258,1355126400"; 
   d="scan'208";a="229864967"
Message-ID: <50C71F4D.5040804@intel.com>
Date: Tue, 11 Dec 2012 19:55:57 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: Re: [PATCH 02/18] sched: fix find_idlest_group mess logical
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <1355127754-8444-3-git-send-email-alex.shi@intel.com> <50C6BFB9.7030405@linux.vnet.ibm.com> <50C6C4A9.2090003@intel.com> <50C6C990.1090704@linux.vnet.ibm.com>
In-Reply-To: <50C6C990.1090704@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2012 01:50 PM, Preeti U Murthy wrote:
> Hi Alex,
> On 12/11/2012 10:59 AM, Alex Shi wrote:
>> On 12/11/2012 01:08 PM, Preeti U Murthy wrote:
>>> Hi Alex,
>>>
>>> On 12/10/2012 01:52 PM, Alex Shi wrote:
>>>> There is 4 situations in the function:
>>>> 1, no task allowed group;
>>>> 	so min_load = ULONG_MAX, this_load = 0, idlest = NULL
>>>> 2, only local group task allowed;
>>>> 	so min_load = ULONG_MAX, this_load assigned, idlest = NULL
>>>> 3, only non-local task group allowed;
>>>> 	so min_load assigned, this_load = 0, idlest != NULL
>>>> 4, local group + another group are task allowed.
>>>> 	so min_load assigned, this_load assigned, idlest != NULL
>>>>
>>>> Current logical will return NULL in first 3 kinds of scenarios.
>>>> And still return NULL, if idlest group is heavier then the
>>>> local group in the 4th situation.
>>>>
>>>> Actually, I thought groups in situation 2,3 are also eligible to host
>>>> the task. And in 4th situation, agree to bias toward local group.
>>>> So, has this patch.
>>>>
>>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>>>> ---
>>>>  kernel/sched/fair.c |   12 +++++++++---
>>>>  1 files changed, 9 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>> index df99456..b40bc2b 100644
>>>> --- a/kernel/sched/fair.c
>>>> +++ b/kernel/sched/fair.c
>>>> @@ -2953,6 +2953,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
>>>>  		  int this_cpu, int load_idx)
>>>>  {
>>>>  	struct sched_group *idlest = NULL, *group = sd->groups;
>>>> +	struct sched_group *this_group = NULL;
>>>>  	unsigned long min_load = ULONG_MAX, this_load = 0;
>>>>  	int imbalance = 100 + (sd->imbalance_pct-100)/2;
>>>>  
>>>> @@ -2987,14 +2988,19 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
>>>>  
>>>>  		if (local_group) {
>>>>  			this_load = avg_load;
>>>> -		} else if (avg_load < min_load) {
>>>> +			this_group = group;
>>>> +		}
>>>> +		if (avg_load < min_load) {
>>>>  			min_load = avg_load;
>>>>  			idlest = group;
>>>>  		}
>>>>  	} while (group = group->next, group != sd->groups);
>>>>  
>>>> -	if (!idlest || 100*this_load < imbalance*min_load)
>>>> -		return NULL;
>>>> +	if (this_group && idlest != this_group)
>>>> +		/* Bias toward our group again */
>>>> +		if (100*this_load < imbalance*min_load)
>>>> +			idlest = this_group;
>>>
>>> If the idlest group is heavier than this_group(or to put it better if
>>> the difference in the loads of the local group and idlest group is less
>>> than a threshold,it means there is no point moving the load from the
>>> local group) you return NULL,that immediately means this_group is chosen
>>> as the candidate group for the task to run,one does not have to
>>> explicitly return that.
>>
>> In situation 4, this_group is not NULL.
> 
> True.The return value of find_idlest_group() indicates that there is no
> other idle group other than the local group(the group to which cpu
> belongs to). it does not indicate that there is no host group for the
> task.If this is the case,select_task_rq_fair() falls back to the
> group(sd->child) to which the cpu chosen in the previous iteration
> belongs to,This is nothing but this_group in the current iteration.

Sorry, I didn't get you here.
> 
> Regards
> Preeti U Murthy
> 


-- 
Thanks
    Alex
