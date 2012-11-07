Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab2KGJ7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:59:31 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:52751 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab2KGJ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:59:26 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 26/31] ARC: Build system: Makefiles, Kconfig, Linker script
Date: Wed,  7 Nov 2012 10:47:49 +0100
Message-Id: <1352281674-2186-27-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/Kbuild                    |    2 +
 arch/arc/Kconfig                   |  337 ++++++++++++++++++++++++++++++++++++
 arch/arc/Kconfig.debug             |   34 ++++
 arch/arc/Makefile                  |  115 ++++++++++++
 arch/arc/boot/Makefile             |   27 +++
 arch/arc/include/asm/Kbuild        |    1 +
 arch/arc/include/asm/vmlinux.lds.h |   12 ++
 arch/arc/kernel/Makefile           |   16 ++
 arch/arc/kernel/arcksyms.c         |   56 ++++++
 arch/arc/kernel/asm-offsets.c      |   46 +++++
 arch/arc/kernel/vmlinux.lds.S      |  117 +++++++++++++
 arch/arc/lib/Makefile              |    9 +
 arch/arc/mm/Makefile               |   10 +
 arch/arc/plat-arcfpga/Kconfig      |   33 ++++
 arch/arc/plat-arcfpga/Makefile     |    9 +
 15 files changed, 824 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/Kbuild
 create mode 100644 arch/arc/Kconfig
 create mode 100644 arch/arc/Kconfig.debug
 create mode 100644 arch/arc/Makefile
 create mode 100644 arch/arc/boot/Makefile
 create mode 100644 arch/arc/include/asm/vmlinux.lds.h
 create mode 100644 arch/arc/kernel/Makefile
 create mode 100644 arch/arc/kernel/arcksyms.c
 create mode 100644 arch/arc/kernel/asm-offsets.c
 create mode 100644 arch/arc/kernel/vmlinux.lds.S
 create mode 100644 arch/arc/lib/Makefile
 create mode 100644 arch/arc/mm/Makefile
 create mode 100644 arch/arc/plat-arcfpga/Kconfig
 create mode 100644 arch/arc/plat-arcfpga/Makefile

