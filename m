Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab0KXHpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 02:45:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40893 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab0KXHpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 02:45:11 -0500
From: "Kamoolkar, Mugdha" <mugdha@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Kanigeri, Hari" <h-kanigeri2@ti.com>, "Anna, Suman" <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Date: Wed, 24 Nov 2010 13:14:30 +0530
Subject: RE: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
Thread-Topic: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
Thread-Index: AcuLJ+BU93KPJ9djSrS6+I4CA+BIUgAgy+og
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59302479315FB@dbde02.ent.ti.com>
References: <1290526740-27624-1-git-send-email-ohad@wizery.com>
 <1290526740-27624-2-git-send-email-ohad@wizery.com>
In-Reply-To: <1290526740-27624-2-git-send-email-ohad@wizery.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohad,

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Ohad Ben-Cohen
> Sent: Tuesday, November 23, 2010 9:09 PM
> To: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org
> Cc: akpm@linux-foundation.org; Greg KH; Tony Lindgren; Cousson, Benoit;
> Grant Likely; Kanigeri, Hari; Anna, Suman; Kevin Hilman; Arnd Bergmann;
> Ohad Ben-Cohen
> Subject: [PATCH v2 1/4] drivers: hwspinlock: add generic framework
>
> Add a common, platform-independent, hwspinlock framework.
>
> Hardware spinlock devices are needed, e.g., in order to access data
> that is shared between remote processors, that otherwise have no
> alternative mechanism to accomplish synchronization and mutual exclusion
> operations.
>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Hari Kanigeri <h-kanigeri2@ti.com>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Tony Lindgren <tony@atomide.com>
> ---
>  Documentation/hwspinlock.txt         |  339 ++++++++++++++++++++
>  drivers/Kconfig                      |    2 +
>  drivers/Makefile                     |    1 +
>  drivers/hwspinlock/Kconfig           |   13 +
>  drivers/hwspinlock/Makefile          |    5 +
>  drivers/hwspinlock/hwspinlock.h      |   61 ++++
>  drivers/hwspinlock/hwspinlock_core.c |  561
> ++++++++++++++++++++++++++++++++++
>  include/linux/hwspinlock.h           |  376 +++++++++++++++++++++++
>  8 files changed, 1358 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/hwspinlock.txt
>  create mode 100644 drivers/hwspinlock/Kconfig
>  create mode 100644 drivers/hwspinlock/Makefile
>  create mode 100644 drivers/hwspinlock/hwspinlock.h
>  create mode 100644 drivers/hwspinlock/hwspinlock_core.c
>  create mode 100644 include/linux/hwspinlock.h
>
> diff --git a/Documentation/hwspinlock.txt b/Documentation/hwspinlock.txt
> new file mode 100644
> index 0000000..ccbf5de
> --- /dev/null
> +++ b/Documentation/hwspinlock.txt
> @@ -0,0 +1,339 @@
> +Common Hardware Spinlock Framework
> +
> +1. Introduction
> +
> +Hardware spinlock modules provide hardware assistance for synchronization
> +and mutual exclusion between heterogeneous processors and those not
> operating
> +under a single, shared operating system.
> +
> +For example, OMAP4 has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP,
> +each of which is running a different Operating System (the master, A9,
> +is usually running Linux and the slave processors, the M3 and the DSP,
> +are running some flavor of RTOS).
> +
> +A generic hwspinlock framework allows platform-independent drivers to use
> +the hwspinlock device in order to access data structures that are shared
> +between remote processors, that otherwise have no alternative mechanism
> +to accomplish synchronization and mutual exclusion operations.
> +
> +This is necessary, for example, for Inter-processor communications:
> +on OMAP4, cpu-intensive multimedia tasks are offloaded by the host to the
> +remote M3 and/or C64x+ slave processors (by an IPC subsystem called
> Syslink).
> +
> +To achieve fast message-based communications, a minimal kernel support
> +is needed to deliver messages arriving from a remote processor to the
> +appropriate user process.
> +
> +This communication is based on simple data structures that is shared
> between
> +the remote processors, and access to it is synchronized using the
> hwspinlock
> +module (remote processor directly places new messages in this shared data
> +structure).
> +
> +A common hwspinlock interface makes it possible to have generic,
> platform-
> +independent, drivers.
> +
> +2. User API
> +
> +  struct hwspinlock *hwspinlock_request(void);
> +   - dynamically assign an hwspinlock and return its address, or NULL
> +     in case an unused hwspinlock isn't available. Users of this
> +     API will usually want to communicate the lock's id to the remote core
> +     before it can be used to achieve synchronization.
> +     Can be called from an atomic context (this function will not sleep) but
> +     not from within interrupt context.
How do multiple clients get a handle that they can use? Are they expected to
share the handle they get from the call above? What if they are independent
clients with no means of communication between them? There may be a need of
an API that returns the handle for a specific ID. For example, a module over
the hwspinlock driver that does some level of management of IDs (e.g. name
to ID mapping) and enables users to get multi-core as well as multi-client
protection on Linux.

