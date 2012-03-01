Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966269Ab2CANVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 08:21:21 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:35737 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757985Ab2CANVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 08:21:19 -0500
Date: Thu, 1 Mar 2012 05:20:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH 2/2 RFC] srcu: implement Peter's checking algorithm
Message-ID: <20120301131957.GA2412@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F44B580.6040003@cn.fujitsu.com>
 <4F4744E9.1060109@cn.fujitsu.com>
 <20120224200109.GH2399@linux.vnet.ibm.com>
 <4F4B3840.6000504@cn.fujitsu.com>
 <20120227183035.GE2463@linux.vnet.ibm.com>
 <4F4C331A.7090007@cn.fujitsu.com>
 <20120228134718.GF2465@linux.vnet.ibm.com>
 <4F4DF8E4.1070100@cn.fujitsu.com>
 <20120229135508.GB2385@linux.vnet.ibm.com>
 <4F4EDF7A.6060607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4EDF7A.6060607@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030113-7282-0000-0000-000006FEA77A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 10:31:22AM +0800, Lai Jiangshan wrote:
> On 02/29/2012 09:55 PM, Paul E. McKenney wrote:
> > On Wed, Feb 29, 2012 at 06:07:32PM +0800, Lai Jiangshan wrote:
> >> On 02/28/2012 09:47 PM, Paul E. McKenney wrote:
> >>> On Tue, Feb 28, 2012 at 09:51:22AM +0800, Lai Jiangshan wrote:
> >>>> On 02/28/2012 02:30 AM, Paul E. McKenney wrote:
> >>>>> On Mon, Feb 27, 2012 at 04:01:04PM +0800, Lai Jiangshan wrote:
> >>>>>> >From 40724998e2d121c2b5a5bd75114625cfd9d4f9a9 Mon Sep 17 00:00:00 2001
> >>>>>> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> >>>>>> Date: Mon, 27 Feb 2012 14:22:47 +0800
> >>>>>> Subject: [PATCH 2/2] srcu: implement Peter's checking algorithm
> >>>>>>
> >>>>>> This patch implement the algorithm as Peter's:
> >>>>>> https://lkml.org/lkml/2012/2/1/119
> >>>>>>
> >>>>>> o	Make the checking lock-free and we can perform parallel checking,
> >>>>>> 	Although almost parallel checking makes no sense, but we need it
> >>>>>> 	when 1) the original checking task is preempted for long, 2)
> >>>>>> 	sychronize_srcu_expedited(), 3) avoid lock(see next)
> >>>>>>
> >>>>>> o	Since it is lock-free, we save a mutex in state machine for
> >>>>>> 	call_srcu().
> >>>>>>
> >>>>>> o	Remove the SRCU_REF_MASK and remove the coupling with the flipping.
> >>>>>> 	(so we can remove the preempt_disable() in future, but use
> >>>>>> 	 __this_cpu_inc() instead.)
> >>>>>>
> >>>>>> o	reduce a smp_mb(), simplify the comments and make the smp_mb() pairs
> >>>>>> 	more intuitive.
> >>>>>
> >>>>> Hello, Lai,
> >>>>>
> >>>>> Interesting approach!
> >>>>>
> >>>>> What happens given the following sequence of events?
> >>>>>
> >>>>> o	CPU 0 in srcu_readers_active_idx_check() invokes
> >>>>> 	srcu_readers_seq_idx(), getting some number back.
> >>>>>
> >>>>> o	CPU 0 invokes srcu_readers_active_idx(), summing the
> >>>>> 	->c[] array up through CPU 3.
> >>>>>
> >>>>> o	CPU 1 invokes __srcu_read_lock(), and increments its counter
> >>>>> 	but not yet its ->seq[] element.
> >>>>
> >>>>
> >>>> Any __srcu_read_lock() whose increment of active counter is not seen
> >>>> by srcu_readers_active_idx() is considerred as
> >>>> "reader-started-after-this-srcu_readers_active_idx_check()",
> >>>> We don't need to wait.
> >>>>
> >>>> As you said, this srcu C.S 's increment seq is not seen by above
> >>>> srcu_readers_seq_idx().
> >>>>
> >>>>>
> >>>>> o	CPU 0 completes its summing of the ->c[] array, incorrectly
> >>>>> 	obtaining zero.
> >>>>>
> >>>>> o	CPU 0 invokes srcu_readers_seq_idx(), getting the same
> >>>>> 	number back that it got last time.
> >>>>
> >>>> If it incorrectly get zero, it means __srcu_read_unlock() is seen
> >>>> in srcu_readers_active_idx(), and it means the increment of
> >>>> seq is seen in this srcu_readers_seq_idx(), it is different
> >>>> from the above seq that it got last time.
> >>>>
> >>>> increment of seq is not seen by above srcu_readers_seq_idx(),
> >>>> but is seen by later one, so the two returned seq is different,
> >>>> this is the core of Peter's algorithm, and this was written
> >>>> in the comments(Sorry for my bad English). Or maybe I miss
> >>>> your means in this mail.
> >>>
> >>> OK, good, this analysis agrees with what I was thinking.
> >>>
> >>> So my next question is about the lock freedom.  This lock freedom has to
> >>> be limited in nature and carefully implemented.  The reasons for this are:
> >>>
> >>> 1.	Readers can block in any case, which can of course block both
> >>> 	synchronize_srcu_expedited() and synchronize_srcu().
> >>>
> >>> 2.	Because only one CPU at a time can be incrementing ->completed,
> >>> 	some sort of lock with preemption disabling will of course be
> >>> 	needed.  Alternatively, an rt_mutex could be used for its
> >>> 	priority-inheritance properties.
> >>>
> >>> 3.	Once some CPU has incremented ->completed, all CPUs that might
> >>> 	still be summing up the old indexes must stop.  If they don't,
> >>> 	they might incorrectly call a too-short grace period in case of
> >>> 	->seq[]-sum overflow on 32-bit systems.
> >>>
> >>> Or did you have something else in mind?
> >>
> >> When flip happens when check_zero, this check_zero will no be
> >> committed even it is success.
> > 
> > But if the CPU in check_zero isn't blocking the grace period, then
> > ->completed could overflow while that CPU was preempted.  Then how
> > would this CPU know that the flip had happened?
> 
> as you said, check the ->completed.
> but disable the overflow for ->completed.
> 
> there is a spinlock for srcu_struct(including locking for flipping)
> 
> 1) assume we need to wait on widx
> 2) use srcu_read_lock() to hold a reference of the 1-widx active counter
> 3) release the spinlock
> 4) do_check_zero
> 5) gain the spinlock
> 6) srcu_read_unlock()
> 7) if ->completed is not changed, and there is no other later check_zero which
>    is committed earlier than us, we will commit our check_zero if we success.
> 
> too complicated.

Plus I don't see how it disables overflow for ->completed.

As you said earlier, abandoning the goal of lock freedom sounds like the
best approach.  Then you can indeed just hold the srcu_struct's mutex
across the whole thing.

							Thanx, Paul

> Thanks,
> Lai
> 
> > 
> >> I play too much with lock-free for call_srcu(), the code becomes complicated,
> >> I just give up lock-free for call_srcu(), the main aim of call_srcu() is simple.
> > 
> > Makes sense to me!
> > 
> >> (But I still like Peter's approach, it has some other good thing
> >> besides lock-free-checking, if you don't like it, I will send
> >> another patch to fix srcu_readers_active())
> > 
> > Try them both and check their performance &c.  If within espilon of
> > each other, pick whichever one you prefer.
> > 
> > 							Thanx, Paul
> 

