Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab0EGKtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 06:49:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42438 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0EGKtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 06:49:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=rUatk6BX4hkh8xoO6T9cRVeVoKYjDr7yHORBW34mEsW8Bz9R+enfndRAB+Zeahc1V
	qxCFh3Eqj3Upbg9FjRYvA==
MIME-Version: 1.0
In-Reply-To: <1273226796.1642.333.camel@laptop>
References: <AANLkTikQCkR2K438llKOh43yEgW-Bw7j0f8GoXR50A0V@mail.gmail.com>
	 <1273155640.5605.300.camel@twins> <20100506171141.GA5562@nowhere>
	 <1273167024.1642.256.camel@laptop> <1273220736.1642.318.camel@laptop>
	 <AANLkTimegTx_2wHCIhyLqcYbkIJEPi3SsdwgFxU4E7Rk@mail.gmail.com>
	 <1273226796.1642.333.camel@laptop>
Date: Fri, 7 May 2010 12:49:19 +0200
Message-ID: <AANLkTimguldif-yCpPIPC65RL5bvp-HARuuhOHarxIf1@mail.gmail.com>
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

On Fri, May 7, 2010 at 12:06 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-05-07 at 11:37 +0200, Stephane Eranian wrote:
>
>> > If we define lag to be the difference between perfect service and our
>> > approximation thereof: lag_i = S - s_i, then for a scheduler to be fair
>> > we must place two conditions thereon:
>> >
>>
>
>> > So eligibility can be expressed as: s_i < avg(s_i).
>> >
>> Which would mean: if my total time on PMU is less than the average
>> time on the PMU for all events thus far, then "schedule me now".
>
Agreed.

>
>> You would have to sort the event by increasing s_i (using the RB tree, I assume)
>
> Exactly.
>
You'd have to insert all event into the tree, read leftmost.
I believe you need more than just basic integer arithmetic
to compare s_i to avg. Or you need to tweak the values
to get more precisions. But you may already be doing that
elsewhere in the kernel.

>> > With this, we will get a schedule like:
>> >
>> > / {A, C}, {B} /
>> >
>> > We are however still fully greedy, which is still O(n), which we don't
>> > want. However if we stop being greedy and use the same heuristic we do
>> > now, stop filling the PMU at the first fail, we'll still be fair,
>> > because the algorithm ensures that.
>> >
>> Let's see if I understand with an example. Assume the PMU multiplex
>> timing is 1ms, 2 counters. s(n) = total time in ms at time n.
>>
>> evt   A  B  C
>> s(0)  0   0  0 -> avg = 0/3=0.00, sort = A, B, C, schedule A, fail on B
>> s(1)  1   0  0 -> avg = 1/3=0.33, sort = B, C, A, schedule B, C,
>> s(2)  1   1  1 -> avg = 3/3=1.00, sort = A, B, C, schedule A, fail on B
>> s(3)  2   1  1 -> avg = 4/3=1.33, sort = B, C, A, schedule B, C
>> s(4)  2   2  2 -> avg = 6/3=2.00, sort = A, B, C, schedule A, fail on B
>> s(5)  3   2  2 -> avg = 5/3=1.66, sort = B, C, A, schedule B, C
>>
>> What if there is no constraints on all 3 events?
>>
>> evt   A  B  C
>> s(0)  0   0  0 -> avg = 0/3=0.00, sort = A, B, C, schedule A, B
>> s(1)  1   1  0 -> avg = 2/3=0.66, sort = C, A, B, schedule C (A, B > avg)
>> s(2)  1   1  1 -> avg = 3/3=1.00, sort = A, B, C, schedule A, B
>> s(3)  2   2  1 -> avg = 5/3=1.66, sort = C, A, B, schedule C (A, B > avg)
>> s(4)  2   2  2 -> avg = 6/3=2.00, sort = B, C, A, schedule B, C
>> s(5)  2   3  3 -> avg = 8/3=2.66, sort = A, B, C, schedule A (B, C > avg)
>> s(6)  3   3  3 -> avg = 9/3=3.00, sort = A, B, C, schedule A, B
>>
>> When all timings are equal, sort could yield any order, it would not matter
>> because overtime each event will be scheduled if it lags.
>>
>> Am I understanding your algorithm right?
>
> Perfectly!
>
> So the ramification of not using a greedy algorithm is that the
> potential schedule of constrained events/groups gets longer than is
> absolutely required, but I think that is something we'll have to live
> with, since O(n) just isn't a nice option.
>
> This can be illustrated if we consider B to be exclusive with both A and
> C, in that case we could end up with:
>
> / {A}, {B}, {C} /
>
> instead of
>
> / {A, C}, {B} /
>
> Depending on the order in which we find events sorted.

Yes. Not clear how you could avoid this without having a global
view of the dependencies between events (which are really event
groups, BTW). Here you'd need to know that if you have
evt   A  B  C
s(0)  0   0  0 -> avg = 0/3=0.00, sort = A, B, C, schedule A, fail on B
s(1)  1   0  0 -> avg = 1/3=0.33, sort = B, C, A, schedule B, fail on C

You'd have two options:
   s(2)  1   1  0 -> avg = 2/3=0.66, sort = C, A, B, schedule A, C
or
   s(2)  1   1  0 -> avg = 2/3=0.66, sort = C, B, A  schedule C

The first is more attractive because it shortens the blind spots on C.
Both are equally fair, though. Looks like you'd need to add a 2nd
parameter to the sort when s_i are equal. That would have to be
related to the number of constraints. You could  sort in reverse order
to the number of constraints, assuming you can express the constraint
as a number. For simple constraints, such as counter restrictions, you
could simply compare the number of possible counters between events.
But there are PMU where there is no counter constraints but events are
incompatible. What values do you compare  in this case?
