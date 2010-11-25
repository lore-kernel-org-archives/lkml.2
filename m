Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab0KYGGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 01:06:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47984 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab0KYGF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 01:05:59 -0500
From: "Kamoolkar, Mugdha" <mugdha@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
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
Date: Thu, 25 Nov 2010 11:35:02 +0530
Subject: RE: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
Thread-Topic: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
Thread-Index: AcuMEiEz01rfvZPORoa+r8HGssToKwARIl4g
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930247931C4B@dbde02.ent.ti.com>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com>
 <1290526740-27624-2-git-send-email-ohad@wizery.com>
 <B85A65D85D7EB246BE421B3FB0FBB59302479315FB@dbde02.ent.ti.com>
 <AANLkTi=JSuJCqceJ3iw3TnV5OeJd+e5T3CyHtWVzBRu_@mail.gmail.com>
In-Reply-To: <AANLkTi=JSuJCqceJ3iw3TnV5OeJd+e5T3CyHtWVzBRu_@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohad,

> -----Original Message-----
> From: Ohad Ben-Cohen [mailto:ohad@wizery.com]
> Sent: Thursday, November 25, 2010 1:29 AM
> To: Kamoolkar, Mugdha
> Cc: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; akpm@linux-foundation.org; Greg KH; Tony
> Lindgren; Cousson, Benoit; Grant Likely; Kanigeri, Hari; Anna, Suman;
> Kevin Hilman; Arnd Bergmann
> Subject: Re: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
> 
> Hi Mugdha,
> 
> On Wed, Nov 24, 2010 at 9:44 AM, Kamoolkar, Mugdha <mugdha@ti.com> wrote:
> > How do multiple clients get a handle that they can use? Are they
> expected to
> > share the handle they get from the call above?
> 
> Currently, yes.
> 
> > What if they are independent
> > clients with no means of communication between them? There may be a need
> of
> > an API that returns the handle for a specific ID. For example, a module
> over
> > the hwspinlock driver that does some level of management of IDs (e.g.
> name
> > to ID mapping) and enables users to get multi-core as well as multi-
> client
> > protection on Linux.
> 
> I'm not sure I understand the use case. Can you please elaborate ?
> 
Consider a software module on top of the hwspinlock, which provides a 
generic way for multi-core critical section, say GateMP. This module enables 
users to create critical section objects by name. Any other client can open 
the critical section by name and get a handle to it. I would expect this 
module to make a call to request a resource when creating the GateMP object. 
Suppose that the object is actually created by the remote core, and the call 
comes to Linux on the host processor to allocate the system resource (as the 
owner of the system resources). It will call hwspinlock_request, get a 
handle, get the ID from it, and return the ID to the remote processor. There 
is no point in the remote processor holding the handle that's not valid in 
its virtual space. The ID, in this case, is the single portable value that 
every processor understands in a different way. When this object were being 
deleted, the ID would be passed to Linux, and a corresponding Linux entity 
would then have to get the handle from the ID and call _free.

Similarly, suppose the creation is happening from user-space, the user-space 
object should store the ID in the user object, and get the handle from the 
ID when performing any actions on the lock from kernel-side.

> > For example:
> > struct hwspinlock *hwspinlock_get_handle(unsigned int id);
> 
> I'm afraid such an API will be easily abused, e.g., drivers that will
> try to use a predefined hwspinlock id without taking care of reserving
> it early enough will probably use it to overcome an "oops this
> hwspinlock has already been assigned to someone else".
> 
Really? Why would they intentionally destabilize the system like this???

> So let me suggest we should first understand the use case for the API
> you propose, and then see how we solve it ?
> 
> > Why are some of the APIs hwspinlock_ and others hwspin_?
> 
> I'm following the regular spinlock naming, which nicely avoids having
> the word 'lock' twice in the API. So you get APIs like hwspin_lock,
> hwspin_unlock, hwspin_trylock. In our case we still have stuff like
> hwspinlock_request and hwspinlock_free. I can probably make it
> hwspin_lock_request, does that look nicer ?
> 
No real issues with this, just seems less intuitive. I just expected all the 
module APIs to follow same convention <module>_API to make them more 
intuitive.

