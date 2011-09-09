Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab1IIBMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:12:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3886 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765Ab1IIBLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:11:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6463"; a="116864896"
Message-Id: <20110909010917.855418094@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Thu, 08 Sep 2011 20:09:20 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Linas Vepstas <linas@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [patch v3 33/36] Hexagon: Add configuration and makefiles for the Hexagon architecture.
References: <20110909010847.294039464@codeaurora.org>
Content-Disposition: inline; filename=linux-build.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed CONFIG_ARCH_HAS_KMAP

Signed-off-by: Linas Vepstas <linas@codeaurora.org>
Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>

---
 arch/hexagon/Kconfig              |  218 ++++++++++++++++++++++++++++++++++++++
 arch/hexagon/Makefile             |   59 ++++++++++
 arch/hexagon/kernel/Makefile      |   19 +++
 arch/hexagon/kernel/asm-offsets.c |  104 ++++++++++++++++++
 arch/hexagon/kernel/vmlinux.lds.S |   93 ++++++++++++++++
 arch/hexagon/lib/Makefile         |    4 
 arch/hexagon/mm/Makefile          |    7 +
 7 files changed, 504 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/Kconfig
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/Kconfig	2011-09-07 13:01:00.740692085 -0500
@@ -0,0 +1,218 @@
+# Hexagon configuration
+comment "Linux Kernel Configuration for Hexagon"
+
+config HEXAGON
+	def_bool y
+	select HAVE_OPROFILE
+	select USE_GENERIC_SMP_HELPERS if SMP
+	# Other pending projects/to-do items.
+	# select HAVE_REGS_AND_STACK_ACCESS_API
+	# select HAVE_HW_BREAKPOINT if PERF_EVENTS
+	# select ARCH_HAS_CPU_IDLE_WAIT
+	# select ARCH_WANT_OPTIONAL_GPIOLIB
+	# select ARCH_REQUIRE_GPIOLIB
+	# select HAVE_CLK
+	# select IRQ_PER_CPU
+	select HAVE_IRQ_WORK
+	# select GENERIC_PENDING_IRQ if SMP
+	select GENERIC_ATOMIC64
+	select HAVE_PERF_EVENTS
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_HARDIRQS_NO__DO_IRQ
+	select GENERIC_HARDIRQS_NO_DEPRECATED
+	# GENERIC_ALLOCATOR is used by dma_alloc_coherent()
+	select GENERIC_ALLOCATOR
+	select HAVE_ARCH_KGDB
+	select NO_IOPORT
+	# mostly generic routines, with some accelerated ones
+	---help---
+	  Qualcomm Hexagon is a processor architecture designed for high
+	  performance and low power across a wide variety of applications.
+
+config HEXAGON_ARCH_V1
+	bool
+
+config HEXAGON_ARCH_V2
+	bool
+
+config HEXAGON_ARCH_V3
+	bool
+
+config HEXAGON_ARCH_V4
+	bool
+
+config FRAME_POINTER
+	def_bool y
+
+config LOCKDEP_SUPPORT
+	def_bool y
+
+config PCI
+	def_bool n
+
+config EARLY_PRINTK
+	def_bool y
+
+config KTIME_SCALAR
+	def_bool y
+
+config MMU
+	def_bool y
+
+config TRACE_IRQFLAGS_SUPPORT
+	def_bool y
+
+config GENERIC_CSUM
+	def_bool y
+
+#
+# Use the generic interrupt handling code in kernel/irq/:
+#
+config GENERIC_IRQ_PROBE
+	def_bool y
+
+config GENERIC_IOMAP
+	def_bool y
+
+#config ZONE_DMA
+#	bool
+#	default y
+
+config HAS_DMA
+	bool
+	select HAVE_DMA_ATTRS
+	default y
+
+config NEED_SG_DMA_LENGTH
+	def_bool y
+
+config RWSEM_GENERIC_SPINLOCK
+	def_bool n
+
+config RWSEM_XCHGADD_ALGORITHM
+	def_bool y
+
+config GENERIC_FIND_NEXT_BIT
+	def_bool y
+
+config GENERIC_HWEIGHT
+	def_bool y
+
+config GENERIC_TIME
+	def_bool y
+
+config GENERIC_CLOCKEVENTS
+	def_bool y
+
+config GENERIC_CLOCKEVENTS_BROADCAST
+	def_bool y
+
+config STACKTRACE_SUPPORT
+	def_bool y
+	select STACKTRACE
+
+config GENERIC_BUG
+	def_bool y
+	depends on BUG
+
+config BUG
+	def_bool y
+
+menu "Machine selection"
+
+choice
+	prompt "System type"
+	default HEXAGON_ARCH_V2
+
+config HEXAGON_COMET
+	bool "Comet Board"
+	select HEXAGON_ARCH_V2
+	---help---
+	  Support for the Comet platform.
+
+endchoice
+
+config HEXAGON_VM
+	def_bool y
+
+config CMDLINE
+	string "Default kernel command string"
+	default ""
+	help
+	  On some platforms, there is currently no way for the boot loader
+	  to pass arguments to the kernel. For these, you should supply some
+	  command-line options at build time by entering them here.  At a
+	  minimum, you should specify the memory size and the root device
+	  (e.g., mem=64M root=/dev/nfs).
+
+config HEXAGON_ANGEL_TRAPS
+	bool "Use Angel Traps"
+	default n
+	---help---
+	  Enable angel debug traps (for printk's).
+
+config SMP
+	bool "Multi-Processing support"
+	---help---
+	  Enables SMP support in the kernel.  If unsure, say "Y"
+
+config NR_CPUS
+	int "Maximum number of CPUs" if SMP
+	range 2 6 if SMP
+	default "1" if !SMP
+	default "6" if SMP
+	---help---
+	  This allows you to specify the maximum number of CPUs which this
+	  kernel will support.  The maximum supported value is 6 and the
+	  minimum value which makes sense is 2.
+
+	  This is purely to save memory - each supported CPU adds
+	  approximately eight kilobytes to the kernel image.
+
+choice
+	prompt "Kernel page size"
+	default PAGE_SIZE_4KB
+	---help---
+	  Changes the default page size; use with caution.
+
+config PAGE_SIZE_4KB
+	bool "4KB"
+
+config PAGE_SIZE_16KB
+	bool "16KB"
+
+config PAGE_SIZE_64KB
+	bool "64KB"
+
+config PAGE_SIZE_256KB
+	bool "256KB"
+
+endchoice
+
+source "mm/Kconfig"
+
+source "kernel/Kconfig.hz"
+source "kernel/time/Kconfig"
+
+config GENERIC_GPIO
+	bool "Generic GPIO support"
+	default n
+
+endmenu
+
+source "init/Kconfig"
+source "drivers/Kconfig"
+source "fs/Kconfig"
+
+menu "Executable File Formats"
+source "fs/Kconfig.binfmt"
+endmenu
+
+source "net/Kconfig"
+source "security/Kconfig"
+source "crypto/Kconfig"
+source "lib/Kconfig"
+
+menu "Kernel hacking"
+source "lib/Kconfig.debug"
+endmenu
Index: linux-hexagon-kernel/arch/hexagon/kernel/asm-offsets.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/asm-offsets.c	2011-09-03 20:14:59.834981699 -0500
@@ -0,0 +1,104 @@
+/*
+ * Copyright (C) 1996 David S. Miller
+ * Copyright (C) 1997, 1998, 1999, 2000, 2001, 2002, 2003 Ralf Baechle
+ * Copyright (C) 1999, 2000 Silicon Graphics, Inc.
+ * Kevin Kissell, kevink@mips.com and Carsten Langgaard, carstenl@mips.com
+ * Copyright (C) 2000 MIPS Technologies, Inc.
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/compat.h>
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/kbuild.h>
+#include <asm/ptrace.h>
+#include <asm/processor.h>
+
+/*  This file is used to produce asm/linkerscript constants from header
+    files typically used in c.  Specifically, it generates asm-offsets.h  */
+
+int main(void)
+{
+	COMMENT("This is a comment.");
+	/*  might get these from somewhere else.  */
+	DEFINE(_PAGE_SIZE, PAGE_SIZE);
+	DEFINE(_PAGE_SHIFT, PAGE_SHIFT);
+	BLANK();
+
+	COMMENT("Hexagon pt_regs definitions");
+	OFFSET(_PT_SYSCALL_NR, pt_regs, syscall_nr);
+	OFFSET(_PT_UGPGP, pt_regs, ugpgp);
+	OFFSET(_PT_R3130, pt_regs, r3130);
+	OFFSET(_PT_R2928, pt_regs, r2928);
+	OFFSET(_PT_R2726, pt_regs, r2726);
+	OFFSET(_PT_R2524, pt_regs, r2524);
+	OFFSET(_PT_R2322, pt_regs, r2322);
+	OFFSET(_PT_R2120, pt_regs, r2120);
+	OFFSET(_PT_R1918, pt_regs, r1918);
+	OFFSET(_PT_R1716, pt_regs, r1716);
+	OFFSET(_PT_R1514, pt_regs, r1514);
+	OFFSET(_PT_R1312, pt_regs, r1312);
+	OFFSET(_PT_R1110, pt_regs, r1110);
+	OFFSET(_PT_R0908, pt_regs, r0908);
+	OFFSET(_PT_R0706, pt_regs, r0706);
+	OFFSET(_PT_R0504, pt_regs, r0504);
+	OFFSET(_PT_R0302, pt_regs, r0302);
+	OFFSET(_PT_R0100, pt_regs, r0100);
+	OFFSET(_PT_LC0SA0, pt_regs, lc0sa0);
+	OFFSET(_PT_LC1SA1, pt_regs, lc1sa1);
+	OFFSET(_PT_M1M0, pt_regs, m1m0);
+	OFFSET(_PT_PREDSUSR, pt_regs, predsusr);
+	OFFSET(_PT_EVREC, pt_regs, hvmer);
+	OFFSET(_PT_ER_VMEL, pt_regs, hvmer.vmel);
+	OFFSET(_PT_ER_VMEST, pt_regs, hvmer.vmest);
+	OFFSET(_PT_ER_VMPSP, pt_regs, hvmer.vmpsp);
+	OFFSET(_PT_ER_VMBADVA, pt_regs, hvmer.vmbadva);
+	DEFINE(_PT_REGS_SIZE, sizeof(struct pt_regs));
+	BLANK();
+
+	COMMENT("Hexagon thread_info definitions");
+	OFFSET(_THREAD_INFO_FLAGS, thread_info, flags);
+	OFFSET(_THREAD_INFO_PT_REGS, thread_info, regs);
+	OFFSET(_THREAD_INFO_SP, thread_info, sp);
+	DEFINE(_THREAD_SIZE, THREAD_SIZE);
+	BLANK();
+
+	COMMENT("Hexagon hexagon_switch_stack definitions");
+	OFFSET(_SWITCH_R1716, hexagon_switch_stack, r1716);
+	OFFSET(_SWITCH_R1918, hexagon_switch_stack, r1918);
+	OFFSET(_SWITCH_R2120, hexagon_switch_stack, r2120);
+	OFFSET(_SWITCH_R2322, hexagon_switch_stack, r2322);
+
+	OFFSET(_SWITCH_R2524, hexagon_switch_stack, r2524);
+	OFFSET(_SWITCH_R2726, hexagon_switch_stack, r2726);
+	OFFSET(_SWITCH_FP, hexagon_switch_stack, fp);
+	OFFSET(_SWITCH_LR, hexagon_switch_stack, lr);
+	DEFINE(_SWITCH_STACK_SIZE, sizeof(struct hexagon_switch_stack));
+	BLANK();
+
+	COMMENT("Hexagon task_struct definitions");
+	OFFSET(_TASK_THREAD_INFO, task_struct, stack);
+	OFFSET(_TASK_STRUCT_THREAD, task_struct, thread);
+
+	COMMENT("Hexagon thread_struct definitions");
+	OFFSET(_THREAD_STRUCT_SWITCH_SP, thread_struct, switch_sp);
+
+	return 0;
+}
Index: linux-hexagon-kernel/arch/hexagon/kernel/vmlinux.lds.S
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/vmlinux.lds.S	2011-09-07 13:00:31.180647169 -0500
@@ -0,0 +1,93 @@
+/*
+ * Linker script for Hexagon kernel
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#define LOAD_OFFSET PAGE_OFFSET
+
+#include <asm-generic/vmlinux.lds.h>
+#include <asm/asm-offsets.h>	/*  Most of the kernel defines are here  */
+#include <asm/mem-layout.h>	/*  except for page_offset  */
+#include <asm/cache.h>		/*  and now we're pulling cache line size  */
+OUTPUT_ARCH(hexagon)
+ENTRY(stext)
+
+jiffies = jiffies_64;
+
+/*
+See asm-generic/vmlinux.lds.h for expansion of some of these macros.
+See asm-generic/sections.h for seemingly required labels.
+*/
+
+#define PAGE_SIZE _PAGE_SIZE
+
+/*  This LOAD_OFFSET is temporary for debugging on the simulator; it may change
+    for hypervisor pseudo-physical memory.  */
+
+
+SECTIONS
+{
+	. = PAGE_OFFSET + LOAD_ADDRESS;
+
+	__init_begin = .;
+	HEAD_TEXT_SECTION
+	INIT_TEXT_SECTION(PAGE_SIZE)
+	PERCPU_SECTION(L1_CACHE_BYTES)
+	__init_end = .;
+
+        . = ALIGN(_PAGE_SIZE);
+	_stext = .;
+	.text : AT(ADDR(.text) - LOAD_OFFSET) {
+		_text = .;
+		TEXT_TEXT
+		SCHED_TEXT
+		LOCK_TEXT
+		KPROBES_TEXT
+		*(.fixup)
+	}
+	_etext = .;
+
+	INIT_DATA_SECTION(PAGE_SIZE)
+
+	_sdata = .;
+		RW_DATA_SECTION(32,PAGE_SIZE,PAGE_SIZE)
+		RO_DATA_SECTION(PAGE_SIZE)
+	_edata = .;
+
+	EXCEPTION_TABLE(16)
+	NOTES
+
+	BSS_SECTION(_PAGE_SIZE, _PAGE_SIZE, _PAGE_SIZE)
+
+	_end = .;
+
+	/DISCARD/ : {
+		EXIT_TEXT
+		EXIT_DATA
+		EXIT_CALL
+	}
+
+	STABS_DEBUG
+	DWARF_DEBUG
+
+}
+
+
+
+
+
Index: linux-hexagon-kernel/arch/hexagon/lib/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/lib/Makefile	2011-09-03 20:14:59.834981699 -0500
@@ -0,0 +1,4 @@
+#
+# Makefile for hexagon-specific library files.
+#
+obj-y = checksum.o io.o memcpy.o memset.o
Index: linux-hexagon-kernel/arch/hexagon/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/Makefile	2011-09-07 13:00:30.850646667 -0500
@@ -0,0 +1,59 @@
+#  Makefile for the Hexagon arch
+
+KBUILD_DEFCONFIG = comet_defconfig
+
+# Do not use GP-relative jumps
+KBUILD_CFLAGS += -G0
+LDFLAGS_vmlinux += -G0
+
+# Do not use single-byte enums; these will overflow.
+KBUILD_CFLAGS += -fno-short-enums
+
+# Modules must use either long-calls, or use pic/plt.
+# Use long-calls for now, it's easier.  And faster.
+# CFLAGS_MODULE += -fPIC
+# LDFLAGS_MODULE += -shared
+CFLAGS_MODULE += -mlong-calls
+
+cflags-$(CONFIG_HEXAGON_ARCH_V1) += $(call cc-option,-mv1)
+cflags-$(CONFIG_HEXAGON_ARCH_V2) += $(call cc-option,-mv2)
+cflags-$(CONFIG_HEXAGON_ARCH_V3) += $(call cc-option,-mv3)
+cflags-$(CONFIG_HEXAGON_ARCH_V4) += $(call cc-option,-mv4)
+
+aflags-$(CONFIG_HEXAGON_ARCH_V1) += $(call cc-option,-mv1)
+aflags-$(CONFIG_HEXAGON_ARCH_V2) += $(call cc-option,-mv2)
+aflags-$(CONFIG_HEXAGON_ARCH_V3) += $(call cc-option,-mv3)
+aflags-$(CONFIG_HEXAGON_ARCH_V4) += $(call cc-option,-mv4)
+
+ldflags-$(CONFIG_HEXAGON_ARCH_V1) += $(call cc-option,-mv1)
+ldflags-$(CONFIG_HEXAGON_ARCH_V2) += $(call cc-option,-mv2)
+ldflags-$(CONFIG_HEXAGON_ARCH_V3) += $(call cc-option,-mv3)
+ldflags-$(CONFIG_HEXAGON_ARCH_V4) += $(call cc-option,-mv4)
+
+KBUILD_CFLAGS += $(cflags-y)
+KBUILD_AFLAGS += $(aflags-y)
+
+#  no KBUILD_LDFLAGS?
+LDFLAGS += $(ldflags-y)
+
+# Thread-info register will be r19.  This value is not configureable;
+# it is hard-coded in several files.
+TIR_NAME := r19
+KBUILD_CFLAGS += -ffixed-$(TIR_NAME) -DTHREADINFO_REG=$(TIR_NAME) -D__linux__
+KBUILD_AFLAGS += -DTHREADINFO_REG=$(TIR_NAME)
+
+LIBGCC := $(shell $(CC) $(KBUILD_CFLAGS) -print-libgcc-file-name)
+libs-y += $(LIBGCC)
+
+head-y := arch/hexagon/kernel/head.o \
+	arch/hexagon/kernel/init_task.o
+
+core-y += arch/hexagon/kernel/ \
+	arch/hexagon/mm/ \
+	arch/hexagon/lib/
+
+#	arch/hexagon/platform/common/
+#
+#core-$(CONFIG_HEXAGON_COMET)		+= arch/hexagon/platform/comet/
+#machine-$(CONFIG_HEXAGON_COMET)		:= comet
+
Index: linux-hexagon-kernel/arch/hexagon/mm/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/mm/Makefile	2011-09-07 13:00:31.200647199 -0500
@@ -0,0 +1,7 @@
+#
+# Makefile for Hexagon memory management subsystem
+#
+
+obj-y := init.o pgalloc.o ioremap.o uaccess.o vm_fault.o cache.o
+obj-y += copy_to_user.o copy_from_user.o strnlen_user.o vm_tlb.o
+
Index: linux-hexagon-kernel/arch/hexagon/kernel/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/kernel/Makefile	2011-09-07 13:00:31.030646941 -0500
@@ -0,0 +1,19 @@
+extra-y := head.o vmlinux.lds init_task.o
+
+obj-$(CONFIG_SMP) += smp.o topology.o
+
+obj-y += irq.o setup.o irq_cpu.o traps.o syscalltab.o signal.o time.o
+obj-y += process.o syscall.o trampoline.o reset.o ptrace.o
+obj-y += vdso.o
+
+obj-$(CONFIG_KGDB)    += kgdb.o
+obj-$(CONFIG_MODULES) += module.o hexagon_ksyms.o
+
+# Modules required to work with the Hexagon Virtual Machine
+obj-y += vm_entry.o vm_events.o vm_switch.o vm_ops.o vm_init_segtable.o
+obj-y += vm_vectors.o
+
+obj-$(CONFIG_HAS_DMA) += dma.o
+
+obj-$(CONFIG_STACKTRACE) += stacktrace.o
+

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

