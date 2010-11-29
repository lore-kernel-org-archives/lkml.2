Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab0K2VbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 16:31:24 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63301 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab0K2VbW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 16:31:22 -0500
MIME-Version: 1.0
X-Originating-IP: [192.91.75.238]
In-Reply-To: <20101126225134.GB27223@lixom.net>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com>
 <1290526740-27624-2-git-send-email-ohad@wizery.com> <20101126045912.GC6598@lixom.net>
 <AANLkTin5Tfcuy0WcHJ22rWC8niwZCj8SZAMKLz0p9jwc@mail.gmail.com> <20101126225134.GB27223@lixom.net>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 29 Nov 2010 13:31:00 -0800
Message-ID: <AANLkTinxZVVpJMccsgMnVGg3Kp-wCyyz9EKPZCFoVE-E@mail.gmail.com>
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

Hi Olof,

On Sat, Nov 27, 2010 at 12:51 AM, Olof Johansson <olof@lixom.net> wrote:
>> >> +int __hwspin_trylock(struct hwspinlock *hwlock, int mode, unsigned long *flags)
>> >> +{
>> >> +     int ret;
>> >> +
>> >> +     if (unlikely(!hwlock)) {
>> >> +             pr_err("invalid hwlock\n");
>> >
>> > These kind of errors can get very spammy for buggy drivers.
>>
>> Yeah, but that's the purpose - I want to catch such egregious drivers
>> who try to crash the kernel.
...
> Anyway, above plus a __WARN() would be OK with me.

Np, but let's wait a bit to see if something like the
BUG_ON_MAPPABLE_NULL macro materializes or not. That should satisfy
everyone in a generic way.

>> >> +     /*
>> >> +      * We can be sure the other core's memory operations
>> >> +      * are observable to us only _after_ we successfully take
>> >> +      * the hwspinlock, so we must make sure that subsequent memory
>> >> +      * operations will not be reordered before we actually took the
>> >> +      * hwspinlock.
>> >> +      *
>> >> +      * Note: the implicit memory barrier of the spinlock above is too
>> >> +      * early, so we need this additional explicit memory barrier.
>> >> +      */
>> >> +     mb();
>> >
>> > rmb() should be sufficient here.
>>
>> It's not.
>>
>> We need to make sure that our writes, too, will not be reordered
>> before that barrier. Otherwise, we might end up changing protected
>> shared memory during the critical section of the remote processor
>> (before we acquire the lock we must not read from, or write to, the
>> protected shared memory).
>>
>> I guess I need to add a comment about this.
>
> How is the shared memory mapped? It should be mapped such that speculative
> writes shouldn't be happening, and presumably such that hardware-triggered
> prefetces won't happen either.

That's up to the users of hwspinlock to take care of, we shouldn't
worry about it here.

> For those cases a DMB should be sufficient
> on ARM, a DSB shouldn't be needed?
>
> Maybe it would make more sense to move the barriers down into the
> implementation-specific layer, where the appropriate low-level barries
> can be used instead of the generic rmb()/wmb()/mb() ones that tend to
> be heavy-handed where implementations don't match generic requirements.
...
> Still, could be useful to push down to hardware-specific layers and use
> just the specific barrier needed.

But that's what mb/wmb/rmb are for - we use mb because we care of both
read and write reordering - and then it's up to platform-specific code
to implement it correctly. We shouldn't worry about the
platform-specific implementation of mb/wmb/rmb in drivers.

>> >> +     /* this implies an unrecoverable bug. at least rant */
>> >> +     WARN_ON(tmp != hwlock);
>> >
>> > I don't see how this could ever happen?
>>
>> It can't. Unless there's a bug somewhere.
>
> If it's an unrecoverable bug, then you should panic(). Or BUG_ON(),
> which can also be compiled out.

Sure.

> Anyway, I'm not going to argue more over this one (and the others like
> it). It just seemed redundant and other subsystems tend to rely on
> low-level services working correctly. :)

