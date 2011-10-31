Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab1KAA2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 20:28:32 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49494 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569Ab1KAA2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 20:28:31 -0400
Date: Mon, 31 Oct 2011 15:14:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, peterz@infradead.org
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
Message-ID: <20111031221416.GQ6160@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111031082634.GA10348@localhost>
 <20111031095152.GL6160@linux.vnet.ibm.com>
 <20111031104325.GA25808@localhost>
 <20111031114142.GA32555@localhost>
 <20111031123125.GA6162@localhost>
 <20111031123708.GA6839@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111031123708.GA6839@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110100-5806-0000-0000-0000007CB468
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 08:37:08PM +0800, Wu Fengguang wrote:
> On Mon, Oct 31, 2011 at 08:31:25PM +0800, Wu Fengguang wrote:
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
> > 
> > Here is another dmesg showing the warnings inside kvm.
> > 
> > btw, I turned on the ftrace self tests and it shows a warning, too.
> 
> The trace events magically show up after enabling the ftrace self
> tests. Here are some of them collected in the original test box.
> Hope it helps.

Indeed it does!

Peter, I have been using "idle_cpu(smp_processor_id()))" to verify that
I really am running in the context of the idle task when RCU believes
that the current CPU has gone idle.  This is apparently the wrong thing
to use, because it gives spurious warnings when bringing up the non-boot
CPUs on x86 under some configs -- the task running at that point appears
to be kworker/0:0 rather than an idle thread.

At other times I get the warning even though the trace-event system is
convinced that I am running in the context of an idle thread, for example,
as in the following trace output:

<idle>-0     [000]    29.985355: rcu_dyntick: Error on entry: not idle task 0

On the left, trace-events thinks that this is the idle task, but the
check idle_cpu(smp_processor_id())) says otherwise.

Help?

							Thanx, Paul

