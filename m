Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1BRAIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:08:45 -0500
Received: from dalsmrelay2.nai.com ([205.227.136.216]:49066 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab1BRAIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:08:40 -0500
Message-ID: <4D5DB83D.80205@snapgear.com>
Date: Fri, 18 Feb 2011 10:07:25 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
CC: Steven King <sfking00@yahoo.com>,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Greg Ungerer <gregungerer@westnet.com.au>
Subject: merge of m68knommu and m68k arch branches?
Content-Type: multipart/mixed;
	boundary="------------090904080404090107040203"
X-OriginalArrivalTime: 18 Feb 2011 00:08:22.0691 (UTC) FILETIME=[F4A94F30:01CBCEFF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------090904080404090107040203
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit


Hi All,

I would like to put up for discussion a merge of the m68knommu and
m68k arch branches.

Attached is a script and patch that does a kind of brute force
simplistic merge of the directories and files. (Thanks to Stephen King
<sfking@fdwdc.com> for the initial version of this script, and to
Sam Ravnborg for the m68k includes merge script this was based on).
Nothing outside of the arch/m68k and arch/m68knommu directories is
touched, and in the end there is no more arch/m68knommu. To apply you
simply run the script from the top of a current kernel git tree (I used
2.6.38-rc5 for testing) and then apply the patch.

This results in a tree that builds and runs on m68knommu targets that
I tested, and at least builds with seemingly no change on m68k targets
(I have not actually tested anything on a real m68k target). Configuring
kernels results in the .config files containing the same option sets
(though a few options appear in a different place/order).

Inside of the new arch/m68k is a little messy in the kernel and mm
directories. There is plenty of scope for cleanup and merge on the
files in here - but I want to leave that for follow up patches after
this initial directory merge. As a data point, when we merged the
m68k and m68knommu include files we had something like 70 or 80
duplicate but separate files, after some cleanups that is now down to
10. Ongoing cleanup will merge some of these remaining ones as well.

Thoughts?

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com

--------------090904080404090107040203
Content-Type: application/x-sh; name="merge.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="merge.sh"

#!/bin/bash

mergefile() {
	BASE=${1%.?}
	EXT=${1#${BASE}}
	git mv ${TARGET}/$1 ${TARGET}/${BASE}_mm${EXT}
	git mv ${SOURCE}/$1 ${TARGET}/${BASE}_no${EXT}
	cat <<-EOF > ${TARGET}/$1
	#ifdef CONFIG_MMU
	#include "${BASE}_mm${EXT}"
	#else
	#include "${BASE}_no${EXT}"
	#endif
	EOF
	git add ${TARGET}/$1
}

mergedir() {
	TARGET=arch/m68k/$1
	SOURCE=arch/m68knommu/$1
	files=${1}_MERGE_FILES
	MERGE_FILES=${!files}

	echo "merging files in $1"
	for F in $MERGE_FILES ; do
		mergefile $F
	done

	files=${1}_NOMERGE_FILES
	NOMERGE_FILES=${!files}

	echo "moving files in $1"
	for F in $NOMERGE_FILES ; do
		git mv ${SOURCE}/$F ${TARGET}/$F
	done

	files=${1}_REMOVE_FILES
	REMOVE_FILES=${!files}

	echo "removing common files in $1"
	for F in $REMOVE_FILES ; do
		git rm ${SOURCE}/$F
	done

	if [ -e ${SOURCE}/Makefile ]; then
		git mv ${TARGET}/Makefile ${TARGET}/Makefile_mm
		git mv ${SOURCE}/Makefile ${TARGET}/Makefile_no
		cat <<-EOF > ${TARGET}/Makefile
		ifdef CONFIG_MMU
		include ${TARGET}/Makefile_mm
		else
		include ${TARGET}/Makefile_no
		endif
		EOF
		git add ${TARGET}/Makefile
	fi
}

configs_MERGE_FILES=""
configs_NOMERGE_FILES="m5208evb_defconfig \
			m5272c3_defconfig \
			m5307c3_defconfig \
			m5249evb_defconfig \
			m5275evb_defconfig \
			m5407c3_defconfig"
configs_REMOVE_FILES=""
kernel_MERGE_FILES="asm-offsets.c \
			dma.c entry.S \
			m68k_ksyms.c \
			module.c \
			process.c \
			ptrace.c \
			setup.c \
			signal.c \
			sys_m68k.c \
			time.c \
			traps.c \
			vmlinux.lds.S"
kernel_NOMERGE_FILES="init_task.c \
			irq.c \
			syscalltable.S"
kernel_REMOVE_FILES=""
lib_MERGE_FILES="checksum.c \
			muldi3.c"
lib_NOMERGE_FILES="delay.c \
			divsi3.S \
			memcpy.c \
			memmove.c \
			memset.c \
			modsi3.S \
			mulsi3.S \
			udivsi3.S \
			umodsi3.S"
lib_REMOVE_FILES="ashldi3.c \
			ashrdi3.c \
			lshrdi3.c"
mm_MERGE_FILES="init.c kmap.c"
mm_NOMERGE_FILES=""
mm_REMOVE_FILES=""

DIRS="configs kernel lib mm"

echo "STARTing merge"
for dir in $DIRS ; do
	echo "merging $dir..."
	mergedir $dir
done
echo "moving platform"
git mv arch/m68knommu/platform arch/m68k/
git rm arch/m68knommu/defconfig

echo "merging master Makefile"
git mv arch/m68k/Makefile arch/m68k/Makefile_mm
git mv arch/m68knommu/Makefile arch/m68k/Makefile_no
cat <<-EOF > arch/m68k/Makefile
ifdef CONFIG_MMU
include arch/m68k/Makefile_mm
else
include arch/m68k/Makefile_no
endif
EOF
git add arch/m68k/Makefile

echo "removing remaining m68knommu dirs"
git rm -r arch/m68knommu
rm -r arch/m68knommu
exit 0

--------------090904080404090107040203
Content-Type: text/x-diff; name="m68k-kconfig-merge.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="m68k-kconfig-merge.patch"

diff -Naurp linux-2.6.x.half-merge/arch/m68k/Kconfig linux-2.6.x.full-merge/arch/m68k/Kconfig
--- linux-2.6.x.half-merge/arch/m68k/Kconfig	2010-11-03 10:27:34.831994252 +1000
+++ linux-2.6.x.full-merge/arch/m68k/Kconfig	2011-02-17 15:25:44.565986486 +1000
@@ -1,13 +1,10 @@
 config M68K
 	bool
 	default y
-	select HAVE_AOUT
 	select HAVE_IDE
-	select GENERIC_ATOMIC64
-
-config MMU
-	bool
-	default y
+	select HAVE_AOUT if MMU
+	select GENERIC_ATOMIC64 if MMU
+	select HAVE_GENERIC_HARDIRQS if !MMU
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
@@ -36,426 +33,70 @@ config TIME_LOW_RES
 	bool
 	default y
 
-config GENERIC_IOMAP
-	bool
-	default y
-
-config ARCH_MAY_HAVE_PC_FDC
-	bool
-	depends on BROKEN && (Q40 || SUN3X)
-	default y
-
 config NO_IOPORT
 	def_bool y
 
 config NO_DMA
-	def_bool SUN3
+	def_bool (MMU && SUN3) || (!MMU && !COLDFIRE)
+
+config ZONE_DMA
+	bool
+	default y
 
 config HZ
 	int
+	default 1000 if CLEOPATRA
 	default 100
 
-config ARCH_USES_GETTIMEOFFSET
-	def_bool y
-
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
 
-menu "Platform dependent setup"
-
-config EISA
-	bool
-	---help---
-	  The Extended Industry Standard Architecture (EISA) bus was
-	  developed as an open alternative to the IBM MicroChannel bus.
-
-	  The EISA bus provided some of the features of the IBM MicroChannel
-	  bus while maintaining backward compatibility with cards made for
-	  the older ISA bus.  The EISA bus saw limited use between 1988 and
-	  1995 when it was made obsolete by the PCI bus.
-
-	  Say Y here if you are building a kernel for an EISA-based machine.
-
-	  Otherwise, say N.
-
-config MCA
-	bool
-	help
-	  MicroChannel Architecture is found in some IBM PS/2 machines and
-	  laptops.  It is a bus system similar to PCI or ISA. See
-	  <file:Documentation/mca.txt> (and especially the web page given
-	  there) before attempting to build an MCA bus kernel.
-
-config PCMCIA
-	tristate
-	---help---
-	  Say Y here if you want to attach PCMCIA- or PC-cards to your Linux
-	  computer.  These are credit-card size devices such as network cards,
-	  modems or hard drives often used with laptops computers.  There are
-	  actually two varieties of these cards: the older 16 bit PCMCIA cards
-	  and the newer 32 bit CardBus cards.  If you want to use CardBus
-	  cards, you need to say Y here and also to "CardBus support" below.
-
-	  To use your PC-cards, you will need supporting software from David
-	  Hinds' pcmcia-cs package (see the file <file:Documentation/Changes>
-	  for location).  Please also read the PCMCIA-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  To compile this driver as modules, choose M here: the
-	  modules will be called pcmcia_core and ds.
-
-config AMIGA
-	bool "Amiga support"
-	select MMU_MOTOROLA if MMU
-	help
-	  This option enables support for the Amiga series of computers. If
-	  you plan to use this kernel on an Amiga, say Y here and browse the
-	  material available in <file:Documentation/m68k>; otherwise say N.
-
-config ATARI
-	bool "Atari support"
-	select MMU_MOTOROLA if MMU
-	help
-	  This option enables support for the 68000-based Atari series of
-	  computers (including the TT, Falcon and Medusa). If you plan to use
-	  this kernel on an Atari, say Y here and browse the material
-	  available in <file:Documentation/m68k>; otherwise say N.
-
-config MAC
-	bool "Macintosh support"
-	select MMU_MOTOROLA if MMU
-	help
-	  This option enables support for the Apple Macintosh series of
-	  computers (yes, there is experimental support now, at least for part
-	  of the series).
-
-	  Say N unless you're willing to code the remaining necessary support.
-	  ;)
-
-config NUBUS
-	bool
-	depends on MAC
-	default y
-
-config M68K_L2_CACHE
-	bool
-	depends on MAC
-	default y
-
-config APOLLO
-	bool "Apollo support"
-	select MMU_MOTOROLA if MMU
-	help
-	  Say Y here if you want to run Linux on an MC680x0-based Apollo
-	  Domain workstation such as the DN3500.
-
-config VME
-	bool "VME (Motorola and BVM) support"
-	select MMU_MOTOROLA if MMU
-	help
-	  Say Y here if you want to build a kernel for a 680x0 based VME
-	  board.  Boards currently supported include Motorola boards MVME147,
-	  MVME162, MVME166, MVME167, MVME172, and MVME177.  BVME4000 and
-	  BVME6000 boards from BVM Ltd are also supported.
-
-config MVME147
-	bool "MVME147 support"
-	depends on VME
-	help
-	  Say Y to include support for early Motorola VME boards.  This will
-	  build a kernel which can run on MVME147 single-board computers.  If
-	  you select this option you will have to select the appropriate
-	  drivers for SCSI, Ethernet and serial ports later on.
-
-config MVME16x
-	bool "MVME162, 166 and 167 support"
-	depends on VME
-	help
-	  Say Y to include support for Motorola VME boards.  This will build a
-	  kernel which can run on MVME162, MVME166, MVME167, MVME172, and
-	  MVME177 boards.  If you select this option you will have to select
-	  the appropriate drivers for SCSI, Ethernet and serial ports later
-	  on.
-
-config BVME6000
-	bool "BVME4000 and BVME6000 support"
-	depends on VME
-	help
-	  Say Y to include support for VME boards from BVM Ltd.  This will
-	  build a kernel which can run on BVME4000 and BVME6000 boards.  If
-	  you select this option you will have to select the appropriate
-	  drivers for SCSI, Ethernet and serial ports later on.
-
-config HP300
-	bool "HP9000/300 and HP9000/400 support"
-	select MMU_MOTOROLA if MMU
-	help
-	  This option enables support for the HP9000/300 and HP9000/400 series
-	  of workstations. Support for these machines is still somewhat
-	  experimental. If you plan to try to use the kernel on such a machine
-	  say Y here.
-	  Everybody else says N.
-
-config DIO
-	bool "DIO bus support"
-	depends on HP300
+config MMU
+	bool "MMU-based Paged Memory Management Support"
 	default y
 	help
-	  Say Y here to enable support for the "DIO" expansion bus used in
-	  HP300 machines. If you are using such a system you almost certainly
-	  want this.
-
-config SUN3X
-	bool "Sun3x support"
-	select MMU_MOTOROLA if MMU
-	select M68030
-	help
-	  This option enables support for the Sun 3x series of workstations.
-	  Be warned that this support is very experimental.
-	  Note that Sun 3x kernels are not compatible with Sun 3 hardware.
-	  General Linux information on the Sun 3x series (now discontinued)
-	  is at <http://www.angelfire.com/ca2/tech68k/sun3.html>.
-
-	  If you don't want to compile a kernel for a Sun 3x, say N.
-
-config Q40
-	bool "Q40/Q60 support"
-	select MMU_MOTOROLA if MMU
-	help
-	  The Q40 is a Motorola 68040-based successor to the Sinclair QL
-	  manufactured in Germany.  There is an official Q40 home page at
-	  <http://www.q40.de/>.  This option enables support for the Q40 and
-	  Q60. Select your CPU below.  For 68LC060 don't forget to enable FPU
-	  emulation.
-
-config SUN3
-	bool "Sun3 support"
-	depends on !MMU_MOTOROLA
-	select MMU_SUN3 if MMU
-	select M68020
-	help
-	  This option enables support for the Sun 3 series of workstations
-	  (3/50, 3/60, 3/1xx, 3/2xx systems). Enabling this option requires
-	  that all other hardware types must be disabled, as Sun 3 kernels
-	  are incompatible with all other m68k targets (including Sun 3x!).
-
-	  If you don't want to compile a kernel exclusively for a Sun 3, say N.
-
-comment "Processor type"
-
-config M68020
-	bool "68020 support"
-	help
-	  If you anticipate running this kernel on a computer with a MC68020
-	  processor, say Y. Otherwise, say N. Note that the 68020 requires a
-	  68851 MMU (Memory Management Unit) to run Linux/m68k, except on the
-	  Sun 3, which provides its own version.
-
-config M68030
-	bool "68030 support"
-	depends on !MMU_SUN3
-	help
-	  If you anticipate running this kernel on a computer with a MC68030
-	  processor, say Y. Otherwise, say N. Note that a MC68EC030 will not
-	  work, as it does not include an MMU (Memory Management Unit).
-
-config M68040
-	bool "68040 support"
-	depends on !MMU_SUN3
-	help
-	  If you anticipate running this kernel on a computer with a MC68LC040
-	  or MC68040 processor, say Y. Otherwise, say N. Note that an
-	  MC68EC040 will not work, as it does not include an MMU (Memory
-	  Management Unit).
-
-config M68060
-	bool "68060 support"
-	depends on !MMU_SUN3
-	help
-	  If you anticipate running this kernel on a computer with a MC68060
-	  processor, say Y. Otherwise, say N.
-
-config MMU_MOTOROLA
-	bool
-
-config MMU_SUN3
-	bool
-	depends on MMU && !MMU_MOTOROLA
-
-config M68KFPU_EMU
-	bool "Math emulation support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	help
-	  At some point in the future, this will cause floating-point math
-	  instructions to be emulated by the kernel on machines that lack a
-	  floating-point math coprocessor.  Thrill-seekers and chronically
-	  sleep-deprived psychotic hacker types can say Y now, everyone else
-	  should probably wait a while.
-
-config M68KFPU_EMU_EXTRAPREC
-	bool "Math emulation extra precision"
-	depends on M68KFPU_EMU
-	help
-	  The fpu uses normally a few bit more during calculations for
-	  correct rounding, the emulator can (often) do the same but this
-	  extra calculation can cost quite some time, so you can disable
-	  it here. The emulator will then "only" calculate with a 64 bit
-	  mantissa and round slightly incorrect, what is more than enough
-	  for normal usage.
-
-config M68KFPU_EMU_ONLY
-	bool "Math emulation only kernel"
-	depends on M68KFPU_EMU
-	help
-	  This option prevents any floating-point instructions from being
-	  compiled into the kernel, thereby the kernel doesn't save any
-	  floating point context anymore during task switches, so this
-	  kernel will only be usable on machines without a floating-point
-	  math coprocessor. This makes the kernel a bit faster as no tests
-	  needs to be executed whether a floating-point instruction in the
-	  kernel should be executed or not.
-
-config ADVANCED
-	bool "Advanced configuration options"
-	---help---
-	  This gives you access to some advanced options for the CPU. The
-	  defaults should be fine for most users, but these options may make
-	  it possible for you to improve performance somewhat if you know what
-	  you are doing.
-
-	  Note that the answer to this question won't directly affect the
-	  kernel: saying N will just cause the configurator to skip all
-	  the questions about these options.
-
-	  Most users should say N to this question.
-
-config RMW_INSNS
-	bool "Use read-modify-write instructions"
-	depends on ADVANCED
-	---help---
-	  This allows to use certain instructions that work with indivisible
-	  read-modify-write bus cycles. While this is faster than the
-	  workaround of disabling interrupts, it can conflict with DMA
-	  ( = direct memory access) on many Amiga systems, and it is also said
-	  to destabilize other machines. It is very likely that this will
-	  cause serious problems on any Amiga or Atari Medusa if set. The only
-	  configuration where it should work are 68030-based Ataris, where it
-	  apparently improves performance. But you've been warned! Unless you
-	  really know what you are doing, say N. Try Y only if you're quite
-	  adventurous.
-
-config SINGLE_MEMORY_CHUNK
-	bool "Use one physical chunk of memory only" if ADVANCED && !SUN3
-	default y if SUN3
-	select NEED_MULTIPLE_NODES
-	help
-	  Ignore all but the first contiguous chunk of physical memory for VM
-	  purposes.  This will save a few bytes kernel size and may speed up
-	  some operations.  Say N if not sure.
-
-config 060_WRITETHROUGH
-	bool "Use write-through caching for 68060 supervisor accesses"
-	depends on ADVANCED && M68060
-	---help---
-	  The 68060 generally uses copyback caching of recently accessed data.
-	  Copyback caching means that memory writes will be held in an on-chip
-	  cache and only written back to memory some time later.  Saying Y
-	  here will force supervisor (kernel) accesses to use writethrough
-	  caching.  Writethrough caching means that data is written to memory
-	  straight away, so that cache and memory data always agree.
-	  Writethrough caching is less efficient, but is needed for some
-	  drivers on 68060 based systems where the 68060 bus snooping signal
-	  is hardwired on.  The 53c710 SCSI driver is known to suffer from
-	  this problem.
+	  Select if you want MMU-based virtualised addressing space
+	  support by paged memory management. If unsure, say 'Y'.
 
-config ARCH_DISCONTIGMEM_ENABLE
-	def_bool !SINGLE_MEMORY_CHUNK
+menu "Platform dependent setup"
 
-config NODES_SHIFT
-	int
-	default "3"
-	depends on !SINGLE_MEMORY_CHUNK
+if MMU
+source arch/m68k/Kconfig.mmu
+endif
+if !MMU
+source arch/m68k/Kconfig.nommu
+endif
 
 source "mm/Kconfig"
 
 endmenu
 
-menu "General setup"
+menu "Executable file formats"
 
 source "fs/Kconfig.binfmt"
 
-config ZORRO
-	bool "Amiga Zorro (AutoConfig) bus support"
-	depends on AMIGA
-	help
-	  This enables support for the Zorro bus in the Amiga. If you have
-	  expansion cards in your Amiga that conform to the Amiga
-	  AutoConfig(tm) specification, say Y, otherwise N. Note that even
-	  expansion cards that do not fit in the Zorro slots but fit in e.g.
-	  the CPU slot may fall in this category, so you have to say Y to let
-	  Linux use these.
-
-config AMIGA_PCMCIA
-	bool "Amiga 1200/600 PCMCIA support (EXPERIMENTAL)"
-	depends on AMIGA && EXPERIMENTAL
-	help
-	  Include support in the kernel for pcmcia on Amiga 1200 and Amiga
-	  600. If you intend to use pcmcia cards say Y; otherwise say N.
-
-config STRAM_PROC
-	bool "ST-RAM statistics in /proc"
-	depends on ATARI
-	help
-	  Say Y here to report ST-RAM usage statistics in /proc/stram.
-
-config HEARTBEAT
-	bool "Use power LED as a heartbeat" if AMIGA || APOLLO || ATARI || MAC ||Q40
-	default y if !AMIGA && !APOLLO && !ATARI && !MAC && !Q40 && HP300
-	help
-	  Use the power-on LED on your machine as a load meter.  The exact
-	  behavior is platform-dependent, but normally the flash frequency is
-	  a hyperbolic function of the 5-minute load average.
-
-# We have a dedicated heartbeat LED. :-)
-config PROC_HARDWARE
-	bool "/proc/hardware support"
-	help
-	  Say Y here to support the /proc/hardware file, which gives you
-	  access to information about the machine you're running on,
-	  including the model, CPU, MMU, clock speed, BogoMIPS rating,
-	  and memory size.
-
-config ISA
-	bool
-	depends on Q40 || AMIGA_PCMCIA
-	default y
-	help
-	  Find out whether you have ISA slots on your motherboard.  ISA is the
-	  name of a bus system, i.e. the way the CPU talks to the other stuff
-	  inside your box.  Other bus systems are PCI, EISA, MicroChannel
-	  (MCA) or VESA.  ISA is an older system, now being displaced by PCI;
-	  newer boards don't support it.  If you have ISA, say Y, otherwise N.
-
-config GENERIC_ISA_DMA
-	bool
-	depends on Q40 || AMIGA_PCMCIA
-	default y
+endmenu
 
-config ZONE_DMA
-	bool
-	default y
+if !MMU
 
-source "drivers/pci/Kconfig"
+menu "Power management options"
 
-source "drivers/zorro/Kconfig"
+config PM
+        bool "Power Management support"
+        help
+          Support processor power management modes
 
 endmenu
 
+endif
+
 source "net/Kconfig"
 
 source "drivers/Kconfig"
 
+if MMU
+
 menu "Character devices"
 
 config ATARI_MFPSER
@@ -606,6 +247,8 @@ config SERIAL_CONSOLE
 
 endmenu
 
+endif
+
 source "fs/Kconfig"
 
 source "arch/m68k/Kconfig.debug"
diff -Naurp linux-2.6.x.half-merge/arch/m68k/Kconfig.debug linux-2.6.x.full-merge/arch/m68k/Kconfig.debug
--- linux-2.6.x.half-merge/arch/m68k/Kconfig.debug	2008-05-19 12:09:09.000000000 +1000
+++ linux-2.6.x.full-merge/arch/m68k/Kconfig.debug	2011-02-17 12:04:57.836435503 +1000
@@ -2,4 +2,38 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
+if !MMU
+
+config FULLDEBUG
+	bool "Full Symbolic/Source Debugging support"
+	help
+	  Enable debugging symbols on kernel build.
+
+config HIGHPROFILE
+	bool "Use fast second timer for profiling"
+	depends on COLDFIRE
+	help
+	  Use a fast secondary clock to produce profiling information.
+
+config BOOTPARAM
+	bool 'Compiled-in Kernel Boot Parameter'
+
+config BOOTPARAM_STRING
+	string 'Kernel Boot Parameter'
+	default 'console=ttyS0,19200'
+	depends on BOOTPARAM
+
+config NO_KERNEL_MSG
+	bool "Suppress Kernel BUG Messages"
+	help
+	  Do not output any debug BUG messages within the kernel.
+
+config BDM_DISABLE
+	bool "Disable BDM signals"
+	depends on (EXPERIMENTAL && COLDFIRE)
+	help
+	  Disable the ColdFire CPU's BDM signals.
+
+endif
+
 endmenu
diff -Naurp linux-2.6.x.half-merge/arch/m68k/Kconfig.mmu linux-2.6.x.full-merge/arch/m68k/Kconfig.mmu
--- linux-2.6.x.half-merge/arch/m68k/Kconfig.mmu	1970-01-01 10:00:00.000000000 +1000
+++ linux-2.6.x.full-merge/arch/m68k/Kconfig.mmu	2011-02-17 14:40:05.105966414 +1000
@@ -0,0 +1,386 @@
+config GENERIC_IOMAP
+	bool
+	default y
+
+config ARCH_MAY_HAVE_PC_FDC
+	bool
+	depends on BROKEN && (Q40 || SUN3X)
+	default y
+
+config ARCH_USES_GETTIMEOFFSET
+	def_bool y
+
+config EISA
+	bool
+	---help---
+	  The Extended Industry Standard Architecture (EISA) bus was
+	  developed as an open alternative to the IBM MicroChannel bus.
+
+	  The EISA bus provided some of the features of the IBM MicroChannel
+	  bus while maintaining backward compatibility with cards made for
+	  the older ISA bus.  The EISA bus saw limited use between 1988 and
+	  1995 when it was made obsolete by the PCI bus.
+
+	  Say Y here if you are building a kernel for an EISA-based machine.
+
+	  Otherwise, say N.
+
+config MCA
+	bool
+	help
+	  MicroChannel Architecture is found in some IBM PS/2 machines and
+	  laptops.  It is a bus system similar to PCI or ISA. See
+	  <file:Documentation/mca.txt> (and especially the web page given
+	  there) before attempting to build an MCA bus kernel.
+
+config PCMCIA
+	tristate
+	---help---
+	  Say Y here if you want to attach PCMCIA- or PC-cards to your Linux
+	  computer.  These are credit-card size devices such as network cards,
+	  modems or hard drives often used with laptops computers.  There are
+	  actually two varieties of these cards: the older 16 bit PCMCIA cards
+	  and the newer 32 bit CardBus cards.  If you want to use CardBus
+	  cards, you need to say Y here and also to "CardBus support" below.
+
+	  To use your PC-cards, you will need supporting software from David
+	  Hinds' pcmcia-cs package (see the file <file:Documentation/Changes>
+	  for location).  Please also read the PCMCIA-HOWTO, available from
+	  <http://www.tldp.org/docs.html#howto>.
+
+	  To compile this driver as modules, choose M here: the
+	  modules will be called pcmcia_core and ds.
+
+config AMIGA
+	bool "Amiga support"
+	select MMU_MOTOROLA if MMU
+	help
+	  This option enables support for the Amiga series of computers. If
+	  you plan to use this kernel on an Amiga, say Y here and browse the
+	  material available in <file:Documentation/m68k>; otherwise say N.
+
+config ATARI
+	bool "Atari support"
+	select MMU_MOTOROLA if MMU
+	help
+	  This option enables support for the 68000-based Atari series of
+	  computers (including the TT, Falcon and Medusa). If you plan to use
+	  this kernel on an Atari, say Y here and browse the material
+	  available in <file:Documentation/m68k>; otherwise say N.
+
+config MAC
+	bool "Macintosh support"
+	select MMU_MOTOROLA if MMU
+	help
+	  This option enables support for the Apple Macintosh series of
+	  computers (yes, there is experimental support now, at least for part
+	  of the series).
+
+	  Say N unless you're willing to code the remaining necessary support.
+	  ;)
+
+config NUBUS
+	bool
+	depends on MAC
+	default y
+
+config M68K_L2_CACHE
+	bool
+	depends on MAC
+	default y
+
+config APOLLO
+	bool "Apollo support"
+	select MMU_MOTOROLA if MMU
+	help
+	  Say Y here if you want to run Linux on an MC680x0-based Apollo
+	  Domain workstation such as the DN3500.
+
+config VME
+	bool "VME (Motorola and BVM) support"
+	select MMU_MOTOROLA if MMU
+	help
+	  Say Y here if you want to build a kernel for a 680x0 based VME
+	  board.  Boards currently supported include Motorola boards MVME147,
+	  MVME162, MVME166, MVME167, MVME172, and MVME177.  BVME4000 and
+	  BVME6000 boards from BVM Ltd are also supported.
+
+config MVME147
+	bool "MVME147 support"
+	depends on VME
+	help
+	  Say Y to include support for early Motorola VME boards.  This will
+	  build a kernel which can run on MVME147 single-board computers.  If
+	  you select this option you will have to select the appropriate
+	  drivers for SCSI, Ethernet and serial ports later on.
+
+config MVME16x
+	bool "MVME162, 166 and 167 support"
+	depends on VME
+	help
+	  Say Y to include support for Motorola VME boards.  This will build a
+	  kernel which can run on MVME162, MVME166, MVME167, MVME172, and
+	  MVME177 boards.  If you select this option you will have to select
+	  the appropriate drivers for SCSI, Ethernet and serial ports later
+	  on.
+
+config BVME6000
+	bool "BVME4000 and BVME6000 support"
+	depends on VME
+	help
+	  Say Y to include support for VME boards from BVM Ltd.  This will
+	  build a kernel which can run on BVME4000 and BVME6000 boards.  If
+	  you select this option you will have to select the appropriate
+	  drivers for SCSI, Ethernet and serial ports later on.
+
+config HP300
+	bool "HP9000/300 and HP9000/400 support"
+	select MMU_MOTOROLA if MMU
+	help
+	  This option enables support for the HP9000/300 and HP9000/400 series
+	  of workstations. Support for these machines is still somewhat
+	  experimental. If you plan to try to use the kernel on such a machine
+	  say Y here.
+	  Everybody else says N.
+
+config DIO
+	bool "DIO bus support"
+	depends on HP300
+	default y
+	help
+	  Say Y here to enable support for the "DIO" expansion bus used in
+	  HP300 machines. If you are using such a system you almost certainly
+	  want this.
+
+config SUN3X
+	bool "Sun3x support"
+	select MMU_MOTOROLA if MMU
+	select M68030
+	help
+	  This option enables support for the Sun 3x series of workstations.
+	  Be warned that this support is very experimental.
+	  Note that Sun 3x kernels are not compatible with Sun 3 hardware.
+	  General Linux information on the Sun 3x series (now discontinued)
+	  is at <http://www.angelfire.com/ca2/tech68k/sun3.html>.
+
+	  If you don't want to compile a kernel for a Sun 3x, say N.
+
+config Q40
+	bool "Q40/Q60 support"
+	select MMU_MOTOROLA if MMU
+	help
+	  The Q40 is a Motorola 68040-based successor to the Sinclair QL
+	  manufactured in Germany.  There is an official Q40 home page at
+	  <http://www.q40.de/>.  This option enables support for the Q40 and
+	  Q60. Select your CPU below.  For 68LC060 don't forget to enable FPU
+	  emulation.
+
+config SUN3
+	bool "Sun3 support"
+	depends on !MMU_MOTOROLA
+	select MMU_SUN3 if MMU
+	select M68020
+	help
+	  This option enables support for the Sun 3 series of workstations
+	  (3/50, 3/60, 3/1xx, 3/2xx systems). Enabling this option requires
+	  that all other hardware types must be disabled, as Sun 3 kernels
+	  are incompatible with all other m68k targets (including Sun 3x!).
+
+	  If you don't want to compile a kernel exclusively for a Sun 3, say N.
+
+comment "Processor type"
+
+config M68020
+	bool "68020 support"
+	help
+	  If you anticipate running this kernel on a computer with a MC68020
+	  processor, say Y. Otherwise, say N. Note that the 68020 requires a
+	  68851 MMU (Memory Management Unit) to run Linux/m68k, except on the
+	  Sun 3, which provides its own version.
+
+config M68030
+	bool "68030 support"
+	depends on !MMU_SUN3
+	help
+	  If you anticipate running this kernel on a computer with a MC68030
+	  processor, say Y. Otherwise, say N. Note that a MC68EC030 will not
+	  work, as it does not include an MMU (Memory Management Unit).
+
+config M68040
+	bool "68040 support"
+	depends on !MMU_SUN3
+	help
+	  If you anticipate running this kernel on a computer with a MC68LC040
+	  or MC68040 processor, say Y. Otherwise, say N. Note that an
+	  MC68EC040 will not work, as it does not include an MMU (Memory
+	  Management Unit).
+
+config M68060
+	bool "68060 support"
+	depends on !MMU_SUN3
+	help
+	  If you anticipate running this kernel on a computer with a MC68060
+	  processor, say Y. Otherwise, say N.
+
+config MMU_MOTOROLA
+	bool
+
+config MMU_SUN3
+	bool
+	depends on MMU && !MMU_MOTOROLA
+
+config M68KFPU_EMU
+	bool "Math emulation support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  At some point in the future, this will cause floating-point math
+	  instructions to be emulated by the kernel on machines that lack a
+	  floating-point math coprocessor.  Thrill-seekers and chronically
+	  sleep-deprived psychotic hacker types can say Y now, everyone else
+	  should probably wait a while.
+
+config M68KFPU_EMU_EXTRAPREC
+	bool "Math emulation extra precision"
+	depends on M68KFPU_EMU
+	help
+	  The fpu uses normally a few bit more during calculations for
+	  correct rounding, the emulator can (often) do the same but this
+	  extra calculation can cost quite some time, so you can disable
+	  it here. The emulator will then "only" calculate with a 64 bit
+	  mantissa and round slightly incorrect, what is more than enough
+	  for normal usage.
+
+config M68KFPU_EMU_ONLY
+	bool "Math emulation only kernel"
+	depends on M68KFPU_EMU
+	help
+	  This option prevents any floating-point instructions from being
+	  compiled into the kernel, thereby the kernel doesn't save any
+	  floating point context anymore during task switches, so this
+	  kernel will only be usable on machines without a floating-point
+	  math coprocessor. This makes the kernel a bit faster as no tests
+	  needs to be executed whether a floating-point instruction in the
+	  kernel should be executed or not.
+
+config ADVANCED
+	bool "Advanced configuration options"
+	---help---
+	  This gives you access to some advanced options for the CPU. The
+	  defaults should be fine for most users, but these options may make
+	  it possible for you to improve performance somewhat if you know what
+	  you are doing.
+
+	  Note that the answer to this question won't directly affect the
+	  kernel: saying N will just cause the configurator to skip all
+	  the questions about these options.
+
+	  Most users should say N to this question.
+
+config RMW_INSNS
+	bool "Use read-modify-write instructions"
+	depends on ADVANCED
+	---help---
+	  This allows to use certain instructions that work with indivisible
+	  read-modify-write bus cycles. While this is faster than the
+	  workaround of disabling interrupts, it can conflict with DMA
+	  ( = direct memory access) on many Amiga systems, and it is also said
+	  to destabilize other machines. It is very likely that this will
+	  cause serious problems on any Amiga or Atari Medusa if set. The only
+	  configuration where it should work are 68030-based Ataris, where it
+	  apparently improves performance. But you've been warned! Unless you
+	  really know what you are doing, say N. Try Y only if you're quite
+	  adventurous.
+
+config SINGLE_MEMORY_CHUNK
+	bool "Use one physical chunk of memory only" if ADVANCED && !SUN3
+	default y if SUN3
+	select NEED_MULTIPLE_NODES
+	help
+	  Ignore all but the first contiguous chunk of physical memory for VM
+	  purposes.  This will save a few bytes kernel size and may speed up
+	  some operations.  Say N if not sure.
+
+config 060_WRITETHROUGH
+	bool "Use write-through caching for 68060 supervisor accesses"
+	depends on ADVANCED && M68060
+	---help---
+	  The 68060 generally uses copyback caching of recently accessed data.
+	  Copyback caching means that memory writes will be held in an on-chip
+	  cache and only written back to memory some time later.  Saying Y
+	  here will force supervisor (kernel) accesses to use writethrough
+	  caching.  Writethrough caching means that data is written to memory
+	  straight away, so that cache and memory data always agree.
+	  Writethrough caching is less efficient, but is needed for some
+	  drivers on 68060 based systems where the 68060 bus snooping signal
+	  is hardwired on.  The 53c710 SCSI driver is known to suffer from
+	  this problem.
+
+config ARCH_DISCONTIGMEM_ENABLE
+	def_bool !SINGLE_MEMORY_CHUNK
+
+config NODES_SHIFT
+	int
+	default "3"
+	depends on !SINGLE_MEMORY_CHUNK
+
+config ZORRO
+	bool "Amiga Zorro (AutoConfig) bus support"
+	depends on AMIGA
+	help
+	  This enables support for the Zorro bus in the Amiga. If you have
+	  expansion cards in your Amiga that conform to the Amiga
+	  AutoConfig(tm) specification, say Y, otherwise N. Note that even
+	  expansion cards that do not fit in the Zorro slots but fit in e.g.
+	  the CPU slot may fall in this category, so you have to say Y to let
+	  Linux use these.
+
+config AMIGA_PCMCIA
+	bool "Amiga 1200/600 PCMCIA support (EXPERIMENTAL)"
+	depends on AMIGA && EXPERIMENTAL
+	help
+	  Include support in the kernel for pcmcia on Amiga 1200 and Amiga
+	  600. If you intend to use pcmcia cards say Y; otherwise say N.
+
+config STRAM_PROC
+	bool "ST-RAM statistics in /proc"
+	depends on ATARI
+	help
+	  Say Y here to report ST-RAM usage statistics in /proc/stram.
+
+config HEARTBEAT
+	bool "Use power LED as a heartbeat" if AMIGA || APOLLO || ATARI || MAC ||Q40
+	default y if !AMIGA && !APOLLO && !ATARI && !MAC && !Q40 && HP300
+	help
+	  Use the power-on LED on your machine as a load meter.  The exact
+	  behavior is platform-dependent, but normally the flash frequency is
+	  a hyperbolic function of the 5-minute load average.
+
+# We have a dedicated heartbeat LED. :-)
+config PROC_HARDWARE
+	bool "/proc/hardware support"
+	help
+	  Say Y here to support the /proc/hardware file, which gives you
+	  access to information about the machine you're running on,
+	  including the model, CPU, MMU, clock speed, BogoMIPS rating,
+	  and memory size.
+
+config ISA
+	bool
+	depends on Q40 || AMIGA_PCMCIA
+	default y
+	help
+	  Find out whether you have ISA slots on your motherboard.  ISA is the
+	  name of a bus system, i.e. the way the CPU talks to the other stuff
+	  inside your box.  Other bus systems are PCI, EISA, MicroChannel
+	  (MCA) or VESA.  ISA is an older system, now being displaced by PCI;
+	  newer boards don't support it.  If you have ISA, say Y, otherwise N.
+
+config GENERIC_ISA_DMA
+	bool
+	depends on Q40 || AMIGA_PCMCIA
+	default y
+
+source "drivers/pci/Kconfig"
+
+source "drivers/zorro/Kconfig"
+
diff -Naurp linux-2.6.x.half-merge/arch/m68k/Kconfig.nommu linux-2.6.x.full-merge/arch/m68k/Kconfig.nommu
--- linux-2.6.x.half-merge/arch/m68k/Kconfig.nommu	1970-01-01 10:00:00.000000000 +1000
+++ linux-2.6.x.full-merge/arch/m68k/Kconfig.nommu	2011-02-17 14:41:50.095767516 +1000
@@ -0,0 +1,715 @@
+config FPU
+	bool
+	default n
+
+config GENERIC_FIND_NEXT_BIT
+	bool
+	default y
+
+config GENERIC_GPIO
+	bool
+	default n
+
+config GENERIC_CMOS_UPDATE
+	bool
+	default y
+
+config GENERIC_CLOCKEVENTS
+	bool
+	default n
+
+config COLDFIRE_SW_A7
+	bool
+	default n
+
+config HAVE_CACHE_SPLIT
+	bool
+
+config HAVE_CACHE_CB
+	bool
+
+choice
+	prompt "CPU"
+	default M68EZ328
+
+config M68328
+	bool "MC68328"
+	help
+	  Motorola 68328 processor support.
+
+config M68EZ328
+	bool "MC68EZ328"
+	help
+	  Motorola 68EX328 processor support.
+
+config M68VZ328
+	bool "MC68VZ328"
+	help
+	  Motorola 68VZ328 processor support.
+
+config M68360
+	bool "MC68360"
+	help
+	  Motorola 68360 processor support.
+
+config M5206
+	bool "MCF5206"
+	select COLDFIRE_SW_A7
+	help
+	  Motorola ColdFire 5206 processor support.
+
+config M5206e
+	bool "MCF5206e"
+	select COLDFIRE_SW_A7
+	help
+	  Motorola ColdFire 5206e processor support.
+
+config M520x
+	bool "MCF520x"
+	select GENERIC_CLOCKEVENTS
+	select HAVE_CACHE_SPLIT
+	help
+	   Freescale Coldfire 5207/5208 processor support.
+
+config M523x
+	bool "MCF523x"
+	select GENERIC_CLOCKEVENTS
+	select HAVE_CACHE_SPLIT
+	help
+	  Freescale Coldfire 5230/1/2/4/5 processor support
+
+config M5249
+	bool "MCF5249"
+	select COLDFIRE_SW_A7
+	help
+	  Motorola ColdFire 5249 processor support.
+
+config M5271
+	bool "MCF5271"
+	select HAVE_CACHE_SPLIT
+	help
+	  Freescale (Motorola) ColdFire 5270/5271 processor support.
+
+config M5272
+	bool "MCF5272"
+	select COLDFIRE_SW_A7
+	help
+	  Motorola ColdFire 5272 processor support.
+
+config M5275
+	bool "MCF5275"
+	select HAVE_CACHE_SPLIT
+	help
+	  Freescale (Motorola) ColdFire 5274/5275 processor support.
+
+config M528x
+	bool "MCF528x"
+	select GENERIC_CLOCKEVENTS
+	select HAVE_CACHE_SPLIT
+	help
+	  Motorola ColdFire 5280/5282 processor support.
+
+config M5307
+	bool "MCF5307"
+	select COLDFIRE_SW_A7
+	select HAVE_CACHE_CB
+	help
+	  Motorola ColdFire 5307 processor support.
+
+config M532x
+	bool "MCF532x"
+	select HAVE_CACHE_CB
+	help
+	  Freescale (Motorola) ColdFire 532x processor support.
+
+config M5407
+	bool "MCF5407"
+	select COLDFIRE_SW_A7
+	select HAVE_CACHE_CB
+	help
+	  Motorola ColdFire 5407 processor support.
+
+config M547x
+	bool "MCF547x"
+	select HAVE_CACHE_CB
+	help
+	  Freescale ColdFire 5470/5471/5472/5473/5474/5475 processor support.
+
+config M548x
+	bool "MCF548x"
+	select HAVE_CACHE_CB
+	help
+	  Freescale ColdFire 5480/5481/5482/5483/5484/5485 processor support.
+
+endchoice
+
+config M527x
+	bool
+	depends on (M5271 || M5275)
+	select GENERIC_CLOCKEVENTS
+	default y
+
+config M54xx
+	bool
+	depends on (M548x || M547x)
+	default y
+
+config COLDFIRE
+	bool
+	depends on (M5206 || M5206e || M520x || M523x || M5249 || M527x || M5272 || M528x || M5307 || M532x || M5407 || M54xx)
+	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
+	default y
+
+config CLOCK_SET
+	bool "Enable setting the CPU clock frequency"
+	default n
+	help
+	  On some CPU's you do not need to know what the core CPU clock
+	  frequency is. On these you can disable clock setting. On some
+	  traditional 68K parts, and on all ColdFire parts you need to set
+	  the appropriate CPU clock frequency. On these devices many of the
+	  onboard peripherals derive their timing from the master CPU clock
+	  frequency.
+
+config CLOCK_FREQ
+	int "Set the core clock frequency"
+	default "66666666"
+	depends on CLOCK_SET
+	help
+	  Define the CPU clock frequency in use. This is the core clock
+	  frequency, it may or may not be the same as the external clock
+	  crystal fitted to your board. Some processors have an internal
+	  PLL and can have their frequency programmed at run time, others
+	  use internal dividers. In general the kernel won't setup a PLL
+	  if it is fitted (there are some exceptions). This value will be
+	  specific to the exact CPU that you are using.
+
+config CLOCK_DIV
+	int "Set the core/bus clock divide ratio"
+	default "1"
+	depends on CLOCK_SET
+	help
+	  On many SoC style CPUs the master CPU clock is also used to drive 
+	  on-chip peripherals. The clock that is distributed to these
+	  peripherals is sometimes a fixed ratio of the master clock
+	  frequency. If so then set this to the divider ratio of the
+	  master clock to the peripheral clock. If not sure then select 1.
+
+config OLDMASK
+	bool "Old mask 5307 (1H55J) silicon"
+	depends on M5307
+	help
+	  Build support for the older revision ColdFire 5307 silicon.
+	  Specifically this is the 1H55J mask revision.
+
+if HAVE_CACHE_SPLIT
+choice
+	prompt "Split Cache Configuration"
+	default CACHE_I
+
+config CACHE_I
+	bool "Instruction"
+	help
+	  Use all of the ColdFire CPU cache memory as an instruction cache.
+
+config CACHE_D
+	bool "Data"
+	help
+	  Use all of the ColdFire CPU cache memory as a data cache.
+
+config CACHE_BOTH
+	bool "Both"
+	help
+	  Split the ColdFire CPU cache, and use half as an instruction cache
+	  and half as a data cache.
+endchoice
+endif
+
+if HAVE_CACHE_CB
+choice
+	prompt "Data cache mode"
+	default CACHE_WRITETHRU
+
+config CACHE_WRITETHRU
+	bool "Write-through"
+	help
+	  The ColdFire CPU cache is set into Write-through mode.
+
+config CACHE_COPYBACK
+	bool "Copy-back"
+	help
+	  The ColdFire CPU cache is set into Copy-back mode.
+endchoice
+endif
+
+comment "Platform"
+
+config PILOT3
+	bool "Pilot 1000/5000, PalmPilot Personal/Pro, or PalmIII support"
+	depends on M68328
+	help
+	  Support for the Palm Pilot 1000/5000, Personal/Pro and PalmIII.
+
+config XCOPILOT_BUGS
+	bool "(X)Copilot support"
+	depends on PILOT3
+	help
+	  Support the bugs of Xcopilot.
+
+config UC5272
+	bool 'Arcturus Networks uC5272 dimm board support'
+	depends on M5272
+	help
+	  Support for the Arcturus Networks uC5272 dimm board.
+
+config UC5282
+	bool "Arcturus Networks uC5282 board support"
+	depends on M528x
+	help
+	  Support for the Arcturus Networks uC5282 dimm board.
+
+config UCSIMM
+	bool "uCsimm module support"
+	depends on M68EZ328
+	help
+	  Support for the Arcturus Networks uCsimm module.
+
+config UCDIMM
+	bool "uDsimm module support"
+	depends on M68VZ328
+	help
+	  Support for the Arcturus Networks uDsimm module.
+
+config DRAGEN2
+	bool "DragenEngine II board support"
+	depends on M68VZ328
+	help
+	  Support for the DragenEngine II board.
+
+config DIRECT_IO_ACCESS
+	bool "Allow user to access IO directly"
+	depends on (UCSIMM || UCDIMM || DRAGEN2)
+	help
+	  Disable the CPU internal registers protection in user mode,
+	  to allow a user application to read/write them.
+
+config INIT_LCD
+	bool "Initialize LCD"
+	depends on (UCSIMM || UCDIMM || DRAGEN2)
+	help
+	  Initialize the LCD controller of the 68x328 processor.
+
+config MEMORY_RESERVE
+	int "Memory reservation (MiB)"
+	depends on (UCSIMM || UCDIMM)
+	help
+	  Reserve certain memory regions on 68x328 based boards.
+
+config UCQUICC
+	bool "Lineo uCquicc board support"
+	depends on M68360
+	help
+	  Support for the Lineo uCquicc board.
+
+config ARN5206
+	bool "Arnewsh 5206 board support"
+	depends on M5206
+	help
+	  Support for the Arnewsh 5206 board.
+
+config M5206eC3
+	bool "Motorola M5206eC3 board support"
+	depends on M5206e
+	help
+	  Support for the Motorola M5206eC3 board.
+
+config ELITE
+	bool "Motorola M5206eLITE board support"
+	depends on M5206e
+	help
+	  Support for the Motorola M5206eLITE board.
+
+config M5208EVB
+	bool "Freescale M5208EVB board support"
+	depends on M520x
+	help
+	  Support for the Freescale Coldfire M5208EVB.
+
+config M5235EVB
+	bool "Freescale M5235EVB support"
+	depends on M523x
+	help
+	  Support for the Freescale M5235EVB board.
+
+config M5249C3
+	bool "Motorola M5249C3 board support"
+	depends on M5249
+	help
+	  Support for the Motorola M5249C3 board.
+
+config M5271EVB
+	bool "Freescale (Motorola) M5271EVB board support"
+	depends on M5271
+	help
+	  Support for the Freescale (Motorola) M5271EVB board.
+
+config M5275EVB
+	bool "Freescale (Motorola) M5275EVB board support"
+	depends on M5275
+	help
+	  Support for the Freescale (Motorola) M5275EVB board.
+
+config M5272C3
+	bool "Motorola M5272C3 board support"
+	depends on M5272
+	help
+	  Support for the Motorola M5272C3 board.
+
+config COBRA5272
+	bool "senTec COBRA5272 board support"
+	depends on M5272
+	help
+	  Support for the senTec COBRA5272 board.
+
+config AVNET5282
+	bool "Avnet 5282 board support"
+	depends on M528x
+	help
+	  Support for the Avnet 5282 board.  
+	  
+config M5282EVB
+	bool "Motorola M5282EVB board support"
+	depends on M528x
+	help
+	  Support for the Motorola M5282EVB board.
+
+config COBRA5282
+	bool "senTec COBRA5282 board support"
+	depends on M528x
+	help
+	  Support for the senTec COBRA5282 board.
+	  
+config SOM5282EM
+	bool "EMAC.Inc SOM5282EM board support"
+	depends on M528x
+	help
+	  Support for the EMAC.Inc SOM5282EM module.  
+	  
+config WILDFIRE
+	bool "Intec Automation Inc. WildFire board support"
+	depends on M528x
+	help
+	  Support for the Intec Automation Inc. WildFire.
+	  
+config WILDFIREMOD
+	bool "Intec Automation Inc. WildFire module support"
+	depends on M528x
+	help
+	  Support for the Intec Automation Inc. WildFire module.
+
+config ARN5307
+	bool "Arnewsh 5307 board support"
+	depends on M5307
+	help
+	  Support for the Arnewsh 5307 board.
+
+config M5307C3
+	bool "Motorola M5307C3 board support"
+	depends on M5307
+	help
+	  Support for the Motorola M5307C3 board.
+
+config SECUREEDGEMP3
+	bool "SnapGear SecureEdge/MP3 platform support"
+	depends on M5307
+	help
+	  Support for the SnapGear SecureEdge/MP3 platform.
+
+config M5329EVB
+	bool "Freescale (Motorola) M5329EVB board support"
+	depends on M532x
+	help
+	  Support for the Freescale (Motorola) M5329EVB board.
+
+config COBRA5329
+	bool "senTec COBRA5329 board support"
+	depends on M532x
+	help
+	  Support for the senTec COBRA5329 board.
+
+config M5407C3
+	bool "Motorola M5407C3 board support"
+	depends on M5407
+	help
+	  Support for the Motorola M5407C3 board.
+
+config CLEOPATRA
+	bool "Feith CLEOPATRA board support"
+	depends on (M5307 || M5407)
+	help
+	  Support for the Feith Cleopatra boards.
+
+config CANCam
+	bool "Feith CANCam board support"
+	depends on M5272
+	help
+	  Support for the Feith CANCam board.
+
+config SCALES
+	bool "Feith SCALES board support"
+	depends on M5272
+	help
+	  Support for the Feith SCALES board.
+
+config NETtel
+	bool "SecureEdge/NETtel board support"
+	depends on (M5206e || M5272 || M5307)
+	help
+	  Support for the SnapGear NETtel/SecureEdge/SnapGear boards.
+
+config SNAPGEAR
+	bool "SnapGear router board support"
+	depends on NETtel
+	help
+	  Special additional support for SnapGear router boards.
+
+config CPU16B
+	bool "Sneha Technologies S.L. Sarasvati board support"
+	depends on M5272
+	help
+	  Support for the SNEHA CPU16B board.
+
+config MOD5272
+	bool "Netburner MOD-5272 board support"
+	depends on M5272
+	help
+	  Support for the Netburner MOD-5272 board.
+
+config SAVANTrosie1
+	bool "Savant Rosie1 board support"
+	depends on M523x
+	help
+	  Support for the Savant Rosie1 board.
+
+config ROMFS_FROM_ROM
+	bool "ROMFS image not RAM resident"
+	depends on (NETtel || SNAPGEAR)
+	help
+	  The ROMfs filesystem will stay resident in the FLASH/ROM, not be
+	  moved into RAM.
+
+config PILOT
+	bool
+	default y
+	depends on (PILOT3 || PILOT5)
+
+config ARNEWSH
+	bool
+	default y
+	depends on (ARN5206 || ARN5307)
+
+config FREESCALE
+	bool
+	default y
+	depends on (M5206eC3 || M5208EVB || M5235EVB || M5249C3 || M5271EVB || M5272C3 || M5275EVB || M5282EVB || M5307C3 || M5329EVB || M5407C3)
+
+config HW_FEITH
+	bool
+	default y
+	depends on (CLEOPATRA || CANCam || SCALES)
+
+config senTec
+	bool
+	default y
+	depends on (COBRA5272 || COBRA5282)
+	
+config EMAC_INC
+	bool
+	default y
+	depends on (SOM5282EM)
+
+config SNEHA
+	bool
+	default y
+	depends on CPU16B
+
+config SAVANT
+	bool
+	default y
+	depends on SAVANTrosie1
+
+config AVNET
+	bool
+	default y
+	depends on (AVNET5282)
+
+config UBOOT
+	bool "Support for U-Boot command line parameters"
+	help
+	  If you say Y here kernel will try to collect command
+	  line parameters from the initial u-boot stack.
+	default n
+
+config 4KSTACKS
+	bool "Use 4Kb for kernel stacks instead of 8Kb"
+	default y
+	help
+	  If you say Y here the kernel will use a 4Kb stacksize for the
+	  kernel stack attached to each process/thread. This facilitates
+	  running more threads on a system and also reduces the pressure
+	  on the VM subsystem for higher order allocations.
+
+comment "RAM configuration"
+
+config RAMBASE
+	hex "Address of the base of RAM"
+	default "0"
+	help
+	  Define the address that RAM starts at. On many platforms this is
+	  0, the base of the address space. And this is the default. Some
+	  platforms choose to setup their RAM at other addresses within the
+	  processor address space.
+
+config RAMSIZE
+	hex "Size of RAM (in bytes), or 0 for automatic"
+	default "0x400000"
+	help
+	  Define the size of the system RAM. If you select 0 then the
+	  kernel will try to probe the RAM size at runtime. This is not
+	  supported on all CPU types.
+
+config VECTORBASE
+	hex "Address of the base of system vectors"
+	default "0"
+	help
+	  Define the address of the system vectors. Commonly this is
+	  put at the start of RAM, but it doesn't have to be. On ColdFire
+	  platforms this address is programmed into the VBR register, thus
+	  actually setting the address to use.
+
+config KERNELBASE
+	hex "Address of the base of kernel code"
+	default "0x400"
+	help
+	  Typically on m68k systems the kernel will not start at the base
+	  of RAM, but usually some small offset from it. Define the start
+	  address of the kernel here. The most common setup will have the
+	  processor vectors at the base of RAM and then the start of the
+	  kernel. On some platforms some RAM is reserved for boot loaders
+	  and the kernel starts after that. The 0x400 default was based on
+	  a system with the RAM based at address 0, and leaving enough room
+	  for the theoretical maximum number of 256 vectors.
+
+choice
+	prompt "RAM bus width"
+	default RAMAUTOBIT
+
+config RAMAUTOBIT
+	bool "AUTO"
+	help
+	  Select the physical RAM data bus size. Not needed on most platforms,
+	  so you can generally choose AUTO.
+
+config RAM8BIT
+	bool "8bit"
+	help
+	  Configure RAM bus to be 8 bits wide.
+
+config RAM16BIT
+	bool "16bit"
+	help
+	  Configure RAM bus to be 16 bits wide.
+
+config RAM32BIT
+	bool "32bit"
+	help
+	  Configure RAM bus to be 32 bits wide.
+
+endchoice
+
+comment "ROM configuration"
+
+config ROM
+	bool "Specify ROM linker regions"
+	default n
+	help
+	  Define a ROM region for the linker script. This creates a kernel
+	  that can be stored in flash, with possibly the text, and data
+	  regions being copied out to RAM at startup.
+
+config ROMBASE
+	hex "Address of the base of ROM device"
+	default "0"
+	depends on ROM
+	help
+	  Define the address that the ROM region starts at. Some platforms
+	  use this to set their chip select region accordingly for the boot
+	  device.
+
+config ROMVEC
+	hex "Address of the base of the ROM vectors"
+	default "0"
+	depends on ROM
+	help
+	  This is almost always the same as the base of the ROM. Since on all
+	  68000 type variants the vectors are at the base of the boot device
+	  on system startup.
+
+config ROMVECSIZE
+	hex "Size of ROM vector region (in bytes)"
+	default "0x400"
+	depends on ROM
+	help
+	  Define the size of the vector region in ROM. For most 68000
+	  variants this would be 0x400 bytes in size. Set to 0 if you do
+	  not want a vector region at the start of the ROM.
+
+config ROMSTART
+	hex "Address of the base of system image in ROM"
+	default "0x400"
+	depends on ROM
+	help
+	  Define the start address of the system image in ROM. Commonly this
+	  is strait after the ROM vectors.
+
+config ROMSIZE
+	hex "Size of the ROM device"
+	default "0x100000"
+	depends on ROM
+	help
+	  Size of the ROM device. On some platforms this is used to setup
+	  the chip select that controls the boot ROM device.
+
+choice
+	prompt "Kernel executes from"
+	---help---
+	  Choose the memory type that the kernel will be running in.
+
+config RAMKERNEL
+	bool "RAM"
+	help
+	  The kernel will be resident in RAM when running.
+
+config ROMKERNEL
+	bool "ROM"
+	help
+	  The kernel will be resident in FLASH/ROM when running. This is
+	  often referred to as Execute-in-Place (XIP), since the kernel
+	  code executes from the position it is stored in the FLASH/ROM.
+
+endchoice
+
+if COLDFIRE
+source "kernel/Kconfig.preempt"
+endif
+
+source "kernel/time/Kconfig"
+
+config ISA_DMA_API
+	bool
+	depends on !M5272
+	default y
+
+source "drivers/pcmcia/Kconfig"
+
diff -Naurp linux-2.6.x.half-merge/arch/m68k/Makefile_no linux-2.6.x.full-merge/arch/m68k/Makefile_no
--- linux-2.6.x.half-merge/arch/m68k/Makefile_no	2011-01-19 21:22:16.753878384 +1000
+++ linux-2.6.x.full-merge/arch/m68k/Makefile_no	2011-02-17 15:22:50.636396207 +1000
@@ -1,5 +1,5 @@
 #
