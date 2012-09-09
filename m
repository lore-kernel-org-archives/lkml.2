Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2IIXey (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:34:54 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58873 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab2IIXeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:34:50 -0400
Date: Sun, 9 Sep 2012 19:34:47 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Ben Hutchings <ben@decadent.org.uk>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Chris Mason <chris.mason@fusionio.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ 25/95] mutex: Place lock in contended state after fastpath_lock
 failure
In-Reply-To: <20120909224154.303617964@decadent.org.uk>
Message-ID: <alpine.LFD.2.02.1209091930530.28681@xanadu.home>
References: <20120909224154.303617964@decadent.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Sep 2012, Ben Hutchings wrote:

> 3.2-stable review patch.  If anyone has any objections, please let me know.

Once you have this patch included, could you pick up commit a76d7bd96d 
as well please?

Thanks.

> ------------------
> 
> From: Will Deacon <will.deacon@arm.com>
> 
> commit 0bce9c46bf3b15f485d82d7e81dabed6ebcc24b1 upstream.
> 
> ARM recently moved to asm-generic/mutex-xchg.h for its mutex
> implementation after the previous implementation was found to be missing
> some crucial memory barriers. However, this has revealed some problems
> running hackbench on SMP platforms due to the way in which the
> MUTEX_SPIN_ON_OWNER code operates.
> 
> The symptoms are that a bunch of hackbench tasks are left waiting on an
> unlocked mutex and therefore never get woken up to claim it. This boils
> down to the following sequence of events:
> 
>         Task A        Task B        Task C        Lock value
> 0                                                     1
> 1       lock()                                        0
> 2                     lock()                          0
> 3                     spin(A)                         0
> 4       unlock()                                      1
> 5                                   lock()            0
> 6                     cmpxchg(1,0)                    0
> 7                     contended()                    -1
> 8       lock()                                        0
> 9       spin(C)                                       0
> 10                                  unlock()          1
> 11      cmpxchg(1,0)                                  0
> 12      unlock()                                      1
> 
> At this point, the lock is unlocked, but Task B is in an uninterruptible
> sleep with nobody to wake it up.
> 
> This patch fixes the problem by ensuring we put the lock into the
> contended state if we fail to acquire it on the fastpath, ensuring that
> any blocked waiters are woken up when the mutex is released.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Chris Mason <chris.mason@fusionio.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Reviewed-by: Nicolas Pitre <nico@linaro.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-6e9lrw2avczr0617fzl5vqb8@git.kernel.org
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  include/asm-generic/mutex-xchg.h |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/include/asm-generic/mutex-xchg.h b/include/asm-generic/mutex-xchg.h
> index 580a6d3..c04e0db 100644
> --- a/include/asm-generic/mutex-xchg.h
> +++ b/include/asm-generic/mutex-xchg.h
> @@ -26,7 +26,13 @@ static inline void
>  __mutex_fastpath_lock(atomic_t *count, void (*fail_fn)(atomic_t *))
>  {
>  	if (unlikely(atomic_xchg(count, 0) != 1))
> -		fail_fn(count);
> +		/*
> +		 * We failed to acquire the lock, so mark it contended
> +		 * to ensure that any waiting tasks are woken up by the
> +		 * unlock slow path.
> +		 */
> +		if (likely(atomic_xchg(count, -1) != 1))
> +			fail_fn(count);
>  }
>  
>  /**
> @@ -43,7 +49,8 @@ static inline int
>  __mutex_fastpath_lock_retval(atomic_t *count, int (*fail_fn)(atomic_t *))
>  {
>  	if (unlikely(atomic_xchg(count, 0) != 1))
> -		return fail_fn(count);
> +		if (likely(atomic_xchg(count, -1) != 1))
> +			return fail_fn(count);
>  	return 0;
>  }
>  
> 
> 
