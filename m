Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0EWWIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 18:08:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54970 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab0EWWIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 18:08:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
Date: Mon, 24 May 2010 00:08:15 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc6-00202-gac5d593; KDE/4.4.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <4BF757FF.6060100@tilera.com>
In-Reply-To: <4BF757FF.6060100@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005240008.16497.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19bI9Iw2/AV7v/I2C3z0zu8kLbpbDJ98wGdgXZ
 u0Pm0fmQ+Nd/vit4opZNhY/lj/PCYNNbz5c057vxjukFt4bgq0
 Wah0tZ4YpNdY8aEhAGnow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 May 2010 06:05:19 Chris Metcalf wrote:
> As an experiment, I've created a "git format-patch" output file for all
> the remaining Tilera-specific changes; Alan took the
> lowmem_page_address() change into -mm, so hopefully that will make it
> into 2.6.35 as well.  I'm reluctant to post all the arch/tile contents
> to LKML as a single 3 MB monster email, but you can just cut and paste
> the following command to pull it into git:
> 
> wget http://www.tilera.com/scm/linux-2.6.34-arch-tile.patch | git am

Thanks for this. I took an initial look at the code and it looks pretty
good as far as I got though not mergeable for 2.6.35 IMHO. There are a number
of areas where code should be generic that is not, and there is stuff
in there that I think you should submit separately.

> In practice I could probably email it without causing grief to anyone's
> mailer, but in the interests of saving disk and network bandwidth I'll
> try this way.  There are no changes in this patch that affect any other
> architecture.

It would help if you can set up an actual git tree to pull from, but
it also works the way you did it. I looked mostly at the header files,
leaving out the device drivers and oprofile intentionally and I have
not yet found time to look at your arch/tile/{lib,kernel,mm}

>  MAINTAINERS                                  |    6 +
>  arch/tile/Kbuild                             |    4 +
>  arch/tile/Kconfig                            |  533 +
>  arch/tile/Kconfig.debug                      |   49 +
>  arch/tile/Makefile                           |   68 +
>  arch/tile/configs/tile_defconfig             | 1297 +++
>  arch/tile/drivers/Makefile                   |   23 +
>  arch/tile/drivers/bme_mem.c                  |  408 +
>  arch/tile/drivers/bme_mem.h                  |   61 +
>  arch/tile/drivers/eeprom.c                   |  366 +
>  arch/tile/drivers/eeprom.h                   |   43 +
>  arch/tile/drivers/hpi.c                      |  447 +
>  arch/tile/drivers/hpi.h                      |   59 +
>  arch/tile/drivers/i2c.c                      |  330 +
>  arch/tile/drivers/ide-gpio.c                 | 1505 +++
>  arch/tile/drivers/iorpc.c                    |  483 +
>  arch/tile/drivers/iorpc.h                    |   66 +
>  arch/tile/drivers/rshim.c                    |  245 +
>  arch/tile/drivers/rshim.h                    |   54 +
>  arch/tile/drivers/rtc.c                      |  152 +
>  arch/tile/drivers/softuart.c                 |  306 +
>  arch/tile/drivers/srom.c                     |  409 +
>  arch/tile/drivers/srom.h                     |   66 +
>  arch/tile/drivers/tilepci_barmem.c           |  320 +
>  arch/tile/drivers/tilepci_direct_hv.c        |  517 +
>  arch/tile/drivers/tilepci_endp.c             | 1623 +++
>  arch/tile/drivers/tilepci_endp.h             |   32 +
>  arch/tile/drivers/tilepci_shared_code.c      | 1600 +++
>  arch/tile/drivers/tilepci_shared_code.h      | 1650 +++
>  arch/tile/drivers/watchdog.c                 |  449 +
>  arch/tile/drivers/xgbe.h                     |  179 +
>  arch/tile/drivers/xgbe_main.c                | 1015 ++
>  arch/tile/drivers/xgbe_net.c                 | 3377 +++++++
>  arch/tile/drivers/xgbe_net_fastio.S          |   32 +

Most of these device drivers should be reviewed separately
using the appropriate mailing lists. In general we prefer
the drivers to live in drivers/{net,ata,serial,...} than
in arch/.../drivers.

The notable exception is pci, which should go to arch/tile/pci
but still be reviewed in the pci mailing list.

