Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab2IFVJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 17:09:39 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33424 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759839Ab2IFVJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 17:09:38 -0400
Date: Thu, 6 Sep 2012 14:03:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 11/15] rcu: Avoid spurious RCU CPU stall
 warnings
Message-ID: <20120906210354.GC2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346943414.18408.31.camel@twins>
 <1346944049.1680.23.camel@gandalf.local.home>
 <1346944758.18408.35.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346944758.18408.35.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090621-5806-0000-0000-000019465382
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 05:19:18PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-09-06 at 11:07 -0400, Steven Rostedt wrote:
> > On Thu, 2012-09-06 at 16:56 +0200, Peter Zijlstra wrote:
> > > On Thu, 2012-08-30 at 11:56 -0700, Paul E. McKenney wrote:
> > > > 
> > > > If a given CPU avoids the idle loop but also avoids starting a new
> > > > RCU grace period for a full minute, RCU can issue spurious RCU CPU
> > > > stall warnings.  This commit fixes this issue by adding a check for
> > > > ongoing grace period to avoid these spurious stall warnings. 
> > > 
> > > How would it avoid starting a new period for over a minute? fqs should
> > > happen, right? And holding rcu_read_lock() for over a minute surely is a
> > > bug.
> > 
> > I can see this happening in test cases, but it would seem weird on a
> > normal system. That is, for preempt rcu, having a process scheduled out
> > holding an rcu_read_lock() for over a minute could happen on a really
> > stressed out system. But for such a case, I don't think a warning is out
> > of question.
> 
> One would hope that fqs would boost things.. but yeah, if your app is
> spinning above the rcu boost prio you're still toast. But in that case
> you're right, a warning is fully deserved.

Here are a few other ways that stalls can happen:

o	A CPU looping in an RCU read-side critical section.
	
o	A CPU looping with interrupts disabled.  This condition can
	result in RCU-sched and RCU-bh stalls.

o	A CPU looping with preemption disabled.  This condition can
	result in RCU-sched stalls and, if ksoftirqd is in use, RCU-bh
	stalls.

o	A CPU looping with bottom halves disabled.  This condition can
	result in RCU-sched and RCU-bh stalls.

o	For !CONFIG_PREEMPT kernels, a CPU looping anywhere in the kernel
	without invoking schedule().

o	A CPU-bound real-time task in a CONFIG_PREEMPT kernel, which might
	happen to preempt a low-priority task in the middle of an RCU
	read-side critical section.   This is especially damaging if
	that low-priority task is not permitted to run on any other CPU,
	in which case the next RCU grace period can never complete, which
	will eventually cause the system to run out of memory and hang.
	While the system is in the process of running itself out of
	memory, you might see stall-warning messages.

o	A CPU-bound real-time task in a CONFIG_PREEMPT_RT kernel that
	is running at a higher priority than the RCU softirq threads.
	This will prevent RCU callbacks from ever being invoked,
	and in a CONFIG_TREE_PREEMPT_RCU kernel will further prevent
	RCU grace periods from ever completing.  Either way, the
	system will eventually run out of memory and hang.  In the
	CONFIG_TREE_PREEMPT_RCU case, you might see stall-warning
	messages.

o	A hardware or software issue shuts off the scheduler-clock
	interrupt on a CPU that is not in dyntick-idle mode.  This
	problem really has happened, and seems to be most likely to
	result in RCU CPU stall warnings for CONFIG_NO_HZ=n kernels.

o	A bug in the RCU implementation.

o	A hardware failure.  This is quite unlikely, but has occurred
	at least once in real life.  A CPU failed in a running system,
	becoming unresponsive, but not causing an immediate crash.
	This resulted in a series of RCU CPU stall warnings, eventually
	leading the realization that the CPU had failed.

							Thanx, Paul

