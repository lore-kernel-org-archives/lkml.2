Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab0FYGXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 02:23:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:37588 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab0FYGW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 02:22:59 -0400
Date: Fri, 25 Jun 2010 16:22:50 +1000
From: Nick Piggin <npiggin@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 05/52] lglock: introduce special lglock and brlock spin
 locks
Message-ID: <20100625062250.GS10441@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030726.371426768@suse.de>
 <alpine.LFD.2.00.1006241904160.2911@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006241904160.2911@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 08:15:54PM +0200, Thomas Gleixner wrote:
> On Thu, 24 Jun 2010, npiggin@suse.de wrote:
> 
> > +#define DEFINE_LGLOCK(name)						\
> > +									\
> > + DEFINE_PER_CPU(arch_spinlock_t, name##_lock);				\
> 
> Uuurgh. You want to make that an arch_spinlock ? Just to avoid the
> preempt_count overflow when you lock all cpu locks nested ?

Yep, and the lockdep wreckage too :)

Actually it's nice to avoid the function call too (lglock/brlocks
are already out of line). Calls aren't totally free, especially
on small chips without RSBs. And even with RSBs it's helpful not
to overflow them, although Nehalem seems to have 12-16 entries.
 

> I'm really not happy about that, it's going to be a complete nightmare
> for RT. If you wanted to make this a present for RT giving the
> scalability stuff massive testing, then you failed miserably :)

Heh, it's a present for -rt because the locking is quite isolated
(I did the same thing with hashtable bitlocks, added a new structure
for them, in case you prefer spinlocks than bit spinlocks there).

-rt already changes locking primitives, so in the worst case you
might have to tweak this. My previous patches were open coding
these locks in fs/ so I can understand why that was a headache.

 
> I know how to fix it, but can't we go for an approach which
> does not require massive RT patching again ?
> 
> struct percpu_lock {
>        spinlock_t lock;
>        unsigned   global_state;
> };
> 
> And let the lock function do:
> 
>     spin_lock(&pcp->lock);
>     while (pcp->global_state)
>     	  cpu_relax();
> 
> So the global lock side can take each single lock, modify the percpu
> "global state" and release the lock. On unlock you just need to reset
> the global state w/o taking the percpu lock and be done.
> 
> I doubt that the extra conditional in the lock path is going to be
> relevant overhead, compared to the spin_lock it's noise.

Hmm. We need a smp_rmb() which costs a bit (on non-x86). For -rt you would
need to do priority boosting too.

reader lock:
spin_lock(&pcp->rlock);
if (unlikely(pcp->global_state)) {
  spin_unlock(&pcp->rlock);
  spin_lock(&wlock);
  spin_lock(&pcp->rlock);
  spin_unlock(&wlock);
} else
  smp_rmb();

I think I'll keep it as is for now, it's hard enough to keep single
threaded performance up. But it should be much easier to override
this in -rt and I'll be happy to try restructuring things to help rt
if and when it's possible.