-# arch/m68knommu/Makefile
+# arch/m68k/Makefile_no
 #
 # This file is subject to the terms and conditions of the GNU General Public
 # License.  See the file "COPYING" in the main directory of this archive
@@ -82,7 +82,7 @@ cpuclass-$(CONFIG_M68360)	:= 68360
 CPUCLASS := $(cpuclass-y)
 
 ifneq ($(CPUCLASS),$(PLATFORM))
-CLASSDIR := arch/m68knommu/platform/$(cpuclass-y)/
+CLASSDIR := arch/m68k/platform/$(cpuclass-y)/
 endif
 
 export PLATFORM BOARD MODEL CPUCLASS
@@ -114,13 +114,13 @@ KBUILD_CFLAGS += $(cflags-y)
 KBUILD_CFLAGS += -D__linux__
 KBUILD_CFLAGS += -DUTS_SYSNAME=\"uClinux\"
 
-head-y := arch/m68knommu/platform/$(cpuclass-y)/head.o
+head-y := arch/m68k/platform/$(cpuclass-y)/head.o
 
-core-y	+= arch/m68knommu/kernel/ \
-	   arch/m68knommu/mm/ \
+core-y	+= arch/m68k/kernel/ \
+	   arch/m68k/mm/ \
 	   $(CLASSDIR) \
-	   arch/m68knommu/platform/$(PLATFORM)/
-libs-y	+= arch/m68knommu/lib/
+	   arch/m68k/platform/$(PLATFORM)/
+libs-y	+= arch/m68k/lib/
 
 archclean:
 

--------------090904080404090107040203--
