Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350Ab2IFUCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:02:16 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42516 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab2IFUCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:02:14 -0400
Date: Thu, 6 Sep 2012 13:01:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 23/23] rcu: Simplify quiescent-state
 detection
Message-ID: <20120906200138.GR2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-23-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346942162.18408.25.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346942162.18408.25.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090620-7408-0000-0000-000008437697
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 04:36:02PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-08-30 at 11:18 -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > The current quiescent-state detection algorithm is needlessly
> > complex.
> 
> Heh! Be careful, we might be led into believing all this RCU is actually
> really rather simple and this complexity is a bug on your end ;-)

Actually, the smallest "toy" implementation of RCU is only about 20
lines of code -- and on a mythical sequentially consistent system, it
would be smaller still.  Of course, the Linux kernel implementation if
somewhat larger.  Something about wanting scalability above a few tens of
CPUs, real-time response (also on huge numbers of CPUs), energy-efficient
handling of dyntick-idle mode, detection of stalled CPUs, and so on.  ;-)

> >   It records the grace-period number corresponding to
> > the quiescent state at the time of the quiescent state, which
> > works, but it seems better to simply erase any record of previous
> > quiescent states at the time that the CPU notices the new grace
> > period.  This has the further advantage of removing another piece
> > of RCU for which lockless reasoning is required. 
> 
> So why didn't you do that from the start? :-)

Because I was slow and stupid!  ;-)

> That is, I'm curious to know some history, why was it so and what led
> you to this insight?

I had historically (as in for almost 20 years now) used a counter
to track grace periods.  Now these are in theory subject to integer
overflow, but DYNIX/ptx was non-preemptible, so the general line of
reasoning was that anything that might stall long enough for even a 32-bit
grace-period counter to overflow would necessarily stall grace periods,
thus preventing overflow.

Of course, the advent of CONFIG_PREEMPT in the Linux kernel invalidated
this assumption, but for most uses, if the grace-period counter overflows,
you have waited way more than a grace period, so who cares?

Then combination of TREE_RCU and dyntick-idle came along, and it became
necessary to more carefully associate quiescent states with the corresponding
grace period.  Now here overflow is dangerous, because it can result in
associating an ancient quiescent state with the current grace period.
But my attitude was that if you have a task preempted for more than one
year, getting soft-lockup warnings every two minutes during that time,
well, you got what you deserved.  And even then at very low probability.

However, formal validation software (such as Promela) do not take kindly
to free-running counters.  The usual trick is to use a much narrower
counter.  But that would mean that any attempted mechanical validation
would give a big fat false positive on the counter used to associate
quiescent states with grace periods.  Because I have a long-term goal
of formally validating RCU is it sits in the Linux kernel, that counter
had to go.

And I do believe that the result is easier for humans to understand, so
it is all to the good.

This time, at least.  ;-)

							Thanx, Paul

