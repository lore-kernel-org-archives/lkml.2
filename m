Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab2DZRaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:30:05 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58820 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab2DZRaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:30:02 -0400
Date: Thu, 26 Apr 2012 10:28:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 4/6] rcu: Clarify help text for
 RCU_BOOST_PRIO
Message-ID: <20120426172859.GF2407@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120423164159.GA13819@linux.vnet.ibm.com>
 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335199347-13926-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335444391.13683.11.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335444391.13683.11.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042617-5806-0000-0000-000014A4A448
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 02:46:31PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-04-23 at 09:42 -0700, Paul E. McKenney wrote:
> > +         This option specifies the real-time priority to which long-term
> > +         preempted RCU readers are to be boosted.  If you are working
> > +         with a real-time application that has one or more CPU-bound
> > +         threads running at a real-time priority level,
> 
> Then your application is broken ;-) the kernel is known to mis-behave
> under these circumstances since it doesn't get to run house-keeping
> tasks. RCU is just one of these and elevating it doesn't make it work.

As you say, CPU-bound RT tasks have a number of problems, and RCU is but
one of them.  That said, an RCU-induced memory-exhaustion system hang
is an extremely unfriendly diagnostic message, and use of RCU priority
boosting allows them a better debugging environment.

> >  you should set
> > +         RCU_BOOST_PRIO to a priority higher then the highest-priority
> > +         real-time CPU-bound thread.  The default RCU_BOOST_PRIO value
> > +         of 1 is appropriate in the common case, which is real-time
> > +         applications that do not have any CPU-bound threads.
> 
> Alternatively, 1 is the worst possible choice forcing people to consider
> the issue.

You say that as if forcing people to consider the issue was a
bad thing.  ;-)

> > +         Some real-time applications might not have a single real-time
> > +         thread that saturates a given CPU, but instead might have
> > +         multiple real-time threads that, taken together, fully utilize
> > +         that CPU.  In this case, you should set RCU_BOOST_PRIO to
> > +         a priority higher than the lowest-priority thread that is
> > +         conspiring to prevent the CPU from running any non-real-time
> > +         tasks.  For example, if one thread at priority 10 and another
> > +         thread at priority 5 are between themselves fully consuming
> > +         the CPU time on a given CPU, then RCU_BOOST_PRIO should be
> > +         set to priority 6 or higher. 
> 
> I'd call this misleading, who's to say that preempting the 5 would yield
> enough time to complete the RCU work?

Yep, hence the "or higher".

> This all gets us back to the fun question of RCU delayed bandwidth
> budgeting.. ideally every 'task' that does call_rcu() should donate some
> of its budget towards the thread running the callback.

There was an academic interested in that topic a few years ago, but
I don't believe anything came of it.  An interesting approach would
be to do EDF scheduling on the callbacks themselves, but having a
separate thread for each callback sounds like overkill.

> Anyway, I'd argue both the old and new description are bonkers.

Indeed, my goal was "less bonkers" rather than "not bonkers".  A
"not bonkers" description remains a long-term aspiration rather than
a short-term goal for the moment.  I can only hope that the timeframe
is shorter than it was for RCU back in the early 1990s.  ;-)

							Thanx, Paul