> arch/tile/oprofile/Makefile                  |    9 +
> arch/tile/oprofile/backtrace.c               |   73 +
> arch/tile/oprofile/op_common.c               |  352 +
> arch/tile/oprofile/op_impl.h                 |   37 +

These should probably go through the oprofile list.

> +config TILE
> +	def_bool y
> +	select HAVE_OPROFILE
> +	select HAVE_IDE
> +	select GENERIC_FIND_FIRST_BIT
> +	select GENERIC_FIND_NEXT_BIT
> +	select RESOURCES_64BIT
> +	select USE_GENERIC_SMP_HELPERS
> +
> +# FIXME: investigate whether we need/want these options.
> +#	select HAVE_GENERIC_DMA_COHERENT
> +#	select HAVE_DMA_ATTRS
> +#	select HAVE_IOREMAP_PROT
> +#       select HAVE_OPTPROBES
> +#       select HAVE_REGS_AND_STACK_ACCESS_API
> +#       select HAVE_HW_BREAKPOINT
> +#       select PERF_EVENTS
> +#       select HAVE_USER_RETURN_NOTIFIER

You will want to implement PERF_EVENTS, which replaces OPROFILE
(you can have both though). You should not need HAVE_IDE, which
is deprecated by libata, but you will need to reimplement the
driver. HAVE_REGS_AND_STACK_ACCESS_API is a good one, you
should implmenent that. HAVE_HW_BREAKPOINT is good, but
requires hardware support.

It is unlikely that you need DMA attributes (unless your PCI
devices want to use nonstandard ordering rules). Similarly,
you hopefully won't need HAVE_GENERIC_DMA_COHERENT.

> +config HOMECACHE
> +	bool "Support for dynamic home cache management"
> +	depends on TILERA_MDE
> +	---help---
> +	  Home cache management allows Linux to dynamically adjust
> +	  which core's (or cores') cache is the "home" for every page
> +	  of memory.  This allows performance improvements on TILEPro
> +	  (for example, by enabling the default "allbutstack" mode
> +	  where stack pages are always homed on the core running the
> +	  task).  TILE64 has less performant cache-coherent support,
> +	  so it is not recommended to disable homecaching for TILE64.
> +
> +config DATAPLANE
> +	bool "Support for Zero-Overhead Linux mode"
> +	depends on SMP
> +	depends on NO_HZ
> +	depends on TILERA_MDE
> +	---help---
> +	  Zero-Overhead Linux mode, also called "dataplane" mode,
> +	  allows Linux cpus running only a single user task to run
> +	  without any kernel overhead on that cpu.  The normal
> +	  scheduler tick is disabled, kernel threads such as the
> +	  softlockup thread are not run, kernel TLB flush IPIs are
> +	  deferred, vmstat updates are not performed, etc.

These sound like very interesting features that may also be
useful for other architectures. I would recommend splitting them
out into separate patches, by removing the support from the
base architecture patch, and submitting the two patches for these
features for discussion on the linux-kernel and linux-arch
mailing lists.

> +choice
> +	depends on EXPERIMENTAL
> +	prompt "Memory split" if EMBEDDED
> +	default VMSPLIT_3G

I would recommend leaving out this option on your architecture
because of the craziness. If I understand you correctly, the
CPUs are all 64 bit capable, so there is little point in
micro-optimizing the highmem case.

> +config XGBE_MAIN
> +	tristate "Tilera GBE/XGBE character device support"
> +	default y
> +	depends on HUGETLBFS
> +	---help---
> +	  This is the low-level driver for access to xgbe/gbe/pcie.

This should go to drivers/net/Kconfig.

> +config TILEPCI_ENDP
> +	tristate "Tilera PCIE Endpoint Channel Driver"
> +	default y
> +	depends on !TILEGX
> +	---help---
> +	  This device is required on Tilera PCI cards; the driver
> +	  allows Tilera Linux on the chip to communicate with the
> +	  Intel Linux running on the host.

This driver is likely one of the hardest things to review. I'd
recommend leaving it out of the arch patch for now and submitting
it for a separate review together with the host side driver.

> +config TILE_IDE_GPIO
> +	bool "Tilera IDE driver for GPIO"
> +	depends on IDE
> +	default y
> +	---help---
> +	  This device provides an IDE interface using the GPIO pins.

