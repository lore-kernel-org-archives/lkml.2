Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab0JSRBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 13:01:32 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47618 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab0JSRBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 13:01:30 -0400
MIME-Version: 1.0
In-Reply-To: <1287387875-14168-2-git-send-email-ohad@wizery.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com> <1287387875-14168-2-git-send-email-ohad@wizery.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 19 Oct 2010 11:01:07 -0600
X-Google-Sender-Auth: iVfqlDMnDEjLE9Rtagrfx6PaX00
Message-ID: <AANLkTimDdPUjo+65vBL0PTQ3b=5NpeVT28XrdkYqx3Ex@mail.gmail.com>
Subject: Re: [PATCH 1/3] drivers: misc: add omap_hwspinlock driver
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>, Hari Kanigeri <h-kanigeri2@ti.com>,
        Suman Anna <s-anna@ti.com>, Simon Que <sque@ti.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 1:44 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> From: Simon Que <sque@ti.com>
>
> Add driver for OMAP's Hardware Spinlock module.
>
> The OMAP Hardware Spinlock module, initially introduced in OMAP4,
> provides hardware assistance for synchronization between the
> multiple processors in the device (Cortex-A9, Cortex-M3 and
> C64x+ DSP).

Hi Ohad, A couple of comments below.

>
> Signed-off-by: Simon Que <sque@ti.com>
> Signed-off-by: Hari Kanigeri <h-kanigeri2@ti.com>
> Signed-off-by: Krishnamoorthy, Balaji T <balajitk@ti.com>
> [ohad@wizery.com: disable interrupts/preemption to prevent hw abuse]
> [ohad@wizery.com: add memory barriers to prevent memory reordering issues]
> [ohad@wizery.com: relax omap interconnect between subsequent lock attempts]
> [ohad@wizery.com: timeout param to use jiffies instead of number of attempts]
> [ohad@wizery.com: remove code duplication in lock, trylock, lock_timeout]
> [ohad@wizery.com: runtime pm usage count to reflect num of requested locks]
> [ohad@wizery.com: move to drivers/misc, general cleanups, document]
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> ---
>  Documentation/misc-devices/omap_hwspinlock.txt |  199 +++++++++
>  drivers/misc/Kconfig                           |   10 +
>  drivers/misc/Makefile                          |    1 +
>  drivers/misc/omap_hwspinlock.c                 |  555 ++++++++++++++++++++++++
>  include/linux/omap_hwspinlock.h                |  108 +++++
>  5 files changed, 873 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/misc-devices/omap_hwspinlock.txt
>  create mode 100644 drivers/misc/omap_hwspinlock.c
>  create mode 100644 include/linux/omap_hwspinlock.h
>
> diff --git a/Documentation/misc-devices/omap_hwspinlock.txt b/Documentation/misc-devices/omap_hwspinlock.txt
> new file mode 100644
> index 0000000..b093347
> --- /dev/null
> +++ b/Documentation/misc-devices/omap_hwspinlock.txt
> @@ -0,0 +1,199 @@
> +OMAP Hardware Spinlocks
> +
> +1. Introduction
> +
> +Hardware spinlock modules provide hardware assistance for synchronization
> +and mutual exclusion between heterogeneous processors and those not operating
> +under a single, shared operating system.
> +
> +For example, OMAP4 has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP,
> +each of which is running a different Operating System (the master, A9,
> +is usually running Linux and the slave processors, the M3 and the DSP,
> +are running some flavor of RTOS).
> +
> +A hwspinlock driver allows kernel code to access data structures (or hardware
> +resources) that are shared with any of the existing remote processors, with
> +which there is no alternative mechanism to accomplish synchronization and
> +mutual exclusion operations.
> +
> +This is necessary, for example, for Inter-processor communications:
> +on OMAP4, cpu-intensive multimedia tasks are offloaded by the host to the
> +remote M3 and/or C64x+ slave processors (by an IPC subsystem called Syslink).
> +
> +To achieve fast message-based communications, a minimal kernel support
> +is needed to deliver messages arriving from a remote processor to the
> +appropriate user process.
> +
> +This communication is based on simple data structures that are shared between
> +the remote processors, and access to them is synchronized using the hwspinlock
> +module (remote processor directly places new messages in this shared data
> +structure).
> +
> +2. User API
> +
> +  struct omap_hwspinlock *omap_hwspinlock_request(void);
> +   - dynamically assign an hwspinlock and return its address, or
> +     ERR_PTR(-EBUSY) if an unused hwspinlock isn't available. Users of this
> +     API will usually want to communicate the lock's id to the remote core
> +     before it can be used to achieve synchronization (to get the id of the
> +     lock, use omap_hwspinlock_get_id()).
> +     Can be called from an atomic context (this function will not sleep) but
> +     not from within interrupt context.