> >> +  int hwspin_lock_timeout(struct hwspinlock *hwlock, unsigned long
> timeout);
> >> +   - lock a previously-assigned hwspinlock with a timeout limit
> (specified in
> >> +     jiffies). If the hwspinlock is already taken, the function will
> busy
> >> loop
> >> +     waiting for it to be released, but give up when the timeout meets
> >> jiffies.
> >> +     If timeout is 0, the function will never give up (therefore if a
> faulty
> >> +     remote core never releases the hwspinlock, it will deadlock).
> > If timeout is 0, shouldn't it rather behave as a trylock? If timeout is
> > MAX_SCHEDULE_TIMEOUT, then it should behave as a wait-forever.
> 
> Good point, thanks!
> 
> >> +  int hwspin_trylock(struct hwspinlock *hwlock);
> >> +   - attempt to lock a previously-assigned hwspinlock, but immediately
> fail
> >> if
> >> +     it is already taken.
> >> +     Upon a successful return from this function, preemption is
> disabled so
> >> +     caller must not sleep, and is advised to release the hwspinlock
> as soon
> >> as
> >> +     possible, in order to minimize remote cores polling on the
> hardware
> >> +     interconnect.
> >> +     Returns 0 on success and an appropriate error code otherwise
> (most
> >> +     notably -EBUSY if the hwspinlock was already taken).
> >> +     The function will never sleep.
> > Is this function needed at all if timeout 0 behaves similar to trylock?
> 
> Yeah. Drivers should use the _trylock version when applicable because
> it'd make the code more readable, and it's more intuitive (just like
> the spin_trylock API).
Agreed.

> 
> >> +  struct hwspinlock *hwspinlock_unregister(unsigned int id);
> >> +   - to be called from the underlying vendor-specific implementation,
> in
> >> order
> >> +     to unregister an existing (and unused) hwspinlock instance.
> >> +     Can be called from an atomic context (will not sleep) but not
> from
> >> +     within interrupt context.
> >> +     Returns the address of hwspinlock on success, or NULL on error
> (e.g.
> >> +     if the hwspinlock is sill in use).
> > Does this need to be called for all hwspinlocks?
> 
> Currently, yes.
> 
Ok, that should be fine.

> I actually am planning an improvement that would allow registering a
> block of hwspinlocks; I don't think that the multiple calls of
> register/unregister is that bad (it happens only once at boot), but I
> want to allow sharing of the owner, ops and dev members of the
> hwspinlock instances (to save some memory).
> 
> Anyway, it's not a big improvement, so I planned first to get things
> merged and then look into stuff like that.
> 
> >> +int __hwspin_lock_timeout(struct hwspinlock *hwlock, unsigned long to,
> >> +                                     int mode, unsigned long *flags)
> >> +{
> >> +     int ret;
> >> +
> >> +     for (;;) {
> >> +             /* Try to take the hwspinlock */
> >> +             ret = __hwspin_trylock(hwlock, mode, flags);
> >> +             if (ret != -EBUSY)
> >> +                     break;
> >> +
> >> +             /*
> >> +              * The lock is already taken, let's check if the user
> wants
> >> +              * us to try again
> >> +              */
> >> +             if (to && time_is_before_eq_jiffies(to))
> >> +                     return -ETIMEDOUT;
> >> +
> >> +             /*
> >> +              * Allow platform-specific relax handlers to prevent
> >> +              * hogging the interconnect (no sleeping, though)
> >> +              */
> >> +             if (hwlock->ops->relax)
> >> +                     hwlock->ops->relax(hwlock);
> > There should be a way to have an escape mechanism for the case where a
> deadlock
> > has occurred due to remote side taking the spinlock and crashing.
> 
> This is exactly what the timeout parameter is for..
> 
I was looking at the situation where someone does not use the lock with 
timeout. In that case, do we say that there's no way out? And the system 
will hang and need a re-boot? Or do we still want to enable some way to 
forcibly break the wait after it has happened for an unreasonably long time?

> Thanks,
> Ohad.