For example:
struct hwspinlock *hwspinlock_get_handle(unsigned int id);

> +
> +  struct hwspinlock *hwspinlock_request_specific(unsigned int id);
> +   - assign a specific hwspinlock id and return its address, or NULL
> +     if that hwspinlock is already in use. Usually board code will
> +     be calling this function in order to reserve specific hwspinlock
> +     ids for predefined purposes.
> +     Can be called from an atomic context (this function will not sleep) but
> +     not from within interrupt context.
> +
> +  int hwspinlock_free(struct hwspinlock *hwlock);
> +   - free a previously-assigned hwspinlock; returns 0 on success, or an
> +     appropriate error code on failure (e.g. -EINVAL if the hwspinlock
> +     is already free).
> +     Can be called from an atomic context (this function will not sleep) but
> +     not from within interrupt context.
> +
> +  int hwspin_lock(struct hwspinlock *hwlock);
> +   - lock a previously assigned hwspinlock. If the hwspinlock is already
> +     taken, the function will busy loop waiting for it to be released.
> +     Note: if a faulty remote core never releases this lock, this function
> +     will deadlock.
> +     This function will fail only if hwlock is invalid. Otherwise, it will
> +     always succeed (or deadlock; see above) and it will never sleep.
> +     Upon a successful return from this function, preemption is disabled so
> +     the caller must not sleep, and is advised to release the hwspinlock as
> +     soon as possible, in order to minimize remote cores polling on the
> +     hardware interconnect.
Why are some of the APIs hwspinlock_ and others hwspin_?

> +
> +  int hwspin_lock_irq(struct hwspinlock *hwlock);
> +   - lock a previously assigned hwspinlock. If the hwspinlock is already
> +     taken, the function will busy loop waiting for it to be released.
> +     Note: if a faulty remote core never releases this lock, this
> function
> +     will deadlock.
> +     This function will fail only if hwlock is invalid. Otherwise, it will
> +     always succeed (or deadlock; see above) and it will never sleep.
> +     Upon a successful return from this function, preemption is disabled and
> +     the local interrupts are disabled. The caller must not sleep, and is
> +     advised to release the hwspinlock as soon as possible.
> +
> +  int hwspin_lock_irqsave(struct hwspinlock *hwlock, unsigned long *flags);
> +   - lock a previously assigned hwspinlock. If the hwspinlock is already
> +     taken, the function will busy loop waiting for it to be released.
> +     Note: if a faulty remote core never releases this lock, this function
> +     will deadlock.
> +     This function will fail only if hwlock is invalid. Otherwise, it will
> +     always succeed (or deadlock; see above) and it will never sleep.
> +     Upon a successful return from this function, preemption is disabled,
> +     the local interrupts are disabled, and their previous state is saved
> +     in the given flags placeholder. The caller must not sleep, and is
> +     advised to release the hwspinlock as soon as possible.
> +
> +  int hwspin_lock_timeout(struct hwspinlock *hwlock, unsigned long timeout);
> +   - lock a previously-assigned hwspinlock with a timeout limit (specified in
> +     jiffies). If the hwspinlock is already taken, the function will busy
> loop
> +     waiting for it to be released, but give up when the timeout meets
> jiffies.
> +     If timeout is 0, the function will never give up (therefore if a faulty
> +     remote core never releases the hwspinlock, it will deadlock).
If timeout is 0, shouldn't it rather behave as a trylock? If timeout is
MAX_SCHEDULE_TIMEOUT, then it should behave as a wait-forever.

> +     Upon a successful return from this function, preemption is disabled so
> +     the caller must not sleep, and is advised to release the hwspinlock as
> +     soon as possible, in order to minimize remote cores polling on the
> +     hardware interconnect.
> +     Returns 0 when successful and an appropriate error code otherwise (most
> +     notably -ETIMEDOUT if the hwspinlock is still busy after timeout meets
> +     jiffies). The function will never sleep.
> +
> +  int hwspin_lock_timeout_irq(struct hwspinlock *hwlock, unsigned long
> timeout);
> +   - lock a previously-assigned hwspinlock with a timeout limit (specified in
> +     jiffies). If the hwspinlock is already taken, the function will busy
> loop
> +     waiting for it to be released, but give up when the timeout meets
> jiffies.
> +     If timeout is 0, the function will never give up (therefore if a faulty
> +     remote core never releases the hwspinlock, it will deadlock).
Same comment as above for 0 timeout.

> +     Upon a successful return from this function, preemption and the local
> +     interrupts are disabled, so the caller must not sleep, and is advised to
> +     release the hwspinlock as soon as possible.
> +     Returns 0 when successful and an appropriate error code otherwise (most
> +     notably -ETIMEDOUT if the hwspinlock is still busy after timeout meets
> +     jiffies). The function will never sleep.
> +
> +  int hwspin_lock_timeout_irqsave(struct hwspinlock *hwlock, unsigned long
> to,
> +                                                     unsigned long *flags);
> +   - lock a previously-assigned hwspinlock with a timeout limit (specified in
> +     jiffies). If the hwspinlock is already taken, the function will busy
> loop
> +     waiting for it to be released, but give up when the timeout meets
> jiffies.
> +     If timeout is 0, the function will never give up (therefore if a faulty
> +     remote core never releases the hwspinlock, it will deadlock).
Same comment as above for 0 timeout.

