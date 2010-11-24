Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab0KXT7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:59:39 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36270 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab0KXT7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:59:37 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.224.233]
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59302479315FB@dbde02.ent.ti.com>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com>
 <1290526740-27624-2-git-send-email-ohad@wizery.com> <B85A65D85D7EB246BE421B3FB0FBB59302479315FB@dbde02.ent.ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 24 Nov 2010 21:59:15 +0200
Message-ID: <AANLkTi=JSuJCqceJ3iw3TnV5OeJd+e5T3CyHtWVzBRu_@mail.gmail.com>
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

Hi Mugdha,

On Wed, Nov 24, 2010 at 9:44 AM, Kamoolkar, Mugdha <mugdha@ti.com> wrote:
> How do multiple clients get a handle that they can use? Are they expected to
> share the handle they get from the call above?

Currently, yes.

> What if they are independent
> clients with no means of communication between them? There may be a need of
> an API that returns the handle for a specific ID. For example, a module over
> the hwspinlock driver that does some level of management of IDs (e.g. name
> to ID mapping) and enables users to get multi-core as well as multi-client
> protection on Linux.

I'm not sure I understand the use case. Can you please elaborate ?

> For example:
> struct hwspinlock *hwspinlock_get_handle(unsigned int id);

I'm afraid such an API will be easily abused, e.g., drivers that will
try to use a predefined hwspinlock id without taking care of reserving
it early enough will probably use it to overcome an "oops this
hwspinlock has already been assigned to someone else".

So let me suggest we should first understand the use case for the API
you propose, and then see how we solve it ?

> Why are some of the APIs hwspinlock_ and others hwspin_?

I'm following the regular spinlock naming, which nicely avoids having
the word 'lock' twice in the API. So you get APIs like hwspin_lock,
hwspin_unlock, hwspin_trylock. In our case we still have stuff like
hwspinlock_request and hwspinlock_free. I can probably make it
hwspin_lock_request, does that look nicer ?

>> +  int hwspin_lock_timeout(struct hwspinlock *hwlock, unsigned long timeout);
>> +   - lock a previously-assigned hwspinlock with a timeout limit (specified in
>> +     jiffies). If the hwspinlock is already taken, the function will busy
>> loop
>> +     waiting for it to be released, but give up when the timeout meets
>> jiffies.
>> +     If timeout is 0, the function will never give up (therefore if a faulty
>> +     remote core never releases the hwspinlock, it will deadlock).
> If timeout is 0, shouldn't it rather behave as a trylock? If timeout is
> MAX_SCHEDULE_TIMEOUT, then it should behave as a wait-forever.

Good point, thanks!

>> +  int hwspin_trylock(struct hwspinlock *hwlock);
>> +   - attempt to lock a previously-assigned hwspinlock, but immediately fail
>> if
>> +     it is already taken.
>> +     Upon a successful return from this function, preemption is disabled so
>> +     caller must not sleep, and is advised to release the hwspinlock as soon
>> as
>> +     possible, in order to minimize remote cores polling on the hardware
>> +     interconnect.
>> +     Returns 0 on success and an appropriate error code otherwise (most
>> +     notably -EBUSY if the hwspinlock was already taken).
>> +     The function will never sleep.
> Is this function needed at all if timeout 0 behaves similar to trylock?

Yeah. Drivers should use the _trylock version when applicable because
it'd make the code more readable, and it's more intuitive (just like
the spin_trylock API).

>> +  struct hwspinlock *hwspinlock_unregister(unsigned int id);
>> +   - to be called from the underlying vendor-specific implementation, in
>> order
>> +     to unregister an existing (and unused) hwspinlock instance.
>> +     Can be called from an atomic context (will not sleep) but not from
>> +     within interrupt context.
>> +     Returns the address of hwspinlock on success, or NULL on error (e.g.
>> +     if the hwspinlock is sill in use).
> Does this need to be called for all hwspinlocks?

Currently, yes.

I actually am planning an improvement that would allow registering a
block of hwspinlocks; I don't think that the multiple calls of
register/unregister is that bad (it happens only once at boot), but I
want to allow sharing of the owner, ops and dev members of the
hwspinlock instances (to save some memory).

Anyway, it's not a big improvement, so I planned first to get things
merged and then look into stuff like that.

>> +int __hwspin_lock_timeout(struct hwspinlock *hwlock, unsigned long to,
>> +                                     int mode, unsigned long *flags)
>> +{
>> +     int ret;
>> +
>> +     for (;;) {
>> +             /* Try to take the hwspinlock */
>> +             ret = __hwspin_trylock(hwlock, mode, flags);
>> +             if (ret != -EBUSY)
>> +                     break;
>> +
>> +             /*
>> +              * The lock is already taken, let's check if the user wants
>> +              * us to try again
>> +              */
>> +             if (to && time_is_before_eq_jiffies(to))
>> +                     return -ETIMEDOUT;
>> +
>> +             /*
>> +              * Allow platform-specific relax handlers to prevent
>> +              * hogging the interconnect (no sleeping, though)
>> +              */
>> +             if (hwlock->ops->relax)
>> +                     hwlock->ops->relax(hwlock);
> There should be a way to have an escape mechanism for the case where a deadlock
> has occurred due to remote side taking the spinlock and crashing.

This is exactly what the timeout parameter is for..

Thanks,
Ohad.