replace this with a driver in drivers/ata.

> +config TILE_SOFTUART
> +	bool "Tilera Soft UART"
> +	default n
> +	depends on !TILEGX
> +	---help---
> +	  This device provides access to the FlexIO UART functionality.
> +	  It requires a dedicated hypervisor "softuart" driver tile.

I haven't looked at the driver, but it's very likely that you
want to replace it with either a backend for drivers/char/hvc_console.c
or drivers/serial/serial_core.c, modeled after the other drivers
using those interfaces. serial_core is for things that look like
an actual UART, while hvc_console is for abstracted interfaces
that have a simple read/write interface like a hypervisor.

[skipping device drivers]

> diff --git a/arch/tile/feedback/cachepack.c b/arch/tile/feedback/cachepack.c
> new file mode 100644
> index 0000000..7b54348
> --- /dev/null
> +++ b/arch/tile/feedback/cachepack.c
> +#include "file.h"
> +#include <arch/chip.h>
> +#ifdef __KERNEL__
> +#define THREADS_SUPPORTED
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/module.h>
> +#include <linux/spinlock.h>
> +#include <linux/mm.h>
> +#else
> +#include "threads.h"
> +#include "mmap.h"

This file looks like mixed kernel/user code, which is something
we don't normally do. It also does not follow kernel coding style.
I'd suggest splitting the implementation and having the kernel
version only include the necessary code without all the #ifdef
and in normal style.

You could also leave this out for now.

> diff --git a/arch/tile/include/arch/abi.h b/arch/tile/include/arch/abi.h
> new file mode 100644
> index 0000000..18ad6a0
> --- /dev/null
> +++ b/arch/tile/include/arch/abi.h
> @@ -0,0 +1,93 @@
> +// Copyright 2010 Tilera Corporation. All Rights Reserved.
> +//
> +//   This program is free software; you can redistribute it and/or
> +//   modify it under the terms of the GNU General Public License
> +//   as published by the Free Software Foundation, version 2.
> +//
> +//   This program is distributed in the hope that it will be useful, but
> +//   WITHOUT ANY WARRANTY; without even the implied warranty of
> +//   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> +//   NON INFRINGEMENT.  See the GNU General Public License for
> +//   more details.
> +
> +//! @file
> +//!
> +//! ABI-related register definitions helpful when writing assembly code.
> +//!

This file uses nonstandard formatting of the comments. Is it
a generated file, or something that needs to be shared with
other projects?

If it is not shared with anything that strictly mandates the
style, I'd recommend moving to regular kernel style.

> +//! Get the current cycle count.
> +//!
> +static __inline unsigned long long
> +get_cycle_count(void)
> +{
> +  unsigned int high = __insn_mfspr(SPR_CYCLE_HIGH);
> +  unsigned int low = __insn_mfspr(SPR_CYCLE_LOW);
> +  unsigned int high2 = __insn_mfspr(SPR_CYCLE_HIGH);
> +  if (__builtin_expect(high == high2, 1))
> +  {
> +#ifdef __TILECC__
> +#pragma frequency_hint FREQUENT
> +#endif
> +    return (((unsigned long long)high) << 32) | low;
> +  }
> +  do {
> +    low = __insn_mfspr(SPR_CYCLE_LOW);
> +    high = high2;
> +    high2 = __insn_mfspr(SPR_CYCLE_HIGH);
> +  } while (high != high2);
> +  return (((unsigned long long)high) << 32) | low;
> +}

I would not use these functions directly in driver code.
You could move all of cycle.h to timex.h and rename
get_cycle_count to get_cycles. The other functions
are not used anywhere, so they don't need to be
part of the header.

You should also implement read_current_timer using
this so you can avoid the expensive delay loop
calibration at boot time.

> +//! Delay for a brief period.
> +//!
> +//! As implemented, this function is a six-cycle slow SPR read.
> +//!
> +static __USUALLY_INLINE void
> +cycle_relax(void)
> +{
> +  __insn_mfspr(SPR_PASS);
> +}

Another abstraction you can kill by moving this directly
to cpu_relax and calling that from your relax().

