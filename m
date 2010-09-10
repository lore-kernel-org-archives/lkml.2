Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0IJQKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 12:10:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943Ab0IJQKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 12:10:16 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/17] Name the irq flag handling functions sanely
To: linux-arch@vger.kernel.org
Cc: torvalds@osdl.org, linux-kernel@vger.kernel.org
Date: Fri, 10 Sep 2010 17:10:02 +0100
Message-ID: <20100910161002.20226.27995.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Note that this patch alters all arches.  Most are now ACK'd.  PowerPC and
 Xtensa are being tested; Blackfin and Score need ACK'ing but have been
 checked; IA-64 got looked at briefly and I've heard nothing more; I've heard
 nothing from the SH and CRIS maintainers]

A patch ("Fix IRQ flag handling naming") in the middle of the series makes the
naming of the general irq flag functions sane.  That is followed by a bunch of
patches for individual arches that aren't included yet in the main patch, but
will need rolling in before final submission.


Currently, under one configuration, linux/irqflags.h maps:

	local_irq_enable() -> raw_local_irq_enable()
	local_irq_disable() -> raw_local_irq_disable()
	local_irq_save() -> raw_local_irq_save()
	...

and under the other configuration, it maps:

	raw_local_irq_enable() -> local_irq_enable()
	raw_local_irq_disable() -> local_irq_disable()
	raw_local_irq_save() -> local_irq_save()
	...

This is quite confusing.  There should be one set of names expected of the
arch, and this should be wrapped to give another set of names that are expected
by users of this facility.

The main patch changes the asm/irqflags.h headers to provide:

	flags = arch_local_save_flags()
	flags = arch_local_irq_save()
	arch_local_irq_restore(flags)
	arch_local_irq_disable()
	arch_local_irq_enable()
	arch_irqs_disabled_flags(flags)
	arch_irqs_disabled()
	arch_safe_halt()

Then linux/irqflags.h wraps these to provide:

	raw_local_save_flags(flags)
	raw_local_irq_save(flags)
	raw_local_irq_restore(flags)
	raw_local_irq_disable()
	raw_local_irq_enable()
	raw_irqs_disabled_flags(flags)
	raw_irqs_disabled()
	raw_safe_halt()

with type checking on the flags 'arguments', and then wraps those to provide:

	local_save_flags(flags)
	local_irq_save(flags)
	local_irq_restore(flags)
	local_irq_disable()
	local_irq_enable()
	irqs_disabled_flags(flags)
	irqs_disabled()
	safe_halt()

with tracing included if enabled.

The arch functions can now all be inline functions rather than some of them
having to be macros.


=====================
FURTHER CONSIDERATION
=====================

With this patch, a chunk of asm/system.h has been deported.  That leaves a few
bits:

	- Barriers
	- cmpxchg()/xchg() implementations
	- switch_to()
	- arch_align_stack()
	- Various random arch bits

Is it worth deprecating this file and deporting the rest to various specific
header files?

	Barriers => asm/barrier.h
	cmpxchg()/xchg() => asm/atomic.h
	switch_to() => asm/process.h (+ bits from asm/processor.h)
	arch_align_stack() => asm/process.h


===========
ARCH FIXUPS
===========

To make this work, some of the arches need fixing up to some extent or other
beyond the irqflags stuff:

 (1) Blackfin.

     A number of circular dependencies and other problems needed sorting out in
     the Blackfin arch.  The first few patches deal with this.  With this, most
     of the Blackfin defconfigs compile, and none of the breakage is obviously
     to do with the irqflags patches.

     This also requires a name collision between the DES crypto module and the
     Blackfin arch code to be fixed.

 (2) SH.

     Some consts were missing from the sys_execve() declaration.

 (3) SMC1x driver and MIPS.

     A bunch of missing <linux/irq.h> inclusions were fixed.

     One patch if a prerequisite fixup borrowed from the Linux-MIPS tree.