It's not entirely about checking other subsystems: in a way, one can
also look at it as sanity checks to the hwspinlock framework itself.

For example, when we fetch an hwlock object, and then make sure the id
of the hwlock really match the id we looked for, we get a sanity-level
confidence that our data isn't messed up, and that the radix tree was
pretty much used correctly so far.

If, for some reason, that check would fail, that doesn't necessarily
mean the radix code is faulty: it just means something went really
bad, and for some reason the incorrect object is stored with the id we
looked for. It can also be hwspinlock's fault.

It's important to detect such an anomaly as early as possible,
otherwise the wrong lock is going to be used, user data might be
corrupted, and in general, it's going to be veeeery hard to debug
this.

So I consider this a low-cost check with very high value, and if it
would be triggered even once in the lifetime of hwspinlock, it's well
worth it.

>
>> >> +/**
>> >> + * hwspinlock_unregister() - unregister an hw spinlock
>> >> + * @id: index of the specific hwspinlock to unregister
>> >> + *
>> >> + * This function should be called from the underlying platform-specific
>> >> + * implementation, to unregister an existing (and unused) hwspinlock.
>> >> + *
>> >> + * Can be called from an atomic context (will not sleep) but not from
>> >> + * within interrupt context.
>> >> + *
>> >> + * Returns the address of hwspinlock @id on success, or NULL on failure
>> >
>> > Why not just return int for success / fail and have the driver keep track
>> > of the lock pointers too?
>>
>> Because it's elegant. This way drivers don't need to keep track of the pointers.
>>
>> It can be changed, with an extra cost of code (duplicated for each
>> implementation) and memory, but why would we want to do that ?
>
> "Functions should be short and sweet, and do just one thing"

Do you consider radix_tree_delete() inappropriate then ?

>
> It is now a hwspinlock_unregister_and_return(). Making a function to
> lookup id->lockptr (and possibly passing that to the unregister function)
> would take care of that

Such a function is redundant - as this functionality is already
provided in radix_tree_delete, and it'd be a pity not to use it. One
doesn't have to use this return value though, but it really helps
simplifying the users with no additional cost.

>, if you don't want to track the lock pointers in the
> lowlevel driver.
>

>> >> +int hwspinlock_free(struct hwspinlock *hwlock)
>> >> +{
>> >> +     struct hwspinlock *tmp;
>> >> +     int ret;
>> >> +
>> >> +     if (!hwlock) {
>> >
>> > Some alloc/free APIs will just silently return for these cases.
>>
>> True.
>>
>> Some other free API will simply crash.
>>
>> Does it bother so much if we stick to the safe side here ?
>
> The main benefit of doing a silent return and allowing a free of a NULL
> pointer is that it makes cleanup of failed init/setup a bit simpler:
> you can just iterate over the potentially created hwlocks and free them
> even if they haven't been allocated (as long as the pointers initialize
> as NULL).

It feels to me like encouraging sloppy coding, especially since we're
talking about hardware resources here, but maybe I'm overlooking a
real use case here...

>> >> +             pr_err("invalid hwlock\n");
>> >> +             return -EINVAL;
>> >> +     }
>> >> +
>> >> +     spin_lock(&hwspinlock_tree_lock);
>> >> +
>> >> +     /* make sure the hwspinlock is used */
>> >> +     ret = radix_tree_tag_get(&hwspinlock_tree, hwlock->id,
>> >> +                                                     HWSPINLOCK_UNUSED);
>> >> +     if (ret == 1) {
>> >> +             dev_err(hwlock->dev, "%s: hwlock is already free\n", __func__);
>> >
>> > Double free. WARN_ON() seems appropriate?
>>
>> I don't want that this message will ever get compiled out.
>
> Again adding a __WARN() would make both of us happy. :)

Sure.

Thanks,
Ohad.