diff --git a/arch/arc/Kbuild b/arch/arc/Kbuild
new file mode 100644
index 0000000..082d329
--- /dev/null
+++ b/arch/arc/Kbuild
@@ -0,0 +1,2 @@
+obj-y += kernel/
+obj-y += mm/
diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
new file mode 100644
index 0000000..d6983afa
--- /dev/null
+++ b/arch/arc/Kconfig
@@ -0,0 +1,337 @@
+#
+# Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+
+config ARC
+	def_bool y
+	select ARCH_WANT_IPC_PARSE_VERSION
+	# ARC Busybox based initramfs absolutely relies on DEVTMPFS for /dev
+	# DEVTMPS in turn needs HOTPLUG
+	select DEVTMPFS if !INITRAMFS_SOURCE=""
+	select GENERIC_ATOMIC64
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_FIND_FIRST_BIT
+	# for now, we don't need GENERIC_IRQ_PROBE, CONFIG_GENERIC_IRQ_CHIP
+	select GENERIC_IRQ_SHOW
+	select GENERIC_PENDING_IRQ if SMP
+	select GENERIC_SMP_IDLE_THREAD
+	select HAVE_GENERIC_HARDIRQS
+	select HOTPLUG if !INITRAMFS_SOURCE=""
+	select MODULES_USE_ELF_RELA
+
+config SCHED_OMIT_FRAME_POINTER
+	def_bool y
+
+config GENERIC_CSUM
+	def_bool y
+
+config RWSEM_GENERIC_SPINLOCK
+	def_bool y
+
+# for old_[ug]id_t - do we need this ?
+config UID16
+	def_bool y
+
+config ARCH_FLATMEM_ENABLE
+	def_bool y
+
+config MMU
+	def_bool y
+
+config NO_IOPORT
+	def_bool y
+
+config GENERIC_CALIBRATE_DELAY
+	def_bool y
+
+config GENERIC_HWEIGHT
+	def_bool y
+
+config BINFMT_ELF
+	def_bool y
+
+config STACKTRACE_SUPPORT
+	def_bool y
+	select STACKTRACE
+
+config HAVE_LATENCYTOP_SUPPORT
+	def_bool y
+
+config NO_DMA
+	def_bool n
+
+source "init/Kconfig"
+source "kernel/Kconfig.freezer"
+
+menu "ARC Architecture Configuration"
+
+choice
+	prompt "ARC Platform"
+	default ARC_PLAT_FPGA_LEGACY
+
+config ARC_PLAT_FPGA_LEGACY
+	bool "\"Legacy\" ARC FPGA dev platform"
+	help
+	  Support for ARC development platforms, provided by Synopsys.
+	  These are based on FPGA or ISS. e.g.
+	  - ARCAngel4
+	  - ML509
+	  - MetaWare ISS
+
+#New platform adds here
+endchoice
+
+menu "ARC CPU Configuration"
+
+choice
+	prompt "ARC Core"
+	default ARC_CPU_770
+
+config ARC_CPU_750D
+	bool "ARC750D"
+	help
+	  Support for ARC750 core
+
+config ARC_CPU_770
+	bool "ARC770"
+	select ARC_CPU_REL_4_10
+	help
+	  Support for ARC770 core introduced with Rel 4.10 (Summer 2011)
+	  This core has a bunch of cool new features:
+	  -MMU-v3: Variable Page Sz (4k, 8k, 16k), bigger J-TLB (128x4)
+                   Shared Address Spaces (for sharing TLB entires in MMU)
+	  -Caches: New Prog Model, Region Flush
+	  -Insns: endian swap, load-locked/store-conditional, time-stamp-ctr
+
+endchoice
+
+config CPU_BIG_ENDIAN
+	bool "Enable Big Endian Mode"
+	default n
+	help
+	  Build kernel for Big Endian Mode of ARC CPU
+
+menuconfig ARC_CACHE
+	bool "Enable Cache Support"
+	default y
+
+if ARC_CACHE
+
+config ARC_CACHE_LINE_SHIFT
+	int "Cache Line Length (as power of 2)"
+	range 5 7
+	default "6"
+	help
+	  Starting with ARC700 4.9, Cache line length is configurable,
+	  This option specifies "N", with Line-len = 2 power N
+	  So line lengths of 32, 64, 128 are specified by 5,6,7, respectively
+	  Linux only supports same line lengths for I and D caches.
+
+config ARC_HAS_ICACHE
+	bool "Use Instruction Cache"
+	default y
+
+config ARC_HAS_DCACHE
+	bool "Use Data Cache"
+	default y
+
+config ARC_CACHE_PAGES
+	bool "Per Page Cache Control"
+	default y
+	depends on ARC_HAS_ICACHE || ARC_HAS_DCACHE
+	help
+	  This can be used to over-ride the global I/D Cache Enable on a
+	  per-page basis (but only for pages accessed via MMU such as
+	  Kernel Virtual address or User Virtual Address)
+	  TLB entries have a per-page Cache Enable Bit.
+	  Note that Global I/D ENABLE + Per Page DISABLE works but corollary
+	  Global DISABLE + Per Page ENABLE won't work
+
+endif	#ARC_CACHE
+
+config ARC_HAS_HW_MPY
+	bool "Use Hardware Multiplier (Normal or Faster XMAC)"
+	default y
+	help
+	  Influences how gcc generates code for MPY operations.
+	  If enabled, MPYxx insns are generated, provided by Standard/XMAC
+	  Multipler. Otherwise software multipy lib is used
+
+choice
+	prompt "ARC700 MMU Version"
+	default ARC_MMU_V3 if ARC_CPU_770
+	default ARC_MMU_V2 if ARC_CPU_750D
+
+config ARC_MMU_V1
+	bool "MMU v1"
+	help
+	  Orig ARC700 MMU
+
+config ARC_MMU_V2
+	bool "MMU v2"
+	help
+	  Fixed the deficiency of v1 - possible thrashing in memcpy sceanrio
+	  when 2 D-TLB and 1 I-TLB entries index into same 2way set.
+
+config ARC_MMU_V3
+	bool "MMU v3"
+	depends on ARC_CPU_770
+	help
+	  Introduced with ARC700 4.10: New Features
+	  Variable Page size (1k-16k), var JTLB size 128 x (2 or 4)
+	  Shared Address Spaces (SASID)
+
+endchoice
+
+
+choice
+	prompt "MMU Page Size"
+	default ARC_PAGE_SIZE_8K
+
+config ARC_PAGE_SIZE_8K
+	bool "8KB"
+	help
+	  Choose between 8k vs 16k
+
+config ARC_PAGE_SIZE_16K
+	bool "16KB"
+	depends on ARC_MMU_V3
+
+config ARC_PAGE_SIZE_4K
+	bool "4KB"
+	depends on ARC_MMU_V3
+
+endchoice
+
+config ARC_FPU_SAVE_RESTORE
+	bool "Enable FPU state persistence across context switch"
+	default n
+	help
+	  Double Precision Floating Point unit had dedictaed regs which
+	  need to be saved/restored across context-switch.
+	  Note that ARC FPU is overly simplistic, unlike say x86, which has
+	  hardware pieces to allow software to conditionally save/restore,
+	  based on actual usage of FPU by a task. Thus our implemn does
+	  this for all tasks in system.
+
+menuconfig ARC_CPU_REL_4_10
+	bool "Enable support for Rel 4.10 features"
+	default n
+	help
+	  -ARC770 (and dependent features) enabled
+	  -ARC750 also shares some of the new features with 770
+
+config ARC_HAS_LLSC
+	bool "Insn: LLOCK/SCOND (efficient atomic ops)"
+	default y
+	depends on ARC_CPU_770
+	# if SMP, enable LLSC ONLY if ARC implementation has coherent atomics
+	depends on !SMP || ARC_HAS_COH_LLSC
+
+config ARC_HAS_SWAPE
+	bool "Insn: SWAPE (endian-swap)"
+	default y
+	depends on ARC_CPU_REL_4_10
+
+config ARC_HAS_RTSC
+	bool "Insn: RTSC (64-bit r/o cycle counter)"
+	default y
+	depends on ARC_CPU_REL_4_10
+
+endmenu   # "ARC CPU Configuration"
+
+menu "Platform Board Configuration"
+
+source "arch/arc/plat-arcfpga/Kconfig"
+#New platform adds here
+
+config ARC_PLAT_CLK
+	int "Clk speed in Hz"
+	default "80000000"
+
+config LINUX_LINK_BASE
+	hex "Linux Link Address"
+	default "0x80000000"
+	help
+	  ARC700 divides the 32 bit phy address space into two equal halves
+	  -Lower 2G (0 - 0x7FFF_FFFF ) is user virtual, translated by MMU
+	  -Upper 2G (0x8000_0000 onwards) is untranslated, for kernel
+	  Typically Linux kernel is linked at the start of untransalted addr,
+	  hence the default value of 0x8zs.
+	  However some customers have peripherals mapped at this addr, so
+	  Linux needs to be scooted a bit.
+	  If you don't know what the above means, leave this setting alone.
+
+config ARC_PLAT_SDRAM_SIZE
+	hex "SD RAM Size"
+	default "0x10000000"
+	help
+	  Implies the amount of SDRAM/DRAM Linux is going to claim/own.
+	  The actual memory itself could be larger than this number. But for
+	  all software purposes, this is the amt of memory.
+
+endmenu # "Platform Board Configuration"
+
+config ARC_STACK_NONEXEC
+	bool "Make stack non-executable"
+	default n
+	help
+	  To disable the execute permissions of stack/heap of processes
+	  which are enabled by default.
+
+config HZ
+	int "Timer Frequency"
+	default 100
+
+menuconfig ARC_DBG
+	bool "ARC debugging"
+	default y
+
+config ARC_DBG_TLB_PARANOIA
+	bool "Paranoia Checks in Low Level TLB Handlers"
+	depends on ARC_DBG
+	default n
+
+config ARC_DBG_TLB_MISS_COUNT
+	bool "Profile TLB Misses"
+	default n
+	select DEBUG_FS
+	depends on ARC_DBG
+	help
+	  Counts number of I and D TLB Misses and exports them via Debugfs
+	  The counters can be cleared via Debugfs as well
+
+config CMDLINE
+	string "Kernel command line to built-in"
+	default "print-fatal-signals=1"
+	help
+	  The default command line which will be appended to the optional
+	  u-boot provided command line (see below)
+
+config CMDLINE_UBOOT
+	bool "Support U-boot kernel command line passing"
+	default n
+	help
+	  If you are using U-boot (www.denx.de) and wish to pass the kernel
+	  command line from the U-boot environment to the Linux kernel then
+	  switch this option on.
+	  ARC U-boot will setup the cmdline in RAM/flash and set r2 to point
+	  to it. kernel startup code will copy the string into cmdline buffer
+	  and also append CONFIG_CMDLINE.
+
+source "kernel/Kconfig.preempt"
+
+endmenu	 # "ARC Architecture Configuration"
+
+source "mm/Kconfig"
+source "net/Kconfig"
+source "drivers/Kconfig"
+source "fs/Kconfig"
+source "arch/arc/Kconfig.debug"
+source "security/Kconfig"
+source "crypto/Kconfig"
+source "lib/Kconfig"
diff --git a/arch/arc/Kconfig.debug b/arch/arc/Kconfig.debug
new file mode 100644
index 0000000..962c609
--- /dev/null
+++ b/arch/arc/Kconfig.debug
@@ -0,0 +1,34 @@
+menu "Kernel hacking"
+
+source "lib/Kconfig.debug"
+
+config EARLY_PRINTK
+	bool "Early printk" if EMBEDDED
+	default y
+	help
+	  Write kernel log output directly into the VGA buffer or to a serial
+	  port.
+
+	  This is useful for kernel debugging when your machine crashes very
+	  early before the console code is initialized. For normal operation
+	  it is not recommended because it looks ugly and doesn't cooperate
+	  with klogd/syslogd or the X server. You should normally N here,
+	  unless you want to debug such a crash.
+
+config DEBUG_STACKOVERFLOW
+	bool "Check for stack overflows"
+	depends on DEBUG_KERNEL
+	help
+	  This option will cause messages to be printed if free stack space
+	  drops below a certain limit.
+
+config 16KSTACKS
+	bool "Use 16Kb for kernel stacks instead of 8Kb"
+	help
+	  If you say Y here the kernel will use a  16Kb stacksize for the
+	  kernel stack attached to each process/thread. The default is 8K.
+	  This increases the resident kernel footprint and will cause less
+	  threads to run on the system and also increase the pressure
+	  on the VM subsystem for higher order allocations.
+
+endmenu
diff --git a/arch/arc/Makefile b/arch/arc/Makefile
new file mode 100644
index 0000000..4d52a3b
--- /dev/null
+++ b/arch/arc/Makefile
@@ -0,0 +1,115 @@
+#
+# Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+
+UTS_MACHINE := arc
+
+KBUILD_DEFCONFIG := fpga_defconfig
+
+# For ARC FPGA Platforms
+platform-$(CONFIG_ARC_PLAT_FPGA_LEGACY)	:= arcfpga
+#New platform adds here
+
+PLATFORM := $(platform-y)
+export PLATFORM
+
+cflags-y	+= -Iarch/arc/plat-$(PLATFORM)/include
+cflags-y	+= -mA7 -fno-common -pipe -fno-builtin -D__linux__
+
+atleast_gcc44 :=  $(call cc-ifversion, -gt, 0402, y)
+cflags-$(atleast_gcc44)			+= -fsection-anchors
+
+cflags-$(CONFIG_ARC_HAS_LLSC)		+= -mlock
+cflags-$(CONFIG_ARC_HAS_SWAPE)		+= -mswape
+cflags-$(CONFIG_ARC_HAS_RTSC)		+= -mrtsc
+cflags-$(CONFIG_ARC_DW2_UNWIND)		+= -fasynchronous-unwind-tables
+
+ifndef CONFIG_CC_OPTIMIZE_FOR_SIZE
+# Generic build system uses -O2, we want -O3
+cflags-y  += -O3
+endif
+
+# small data is default for elf32 tool-chain. If not usable, disable it
+# This also allows repurposing GP as scratch reg to gcc reg allocator
+disable_small_data := y
+cflags-$(disable_small_data)		+= -mno-sdata -fcall-used-gp
+
+cflags-$(CONFIG_CPU_BIG_ENDIAN)		+= -mbig-endian
+ldflags-$(CONFIG_CPU_BIG_ENDIAN)	+= -EB
+
+# STAR 9000518362:
+# arc-linux-uclibc-ld (buildroot) or arceb-elf32-ld (EZChip) don't accept
+# --build-id w/o "-marclinux".
+# Default arc-elf32-ld is OK
+ldflags-y				+= -marclinux
+
+ARC_LIBGCC				:= -mA7
+cflags-$(CONFIG_ARC_HAS_HW_MPY)		+= -multcost=16
+
+ifndef CONFIG_ARC_HAS_HW_MPY
+	cflags-y	+= -mno-mpy
+
+# newlib for ARC700 assumes MPY to be always present, which is generally true
+# However, if someone really doesn't want MPY, we need to use the 600 ver
+# which coupled with -mno-mpy will use mpy emulation
+# With gcc 4.4.7, -mno-mpy is enough to make any other related adjustments,
+# e.g. increased cost of MPY. With gcc 4.2.1 this had to be explicitly hinted
+
+	ARC_LIBGCC		:= -marc600
+	ifneq ($(atleast_gcc44),y)
+		cflags-y	+= -multcost=30
+	endif
+endif
+
+LIBGCC	:= $(shell $(CC) $(ARC_LIBGCC) $(cflags-y) --print-libgcc-file-name)
+
+# Modules with short calls might break for calls into builtin-kernel
+KBUILD_CFLAGS_MODULE	+= -mlong-calls
+
+# Finally dump eveything into kernel build system
+KBUILD_CFLAGS	+= $(cflags-y)
+KBUILD_AFLAGS	+= $(KBUILD_CFLAGS)
+LDFLAGS		+= $(ldflags-y)
+
+# Needed for Linker script preprocessing
+KBUILD_CPPFLAGS	+= -Iarch/arc/plat-$(PLATFORM)/include
+
+head-y		:= arch/arc/kernel/head.o
+
+# See arch/arc/Kbuild for content of core part of the kernel
+core-y		+= arch/arc/
+
+# w/o this ifneq, make ARCH=arc clean was crapping out
+ifneq ($(platform-y),)
+core-y		+= arch/arc/plat-$(PLATFORM)/
+endif
+
+libs-y		+= arch/arc/lib/ $(LIBGCC)
+
+#default target for make without any arguements.
+KBUILD_IMAGE := bootpImage
+
+all:	$(KBUILD_IMAGE)
+boot	:= arch/arc/boot
+
+bootpImage: vmlinux
+
+uImage: vmlinux
+	$(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+
+archclean:
+	$(Q)$(MAKE) $(clean)=$(boot)
+
+# Hacks to enable final link due to absence of link-time branch relexation
+# and gcc choosing optimal(shorter) branches at -O3
+#
+# vineetg Feb 2010: -mlong-calls switched off for overall kernel build
+# However lib/decompress_inflate.o (.init.text) calls
+# zlib_inflate_workspacesize (.text) causing relocation errors.
+# Thus forcing all exten calls in this file to be long calls
+export CFLAGS_decompress_inflate.o = -mmedium-calls
+export CFLAGS_initramfs.o = -mmedium-calls
diff --git a/arch/arc/boot/Makefile b/arch/arc/boot/Makefile
new file mode 100644
index 0000000..4ff734d
--- /dev/null
+++ b/arch/arc/boot/Makefile
@@ -0,0 +1,27 @@
+targets := vmlinux.bin vmlinux.bin.gz uImage
+
+# uImage build relies on mkimage being availble on your host for ARC target
+# You will need to build u-boot for ARC, rename mkimage to arc-elf32-mkimage
+# and make sure it's reacable from your PATH
+MKIMAGE := $(srctree)/scripts/mkuboot.sh
+
+OBJCOPYFLAGS= -O binary -R .note -R .note.gnu.build-id -R .comment -S
+
+LINUX_START_TEXT = $$(readelf -h vmlinux | \
+			grep "Entry point address" | grep -o 0x.*)
+
+quiet_cmd_uimage = UIMAGE $@
+	cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A arc -O linux -T kernel \
+			-C gzip -a $(CONFIG_LINUX_LINK_BASE) \
+			-e $(LINUX_START_TEXT) -d $< $@
+
+$(obj)/vmlinux.bin: vmlinux FORCE
+	$(call if_changed,objcopy)
+
+$(obj)/vmlinux.bin.gz: $(obj)/vmlinux.bin FORCE
+	$(call if_changed,gzip)
+
+$(obj)/uImage: $(obj)/vmlinux.bin.gz FORCE
+	$(call if_changed,uimage)
+
+PHONY += FORCE
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index d6c037a..148dfcf 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -33,6 +33,7 @@ generic-y += mman.h
 generic-y += msgbuf.h
 generic-y += param.h
 generic-y += parport.h
+generic-y += pci.h
 generic-y += percpu.h
 generic-y += poll.h
 generic-y += posix_types.h
diff --git a/arch/arc/include/asm/vmlinux.lds.h b/arch/arc/include/asm/vmlinux.lds.h
new file mode 100644
index 0000000..12c8e42
--- /dev/null
+++ b/arch/arc/include/asm/vmlinux.lds.h
@@ -0,0 +1,12 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_VMLINUX_LDS_H__
+#define __ASM_VMLINUX_LDS_H__
+
+#endif
diff --git a/arch/arc/kernel/Makefile b/arch/arc/kernel/Makefile
new file mode 100644
index 0000000..47f6b33
--- /dev/null
+++ b/arch/arc/kernel/Makefile
@@ -0,0 +1,16 @@
+#
+# Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+
+obj-y	:= arcksyms.o setup.o irq.o time.o reset.o ptrace.o entry.o process.o \
+	   signal.o traps.o sys.o troubleshoot.o stacktrace.o
+
+obj-$(CONFIG_ARC_FPU_SAVE_RESTORE)	+= fpu.o
+CFLAGS_fpu.o   += -mdpfp
+
+obj-y += ctx_sw_asm.o
+
+extra-y := vmlinux.lds head.o
diff --git a/arch/arc/kernel/arcksyms.c b/arch/arc/kernel/arcksyms.c
new file mode 100644
index 0000000..4d9e777
--- /dev/null
+++ b/arch/arc/kernel/arcksyms.c
@@ -0,0 +1,56 @@
+/*
+ * arcksyms.c - Exporting symbols not exportable from their own sources
+ *
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+
+/* libgcc functions, not part of kernel sources */
+extern void __ashldi3(void);
+extern void __ashrdi3(void);
+extern void __divsi3(void);
+extern void __divsf3(void);
+extern void __lshrdi3(void);
+extern void __modsi3(void);
+extern void __muldi3(void);
+extern void __ucmpdi2(void);
+extern void __udivsi3(void);
+extern void __umodsi3(void);
+extern void __cmpdi2(void);
+extern void __fixunsdfsi(void);
+extern void __muldf3(void);
+extern void __divdf3(void);
+extern void __floatunsidf(void);
+extern void __floatunsisf(void);
+
+EXPORT_SYMBOL(__ashldi3);
+EXPORT_SYMBOL(__ashrdi3);
+EXPORT_SYMBOL(__divsi3);
+EXPORT_SYMBOL(__divsf3);
+EXPORT_SYMBOL(__lshrdi3);
+EXPORT_SYMBOL(__modsi3);
+EXPORT_SYMBOL(__muldi3);
+EXPORT_SYMBOL(__ucmpdi2);
+EXPORT_SYMBOL(__udivsi3);
+EXPORT_SYMBOL(__umodsi3);
+EXPORT_SYMBOL(__cmpdi2);
+EXPORT_SYMBOL(__fixunsdfsi);
+EXPORT_SYMBOL(__muldf3);
+EXPORT_SYMBOL(__divdf3);
+EXPORT_SYMBOL(__floatunsidf);
+EXPORT_SYMBOL(__floatunsisf);
+
+/* ARC optimised assembler routines */
+EXPORT_SYMBOL(memset);
+EXPORT_SYMBOL(memcpy);
+EXPORT_SYMBOL(memcmp);
+EXPORT_SYMBOL(strchr);
+EXPORT_SYMBOL(strcpy);
+EXPORT_SYMBOL(strcmp);
+EXPORT_SYMBOL(strlen);
diff --git a/arch/arc/kernel/asm-offsets.c b/arch/arc/kernel/asm-offsets.c
new file mode 100644
index 0000000..7f3f611
--- /dev/null
+++ b/arch/arc/kernel/asm-offsets.c
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <asm/hardirq.h>
+#include <linux/thread_info.h>
+#include <asm/page.h>
+#include <linux/kbuild.h>
+
+int main(void)
+{
+	DEFINE(TASK_THREAD, offsetof(struct task_struct, thread));
+	DEFINE(TASK_THREAD_INFO, offsetof(struct task_struct, stack));
+
+	BLANK();
+
+	DEFINE(THREAD_KSP, offsetof(struct thread_struct, ksp));
+	DEFINE(THREAD_CALLEE_REG, offsetof(struct thread_struct, callee_reg));
+	DEFINE(THREAD_FAULT_ADDR,
+	       offsetof(struct thread_struct, fault_address));
+
+	BLANK();
+
+	DEFINE(THREAD_INFO_FLAGS, offsetof(struct thread_info, flags));
+	DEFINE(THREAD_INFO_PREEMPT_COUNT,
+	       offsetof(struct thread_info, preempt_count));
+
+	BLANK();
+
+	DEFINE(TASK_ACT_MM, offsetof(struct task_struct, active_mm));
+	DEFINE(TASK_TGID, offsetof(struct task_struct, tgid));
+
+	DEFINE(MM_CTXT, offsetof(struct mm_struct, context));
+	DEFINE(MM_PGD, offsetof(struct mm_struct, pgd));
+
+	DEFINE(MM_CTXT_ASID, offsetof(mm_context_t, asid));
+
+	return 0;
+}
diff --git a/arch/arc/kernel/vmlinux.lds.S b/arch/arc/kernel/vmlinux.lds.S
new file mode 100644
index 0000000..67c35bd
--- /dev/null
+++ b/arch/arc/kernel/vmlinux.lds.S
@@ -0,0 +1,117 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm-generic/vmlinux.lds.h>
+#include <asm/vmlinux.lds.h>
+#include <asm/cache.h>
+#include <asm/page.h>
+#include <asm/thread_info.h>
+#include <plat/memmap.h>
+
+OUTPUT_ARCH(arc)
+ENTRY(_stext)
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+jiffies = jiffies_64 + 4;
+#else
+jiffies = jiffies_64;
+#endif
+
+SECTIONS
+{
+	. = CONFIG_LINUX_LINK_BASE;
+
+	_int_vec_base_lds = .;
+	.vector : {
+		*(.vector)
+		. = ALIGN(PAGE_SIZE);
+	}
+
+	/*
+	 * The reason for having a seperate subsection .init.ramfs is to
+	 * prevent objump from including it in kernel dumps
+	 *
+	 * Reason for having .init.ramfs above .init is to make sure that the
+	 * binary blob is tucked away to one side, reducing the displacement
+	 * between .init.text and .text, avoiding any possible relocation
+	 * errors because of calls from .init.text to .text
+	 * Yes such calls do exist. e.g.
+	 *	decompress_inflate.c:gunzip( ) -> zlib_inflate_workspace( )
+	 */
+
+	__init_begin = .;
+
+	.init.ramfs : { INIT_RAM_FS }
+
+	. = ALIGN(PAGE_SIZE);
+	_stext = .;
+
+	HEAD_TEXT_SECTION
+	INIT_TEXT_SECTION(L1_CACHE_BYTES)
+
+	/* INIT_DATA_SECTION open-coded: special INIT_RAM_FS handling */
+	.init.data : {
+		INIT_DATA
+		INIT_SETUP(L1_CACHE_BYTES)
+		INIT_CALLS
+		CON_INITCALL
+		SECURITY_INITCALL
+	}
+
+	PERCPU_SECTION(L1_CACHE_BYTES)
+
+	/*
+	 * .exit.text is discard at runtime, not link time, to deal with
+	 * references from .debug_frame
+	 * It will be init freed, being inside [__init_start : __init_end]
+	 */
+	.exit.text : { EXIT_TEXT }
+	.exit.data : { EXIT_DATA }
+
+	. = ALIGN(PAGE_SIZE);
+	__init_end = .;
+
+	.text : {
+		_text = .;
+		TEXT_TEXT
+		SCHED_TEXT
+		LOCK_TEXT
+		KPROBES_TEXT
+		*(.fixup)
+		*(.gnu.warning)
+	}
+	EXCEPTION_TABLE(L1_CACHE_BYTES)
+	_etext = .;
+
+	_sdata = .;
+	RO_DATA_SECTION(PAGE_SIZE)
+
+	/*
+	 * 1. this is .data essentially
+	 * 2. THREAD_SIZE for init.task, must be kernel-stk sz aligned
+	 */
+	RW_DATA_SECTION(L1_CACHE_BYTES, PAGE_SIZE, THREAD_SIZE)
+
+	_edata = .;
+
+	BSS_SECTION(0, 0, 0)
+
+	NOTES
+
+	. = ALIGN(PAGE_SIZE);
+	_end = . ;
+
+	STABS_DEBUG
+	DWARF_DEBUG
+	DISCARDS
+
+	.arcextmap 0 : {
+		*(.gnu.linkonce.arcextmap.*)
+		*(.arcextmap.*)
+	}
+}
diff --git a/arch/arc/lib/Makefile b/arch/arc/lib/Makefile
new file mode 100644
index 0000000..f4eaaf4
--- /dev/null
+++ b/arch/arc/lib/Makefile
@@ -0,0 +1,9 @@
+#
+# Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+
+lib-y	:= strchr-700.o strcmp.o strcpy-700.o strlen.o \
+	   memcmp.o memcpy-700.o memset.o
diff --git a/arch/arc/mm/Makefile b/arch/arc/mm/Makefile
new file mode 100644
index 0000000..303f567
--- /dev/null
+++ b/arch/arc/mm/Makefile
@@ -0,0 +1,10 @@
+#
+# Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+
+obj-y	:= extable.o ioremap.o dma.o fault.o init.o mmap.o \
+	   tlb.o tlbex.o cache_arc700.o
diff --git a/arch/arc/plat-arcfpga/Kconfig b/arch/arc/plat-arcfpga/Kconfig
new file mode 100644
index 0000000..3b41a0e
--- /dev/null
+++ b/arch/arc/plat-arcfpga/Kconfig
@@ -0,0 +1,33 @@
+#
+# Copyright (C) 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+
+if ARC_PLAT_FPGA_LEGACY
+
+choice
+	prompt "FPGA Board"
+
+config ARC_BOARD_ANGEL4
+	bool "ARC Angel4"
+	help
+	  ARC Angel4 FPGA Ref Platform (Xilinx Virtex Based)
+
+config ARC_BOARD_ML509
+	bool "ML509"
+	help
+	  ARC ML509 FPGA Ref Platform (Xilinx Virtex-5 Based)
+
+endchoice
+
+config ARC_SERIAL_BAUD
+	int "UART Baud rate"
+	default "115200"
+	depends on SERIAL_ARC
+	help
+	  Baud rate for the ARC UART
+
+endif
diff --git a/arch/arc/plat-arcfpga/Makefile b/arch/arc/plat-arcfpga/Makefile
new file mode 100644
index 0000000..385eb9d
--- /dev/null
+++ b/arch/arc/plat-arcfpga/Makefile
@@ -0,0 +1,9 @@
+#
+# Copyright (C) 2011-2012 Synopsys, Inc. (www.synopsys.com)
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+
+obj-y := platform.o irq.o
-- 
1.7.4.1

