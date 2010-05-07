Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab0EGKGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 06:06:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:57030 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab0EGKGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 06:06:40 -0400
Subject: Re: [RFC] perf_events: ctx_flexible_sched_in() not maximizing PMU 
 utilization
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <AANLkTimegTx_2wHCIhyLqcYbkIJEPi3SsdwgFxU4E7Rk@mail.gmail.com>
References: <AANLkTikQCkR2K438llKOh43yEgW-Bw7j0f8GoXR50A0V@mail.gmail.com>
	 <1273155640.5605.300.camel@twins> <20100506171141.GA5562@nowhere>
	 <1273167024.1642.256.camel@laptop> <1273220736.1642.318.camel@laptop>
	 <AANLkTimegTx_2wHCIhyLqcYbkIJEPi3SsdwgFxU4E7Rk@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 12:06:36 +0200
Message-ID: <1273226796.1642.333.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 11:37 +0200, Stephane Eranian wrote:

> > If we define lag to be the difference between perfect service and our
> > approximation thereof: lag_i = S - s_i, then for a scheduler to be fair
> > we must place two conditions thereon:
> >
> 
> I assume S represents the time an event would be on the PMU in the
> case of perfect scheduling. And thus S is the same for all events. The
> index i represents the event index.

Ah indeed, I should have clarified that.

> > So eligibility can be expressed as: s_i < avg(s_i).
> >
> Which would mean: if my total time on PMU is less than the average
> time on the PMU for all events thus far, then "schedule me now".

Yes, although I would state the action like: "consider me for
scheduling", since there might not be place for all eligible events on
the PMU.

[ If you start adding weights (like we do for task scheduling) this
becomes a weighted average. ]

> You would have to sort the event by increasing s_i (using the RB tree, I assume)

Exactly.

> > With this, we will get a schedule like:
> >
> > / {A, C}, {B} /
> >
> > We are however still fully greedy, which is still O(n), which we don't
> > want. However if we stop being greedy and use the same heuristic we do
> > now, stop filling the PMU at the first fail, we'll still be fair,
> > because the algorithm ensures that.
> >
> Let's see if I understand with an example. Assume the PMU multiplex
> timing is 1ms, 2 counters. s(n) = total time in ms at time n.
> 
> evt   A  B  C
> s(0)  0   0  0 -> avg = 0/3=0.00, sort = A, B, C, schedule A, fail on B
> s(1)  1   0  0 -> avg = 1/3=0.33, sort = B, C, A, schedule B, C,
> s(2)  1   1  1 -> avg = 3/3=1.00, sort = A, B, C, schedule A, fail on B
> s(3)  2   1  1 -> avg = 4/3=1.33, sort = B, C, A, schedule B, C
> s(4)  2   2  2 -> avg = 6/3=2.00, sort = A, B, C, schedule A, fail on B
> s(5)  3   2  2 -> avg = 5/3=1.66, sort = B, C, A, schedule B, C
> 
> What if there is no constraints on all 3 events?
> 
> evt   A  B  C
> s(0)  0   0  0 -> avg = 0/3=0.00, sort = A, B, C, schedule A, B
> s(1)  1   1  0 -> avg = 2/3=0.66, sort = C, A, B, schedule C (A, B > avg)
> s(2)  1   1  1 -> avg = 3/3=1.00, sort = A, B, C, schedule A, B
> s(3)  2   2  1 -> avg = 5/3=1.66, sort = C, A, B, schedule C (A, B > avg)
> s(4)  2   2  2 -> avg = 6/3=2.00, sort = B, C, A, schedule B, C
> s(5)  2   3  3 -> avg = 8/3=2.66, sort = A, B, C, schedule A (B, C > avg)
> s(6)  3   3  3 -> avg = 9/3=3.00, sort = A, B, C, schedule A, B
> 
> When all timings are equal, sort could yield any order, it would not matter
> because overtime each event will be scheduled if it lags.
> 
> Am I understanding your algorithm right?

Perfectly!

So the ramification of not using a greedy algorithm is that the
potential schedule of constrained events/groups gets longer than is
absolutely required, but I think that is something we'll have to live
with, since O(n) just isn't a nice option.

This can be illustrated if we consider B to be exclusive with both A and
C, in that case we could end up with:

/ {A}, {B}, {C} /

instead of

/ {A, C}, {B} /

Depending on the order in which we find events sorted.

