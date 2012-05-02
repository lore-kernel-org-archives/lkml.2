Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2EBVdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:33:13 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34793 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab2EBVdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:33:12 -0400
Date: Wed, 2 May 2012 14:32:38 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Hugh Dickins <hughd@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: linux-next ppc64: RCU mods cause __might_sleep BUGs
Message-ID: <20120502213238.GA12153@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LSU.2.00.1204301451270.2986@eggly.anvils>
 <1335832418.20866.95.camel@pasglop>
 <alpine.LSU.2.00.1204302142310.27208@eggly.anvils>
 <20120501142208.GA2441@linux.vnet.ibm.com>
 <alpine.LSU.2.00.1205011410360.28232@eggly.anvils>
 <20120501232516.GR2441@linux.vnet.ibm.com>
 <alpine.LSU.2.00.1205021324430.24246@eggly.anvils>
 <20120502204954.GK2450@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502204954.GK2450@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050221-3270-0000-0000-000006032743
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 01:49:54PM -0700, Paul E. McKenney wrote:
> On Wed, May 02, 2012 at 01:25:30PM -0700, Hugh Dickins wrote:
> > On Tue, 1 May 2012, Paul E. McKenney wrote:
> > > > > > > On Mon, 2012-04-30 at 15:37 -0700, Hugh Dickins wrote:
> > > > > > > > 
> > > > > > > > BUG: sleeping function called from invalid context at include/linux/pagemap.h:354
> > > > > > > > in_atomic(): 0, irqs_disabled(): 0, pid: 6886, name: cc1
> > > > > > > > Call Trace:
> > > > > > > > [c0000001a99f78e0] [c00000000000f34c] .show_stack+0x6c/0x16c (unreliable)
> > > > > > > > [c0000001a99f7990] [c000000000077b40] .__might_sleep+0x11c/0x134
> > > > > > > > [c0000001a99f7a10] [c0000000000c6228] .filemap_fault+0x1fc/0x494
> > > > > > > > [c0000001a99f7af0] [c0000000000e7c9c] .__do_fault+0x120/0x684
> > > > > > > > [c0000001a99f7c00] [c000000000025790] .do_page_fault+0x458/0x664
> > > > > > > > [c0000001a99f7e30] [c000000000005868] handle_page_fault+0x10/0x30
> > 
> > Got it at last.  Embarrassingly obvious.  __rcu_read_lock() and
> > __rcu_read_unlock() are not safe to be using __this_cpu operations,
> > the cpu may change in between the rmw's read and write: they should
> > be using this_cpu operations (or, I put preempt_disable/enable in the
> > __rcu_read_unlock below).  __this_cpus there work out fine on x86,
> > which was given good instructions to use; but not so well on PowerPC.
> 
> Thank you very much for tracking this down!!!
> 
> > I've been running successfully for an hour now with the patch below;
> > but I expect you'll want to consider the tradeoffs, and may choose a
> > different solution.
> 
> The thing that puzzles me about this is that the normal path through
> the scheduler would save and restore these per-CPU variables to and
> from the task structure.  There must be a sneak path through the
> scheduler that I failed to account for.

Sigh...  I am slow today, I guess.  The preemption could of course
happen between the time that the task calculated the address of the
per-CPU variable and the time that it modified it.  If this happens,
we are modifying some other CPU's per-CPU variable.

Given that Linus saw no performance benefit from this patchset, I am
strongly tempted to just drop this inlinable-__rcu_read_lock() series
at this point.

I suppose that the other option is to move preempt_count() to a
per-CPU variable, then use the space in the task_info struct.
But that didn't generate anywhere near as good of code...

							Thanx, Paul

> But given your good work, this should be easy for me to chase down
> even on my x86-based laptop -- just convert from __this_cpu_inc() to a
> read-inc-delay-write sequence.  And check that the underlying variable
> didn't change in the meantime.  And dump an ftrace if it did.  ;-)
> 
> Thank you again, Hugh!
> 
> 							Thanx, Paul
> 
> > Hugh
> > 
> > --- 3.4-rc4-next-20120427/include/linux/rcupdate.h	2012-04-28 09:26:38.000000000 -0700
> > +++ testing/include/linux/rcupdate.h	2012-05-02 11:46:06.000000000 -0700
> > @@ -159,7 +159,7 @@ DECLARE_PER_CPU(struct task_struct *, rc
> >   */
> >  static inline void __rcu_read_lock(void)
> >  {
> > -	__this_cpu_inc(rcu_read_lock_nesting);
> > +	this_cpu_inc(rcu_read_lock_nesting);
> >  	barrier(); /* Keep code within RCU read-side critical section. */
> >  }
> > 
> > --- 3.4-rc4-next-20120427/kernel/rcupdate.c	2012-04-28 09:26:40.000000000 -0700
> > +++ testing/kernel/rcupdate.c	2012-05-02 11:44:13.000000000 -0700
> > @@ -72,6 +72,7 @@ DEFINE_PER_CPU(struct task_struct *, rcu
> >   */
> >  void __rcu_read_unlock(void)
> >  {
> > +	preempt_disable();
> >  	if (__this_cpu_read(rcu_read_lock_nesting) != 1)
> >  		__this_cpu_dec(rcu_read_lock_nesting);
> >  	else {
> > @@ -83,13 +84,14 @@ void __rcu_read_unlock(void)
> >  		barrier();  /* ->rcu_read_unlock_special load before assign */
> >  		__this_cpu_write(rcu_read_lock_nesting, 0);
> >  	}
> > -#ifdef CONFIG_PROVE_LOCKING
> > +#if 1 /* CONFIG_PROVE_LOCKING */
> >  	{
> >  		int rln = __this_cpu_read(rcu_read_lock_nesting);
> > 
> > -		WARN_ON_ONCE(rln < 0 && rln > INT_MIN / 2);
> > +		BUG_ON(rln < 0 && rln > INT_MIN / 2);
> >  	}
> >  #endif /* #ifdef CONFIG_PROVE_LOCKING */
> > +	preempt_enable();
> >  }
> >  EXPORT_SYMBOL_GPL(__rcu_read_unlock);
> > 
> > --- 3.4-rc4-next-20120427/kernel/sched/core.c	2012-04-28 09:26:40.000000000 -0700
> > +++ testing/kernel/sched/core.c	2012-05-01 22:40:46.000000000 -0700
> > @@ -2024,7 +2024,7 @@ asmlinkage void schedule_tail(struct tas
> >  {
> >  	struct rq *rq = this_rq();
> > 
> > -	rcu_switch_from(prev);
> > +	/* rcu_switch_from(prev); */
> >  	rcu_switch_to();
> >  	finish_task_switch(rq, prev);
> > 
> > @@ -7093,6 +7093,10 @@ void __might_sleep(const char *file, int
> >  		"BUG: sleeping function called from invalid context at %s:%d\n",
> >  			file, line);
> >  	printk(KERN_ERR
> > +		"cpu=%d preempt_count=%x preempt_offset=%x rcu_nesting=%x nesting_save=%x\n",
> > +		raw_smp_processor_id(), preempt_count(), preempt_offset,
> > +		rcu_preempt_depth(), current->rcu_read_lock_nesting_save); 
> > +	printk(KERN_ERR
> >  		"in_atomic(): %d, irqs_disabled(): %d, pid: %d, name: %s\n",
> >  			in_atomic(), irqs_disabled(),
> >  			current->pid, current->comm);
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 

