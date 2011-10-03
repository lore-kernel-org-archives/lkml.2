Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab1JCM7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 08:59:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40448 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab1JCM7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 08:59:08 -0400
Date: Mon, 3 Oct 2011 14:59:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20111003125858.GC1835@somewhere>
References: <20110928184025.GF2383@linux.vnet.ibm.com>
 <20110928234633.GA3537@somewhere>
 <20110929005545.GT2383@linux.vnet.ibm.com>
 <20110929123040.GB3537@somewhere>
 <20110929171205.GA2362@linux.vnet.ibm.com>
 <20110930131105.GC19053@somewhere>
 <20110930152946.GA2397@linux.vnet.ibm.com>
 <20110930192438.GA7505@linux.vnet.ibm.com>
 <20111002225019.GA1835@somewhere>
 <20111003002832.GC2539@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003002832.GC2539@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 05:28:32PM -0700, Paul E. McKenney wrote:
> On Mon, Oct 03, 2011 at 12:50:22AM +0200, Frederic Weisbecker wrote:
> > On Fri, Sep 30, 2011 at 12:24:38PM -0700, Paul E. McKenney wrote:
> > > @@ -328,11 +326,11 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
> > >  		return 1;
> > >  	}
> > >  
> > > -	/* If preemptible RCU, no point in sending reschedule IPI. */
> > > -	if (rdp->preemptible)
> > > -		return 0;
> > > -
> > > -	/* The CPU is online, so send it a reschedule IPI. */
> > > +	/*
> > > +	 * The CPU is online, so send it a reschedule IPI.  This forces
> > > +	 * it through the scheduler, and (inefficiently) also handles cases
> > > +	 * where idle loops fail to inform RCU about the CPU being idle.
> > > +	 */
> > 
> > If the idle loop forgets to call rcu_idle_enter() before going to
> > sleep, I don't know if it's a good idea to try to cure that situation
> > by forcing a quiescent state remotely. It may make the thing worse
> > because we actually won't notice the lack of call to rcu_idle_enter()
> > that the rcu stall detector would otherwise report to us.
> > 
> > Also I don't think that works. If the task doesn't have
> > TIF_RESCHED, it won't go through the scheduler on irq exit.
> > smp_send_reschedule() doesn't set the flag. And also scheduler_ipi()
> > returns right away if no wake up is pending.
> > 
> > So, other than resuming the idle loop to sleep again, nothing may happen.
> > 
> > Or am I missing something?
> 
> Hmmm...  Seems like the IPIs aren't helping in any case, then?

I thought it was there for !PREEMPT cases where the task has TIF_RESCHED
but takes too much time to find an opportunity to go to sleep.
 
> I suppose that I could do an smp_call_function_single(), which then
> did a set_need_resched()...
> 
> But this is a separate issue that I need to deal with.  That said, any
> suggestions are welcome!

Note you can't call smp_call_function_*() while irqs are disabled.

Perhaps you need something like kernel/sched.c:resched_cpu()
This adds some rq->lock contention though.