> +/* Use __ALWAYS_INLINE to force inlining, even at "-O0". */
> +#ifndef __ALWAYS_INLINE
> +#define __ALWAYS_INLINE __inline __attribute__((always_inline))
> +#endif
> +
> +/* Use __USUALLY_INLINE to force inlining even at "-Os", but not at "-O0". */
> +#ifndef __USUALLY_INLINE
> +#ifdef __OPTIMIZE__
> +#define __USUALLY_INLINE __ALWAYS_INLINE
> +#else
> +#define __USUALLY_INLINE
> +#endif
> +#endif

Please get rid of these abstraction, inlining is already hard
enough with the macros we have in the common code. We have
an __always_inline macro that is defined the same way as yours
and if you can make a good case for your __USUALLY_INLINE,
we can add that as __usually_inline to linux/compiler.h

> diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
> new file mode 100644
> index 0000000..c191db6
> --- /dev/null
> +++ b/arch/tile/include/asm/Kbuild
> @@ -0,0 +1,17 @@
> +include include/asm-generic/Kbuild.asm
> +
> +header-y += hardwall.h
> +header-y += memprof.h
> +header-y += ucontext.h
> +header-y += user.h
> +
> +unifdef-y += bme.h
> +unifdef-y += page.h
> +unifdef-y += tilepci.h

note that header-y and unifdef-y are now synonyms,
you can just make them all header-y.

Do you really need to export user.h and page.h?

> +# FIXME: The kernel probably shouldn't provide these to user-space,
> +# but it's convenient for now to do so.
> +unifdef-y += opcode-tile.h
> +unifdef-y += opcode_constants.h
> +unifdef-y += opcode-tile_32.h
> +unifdef-y += opcode_constants_32.h

The comment is right, they should not be exported.

> diff --git a/arch/tile/include/asm/a.out.h b/arch/tile/include/asm/a.out.h
> new file mode 100644
> index 0000000..36ee719
> --- /dev/null
> +++ b/arch/tile/include/asm/a.out.h

Should not be needed, just remove this file.

> --- /dev/null
> +++ b/arch/tile/include/asm/addrspace.h

This file is not referenced anywhere. I'd suggest removing it
until you send code that actually uses it.

> diff --git a/arch/tile/include/asm/asm.h b/arch/tile/include/asm/asm.h
> new file mode 100644
> index 0000000..f064bc4
> --- /dev/null
> +++ b/arch/tile/include/asm/asm.h

Can be removed. syscall_table.S is the only user (of just one
of its macros), so just change that file to not rely on
the header.

> diff --git a/arch/tile/include/asm/atomic.h b/arch/tile/include/asm/atomic.h
> new file mode 100644
> index 0000000..a4f4714
> --- /dev/null
> +++ b/arch/tile/include/asm/atomic.h
> +
> +#ifndef _ASM_TILE_ATOMIC_H
> +#define _ASM_TILE_ATOMIC_H
> +
> +#ifndef __ASSEMBLY__
> +
> +#include <linux/compiler.h>
> +#include <asm/system.h>
> +
> +#define ATOMIC_INIT(i)	{ (i) }

This file looks mostly generic, and is to a large extent the
same as the existing asm-generic/atomic.h. Could you add an
#ifdef atomic_add_return to the definition of that in
the generic file and use that, overriding the functions
that need to be architecture specific on SMP systems?

> diff --git a/arch/tile/include/asm/atomic_32.h b/arch/tile/include/asm/atomic_32.h
> new file mode 100644
> index 0000000..e4f8b4f
> --- /dev/null
> +++ b/arch/tile/include/asm/atomic_32.h
> +#ifndef _ASM_TILE_ATOMIC_32_H
> +#define _ASM_TILE_ATOMIC_32_H
> +
> +#include <arch/chip.h>

It's unclear why part of atomic.h is split out into atomic_32.h,
especially when the file actually contains the definitions for
atomic64_t ;-).

> diff --git a/arch/tile/include/asm/backtrace.h b/arch/tile/include/asm/backtrace.h
> new file mode 100644
> index 0000000..3e65364
> --- /dev/null
> +++ b/arch/tile/include/asm/backtrace.h
> +#ifndef _TILE_BACKTRACE_H
> +#define _TILE_BACKTRACE_H
> +
> +#ifndef _LANGUAGE_ASSEMBLY
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif /* __cplusplus */
> +
> +#ifdef __KERNEL__
> +#include <linux/types.h>
> +#else
> +#include <stdint.h>
> +#include <stdbool.h>
> +#endif

