Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857Ab0KQBZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:25:50 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51970 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932747Ab0KQBZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:25:49 -0500
Date: Tue, 16 Nov 2010 17:25:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Joe Korty <joe.korty@ccur.com>,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        houston.jim@comcast.net
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101117012544.GN2503@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101105210059.GA27317@tsunami.ccur.com>
 <4CD912E9.1080907@cn.fujitsu.com>
 <20101110155419.GC5750@nowhere>
 <1289410271.2084.25.camel@laptop>
 <20101111041920.GD3134@linux.vnet.ibm.com>
 <20101113223046.GB5445@nowhere>
 <20101116012846.GV2555@linux.vnet.ibm.com>
 <20101116135230.GA5362@nowhere>
 <20101116155104.GB2497@linux.vnet.ibm.com>
 <20101117005229.GC26243@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117005229.GC26243@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 01:52:33AM +0100, Frederic Weisbecker wrote:
> On Tue, Nov 16, 2010 at 07:51:04AM -0800, Paul E. McKenney wrote:
> > On Tue, Nov 16, 2010 at 02:52:34PM +0100, Frederic Weisbecker wrote:
> > > On Mon, Nov 15, 2010 at 05:28:46PM -0800, Paul E. McKenney wrote:
> > > > My concern is not the tick -- it is really easy to work around lack of a
> > > > tick from an RCU viewpoint.  In fact, this happens automatically given the
> > > > current implementations!  If there is a callback anywhere in the system,
> > > > then RCU will prevent the corresponding CPU from entering dyntick-idle
> > > > mode, and that CPU's clock will drive the rest of RCU as needed via
> > > > force_quiescent_state().
> > > 
> > > Now, I'm confused, I thought a CPU entering idle nohz had nothing to do
> > > if it has no local callbacks, and rcu_enter_nohz already deals with
> > > everything.
> > > 
> > > There is certainly tons of subtle things in RCU anyway :)
> > 
> > Well, I wasn't being all that clear above, apologies!!!
> > 
> > If a given CPU hasn't responded to the current RCU grace period,
> > perhaps due to being in a longer-than-average irq handler, then it
> > doesn't necessarily need its own scheduler tick enabled.  If there is a
> > callback anywhere else in the system, then there is some other CPU with
> > its scheduler tick enabled.  That other CPU can drive the slow-to-respond
> > CPU through the grace-period process.
> 
> So, the scenario is that a first CPU (CPU 0) enqueues a callback and then
> starts a new GP. But the GP is abnormally long because another CPU (CPU 1)
> takes too much time to respond. But the CPU 2 enqueues a new callback.
> 
> What you're saying is that CPU 2 will take care of the current grace period
> that hasn't finished, because it needs to start another one?
> So this CPU 2 is going to be more insistant and will then send IPIs to
> CPU 1.
> 
> Or am I completely confused? :-D

The main thing is that all CPUs that have at least one callback queued
will also have their scheduler tick enabled.  So in your example above,
both CPU 0 and CPU 2 would get insistent at about the same time.  Internal
RCU locking would choose which one of the two actually send the IPIs
(currently just resched IPIs, but can be changed fairly easily if needed).

> Ah, and if I understood well, if nobody like CPU 2 had been starting a new
> grace period, then nobody would send those IPIs?

Yep, if there are no callbacks, there is no grace period, so RCU would
have no reason to send any IPIs.  And again, this should be the common
case for HPC applications.

> Looking at the rcu tree code, the IPI is sent from the state machine in
> force_quiescent_state(), if the given CPU is not in dyntick mode.
> And force_quiescent_state() is either called from the rcu softirq
> or when one queues a callback. So, yeah, I think I understood correctly :)

Yep!!!

> But it also means that if we have two CPUs only, and CPU 0 starts a grace
> period and then goes idle. CPU 1 may never respond and the grace period
> may end in a rough while.

Well, if CPU 0 started a grace period, there must have been an RCU
callback in the system somewhere.  (Otherwise, there is an RCU bug, though
a fairly minor one -- if there are no RCU callbacks, then there isn't
too much of a problem if the needless RCU grace period takes forever.)
That RCU callback will be enqueued on one of the two CPUs, and that CPU
will keep its scheduler tick running, and thus will help the grace period
along as needed.

> > The current RCU code should work in the common case.  There are probably
> > a few bugs, but I will make you a deal.  You find them, I will fix them.
> > Particularly if you are willing to test the  fixes.
> 
> Of course :)
> 
> > > > The force_quiescent_state() workings would
> > > > want to be slightly different for dyntick-hpc, but not significantly so
> > > > (especially once I get TREE_RCU moved to kthreads).
> > > > 
> > > > My concern is rather all the implicit RCU-sched read-side critical
> > > > sections, particularly those that arch-specific code is creating.
> > > > And it recently occurred to me that there are necessarily more implicit
> > > > irq/preempt disables than there are exception entries.
> > > 
> > > Doh! You're right, I don't know why I thought that adaptive tick would
> > > solve the implicit rcu sched/bh cases, my vision took a shortcut.
> > 
> > Yeah, and I was clearly suffering from a bit of sleep deprivation when
> > we discussed this in Boston.  :-/
> 
> I suspect the real problem was my oral english understanding ;-)

Mostly I didn't think to ask if re-enabling the scheduler tick was
the only problem.  ;-)

> > > > 3.	The implicit RCU-sched read-side critical sections just work
> > > > 	as they do today.
> > > > 
> > > > Or am I missing some other problems with this approach?
> > > 
> > > No, looks good, now I'm going to implement/test a draft of these ideas.
> > > 
> > > Thanks a lot!
> > 
> > Very cool, and thank you!!!  I am sure that you will not be shy about
> > letting me know of any RCU problems that you might encounter.  ;-)
> 
> Of course not ;-)

Sounds good!  ;-)

							Thanx, Paul