David
---

David Howells (16):
      Fix Score irqflags
      Fix XTENSA irqflags
      Fix SH irqflags.
      Fix powerpc irqflags
      Fix CRIS irqflags
      Fix IA64 irqflags
      Fix IRQ flag handling naming
      MIPS: Add missing #inclusions of <linux/irq.h>
      smc91x: Add missing #inclusion of <linux/irq.h>
      Drop a couple of unnecessary asm/system.h inclusions
      SH: Add missing consts to sys_execve() declaration
      Blackfin: Rename IRQ flags handling functions
      Blackfin: Add missing dep to asm/irqflags.h
      Blackfin: Rename DES PC2() symbol to avoid collision
      Blackfin: Split the BF532 BFIN_*_FIO_FLAG() functions to their own header
      Blackfin: Split PLL code from mach-specific cdef headers

FUJITA Tomonori (1):
      MIPS: TX49xx: rename ARCH_KMALLOC_MINALIGN to ARCH_DMA_MINALIGN


 arch/alpha/include/asm/irqflags.h                  |   65 +++++
 arch/alpha/include/asm/system.h                    |   28 --
 arch/arm/include/asm/irqflags.h                    |  145 ++++++-----
 arch/avr32/include/asm/irqflags.h                  |   29 +-
 arch/blackfin/include/asm/ipipe.h                  |    8 -
 arch/blackfin/include/asm/irqflags.h               |  273 ++++++++++----------
 arch/blackfin/include/asm/mmu_context.h            |    8 -
 arch/blackfin/include/asm/system.h                 |    4 
 arch/blackfin/kernel/bfin_gpio.c                   |  102 ++++---
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c            |    8 -
 arch/blackfin/kernel/ipipe.c                       |   38 +--
 arch/blackfin/kernel/process.c                     |    4 
 arch/blackfin/kernel/trace.c                       |    1 
 .../mach-bf518/include/mach/cdefBF51x_base.h       |   50 ----
 arch/blackfin/mach-bf518/include/mach/pll.h        |   63 +++++
 .../mach-bf527/include/mach/cdefBF52x_base.h       |   50 ----
 arch/blackfin/mach-bf527/include/mach/pll.h        |   63 +++++
 arch/blackfin/mach-bf533/boards/blackstamp.c       |    1 
 arch/blackfin/mach-bf533/boards/ip0x.c             |    1 
 arch/blackfin/mach-bf533/boards/stamp.c            |    1 
 arch/blackfin/mach-bf533/include/mach/cdefBF532.h  |   91 -------
 arch/blackfin/mach-bf533/include/mach/fio_flag.h   |   55 ++++
 arch/blackfin/mach-bf533/include/mach/pll.h        |   57 ++++
 arch/blackfin/mach-bf537/include/mach/cdefBF534.h  |   44 ---
 arch/blackfin/mach-bf537/include/mach/pll.h        |   57 ++++
 arch/blackfin/mach-bf538/include/mach/cdefBF538.h  |   50 ----
 arch/blackfin/mach-bf538/include/mach/pll.h        |   63 +++++
 .../mach-bf548/include/mach/cdefBF54x_base.h       |   56 ----
 arch/blackfin/mach-bf548/include/mach/pll.h        |   69 +++++
 arch/blackfin/mach-bf561/include/mach/cdefBF561.h  |   50 ----
 arch/blackfin/mach-bf561/include/mach/pll.h        |   63 +++++
 arch/blackfin/mach-common/cpufreq.c                |    4 
 arch/blackfin/mach-common/ints-priority.c          |   24 +-
 arch/blackfin/mach-common/pm.c                     |   10 -
 arch/cris/include/arch-v10/arch/irqflags.h         |   45 +++
 arch/cris/include/arch-v10/arch/system.h           |   16 -
 arch/cris/include/arch-v32/arch/irqflags.h         |   46 +++
 arch/cris/include/arch-v32/arch/system.h           |   22 --
 arch/cris/include/asm/irqflags.h                   |    1 
 arch/cris/include/asm/system.h                     |    1 
 arch/frv/include/asm/irqflags.h                    |  158 ++++++++++++
 arch/frv/include/asm/system.h                      |  136 ----------
 arch/h8300/include/asm/irqflags.h                  |   43 +++
 arch/h8300/include/asm/system.h                    |   24 --
 arch/ia64/include/asm/irqflags.h                   |   94 +++++++
 arch/ia64/include/asm/system.h                     |   76 ------
 arch/m32r/include/asm/irqflags.h                   |  104 ++++++++
 arch/m32r/include/asm/system.h                     |   66 -----
 arch/m68k/include/asm/entry_no.h                   |    2 
 arch/m68k/include/asm/irqflags.h                   |   76 ++++++
 arch/m68k/include/asm/system_mm.h                  |   25 --
 arch/m68k/include/asm/system_no.h                  |   57 ----
 arch/m68knommu/kernel/asm-offsets.c                |    2 
 arch/m68knommu/platform/coldfire/head.S            |    1 
 arch/microblaze/include/asm/irqflags.h             |  193 +++++++-------
 arch/mips/alchemy/devboards/bcsr.c                 |    1 
 arch/mips/ar7/irq.c                                |    1 
 arch/mips/bcm63xx/irq.c                            |    1 
 arch/mips/cavium-octeon/serial.c                   |    1 
 arch/mips/dec/setup.c                              |    1 
 arch/mips/include/asm/irqflags.h                   |   53 ++--
 arch/mips/include/asm/mach-loongson/loongson.h     |    1 
 arch/mips/include/asm/mach-tx49xx/kmalloc.h        |    2 
 arch/mips/jazz/irq.c                               |    1 
 arch/mips/kernel/cevt-bcm1480.c                    |    1 
 arch/mips/kernel/cevt-ds1287.c                     |    1 
 arch/mips/kernel/cevt-gt641xx.c                    |    1 
 arch/mips/kernel/cevt-r4k.c                        |    1 
 arch/mips/kernel/cevt-sb1250.c                     |    1 
 arch/mips/kernel/cevt-smtc.c                       |    1 
 arch/mips/kernel/cevt-txx9.c                       |    1 
 arch/mips/kernel/i8253.c                           |    1 
 arch/mips/kernel/i8259.c                           |    1 
 arch/mips/kernel/irq-gic.c                         |    2 
 arch/mips/kernel/irq-rm7000.c                      |    1 
 arch/mips/kernel/irq-rm9000.c                      |    1 
 arch/mips/kernel/irq_cpu.c                         |    1 
 arch/mips/kernel/irq_txx9.c                        |    1 
 arch/mips/kernel/smtc.c                            |    4 
 arch/mips/kernel/traps.c                           |    2 
 arch/mips/mti-malta/malta-platform.c               |    1 
 arch/mips/pci/ops-tx3927.c                         |    1 
 arch/mips/pci/ops-tx4927.c                         |    1 
 arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c         |    1 
 arch/mips/powertv/asic/irq_asic.c                  |    1 
 arch/mips/rb532/serial.c                           |    1 
 arch/mips/sni/a20r.c                               |    1 
 arch/mips/sni/pcimt.c                              |    1 
 arch/mips/sni/pcit.c                               |    1 
 arch/mips/sni/rm200.c                              |    1 
 arch/mips/sni/time.c                               |    1 
 arch/mips/txx9/generic/irq_tx4927.c                |    1 
 arch/mips/txx9/generic/irq_tx4938.c                |    1 
 arch/mips/txx9/generic/irq_tx4939.c                |    1 
 arch/mips/txx9/generic/setup.c                     |    1 
 arch/mips/txx9/jmr3927/irq.c                       |    1 
 arch/mips/txx9/rbtx4927/irq.c                      |    1 
 arch/mips/txx9/rbtx4938/irq.c                      |    1 
 arch/mips/txx9/rbtx4939/irq.c                      |    1 
 arch/mips/vr41xx/common/irq.c                      |    1 
 arch/mips/vr41xx/common/siu.c                      |    1 
 arch/mn10300/include/asm/irqflags.h                |  119 +++++++++
 arch/mn10300/include/asm/system.h                  |  109 --------
 arch/mn10300/kernel/entry.S                        |    1 
 arch/parisc/include/asm/irqflags.h                 |   46 +++
 arch/parisc/include/asm/system.h                   |   19 -
 arch/powerpc/include/asm/hw_irq.h                  |  113 +++++---
 arch/powerpc/include/asm/irqflags.h                |    2 
 arch/powerpc/kernel/exceptions-64s.S               |    4 
 arch/powerpc/kernel/irq.c                          |    4 
 arch/s390/include/asm/irqflags.h                   |   51 ++--
 arch/s390/include/asm/system.h                     |    2 
 arch/s390/kernel/mem_detect.c                      |    4 
 arch/s390/mm/init.c                                |    2 
 arch/s390/mm/maccess.c                             |    4 
 arch/score/include/asm/irqflags.h                  |  187 +++++++-------
 arch/sh/include/asm/syscalls_32.h                  |    6 
 arch/sh/kernel/irq_32.c                            |    8 -
 arch/sparc/include/asm/irqflags_32.h               |   35 ++-
 arch/sparc/include/asm/irqflags_64.h               |   29 +-
 arch/sparc/kernel/irq_32.c                         |   13 -
 arch/sparc/prom/p1275.c                            |    2 
 arch/tile/include/asm/irqflags.h                   |   36 +--
 arch/x86/include/asm/irqflags.h                    |   32 +-
 arch/x86/include/asm/paravirt.h                    |   16 +
 arch/xtensa/include/asm/irqflags.h                 |   58 ++++
 arch/xtensa/include/asm/system.h                   |   33 --
 crypto/des_generic.c                               |  130 +++++-----
 drivers/net/bfin_mac.c                             |    1 
 drivers/net/smc91x.c                               |    1 
 drivers/s390/char/sclp.c                           |    2 
 drivers/vlynq/vlynq.c                              |    1 
 drivers/watchdog/octeon-wdt-main.c                 |    1 
 include/asm-generic/atomic.h                       |    5 
 include/asm-generic/cmpxchg-local.h                |    1 
 include/asm-generic/hardirq.h                      |    1 
 include/asm-generic/irqflags.h                     |   52 ++--
 include/linux/hardirq.h                            |    1 
 include/linux/irqflags.h                           |  107 +++++---
 include/linux/list.h                               |    1 
 include/linux/spinlock.h                           |    1 
 141 files changed, 2325 insertions(+), 1842 deletions(-)
 create mode 100644 arch/alpha/include/asm/irqflags.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf527/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf533/include/mach/fio_flag.h
 create mode 100644 arch/blackfin/mach-bf533/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf537/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf548/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf561/include/mach/pll.h
 create mode 100644 arch/cris/include/arch-v10/arch/irqflags.h
 create mode 100644 arch/cris/include/arch-v32/arch/irqflags.h
 create mode 100644 arch/cris/include/asm/irqflags.h
 create mode 100644 arch/frv/include/asm/irqflags.h
 create mode 100644 arch/h8300/include/asm/irqflags.h
 create mode 100644 arch/ia64/include/asm/irqflags.h
 create mode 100644 arch/m32r/include/asm/irqflags.h
 create mode 100644 arch/m68k/include/asm/irqflags.h
 create mode 100644 arch/mn10300/include/asm/irqflags.h
 create mode 100644 arch/parisc/include/asm/irqflags.h
 create mode 100644 arch/xtensa/include/asm/irqflags.h

