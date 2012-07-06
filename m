Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030312Ab2GFLwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:52:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56344 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030243Ab2GFLwd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:52:33 -0400
Message-ID: <1341575532.7709.47.camel@twins>
Subject: Re: [PATCH 09/16] sched: normalize tg load contributions against
 runnable time
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Fri, 06 Jul 2012 13:52:12 +0200
In-Reply-To: <1341431285.19870.15.camel@laptop>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
	 <20120628022414.30496.11931.stgit@kitami.mtv.corp.google.com>
	 <1341431285.19870.15.camel@laptop>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-04 at 21:48 +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-27 at 19:24 -0700, Paul Turner wrote:
> > Entities of equal weight should receive equitable distribution of cpu time.
> > This is challenging in the case of a task_group's shares as execution may be
> > occurring on multiple cpus simultaneously.
> > 
> > To handle this we divide up the shares into weights proportionate with the load
> > on each cfs_rq.  This does not however, account for the fact that the sum of
> > the parts may be less than one cpu and so we need to normalize:
> >   load(tg) = min(runnable_avg(tg), 1) * tg->shares
> > Where runnable_avg is the aggregate time in which the task_group had runnable
> > children. 
> 
> I remember we had a bit of a discussion on this last time, I thought you
> were going to convince me this approximation was 'right'.
> 
> Care to still do so.. the rationale used should at least live in a
> comment somewhere, otherwise someone will go silly trying to understand
> things later on.

So if we treat the per-cpu utilization u_i as probability, then we're
looking for:

  P(\Union_{i=1..n} u_i) := 
	\Sum_{k=1..n} (-1)^(k-1) P(\Intersection_{i=1..k} u_i)

Computing this however is far too expensive, what we can do is
approximate by setting u = avg(u_i) and then using:

  u_i == u_j for all i,j

and assuming all variables are independent, giving us:

  P(A \Intersection B) = P(A)P(B)

This then yields:

  P(\Union_{i=1..n} u_i) ~= \Sum_{k=1..n} (-1)^(k-1) (n choose k) u^k

Which unfortunately isn't a series I found a sane solution for, but
numerically (see below) we can see it very quickly approaches 1 when n
>> 1.

Therefore, the chosen approximation of min(1, \Sum_i u_i) is indeed a
sane approximation since for very small u_i and/or small n the sum is
less likely to exceed 1 and for big u_i and/or big n the clip to 1 is
indeed correct.

*phew*

Was this what you meant? :-)

Now all that is left is grok the actual code..


probability_union.bc
---


define f (x) {
	if (x <= 1) return (1);
	return (f(x-1) * x);
}

define choose (n,k) {
	return f(n) / (f(n-k) * f(k));
}

define pu (p,n) {
	auto s, k

	s = 0;
	for (k = 1; k <= n; k++) {
		s += (-1)^(k-1) * choose(n,k) * p^k;
	}

	return s;
}


for (n=2; n<128; n*=2) {
	print n, ": "
	for (p = 1; p < 11; p++) {
		print pu(p/10,n), " "
	}
	print "\n"
}
quit
