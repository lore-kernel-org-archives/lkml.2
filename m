Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab0H0B7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 21:59:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753489Ab0H0B7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 21:59:09 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 00/22] Name the irq flag handling functions sanely
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 27 Aug 2010 02:59:05 +0100
Message-ID: <20100827015905.27277.39167.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Note that this patch alters all arches except AVR32, Cris, Microblaze, Score,
 Tile and Xtensa as I don't have usable compilers for those.  Not all the other
 arches compiled successfully, but as far as I can tell, those problems are not
 due to my patches].

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


===========
ARCH FIXUPS
===========

To make this work, some of the arches need fixing up to some extent or other
beyond the irqflags stuff:

 (1) Alpha.

     A missing comma prevented compilation of one of the upstream files.

 (2) Blackfin.

     A number of circular dependencies and other problems needed sorting out in
     the Blackfin arch.  The first few patches deal with this.  With this, most
     of the Blackfin defconfigs compile, and none of the breakage is obviously
     to do with the irqflags patches.

     This also requires a name collision between the DES crypto module and the
     Blackfin arch code to be fixed.

 (3) H8300.

     A number of general problems needed sorting.

 (4) SH.

     Some consts were missing from the sys_execve() declaration.

David
---

David Howells (22):
      Fix Sparc irqflags
      Fix SH irqflags
      Fix powerpc irqflags
      Fix PA-RISC irqflags
      Fix M68K irqflags
      Fix m32r irqflags
      Fix IA64 irqflags
      Fix H8300 arch
      Fix Alpha irqflags
      MIPS: Fix IRQ flags handling
      Fix IRQ flag handling naming
      SH: Add missing consts to sys_execve() declaration
      h8300: Fix missing consts in kernel_execve()
      h8300: Fix die()
      h8300: IRQ flags should be stored in an unsigned long
      Blackfin: Rename IRQ flags handling functions
      Blackfin: Add missing dep to asm/irqflags.h
      Blackfin: Rename DES PC2() symbol to avoid collision
      Blackfin: Split the BF532 BFIN_*_FIO_FLAG() functions to their own header
      Blackfin: Don't redefine blackfin serial port symbols
      Blackfin: Split PLL code from mach-specific cdef headers
      Alpha: Fix a missing comma in sys_osf_statfs()


 arch/alpha/include/asm/irqflags.h                  |   65 +++++
 arch/alpha/include/asm/system.h                    |   28 --
 arch/alpha/kernel/osf_sys.c                        |    2 
 arch/arm/include/asm/irqflags.h                    |  143 ++++++----
 arch/blackfin/include/asm/bfin_sport.h             |   16 +
 arch/blackfin/include/asm/ipipe.h                  |    8 -
 arch/blackfin/include/asm/irqflags.h               |  273 ++++++++++----------
 arch/blackfin/include/asm/mmu_context.h            |    8 -
 arch/blackfin/include/asm/system.h                 |    4 
 arch/blackfin/kernel/bfin_gpio.c                   |  102 ++++---
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c            |    8 -
 arch/blackfin/kernel/ipipe.c                       |   38 +--
 arch/blackfin/kernel/process.c                     |    4 
 .../mach-bf518/include/mach/cdefBF51x_base.h       |   50 ----
 arch/blackfin/mach-bf518/include/mach/pll.h        |   63 +++++
 .../mach-bf527/include/mach/cdefBF52x_base.h       |   50 ----
 arch/blackfin/mach-bf527/include/mach/pll.h        |   63 +++++
 arch/blackfin/mach-bf533/boards/blackstamp.c       |    1 
 arch/blackfin/mach-bf533/boards/ip0x.c             |    1 
 arch/blackfin/mach-bf533/boards/stamp.c            |    1 
 arch/blackfin/mach-bf533/include/mach/cdefBF532.h  |   91 -------
 arch/blackfin/mach-bf533/include/mach/defBF532.h   |   27 --
 arch/blackfin/mach-bf533/include/mach/fio_flag.h   |   55 ++++
 arch/blackfin/mach-bf533/include/mach/pll.h        |   57 ++++
 arch/blackfin/mach-bf537/include/mach/cdefBF534.h  |   44 ---
 arch/blackfin/mach-bf537/include/mach/pll.h        |   57 ++++
 arch/blackfin/mach-bf538/include/mach/cdefBF538.h  |   50 ----
 arch/blackfin/mach-bf538/include/mach/pll.h        |   63 +++++
 .../mach-bf548/include/mach/cdefBF54x_base.h       |   56 ----
 .../mach-bf548/include/mach/defBF54x_base.h        |   59 ----
 arch/blackfin/mach-bf548/include/mach/pll.h        |   69 +++++
 arch/blackfin/mach-bf561/include/mach/cdefBF561.h  |   50 ----
 arch/blackfin/mach-bf561/include/mach/defBF561.h   |   58 ----
 arch/blackfin/mach-bf561/include/mach/pll.h        |   63 +++++
 arch/blackfin/mach-common/cpufreq.c                |    4 
 arch/blackfin/mach-common/ints-priority.c          |   24 +-
 arch/blackfin/mach-common/pm.c                     |   10 -
 arch/frv/include/asm/irqflags.h                    |  158 ++++++++++++
 arch/frv/include/asm/system.h                      |  136 ----------
 arch/h8300/include/asm/atomic.h                    |   15 +
 arch/h8300/include/asm/irqflags.h                  |   43 +++
 arch/h8300/include/asm/system.h                    |   28 --
 arch/h8300/kernel/sys_h8300.c                      |    4 
 arch/h8300/kernel/traps.c                          |    2 
 arch/ia64/include/asm/irqflags.h                   |   94 +++++++
 arch/ia64/include/asm/system.h                     |   76 ------
 arch/m32r/include/asm/irqflags.h                   |  105 ++++++++
 arch/m32r/include/asm/system.h                     |   66 -----
 arch/m68k/include/asm/irqflags.h                   |    5 
 arch/m68k/include/asm/irqflags_mm.h                |   57 ++++
 arch/m68k/include/asm/irqflags_no.h                |   86 ++++++
 arch/m68k/include/asm/system_mm.h                  |   25 --
 arch/m68k/include/asm/system_no.h                  |   49 ----
 arch/mips/include/asm/irqflags.h                   |   53 ++--
 arch/mn10300/include/asm/irqflags.h                |  119 +++++++++
 arch/mn10300/include/asm/system.h                  |  109 --------
 arch/mn10300/kernel/entry.S                        |    1 
 arch/parisc/include/asm/irqflags.h                 |   46 +++
 arch/parisc/include/asm/system.h                   |   19 -
 arch/powerpc/include/asm/hw_irq.h                  |  115 +++++---
 arch/powerpc/include/asm/irqflags.h                |    2 
 arch/powerpc/kernel/exceptions-64s.S               |    4 
 arch/powerpc/kernel/irq.c                          |    4 
 arch/sh/include/asm/syscalls_32.h                  |    6 
 arch/sh/kernel/irq_32.c                            |    8 -
 arch/sparc/include/asm/irqflags_32.h               |   35 ++-
 arch/sparc/include/asm/irqflags_64.h               |   29 +-
 arch/sparc/kernel/irq_32.c                         |   12 -
 arch/x86/include/asm/irqflags.h                    |   32 +-
 arch/x86/include/asm/paravirt.h                    |   16 +
 crypto/des_generic.c                               |  130 +++++-----
 drivers/net/bfin_mac.c                             |    1 
 include/asm-generic/atomic.h                       |    3 
 include/asm-generic/irqflags.h                     |   52 ++--
 include/linux/irqflags.h                           |  107 +++++---
 include/linux/spinlock.h                           |    1 
 76 files changed, 1958 insertions(+), 1660 deletions(-)
 create mode 100644 arch/alpha/include/asm/irqflags.h
 create mode 100644 arch/blackfin/mach-bf518/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf527/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf533/include/mach/fio_flag.h
 create mode 100644 arch/blackfin/mach-bf533/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf537/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf538/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf548/include/mach/pll.h
 create mode 100644 arch/blackfin/mach-bf561/include/mach/pll.h
 create mode 100644 arch/frv/include/asm/irqflags.h
 create mode 100644 arch/h8300/include/asm/irqflags.h
 create mode 100644 arch/ia64/include/asm/irqflags.h
 create mode 100644 arch/m32r/include/asm/irqflags.h
 create mode 100644 arch/m68k/include/asm/irqflags.h
 create mode 100644 arch/m68k/include/asm/irqflags_mm.h
 create mode 100644 arch/m68k/include/asm/irqflags_no.h
 create mode 100644 arch/mn10300/include/asm/irqflags.h
 create mode 100644 arch/parisc/include/asm/irqflags.h

