Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0FYT7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 15:59:46 -0400
Received: from www.tglx.de ([62.245.132.106]:35836 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901Ab0FYT7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 15:59:45 -0400
Date: Fri, 25 Jun 2010 21:59:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Darren Hart <dvhltc@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andreas Schwab <schwab@redhat.com>, Danny Feng <dfeng@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: sys_futex() && timespec_valid()
In-Reply-To: <20100625192008.GA25337@redhat.com>
Message-ID: <alpine.LFD.2.00.1006252140410.18683@localhost.localdomain>
References: <20100625192008.GA25337@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2005;0cOleg,

On Fri, 25 Jun 2010, Oleg Nesterov wrote:

> Hello.
> 
> Another stupid question about the trivial problem I am going to ask,
> just to report the authoritative answer back to bugzilla. The problem
> is, personally I am not sure we should/can add the user-visible change
> required by glibc maintainers, and I am in no position to suggest them
> to fix the user-space code instead.
> 
> 
> In short, glibc developers believe that sys_futex(ts) is buggy and
> needs the fix to return -ETIMEDOUT instead of -EINVAL in case when
> ts->tv_sec < 0 and the timeout is absolute.

Oh well. We followed the validity check for all other syscalls which
hand in [absolute] timespecs:

 The rqtp argument specified a nanosecond value less than zero or
 greater than or equal to 1000 million; or the TIMER_ABSTIME flag was
 specified in flags and the rqtp argument is outside the range for the
 clock specified by clock_id;

tv->sec < 0 is definitely an invalid value for both CLOCK_REALTIME and
CLOCK_MONOTONIC. And I consider any code assuming that it's sane as
buggy by definition.

I'm strictly against having different definitions of sanity for
different syscalls.

> Ignoring the possible cleanups/microoptimizations, something like this:
> 
> --- x/kernel/futex.c
> +++ x/kernel/futex.c
> @@ -2625,6 +2625,16 @@ SYSCALL_DEFINE6(futex, u32 __user *, uad
>  		      cmd == FUTEX_WAIT_REQUEUE_PI)) {
>  		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
>  			return -EFAULT;
> +
> +		// absolute timeout
> +		if (cmd != FUTEX_WAIT) {
> +			if (ts->tv_nsec >= NSEC_PER_SEC)
> +				return -EINVAL;
> +			if (ts->tv_sec < 0)
> +				return -ETIMEDOUT;
> +		}
> +
> +
>  		if (!timespec_valid(&ts))
>  			return -EINVAL;

 Btw, you'd need that ugly check in the compat syscall as well.
 
> ------------------------------------------------------------------------
> 
> Otherwise, pthread_rwlock_timedwrlock(ts) hangs spinning in user-space
> forever if ts->tv_sec < 0.
> 
> To clarify: this depends on libc version and arch.

Ouch. So we have code in libc which makes different assumptions about
the syscall semantics ?

> This happens because pthread_rwlock_timedwrlock(rwlock, ts) on x86_64
> roughly does:
> 
> 	for (;;) {
> 		if (fast_path_succeeds(rwlock))
> 			return 0;
> 
> 		if (ts->tv_nsec >= NSEC_PER_SEC)
> 			return EINVAL;
> 
> 		errcode = sys_futex(FUTEX_WAIT_BITSET_PRIVATE, ts);
> 		if (errcode == ETIMEDOUT)
> 			return ETIMEDOUT;
> 	}
> 
> and since the kernel return EINVAL due to !timespec_valid(ts), the
> code above loops forever.
> 
> (btw, we have same problem with EFAULT, and this is considered as
>  a caller's problem).

Brilliant.
 
> IOW, pthread_rwlock_timedwrlock() assumes that in this case
> sys_futex() can return nothing interesting except 0 or ETIMEDOUT.
> I guess pthread_rwlock_timedwrlock() is not alone, but I didn't check.
> 
> So, the question: do you think we can change sys_futex() to make
> glibc happy?

Do we really want to add crap to the kernel, just because some
lunatics have interesting assumptions about validation ?

Definitely NOT
 
> Or, do you think it is user-space who should check tv_sec < 0 if
> it wants ETIMEDOUT with the negative timeout ?

If user space folks consider tv_sec < 0 a value which is sane and
inside the valid range of CLOCK_MONO/REAL then I can't do much more
than shrug.

Thanks,

	tglx