The file backtrace.h is not exported to user space, so you don't
need any of these guards in the kernel. It should also be changed
to follow regular coding style.

> diff --git a/arch/tile/include/asm/bitops.h b/arch/tile/include/asm/bitops.h
> new file mode 100644
> index 0000000..dc3228e
> --- /dev/null
> +++ b/arch/tile/include/asm/bitops.h

This file looks completely generic, but improved over the
asm-generic/bitops/* files by using compiler builtins where
possible.
It would be nice if you could change the generic code to
use the same builtins when possible.

> +#include <linux/compiler.h>
> +#include <asm/atomic.h>
> +#include <asm/system.h>
> +
> +/* Tile-specific routines to support <asm/bitops.h>. */
> +unsigned long _atomic_or(volatile unsigned long *p, unsigned long mask);
> +unsigned long _atomic_andn(volatile unsigned long *p, unsigned long mask);
> +unsigned long _atomic_xor(volatile unsigned long *p, unsigned long mask);
> +
> +/**
> + * set_bit - Atomically set a bit in memory
> + * @nr: the bit to set
> + * @addr: the address to start counting from
> + *
> + * This function is atomic and may not be reordered.
> + * See __set_bit() if you do not require the atomic guarantees.
> + * Note that @nr may be almost arbitrarily large; this function is not
> + * restricted to acting on a single-word quantity.
> + */
> +static inline void set_bit(unsigned nr, volatile unsigned long *addr)
> +{
> +	_atomic_or(addr + BIT_WORD(nr), BIT_MASK(nr));
> +}

Why not just declare set_bit (and other functions from here)
to be extern?

> +++ b/arch/tile/include/asm/bitsperlong.h
> +
> +# define __BITS_PER_LONG 32

This seems wrong, unless you support _only_ 32 bit user space.

> +#ifndef _ASM_TILE_BME_H
> +#define _ASM_TILE_BME_H
> +
> +#ifndef __KERNEL__
> +#include <stdint.h>
> +#else
> +#include <linux/types.h>
> +#endif

Don't do this, just use the __u32 and similar types in
data structures. The stdint.h types are problematic
in exported kernel headers.

> +/**
> + * Descriptor for user memory attributes.
> + */
> +struct bme_user_mem_desc {
> +	void *va;		/**< Address of memory. */
> +	uint32_t len;		/**< Length of memory in bytes. */
> +};

Pointers in ioctl data structures are bad because they
require conversion between 32 bit applications and 64 bit
kernels. Better use a __u64 member or try to avoid the pointers
entirely.

> +/**
> + * Descriptor for physical memory attributes.
> + */
> +struct bme_phys_mem_desc {
> +	uint64_t pa;		/**< Physical address of memory. */
> +	uint32_t len;		/**< Length of memory in bytes. */
> +	uint64_t pte;		/**< Caching attributes. */
> +};

This data structure has implicit padding. I suspect that this
is ok on your arch, but in general you should make the padding
explicit or avoid it by aligning the members. Just make len
a __u64 here.

The problem is that code that is portable to x86 behaves differently
in 32 and 64 bit mode: x86-32 does not add padding here.

> +/** Get the number of pages this range of memory covers. */
> +#define BME_IOC_GET_NUM_PAGES _IO(BME_IOC_TYPE, 0x0)
> +
> +/**
> + * Lock the memory so it can be accessed by BME tiles.  User must provide
> + * space for the number of pages included in this range.  That number may
> + * be obtained by BME_IOC_GET_NUM_PAGES, above.
> + */
> +#define BME_IOC_LOCK_MEMORY _IO(BME_IOC_TYPE, 0x1)

These should actually be _IOWR, not _IO, because you are
passing data structures.

> --- /dev/null
> +++ b/arch/tile/include/asm/bugs.h
> @@ -0,0 +1,22 @@
> +
> +#ifndef _ASM_TILE_BUGS_H
> +#define _ASM_TILE_BUGS_H
> +
> +static inline void check_bugs(void)
> +{
> +}
> +
> +#endif /* _ASM_TILE_BUGS_H */

While this file is trivial, please just use the asm-generic
version anyway. I have a patch (and have had it for
ages) that lets you leave out any files that only contain
a redirect to asm-generic.

