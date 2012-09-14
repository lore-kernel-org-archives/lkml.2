Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab2INU7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 16:59:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab2INU7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 16:59:32 -0400
Date: Fri, 14 Sep 2012 13:59:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vikram Mulukutla <markivx@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        sboyd@codeaurora.org
Subject: Re: [PATCH] lib: spinlock_debug: Avoid livelock in do_raw_spin_lock
Message-Id: <20120914135931.262f6d0c.akpm@linux-foundation.org>
In-Reply-To: <1347592526-7592-1-git-send-email-markivx@codeaurora.org>
References: <1347592526-7592-1-git-send-email-markivx@codeaurora.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Sep 2012 20:15:26 -0700
Vikram Mulukutla <markivx@codeaurora.org> wrote:

> The logic in do_raw_spin_lock attempts to acquire a spinlock
> by invoking arch_spin_trylock in a loop with a delay between
> each attempt. Now consider the following situation in a 2
> CPU system:
> 
> 1. CPU-0 continually acquires and releases a spinlock in a
>    tight loop; it stays in this loop until some condition X
>    is satisfied. X can only be satisfied by another CPU.
> 
> 2. CPU-1 tries to acquire the same spinlock, in an attempt
>    to satisfy the aforementioned condition X. However, it
>    never sees the unlocked value of the lock because the
>    debug spinlock code uses trylock instead of just lock;
>    it checks at all the wrong moments - whenever CPU-0 has
>    locked the lock.
> 
> Now in the absence of debug spinlocks, the architecture specific
> spinlock code can correctly allow CPU-1 to wait in a "queue"
> (e.g., ticket spinlocks), ensuring that it acquires the lock at
> some point. However, with the debug spinlock code, livelock
> can easily occur due to the use of try_lock, which obviously
> cannot put the CPU in that "queue". This queueing mechanism is
> implemented in both x86 and ARM spinlock code.
> 
> Note that the situation mentioned above is not hypothetical.
> A real problem was encountered where CPU-0 was running
> hrtimer_cancel with interrupts disabled, and CPU-1 was attempting
> to run the hrtimer that CPU-0 was trying to cancel.

I'm surprised.  Yes, I guess it will happen if both CPUs have local
interrupts disabled.  And perhaps serialisation of the locked operation
helps.

> ...
>
> --- a/lib/spinlock_debug.c
> +++ b/lib/spinlock_debug.c
> @@ -107,23 +107,27 @@ static void __spin_lock_debug(raw_spinlock_t *lock)
>  {
>  	u64 i;
>  	u64 loops = loops_per_jiffy * HZ;
> -	int print_once = 1;
>  
> -	for (;;) {
> -		for (i = 0; i < loops; i++) {
> -			if (arch_spin_trylock(&lock->raw_lock))
> -				return;
> -			__delay(1);
> -		}
> -		/* lockup suspected: */
> -		if (print_once) {
> -			print_once = 0;
> -			spin_dump(lock, "lockup suspected");
> +	for (i = 0; i < loops; i++) {
> +		if (arch_spin_trylock(&lock->raw_lock))
> +			return;
> +		__delay(1);
> +	}
> +	/* lockup suspected: */
> +	spin_dump(lock, "lockup suspected");
>  #ifdef CONFIG_SMP
> -			trigger_all_cpu_backtrace();
> +	trigger_all_cpu_backtrace();
>  #endif
> -		}
> -	}
> +
> +	/*
> +	 * In case the trylock above was causing a livelock, give the lower
> +	 * level arch specific lock code a chance to acquire the lock. We have
> +	 * already printed a warning/backtrace at this point. The non-debug arch
> +	 * specific code might actually succeed in acquiring the lock. If it is
> +	 * not successful, the end-result is the same - there is no forward
> +	 * progress.
> +	 */
> +	arch_spin_lock(&lock->raw_lock);
>  }

The change looks reasonable to me.  I suggest we disambiguate that
comment a bit:

--- a/lib/spinlock_debug.c~lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix
+++ a/lib/spinlock_debug.c
@@ -120,7 +120,7 @@ static void __spin_lock_debug(raw_spinlo
 #endif
 
 	/*
-	 * In case the trylock above was causing a livelock, give the lower
+	 * The trylock above was causing a livelock.  Give the lower
 	 * level arch specific lock code a chance to acquire the lock. We have
 	 * already printed a warning/backtrace at this point. The non-debug arch
 	 * specific code might actually succeed in acquiring the lock. If it is
_

