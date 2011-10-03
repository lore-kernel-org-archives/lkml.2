Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab1JCAxE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 20:53:04 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:37844 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab1JCAw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 20:52:56 -0400
Date: Sun, 2 Oct 2011 17:32:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20111003003247.GD2539@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110928123116.GP18553@somewhere>
 <20110928184025.GF2383@linux.vnet.ibm.com>
 <20110928234633.GA3537@somewhere>
 <20110929005545.GT2383@linux.vnet.ibm.com>
 <20110929123040.GB3537@somewhere>
 <20110929171205.GA2362@linux.vnet.ibm.com>
 <20110930131105.GC19053@somewhere>
 <20110930152946.GA2397@linux.vnet.ibm.com>
 <20110930192438.GA7505@linux.vnet.ibm.com>
 <20111002230753.GB1835@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111002230753.GB1835@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 01:07:56AM +0200, Frederic Weisbecker wrote:
> On Fri, Sep 30, 2011 at 12:24:38PM -0700, Paul E. McKenney wrote:
> > +#ifdef CONFIG_PROVE_RCU
> > +
> > +/*
> > + * Test whether the current CPU is idle.
> > + */
> > +int rcu_is_cpu_idle(void)
> > +{
> > +	return !rcu_dynticks_nesting;
> > +}
> 
> Seems that's not used in the patch.
> 
> > +
> > +#endif /* #ifdef CONFIG_PROVE_RCU */
> <snip>
> > +#ifdef CONFIG_PROVE_RCU
> > +
> >  /**
> > - * rcu_irq_enter - inform RCU of entry to hard irq context
> > + * rcu_is_cpu_idle - see if RCU thinks that the current CPU is idle
> >   *
> > - * If the CPU was idle with dynamic ticks active, this updates the
> > - * rdtp->dynticks to let the RCU handling know that the CPU is active.
> > + * If the current CPU is in its idle loop and is neither in an interrupt
> > + * or NMI handler, return true.  The caller must have at least disabled
> > + * preemption.
> >   */
> > -void rcu_irq_enter(void)
> > +int rcu_is_cpu_idle(void)
> >  {
> > -	rcu_exit_nohz();
> > +	return (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
> >  }
> 
> So that's not used in this patch but it's interesting for me
> to backport "rcu: Detect illegal rcu dereference in extended quiescent state".

Yep, that is why it is there.

> The above should be read from a preempt disabled section though
> (remember "rcu: Fix preempt-unsafe debug check of rcu extended quiescent state")

Yes, and that is why the last line of the header comment reads "The
caller must have at least disabled preemption."  Disabling preemption
is not necessary in Tiny RCU because there is no other CPU for the task
to go to.  (Right?)

> Those functions should probably lay in a separate patch. But I don't mind
> much keeping the things as is and use these APIs in my next patches though.
> I'll just fix the preempt enabled thing above.

Or were you saying that you wish to make calls to rcu_is_cpu_idle()
that have preemption enabled?

And I can split the patch easily enough while keeping the diff the same,
so you should be able to do your porting on top of the existing code.

And thank you very much for looking this over!

							Thanx, Paul
