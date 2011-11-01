Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab1KAAfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:35:20 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49102 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650Ab1KAAfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:35:18 -0400
Date: Mon, 31 Oct 2011 17:34:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Carsten Emde <cbe@osadl.org>
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
Message-ID: <20111101003434.GR6160@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111031082634.GA10348@localhost>
 <20111031095152.GL6160@linux.vnet.ibm.com>
 <20111031104325.GA25808@localhost>
 <20111031114142.GA32555@localhost>
 <20111031121951.GM6160@linux.vnet.ibm.com>
 <1320075882.4793.4.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320075882.4793.4.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110100-9360-0000-0000-000000365FE8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 11:44:42AM -0400, Steven Rostedt wrote:
> On Mon, 2011-10-31 at 05:19 -0700, Paul E. McKenney wrote:
> > On Mon, Oct 31, 2011 at 07:41:42PM +0800, Wu Fengguang wrote:
> > > On Mon, Oct 31, 2011 at 06:43:25PM +0800, Wu Fengguang wrote:
> > > > On Mon, Oct 31, 2011 at 05:51:52PM +0800, Paul E. McKenney wrote:
> > > > > On Mon, Oct 31, 2011 at 04:26:34PM +0800, Wu Fengguang wrote:
> > > > > > Hi Paul,
> > > > > >
> > > > > > I got two warnings in rcutree.c. The last working kernels are
> > > > > > linux-next 20111014 and linux v3.1.
> > > > > 
> > > > > Interesting.  Could you please enable RCU event tracing at boot?
> > > > 
> > > > Sorry I cannot...possibly due to another ftrace bug.
> > > > 
> > > > > The RCU event tracing is at tracing/events/rcu/enable relative to
> > > > > the debugfs mount point at runtime, if that helps.
> > > > 
> > > > It's exactly that linux next 20111025 (comparing to 20111014) no
> > > > longer produces all the trace events that made me looking into the
> > > > dmesg and find the warning from RCU (rather than the expected warning
> > > > from ftrace).
> > > > 
> > > > The trace output is now:
> > > > 
> > > >         # tracer: nop
> > > >         #
> > > >         # WARNING: FUNCTION TRACING IS CORRUPTED
> > > >         #          MAY BE MISSING FUNCTION EVENTS
> > > >         #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> > > >         #              | |       |          |         |
> > > > (nothing more)
> > > 
> > > I checked the other test box and got the same warnings. Below is the
> > > full dmesg.
> > > 
> > > No single trace output again..
> > 
> > Hmmm...  I wonder if it is too early during boot for tracing to work
> > correctly.
> > 
> > Gah!  I have rcu/next set ahead to commits that are not supposed to go
> > upstream yet.  I reset it back to match the stuff that is targeted for
> > the current merge window.  Still need to find the bug, of course.
> > 
> > Anyone have any idea why the kworker thread might be trying to enter
> > the idle loop?  The idle_cpu(smp_processor_id()) call believes that
> > this is not the idle task.  Or does x86 allow non-idle tasks to enter
> > the idle loop?  Or to be migrated off-CPU?
> 
> 
> It's not. Carsten Emde noticed what looked like a bug in ftrace last
> week at LinuxCon, and looking deeper at it, I found that the swapper
> task for all but CPU0 is named kworker.  That's because kworker creates
> the idle task for all other CPUs besides CPU 0 and the idle task takes
> on kworker name.
> 
> Carsten posted a patch last week too:
> 
> https://lkml.org/lkml/2011/10/26/313
> 
> I'm glad that this bug shows up outside of just ftrace :)

That makes one of us.  ;-)

Fengguang, does Carsten's patch help?

							Thanx, Paul

