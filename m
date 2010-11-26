Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab0KZE7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 23:59:15 -0500
Received: from mail.lixom.net ([70.86.134.90]:33210 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab0KZE7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 23:59:13 -0500
Date: Thu, 25 Nov 2010 22:59:12 -0600
From: Olof Johansson <olof@lixom.net>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Hari Kanigeri <h-kanigeri2@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, Grant Likely <grant.likely@secretlab.ca>,
        Kevin Hilman <khilman@deeprootsystems.com>, akpm@linux-foundation.org,
        Suman Anna <s-anna@ti.com>
Subject: Re: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
Message-ID: <20101126045912.GC6598@lixom.net>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com> <1290526740-27624-2-git-send-email-ohad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290526740-27624-2-git-send-email-ohad@wizery.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In addition to other comments from others, here are a few on the
implementation.

There's a fair amount of potentially spammy and redundant debug code
left in the generic code. I've commented on some of them below, but the
same comments would apply to other locations as well.


On Tue, Nov 23, 2010 at 05:38:57PM +0200, Ohad Ben-Cohen wrote:
> diff --git a/drivers/hwspinlock/hwspinlock_core.c b/drivers/hwspinlock/hwspinlock_core.c
> new file mode 100644
> index 0000000..cd230bc
> --- /dev/null
> +++ b/drivers/hwspinlock/hwspinlock_core.c
> @@ -0,0 +1,561 @@
> +/*
> + * Generic hardware spinlock framework
> + *
> + * Copyright (C) 2010 Texas Instruments Incorporated - http://www.ti.com
> + *
> + * Contact: Ohad Ben-Cohen <ohad@wizery.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#define pr_fmt(fmt)    "%s: " fmt, __func__

Not used.

> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/spinlock.h>
> +#include <linux/types.h>
> +#include <linux/err.h>
> +#include <linux/jiffies.h>
> +#include <linux/radix-tree.h>
> +#include <linux/hwspinlock.h>
> +#include <linux/pm_runtime.h>
> +
> +#include "hwspinlock.h"
> +
> +/* radix tree tags */
> +#define HWSPINLOCK_UNUSED	(0) /* tags an hwspinlock as unused */
> +
> +/*
> + * A radix tree is used to maintain the available hwspinlock instances.
> + * The tree associates hwspinlock pointers with their integer key id,
> + * and provides easy-to-use API which makes the hwspinlock core code simple
> + * and easy to read.
> + *
> + * Radix trees are quick on lookups, and reasonably efficient in terms of
> + * storage, especially with high density usages such as this framework
> + * requires (a continuous range of integer keys, beginning with zero, is
> + * used as the ID's of the hwspinlock instances).
> + *
> + * The radix tree API supports tagging items in the tree, which this
> + * framework uses to mark unused hwspinlock instances (see the
> + * HWSPINLOCK_UNUSED tag above). As a result, the process of querying the
> + * tree, looking for an unused hwspinlock instance, is now reduced to a
> + * single radix tree API call.
> + */
> +static RADIX_TREE(hwspinlock_tree, GFP_KERNEL);
> +
> +/*
> + * Synchronization of access to the tree is achieved using this spinlock,
> + * as the radix-tree API requires that users provide all synchronisation.
> + */
> +static DEFINE_SPINLOCK(hwspinlock_tree_lock);
> +
> +/**
> + * __hwspin_trylock() - attempt to lock a specific hwspinlock
> + * @hwlock: an hwspinlock which we want to trylock
> + * @mode: controls whether local interrups are disabled or not
> + * @flags: a pointer where the caller's interrupt state will be saved at (if
> + *         requested)
> + *
> + * This function attempts to lock an hwspinlock, and will immediately
> + * fail if the hwspinlock is already taken.
> + *
> + * Upon a successful return from this function, preemption (and possibly
> + * interrupts) is disabled, so the caller must not sleep, and is advised to
> + * release the hwspinlock as soon as possible. This is required in order to
> + * minimize remote cores polling on the hardware interconnect.
> + *
> + * The user decides whether local interrupts are disabled or not, and if yes,
> + * whether he wants their previous state to be saved. It is up to the user
> + * to choose the appropriate @mode of operation, exactly the same way users
> + * should decide between spin_trylock, spin_trylock_irq and
> + * spin_trylock_irqsave.
> + *
> + * Returns 0 if we successfully locked the hwspinlock, -EBUSY if
> + * the hwspinlock was already taken, and -EINVAL if @hwlock is invalid.
> + * This function will never sleep.
> + */
> +int __hwspin_trylock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
> +{
> +	int ret;
> +
> +	if (unlikely(!hwlock)) {
> +		pr_err("invalid hwlock\n");

These kind of errors can get very spammy for buggy drivers. It's likely
more useful to either do a WARN_ON(), and/or move them under a debug
config option.

> +		return -EINVAL;
> +	}
> +	if (unlikely(mode == HWLOCK_IRQSTATE && flags == NULL)) {
> +		pr_err("invalid flags pointer (null)\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * This spin_lock{_irq, _irqsave} serves three purposes:
> +	 *
> +	 * 1. Disable preemption, in order to minimize the period of time
> +	 *    in which the hwspinlock is taken. This is important in order
> +	 *    to minimize the possible polling on the hardware interconnect
> +	 *    by a remote user of this lock.
> +	 * 2. Make the hwspinlock SMP-safe (so we can take it from
> +	 *    additional contexts on the local host).
> +	 * 3. Ensure that in_atomic/might_sleep checks catch potential
> +	 *    problems with hwspinlock usage (e.g. scheduler checks like
> +	 *    'scheduling while atomic' etc.)
> +	 */
> +	if (mode == HWLOCK_IRQSTATE)
> +		ret = spin_trylock_irqsave(&hwlock->lock, *flags);
> +	else if (mode == HWLOCK_IRQ)
> +		ret = spin_trylock_irq(&hwlock->lock);
> +	else
> +		ret = spin_trylock(&hwlock->lock);
> +
> +	/* is lock already taken by another context on the local cpu ? */
> +	if (!ret)
> +		return -EBUSY;
> +
> +	/* try to take the hwspinlock device */
> +	ret = hwlock->ops->trylock(hwlock);
> +
> +	/* if hwlock is already taken, undo spin_trylock_* and exit */
> +	if (!ret) {
> +		if (mode == HWLOCK_IRQSTATE)
> +			spin_unlock_irqrestore(&hwlock->lock, *flags);
> +		else if (mode == HWLOCK_IRQ)
> +			spin_unlock_irq(&hwlock->lock);
> +		else
> +			spin_unlock(&hwlock->lock);
> +
> +		return -EBUSY;
> +	}
> +
> +	/*
> +	 * We can be sure the other core's memory operations
> +	 * are observable to us only _after_ we successfully take
> +	 * the hwspinlock, so we must make sure that subsequent memory
> +	 * operations will not be reordered before we actually took the
> +	 * hwspinlock.
> +	 *
> +	 * Note: the implicit memory barrier of the spinlock above is too
> +	 * early, so we need this additional explicit memory barrier.
> +	 */
> +	mb();

rmb() should be sufficient here.

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(__hwspin_trylock);
> +

[...]

> +/**
> + * __hwspin_unlock() - unlock a specific hwspinlock
> + * @hwlock: a previously-acquired hwspinlock which we want to unlock
> + * @mode: controls whether local interrups needs to be restored or not
> + * @flags: previous caller's interrupt state to restore (if requested)
> + *
> + * This function will unlock a specific hwspinlock, enable preemption and
> + * (possibly) enable interrupts or restore their previous state.
> + * @hwlock must be already locked before calling this function: it is a bug
> + * to call unlock on a @hwlock that is already unlocked.
> + *
> + * The user decides whether local interrupts should be enabled or not, and
> + * if yes, whether he wants their previous state to be restored. It is up
> + * to the user to choose the appropriate @mode of operation, exactly the
> + * same way users decide between spin_unlock, spin_unlock_irq and
> + * spin_unlock_irqrestore.
> + *
> + * The function will never sleep.
> + *
> + * Returns 0 on success, -EINVAL if @hwlock or @flags are invalid.
> + */
> +int __hwspin_unlock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
> +{
> +	if (unlikely(!hwlock)) {
> +		pr_err("invalid hwlock\n");
> +		return -EINVAL;
> +	}
> +	if (unlikely(mode == HWLOCK_IRQSTATE && flags == NULL)) {
> +		pr_err("invalid flags pointer (null)\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * We must make sure that memory operations, done before unlocking
> +	 * the hwspinlock, will not be reordered after the lock is released.
> +	 *
> +	 * That's the purpose of this explicit memory barrier.
> +	 *
> +	 * Note: the memory barrier induced by the spin_unlock below is too
> +	 * late; the other core is going to access memory soon after it will
> +	 * take the hwspinlock, and by then we want to be sure our memory
> +	 * operations are already observable.
> +	 */
> +	mb();

wmb() should be sufficient here.

> +
> +	hwlock->ops->unlock(hwlock);
> +
> +	/* Undo the spin_trylock{_irq, _irqsave} called while locking */
> +	if (mode == HWLOCK_IRQSTATE)
> +		spin_unlock_irqrestore(&hwlock->lock, *flags);
> +	else if (mode == HWLOCK_IRQ)
> +		spin_unlock_irq(&hwlock->lock);
> +	else
> +		spin_unlock(&hwlock->lock);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(__hwspin_unlock);
> +
> +/**
> + * hwspinlock_register() - register a new hw spinlock
> + * @hwlock: hwspinlock to register.
> + *
> + * This function should be called from the underlying platform-specific
> + * implementation, to register a new hwspinlock instance.
> + *
> + * Can be called from an atomic context (will not sleep) but not from
> + * within interrupt context.
> + *
> + * Returns 0 on success, or an appropriate error code on failure
> + */
> +int hwspinlock_register(struct hwspinlock *hwlock)
> +{
> +	struct hwspinlock *tmp;
> +	int ret;
> +
> +	if (!hwlock || !hwlock->ops ||
> +		!hwlock->ops->trylock || !hwlock->ops->unlock) {
> +		pr_err("invalid parameters\n");
> +		return -EINVAL;
> +	}
> +
> +	spin_lock_init(&hwlock->lock);
> +
> +	spin_lock(&hwspinlock_tree_lock);
> +
> +	ret = radix_tree_insert(&hwspinlock_tree, hwlock->id, hwlock);
> +	if (ret)
> +		goto out;
> +
> +	/* mark this hwspinlock as available */
> +	tmp = radix_tree_tag_set(&hwspinlock_tree, hwlock->id,
> +							HWSPINLOCK_UNUSED);
> +
> +	/* this implies an unrecoverable bug. at least rant */
> +	WARN_ON(tmp != hwlock);

I don't see how this could ever happen?

> +
> +out:
> +	spin_unlock(&hwspinlock_tree_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(hwspinlock_register);
> +
> +/**
> + * hwspinlock_unregister() - unregister an hw spinlock
> + * @id: index of the specific hwspinlock to unregister
> + *
> + * This function should be called from the underlying platform-specific
> + * implementation, to unregister an existing (and unused) hwspinlock.
> + *
> + * Can be called from an atomic context (will not sleep) but not from
> + * within interrupt context.
> + *
> + * Returns the address of hwspinlock @id on success, or NULL on failure

Why not just return int for success / fail and have the driver keep track
of the lock pointers too?

Or, if you for some reason is attached to the ptr-return case, please make it return
standard ERR_PTR instead.


[...]

> +struct hwspinlock *hwspinlock_request(void)
> +{
> +	struct hwspinlock *hwlock;
> +	int ret;
> +
> +	spin_lock(&hwspinlock_tree_lock);
> +
> +	/* look for an unused lock */
> +	ret = radix_tree_gang_lookup_tag(&hwspinlock_tree, (void **)&hwlock,
> +						0, 1, HWSPINLOCK_UNUSED);
> +	if (ret == 0) {
> +		pr_warn("a free hwspinlock is not available\n");
> +		hwlock = NULL;
> +		goto out;
> +	}
> +
> +	/* sanity check: we shouldn't get more than we requested for */
> +	WARN_ON(ret > 1);

No need to check, unless you're debugging the radix code.

> +	/* mark as used and power up */
> +	ret = __hwspinlock_request(hwlock);
> +	if (ret < 0)
> +		hwlock = NULL;
> +
> +out:
> +	spin_unlock(&hwspinlock_tree_lock);
> +	return hwlock;
> +}
> +EXPORT_SYMBOL_GPL(hwspinlock_request);
> +

[...]

> +/**
> + * hwspinlock_free() - free a specific hwspinlock
> + * @hwlock: the specific hwspinlock to free
> + *
> + * This function mark @hwlock as free again.
> + * Should only be called with an @hwlock that was retrieved from
> + * an earlier call to omap_hwspinlock_request{_specific}.
> + *
> + * Can be called from an atomic context (will not sleep) but not from
> + * within interrupt context (simply because there is no use case for
> + * that yet).
> + *
> + * Returns 0 on success, or an appropriate error code on failure
> + */
> +int hwspinlock_free(struct hwspinlock *hwlock)
> +{
> +	struct hwspinlock *tmp;
> +	int ret;
> +
> +	if (!hwlock) {

Some alloc/free APIs will just silently return for these cases.

> +		pr_err("invalid hwlock\n");
> +		return -EINVAL;
> +	}
> +
> +	spin_lock(&hwspinlock_tree_lock);
> +
> +	/* make sure the hwspinlock is used */
> +	ret = radix_tree_tag_get(&hwspinlock_tree, hwlock->id,
> +							HWSPINLOCK_UNUSED);
> +	if (ret == 1) {
> +		dev_err(hwlock->dev, "%s: hwlock is already free\n", __func__);

Double free. WARN_ON() seems appropriate?

> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* notify the underlying device that power is not needed */
> +	ret = pm_runtime_put(hwlock->dev);
> +	if (ret < 0)
> +		goto out;
> +
> +	/* mark this hwspinlock as available */
> +	tmp = radix_tree_tag_set(&hwspinlock_tree, hwlock->id,
> +							HWSPINLOCK_UNUSED);
> +
> +	/* sanity check (this shouldn't happen) */
> +	WARN_ON(tmp != hwlock);

No need for this.

> +
> +	module_put(hwlock->owner);
> +
> +out:
> +	spin_unlock(&hwspinlock_tree_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(hwspinlock_free);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Generic hardware spinlock interface");
> +MODULE_AUTHOR("Ohad Ben-Cohen <ohad@wizery.com>");



