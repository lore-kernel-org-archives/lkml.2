Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab1JPN2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 09:28:16 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34931 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1JPN2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 09:28:14 -0400
Date: Sun, 16 Oct 2011 15:28:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Mike Frysinger <vapier@gentoo.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, anton@samba.org
Subject: Re: [PATCH 08/11 v2] nohz: Allow rcu extended quiescent state
 handling seperately from tick stop
Message-ID: <20111016132804.GB2829@somewhere>
References: <1318004530-705-9-git-send-email-fweisbec@gmail.com>
 <1318082460-9982-1-git-send-email-fweisbec@gmail.com>
 <20111013065752.GB2430@linux.vnet.ibm.com>
 <20111013070357.GA7656@linux.vnet.ibm.com>
 <20111013125017.GH14968@somewhere>
 <20111013225136.GG2350@linux.vnet.ibm.com>
 <20111014120832.GJ14968@somewhere>
 <20111014170019.GE2428@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014170019.GE2428@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 10:00:19AM -0700, Paul E. McKenney wrote:
> On Fri, Oct 14, 2011 at 02:08:36PM +0200, Frederic Weisbecker wrote:
> > On Thu, Oct 13, 2011 at 03:51:36PM -0700, Paul E. McKenney wrote:
> > > On Thu, Oct 13, 2011 at 02:50:20PM +0200, Frederic Weisbecker wrote:
> > > > On Thu, Oct 13, 2011 at 12:03:57AM -0700, Paul E. McKenney wrote:
> > > > > On Wed, Oct 12, 2011 at 11:57:52PM -0700, Paul E. McKenney wrote:
> > > > > > On Sat, Oct 08, 2011 at 04:01:00PM +0200, Frederic Weisbecker wrote:
> > > > > > > It is assumed that rcu won't be used once we switch to tickless
> > > > > > > mode and until we restart the tick. However this is not always
> > > > > > > true, as in x86-64 where we dereference the idle notifiers after
> > > > > > > the tick is stopped.
> > > > > > > 
> > > > > > > To prepare for fixing this, add two new APIs:
> > > > > > > tick_nohz_idle_enter_norcu() and tick_nohz_idle_exit_norcu().
> > > > > > > 
> > > > > > > If no use of RCU is made in the idle loop between
> > > > > > > tick_nohz_enter_idle() and tick_nohz_exit_idle() calls, the arch
> > > > > > > must instead call the new *_norcu() version such that the arch doesn't
> > > > > > > need to call rcu_idle_enter() and rcu_idle_exit().
> > > > > > > 
> > > > > > > Otherwise the arch must call tick_nohz_enter_idle() and
> > > > > > > tick_nohz_exit_idle() and also call explicitly:
> > > > > > > 
> > > > > > > - rcu_idle_enter() after its last use of RCU before the CPU is put
> > > > > > > to sleep.
> > > > > > > - rcu_idle_exit() before the first use of RCU after the CPU is woken
> > > > > > > up.
> > > > > > 
> > > > > > Thank you, Frederic!  I have queued this to replace the earlier
> > > > > > version.  The set is available on branch rcu/dyntick of
> > > > > > 
> > > > > > 	https://github.com/paulmckrcu/linux
> > > > > 
> > > > > Which reminds me...  About the ultimate objective, getting tick-free
> > > > > operation.  (Or, for the guys who want to eliminate the tick entirely,
> > > > > shutting up the hrtimer stuff that they want to replace it with.)
> > > > > 
> > > > > I believe that you will then need to have two levels of not-in-dynticks
> > > > > for processes, one for idle vs. not and another for when a process
> > > > > switches from user-space to kernel execution.  Correct, or am I
> > > > > confused?
> > > > > 
> > > > > The reason I ask is that commit e11f5981 currently only allows one
> > > > > level of not-in-dynticks for processes.  It is easy to add another
> > > > > level, but thought I should check beforehand.
> > > > 
> > > > Hmm, yeah looking at that patch, it's going to be hard to have a nesting
> > > > that looks like:
> > > > 
> > > > rcu_irq_enter();
> > > > rcu_user_enter();
> > > > rcu_irq_exit(); <-- with effective extended quiescent state starting there
> > > 
> > > OK, so the idea here is that there has been two runnable processes on
> > > the current CPU, but during the irq handler one of them moves or some
> > > such?
> > 
> > No it happens when we have an irq in userspace and we stop the tick
> > from that irq. Noticing we are in userspace, we want to be in extended
> > quiescent state when we resume from the interrupt to userspace.
> 
> Ah, OK!
> 
> > > If so, how about a rcu_user_enter_fromirq() that sets the counter
> > > to 1 so that the rcu_irq_exit() cleans up properly?  If need be, I could
> > > of course provide an argument to allow you to specify the count offset.
> > 
> > Yeah I think that should work.
> 
> Very good.  I will start off with no argument, easy enough to add it
> later if needed.

Yeah, but for now, this is out of tree code. The functions seem quite trivial
to write so I guess I can sort it out in my tree when I'll rebase on 3.2
(if the current queue goes to the next merge window)
 
> > > > I also need to be able to call rcu_user_enter() from non-irq path.
> > > 
> > > Then rcu_user_enter_fromirq() would be for the irq path and
> > > rcu_user_enter() from the non-irq path.
> > > 
> > > Would that work for you?
> > 
> > Yep!
> 
> Very good, I will take a whack at it.  BTW, testing is going quite
> well thus far with your current patches combined with my paranoid
> idle-count approach.  One test in particular that previously failed
> reliably within minutes just successfully completed a ten-hour run.
> So things are looking up!  (Famous last words...)

Great, I cross my fingers! :)

> 
> > > > I don't truly understand the problem of the usermode helpers that
> > > > mess up the dynticks counts. May be we can somewhow fix it differently
> > > > from the offending callsite?
> > > 
> > > I tried a few approaches along these lines, but there were way too
> > > many opportunities for interruption and preemption along the way.
> > > The problem is that unless the fixup happens under a no-preempt
> > > region of code that includes the rcu_irq_enter() or rcu_irq_exit()
> > > call (as the case may be), then you end up messing up the idle-depth
> > > count of two CPUs rather than just one.  :-(
> > > 
> > > But maybe I am missing something -- suggestions more than welcome!
> > 
> > It's rather me missing everything :)
> > It happens when we call call_usermodehelper()? If so how? We have a
> > call to rcu_irq_enter() that lacks an rcu_irq_exit() ?
> 
> On powerpc, it executes the "sc" ("system call") instruction from
> kernel mode, which results in an exception.  But from what I can see,
> there is no corresponding return from exception, so my not-so-paranoid
> counting scheme would lose count.  That said, please keep in mind that
> I in no way fully understand that code.  It is also far from clear to
> me why my earlier dyntick-idle code worked in this situation -- perhaps
> the value of preempt_count() gets fixed up somehow -- I haven't really
> studied all the assembly language involved in detail, so there is lots
> of opportunity for such a fixup somewhere.
> 
> You asked!  ;-)

Haha! ;)
