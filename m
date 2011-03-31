Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827Ab1CaOAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:00:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56407 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab1CaOAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:00:15 -0400
Subject: Re: [RFC] seqlock,lockdep: Add lock primitives to read_seqbegin().
From: Peter Zijlstra <peterz@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: rostedt@goodmis.org, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <201103302117.HAF43299.HVOSFQOFJMFOtL@I-love.SAKURA.ne.jp>
References: <201103290430.p2T4UhLA081016@www262.sakura.ne.jp>
	 <1301405984.2250.402.camel@laptop> <1301421032.2250.432.camel@laptop>
	 <201103300812.p2U8CJ9T071782@www262.sakura.ne.jp>
	 <1301478610.4859.170.camel@twins>
	 <201103302117.HAF43299.HVOSFQOFJMFOtL@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 31 Mar 2011 15:59:44 +0200
Message-ID: <1301579984.4859.284.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 21:17 +0900, Tetsuo Handa wrote:
> Peter Zijlstra wrote:
> > >  Also, I assume you meant to call
> > > spin_acquire() before entering the spin state (as with
> > > 
> > >   static inline void __raw_spin_lock(raw_spinlock_t *lock)
> > >   {
> > >         preempt_disable();
> > >         spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
> > >         LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
> > >   }
> > > 
> > > . Otherwise, lockdep cannot report it when hit this bug upon the first call to
> > > this function). 
> > 
> > Huh no, of course not, a seqlock read side cannot contend in the classic
> > sense.
> 
> I couldn't understand what 'contend' means. I think
> 
>   static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
>   {
>   	unsigned ret;
>   repeat:
>   	ret = sl->sequence;
>   	smp_rmb();
>   	if (unlikely(ret & 1)) {
>   		cpu_relax();
>   		goto repeat;
>   	}
>   	return ret;
>   }
> 
> is equivalent (except that above one will not write to any kernel memory) to
> 
>   static __always_inline unsigned read_seqbegin(seqlock_t *sl)
>   {
>   	unsigned ret;
>   	unsigned long flags;
>   	spin_lock_irqsave(&sl->lock, flags);
>   	ret = sl->sequence;
>   	spin_unlock_irqrestore(&sl->lock, flags);
>   	return ret;
>   }
> 
> because read_seqbegin() cannot return to the reader until the writer (if there
> is one) calls write_sequnlock().

It more or less it, but conceptually the seqlock read-side is a
non-blocking algorithm and thus doesn't block or contend. The above
initial wait is merely an optimization to avoid having to retry, which
could be more expensive than simply waiting there.

Anyway, all the lockdep contention crap is purely about lockstat and
doesn't matter for dependency tracking.

> Don't we call this situation (a reader thread temporarily behaves like a writer
> thread who writes nothing) as 'contended'?
> 
> Anyway, could you show me read_seqbegin2()/read_seqretry2() for testing with
> locktest module?

Like I wrote before:

> @@ -94,6 +94,7 @@ static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
>                 cpu_relax();
>                 goto repeat;
>         }
> +       rwlock_acquire_read(&sl->lock->dep_map, 0, 0, _RET_IP_);
>  
>         return ret;
>  }
> @@ -107,6 +108,8 @@ static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
>  {
>         smp_rmb();
>  
> +       rwlock_release(&sl->lock->dep_map, 1, _RET_IP_);
> +
>         return unlikely(sl->sequence != start);
>  }

Should do, except that lockdep doesn't properly work for read-recursive
locks, which needs to get fixed.
