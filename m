Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab1BGSWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:22:06 -0500
Received: from smtp-out.google.com ([74.125.121.67]:12172 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab1BGSWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:22:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kUEgd8af7SD6Z1XTCI9wYasA9CqxEks9B74m5+yvBSBrfrZJxsJWEXiRSaG/enC7uP
         YrUGMqPcF8R8QwO8lowA==
MIME-Version: 1.0
In-Reply-To: <1297086642.13327.15.camel@laptop>
References: <1296852688-1665-1-git-send-email-venki@google.com>
	<1296854731-25039-1-git-send-email-venki@google.com>
	<1297086642.13327.15.camel@laptop>
Date: Mon, 7 Feb 2011 10:21:58 -0800
Message-ID: <AANLkTi=xo8bq6uTjYQ7yxJ69ATry1Xs3q0deE7UN9jPj@mail.gmail.com>
Subject: Re: [PATCH] sched: Resolve sd_idle and first_idle_cpu Catch-22 - v1
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 5:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-02-04 at 13:25 -0800, Venkatesh Pallipadi wrote:
>> Consider a system with { [ (A B) (C D) ] [ (E F) (G H) ] },
>> () denoting SMT siblings, [] cores on same socket and {} system wide
>> Further, A, C and D are idle, B is busy and one of EFGH has excess load.
>>
>> With sd_idle logic, a check in rebalance_domains() converts tick
>> based load balance requests from CPU A to busy load balance for core
>> and above domains (lower rate of balance and higher load_idx).
>
> the if (load_balance())
>        idle = CPU_NOT_IDLE;
> bit, right?
>
>> With first_idle_cpu logic, when CPU C or D tries to balance across domains
>> the logic finds CPU A as first idle CPU in the group and nominates CPU A to
>> idle balance across sockets.
>
> Right..
>
>> But, sd_idle above would not allow CPU A to do cross socket idle balance
>> as CPU A switches its higher level balancing to busy balance.
>
> Because it fails the sd->flags & SD_SHARE_CPUPOWER test at the beginning
> of load_balance() and hence sd_idle will remain 0, right?
>
> I'm just not quite sure how we then end up returning !0 for
> load_balance(), both branches returning -1 seem conditional on
> SD_SHARE_CPUPOWER but the [ (A B) (C D) ], domain doesn't have that set.
>

For (A B) domain, SD_SHARE_CPUPOWER is set and when A finds that B
is busy, it sets its sd_idle to 1 during its SMT sibling balance (once every
2-4 ticks) and load_balance() returns -1 in this case. And rebalance_domains()
looks at this -1 and makes load_balance calls for CORE and NUMA domains
as CPU_NOT_IDLE, thus increasing the load_balance period.

>> So, this can result is no cross socket balancing for extended periods.
>
> Which is bad
>
>> The fix here adds additional check to detect sd_idle logic in
>> first_idle_cpu code path. We will now nominate (in order or preference):
>> * First fully idle CPU
>> * First semi-idle CPU
>> * First CPU
>>
>> Note that this solution works fine for 2 SMT siblings case and won't be
>> perfect in picking proper semi-idle in case of more than 2 SMT threads.
>
> All these SMT exceptions make my head hurt, can't we clean that up
> instead of making them worse?
>
> Why is SMT treaded differently from say a shared cache? In both cases we
> want to spread the load as wide as possible to provide as much of the
> resources to the few runnable tasks.
>

IIRC, the reason for the whole sd_idle part was to have less aggressive
load balance when one SMT sibling is busy and other is idle, in order not
to take CPU cycles away from the busy sibling.
Suresh will know the exact reasoning behind this and which CPUs and
which workload this helped..

Since this patch, I started looking at sd_idle more closely and I have
two other patches fixing problems related to sd_idle in its current form.
I agree that sd_idle stuff is making the code a lot complicated and
we can clean/remove it.

Thanks,
Venki