I strongly recommend reconsidering the ERR_PTR() pattern in new driver
code.  It is impossible to tell from looking at the prototype of a
function if it returns an ERR_PTR() value, or a NULL on failure.  I
pretty much guarantee that new users of this code will miss the
subtlety and introduce new bugs by assuming that the return value can
be tested with "if (!hwlock)".

ERR_PTR() is only appropriate when the caller actually cares about the
failure code and has different behaviour depending on the result.  For
example, filesystem code that needs to return to userspace a specific
error code.  Very seldom does driver code like users of this API
actually care.  Using it is just asking for bugs with no benefit.

> +  struct omap_hwspinlock *omap_hwspinlock_request_specific(unsigned int id);
> +   - assign a specific hwspinlock id and return its address, or
> +     ERR_PTR(-EBUSY) if that hwspinlock is already in use. Usually board code
> +     will be calling this function in order to reserve specific hwspinlock
> +     ids for predefined purposes.
> +     Can be called from an atomic context (this function will not sleep) but
> +     not from within interrupt context.
> +
> +  int omap_hwspinlock_free(struct omap_hwspinlock *hwlock);
> +   - free a previously-assigned hwspinlock; returns 0 on success, or an
> +     appropriate error code on failure (e.g. -EINVAL if the hwspinlock
> +     was not assigned).
> +     Can be called from an atomic context (this function will not sleep) but
> +     not from within interrupt context.
> +
> +  int omap_hwspin_lock(struct omap_hwspinlock *hwlock, unsigned long *flags);
> +   - lock a previously assigned hwspinlock. If the hwspinlock is already
> +     taken, the function will busy loop waiting for it to be released.
> +     Note: if a faulty remote core never releases this lock, this function
> +     will deadlock.
> +     This function will fail if hwlock is invalid, but otherwise it will
> +     always succeed (or deadlock; see above) and will never sleep. It is safe
> +     to call it from any context.
> +     Upon a successful return from this function, interrupts and preemption
> +     are disabled so the caller must not sleep, and is advised to release the
> +     hwspinlock as soon as possible, in order to minimize remote cores polling
> +     on the hardware interconnect.
> +     The flags parameter is a pointer to where the interrupts state of the
> +     caller will be saved at.
> +
> +  int omap_hwspin_lock_timeout(struct omap_hwspinlock *hwlock,
> +                               unsigned long timeout, unsigned long *flags);
> +   - lock a previously-assigned hwspinlock with a timeout limit (specified in
> +     jiffies). If the hwspinlock is already taken, the function will busy loop
> +     waiting for it to be released, but give up when the timeout meets jiffies.
> +     If timeout is 0, the function will never give up (therefore if a faulty
> +     remote core never releases the hwspinlock, it will deadlock).
> +     Upon a successful return from this function, interrupts and preemption
> +     are disabled so the caller must not sleep, and is advised to release the
> +     hwspinlock as soon as possible, in order to minimize remote cores polling

Disabling irqs *might* be a concern as a source of RT latency.  It
might be better to make the caller responsible for managing local spin
locks and irq disable/enable.

OTOH, I also see that a spin lock is still needed internally to
protect the hwspinlock data structure.

g.
