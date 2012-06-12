Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2FLPHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:07:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:44343 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab2FLPHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:07:45 -0400
Date: Tue, 12 Jun 2012 17:07:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Sasha Levin <levinsasha928@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: rcu,sched: spinlock recursion on 3.5-rc2
In-Reply-To: <20120612144705.GB2423@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.02.1206121701350.3086@ionos>
References: <1339500907.4999.99.camel@lappy> <alpine.LFD.2.02.1206121535180.3086@ionos> <20120612144705.GB2423@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2012, Paul E. McKenney wrote:
> On Tue, Jun 12, 2012 at 03:40:13PM +0200, Thomas Gleixner wrote:
> > The torture thread got preempted. rcu_preempt_note_context_switch()
> > tries to unlock the boosting rt mutex.
> > 
> > Though rcu_preempt_note_context_switch() is called with rq lock
> > held. So it's not a surprise that the code will dead lock.
> > 
> > My brain hurts already from looking, so Paul to the rescue!
> 
> My brain hurts from beating my head on my desk.  It seems that attempts
> to enhance PREEMPT_RCU's read-side performance require even more paranoia
> than I normally bring to bear.  :-/
> 
> Please see below for what I expect is the relevant revert.
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> Revert "rcu: Move PREEMPT_RCU preemption to switch_to() invocation"
> 
> This reverts commit 616c310e83b872024271c915c1b9ab505b9efad9
> (Move PREEMPT_RCU preemption to switch_to() invocation) which can
> result in runqueue deadlock.

Hmm, not sure. The deadlock was not triggered in switch_to. It was
just at the beginning of __schedule()

need_resched:
	preempt_disable();
        cpu = smp_processor_id();
	rq = cpu_rq(cpu);
        rcu_note_context_switch(cpu);
	
	Which ends up in rcu_read_unlock_special() which tries to
	unlock the rtmutex.

So that code is still there ....

Thanks,

	tglx
