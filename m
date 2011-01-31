Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab1AaKeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 05:34:04 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44200 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab1AaKeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 05:34:01 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Paul Walmsley <paul@pwsan.com>,
        Hari Kanigeri <hari.kanigeri@gmail.com>,
        Simon Que <simonque@gmail.com>
Subject: [PATCH v4 0/4] Introduce hardware spinlock framework
Date: Mon, 31 Jan 2011 12:33:40 +0200
Message-Id: <1296470024-26854-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP4 introduces a Hardware Spinlock device, which provides hardware
assistance for synchronization and mutual exclusion between heterogeneous
processors and those not operating under a single, shared operating system
(e.g. OMAP4 has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP).

The intention of this hardware device is to allow remote processors,
that have no alternative mechanism to accomplish synchronization and mutual
exclusion operations, to share resources (such as memory and/or any other
hardware resource).

This patch set adds hwspinlock framework that makes it possible
for drivers to use those hwspinlock devices and stay platform-independent.

Currently there are two use cases for this hwspinlock interface:

1. Inter-processor communications: on OMAP4, cpu-intensive multimedia
tasks are offloaded by the host to the remote M3 and/or C64x+ slave
processors.

To achieve fast message-based communications, a minimal kernel support
is needed to deliver messages arriving from a remote processor to the
appropriate user process.

This communication is based on a simple data structure that is shared between
the remote processors, and access to it is synchronized using the hwspinlock
module (remote processor directly places new messages in this shared data
structure).

2. On some OMAP4 boards, the I2C bus is shared between the A9 and the M3,
and the hwspinlock is used to synchronize access to it.

While (2) can get away with an omap-specific hwspinlock implementation,
(1) is by no means omap-specific, and a common hwspinlock interface is
needed to keep it generic, in hopes that it will be useful for other
platforms as well.

Additional users, besides OMAP4:

* Davinci Netra (DM8168) has the same hwspinlock device, and will probably
use the same host implementation (this is untested since hardware is
not available yet, but the specs looks identical).

* Platforms (such as omap3530 and omapl1xx) that have no such hardware
support, but would still need to achieve multi-core synchronization (to
communicate with their DSP).

The only way to achieve mutual exclusion on those platforms is by
using a shared-memory synchronization algorithm such as Peterson's
Algorithm.

We would still need the same hwspinlock framework for that - the busy
looping, the timeout, the various locking schemes, the lock resource
allocation - are all still valid. The only difference would be the
actual lock implementation, therefore we will add another host
implementation for these platforms.

* The C6474, a multi-core DSP device, have Linux running on one
of its cores, and hardware support for synchronization (the C6474
has a richer hardware module that would need more than the hwspinlock
framework offer today - it also supports queuing, owner semantics and
interrupt notification to let a processor know when it acquires a
lock, so it wouldn't have to spin..).  Disclaimer: it will probably
take some time until c6x support is merged upstream, but this is
something that is being actively worked on. For additional information,
see http://focus.ti.com/docs/prod/folders/print/tms320c6474.html and
http://www.linux-c6x.org/wiki/index.php/Main_Page

v3->v4:
- Rebased to 2.6.38-rc2
- Added Tony's Acked-by
- Use hweight (akpm)

v2->v3:
- Remove the timeout-less _lock API variant (Tony)
- s/state->io_base/io_base/ (Ionut)
- Remove the "generic" wording (David)
- s/hwspinlock_/hwspin_lock_/ (Mugdha)
- Use MAX_SCHEDULE_TIMEOUT to indicate no timeout (Mugdha)
- Be more verbose on egregious API misuse (Olof)
- locking API misuse is BUG_ON material (Russell)

  Note: Russell also suggested compiling out NULL checks on ARM.
  I've posted an initial proposal for this (see
  https://lkml.org/lkml/2010/11/29/96), which I'm going to resubmit
  separately. If accepted, I'll adopt hwspinlocks to use it.

v1->v2:
- Convert to a generic interface (Tony)
- API should silently succeed if framework isn't built (Greg)
- Don't use ERR_PTR pattern (Grant)
- Use tristate, fix and extend commentary (Kevin)
- Provide API flexibility regarding irq handling (Arnd, Grant)

  Note: after reviewing OMAP's L4 access times, and comparing them with
  external memory latencies, I can say that there is no notable difference.
  Because of that, we can safely treat the hwspinlock like we do
  with regular spinlocks: preemption should be disabled, but whether
  to disable interrupts or not is up to the caller.

  So despite the TRM's recommendation to always disable local interrupts
  when taking an OMAP Hardware Spinlock, I have decided to allow callers
  not to do that (by providing the full extent of hwspin_lock(),
  hwspin_lock_irq() and hwspin_lock_irqsave() API).

  Just like regular spinlocks, it's up to the callers to decide whether
  interrupts should be disabled or not.

  Sleeping, btw, is still prohibited of course.

Contributions:

Previous versions of an omap-specific hwspinlock driver circulated in
linux-omap several times, and received substantial attention and contribution
from many developers (see [1][2][3][4][5][6]):

Simon Que did the initial implementation and pushed several iterations
Benoit Cousson provided extensive review, help, improvements and hwmod support
Hari Kanigeri helped out when Simon was away
Sanjeev Premi, Santosh Shilimkar and Nishanth Menon did lots of review

I'd like to thank Benoit Cousson, Steve Krueger, Hari Kanigeri,
Nourredine Hamoudi and Richard Woodruff for useful discussions about
the OMAP Spinlock requirements and use-cases.

Relevant linux-omap threads:

[1] http://thread.gmane.org/gmane.linux.ports.arm.omap/38755
[2] http://thread.gmane.org/gmane.linux.ports.arm.omap/38917
[3] http://thread.gmane.org/gmane.linux.ports.arm.omap/39187
[4] http://thread.gmane.org/gmane.linux.ports.arm.omap/39365
[5] http://thread.gmane.org/gmane.linux.ports.arm.omap/39815
[6] http://thread.gmane.org/gmane.linux.ports.arm.omap/40901

Benoit Cousson (1):
  OMAP4: hwmod data: Add hwspinlock

Ohad Ben-Cohen (1):
  drivers: hwspinlock: add framework

Simon Que (2):
  drivers: hwspinlock: add OMAP implementation
  omap: add hwspinlock device

 Documentation/hwspinlock.txt               |  299 +++++++++++++++
 arch/arm/mach-omap2/Makefile               |    1 +
 arch/arm/mach-omap2/hwspinlock.c           |   63 ++++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c |   63 ++++
 drivers/Kconfig                            |    2 +
 drivers/Makefile                           |    2 +
 drivers/hwspinlock/Kconfig                 |   22 ++
 drivers/hwspinlock/Makefile                |    6 +
 drivers/hwspinlock/hwspinlock.h            |   61 +++
 drivers/hwspinlock/hwspinlock_core.c       |  557 ++++++++++++++++++++++++++++
 drivers/hwspinlock/omap_hwspinlock.c       |  231 ++++++++++++
 include/linux/hwspinlock.h                 |  298 +++++++++++++++
 12 files changed, 1605 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/hwspinlock.txt
 create mode 100644 arch/arm/mach-omap2/hwspinlock.c
 create mode 100644 drivers/hwspinlock/Kconfig
 create mode 100644 drivers/hwspinlock/Makefile
 create mode 100644 drivers/hwspinlock/hwspinlock.h
 create mode 100644 drivers/hwspinlock/hwspinlock_core.c
 create mode 100644 drivers/hwspinlock/omap_hwspinlock.c
 create mode 100644 include/linux/hwspinlock.h

