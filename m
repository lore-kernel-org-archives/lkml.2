Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1BHRhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:37:23 -0500
Received: from smtp-out.google.com ([74.125.121.67]:34134 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab1BHRhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:37:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W/XaRK6b8y82ZGCPbN8sG+ezzNyLaByNDqHs0p1hQPLLtP6dZGycIs2WXsW7GPXIiY
         rLJ97fbdYj6grAC0VtxA==
MIME-Version: 1.0
In-Reply-To: <1297108399.8221.35.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1296852688-1665-1-git-send-email-venki@google.com>
	<1296854731-25039-1-git-send-email-venki@google.com>
	<1297086642.13327.15.camel@laptop>
	<AANLkTi=xo8bq6uTjYQ7yxJ69ATry1Xs3q0deE7UN9jPj@mail.gmail.com>
	<1297108399.8221.35.camel@sbsiddha-MOBL3.sc.intel.com>
Date: Tue, 8 Feb 2011 09:37:17 -0800
Message-ID: <AANLkTikmWfLv3iMNUky7TRvQtUknLckftiQ4-Br614Rm@mail.gmail.com>
Subject: Re: [PATCH] sched: Resolve sd_idle and first_idle_cpu Catch-22 - v1
From: Venkatesh Pallipadi <venki@google.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Nick Piggin <npiggin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 11:53 AM, Suresh Siddha
<suresh.b.siddha@intel.com> wrote:
> On Mon, 2011-02-07 at 10:21 -0800, Venkatesh Pallipadi wrote:
>> On Mon, Feb 7, 2011 at 5:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > Why is SMT treaded differently from say a shared cache? In both cases we
>> > want to spread the load as wide as possible to provide as much of the
>> > resources to the few runnable tasks.
>> >
>>
>> IIRC, the reason for the whole sd_idle part was to have less aggressive
>> load balance when one SMT sibling is busy and other is idle, in order not
>> to take CPU cycles away from the busy sibling.
>> Suresh will know the exact reasoning behind this and which CPUs and
>> which workload this helped..
>
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5969fe06
>
> Original code came from Nick in 2005.
>
>        [PATCH] sched: HT optimisation
>
>        If an idle sibling of an HT queue encounters a busy sibling, then make
>        higher level load balancing of the non-idle variety.
>
>        Performance of multiprocessor HT systems with low numbers of tasks
>        (generally < number of virtual CPUs) can be significantly worse than the
>        exact same workloads when running in non-HT mode.  The reason is largely
>        due to poor scheduling behaviour.
>
>        This patch improves the situation, making the performance gap far less
>        significant on one problematic test case (tbench).
>
>
> Peter, to answer your question of why SMT is treated different to cores
> sharing cache, performance improvements contributed by SMT is far less
> compared to the cores and any wrong decisions in SMT load balancing
> (especially in the presence of idle cores, packages) has a bigger
> impact.
>
> I think in the tbench case referred by Nick, idle HT siblings in a busy
> package picked the load instead of the idle packages. And thus we
> probably had to wait for active load balance to kick in to distribute
> the load etc by which the damage would have been. Performance impact of
> this condition wouldn't be as severe in the cores sharing last level
> cache and other resources.
>
> Also there are lot of changes in this area since 2005. So it would be
> nice to revisit the tbench case and see if the logic of propagating busy
> sibling status to the higher level load balances is still needed or not.
>
> On the contrary, perhaps there might be some workloads which may benefit
> in performance/latency if we completely do away with this less
> aggressive SMT load balancing.
>
> Venki, as you are looking into the fixes in this area, can you run your
> workloads (aswell as tbench) and compare the logic with your fixes vs
> removing this logic ?
>

I ran tbench (localhost) with various nprocs (4, 8, 12, 18, 24 on a 12
core 24 SMT system),
comparing current sd_idle, sd_idle with all the fixes I have and no sd_idle.
In general tbench Throughput number had a lot of variance and no noticeable
perf improvement with any of the kernels. The only observable result
was with 12 nprocs (with 11 repeat runs). But this again has high variance.

baseline
    N           Min           Max        Median           Avg        Stddev
x  11        1922.2       2165.48       1937.77     1983.4464     81.730586

sd_idle fixes
    N           Min           Max        Median           Avg        Stddev
x  11       1974.05       2142.77       1994.35     2022.6618     53.034822

no sd_idle
    N           Min           Max        Median           Avg        Stddev
x  11       1982.41       2145.88       2056.86     2043.2027     59.879523


We have atleast one workload where both sd_idle fixes and no sd_idle helps
in terms of reducing the idle time and improving the workload latency response,
in comparison to baseline.

Thanks,
Venki
