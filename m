Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab0HZTTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 15:19:52 -0400
Received: from smtp-out.google.com ([74.125.121.35]:11980 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab0HZTTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 15:19:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QRbBwOAGe3Wpg3q8CQXoFwbtIFaPQLTppB1L3i3u5N9uAAPZHJ5zFIsdfHqXI+OvLq
         5zUBFh4a60IWXmbsL5xQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTimT4T-6dO=Uo05DexYf3exq=0SkZemHuB5aRP3Q@mail.gmail.com>
References: <AANLkTimT4T-6dO=Uo05DexYf3exq=0SkZemHuB5aRP3Q@mail.gmail.com>
Date: Thu, 26 Aug 2010 12:19:46 -0700
Message-ID: <AANLkTim75Z-X--LDJX8MLYF8G=vPW_GniVFQrkL7QoAy@mail.gmail.com>
Subject: Re: divide by zero bug in find_busiest_group
From: Venkatesh Pallipadi <venki@google.com>
To: Chetan Ahuja <chetan.ahuja@gmail.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 25, 2010 at 6:17 PM, Chetan Ahuja <chetan.ahuja@gmail.com> wrote:
> This has been filed as a bug in the kernel bugzilla
> (https://bugzilla.kernel.org/show_bug.cgi?id=16991)
> but the visibility on bugzilla seems low ( and the bugizlla server
> seems to get overly "stressed" during
> certain parts of the day)  so here's my "summary" of the discussion so
> far. If for nothing else, so it gets
> indexed by search engines etc.
>
> We've seen a divide-by-zero crash  in the function  update_sg_lb_stats
> (inlined into find_busiest_group) at the following location :
>
>  /usr/src/linux/kernel/sched.c:3769
> *balance = 0;
> return;
> }
>
> /* Adjust by relative CPU power of the group */
> sgs->avg_load = (sgs->group_load * SCHED_LOAD_SCALE) /
> group->cpu_power;
> aff5: 48 c1 e0 0a shl $0xa,%rax
> aff9: 48 f7 f6 div %rsi
>
> Apparently group->cpu_power can be zero under some conditions.
>
>    I noticed  (what I thought was) a race condition between cpu_power
> being initted to zero
> (in build_xxx_groups functions in sched.c) and their use as
> denominator in find_busiest/idlest_group
> functions. PeterZ replied that there's a safe codepath from
> build_*_groups functions to the crash
> location  which guaranteed  a non-zero value.  I did express concern
> that in absence of explicit
> synchronization/mem-barriers we're at the mercy of compiler and
> hardware doing us favors (by
>  not re-ordering  instructions in an adverse way) for that guarantee.
> But I don't think we got hit
>  by the initial zeroes because all the crashes I saw happened after
> many months of uptime.
>
>  There's also another place group->cpu_power values gets updated
> without any synchronization, in
> the update_cpu_power function. Though the only way  this could result
> in a bad value for cpu_power
> is by  core A reading an in-transit value for a non-atomically-updated
> 64 bit value from core B :-). Unlikely ?
> Very !!. Should we make that update explicity atomic ?  Would be prudent.
>

There is another potential bug that may cause zero power.

I actually saw similar problem a while back, while I was playing
around with rt_avg stuff. But, I have only seen the problem with my
modified kernel (playing with softirq accouting part) and not with
vanilla kernel. May be your workload includes some RT tasks that
triggers this in vanilla kernel as well.

This is what I saw happening in my case:
scale_rt_power()
- In some corner case total ends up being less than rq->rt_avg.
- As a result, available is negative
- scale_rt_power returns negative value
update_cpu_power()
- returns negative power

When we later sum up power across groups, we can end up with a group
having negative power making the sum power a zero for a parent group,
causing div_by_zero.

I now have this change in my tree along with my softirq+rt_avg changes
and haven't seen the failure since.

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index ae2a225..8c31e38 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2858,6 +2858,9 @@ unsigned long scale_rt_power(int cpu)
 	u64 total, available;

 	total = sched_avg_period() + (rq->clock - rq->age_stamp);
+	if (unlikely(total < rq->rt_avg))
+		return 0;
+
 	available = total - rq->rt_avg;

 	if (unlikely((s64)total < SCHED_LOAD_SCALE))



The theory I had on why total can be less than rq->rt_avg.
- (Time T0) update_curr calls sched_rt_avg_update and delta accumulation starts
- (Time T1) lb scale_rt_power calls sched_avg_update() and we say
there was aging at this point (while rt_avg doesn't have delta added
yet)
- (Time T2) timer int -> update_curr calls sched_rt_avg_update() with
no aging of timestamp, but delta added to rt_avg.
- Time passes
- (Time T3) lb calls scale_latc_power again, and at this point
  total = period + (T3 - T1)
  rt_avg = halved at T1 (which can be ~period) + T3 - T0
which can be slightly greater than total, spoiling the math from there on.

I tried reproducing the problem with vanilla kernel and couldn't
reproduce it. May be your workload is triggering this some how?
Also, Suresh did recent fixes to rt_avg and this may not be a problem
after that. I Haven't looked at this case closely after that recent
change.

Thanks,
Venki
