Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab2FLPfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:35:09 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60012 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2FLPfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:35:07 -0400
Date: Tue, 12 Jun 2012 08:22:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sasha Levin <levinsasha928@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: rcu,sched: spinlock recursion on 3.5-rc2
Message-ID: <20120612152252.GC2423@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1339500907.4999.99.camel@lappy>
 <alpine.LFD.2.02.1206121535180.3086@ionos>
 <20120612144705.GB2423@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206121701350.3086@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1206121701350.3086@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061215-1780-0000-0000-0000065FDEA1
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000281; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00147432; UDB=6.00033660; UTC=2012-06-12
 15:35:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 05:07:37PM +0200, Thomas Gleixner wrote:
> On Tue, 12 Jun 2012, Paul E. McKenney wrote:
> > On Tue, Jun 12, 2012 at 03:40:13PM +0200, Thomas Gleixner wrote:
> > > The torture thread got preempted. rcu_preempt_note_context_switch()
> > > tries to unlock the boosting rt mutex.
> > > 
> > > Though rcu_preempt_note_context_switch() is called with rq lock
> > > held. So it's not a surprise that the code will dead lock.
> > > 
> > > My brain hurts already from looking, so Paul to the rescue!
> > 
> > My brain hurts from beating my head on my desk.  It seems that attempts
> > to enhance PREEMPT_RCU's read-side performance require even more paranoia
> > than I normally bring to bear.  :-/
> > 
> > Please see below for what I expect is the relevant revert.
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > Revert "rcu: Move PREEMPT_RCU preemption to switch_to() invocation"
> > 
> > This reverts commit 616c310e83b872024271c915c1b9ab505b9efad9
> > (Move PREEMPT_RCU preemption to switch_to() invocation) which can
> > result in runqueue deadlock.
> 
> Hmm, not sure. The deadlock was not triggered in switch_to. It was
> just at the beginning of __schedule()
> 
> need_resched:
> 	preempt_disable();
>         cpu = smp_processor_id();
> 	rq = cpu_rq(cpu);
>         rcu_note_context_switch(cpu);
> 	
> 	Which ends up in rcu_read_unlock_special() which tries to
> 	unlock the rtmutex.
> 
> So that code is still there ....

???

rcu_note_context_switch() does not call rcu_preempt_note_context_switch()
unless the patch is reverted.  No rcu_preempt_note_context_switch(),
no rcu_read_unlock_special().

Besides which, unless I am even more confused than normal, __schedule()
doesn't hold any runqueue locks at this point.  However, those locks
really are held across the call to switch_to() in context_switch().

I bet that gcc inlined context_switch().

							Thanx, Paul