> +     Upon a successful return from this function, preemption is disabled,
> +     local interrupts are disabled and their previous state is saved at the
> +     given flags placeholder. The caller must not sleep, and is advised to
> +     release the hwspinlock as soon as possible.
> +     Returns 0 when successful and an appropriate error code otherwise (most
> +     notably -ETIMEDOUT if the hwspinlock is still busy after timeout meets
> +     jiffies). The function will never sleep.
> +
> +  int hwspin_trylock(struct hwspinlock *hwlock);
> +   - attempt to lock a previously-assigned hwspinlock, but immediately fail
> if
> +     it is already taken.
> +     Upon a successful return from this function, preemption is disabled so
> +     caller must not sleep, and is advised to release the hwspinlock as soon
> as
> +     possible, in order to minimize remote cores polling on the hardware
> +     interconnect.
> +     Returns 0 on success and an appropriate error code otherwise (most
> +     notably -EBUSY if the hwspinlock was already taken).
> +     The function will never sleep.
Is this function needed at all if timeout 0 behaves similar to trylock?

> +
> +  int hwspin_trylock_irq(struct hwspinlock *hwlock);
> +   - attempt to lock a previously-assigned hwspinlock, but immediately fail
> if
> +     it is already taken.
> +     Upon a successful return from this function, preemption and the local
> +     interrupts are disabled so caller must not sleep, and is advised to
> +     release the hwspinlock as soon as possible.
> +     Returns 0 on success and an appropriate error code otherwise (most
> +     notably -EBUSY if the hwspinlock was already taken).
> +     The function will never sleep.
Same comment as above for trylock.

> +
> +  int hwspin_trylock_irqsave(struct hwspinlock *hwlock, unsigned long
> *flags);
> +   - attempt to lock a previously-assigned hwspinlock, but immediately fail
> if
> +     it is already taken.
> +     Upon a successful return from this function, preemption is disabled,
> +     the local interrupts are disabled and their previous state is saved
> +     at the given flags placeholder. The caller must not sleep, and is
> advised
> +     to release the hwspinlock as soon as possible.
> +     Returns 0 on success and an appropriate error code otherwise (most
> +     notably -EBUSY if the hwspinlock was already taken).
> +     The function will never sleep.
Same comment as above for trylock.

<snip>

> +
> +4. API for implementors
> +
> +  int hwspinlock_register(struct hwspinlock *hwlock);
> +   - to be called from the underlying platform-specific implementation, in
> +     order to register a new hwspinlock instance. Can be called from an
> atomic
> +     context (this function will not sleep) but not from within interrupt
> +     context. Returns 0 on success, or appropriate error code on failure.
> +
> +  struct hwspinlock *hwspinlock_unregister(unsigned int id);
> +   - to be called from the underlying vendor-specific implementation, in
> order
> +     to unregister an existing (and unused) hwspinlock instance.
> +     Can be called from an atomic context (will not sleep) but not from
> +     within interrupt context.
> +     Returns the address of hwspinlock on success, or NULL on error (e.g.
> +     if the hwspinlock is sill in use).
Does this need to be called for all hwspinlocks? For example, if there are
64 hwspinlocks on a device, do these APIs need to be called 64 times? Is there
any other way to directly register all 64 hwspinlocks in a single shot?

<snip>

> +int __hwspin_lock_timeout(struct hwspinlock *hwlock, unsigned long to,
> +                                     int mode, unsigned long *flags)
> +{
> +     int ret;
> +
> +     for (;;) {
> +             /* Try to take the hwspinlock */
> +             ret = __hwspin_trylock(hwlock, mode, flags);
> +             if (ret != -EBUSY)
> +                     break;
> +
> +             /*
> +              * The lock is already taken, let's check if the user wants
> +              * us to try again
> +              */
> +             if (to && time_is_before_eq_jiffies(to))
> +                     return -ETIMEDOUT;
> +
> +             /*
> +              * Allow platform-specific relax handlers to prevent
> +              * hogging the interconnect (no sleeping, though)
> +              */
> +             if (hwlock->ops->relax)
> +                     hwlock->ops->relax(hwlock);
There should be a way to have an escape mechanism for the case where a deadlock
has occurred due to remote side taking the spinlock and crashing.
Is it possible to have a max loop or time check here and then exit with error
if that max is reached, because there was an expected condition? Hanging the
kernel because of a remote crash causes problems in implementing slave error
handling.

> +     }
> +
> +     return ret;
> +}
> +EXPORT_SYMBOL_GPL(__hwspin_lock_timeout);

<snip>

