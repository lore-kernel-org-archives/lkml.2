Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab2BVV1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 16:27:08 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:39765 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab2BVV1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 16:27:03 -0500
Date: Wed, 22 Feb 2012 13:26:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH 2/3 RFC paul/rcu/srcu] srcu: only increase the upper bit
 for srcu_read_lock()
Message-ID: <20120222212630.GA6759@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120213020951.GA12138@linux.vnet.ibm.com>
 <4F41F315.1040900@cn.fujitsu.com>
 <20120220174418.GI2470@linux.vnet.ibm.com>
 <4F42EF53.6060400@cn.fujitsu.com>
 <20120221015037.GE2384@linux.vnet.ibm.com>
 <4F435966.9020106@cn.fujitsu.com>
 <20120221172442.GG2375@linux.vnet.ibm.com>
 <4F44B57C.3020104@cn.fujitsu.com>
 <20120222212056.GJ2416@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120222212056.GJ2416@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022221-3352-0000-0000-000002D332E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 01:20:56PM -0800, Paul E. McKenney wrote:
> On Wed, Feb 22, 2012 at 05:29:32PM +0800, Lai Jiangshan wrote:
> > >From de49bb517e6367776e2226b931346ab6c798b122 Mon Sep 17 00:00:00 2001
> > From: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Date: Wed, 22 Feb 2012 10:41:59 +0800
> > Subject: [PATCH 2/3 RFC paul/rcu/srcu] srcu: only increase the upper bit for srcu_read_lock()
> > 
> > The algorithm/smp_mb()s ensure 'there is only one srcu_read_lock()
> > between flip and recheck for a cpu'.
> > Increment of the upper bit for srcu_read_lock() only can
> > ensure a single pair of lock/unlock change the cpu counter.
> 
> Very nice!  Also makes is more clear in that no combination of operations
> including exactly one increment can possibly wrap back to the same value,
> because the upper bit would be different.

Make that without underflow -- one increment and 2^31+1 decrements would
in fact return the counter to its original value, but that would require
cramming more than two billion tasks into a 32-bit address space, which
I believe to be sufficiently unlikely.  (Famous last words...)

							Thanx, Paul

> In deference to Peter Zijlstra's sensibilities, I changed the:
> 
> 	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += -1;
> 
> to:
> 
> 	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) -= 1;
> 
> I did manage to resist the temptation to instead say:
> 
> 	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) -= +1;
> 
> ;-)
> 
> Queued, thank you!
> 
> 							Thanx, Paul
> 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> >  include/linux/srcu.h |    2 +-
> >  kernel/srcu.c        |   11 +++++------
> >  2 files changed, 6 insertions(+), 7 deletions(-)
> > 
> > diff --git a/include/linux/srcu.h b/include/linux/srcu.h
> > index a478c8e..5b49d41 100644
> > --- a/include/linux/srcu.h
> > +++ b/include/linux/srcu.h
> > @@ -35,7 +35,7 @@ struct srcu_struct_array {
> >  };
> > 
> >  /* Bit definitions for field ->c above and ->snap below. */
> > -#define SRCU_USAGE_BITS		2
> > +#define SRCU_USAGE_BITS		1
> >  #define SRCU_REF_MASK		(ULONG_MAX >> SRCU_USAGE_BITS)
> >  #define SRCU_USAGE_COUNT	(SRCU_REF_MASK + 1)
> > 
> > diff --git a/kernel/srcu.c b/kernel/srcu.c
> > index 17e95bc..a51ac48 100644
> > --- a/kernel/srcu.c
> > +++ b/kernel/srcu.c
> > @@ -138,10 +138,10 @@ static bool srcu_readers_active_idx_check(struct srcu_struct *sp, int idx)
> > 
> >  	/*
> >  	 * Now, we check the ->snap array that srcu_readers_active_idx()
> > -	 * filled in from the per-CPU counter values.  Since both
> > -	 * __srcu_read_lock() and __srcu_read_unlock() increment the
> > -	 * upper bits of the per-CPU counter, an increment/decrement
> > -	 * pair will change the value of the counter.  Since there is
> > +	 * filled in from the per-CPU counter values. Since
> > +	 * __srcu_read_lock() increments the upper bits of
> > +	 * the per-CPU counter, an increment/decrement pair will
> > +	 * change the value of the counter.  Since there is
> >  	 * only one possible increment, the only way to wrap the counter
> >  	 * is to have a huge number of counter decrements, which requires
> >  	 * a huge number of tasks and huge SRCU read-side critical-section
> > @@ -234,8 +234,7 @@ void __srcu_read_unlock(struct srcu_struct *sp, int idx)
> >  {
> >  	preempt_disable();
> >  	smp_mb(); /* C */  /* Avoid leaking the critical section. */
> > -	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) +=
> > -		SRCU_USAGE_COUNT - 1;
> > +	ACCESS_ONCE(this_cpu_ptr(sp->per_cpu_ref)->c[idx]) += -1;
> >  	preempt_enable();
> >  }
> >  EXPORT_SYMBOL_GPL(__srcu_read_unlock);
> > -- 
> > 1.7.4.4
> > 

