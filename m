Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab0KYO32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:29:28 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42471 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0KYO30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:29:26 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.224.233]
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB5930247931C4B@dbde02.ent.ti.com>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com>
 <1290526740-27624-2-git-send-email-ohad@wizery.com> <B85A65D85D7EB246BE421B3FB0FBB59302479315FB@dbde02.ent.ti.com>
 <AANLkTi=JSuJCqceJ3iw3TnV5OeJd+e5T3CyHtWVzBRu_@mail.gmail.com> <B85A65D85D7EB246BE421B3FB0FBB5930247931C4B@dbde02.ent.ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 25 Nov 2010 16:29:05 +0200
Message-ID: <AANLkTikBQsBLxo7SG38UOs7ZeU+_XdEtT67Ogxpijmq=@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
To: "Kamoolkar, Mugdha" <mugdha@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Kanigeri, Hari" <h-kanigeri2@ti.com>, "Anna, Suman" <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 8:05 AM, Kamoolkar, Mugdha <mugdha@ti.com> wrote:
> Consider a software module on top of the hwspinlock, which provides a
> generic way for multi-core critical section, say GateMP. This module enables
> users to create critical section objects by name. Any other client can open
> the critical section by name and get a handle to it. I would expect this
> module to make a call to request a resource when creating the GateMP object.
> Suppose that the object is actually created by the remote core, and the call
> comes to Linux on the host processor to allocate the system resource (as the
> owner of the system resources). It will call hwspinlock_request, get a
> handle, get the ID from it, and return the ID to the remote processor. There
> is no point in the remote processor holding the handle that's not valid in
> its virtual space. The ID, in this case, is the single portable value that
> every processor understands in a different way. When this object were being
> deleted, the ID would be passed to Linux, and a corresponding Linux entity
> would then have to get the handle from the ID and call _free.

How is it different from any other hardware resource that the host
will allocate on behalf of the slaves ? Do we have such _open API for,
e.g., dmtimer ?

It looks like this is a broader problem that needs to be solved by the
kernel module that will manage the resources of the remote processors.

>
> Similarly, suppose the creation is happening from user-space, the user-space
> object should store the ID in the user object, and get the handle from the
> ID when performing any actions on the lock from kernel-side.

The user space interface is not yet defined, but -

One option is to expose a char device for every hwspinlock device,
that can only be opened by a single user (which, after successfully
opening it, will become its owner). Once that user will close the
device (either consciously or by crashing), the kernel will free the
resource. It doesn't look like an _open API is needed here.

>> > For example:
>> > struct hwspinlock *hwspinlock_get_handle(unsigned int id);
>>
>> I'm afraid such an API will be easily abused, e.g., drivers that will
>> try to use a predefined hwspinlock id without taking care of reserving
>> it early enough will probably use it to overcome an "oops this
>> hwspinlock has already been assigned to someone else".
>>
> Really? Why would they intentionally destabilize the system like this???

These things just happen.. even by mistake.

But I rather focus on the "why yes" rather than on the "why not".
Let's define the problem exactly, and then see how to solve it
correctly. Btw it might still end up being an _open API if we find it
as the best solution (but let's first see that we understand the
problem first).

> No real issues with this, just seems less intuitive. I just expected all the
> module APIs to follow same convention <module>_API to make them more
> intuitive.

Then I'll change it, it does might look better.

>> >> +int __hwspin_lock_timeout(struct hwspinlock *hwlock, unsigned long to,
>> >> +                                     int mode, unsigned long *flags)
>> >> +{
>> >> +     int ret;
>> >> +
>> >> +     for (;;) {
>> >> +             /* Try to take the hwspinlock */
>> >> +             ret = __hwspin_trylock(hwlock, mode, flags);
>> >> +             if (ret != -EBUSY)
>> >> +                     break;
>> >> +
>> >> +             /*
>> >> +              * The lock is already taken, let's check if the user
>> wants
>> >> +              * us to try again
>> >> +              */
>> >> +             if (to && time_is_before_eq_jiffies(to))
>> >> +                     return -ETIMEDOUT;
>> >> +
>> >> +             /*
>> >> +              * Allow platform-specific relax handlers to prevent
>> >> +              * hogging the interconnect (no sleeping, though)
>> >> +              */
>> >> +             if (hwlock->ops->relax)
>> >> +                     hwlock->ops->relax(hwlock);
>> > There should be a way to have an escape mechanism for the case where a
>> deadlock
>> > has occurred due to remote side taking the spinlock and crashing.
>>
>> This is exactly what the timeout parameter is for..
>>
> I was looking at the situation where someone does not use the lock with
> timeout.
> In that case, do we say that there's no way out?

If one decides to use the simple _lock version, then yes (just like
with spin_lock()).

But if the user cares about an optional crash of the remote task, then
definitely the _timeout version should be used - that's why we
provided it.

We can remove the _lock version altogether, but I don't think it's a
good thing. A user can still use the _timeout version with infinite
timeout, which would yield the same result. The _lock version is
provided for simple cases, where a timeout isn't required.

Thanks,
Ohad.

> And the system
> will hang and need a re-boot? Or do we still want to enable some way to
> forcibly break the wait after it has happened for an unreasonably long time?
>
>> Thanks,
>> Ohad.
>
