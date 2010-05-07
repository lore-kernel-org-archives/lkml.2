Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0EGIZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 04:25:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:53594 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab0EGIZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 04:25:41 -0400
Subject: Re: [RFC] perf_events: ctx_flexible_sched_in() not maximizing PMU
 utilization
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1273167024.1642.256.camel@laptop>
References: <AANLkTikQCkR2K438llKOh43yEgW-Bw7j0f8GoXR50A0V@mail.gmail.com>
	 <1273155640.5605.300.camel@twins>  <20100506171141.GA5562@nowhere>
	 <1273167024.1642.256.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 10:25:36 +0200
Message-ID: <1273220736.1642.318.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 19:30 +0200, Peter Zijlstra wrote:
> On Thu, 2010-05-06 at 19:11 +0200, Frederic Weisbecker wrote:
> 
> > > But yeah, I did think of making the thing an RB-tree and basically
> > > schedule on service received, that should fix the lop-sided RR we get
> > > with constrained events.
> 
> > I don't understand what you mean by schedule on service received, and why
> > an rbtree would solve that.
> 
> Schedule those events that got scheduled least, if because of
> constraints we didn't fully utilize the PMU it is very likely that
> strict RR (like we do now) will not end up giving equal service to each
> counter/group.
> 
> Therefore, if you sort them in a tree, based on the amount of time they
> got on the PMU, and always schedule the leftmost, you do get fairness.


OK a simple example, suppose we have 3 events, A, B and C. A and B are
exclusive. With the current RR scheduling we get:

/ {A}, {B, C}, {C, A} /

Which isn't fair, because we get a 2:1:2 ratio.

If we were to do as Stephane suggested and always schedule the PMU in a
greedy fashion, we'd get:

/ {A, C}, {B, C} /

Which isn't fair either 1:1:2.


The perfect case would be if we could always schedule all events on the
PMU, that way they'd get equal service. But since we cannot, we much
approximate that.

If we define lag to be the difference between perfect service and our
approximation thereof: lag_i = S - s_i, then for a scheduler to be fair
we must place two conditions thereon:

 1) There must be a bound on the maximal lag_i, this ensures progress.
 2) The sum of lags must be zero, this ensures we converge to the ideal
    service. [*]

We can satisfy 1 by always at least scheduling the event which has thus
far received the least service, this ensures everybody makes progress,
since by definition everybody will at one point be that one.

This by itself however is not enough, since we can schedule multiple
events, lets again try a greedy model with the previous example. That
would again reduce to the unfair:

/ {A, C}, {B, C} /

Simply because C is always schedulable and A and B alternate between
being the one who received least service.

This would however violate 2, since C will always be scheduled, its lag
will decrease without bound.

We can fix this by explicitly not scheduling C when its not eligible.
That is, we only consider eligible events for placement on the PMU.
Eligibility means an event has received less service than it would have
had under the perfect model.

The second condition will help us here: \Sum_i S - s_i = 0. That can be
written as: n*S - \Sum s_i = 0, where n = \Sum_i 1. From this it
trivially follows that: S = 1/n \Sum s_i, or in other words S =
avg(s_i).

So eligibility can be expressed as: s_i < avg(s_i).

With this, we will get a schedule like:

/ {A, C}, {B} /

We are however still fully greedy, which is still O(n), which we don't
want. However if we stop being greedy and use the same heuristic we do
now, stop filling the PMU at the first fail, we'll still be fair,
because the algorithm ensures that.


[*] it might be possible these conditions are the same one.

