Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0KZIxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 03:53:33 -0500
Received: from mail-iw0-f194.google.com ([209.85.214.194]:65210 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab0KZIxc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 03:53:32 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.224.233]
In-Reply-To: <20101126045912.GC6598@lixom.net>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com>
 <1290526740-27624-2-git-send-email-ohad@wizery.com> <20101126045912.GC6598@lixom.net>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 26 Nov 2010 10:53:10 +0200
Message-ID: <AANLkTin5Tfcuy0WcHJ22rWC8niwZCj8SZAMKLz0p9jwc@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
To: Olof Johansson <olof@lixom.net>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Hari Kanigeri <h-kanigeri2@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, Grant Likely <grant.likely@secretlab.ca>,
        Kevin Hilman <khilman@deeprootsystems.com>, akpm@linux-foundation.org,
        Suman Anna <s-anna@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 6:59 AM, Olof Johansson <olof@lixom.net> wrote:
>> +#define pr_fmt(fmt)    "%s: " fmt, __func__
>
> Not used.

Yes, it is, check out how the pr_* macros are implemented:

#define pr_info(fmt, ...) \
        printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)

I use it to ensure that the function name is printed with any pr_*
macro, without having to explicitly specify the __func__ param every
time.


>> +int __hwspin_trylock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
>> +{
>> +     int ret;
>> +
>> +     if (unlikely(!hwlock)) {
>> +             pr_err("invalid hwlock\n");
>
> These kind of errors can get very spammy for buggy drivers.

Yeah, but that's the purpose - I want to catch such egregious drivers
who try to crash the kernel.

> It's likely
> more useful to either do a WARN_ON(), and/or move them under a debug
> config option.

Why would you prefer to compile out reporting of such extremely buggy behavior ?

>
>> +             return -EINVAL;
>> +     }
>> +     if (unlikely(mode == HWLOCK_IRQSTATE && flags == NULL)) {
>> +             pr_err("invalid flags pointer (null)\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     /*
>> +      * This spin_lock{_irq, _irqsave} serves three purposes:
>> +      *
>> +      * 1. Disable preemption, in order to minimize the period of time
>> +      *    in which the hwspinlock is taken. This is important in order
>> +      *    to minimize the possible polling on the hardware interconnect
>> +      *    by a remote user of this lock.
>> +      * 2. Make the hwspinlock SMP-safe (so we can take it from
>> +      *    additional contexts on the local host).
>> +      * 3. Ensure that in_atomic/might_sleep checks catch potential
>> +      *    problems with hwspinlock usage (e.g. scheduler checks like
>> +      *    'scheduling while atomic' etc.)
>> +      */
>> +     if (mode == HWLOCK_IRQSTATE)
>> +             ret = spin_trylock_irqsave(&hwlock->lock, *flags);
>> +     else if (mode == HWLOCK_IRQ)
>> +             ret = spin_trylock_irq(&hwlock->lock);
>> +     else
>> +             ret = spin_trylock(&hwlock->lock);
>> +
>> +     /* is lock already taken by another context on the local cpu ? */
>> +     if (!ret)
>> +             return -EBUSY;
>> +
>> +     /* try to take the hwspinlock device */
>> +     ret = hwlock->ops->trylock(hwlock);
>> +
>> +     /* if hwlock is already taken, undo spin_trylock_* and exit */
>> +     if (!ret) {
>> +             if (mode == HWLOCK_IRQSTATE)
>> +                     spin_unlock_irqrestore(&hwlock->lock, *flags);
>> +             else if (mode == HWLOCK_IRQ)
>> +                     spin_unlock_irq(&hwlock->lock);
>> +             else
>> +                     spin_unlock(&hwlock->lock);
>> +
>> +             return -EBUSY;
>> +     }
>> +
>> +     /*
>> +      * We can be sure the other core's memory operations
>> +      * are observable to us only _after_ we successfully take
>> +      * the hwspinlock, so we must make sure that subsequent memory
>> +      * operations will not be reordered before we actually took the
>> +      * hwspinlock.
>> +      *
>> +      * Note: the implicit memory barrier of the spinlock above is too
>> +      * early, so we need this additional explicit memory barrier.
>> +      */
>> +     mb();
>
> rmb() should be sufficient here.

It's not.

We need to make sure that our writes, too, will not be reordered
before that barrier. Otherwise, we might end up changing protected
shared memory during the critical section of the remote processor
(before we acquire the lock we must not read from, or write to, the
protected shared memory).

I guess I need to add a comment about this.

>> +int __hwspin_unlock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
>> +{
>> +     if (unlikely(!hwlock)) {
>> +             pr_err("invalid hwlock\n");
>> +             return -EINVAL;
>> +     }
>> +     if (unlikely(mode == HWLOCK_IRQSTATE && flags == NULL)) {
>> +             pr_err("invalid flags pointer (null)\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     /*
>> +      * We must make sure that memory operations, done before unlocking
>> +      * the hwspinlock, will not be reordered after the lock is released.
>> +      *
>> +      * That's the purpose of this explicit memory barrier.
>> +      *
>> +      * Note: the memory barrier induced by the spin_unlock below is too
>> +      * late; the other core is going to access memory soon after it will
>> +      * take the hwspinlock, and by then we want to be sure our memory
>> +      * operations are already observable.
>> +      */
>> +     mb();
>
> wmb() should be sufficient here.

No - here, too, we need to make sure that also our read operations
will not be reordered after the barrier. Otherwise, we might end up
reading memory that has already been changed by a remote processor
that is just about to acquire the lock.

>
>> +
>> +     hwlock->ops->unlock(hwlock);
>> +
>> +     /* Undo the spin_trylock{_irq, _irqsave} called while locking */
>> +     if (mode == HWLOCK_IRQSTATE)
>> +             spin_unlock_irqrestore(&hwlock->lock, *flags);
>> +     else if (mode == HWLOCK_IRQ)
>> +             spin_unlock_irq(&hwlock->lock);
>> +     else
>> +             spin_unlock(&hwlock->lock);
>> +
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(__hwspin_unlock);
>> +

>> +     /* mark this hwspinlock as available */
>> +     tmp = radix_tree_tag_set(&hwspinlock_tree, hwlock->id,
>> +                                                     HWSPINLOCK_UNUSED);
>> +
>> +     /* this implies an unrecoverable bug. at least rant */
>> +     WARN_ON(tmp != hwlock);
>
> I don't see how this could ever happen?

It can't. Unless there's a bug somewhere.

That's why:
1. It is a WARN_ON - I don't care if someone compiles this out
2. There is no error handler for this (simply because there can never
be an error handler for buggy code). It's just a rant, meant to catch
an unlikely buggy event.

The reason I did this is because I like to check return values. Even
if it's only for sanity sake.

Since it's not a hot path this shouldn't matter to anyone, but if
people are still bothered by it, it can be removed.

>> +/**
>> + * hwspinlock_unregister() - unregister an hw spinlock
>> + * @id: index of the specific hwspinlock to unregister
>> + *
>> + * This function should be called from the underlying platform-specific
>> + * implementation, to unregister an existing (and unused) hwspinlock.
>> + *
>> + * Can be called from an atomic context (will not sleep) but not from
>> + * within interrupt context.
>> + *
>> + * Returns the address of hwspinlock @id on success, or NULL on failure
>
> Why not just return int for success / fail and have the driver keep track
> of the lock pointers too?

Because it's elegant. This way drivers don't need to keep track of the pointers.

It can be changed, with an extra cost of code (duplicated for each
implementation) and memory, but why would we want to do that ?

> Or, if you for some reason is attached to the ptr-return case, please make it return
> standard ERR_PTR instead.

ERR_PTR patterns have been reasonably argued against in the previous
discussion, and I heartily agreed (see
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg37453.html).

>> +     /* look for an unused lock */
>> +     ret = radix_tree_gang_lookup_tag(&hwspinlock_tree, (void **)&hwlock,
>> +                                             0, 1, HWSPINLOCK_UNUSED);
>> +     if (ret == 0) {
>> +             pr_warn("a free hwspinlock is not available\n");
>> +             hwlock = NULL;
>> +             goto out;
>> +     }
>> +
>> +     /* sanity check: we shouldn't get more than we requested for */
>> +     WARN_ON(ret > 1);
>
> No need to check, unless you're debugging the radix code.

Again, this is me preferring to check return values for sanity sake.

The one time that this may yield true (e.g. code has erroneously
changed) is well worth it.

It shouldn't bother anyone since it's not a hot path, but as I said
earlier, if people don't like it that much, it can be removed.

>
>> +     /* mark as used and power up */
>> +     ret = __hwspinlock_request(hwlock);
>> +     if (ret < 0)
>> +             hwlock = NULL;
>> +
>> +out:
>> +     spin_unlock(&hwspinlock_tree_lock);
>> +     return hwlock;
>> +}
>> +EXPORT_SYMBOL_GPL(hwspinlock_request);
>> +
>
> [...]
>
>> +/**
>> + * hwspinlock_free() - free a specific hwspinlock
>> + * @hwlock: the specific hwspinlock to free
>> + *
>> + * This function mark @hwlock as free again.
>> + * Should only be called with an @hwlock that was retrieved from
>> + * an earlier call to omap_hwspinlock_request{_specific}.
>> + *
>> + * Can be called from an atomic context (will not sleep) but not from
>> + * within interrupt context (simply because there is no use case for
>> + * that yet).
>> + *
>> + * Returns 0 on success, or an appropriate error code on failure
>> + */
>> +int hwspinlock_free(struct hwspinlock *hwlock)
>> +{
>> +     struct hwspinlock *tmp;
>> +     int ret;
>> +
>> +     if (!hwlock) {
>
> Some alloc/free APIs will just silently return for these cases.

True.

Some other free API will simply crash.

Does it bother so much if we stick to the safe side here ?

>
>> +             pr_err("invalid hwlock\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     spin_lock(&hwspinlock_tree_lock);
>> +
>> +     /* make sure the hwspinlock is used */
>> +     ret = radix_tree_tag_get(&hwspinlock_tree, hwlock->id,
>> +                                                     HWSPINLOCK_UNUSED);
>> +     if (ret == 1) {
>> +             dev_err(hwlock->dev, "%s: hwlock is already free\n", __func__);
>
> Double free. WARN_ON() seems appropriate?

I don't want that this message will ever get compiled out.

>
>> +             ret = -EINVAL;
>> +             goto out;
>> +     }
>> +
>> +     /* notify the underlying device that power is not needed */
>> +     ret = pm_runtime_put(hwlock->dev);
>> +     if (ret < 0)
>> +             goto out;
>> +
>> +     /* mark this hwspinlock as available */
>> +     tmp = radix_tree_tag_set(&hwspinlock_tree, hwlock->id,
>> +                                                     HWSPINLOCK_UNUSED);
>> +
>> +     /* sanity check (this shouldn't happen) */
>> +     WARN_ON(tmp != hwlock);
>
> No need for this.

Please see explanations above why I added those sanity checks (despite
my explicit comment saying this shouldn't happen).


Thanks!
Ohad.

>
>> +
>> +     module_put(hwlock->owner);
>> +
>> +out:
>> +     spin_unlock(&hwspinlock_tree_lock);
>> +     return ret;
>> +}
>> +EXPORT_SYMBOL_GPL(hwspinlock_free);
>> +
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_DESCRIPTION("Generic hardware spinlock interface");
>> +MODULE_AUTHOR("Ohad Ben-Cohen <ohad@wizery.com>");
>
>
>
>
