Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab1AFKix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:38:53 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:19286 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752791Ab1AFKiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:38:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIcnJU15LcNW/2dsb2JhbACkH3S+NYVMBJAv
Date: Thu, 6 Jan 2011 21:38:42 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH] spinlock: Kill spin_unlock_wait()
Message-ID: <20110106103841.GA3493@amd>
References: <20101224122338.172750730@chello.nl>
 <20101224123742.724459093@chello.nl>
 <AANLkTikGBsh0-QTe9CA2gwDtwzpdMi+fbDsTEKiJAL0P@mail.gmail.com>
 <1294054362.2016.74.camel@laptop>
 <20110104064542.GF3402@amd>
 <1294254867.2016.281.camel@laptop>
 <AANLkTi=URmD1GYqp+PfVf6rc0tXvRnAQG808LMnBRgG1@mail.gmail.com>
 <1294306353.2016.304.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294306353.2016.304.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 10:32:33AM +0100, Peter Zijlstra wrote:
> On Wed, 2011-01-05 at 11:43 -0800, Linus Torvalds wrote:
> > On Wed, Jan 5, 2011 at 11:14 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > >
> > > There appear to be only two callsites of said horror, one in the exit
> > > path and one in ata-eh, neither appear to be performance critical so I
> > > replaced them with a simple lock-unlock sequence.
> > 
> > Again, WHY?
> > 
> > What's the problem with the current code? Instead of generating ugly
> > patches to change it, and instead of removing it, just say what the
> > PROBLEM is.
> 
> Well, I don't care about the primitive anymore, and Nick had some
> reasonable arguments on why its not a good primitive to have. So in a
> brief moment I decided to see what it would take to make it go away.
> 
> Apparently you don't like it, I'm fine with that, consider the patch
> discarded.
> 
> > Some simple helper functions to extract the tail/head part of the
> > ticket lock to make the comparisons understandable,
> 
> Jeremy has a number of pending patches making things more pretty. If you
> wish I can revisit this once that work hits your tree.
> 
>   http://lkml.org/lkml/2010/11/16/479
> 
> He makes the thing looks like:
> 
> +#if (CONFIG_NR_CPUS < 256)
> +typedef u8  __ticket_t;
> +#else
> +typedef u16 __ticket_t;
> +#endif
> +
> +#define TICKET_SHIFT   (sizeof(__ticket_t) * 8)
> +#define TICKET_MASK    ((__ticket_t)((1 << TICKET_SHIFT) - 1))
> +
>  typedef struct arch_spinlock {
> +       union {
> +               unsigned int slock;
> +               struct __raw_tickets {
> +                       __ticket_t head, tail;
> +               } tickets;
> +       };
>  } arch_spinlock_t;
> 
> >  together with
> > always accessing the lock with the proper ACCESS_ONCE() would have
> > made your previous patch acceptable.
> 
> I'm still not quite seeing where I was missing an ACCESS_ONCE(), the
> second loop had a cpu_relax() in, which is a compiler barrier so it
> forces a reload that way.
> 
> >  But you ignored that feedback,
> > and instead you now want to do a "let's just remove it entirely patch"
> > that is even worse.
> 
> My locking improved and became a lot more obvious by not using the
> primitive, so for the work I was doing not using it seemed the better
> solution.
> 
> And as said, this was inspired by Nick's comments and it was a quick
> edit to see what it would take.

I was hoping more that it could be removed from callers rather than
replaced with lock/unlock sequence...

I can't see how the usage in libata could be right. If we're waiting
for some modifications inside the critical section, then it seems we
could load some shared data before the lock is actually released, on
an architecture which does load/load reordering. At best it needs some
good comments and perhaps a barrier or two.

The spin_unlock_wait in do_exit seems like it shouldn't be needed --
exit_pi_state_list takes the pi_lock after the task has died anyway,
so I can't see what the problem would be. Removing the call (and
perhaps put a BUG_ON(!(curr->flags & PF_EXITING)) in exit_pi_state_list
would do the same thing, avoid the barrier, and localize fuxtex exit
protocol to futex.c.

(If the spin_unlock_wait call *was* actually required, eg. we subsequently
 checked current->pi_state_list without holding the pi_lock, then we
 would require a barrier after the spin_unlock_wait call too, to prevent
 speculative load pulling it up before the load of the lock, so I don't
 really agree Linus that it's an obvious API -- to you perhaps because
 barriers are second nature to you, but not for driver writers :)).