> diff --git a/arch/tile/include/asm/checksum.h b/arch/tile/include/asm/checksum.h
> new file mode 100644
> index 0000000..079ab67
> --- /dev/null
> +++ b/arch/tile/include/asm/checksum.h

I believe you can use the asm-generic version here.

> diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
> new file mode 100644
> index 0000000..5703968
> --- /dev/null
> +++ b/arch/tile/include/asm/compat.h

We don't have an architecture using the asm-generic headers
with CONFIG_COMPAT support yet, so tile would be the first
one. I think you should just move this file to
include/asm-generic/compat.h and use that, so future architectures
don't need to define their own.

> +/*
> + * Idle the core for 8 * iterations cycles.
> + * Also make this a compiler barrier, as it's sometimes used in
> + * lieue of cpu_relax(), which has barrier semantics.
> + */
> +static inline void
> +relax(int iterations)
> +{
> +	for (/*above*/; iterations > 0; iterations--)
> +		cycle_relax();
> +	barrier();
> +}

I'd rather not make this part of the interface. Just move this
definition to your spinlock_32.c file and use an open-coded
version in delay.c

> +static inline void
> +dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
> +			enum dma_data_direction direction)
> +{
> +	panic("dma_sync_single_for_cpu");
> +}
> +
> +static inline void
> +dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle,
> +			   size_t size, enum dma_data_direction direction)
> +{
> +	panic("dma_sync_single_for_device");
> +}

These definitions do not look helful. If you cannot figure out what
to do here, it may be better to just declare functions without
a definition so you get a link error for drivers that need them
instead of a runtime panic.

Usually you need to do the same thing you do while mapping when
you sync to the device (e.g. a cache flush) and potentially
a cache invalidate when you sync to the CPU.

> diff --git a/arch/tile/include/asm/dma.h b/arch/tile/include/asm/dma.h
> new file mode 100644
> index 0000000..002f12a
> --- /dev/null
> +++ b/arch/tile/include/asm/dma.h

The asm-generic version should be enough unless you plan to
support legacy ISA extension cards.

> +#ifndef _ASM_TILE_HARDWALL_H
> +#define _ASM_TILE_HARDWALL_H
> +
> +#include <linux/ioctl.h>
> +
> +struct hardwall_rectangle {
> +	int ulhc_x;
> +	int ulhc_y;
> +	int width;
> +	int height;
> +};
> +
> +#define HARDWALL_FILE "/proc/tile/hardwall"

This does not look right, /proc files should not be used with ioctl,
although we have a few existing cases already. You could probably
change this to a misc chardev or a debugfs file.


> +static inline void *memcpy_fromio(void *dst, void *src, int len)
> +{
> +	int x;
> +	if ((unsigned long)src & 0x3)
> +		panic("memcpy_fromio from non dword aligned address");
> +	for (x = 0; x < len; x += 4)
> +		*(u32 *)(dst + x) = readl(src + x);
> +	return dst;
> +}
> +
> +static inline void *memcpy_toio(void *dst, void *src, int len)
> +{
> +	int x;
> +	if ((unsigned long)dst & 0x3)
> +		panic("memcpy_toio to non dword aligned address");
> +	for (x = 0; x < len; x += 4)
> +		writel(*(u32 *)(src + x), dst + x);
> +	return dst;
> +}
> +

panic looks a bit harsh here. Maybe BUG_ON?


> diff --git a/arch/tile/include/asm/kmap_types.h b/arch/tile/include/asm/kmap_types.h
> new file mode 100644
> index 0000000..1480106
> --- /dev/null
> +++ b/arch/tile/include/asm/kmap_types.h

Any reason for having your own copy of this instead of the
generic file?

> diff --git a/arch/tile/include/asm/kvm.h b/arch/tile/include/asm/kvm.h
> new file mode 100644
> index 0000000..7ed6877
> --- /dev/null
> +++ b/arch/tile/include/asm/kvm.h

If you don't support kvm, just remove this file.

> diff --git a/arch/tile/include/asm/mman.h b/arch/tile/include/asm/mman.h
> new file mode 100644
> index 0000000..e448d45
> --- /dev/null
> +++ b/arch/tile/include/asm/mman.h

This looks like you can use the asm-generic/mman.h file.

