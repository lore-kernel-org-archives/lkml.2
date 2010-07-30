Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383Ab0G3TEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:04:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23272 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760276Ab0G3TEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 15:04:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=GGh9ZVtpH/Y7B3Q5wQ8EnTgE2MPbDDLBA1CVsidjMaDL1ixUL2DosCmIAeKcX6e7v
	4nfuuR1yFIlZawbs+Vllg==
MIME-Version: 1.0
In-Reply-To: <1280496739.10435.10.camel@marge.simson.net>
References: <1280467146-32218-1-git-send-email-ncrao@google.com> 
	<1280496739.10435.10.camel@marge.simson.net>
From: Paul Turner <pjt@google.com>
Date: Fri, 30 Jul 2010 12:03:49 -0700
Message-ID: <AANLkTimnb8jPkET312n0rdUV6c4QpAJau1opCrkzdAhC@mail.gmail.com>
Subject: Re: [PATCH 0/6] [RFC] Large weight differential leads to inefficient 
	load balancing
To: Mike Galbraith <efault@gmx.de>
Cc: Nikhil Rao <ncrao@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venki@google.com>, Ken Chen <kenchen@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 6:32 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Thu, 2010-07-29 at 22:19 -0700, Nikhil Rao wrote:
>> Hi all,
>>
>> We have observed that a large weight differential between tasks on a runqueue
>> leads to sub-optimal machine utilization and poor load balancing. For example,
>> if you have lots of SCHED_IDLE tasks (sufficient number to keep the machine 100%
>> busy) and a few SCHED_NORMAL soaker tasks, we see that the machine has
>> significant idle time.
>>
>> The data below highlights this problem. The test machine is a 4 socket quad-core
>> box (16 cpus). These experiemnts were done with v2.6.25-rc6. We spawn 16
>> SCHED_IDLE soaker threads (one per-cpu) to completely fill up the machine. CPU
>> utilization numbers gathered from mpstat for 10s are:
>>
>> 03:30:24 PM  CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal   %idle    intr/s
>> 03:30:25 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16234.65
>> 03:30:26 PM  all   99.88    0.06    0.06    0.00    0.00    0.00    0.00    0.00  16374.00
>> 03:30:27 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16392.00
>> 03:30:28 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16612.12
>> 03:30:29 PM  all   99.88    0.00    0.12    0.00    0.00    0.00    0.00    0.00  16375.00
>> 03:30:30 PM  all   99.94    0.06    0.00    0.00    0.00    0.00    0.00    0.00  16440.00
>> 03:30:31 PM  all   99.81    0.00    0.19    0.00    0.00    0.00    0.00    0.00  16237.62
>> 03:30:32 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16360.00
>> 03:30:33 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16405.00
>> 03:30:34 PM  all   99.38    0.06    0.50    0.00    0.00    0.00    0.00    0.06  18881.82
>> Average:     all   99.86    0.02    0.12    0.00    0.00    0.00    0.00    0.01  16628.20
>>
>> We then spawn one SCHED_NORMAL while-1 task (the absolute number does not matter
>> so long as we introduce some large weight differential).
>>
>> 03:40:57 PM  CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal   %idle    intr/s
>> 03:40:58 PM  all   83.06    0.00    0.06    0.00    0.00    0.00    0.00   16.88  14555.00
>> 03:40:59 PM  all   78.25    0.00    0.06    0.00    0.00    0.00    0.00   21.69  14527.00
>> 03:41:00 PM  all   82.71    0.06    0.06    0.00    0.00    0.00    0.00   17.17  14879.00
>> 03:41:01 PM  all   87.34    0.00    0.06    0.00    0.00    0.00    0.00   12.59  15466.00
>> 03:41:02 PM  all   80.80    0.06    0.19    0.00    0.00    0.00    0.00   18.95  14584.00
>> 03:41:03 PM  all   82.90    0.00    0.06    0.00    0.00    0.00    0.00   17.04  14570.00
>> 03:41:04 PM  all   79.45    0.00    0.06    0.00    0.00    0.00    0.00   20.49  14536.00
>> 03:41:05 PM  all   86.48    0.00    0.07    0.00    0.00    0.00    0.00   13.46  14577.00
>> 03:41:06 PM  all   76.73    0.06    0.06    0.00    0.00    0.06    0.00   23.10  14594.00
>> 03:41:07 PM  all   86.48    0.00    0.07    0.00    0.00    0.00    0.00   13.45  14703.03
>> Average:     all   82.31    0.02    0.08    0.00    0.00    0.01    0.00   17.59  14699.10
>
> What happens with s/SCHED_IDLE/nice 19?
>
>        -Mike
>
>

So this is also a concern of mine that I wanted to raise.

The problem observed above is a function of balancing entities which
can't meaningfully contribute to improving the observed imbalance.

While this does occur with {nice 19, SCHED_IDLE} threads, it is a more
general problem and actually much more prevalent in the group
scheduling case where the group entity weight is more arbitrary.  This
is compounded by the fact that we iterate over the task_groups in load
balance and don't have a good way of differentiating in-group high/low
weight entities.

Something I have been investigating is how can we fix this problem
more generally: e.g. how can we effectively load-balance a low-weight
entity in the presence of high-weight competition.  This could just as
easily be a {1000, 2} share split as it could be a {64000, 2000} share
split -- the latter won't benefit from IDLE_SCHEDULING optimizations
but is a realistic test case if someone is trying to provide minimal
latencies for the high-weight task.

What I've been considering in avenue is instead of load-balancing the
low weight entities when their h_load relative to the imbalance is
'not meaningful' -- by some fitness function, tag them for a separate
load-balancing pass.  This secondary pass would only need to be
periodic in nature, and consider the 'tagged' task_groups from the
generic load_balancing operations.  At this point in time it can be
evaluated whether the load is still 'not meaningful', and distribution
towards the most idle cpu (by utilization) can be evaluated.

The one converse here is that while something like the above is more
general for the low weight-group entity case, it does not extend
particularly cleanly to the non group-scheduling case.  I haven't yet
got a particularly good answer for this since without a group entity
representing the low-weight threads tracking them for a second pass
becomes more cumbersome.
