Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab1C3MRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 08:17:51 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:49872 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab1C3MRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 08:17:49 -0400
X-Nat-Received: from [202.181.97.72]:59932 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1301487450.23765
To: peterz@infradead.org
Cc: rostedt@goodmis.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] seqlock,lockdep: Add lock primitives to read_seqbegin().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201103290430.p2T4UhLA081016@www262.sakura.ne.jp>
	<1301405984.2250.402.camel@laptop>
	<1301421032.2250.432.camel@laptop>
	<201103300812.p2U8CJ9T071782@www262.sakura.ne.jp>
	<1301478610.4859.170.camel@twins>
In-Reply-To: <1301478610.4859.170.camel@twins>
Message-Id: <201103302117.HAF43299.HVOSFQOFJMFOtL@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 30 Mar 2011 21:17:29 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 30032011 #5167156, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> >  Also, I assume you meant to call
> > spin_acquire() before entering the spin state (as with
> > 
> >   static inline void __raw_spin_lock(raw_spinlock_t *lock)
> >   {
> >         preempt_disable();
> >         spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
> >         LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
> >   }
> > 
> > . Otherwise, lockdep cannot report it when hit this bug upon the first call to
> > this function). 
> 
> Huh no, of course not, a seqlock read side cannot contend in the classic
> sense.

I couldn't understand what 'contend' means. I think

  static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
  {
  	unsigned ret;
  repeat:
  	ret = sl->sequence;
  	smp_rmb();
  	if (unlikely(ret & 1)) {
  		cpu_relax();
  		goto repeat;
  	}
  	return ret;
  }

is equivalent (except that above one will not write to any kernel memory) to

  static __always_inline unsigned read_seqbegin(seqlock_t *sl)
  {
  	unsigned ret;
  	unsigned long flags;
  	spin_lock_irqsave(&sl->lock, flags);
  	ret = sl->sequence;
  	spin_unlock_irqrestore(&sl->lock, flags);
  	return ret;
  }

because read_seqbegin() cannot return to the reader until the writer (if there
is one) calls write_sequnlock().

  static inline void write_seqlock(seqlock_t *sl)
  {
  	spin_lock(&sl->lock);
  	++sl->sequence;
  	smp_wmb();
  }
  static inline void write_sequnlock(seqlock_t *sl)
  {
  	smp_wmb();
  	sl->sequence++;
  	spin_unlock(&sl->lock);
  }

Don't we call this situation (a reader thread temporarily behaves like a writer
thread who writes nothing) as 'contended'?

Anyway, could you show me read_seqbegin2()/read_seqretry2() for testing with
locktest module?

Regards.
