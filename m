Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab2LKFI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 00:08:57 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:50043 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab2LKFI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 00:08:56 -0500
Message-ID: <50C6BFB9.7030405@linux.vnet.ibm.com>
Date: Tue, 11 Dec 2012 10:38:09 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: Re: [PATCH 02/18] sched: fix find_idlest_group mess logical
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <1355127754-8444-3-git-send-email-alex.shi@intel.com>
In-Reply-To: <1355127754-8444-3-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121105-6102-0000-0000-000002B25338
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On 12/10/2012 01:52 PM, Alex Shi wrote:
> There is 4 situations in the function:
> 1, no task allowed group;
> 	so min_load = ULONG_MAX, this_load = 0, idlest = NULL
> 2, only local group task allowed;
> 	so min_load = ULONG_MAX, this_load assigned, idlest = NULL
> 3, only non-local task group allowed;
> 	so min_load assigned, this_load = 0, idlest != NULL
> 4, local group + another group are task allowed.
> 	so min_load assigned, this_load assigned, idlest != NULL
> 
> Current logical will return NULL in first 3 kinds of scenarios.
> And still return NULL, if idlest group is heavier then the
> local group in the 4th situation.
> 
> Actually, I thought groups in situation 2,3 are also eligible to host
> the task. And in 4th situation, agree to bias toward local group.
> So, has this patch.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index df99456..b40bc2b 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2953,6 +2953,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
>  		  int this_cpu, int load_idx)
>  {
>  	struct sched_group *idlest = NULL, *group = sd->groups;
> +	struct sched_group *this_group = NULL;
>  	unsigned long min_load = ULONG_MAX, this_load = 0;
>  	int imbalance = 100 + (sd->imbalance_pct-100)/2;
>  
> @@ -2987,14 +2988,19 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p,
>  
>  		if (local_group) {
>  			this_load = avg_load;
> -		} else if (avg_load < min_load) {
> +			this_group = group;
> +		}
> +		if (avg_load < min_load) {
>  			min_load = avg_load;
>  			idlest = group;
>  		}
>  	} while (group = group->next, group != sd->groups);
>  
> -	if (!idlest || 100*this_load < imbalance*min_load)
> -		return NULL;
> +	if (this_group && idlest != this_group)
> +		/* Bias toward our group again */
> +		if (100*this_load < imbalance*min_load)
> +			idlest = this_group;

If the idlest group is heavier than this_group(or to put it better if
the difference in the loads of the local group and idlest group is less
than a threshold,it means there is no point moving the load from the
local group) you return NULL,that immediately means this_group is chosen
as the candidate group for the task to run,one does not have to
explicitly return that.

Let me explain:
find_idlest_group()-if it returns NULL to mark your case4,it means there
is no idler group than the group to which this_cpu belongs to, at that
level of sched domain.Which is fair enough.

So now the question is under such a circumstance which is the idlest
group so far.It is the group containing this_cpu,i.e.this_group.After
this sd->child is chosen which is nothing but this_group(sd hierarchy
moves towards the cpu it belongs to). Again here the idlest group search
begins.

> +
>  	return idlest;
>  }
>  
> 
Regards
Preeti U Murthy

