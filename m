Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0JRHu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 03:50:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37682 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab0JRHu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 03:50:26 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 0/3] Add OMAP hardware spinlock misc driver
Date: Mon, 18 Oct 2010 09:44:32 +0200
Message-Id: <1287387875-14168-1-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP4 introduces a Spinlock hardware module, which provides hardware
assistance for synchronization and mutual exclusion between heterogeneous
processors and those not operating under a single, shared operating system
(e.g. OMAP4 has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP).

The intention of this hardware module is to allow remote processors,
that have no alternative mechanism to accomplish synchronization and mutual
exclusion operations, to share resources (such as memory and/or any other
hardware resource).

This patchset adds a new misc driver for this OMAP hwspinlock module.

Currently there are two users for this driver:

1. Inter-Processor Communications: on OMAP4, cpu-intensive multimedia
tasks are offloaded by the host to the remote M3 and/or C64x+ slave
processors.

To achieve fast message-based communications, a minimal kernel support
is needed to deliver messages arriving from a remote processor to the
appropriate user process.

This communication is based on simple data structures that are shared between
the remote processors, and access to it is synchronized using the hwspinlock
module (to allow the remote processor to directly place new messages in this
shared data structure).

This OMAP IPC system, called Syslink, is being actively developed by TI and
will be gradually submitted upstream.

2. OMAP I2C driver: On some OMAP4 boards, the I2C bus is shared between
the A9 and the M3, and the hwspinlock is used to synchronize access to it.


Patches are against linux-omap-2.6 master, which is 2.6.36-rc8 plus
2.6.37 omap material (needed for the omap specific patches in this set).

Tested on OMAP4 blaze.

Contributions
=============

Previous versions of this driver circulated in linux-omap several times,
and received substantial attention and contribution from many developers
(see [1][2][3][4][5][6]):

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

Changes since the last linux-omap iteration:

1. Disable interrupts and preemption when the lock is taken.
   This is required in order to minimize the period of time in which
   the other core might be spinning on this lock, trying to take it.
   Otherwise the other core will be polling the omap interconnect for
   too long, which would prevent other transactions from being executed.
   spin_trylock_irqsave is used to achieve this, with a dedicated spinlock
   (per hwspinlock). This also makes the hwspinlock primitive SMP-safe (but
   you shouldn't use this primitive to achieve synchronizations between
   different contexts on the same local processor, of course).

2. Add memory barriers
   The hwspinlock is used to achieve mutual exclusion when accessing some
   shared memory data. To guarantee that the memory operations, performed
   inside the critical section, are not reordered by the processor outside
   that critical section, we must use explicit memory barriers.

3. Provide three different locking API: trylock, lock_timeout, and lock,
   and implement them on top of each other (in that order). For the timeout
   API, use a jiffies-based parameter, instead of number of attempts.

4. Relax the OMAP interconnect between two subsequent lock() attempts,
   as recommended by the hw spec.

5. Move driver to drivers/misc, do some general cleanups and documentation

6. Use runtime PM get/put API to couple the number of locks that have being
   requested with the runtime PM's usage_count of the underlying device

Benoit Cousson (1):
  OMAP4: hwmod data: Add hwspinlock

Simon Que (2):
  drivers: misc: add omap_hwspinlock driver
  omap: add hwspinlock device

 Documentation/misc-devices/omap_hwspinlock.txt |  199 +++++++++
 arch/arm/mach-omap2/Makefile                   |    1 +
 arch/arm/mach-omap2/hwspinlock.c               |   67 +++
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c     |   63 +++
 drivers/misc/Kconfig                           |   10 +
 drivers/misc/Makefile                          |    1 +
 drivers/misc/omap_hwspinlock.c                 |  555 ++++++++++++++++++++++++
 include/linux/omap_hwspinlock.h                |  108 +++++
 8 files changed, 1004 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/misc-devices/omap_hwspinlock.txt
 create mode 100644 arch/arm/mach-omap2/hwspinlock.c
 create mode 100644 drivers/misc/omap_hwspinlock.c
 create mode 100644 include/linux/omap_hwspinlock.h