> +/*
> + * Specify the "home cache" for the page explicitly.  The home cache is
> + * the cache of one particular "home" cpu, which is used as a coherence
> + * point for normal cached operations.  Normally the kernel chooses for
> + * you, but you can use the MAP_CACHE_HOME_xxx flags to override.
> + *
> + * User code should not use any symbols with a leading "_" as they are
> + * implementation specific and may change from release to release
> + * without warning.
> + *
> + * See the Tilera mmap(2) man page for more details (e.g. "tile-man mmap").
> + */
> +
> +/* Implementation details; do not use directly. */
> +#define _MAP_CACHE_INCOHERENT   0x40000
> +#define _MAP_CACHE_HOME         0x80000
> +#define _MAP_CACHE_HOME_SHIFT   20
> +#define _MAP_CACHE_HOME_MASK    0x3ff
> +#define _MAP_CACHE_MKHOME(n) \
> +  (_MAP_CACHE_HOME | (((n) & _MAP_CACHE_HOME_MASK) << _MAP_CACHE_HOME_SHIFT))
> +

Since the file is exported to user space, the map_cache stuff probably
should not be here, but get moved to a different header that
is private to the kernel.

> diff --git a/arch/tile/include/asm/posix_types.h b/arch/tile/include/asm/posix_types.h
> new file mode 100644
> index 0000000..ab71c9c
> --- /dev/null
> +++ b/arch/tile/include/asm/posix_types.h

Anything wrong with the asm-generic version of this file?
You really should not need to define your own version,
because this is relevant to the user ABI.

> diff --git a/arch/tile/include/asm/sembuf.h b/arch/tile/include/asm/sembuf.h
> new file mode 100644
> index 0000000..d4dc7cd
> --- /dev/null
> +++ b/arch/tile/include/asm/sembuf.h

Same here, this is part of the ABI, so please use the generic version.

> diff --git a/arch/tile/include/asm/shmparam.h b/arch/tile/include/asm/shmparam.h
> new file mode 100644
> index 0000000..bc99ff6
> --- /dev/null
> +++ b/arch/tile/include/asm/shmparam.h

and here.

> --- /dev/null
> +++ b/arch/tile/include/asm/sigcontext.h
> +
> +#ifndef _ASM_TILE_SIGCONTEXT_H
> +#define _ASM_TILE_SIGCONTEXT_H
> +
> +/* NOTE: we can't include <linux/ptrace.h> due to #include dependencies. */
> +#include <asm/ptrace.h>
> +
> +/* Must track <sys/ucontext.h> */
> +
> +struct sigcontext {
> +	struct pt_regs regs;
> +};

The comments both do not match the code apparently.

> diff --git a/arch/tile/include/asm/spinlock_32.h b/arch/tile/include/asm/spinlock_32.h
> new file mode 100644
> index 0000000..c609041
> --- /dev/null
> +++ b/arch/tile/include/asm/spinlock_32.h

This file could just be renamed to spinlock.h, afaict.

> diff --git a/arch/tile/include/asm/stat.h b/arch/tile/include/asm/stat.h
> new file mode 100644
> index 0000000..4d86b4e
> --- /dev/null
> +++ b/arch/tile/include/asm/stat.h

part of the ABI, please don't define your own.

> --- /dev/null
> +++ b/arch/tile/include/asm/timex.h
> @@ -0,0 +1,51 @@
> +/*
> + * Copyright 2010 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +
> +#ifndef _ASM_TILE_TIMEX_H
> +#define _ASM_TILE_TIMEX_H
> +
> +#include <arch/cycle.h>
> +
> +/* Use this random value, just like most archs.  Mysterious. */
> +#define CLOCK_TICK_RATE	1193180 /* Underlying HZ */

long story. It should however actually be something related to the
your frequency, not the time base of the i8253 chip that I hope
you are not using.

> diff --git a/arch/tile/include/asm/unistd.h b/arch/tile/include/asm/unistd.h
> new file mode 100644
> index 0000000..616dc7d
> --- /dev/null
> +++ b/arch/tile/include/asm/unistd.h

Your unistd.h file contains syscall numbers for many calls that
you should not need in a new architecture. Please move to the
asm-generic/unistd.h file instead. There may be a few things you
need to do in libc to get there, but this version is no good.
If you have problems with asm-generic/unistd.h (or any of the other
asm-generic files), feel free to ask me for help.

	Arnd
