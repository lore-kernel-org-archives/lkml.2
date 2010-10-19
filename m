Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab0JSQ6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:58:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52756 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab0JSQ6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:58:45 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <akpm@linux-foundation.org>,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Simon Que <sque@ti.com>, "Krishnamoorthy\, Balaji T" <balajitk@ti.com>
Subject: Re: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
Organization: Deep Root Systems, LLC
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
	<1287387875-14168-2-git-send-email-ohad@wizery.com>
Date: Tue, 19 Oct 2010 09:58:42 -0700
In-Reply-To: <1287387875-14168-2-git-send-email-ohad@wizery.com> (Ohad
	Ben-Cohen's message of "Mon, 18 Oct 2010 09:44:33 +0200")
Message-ID: <8762wyyv99.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohad Ben-Cohen <ohad@wizery.com> writes:

> From: Simon Que <sque@ti.com>
>
> Add driver for OMAP's Hardware Spinlock module.
>
> The OMAP Hardware Spinlock module, initially introduced in OMAP4,
> provides hardware assistance for synchronization between the
> multiple processors in the device (Cortex-A9, Cortex-M3 and
> C64x+ DSP).

[...]

> +/**
> + * omap_hwspin_trylock() - attempt to lock a specific hwspinlock
> + * @hwlock: a hwspinlock which we want to trylock
> + * @flags: a pointer to where the caller's interrupt state will be saved at
> + *
> + * This function attempt to lock the underlying hwspinlock. Unlike
> + * hwspinlock_lock, this function will immediately fail if the hwspinlock
> + * is already taken.
> + *
> + * Upon a successful return from this function, preemption and interrupts
> + * are disabled, so the caller must not sleep, and is advised to release
> + * the hwspinlock as soon as possible. This is required in order to minimize
> + * remote cores polling on the hardware interconnect.
> + *
> + * This function can be called from any context.
> + *
> + * Returns 0 if we successfully locked the hwspinlock, -EBUSY if
> + * the hwspinlock was already taken, and -EINVAL if @hwlock is invalid.
> + */
> +int omap_hwspin_trylock(struct omap_hwspinlock *hwlock, unsigned long *flags)
> +{
> +	u32 ret;
> +
> +	if (IS_ERR_OR_NULL(hwlock)) {
> +		pr_err("invalid hwlock\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * This spin_trylock_irqsave serves two purposes:
> +
> +	 * 1. Disable local interrupts and preemption, in order to
> +	 *    minimize the period of time in which the hwspinlock
> +	 *    is taken (so caller will not preempted). This is
> +	 *    important in order to minimize the possible polling on
> +	 *    the hardware interconnect by a remote user of this lock.
> +	 *
> +	 * 2. Make this hwspinlock primitive SMP-safe (so we can try to
> +	 *    take it from additional contexts on the local cpu)
> +	 */

3. Ensures that in_atomic/might_sleep checks catch potential problems
   with hwspinlock usage (e.g. scheduler checks like 'scheduling while
   atomic' etc.)

> +	if (!spin_trylock_irqsave(&hwlock->lock, *flags))
> +		return -EBUSY;
> +
> +	/* attempt to acquire the lock by reading its value */
> +	ret = readl(hwlock->addr);
> +
> +	/* lock is already taken */
> +	if (ret == SPINLOCK_TAKEN) {
> +		spin_unlock_irqrestore(&hwlock->lock, *flags);
> +		return -EBUSY;
> +	}
> +
> +	/*
> +	 * We can be sure the other core's memory operations
> +	 * are observable to us only _after_ we successfully take
> +	 * the hwspinlock, so we must make sure that subsequent memory
> +	 * operations will not be reordered before we actually took the
> +	 * hwspinlock.
> +	 * Note: the implicit memory barrier of the spinlock above is too
> +	 * early, so we need this additional explicit memory barrier.
> +	 */
> +	mb();
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(omap_hwspin_trylock);

[...]

> +/**
> + * omap_hwspinlock_unlock() - unlock a specific hwspinlock

minor nit: s/lock_unlock/_unlock/  to match name below

> + * @hwlock: a previously-acquired hwspinlock which we want to unlock
> + * @flags: a pointer to the caller's saved interrupts state
> + *
> + * This function will unlock a specific hwspinlock, enable preemption and
> + * restore the interrupts state. @hwlock must be taken (by us!) before
> + * calling this function: it is a bug to call unlock on a @hwlock that was
> + * not taken by us, i.e. using one of omap_hwspin_{lock trylock, lock_timeout}.
> + *
> + * This function can be called from any context.
> + *
> + * Returns 0 when the @hwlock on success, or -EINVAL if @hwlock is invalid.
> + */
> +int omap_hwspin_unlock(struct omap_hwspinlock *hwlock, unsigned long *flags)
> +{
> +	if (IS_ERR_OR_NULL(hwlock)) {
> +		pr_err("invalid hwlock\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * We must make sure that memory operations, done before unlocking
> +	 * the hwspinlock, will not be reordered after the lock is released.
> +	 * The memory barrier induced by the spin_unlock below is too late:
> +	 * the other core is going to access memory soon after it will take
> +	 * the hwspinlock, and by then we want to be sure our memory operations
> +	 * were already observable.
> +	 */
> +	mb();
> +
> +	/* release the lock by writing 0 to it (NOTTAKEN) */
> +	writel(SPINLOCK_NOTTAKEN, hwlock->addr);
> +
> +	/* undo the spin_trylock_irqsave called in the locking function */
> +	spin_unlock_irqrestore(&hwlock->lock, *flags);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(omap_hwspin_unlock);

[...]

Kevin
