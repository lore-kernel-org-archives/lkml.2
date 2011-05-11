Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab1EKQpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:45:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32219 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab1EKQpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:45:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=hiJ0CXyGMK3LCYVn3k8sepH1s5yKuNb4GtztHOEYS2ZpCZgDSrRl/gzZXgo30v2bWX
         jsv1LDJVO+F59V9Rn6bw==
MIME-Version: 1.0
In-Reply-To: <4DC8E748.90505@jp.fujitsu.com>
References: <20110503092846.022272244@google.com> <20110503092904.806273470@google.com>
 <4DC8E748.90505@jp.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 11 May 2011 02:37:38 -0700
Message-ID: <BANLkTimPX7Jq03HwNdP+GBCzqmYnUVLmBA@mail.gmail.com>
Subject: Re: [patch 04/15] sched: validate CFS quota hierarchies
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 12:20 AM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> Description typos + one bug.
>
> (2011/05/03 18:28), Paul Turner wrote:
>> Add constraints validation for CFS bandwidth hierachies.
>
>                                               hierarchies
>
>>
>> Validate that:
>>    sum(child bandwidth) <= parent_bandwidth
>>
>> In a quota limited hierarchy, an unconstrainted entity
>
>                                   unconstrained
>
>> (e.g. bandwidth==RUNTIME_INF) inherits the bandwidth of its parent.
>>
>> Since bandwidth periods may be non-uniform we normalize to the maximum allowed
>> period, 1 second.
>>
>> This behavior may be disabled (allowing child bandwidth to exceed parent) via
>> kernel.sched_cfs_bandwidth_consistent=0
>>
>> Signed-off-by: Paul Turner <pjt@google.com>
>>
>> ---
> (snip)
>> +/*
>> + * normalize group quota/period to be quota/max_period
>> + * note: units are usecs
>> + */
>> +static u64 normalize_cfs_quota(struct task_group *tg,
>> +                            struct cfs_schedulable_data *d)
>> +{
>> +     u64 quota, period;
>> +
>> +     if (tg == d->tg) {
>> +             period = d->period;
>> +             quota = d->quota;
>> +     } else {
>> +             period = tg_get_cfs_period(tg);
>> +             quota = tg_get_cfs_quota(tg);
>> +     }
>> +
>> +     if (quota == RUNTIME_INF)
>> +             return RUNTIME_INF;
>> +
>> +     return to_ratio(period, quota);
>> +}
>
> Since tg_get_cfs_quota() doesn't return RUNTIME_INF but -1,
> this function needs a fix like following.
>
> For fixed version, feel free to add:
>
> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>
> Thanks,
> H.Seto
>
> ---
>  kernel/sched.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index d2562aa..f171ba5 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9465,16 +9465,17 @@ static u64 normalize_cfs_quota(struct task_group *tg,
>        u64 quota, period;
>
>        if (tg == d->tg) {
> +               if (d->quota == RUNTIME_INF)
> +                       return RUNTIME_INF;
>                period = d->period;
>                quota = d->quota;
>        } else {
> +               if (tg_cfs_bandwidth(tg)->quota == RUNTIME_INF)
> +                       return RUNTIME_INF;
>                period = tg_get_cfs_period(tg);
>                quota = tg_get_cfs_quota(tg);
>        }
>

Good catch!

Just modifying:
+if (quota == RUNTIME_INF || quota == -1)
+                       return RUNTIME_INF;

Seems simpler.

Although really there's no reason for tg_get_cfs_runtime (and
sched_group_rt_runtime from which it's cloned) not to be returning
RUNTIME_INF and then doing the conversion within the cgroupfs handler.

Fixing both is probably a better clean-up.

> -       if (quota == RUNTIME_INF)
> -               return RUNTIME_INF;
> -
>        return to_ratio(period, quota);
>  }
>
>
>
