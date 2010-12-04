Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0LDA3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 19:29:43 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:2116 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0LDA3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 19:29:42 -0500
Message-ID: <4CF98B6F.5050308@caviumnetworks.com>
Date: Fri, 03 Dec 2010 16:29:35 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 0/4] Introduce hardware spinlock framework
References: <1291420247-18171-1-git-send-email-ohad@wizery.com>
In-Reply-To: <1291420247-18171-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Dec 2010 00:30:45.0939 (UTC) FILETIME=[7DE7B030:01CB934A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 03:50 PM, Ohad Ben-Cohen wrote:
> OMAP4 introduces a Hardware Spinlock device, which provides hardware
> assistance for synchronization and mutual exclusion between heterogeneous
> processors and those not operating under a single, shared operating system
> (e.g. OMAP4 has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP).
>
> The intention of this hardware device is to allow remote processors,
> that have no alternative mechanism to accomplish synchronization and mutual
> exclusion operations, to share resources (such as memory and/or any other
> hardware resource).
>

Does anything other than OMAP4 have one of these things?  And are there 
any devices that are commonly encountered across more than one platform 
that might have these hardware spinlocks, thus making it advantageous to 
have a common framework?

If not why a general purpose framework for a very chip specific feature?

There are chips with hardware atomic memory, but the only time it makes 
sense to use it is in conjunction with specialize on-chip devices.  So 
the implementation details are kept in the drivers rather than creating 
a general purpose hwatomic (with its hwatomic_add() et al.) type.

David Daney

> This patchset adds hwspinlock framework that makes it possible
> for drivers to use those hwspinlock devices and stay platform-independent.
>
> Currently there are two users for this hwspinlock interface:
>
> 1. Inter-processor communications: on OMAP4, cpu-intensive multimedia
> tasks are offloaded by the host to the remote M3 and/or C64x+ slave
> processors.
>
> To achieve fast message-based communications, a minimal kernel support
> is needed to deliver messages arriving from a remote processor to the
> appropriate user process.
>
> This communication is based on a simple data structure that is shared between
> the remote processors, and access to it is synchronized using the hwspinlock
> module (remote processor directly places new messages in this shared data
> structure).
>
> 2. On some OMAP4 boards, the I2C bus is shared between the A9 and the M3,
> and the hwspinlock is used to synchronize access to it.
>
> While (2) can get away with an omap-specific hwspinlock implementation,
> (1) is by no means omap-specific, and a common hwspinlock interface is
> needed to keep it generic, in hopes that it will be useful for other
> platforms as well.
>
> Changes v2->v3:
> - Remove the timeout-less _lock API variant (Tony)
> - s/state->io_base/io_base/ (Ionut)
> - Remove the "generic" wording (David)
> - s/hwspinlock_/hwspin_lock_/ (Mugdha)
> - Use MAX_SCHEDULE_TIMEOUT to indicate no timeout (Mugdha)
> - Be more verbose on egregious API misuse (Olof)
> - locking API misuse is BUG_ON material (Russell)
>
>    Note: Russell also suggested compiling out NULL checks on ARM.
>    I've posted an initial proposal for this (see
>    https://lkml.org/lkml/2010/11/29/96), which I'm going to resubmit
>    separately. If accepted, I'll adopt hwspinlocks to use it.
>
> Patches are tested against linux-omap-2.6 master, which is 2.6.37-rc4 plus
> omap material. All, but the third (the hwmod omap patch), apply on top of
> mainline 2.6.37-rc4 as well
>
> Changes v1->v2:
> - Convert to a generic interface (Tony)
> - API should silently succeed if framework isn't built (Greg)
> - Don't use ERR_PTR pattern (Grant)
> - Use tristate, fix and extend commentary (Kevin)
> - Provide API flexibility regarding irq handling (Arnd, Grant)
>
>    Note: after reviewing OMAP's L4 access times, and comparing them with
>    external memory latencies, I can say that there is no notable difference.
>    Because of that, we can safely treat the hwspinlock like we do
>    with regular spinlocks: preemption should be disabled, but whether
>    to disable interrupts or not is up to the caller.
>
>    So despite the TRM's recommendation to always disable local interrupts
>    when taking an OMAP Hardware Spinlock, I have decided to allow callers
>    not to do that (by providing the full extent of hwspin_lock(),
>    hwspin_lock_irq() and hwspin_lock_irqsave() API).
>
>    Just like regular spinlocks, it's up to the callers to decide whether
>    interrupts should be disabled or not.
>
>    Sleeping, btw, is still prohibited of course.
>
> Contributions:
>
> Previous versions of an omap-specific hwspinlock driver circulated in
> linux-omap several times, and received substantial attention and contribution
> from many developers (see [1][2][3][4][5][6]):
>
> Simon Que did the initial implementation and pushed several iterations
> Benoit Cousson provided extensive review, help, improvements and hwmod support
> Hari Kanigeri helped out when Simon was away
> Sanjeev Premi, Santosh Shilimkar and Nishanth Menon did lots of review
>
> I'd like to thank Benoit Cousson, Steve Krueger, Hari Kanigeri,
> Nourredine Hamoudi and Richard Woodruff for useful discussions about
> the OMAP Spinlock requirements and use-cases.
>
> Relevant linux-omap threads:
>
> [1] http://thread.gmane.org/gmane.linux.ports.arm.omap/38755
> [2] http://thread.gmane.org/gmane.linux.ports.arm.omap/38917
> [3] http://thread.gmane.org/gmane.linux.ports.arm.omap/39187
> [4] http://thread.gmane.org/gmane.linux.ports.arm.omap/39365
> [5] http://thread.gmane.org/gmane.linux.ports.arm.omap/39815
> [6] http://thread.gmane.org/gmane.linux.ports.arm.omap/40901
>
