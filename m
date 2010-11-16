Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084Ab0KPB2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 20:28:53 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38353 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759064Ab0KPB2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 20:28:52 -0500
Date: Mon, 15 Nov 2010 17:28:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Joe Korty <joe.korty@ccur.com>,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, josh@joshtriplett.org,
        houston.jim@comcast.net
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101116012846.GV2555@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101104232148.GA28037@linux.vnet.ibm.com>
 <20101105210059.GA27317@tsunami.ccur.com>
 <4CD912E9.1080907@cn.fujitsu.com>
 <20101110155419.GC5750@nowhere>
 <1289410271.2084.25.camel@laptop>
 <20101111041920.GD3134@linux.vnet.ibm.com>
 <20101113223046.GB5445@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101113223046.GB5445@nowhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 11:30:49PM +0100, Frederic Weisbecker wrote:
> On Wed, Nov 10, 2010 at 08:19:20PM -0800, Paul E. McKenney wrote:
> > On Wed, Nov 10, 2010 at 06:31:11PM +0100, Peter Zijlstra wrote:
> > > On Wed, 2010-11-10 at 16:54 +0100, Frederic Weisbecker wrote:
> > > > run the sched tick and if there was nothing to do
> > > > for some time and we are in userspace, deactivate it. 
> > > 
> > > Not for some time, immediately, have the tick track if it was useful, if
> > > it was not, have it stop itself, like:
> > > 
> > > tick()
> > > {
> > >  int stop = 1;
> > > 
> > >  if (nr_running > 1)
> > >   stop = 0;
> > > 
> > >  if(rcu_needs_cpu())
> > >   stop = 0;
> > > 
> > >  ...
> > > 
> > > 
> > >  if (stop)
> > >   enter_nohz_mode();
> > > }
> > 
> > I am still holding out for a dyntick-hpc version of RCU that does not
> > need the tick.  ;-)
> 
> 
> So you don't think it would be an appropriate solution? Keeping the tick for short
> periods of time while we need it only, that looks quite a good way to try.

My concern is not the tick -- it is really easy to work around lack of a
tick from an RCU viewpoint.  In fact, this happens automatically given the
current implementations!  If there is a callback anywhere in the system,
then RCU will prevent the corresponding CPU from entering dyntick-idle
mode, and that CPU's clock will drive the rest of RCU as needed via
force_quiescent_state().  The force_quiescent_state() workings would
want to be slightly different for dyntick-hpc, but not significantly so
(especially once I get TREE_RCU moved to kthreads).

My concern is rather all the implicit RCU-sched read-side critical
sections, particularly those that arch-specific code is creating.
And it recently occurred to me that there are necessarily more implicit
irq/preempt disables than there are exception entries.

So would you be OK with telling RCU about kernel entries/exits, but
simply not enabling the tick?  The irq and NMI kernel entries/exits are
already covered, of course.

This seems to me to work out as follows:

1.	If there are no RCU callbacks anywhere in the system, RCU
	is quiescent and does not cause any IPIs or interrupts of
	any kind.  For HPC workloads, this should be the common case.

2.	If there is an RCU callback, then one CPU keeps a tick going
	and drives RCU core processing on all CPUs.  (This probably
	works with RCU as is, but somewhat painfully.)  This results
	in some IPIs, but only to those CPUs that remain running in
	the kernel for extended time periods.  Appropriate adjustment
	of RCU_JIFFIES_TILL_FORCE_QS, possibly promoted to be a
	kernel configuration parameter, should make such IPIs
	-extremely- rare.  After all, how many kernel code paths
	are going to consume (say) 10 jiffies of CPU time?  (Keep
	in mind that if the system call blocks, the CPU will enter
	dyntick-idle mode, and RCU will still recognize it as an
	innocent bystander without needing to IPI it.)

3.	The implicit RCU-sched read-side critical sections just work
	as they do today.

Or am I missing some other problems with this approach?

							Thanx, Paul
