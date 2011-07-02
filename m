Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1GBVQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 17:16:33 -0400
Received: from mail.southpole.se ([193.12.106.18]:45877 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab1GBVQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 17:16:13 -0400
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Jonas Bonn <jonas@southpole.se>
Subject: [PATCH v2 05/19] OpenRISC: Build infrastructure
Date: Sat,  2 Jul 2011 23:15:38 +0200
Message-Id: <1309641352-18714-6-git-send-email-jonas@southpole.se>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309641352-18714-1-git-send-email-jonas@southpole.se>
References: <1309641352-18714-1-git-send-email-jonas@southpole.se>
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jonas Bonn <jonas@southpole.se>
---
 arch/openrisc/Kconfig                   |  207 +++++++++++++++++++++++++++++++
 arch/openrisc/Makefile                  |   66 ++++++++++
 arch/openrisc/boot/Makefile             |   15 +++
 arch/openrisc/configs/or1ksim_defconfig |   67 ++++++++++
 arch/openrisc/include/asm/Kbuild        |   64 ++++++++++
 arch/openrisc/kernel/Makefile           |   14 ++
 arch/openrisc/kernel/vmlinux.lds.S      |  115 +++++++++++++++++
 arch/openrisc/lib/Makefile              |    5 +
 arch/openrisc/mm/Makefile               |    5 +
 9 files changed, 558 insertions(+), 0 deletions(-)
 create mode 100644 arch/openrisc/Kconfig
 create mode 100644 arch/openrisc/Makefile
 create mode 100644 arch/openrisc/boot/Makefile
 create mode 100644 arch/openrisc/configs/or1ksim_defconfig
 create mode 100644 arch/openrisc/include/asm/Kbuild
 create mode 100644 arch/openrisc/kernel/Makefile
 create mode 100644 arch/openrisc/kernel/vmlinux.lds.S
 create mode 100644 arch/openrisc/lib/Makefile
 create mode 100644 arch/openrisc/mm/Makefile

diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
new file mode 100644
index 0000000..4558baf
--- /dev/null
+++ b/arch/openrisc/Kconfig
@@ -0,0 +1,207 @@
+#
+# For a description of the syntax of this configuration file,
+# see Documentation/kbuild/config-language.txt.
+#
+
+config OPENRISC
+	def_bool y
+	select OF
+	select OF_EARLY_FLATTREE
+	select HAVE_MEMBLOCK
+	select ARCH_WANT_OPTIONAL_GPIOLIB
+        select HAVE_ARCH_TRACEHOOK
+	select HAVE_GENERIC_HARDIRQS
+	select GENERIC_IRQ_CHIP
+	select GENERIC_IRQ_PROBE
+	select GENERIC_IRQ_SHOW
+	select GENERIC_IOMAP
+
+config MMU
+	def_bool y
+
+config WISHBONE_BUS_BIG_ENDIAN
+	def_bool y
+
+config SYMBOL_PREFIX
+        string
+        default ""
+
+config HAVE_DMA_ATTRS
+	def_bool y
+
+config UID16
+	def_bool y
+
+config RWSEM_GENERIC_SPINLOCK
+	def_bool y
+
+config RWSEM_XCHGADD_ALGORITHM
+	def_bool n
+
+config GENERIC_HWEIGHT
+	def_bool y
+
+config GENERIC_IOMAP
+	def_bool y
+
+config NO_IOPORT
+	def_bool y
+
+config GENERIC_GPIO
+	def_bool y
+
+config GENERIC_CLOCKEVENTS
+	def_bool y
+
+config TRACE_IRQFLAGS_SUPPORT
+        def_bool y
+
+# For now, use generic checksum functions
+#These can be reimplemented in assembly later if so inclined
+config GENERIC_CSUM
+        def_bool y
+
+config GENERIC_FIND_NEXT_BIT
+	def_bool y
+
+source "init/Kconfig"
+
+
+menu "Processor type and features"
+
+choice
+	prompt "Subarchitecture"
+	default OR1K_1200
+
+config OR1K_1200
+	bool "OR1200"
+	help
+	  Generic OpenRISC 1200 architecture
+
+endchoice
+
+config OPENRISC_BUILTIN_DTB
+        string "Builtin DTB"
+        default ""
+
+menu "Class II Instructions"
+
+config OPENRISC_HAVE_INST_FF1
+	bool "Have instruction l.ff1"
+	default y
+	help
+	  Select this if your implementation has the Class II instruction l.ff1
+
+config OPENRISC_HAVE_INST_FL1
+	bool "Have instruction l.fl1"
+	default y
+	help
+	  Select this if your implementation has the Class II instruction l.fl1
+
+config OPENRISC_HAVE_INST_MUL
+	bool "Have instruction l.mul for hardware multiply"
+	default y
+	help
+	  Select this if your implementation has a hardware multiply instruction
+
+config OPENRISC_HAVE_INST_DIV
+	bool "Have instruction l.div for hardware divide"
+	default y
+	help
+	  Select this if your implementation has a hardware divide instruction
+endmenu
+
+
+source "kernel/time/Kconfig"
+source kernel/Kconfig.hz
+source kernel/Kconfig.preempt
+source "mm/Kconfig"
+
+config OPENRISC_NO_SPR_SR_DSX
+	bool "use SPR_SR_DSX software emulation" if OR1K_1200
+	default y
+	help
+	  SPR_SR_DSX bit is status register bit indicating whether
+	  the last exception has happened in delay slot.
+
+	  OpenRISC architecture makes it optional to have it implemented
+	  in hardware and the OR1200 does not have it.
+
+	  Say N here if you know that your OpenRISC processor has
+	  SPR_SR_DSX bit implemented. Say Y if you are unsure.
+
+config CMDLINE
+        string "Default kernel command string"
+        default ""
+        help
+          On some architectures there is currently no way for the boot loader
+          to pass arguments to the kernel. For these architectures, you should
+          supply some command-line options at build time by entering them
+          here.
+
+menu "Debugging options"
+
+config DEBUG_STACKOVERFLOW
+	bool "Check for kernel stack overflow"
+	default y
+	help
+	  Make extra checks for space avaliable on stack in some
+          critical functions. This will cause kernel to run a bit slower,
+	  but will catch most of kernel stack overruns and exit gracefuly.
+
+	  Say Y if you are unsure.
+
+config JUMP_UPON_UNHANDLED_EXCEPTION
+	bool "Try to die gracefully"
+	default y
+	help
+	  Now this puts kernel into infinite loop after first oops. Till
+	  your kernel crashes this doesn't have any influence.
+
+	  Say Y if you are unsure.
+
+config OPENRISC_EXCEPTION_DEBUG
+	bool "Print processor state at each exception"
+	default n
+	help
+	  This option will make your kernel unusable for all but kernel
+	  debugging.
+
+	  Say N if you are unsure.
+
+config OPENRISC_ESR_EXCEPTION_BUG_CHECK
+	bool "Check for possible ESR exception bug"
+	default n
+	help
+	  This option enables some checks that might expose some problems
+          in kernel.
+
+	  Say N if you are unsure.
+
+endmenu
+
+endmenu
+
+menu "Executable file formats"
+
+source "fs/Kconfig.binfmt"
+
+endmenu
+
+source "net/Kconfig"
+
+source "drivers/Kconfig"
+
+source "fs/Kconfig"
+
+source "security/Kconfig"
+
+source "crypto/Kconfig"
+
+source "lib/Kconfig"
+
+menu "Kernel hacking"
+
+source "lib/Kconfig.debug"
+
+endmenu
diff --git a/arch/openrisc/Makefile b/arch/openrisc/Makefile
new file mode 100644
index 0000000..9881c45
--- /dev/null
+++ b/arch/openrisc/Makefile
@@ -0,0 +1,66 @@
+# BK Id: %F% %I% %G% %U% %#%
+#
+# This file is included by the global makefile so that you can add your own
+# architecture-specific flags and dependencies. Remember to do have actions
+# for "archclean" and "archdep" for cleaning up and making dependencies for
+# this architecture
+#
+# This file is subject to the terms and conditions of the GNU General Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+# Copyright (C) 1994 by Linus Torvalds
+
+# Changes for or32 by Matjaz Breskvar
+# Based on:
+# arch/i386/Makefile
+
+KBUILD_DEFCONFIG := or1ksim_defconfig
+
+LDFLAGS         :=
+OBJCOPYFLAGS    := -O binary -R .note -R .comment -S
+LDFLAGS_vmlinux :=
+LIBGCC 		 = $(shell $(CC) $(CFLAGS) -print-file-name=libgcc.a)
+
+#KBUILD_CFLAGS		+= -pipe -g -mredzone=0
+KBUILD_CFLAGS		+= -pipe -ffixed-r10
+#KBUILD_CFLAGS		+= -fsigned-char -pipe -ffixed-r10 \
+#		   -ffixed-r16 -ffixed-r17 -ffixed-r18 -ffixed-r19 \
+#		   -ffixed-r20 -ffixed-r21 -ffixed-r22 -ffixed-r23 \
+#		   -ffixed-r24 -ffixed-r25 -ffixed-r26 -ffixed-r27 \
+#		   -ffixed-r28 -ffixed-r29 -ffixed-r30 -ffixed-r31 \
+#                   -Wno-uninitialized
+
+#KBUILD_CFLAGS += $(call cc-option,-mredzone=128)
+#KBUILD_CFLAGS += -mredzone=0
+
+ifeq ($(CONFIG_OPENRISC_HAVE_INST_MUL),y)
+	KBUILD_CFLAGS += $(call cc-option,-mhard-mul)
+else
+	KBUILD_CFLAGS += $(call cc-option,-msoft-mul)
+endif
+
+ifeq ($(CONFIG_OPENRISC_HAVE_INST_DIV),y)
+	KBUILD_CFLAGS += $(call cc-option,-mhard-div)
+else
+	KBUILD_CFLAGS += $(call cc-option,-msoft-div)
+endif
+
+
+
+head-y 		:= arch/openrisc/kernel/head.o arch/openrisc/kernel/init_task.o
+
+
+core-y		+= arch/openrisc/lib/ \
+		   arch/openrisc/kernel/ \
+		   arch/openrisc/mm/
+libs-y		+= $(LIBGCC)
+
+ifneq '$(CONFIG_OPENRISC_BUILTIN_DTB)' '""'
+BUILTIN_DTB := y
+else
+BUILTIN_DTB := n
+endif
+core-$(BUILTIN_DTB) += arch/openrisc/boot/
+
+all: vmlinux
diff --git a/arch/openrisc/boot/Makefile b/arch/openrisc/boot/Makefile
new file mode 100644
index 0000000..98ca185
--- /dev/null
+++ b/arch/openrisc/boot/Makefile
@@ -0,0 +1,15 @@
+
+
+ifneq '$(CONFIG_OPENRISC_BUILTIN_DTB)' '""'
+BUILTIN_DTB := $(patsubst "%",%,$(CONFIG_OPENRISC_BUILTIN_DTB)).dtb.o
+else
+BUILTIN_DTB :=
+endif
+obj-y += $(BUILTIN_DTB)
+
+clean-files := *.dtb.S
+
+#DTC_FLAGS ?= -p 1024
+
+$(obj)/%.dtb: $(src)/dts/%.dts
+	$(call cmd,dtc)
diff --git a/arch/openrisc/configs/or1ksim_defconfig b/arch/openrisc/configs/or1ksim_defconfig
new file mode 100644
index 0000000..af52508
--- /dev/null
+++ b/arch/openrisc/configs/or1ksim_defconfig
@@ -0,0 +1,67 @@
+CONFIG_CROSS_COMPILE="or32-linux-"
+CONFIG_LOG_BUF_SHIFT=14
+CONFIG_BLK_DEV_INITRD=y
+# CONFIG_RD_GZIP is not set
+CONFIG_EXPERT=y
+# CONFIG_SYSCTL_SYSCALL is not set
+# CONFIG_KALLSYMS is not set
+# CONFIG_ELF_CORE is not set
+# CONFIG_EPOLL is not set
+# CONFIG_TIMERFD is not set
+# CONFIG_EVENTFD is not set
+# CONFIG_AIO is not set
+# CONFIG_VM_EVENT_COUNTERS is not set
+# CONFIG_COMPAT_BRK is not set
+CONFIG_SLOB=y
+CONFIG_MODULES=y
+# CONFIG_BLOCK is not set
+CONFIG_OPENRISC_BUILTIN_DTB="or1ksim"
+CONFIG_NO_HZ=y
+CONFIG_HZ_100=y
+CONFIG_NET=y
+CONFIG_PACKET=y
+CONFIG_UNIX=y
+CONFIG_INET=y
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+# CONFIG_INET_LRO is not set
+# CONFIG_INET_DIAG is not set
+CONFIG_TCP_CONG_ADVANCED=y
+# CONFIG_TCP_CONG_BIC is not set
+# CONFIG_TCP_CONG_CUBIC is not set
+# CONFIG_TCP_CONG_WESTWOOD is not set
+# CONFIG_TCP_CONG_HTCP is not set
+# CONFIG_IPV6 is not set
+# CONFIG_WIRELESS is not set
+CONFIG_DEVTMPFS=y
+CONFIG_DEVTMPFS_MOUNT=y
+# CONFIG_PREVENT_FIRMWARE_BUILD is not set
+# CONFIG_FW_LOADER is not set
+CONFIG_PROC_DEVICETREE=y
+CONFIG_NETDEVICES=y
+CONFIG_MICREL_PHY=y
+CONFIG_NET_ETHERNET=y
+CONFIG_ETHOC=y
+# CONFIG_NETDEV_1000 is not set
+# CONFIG_NETDEV_10000 is not set
+# CONFIG_WLAN is not set
+# CONFIG_INPUT is not set
+# CONFIG_SERIO is not set
+# CONFIG_VT is not set
+# CONFIG_LEGACY_PTYS is not set
+# CONFIG_DEVKMEM is not set
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_OF_PLATFORM=y
+# CONFIG_HW_RANDOM is not set
+# CONFIG_HWMON is not set
+# CONFIG_MFD_SUPPORT is not set
+# CONFIG_FB_OC_SHMEM is not set
+# CONFIG_USB_SUPPORT is not set
+# CONFIG_DNOTIFY is not set
+CONFIG_TMPFS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
+# CONFIG_ENABLE_MUST_CHECK is not set
diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
new file mode 100644
index 0000000..11162e6
--- /dev/null
+++ b/arch/openrisc/include/asm/Kbuild
@@ -0,0 +1,64 @@
+include include/asm-generic/Kbuild.asm
+
+header-y += spr_defs.h
+
+generic-y += atomic.h
+generic-y += auxvec.h
+generic-y += bitsperlong.h
+generic-y += bug.h
+generic-y += bugs.h
+generic-y += cacheflush.h
+generic-y += checksum.h
+generic-y += cmpxchg.h
+generic-y += cmpxchg-local.h
+generic-y += cpumask.h
+generic-y += cputime.h
+generic-y += current.h
+generic-y += device.h
+generic-y += div64.h
+generic-y += dma.h
+generic-y += emergency-restart.h
+generic-y += errno.h
+generic-y += fb.h
+generic-y += fcntl.h
+generic-y += ftrace.h
+generic-y += futex.h
+generic-y += hardirq.h
+generic-y += hw_irq.h
+generic-y += ioctl.h
+generic-y += ioctls.h
+generic-y += ipcbuf.h
+generic-y += irq_regs.h
+generic-y += kdebug.h
+generic-y += kmap_types.h
+generic-y += local.h
+generic-y += mman.h
+generic-y += module.h
+generic-y += msgbuf.h
+generic-y += pci.h
+generic-y += percpu.h
+generic-y += poll.h
+generic-y += posix_types.h
+generic-y += resource.h
+generic-y += rmap.h
+generic-y += scatterlist.h
+generic-y += sections.h
+generic-y += segment.h
+generic-y += sembuf.h
+generic-y += setup.h
+generic-y += shmbuf.h
+generic-y += shmparam.h
+generic-y += siginfo.h
+generic-y += signal.h
+generic-y += socket.h
+generic-y += sockios.h
+generic-y += statfs.h
+generic-y += stat.h
+generic-y += string.h
+generic-y += swab.h
+generic-y += termbits.h
+generic-y += termios.h
+generic-y += topology.h
+generic-y += types.h
+generic-y += ucontext.h
+generic-y += user.h
diff --git a/arch/openrisc/kernel/Makefile b/arch/openrisc/kernel/Makefile
new file mode 100644
index 0000000..9a4c270
--- /dev/null
+++ b/arch/openrisc/kernel/Makefile
@@ -0,0 +1,14 @@
+#
+# Makefile for the linux kernel.
+#
+
+extra-y	:= head.o vmlinux.lds init_task.o
+
+obj-y	:= setup.o idle.o or32_ksyms.o process.o dma.o \
+	   traps.o time.o irq.o entry.o ptrace.o signal.o sys_or32.o \
+	   sys_call_table.o
+
+obj-$(CONFIG_MODULES)		+= module.o
+obj-$(CONFIG_OF)		+= prom.o
+
+clean:
diff --git a/arch/openrisc/kernel/vmlinux.lds.S b/arch/openrisc/kernel/vmlinux.lds.S
new file mode 100644
index 0000000..2d69a85
--- /dev/null
+++ b/arch/openrisc/kernel/vmlinux.lds.S
@@ -0,0 +1,115 @@
+/*
+ * OpenRISC vmlinux.lds.S
+ *
+ * Linux architectural port borrowing liberally from similar works of
+ * others.  All original copyrights apply as per the original source
+ * declaration.
+ *
+ * Modifications for the OpenRISC architecture:
+ * Copyright (C) 2003 Matjaz Breskvar <phoenix@bsemi.com>
+ * Copyright (C) 2010-2011 Jonas Bonn <jonas@southpole.se>
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ * ld script for OpenRISC architecture
+ */
+
+/* TODO
+ *		- clean up __offset & stuff
+ *		- change all 8192 aligment to PAGE !!!
+ *		- recheck if all aligments are really needed
+ */
+
+#  define LOAD_OFFSET  PAGE_OFFSET
+#  define LOAD_BASE    PAGE_OFFSET
+
+#include <asm/page.h>
+#include <asm/cache.h>
+#include <asm-generic/vmlinux.lds.h>
+
+OUTPUT_FORMAT("elf32-or32", "elf32-or32", "elf32-or32")
+jiffies = jiffies_64 + 4;
+
+SECTIONS
+{
+        /* Read-only sections, merged into text segment: */
+        . = LOAD_BASE ;
+
+	/* _s_kernel_ro must be page aligned */
+	. = ALIGN(PAGE_SIZE);
+	_s_kernel_ro = .;
+
+        .text                   : AT(ADDR(.text) - LOAD_OFFSET)
+	{
+          _stext = .;
+	  TEXT_TEXT
+	  SCHED_TEXT
+	  LOCK_TEXT
+	  KPROBES_TEXT
+	  IRQENTRY_TEXT
+	  *(.fixup)
+	  *(.text.__*)
+	  _etext = .;
+	}
+	/* TODO: Check if fixup and text.__* are really necessary
+	 * fixup is definitely necessary
+	 */
+
+	_sdata = .;
+
+	/* Page alignment required for RO_DATA_SECTION */
+	RO_DATA_SECTION(PAGE_SIZE)
+	_e_kernel_ro = .;
+
+	/* Whatever comes after _e_kernel_ro had better be page-aligend, too */
+
+	/* 32 here is cacheline size... recheck this */
+	RW_DATA_SECTION(32, PAGE_SIZE, PAGE_SIZE)
+
+        _edata  =  .;
+
+	EXCEPTION_TABLE(4)
+	NOTES
+
+	/* Init code and data */
+	. = ALIGN(PAGE_SIZE);
+	__init_begin = .;
+
+	HEAD_TEXT_SECTION
+
+	/* Page aligned */
+	INIT_TEXT_SECTION(PAGE_SIZE)
+
+	/* Align __setup_start on 16 byte boundary */
+	INIT_DATA_SECTION(16)
+
+	PERCPU_SECTION(L1_CACHE_BYTES)
+
+        __init_end = .;
+
+	. = ALIGN(PAGE_SIZE);
+	.initrd			: AT(ADDR(.initrd) - LOAD_OFFSET)
+	{
+		__initrd_start = .;
+		*(.initrd)
+		__initrd_end = .;
+		FILL (0);
+                . = ALIGN (PAGE_SIZE);
+	}
+
+        __vmlinux_end = .;            /* last address of the physical file */
+
+	BSS_SECTION(0, 0, 0x20)
+
+        _end = .;
+
+	/* Throw in the debugging sections */
+	STABS_DEBUG
+	DWARF_DEBUG
+
+        /* Sections to be discarded -- must be last */
+	DISCARDS
+}
diff --git a/arch/openrisc/lib/Makefile b/arch/openrisc/lib/Makefile
new file mode 100644
index 0000000..966f65d
--- /dev/null
+++ b/arch/openrisc/lib/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for or32 specific library files..
+#
+
+obj-y  = string.o delay.o
diff --git a/arch/openrisc/mm/Makefile b/arch/openrisc/mm/Makefile
new file mode 100644
index 0000000..324ba26
--- /dev/null
+++ b/arch/openrisc/mm/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the linux openrisc-specific parts of the memory manager.
+#
+
+obj-y	:= fault.o tlb.o init.o ioremap.o
-- 
1.7.4.1

