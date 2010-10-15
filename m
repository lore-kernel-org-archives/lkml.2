Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab0JOR2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:28:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:56649 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab0JOR2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:28:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=miGOgQHfd6K60wDWIY5HNFlfyaJHvK+i1i12OTjn+VhKq2J/SoavQTZDqFsjjew69s
         hvK6rBWy9Tb5W9y/DCRg==
MIME-Version: 1.0
In-Reply-To: <1287162325.1998.101.camel@laptop>
References: <1286996978-7007-4-git-send-email-ncrao@google.com>
 <1287035281-25579-1-git-send-email-ncrao@google.com> <1287143423.29097.1460.camel@twins>
 <AANLkTinotiJqfvr9D2yTkuaLDKPcaUaG1dU1goRK8Bi+@mail.gmail.com> <1287162325.1998.101.camel@laptop>
From: Nikhil Rao <ncrao@google.com>
Date: Fri, 15 Oct 2010 10:27:45 -0700
Message-ID: <AANLkTimGNh7bneVPGPiFrY=deNEqf8QH6Ps8pyNkVGVY@mail.gmail.com>
Subject: Re: [PATCH 3/4] sched: drop group_capacity to 1 only if local group
 has extra capacity
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 10:05 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-10-15 at 09:13 -0700, Nikhil Rao wrote:
>
>> >> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
>> >> index 0dd1021..da0c688 100644
>> >> --- a/kernel/sched_fair.c
>> >> +++ b/kernel/sched_fair.c
>> >> @@ -2030,6 +2030,7 @@ struct sd_lb_stats {
>> >>       unsigned long this_load;
>> >>       unsigned long this_load_per_task;
>> >>       unsigned long this_nr_running;
>> >> +     unsigned long this_group_capacity;
>> >>
>> >>       /* Statistics of the busiest group */
>> >>       unsigned long max_load;
>> >> @@ -2546,15 +2547,18 @@ static inline void update_sd_lb_stats(struct sched_domain *sd, int this_cpu,
>> >>               /*
>> >>                * In case the child domain prefers tasks go to siblings
>> >>                * first, lower the sg capacity to one so that we'll try
>> >> -              * and move all the excess tasks away.
>> >> +              * and move all the excess tasks away. We lower capacity only
>> >> +              * if the local group can handle the extra capacity.
>> >>                */
>> >> -             if (prefer_sibling)
>> >> +             if (prefer_sibling && !local_group &&
>> >> +                 sds->this_nr_running < sds->this_group_capacity)
>> >>                       sgs.group_capacity = min(sgs.group_capacity, 1UL);
>> >>
>> >>               if (local_group) {
>> >>                       sds->this_load = sgs.avg_load;
>> >>                       sds->this = sg;
>> >>                       sds->this_nr_running = sgs.sum_nr_running;
>> >> +                     sds->this_group_capacity = sgs.group_capacity;
>> >>                       sds->this_load_per_task = sgs.sum_weighted_load;
>> >>               } else if (update_sd_pick_busiest(sd, sds, sg, &sgs, this_cpu)) {
>> >>                       sds->max_load = sgs.avg_load;
>
> OK, but then you assume that local_group will always be the first group
> served, nor is there any purpose for adding sds->this_group_capacity,
> you could keep that local to this function.
>

Yes, this patch makes the assumption that local_group is the first.

About this_group_capacity, yes -- we don't need the additional field in
sg_lb_stats. We can make it local to this function. I just realized that if
we re-order the patches, we can reuse sgs.has_capacity from the next patch.

> For regular balancing local_group will be the first, since we only
> ascend the domain tree on the local groups. But its not true for no_hz
> balancing afaikt.
>

As Suresh points out, even with NOHZ, the local_group is the first group
since we ascend the per-cpu sched domain. I can add this into the comments
to make it clear.
