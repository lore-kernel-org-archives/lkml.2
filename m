Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0EGJiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:38:00 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47800 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab0EGJh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:37:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=LBJ2935OxmXCyVTwhqY3fDfUHiCPX0DCjN3MTTf/bD12s1eiX59x61dVt2Wqqw88Y
	NFPJc09E6MNv6VuT1hQzA==
MIME-Version: 1.0
In-Reply-To: <1273220736.1642.318.camel@laptop>
References: <AANLkTikQCkR2K438llKOh43yEgW-Bw7j0f8GoXR50A0V@mail.gmail.com>
	 <1273155640.5605.300.camel@twins> <20100506171141.GA5562@nowhere>
	 <1273167024.1642.256.camel@laptop> <1273220736.1642.318.camel@laptop>
Date: Fri, 7 May 2010 11:37:50 +0200
Message-ID: <AANLkTimegTx_2wHCIhyLqcYbkIJEPi3SsdwgFxU4E7Rk@mail.gmail.com>
Subject: Re: [RFC] perf_events: ctx_flexible_sched_in() not maximizing PMU 
	utilization
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 10:25 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-05-06 at 19:30 +0200, Peter Zijlstra wrote:
>> On Thu, 2010-05-06 at 19:11 +0200, Frederic Weisbecker wrote:
>>
>> > > But yeah, I did think of making the thing an RB-tree and basically
>> > > schedule on service received, that should fix the lop-sided RR we get
>> > > with constrained events.
>>
>> > I don't understand what you mean by schedule on service received, and why
>> > an rbtree would solve that.
>>
>> Schedule those events that got scheduled least, if because of
>> constraints we didn't fully utilize the PMU it is very likely that
>> strict RR (like we do now) will not end up giving equal service to each
>> counter/group.
>>
>> Therefore, if you sort them in a tree, based on the amount of time they
>> got on the PMU, and always schedule the leftmost, you do get fairness.
>
>
> OK a simple example, suppose we have 3 events, A, B and C. A and B are
> exclusive. With the current RR scheduling we get:
>
> / {A}, {B, C}, {C, A} /
>
> Which isn't fair, because we get a 2:1:2 ratio.
>
> If we were to do as Stephane suggested and always schedule the PMU in a
> greedy fashion, we'd get:
>
> / {A, C}, {B, C} /
>
> Which isn't fair either 1:1:2.
>
>
> The perfect case would be if we could always schedule all events on the
> PMU, that way they'd get equal service. But since we cannot, we much
> approximate that.
>
> If we define lag to be the difference between perfect service and our
> approximation thereof: lag_i = S - s_i, then for a scheduler to be fair
> we must place two conditions thereon:
>

I assume S represents the time an event would be on the PMU in the
case of perfect scheduling. And thus S is the same for all events. The
index i represents the event index.

If I have 3 events, regardless of their constraints and grouping, the perfect
service would be that each gets 1/3rd of the time.

>  1) There must be a bound on the maximal lag_i, this ensures progress.
>  2) The sum of lags must be zero, this ensures we converge to the ideal
>    service. [*]
>
> We can satisfy 1 by always at least scheduling the event which has thus
> far received the least service, this ensures everybody makes progress,
> since by definition everybody will at one point be that one.
>
> This by itself however is not enough, since we can schedule multiple
> events, lets again try a greedy model with the previous example. That
> would again reduce to the unfair:
>
> / {A, C}, {B, C} /
>
> Simply because C is always schedulable and A and B alternate between
> being the one who received least service.
>
> This would however violate 2, since C will always be scheduled, its lag
> will decrease without bound.
>
> We can fix this by explicitly not scheduling C when its not eligible.
> That is, we only consider eligible events for placement on the PMU.
> Eligibility means an event has received less service than it would have
> had under the perfect model.
>
> The second condition will help us here: \Sum_i S - s_i = 0. That can be
> written as: n*S - \Sum s_i = 0, where n = \Sum_i 1. From this it
> trivially follows that: S = 1/n \Sum s_i, or in other words S =
> avg(s_i).
>
> So eligibility can be expressed as: s_i < avg(s_i).
>
Which would mean: if my total time on PMU is less than the average
time on the PMU
for all events thus far, then "schedule me now".

You would have to sort the event by increasing s_i (using the RB tree, I assume)

> With this, we will get a schedule like:
>
> / {A, C}, {B} /
>
> We are however still fully greedy, which is still O(n), which we don't
> want. However if we stop being greedy and use the same heuristic we do
> now, stop filling the PMU at the first fail, we'll still be fair,
> because the algorithm ensures that.
>
Let's see if I understand with an example. Assume the PMU multiplex
timing is 1ms, 2 counters. s(n) = total time in ms at time n.

evt   A  B  C
s(0)  0   0  0 -> avg = 0/3=0.00, sort = A, B, C, schedule A, fail on B
s(1)  1   0  0 -> avg = 1/3=0.33, sort = B, C, A, schedule B, C,
s(2)  1   1  1 -> avg = 3/3=1.00, sort = A, B, C, schedule A, fail on B
s(3)  2   1  1 -> avg = 4/3=1.33, sort = B, C, A, schedule B, C
s(4)  2   2  2 -> avg = 6/3=2.00, sort = A, B, C, schedule A, fail on B
s(5)  3   2  2 -> avg = 5/3=1.66, sort = B, C, A, schedule B, C

What if there is no constraints on all 3 events?

evt   A  B  C
s(0)  0   0  0 -> avg = 0/3=0.00, sort = A, B, C, schedule A, B
s(1)  1   1  0 -> avg = 2/3=0.66, sort = C, A, B, schedule C (A, B > avg)
s(2)  1   1  1 -> avg = 3/3=1.00, sort = A, B, C, schedule A, B
s(3)  2   2  1 -> avg = 5/3=1.66, sort = C, A, B, schedule C (A, B > avg)
s(4)  2   2  2 -> avg = 6/3=2.00, sort = B, C, A, schedule B, C
s(5)  2   3  3 -> avg = 8/3=2.66, sort = A, B, C, schedule A (B, C > avg)
s(6)  3   3  3 -> avg = 9/3=3.00, sort = A, B, C, schedule A, B

When all timings are equal, sort could yield any order, it would not matter
because overtime each event will be scheduled if it lags.

Am I understanding your algorithm right?
