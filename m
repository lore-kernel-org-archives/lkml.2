Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab0GBQUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 12:20:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:21117 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759067Ab0GBQUG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 12:20:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=EWWk7z/gjWCVS7HH4k8SGLbyO7dKcYnCLIPufKZG7aiHstAljzhlWknLbV+JkheBf
	aXP3P+k4Re8MGn8PBa3IQ==
MIME-Version: 1.0
In-Reply-To: <1278057944.32034.15085.camel@twins>
References: <1278025942-6750-1-git-send-email-venki@google.com>
	<1278057944.32034.15085.camel@twins>
Date: Fri, 2 Jul 2010 09:20:02 -0700
Message-ID: <AANLkTikcZhbbtgNjW-JDf9FVD1jbyIsQ_RxeOUVK8c7C@mail.gmail.com>
Subject: Re: [PATCH] sched: Call update_group_power only for local_group
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 1:05 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-07-01 at 16:12 -0700, Venkatesh Pallipadi wrote:
>> commit 871e35b moved update_group_power() call in update_sg_lb_stats(),
>> resulting in it being called for each group, even though it only updates
>> the power of local group. As a result we have frequent redundant
>> update_group_power() calls.
>>
>> Move it back under "if (local_group)" condition.
>>
>> This reduces the number of calls to update_group_power by a factor of 4
>> on my 4 core in 4 NUMA nodes test system.
>
> Hrm,.. so Gautham removed that because for things like the NO_HZ
> balancer the initial balance_cpu == this_cpu constraint doesn't hold.
>
> Not I don't think the local_group constraint holds for that either, so
> the below would again break that..
>
> Should we perhaps have a conditional on this_rq->nohz_balance_kick or
> so?

The thing is that update_group_power is only updating the power of
local group (sd->groups).
It is getting called multiple times however for each group as
update_sd_lb_stats loops
through groups->next calling update_sg_lb_stats.
If we really want to update the power of non-local groups,
update_cpu_power has to change
to take a groups parameter and non this_cpu as arguments and may have
to access non-local
rq etc.

Thanks,
Venki
>
>> --- a/kernel/sched_fair.c
>> +++ b/kernel/sched_fair.c
>> @@ -2359,8 +2359,11 @@ static inline void update_sg_lb_stats(struct sched_domain *sd,
>>       unsigned int balance_cpu = -1, first_idle_cpu = 0;
>>       unsigned long avg_load_per_task = 0;
>>
>> -     if (local_group)
>> +     if (local_group) {
>>               balance_cpu = group_first_cpu(group);
>> +             update_group_power(sd, this_cpu);
>> +     }
>> +
>>
>>       /* Tally up the load of all CPUs in the group */
>>       max_cpu_load = 0;
>
>
