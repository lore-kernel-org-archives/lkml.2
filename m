Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab1C3Juk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:50:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42922 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab1C3Juj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:50:39 -0400
Subject: Re: [RFC] seqlock,lockdep: Add lock primitives to read_seqbegin().
From: Peter Zijlstra <peterz@infradead.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: rostedt@goodmis.org, mingo@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <201103300812.p2U8CJ9T071782@www262.sakura.ne.jp>
References: <201103261312.AEJ01293.OVFJFSLtHOFOMQ@I-love.SAKURA.ne.jp>
	 <20110328171217.GA8529@home.goodmis.org>
	 <201103290430.p2T4UhLA081016@www262.sakura.ne.jp>
	 <1301405984.2250.402.camel@laptop> <1301421032.2250.432.camel@laptop>
	 <201103300812.p2U8CJ9T071782@www262.sakura.ne.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 30 Mar 2011 11:50:10 +0200
Message-ID: <1301478610.4859.170.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 17:12 +0900, Tetsuo Handa wrote:
> Peter Zijlstra wrote:
> > On Tue, 2011-03-29 at 15:39 +0200, Peter Zijlstra wrote:
> > > 
> > > That said, there are some out-standing issues with rw_locks and lockdep,
> > > Gautham and I worked on that for a while but we never persevered and
> > > finished it..
> > > 
> > >   http://lkml.org/lkml/2009/5/11/203 
> > 
> > I just did a quick rebase onto tip/master (compile tested only):
> > 
> >   http://programming.kicks-ass.net/sekrit/patches-lockdep.tar.bz2
> > 
> > That series needs testing and a few patches to extend the
> > lib/locking-selftest* bits to cover the new functionality.
> 
> Thanks, but I didn't apply above tarball to 2.6.38.2 because lockdep selftests
> failed. 

I probably messed up the last patch, its basically a complete rewrite
because lockdep changed significantly between when that series was
written and now.

> > In order to hit your inversion you need to do something like:
> > 
> > cat /proc/locktest1 & cat /proc/locktest2
> > 
> > if you do them serialized you'll never hit that inversion.
> 
> Yes, I know. But I think that lockdep should report the possibility of hitting
> that inversion even if I do them serialized.

True, my bad.

> So, this is not a bug but intended coding. Then, we want a comment here why
> lockdep annotation is missing.

Nah, ideally we'd fix it by making the VDSO code use another primitive.

> > --- a/include/linux/seqlock.h
> > +++ b/include/linux/seqlock.h
> > @@ -94,6 +94,7 @@ static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
> >               cpu_relax();
> >               goto repeat;
> >       }
> > +     rwlock_acquire_read(&sl->lock->dep_map, 0, 0, _RET_IP_);
> >  
> >       return ret;
> >  }
> > @@ -107,6 +108,8 @@ static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
> >  {
> >       smp_rmb();
> >  
> > +     rwlock_release(&sl->lock->dep_map, 1, _RET_IP_);
> > +
> >       return unlikely(sl->sequence != start);
> >  }
> 
> Excuse me, but the lock embedded into seqlock_t is spinlock rather than rwlock.
> I assume you meant spin_acquire()/spin_release() rather than
> rwlock_acquire_read()/rwlock_release().

No, I meant what I wrote ;-) it doesn't matter to lockdep that its a
spinlock (lockdep doesn't even know that) and in fact rwlock_acquire
(the write version) is identical to spin_acquire() both acquire the lock
in the exclusive state.

The read side of seqlocks is a recursive read lock, hence
rwlock_acquire_read()

>  Also, I assume you meant to call
> spin_acquire() before entering the spin state (as with
> 
>   static inline void __raw_spin_lock(raw_spinlock_t *lock)
>   {
>         preempt_disable();
>         spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
>         LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
>   }
> 
> . Otherwise, lockdep cannot report it when hit this bug upon the first call to
> this function). 

Huh no, of course not, a seqlock read side cannot contend in the classic
sense.
