Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab0KZWvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 17:51:36 -0500
Received: from mail.lixom.net ([70.86.134.90]:51058 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab0KZWvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 17:51:35 -0500
Date: Fri, 26 Nov 2010 16:51:34 -0600
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
Message-ID: <20101126225134.GB27223@lixom.net>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com> <1290526740-27624-2-git-send-email-ohad@wizery.com> <20101126045912.GC6598@lixom.net> <AANLkTin5Tfcuy0WcHJ22rWC8niwZCj8SZAMKLz0p9jwc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin5Tfcuy0WcHJ22rWC8niwZCj8SZAMKLz0p9jwc@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 26, 2010 at 10:53:10AM +0200, Ohad Ben-Cohen wrote:
> On Fri, Nov 26, 2010 at 6:59 AM, Olof Johansson <olof@lixom.net> wrote:
> >> +#define pr_fmt(fmt)    "%s: " fmt, __func__
> >
> > Not used.
> 
> Yes, it is, check out how the pr_* macros are implemented:

Yep, my bad.

> >> +int __hwspin_trylock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
> >> +{
> >> +     int ret;
> >> +
> >> +     if (unlikely(!hwlock)) {
> >> +             pr_err("invalid hwlock\n");
> >
> > These kind of errors can get very spammy for buggy drivers.
> 
> Yeah, but that's the purpose - I want to catch such egregious drivers
> who try to crash the kernel.

You're not really catching the driver, since nothing points at what
made this be printed in syslog. That's why WARN_ON/__WARN has a benefit.

> > It's likely
> > more useful to either do a WARN_ON(), and/or move them under a debug
> > config option.
> 
> Why would you prefer to compile out reporting of such extremely buggy behavior ?

It's not about compiling out. WARN_ON gives a stack trace of the caller
that broke the calling conventions, which makes it much easier to
pinpoint in a bug report than "I have 300 entries of "invalid hwlock"
in my syslog".

Most cases this will happen in is devleopment though, where it's more
helpful to get the stack backtrace.

Anyway, above plus a __WARN() would be OK with me. It should probably be
rate limited though, to avoid completely wedging a system with debug
printouts if it happens frequently, which locking can do.

> >> +     /*
> >> +      * We can be sure the other core's memory operations
> >> +      * are observable to us only _after_ we successfully take
> >> +      * the hwspinlock, so we must make sure that subsequent memory
> >> +      * operations will not be reordered before we actually took the
> >> +      * hwspinlock.
> >> +      *
> >> +      * Note: the implicit memory barrier of the spinlock above is too
> >> +      * early, so we need this additional explicit memory barrier.
> >> +      */
> >> +     mb();
> >
> > rmb() should be sufficient here.
> 
> It's not.
> 
> We need to make sure that our writes, too, will not be reordered
> before that barrier. Otherwise, we might end up changing protected
> shared memory during the critical section of the remote processor
> (before we acquire the lock we must not read from, or write to, the
> protected shared memory).
> 
> I guess I need to add a comment about this.

How is the shared memory mapped? It should be mapped such that speculative
writes shouldn't be happening, and presumably such that hardware-triggered
prefetces won't happen either. For those cases a DMB should be sufficient
on ARM, a DSB shouldn't be needed?

Maybe it would make more sense to move the barriers down into the
implementation-specific layer, where the appropriate low-level barries
can be used instead of the generic rmb()/wmb()/mb() ones that tend to
be heavy-handed where implementations don't match generic requirements.

> > wmb() should be sufficient here.
> 
> No - here, too, we need to make sure that also our read operations
> will not be reordered after the barrier. Otherwise, we might end up
> reading memory that has already been changed by a remote processor
> that is just about to acquire the lock.

You're right, I guess I haven't worked enough with completely
out-of-order systems, since I'm used to wmb() ordering reads as well.

Still, could be useful to push down to hardware-specific layers and use
just the specific barrier needed.

> >> +     /* this implies an unrecoverable bug. at least rant */
> >> +     WARN_ON(tmp != hwlock);
> >
> > I don't see how this could ever happen?
> 
> It can't. Unless there's a bug somewhere.

If it's an unrecoverable bug, then you should panic(). Or BUG_ON(),
which can also be compiled out.

> That's why:
> 1. It is a WARN_ON - I don't care if someone compiles this out
> 2. There is no error handler for this (simply because there can never
> be an error handler for buggy code). It's just a rant, meant to catch
> an unlikely buggy event.
> 
> The reason I did this is because I like to check return values. Even
> if it's only for sanity sake.
> 
> Since it's not a hot path this shouldn't matter to anyone, but if
> people are still bothered by it, it can be removed.

In general, the kernel is low on asserts for catching bugs in used services.

Anyway, I'm not going to argue more over this one (and the others like
it). It just seemed redundant and other subsystems tend to rely on
low-level services working correctly. :)

> >> +/**
> >> + * hwspinlock_unregister() - unregister an hw spinlock
> >> + * @id: index of the specific hwspinlock to unregister
> >> + *
> >> + * This function should be called from the underlying platform-specific
> >> + * implementation, to unregister an existing (and unused) hwspinlock.
> >> + *
> >> + * Can be called from an atomic context (will not sleep) but not from
> >> + * within interrupt context.
> >> + *
> >> + * Returns the address of hwspinlock @id on success, or NULL on failure
> >
> > Why not just return int for success / fail and have the driver keep track
> > of the lock pointers too?
> 
> Because it's elegant. This way drivers don't need to keep track of the pointers.
>
> It can be changed, with an extra cost of code (duplicated for each
> implementation) and memory, but why would we want to do that ?

"Functions should be short and sweet, and do just one thing"

It is now a hwspinlock_unregister_and_return(). Making a function to
lookup id->lockptr (and possibly passing that to the unregister function)
would take care of that, if you don't want to track the lock pointers in the
lowlevel driver.

> > Or, if you for some reason is attached to the ptr-return case, please make it return
> > standard ERR_PTR instead.
> 
> ERR_PTR patterns have been reasonably argued against in the previous
> discussion, and I heartily agreed (see
> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg37453.html).

Fair enough.

> >> +     /* look for an unused lock */
> >> +     ret = radix_tree_gang_lookup_tag(&hwspinlock_tree, (void **)&hwlock,
> >> +                                             0, 1, HWSPINLOCK_UNUSED);
> >> +     if (ret == 0) {
> >> +             pr_warn("a free hwspinlock is not available\n");
> >> +             hwlock = NULL;
> >> +             goto out;
> >> +     }
> >> +
> >> +     /* sanity check: we shouldn't get more than we requested for */
> >> +     WARN_ON(ret > 1);
> >
> > No need to check, unless you're debugging the radix code.
> 
> Again, this is me preferring to check return values for sanity sake.
> 
> The one time that this may yield true (e.g. code has erroneously
> changed) is well worth it.
>
> It shouldn't bother anyone since it's not a hot path, but as I said
> earlier, if people don't like it that much, it can be removed.
> 
> >
> >> +     /* mark as used and power up */
> >> +     ret = __hwspinlock_request(hwlock);
> >> +     if (ret < 0)
> >> +             hwlock = NULL;
> >> +
> >> +out:
> >> +     spin_unlock(&hwspinlock_tree_lock);
> >> +     return hwlock;
> >> +}
> >> +EXPORT_SYMBOL_GPL(hwspinlock_request);
> >> +
> >
> > [...]
> >
> >> +/**
> >> + * hwspinlock_free() - free a specific hwspinlock
> >> + * @hwlock: the specific hwspinlock to free
> >> + *
> >> + * This function mark @hwlock as free again.
> >> + * Should only be called with an @hwlock that was retrieved from
> >> + * an earlier call to omap_hwspinlock_request{_specific}.
> >> + *
> >> + * Can be called from an atomic context (will not sleep) but not from
> >> + * within interrupt context (simply because there is no use case for
> >> + * that yet).
> >> + *
> >> + * Returns 0 on success, or an appropriate error code on failure
> >> + */
> >> +int hwspinlock_free(struct hwspinlock *hwlock)
> >> +{
> >> +     struct hwspinlock *tmp;
> >> +     int ret;
> >> +
> >> +     if (!hwlock) {
> >
> > Some alloc/free APIs will just silently return for these cases.
> 
> True.
> 
> Some other free API will simply crash.
> 
> Does it bother so much if we stick to the safe side here ?

The main benefit of doing a silent return and allowing a free of a NULL
pointer is that it makes cleanup of failed init/setup a bit simpler:
you can just iterate over the potentially created hwlocks and free them
even if they haven't been allocated (as long as the pointers initialize
as NULL).

> >> +             pr_err("invalid hwlock\n");
> >> +             return -EINVAL;
> >> +     }
> >> +
> >> +     spin_lock(&hwspinlock_tree_lock);
> >> +
> >> +     /* make sure the hwspinlock is used */
> >> +     ret = radix_tree_tag_get(&hwspinlock_tree, hwlock->id,
> >> +                                                     HWSPINLOCK_UNUSED);
> >> +     if (ret == 1) {
> >> +             dev_err(hwlock->dev, "%s: hwlock is already free\n", __func__);
> >
> > Double free. WARN_ON() seems appropriate?
> 
> I don't want that this message will ever get compiled out.

Again adding a __WARN() would make both of us happy. :)

> >> +             ret = -EINVAL;
> >> +             goto out;
> >> +     }
> >> +
> >> +     /* notify the underlying device that power is not needed */
> >> +     ret = pm_runtime_put(hwlock->dev);
> >> +     if (ret < 0)
> >> +             goto out;
> >> +
> >> +     /* mark this hwspinlock as available */
> >> +     tmp = radix_tree_tag_set(&hwspinlock_tree, hwlock->id,
> >> +                                                     HWSPINLOCK_UNUSED);
> >> +
> >> +     /* sanity check (this shouldn't happen) */
> >> +     WARN_ON(tmp != hwlock);
> >
> > No need for this.
> 
> Please see explanations above why I added those sanity checks (despite
> my explicit comment saying this shouldn't happen).

See above replies.


-Olof
