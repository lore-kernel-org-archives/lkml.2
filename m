Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab0FYVMF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 17:12:05 -0400
Received: from king.tilera.com ([72.1.168.226]:44209 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab0FYVLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 17:11:05 -0400
Message-Id: <201006252110.o5PLArqD010774@farm-0002.internal.tilera.com>
To: linux-kernel@vger.kernel.org
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 25 Jun 2010 17:04:17 -0400
Subject: [PATCH] arch/tile: Miscellaneous cleanup changes.
X-OriginalArrivalTime: 25 Jun 2010 21:10:54.0064 (UTC) FILETIME=[E5AF0700:01CB14AA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit is primarily changes caused by reviewing "sparse"
and "checkpatch" output on our sources, so is somewhat noisy, since
things like "printk() -> pr_err()" (or whatever) throughout the
codebase tend to get tedious to read.  Rather than trying to tease
apart precisely which things changed due to which type of code
review, this commit includes various cleanups in the code:

- sparse: Add declarations in headers for globals.
- sparse: Fix __user annotations.
- sparse: Using gfp_t consistently instead of int.
- sparse: removing functions not actually used.
- checkpatch: Clean up printk() warnings by using pr_info(), etc.;
  also avoid partial-line printks except in bootup code.
  - checkpatch: Use exposed structs rather than typedefs.
  - checkpatch: Change some C99 comments to C89 comments.

In addition, a couple of minor other changes are rolled in
to this commit:

- Add support for a "raise" instruction to cause SIGFPE, etc., to be raised.
- Remove some compat code that is unnecessary when we fully eliminate
  some of the deprecated syscalls from the generic syscall ABI.
- Update the tile_defconfig to reflect current config contents.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/configs/tile_defconfig       |   15 ++--
 arch/tile/include/arch/abi.h           |   69 +++++++++--------
 arch/tile/include/arch/interrupts_32.h |    2 +-
 arch/tile/include/asm/atomic_32.h      |   17 ++++
 arch/tile/include/asm/compat.h         |   55 +-------------
 arch/tile/include/asm/elf.h            |    6 +-
 arch/tile/include/asm/futex.h          |   17 +++--
 arch/tile/include/asm/page.h           |    9 ++-
 arch/tile/include/asm/pgtable.h        |    9 ++-
 arch/tile/include/asm/pgtable_32.h     |   12 +++
 arch/tile/include/asm/ptrace.h         |    5 +-
 arch/tile/include/asm/sections.h       |    9 ++-
 arch/tile/include/asm/signal.h         |    1 +
 arch/tile/include/asm/spinlock_32.h    |    3 +-
 arch/tile/include/asm/stack.h          |    6 ++
 arch/tile/include/asm/syscalls.h       |   72 +++++++++++++++++-
 arch/tile/include/asm/system.h         |   30 +++++++
 arch/tile/include/asm/thread_info.h    |    8 ++-
 arch/tile/include/asm/traps.h          |   26 ++++++
 arch/tile/include/asm/uaccess.h        |   22 +++---
 arch/tile/include/asm/unistd.h         |    9 +-
 arch/tile/kernel/backtrace.c           |   81 ++++++++-----------
 arch/tile/kernel/compat.c              |   28 ++-----
 arch/tile/kernel/compat_signal.c       |   10 ++-
 arch/tile/kernel/early_printk.c        |    2 +-
 arch/tile/kernel/entry.S               |    4 +-
 arch/tile/kernel/machine_kexec.c       |   38 +++------
 arch/tile/kernel/messaging.c           |    5 +-
 arch/tile/kernel/module.c              |   16 ++--
 arch/tile/kernel/process.c             |  110 ++++++++++++++++----------
 arch/tile/kernel/ptrace.c              |    3 +-
 arch/tile/kernel/reboot.c              |    7 +-
 arch/tile/kernel/setup.c               |  132 ++++++++++++++++++--------------
 arch/tile/kernel/signal.c              |   19 ++---
 arch/tile/kernel/single_step.c         |   75 ++++++++++--------
 arch/tile/kernel/smpboot.c             |   37 +++------
 arch/tile/kernel/stack.c               |   43 +++++-----
 arch/tile/kernel/sys.c                 |   18 ++---
 arch/tile/kernel/time.c                |    7 +-
 arch/tile/kernel/traps.c               |  130 +++++++++++++++++++++++++------
 arch/tile/kernel/vmlinux.lds.S         |    4 +-
 arch/tile/lib/atomic_32.c              |   53 +++++---------
 arch/tile/lib/cpumask.c                |    1 +
 arch/tile/lib/exports.c                |    1 +
 arch/tile/lib/memcpy_tile64.c          |    6 +-
 arch/tile/lib/memmove_32.c             |    2 +-
 arch/tile/lib/memset_32.c              |    3 +-
 arch/tile/lib/spinlock_common.h        |    2 +-
 arch/tile/lib/uaccess.c                |    3 +-
 arch/tile/mm/elf.c                     |    4 +-
 arch/tile/mm/fault.c                   |   64 +++------------
 arch/tile/mm/highmem.c                 |    2 +-
 arch/tile/mm/homecache.c               |   18 +----
 arch/tile/mm/hugetlbpage.c             |    2 +-
 arch/tile/mm/init.c                    |   99 ++++++++++++------------
 arch/tile/mm/pgtable.c                 |   46 +----------
 56 files changed, 798 insertions(+), 679 deletions(-)

diff --git a/arch/tile/configs/tile_defconfig b/arch/tile/configs/tile_defconfig
index 74a5be3..f34c70b 100644
--- a/arch/tile/configs/tile_defconfig
+++ b/arch/tile/configs/tile_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.34
-# Fri May 28 17:51:43 2010
+# Thu Jun  3 13:20:05 2010
 #
 CONFIG_MMU=y
 CONFIG_GENERIC_CSUM=y
@@ -9,16 +9,13 @@ CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
 CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_GENERIC_PENDING_IRQ=y
-CONFIG_ZONE_DMA=y
 CONFIG_SEMAPHORE_SLEEPERS=y
-CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_HAVE_ARCH_ALLOC_REMAP=y
 CONFIG_HAVE_SETUP_PER_CPU_AREA=y
 CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
 CONFIG_SYS_SUPPORTS_HUGETLBFS=y
 CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_CLOCKEVENTS=y
-CONFIG_CLOCKSOURCE_WATCHDOG=y
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 CONFIG_DEFAULT_MIGRATION_COST=10000000
 CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
@@ -32,7 +29,6 @@ CONFIG_STRICT_DEVMEM=y
 CONFIG_SMP=y
 CONFIG_WERROR=y
 # CONFIG_DEBUG_COPY_FROM_USER is not set
-CONFIG_SERIAL_CONSOLE=y
 CONFIG_HVC_TILE=y
 CONFIG_TILE=y
 # CONFIG_TILEGX is not set
@@ -86,6 +82,7 @@ CONFIG_INITRAMFS_COMPRESSION_NONE=y
 # CONFIG_INITRAMFS_COMPRESSION_BZIP2 is not set
 # CONFIG_INITRAMFS_COMPRESSION_LZMA is not set
 # CONFIG_INITRAMFS_COMPRESSION_LZO is not set
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
 CONFIG_ANON_INODES=y
 CONFIG_EMBEDDED=y
@@ -220,7 +217,7 @@ CONFIG_PAGEFLAGS_EXTENDED=y
 CONFIG_SPLIT_PTLOCK_CPUS=4
 CONFIG_MIGRATION=y
 CONFIG_PHYS_ADDR_T_64BIT=y
-CONFIG_ZONE_DMA_FLAG=1
+CONFIG_ZONE_DMA_FLAG=0
 CONFIG_BOUNCE=y
 CONFIG_VIRT_TO_BUS=y
 # CONFIG_KSM is not set
@@ -232,10 +229,11 @@ CONFIG_FEEDBACK_USE=""
 CONFIG_VMALLOC_RESERVE=0x1000000
 CONFIG_HARDWALL=y
 CONFIG_MEMPROF=y
-CONFIG_XGBE_MAIN=y
+CONFIG_XGBE=y
 CONFIG_NET_TILE=y
 CONFIG_PSEUDO_NAPI=y
 CONFIG_TILEPCI_ENDP=y
+CONFIG_TILEPCI_HOST_SUBSET=m
 CONFIG_TILE_IDE_GPIO=y
 CONFIG_TILE_SOFTUART=y
 
@@ -244,6 +242,8 @@ CONFIG_TILE_SOFTUART=y
 #
 CONFIG_PCI=y
 CONFIG_PCI_DOMAINS=y
+# CONFIG_NO_IOMEM is not set
+# CONFIG_NO_IOPORT is not set
 # CONFIG_ARCH_SUPPORTS_MSI is not set
 CONFIG_PCI_DEBUG=y
 # CONFIG_PCI_STUB is not set
@@ -742,6 +742,7 @@ CONFIG_HVC_DRIVER=y
 #
 # CONFIG_RAW_DRIVER is not set
 # CONFIG_TCG_TPM is not set
+CONFIG_DEVPORT=y
 CONFIG_I2C=y
 CONFIG_I2C_BOARDINFO=y
 CONFIG_I2C_COMPAT=y
diff --git a/arch/tile/include/arch/abi.h b/arch/tile/include/arch/abi.h
index 7cdc47b..da8df5b 100644
--- a/arch/tile/include/arch/abi.h
+++ b/arch/tile/include/arch/abi.h
@@ -1,26 +1,29 @@
-// Copyright 2010 Tilera Corporation. All Rights Reserved.
-//
-//   This program is free software; you can redistribute it and/or
-//   modify it under the terms of the GNU General Public License
-//   as published by the Free Software Foundation, version 2.
-//
-//   This program is distributed in the hope that it will be useful, but
-//   WITHOUT ANY WARRANTY; without even the implied warranty of
-//   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
-//   NON INFRINGEMENT.  See the GNU General Public License for
-//   more details.
-
-//! @file
-//!
-//! ABI-related register definitions helpful when writing assembly code.
-//!
+/*
+ * Copyright 2010 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/**
+ * @file
+ *
+ * ABI-related register definitions helpful when writing assembly code.
+ */
 
 #ifndef __ARCH_ABI_H__
 #define __ARCH_ABI_H__
 
 #include <arch/chip.h>
 
-// Registers 0 - 55 are "normal", but some perform special roles.
+/* Registers 0 - 55 are "normal", but some perform special roles. */
 
 #define TREG_FP       52   /**< Frame pointer. */
 #define TREG_TP       53   /**< Thread pointer. */
@@ -30,7 +33,7 @@
 /** Index of last normal general-purpose register. */
 #define TREG_LAST_GPR 55
 
-// Registers 56 - 62 are "special" network registers.
+/* Registers 56 - 62 are "special" network registers. */
 
 #define TREG_SN       56   /**< Static network access. */
 #define TREG_IDN0     57   /**< IDN demux 0 access. */
@@ -40,7 +43,7 @@
 #define TREG_UDN2     61   /**< UDN demux 2 access. */
 #define TREG_UDN3     62   /**< UDN demux 3 access. */
 
-// Register 63 is the "special" zero register.
+/* Register 63 is the "special" zero register. */
 
 #define TREG_ZERO     63   /**< "Zero" register; always reads as "0". */
 
@@ -52,42 +55,44 @@
 #define TREG_SYSCALL_NR_NAME r10
 
 
-//! The ABI requires callers to allocate a caller state save area of
-//! this many bytes at the bottom of each stack frame.
-//!
+/**
+ * The ABI requires callers to allocate a caller state save area of
+ * this many bytes at the bottom of each stack frame.
+ */
 #ifdef __tile__
 #define C_ABI_SAVE_AREA_SIZE (2 * __SIZEOF_POINTER__)
 #endif
 
-//! The operand to an 'info' opcode directing the backtracer to not
-//! try to find the calling frame.
-//!
+/**
+ * The operand to an 'info' opcode directing the backtracer to not
+ * try to find the calling frame.
+ */
 #define INFO_OP_CANNOT_BACKTRACE 2
 
 #ifndef __ASSEMBLER__
 #if CHIP_WORD_SIZE() > 32
 
-//! Unsigned type that can hold a register.
+/** Unsigned type that can hold a register. */
 typedef unsigned long long uint_reg_t;
 
-//! Signed type that can hold a register.
+/** Signed type that can hold a register. */
 typedef long long int_reg_t;
 
-//! String prefix to use for printf().
+/** String prefix to use for printf(). */
 #define INT_REG_FMT "ll"
 
 #elif !defined(__LP64__)   /* avoid confusion with LP64 cross-build tools */
 
-//! Unsigned type that can hold a register.
+/** Unsigned type that can hold a register. */
 typedef unsigned long uint_reg_t;
 
-//! Signed type that can hold a register.
+/** Signed type that can hold a register. */
 typedef long int_reg_t;
 
-//! String prefix to use for printf().
+/** String prefix to use for printf(). */
 #define INT_REG_FMT "l"
 
 #endif
 #endif /* __ASSEMBLER__ */
 
-#endif // !__ARCH_ABI_H__
+#endif /* !__ARCH_ABI_H__ */
diff --git a/arch/tile/include/arch/interrupts_32.h b/arch/tile/include/arch/interrupts_32.h
index feffada..9d0bfa7 100644
--- a/arch/tile/include/arch/interrupts_32.h
+++ b/arch/tile/include/arch/interrupts_32.h
@@ -301,4 +301,4 @@
     INT_MASK(INT_DOUBLE_FAULT) | \
     INT_MASK(INT_AUX_PERF_COUNT) | \
     0)
-#endif // !__ARCH_INTERRUPTS_H__
+#endif /* !__ARCH_INTERRUPTS_H__ */
diff --git a/arch/tile/include/asm/atomic_32.h b/arch/tile/include/asm/atomic_32.h
index e4f8b4f..40a5a3a 100644
--- a/arch/tile/include/asm/atomic_32.h
+++ b/arch/tile/include/asm/atomic_32.h
@@ -348,6 +348,23 @@ void __init_atomic_per_cpu(void);
 /* Support releasing the atomic lock in do_page_fault_ics(). */
 void __atomic_fault_unlock(int *lock_ptr);
 #endif
+
+/* Private helper routines in lib/atomic_asm_32.S */
+extern struct __get_user __atomic_cmpxchg(volatile int *p,
+					  int *lock, int o, int n);
+extern struct __get_user __atomic_xchg(volatile int *p, int *lock, int n);
+extern struct __get_user __atomic_xchg_add(volatile int *p, int *lock, int n);
+extern struct __get_user __atomic_xchg_add_unless(volatile int *p,
+						  int *lock, int o, int n);
+extern struct __get_user __atomic_or(volatile int *p, int *lock, int n);
+extern struct __get_user __atomic_andn(volatile int *p, int *lock, int n);
+extern struct __get_user __atomic_xor(volatile int *p, int *lock, int n);
+extern u64 __atomic64_cmpxchg(volatile u64 *p, int *lock, u64 o, u64 n);
+extern u64 __atomic64_xchg(volatile u64 *p, int *lock, u64 n);
+extern u64 __atomic64_xchg_add(volatile u64 *p, int *lock, u64 n);
+extern u64 __atomic64_xchg_add_unless(volatile u64 *p,
+				      int *lock, u64 o, u64 n);
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_TILE_ATOMIC_32_H */
diff --git a/arch/tile/include/asm/compat.h b/arch/tile/include/asm/compat.h
index e133c53..6ee9d07 100644
--- a/arch/tile/include/asm/compat.h
+++ b/arch/tile/include/asm/compat.h
@@ -70,48 +70,7 @@ struct compat_timeval {
 	s32		tv_usec;
 };
 
-struct compat_stat {
-	unsigned int	st_dev;
-	unsigned int	st_ino;
-	unsigned int	st_mode;
-	unsigned int	st_nlink;
-	unsigned int	st_uid;
-	unsigned int	st_gid;
-	unsigned int	st_rdev;
-	unsigned int    __pad1;
-	int		st_size;
-	int		st_blksize;
-	int		__pad2;
-	int		st_blocks;
-	int		st_atime;
-	unsigned int	st_atime_nsec;
-	int		st_mtime;
-	unsigned int	st_mtime_nsec;
-	int		st_ctime;
-	unsigned int	st_ctime_nsec;
-	unsigned int	__unused[2];
-};
-
-struct compat_stat64 {
-	unsigned long	st_dev;
-	unsigned long	st_ino;
-	unsigned int	st_mode;
-	unsigned int	st_nlink;
-	unsigned int	st_uid;
-	unsigned int	st_gid;
-	unsigned long	st_rdev;
-	long		st_size;
-	unsigned int	st_blksize;
-	unsigned long	st_blocks __attribute__((packed));
-	unsigned int	st_atime;
-	unsigned int	st_atime_nsec;
-	unsigned int	st_mtime;
-	unsigned int	st_mtime_nsec;
-	unsigned int	st_ctime;
-	unsigned int	st_ctime_nsec;
-	unsigned int	__unused8;
-};
-
+#define compat_stat stat
 #define compat_statfs statfs
 
 struct compat_sysctl {
@@ -233,7 +192,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
 /* Sign-extend when storing a kernel pointer to a user's ptregs. */
 static inline unsigned long ptr_to_compat_reg(void __user *uptr)
 {
-	return (long)(int)(long)uptr;
+	return (long)(int)(long __force)uptr;
 }
 
 static inline void __user *compat_alloc_user_space(long len)
@@ -278,17 +237,8 @@ long compat_sys_sync_file_range2(int fd, unsigned int flags,
 long compat_sys_fallocate(int fd, int mode,
 			  u32 offset_lo, u32 offset_hi,
 			  u32 len_lo, u32 len_hi);
-long compat_sys_stat64(char __user *filename,
-		       struct compat_stat64 __user *statbuf);
-long compat_sys_lstat64(char __user *filename,
-			struct compat_stat64 __user *statbuf);
-long compat_sys_fstat64(unsigned int fd, struct compat_stat64 __user *statbuf);
-long compat_sys_fstatat64(int dfd, char __user *filename,
-			  struct compat_stat64 __user *statbuf, int flag);
 long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 				      struct compat_timespec __user *interval);
-ssize_t compat_sys_sendfile(int out_fd, int in_fd, compat_off_t __user *offset,
-			    size_t count);
 
 /* Versions of compat functions that differ from generic Linux. */
 struct compat_msgbuf;
@@ -302,7 +252,6 @@ long tile_compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 			    compat_long_t addr, compat_long_t data);
 
 /* Tilera Linux syscalls that don't have "compat" versions. */
-#define compat_sys_raise_fpe sys_raise_fpe
 #define compat_sys_flush_cache sys_flush_cache
 
 #endif /* _ASM_TILE_COMPAT_H */
diff --git a/arch/tile/include/asm/elf.h b/arch/tile/include/asm/elf.h
index 1bca0de..623a6bb 100644
--- a/arch/tile/include/asm/elf.h
+++ b/arch/tile/include/asm/elf.h
@@ -59,8 +59,7 @@ enum { ELF_ARCH = CHIP_ELF_TYPE() };
  */
 #define elf_check_arch(x)  \
 	((x)->e_ident[EI_CLASS] == ELF_CLASS && \
-	 ((x)->e_machine == CHIP_ELF_TYPE() || \
-	  (x)->e_machine == CHIP_COMPAT_ELF_TYPE()))
+	 (x)->e_machine == CHIP_ELF_TYPE())
 
 /* The module loader only handles a few relocation types. */
 #ifndef __tilegx__
@@ -139,8 +138,7 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
  */
 #define compat_elf_check_arch(x)  \
 	((x)->e_ident[EI_CLASS] == ELFCLASS32 && \
-	 ((x)->e_machine == CHIP_ELF_TYPE() || \
-	  (x)->e_machine == CHIP_COMPAT_ELF_TYPE()))
+	 (x)->e_machine == CHIP_ELF_TYPE())
 
 #define compat_start_thread(regs, ip, usp) do { \
 		regs->pc = ptr_to_compat_reg((void *)(ip)); \
diff --git a/arch/tile/include/asm/futex.h b/arch/tile/include/asm/futex.h
index 9eaeb3c..fe0d10d 100644
--- a/arch/tile/include/asm/futex.h
+++ b/arch/tile/include/asm/futex.h
@@ -29,14 +29,14 @@
 #include <linux/uaccess.h>
 #include <linux/errno.h>
 
-extern struct __get_user futex_set(int *v, int i);
-extern struct __get_user futex_add(int *v, int n);
-extern struct __get_user futex_or(int *v, int n);
-extern struct __get_user futex_andn(int *v, int n);
-extern struct __get_user futex_cmpxchg(int *v, int o, int n);
+extern struct __get_user futex_set(int __user *v, int i);
+extern struct __get_user futex_add(int __user *v, int n);
+extern struct __get_user futex_or(int __user *v, int n);
+extern struct __get_user futex_andn(int __user *v, int n);
+extern struct __get_user futex_cmpxchg(int __user *v, int o, int n);
 
 #ifndef __tilegx__
-extern struct __get_user futex_xor(int *v, int n);
+extern struct __get_user futex_xor(int __user *v, int n);
 #else
 static inline struct __get_user futex_xor(int __user *uaddr, int n)
 {
@@ -131,6 +131,11 @@ static inline int futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval,
 	return asm_ret.err ? asm_ret.err : asm_ret.val;
 }
 
+#ifndef __tilegx__
+/* Return failure from the atomic wrappers. */
+struct __get_user __atomic_bad_address(int __user *addr);
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_TILE_FUTEX_H */
diff --git a/arch/tile/include/asm/page.h b/arch/tile/include/asm/page.h
index c8301c4..f894a90 100644
--- a/arch/tile/include/asm/page.h
+++ b/arch/tile/include/asm/page.h
@@ -16,8 +16,6 @@
 #define _ASM_TILE_PAGE_H
 
 #include <linux/const.h>
-#include <hv/hypervisor.h>
-#include <arch/chip.h>
 
 /* PAGE_SHIFT and HPAGE_SHIFT determine the page sizes. */
 #define PAGE_SHIFT	16
@@ -29,6 +27,11 @@
 #define PAGE_MASK	(~(PAGE_SIZE - 1))
 #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
 
+#ifdef __KERNEL__
+
+#include <hv/hypervisor.h>
+#include <arch/chip.h>
+
 /*
  * The {,H}PAGE_SHIFT values must match the HV_LOG2_PAGE_SIZE_xxx
  * definitions in <hv/hypervisor.h>.  We validate this at build time
@@ -331,4 +334,6 @@ extern pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr);
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
+#endif /* __KERNEL__ */
+
 #endif /* _ASM_TILE_PAGE_H */
diff --git a/arch/tile/include/asm/pgtable.h b/arch/tile/include/asm/pgtable.h
index beb1504..b336737 100644
--- a/arch/tile/include/asm/pgtable.h
+++ b/arch/tile/include/asm/pgtable.h
@@ -229,9 +229,9 @@ static inline void __pte_clear(pte_t *ptep)
 #define pte_donemigrate(x) hv_pte_set_present(hv_pte_clear_migrating(x))
 
 #define pte_ERROR(e) \
-	printk("%s:%d: bad pte 0x%016llx.\n", __FILE__, __LINE__, pte_val(e))
+	pr_err("%s:%d: bad pte 0x%016llx.\n", __FILE__, __LINE__, pte_val(e))
 #define pgd_ERROR(e) \
-	printk("%s:%d: bad pgd 0x%016llx.\n", __FILE__, __LINE__, pgd_val(e))
+	pr_err("%s:%d: bad pgd 0x%016llx.\n", __FILE__, __LINE__, pgd_val(e))
 
 /*
  * set_pte_order() sets the given PTE and also sanity-checks the
@@ -470,6 +470,11 @@ static inline int pmd_huge_page(pmd_t pmd)
 
 #include <asm-generic/pgtable.h>
 
+/* Support /proc/NN/pgtable API. */
+struct seq_file;
+int arch_proc_pgtable_show(struct seq_file *m, struct mm_struct *mm,
+			   unsigned long vaddr, pte_t *ptep, void **datap);
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_TILE_PGTABLE_H */
diff --git a/arch/tile/include/asm/pgtable_32.h b/arch/tile/include/asm/pgtable_32.h
index b935fb2..53ec348 100644
--- a/arch/tile/include/asm/pgtable_32.h
+++ b/arch/tile/include/asm/pgtable_32.h
@@ -89,15 +89,27 @@ static inline int pgd_addr_invalid(unsigned long addr)
 /*
  * Provide versions of these routines that can be used safely when
  * the hypervisor may be asynchronously modifying dirty/accessed bits.
+ * ptep_get_and_clear() matches the generic one but we provide it to
+ * be parallel with the 64-bit code.
  */
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
+#define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 
 extern int ptep_test_and_clear_young(struct vm_area_struct *,
 				     unsigned long addr, pte_t *);
 extern void ptep_set_wrprotect(struct mm_struct *,
 			       unsigned long addr, pte_t *);
 
+#define __HAVE_ARCH_PTEP_GET_AND_CLEAR
+static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
+				       unsigned long addr, pte_t *ptep)
+{
+	pte_t pte = *ptep;
+	pte_clear(_mm, addr, ptep);
+	return pte;
+}
+
 /* Create a pmd from a PTFN. */
 static inline pmd_t ptfn_pmd(unsigned long ptfn, pgprot_t prot)
 {
diff --git a/arch/tile/include/asm/ptrace.h b/arch/tile/include/asm/ptrace.h
index 4d1d995..acdae81 100644
--- a/arch/tile/include/asm/ptrace.h
+++ b/arch/tile/include/asm/ptrace.h
@@ -112,6 +112,9 @@ struct pt_regs {
 /* Fill in a struct pt_regs with the current kernel registers. */
 struct pt_regs *get_pt_regs(struct pt_regs *);
 
+/* Trace the current syscall. */
+extern void do_syscall_trace(void);
+
 extern void show_regs(struct pt_regs *);
 
 #define arch_has_single_step()	(1)
@@ -123,7 +126,7 @@ extern void show_regs(struct pt_regs *);
  */
 struct single_step_state {
 	/* the page to which we will write hacked-up bundles */
-	void *buffer;
+	void __user *buffer;
 
 	union {
 		int flags;
diff --git a/arch/tile/include/asm/sections.h b/arch/tile/include/asm/sections.h
index 6c11149..d062d46 100644
--- a/arch/tile/include/asm/sections.h
+++ b/arch/tile/include/asm/sections.h
@@ -25,7 +25,14 @@ extern char _sinitdata[], _einitdata[];
 /* Write-once data is writable only till the end of initialization. */
 extern char __w1data_begin[], __w1data_end[];
 
-extern char __feedback_section_start[], __feedback_section_end[];
+
+/* Not exactly sections, but PC comparison points in the code. */
+extern char __rt_sigreturn[], __rt_sigreturn_end[];
+#ifndef __tilegx__
+extern char sys_cmpxchg[], __sys_cmpxchg_end[];
+extern char __sys_cmpxchg_grab_lock[];
+extern char __start_atomic_asm_code[], __end_atomic_asm_code[];
+#endif
 
 /* Handle the discontiguity between _sdata and _stext. */
 static inline int arch_is_kernel_data(unsigned long addr)
diff --git a/arch/tile/include/asm/signal.h b/arch/tile/include/asm/signal.h
index d20d326..eb0253f 100644
--- a/arch/tile/include/asm/signal.h
+++ b/arch/tile/include/asm/signal.h
@@ -26,6 +26,7 @@
 #if defined(__KERNEL__) && !defined(__ASSEMBLY__)
 int restore_sigcontext(struct pt_regs *, struct sigcontext __user *, long *);
 int setup_sigcontext(struct sigcontext __user *, struct pt_regs *);
+void do_signal(struct pt_regs *regs);
 #endif
 
 #endif /* _ASM_TILE_SIGNAL_H */
diff --git a/arch/tile/include/asm/spinlock_32.h b/arch/tile/include/asm/spinlock_32.h
index f3a8473..88efdde 100644
--- a/arch/tile/include/asm/spinlock_32.h
+++ b/arch/tile/include/asm/spinlock_32.h
@@ -134,9 +134,8 @@ static inline int arch_read_trylock(arch_rwlock_t *rwlock)
 {
 	int locked;
 	u32 val = __insn_tns((int *)&rwlock->lock);
-	if (unlikely(val & 1)) {
+	if (unlikely(val & 1))
 		return arch_read_trylock_slow(rwlock);
-	}
 	locked = (val << _RD_COUNT_WIDTH) == 0;
 	rwlock->lock = val + (locked << _RD_COUNT_SHIFT);
 	return locked;
diff --git a/arch/tile/include/asm/stack.h b/arch/tile/include/asm/stack.h
index 864913b..f908473 100644
--- a/arch/tile/include/asm/stack.h
+++ b/arch/tile/include/asm/stack.h
@@ -48,6 +48,10 @@ extern void KBacktraceIterator_init(struct KBacktraceIterator *kbt,
 /* Initialize iterator based on current stack. */
 extern void KBacktraceIterator_init_current(struct KBacktraceIterator *kbt);
 
+/* Helper method for above. */
+extern void _KBacktraceIterator_init_current(struct KBacktraceIterator *kbt,
+				ulong pc, ulong lr, ulong sp, ulong r52);
+
 /* No more frames? */
 extern int KBacktraceIterator_end(struct KBacktraceIterator *kbt);
 
@@ -64,5 +68,7 @@ extern void tile_show_stack(struct KBacktraceIterator *, int headers);
 /* Dump stack of current process, with registers to seed the backtrace. */
 extern void dump_stack_regs(struct pt_regs *);
 
+/* Helper method for assembly dump_stack(). */
+extern void _dump_stack(int dummy, ulong pc, ulong lr, ulong sp, ulong r52);
 
 #endif /* _ASM_TILE_STACK_H */
diff --git a/arch/tile/include/asm/syscalls.h b/arch/tile/include/asm/syscalls.h
index 9f2b8e2..af165a7 100644
--- a/arch/tile/include/asm/syscalls.h
+++ b/arch/tile/include/asm/syscalls.h
@@ -22,7 +22,19 @@
 #include <linux/linkage.h>
 #include <linux/signal.h>
 #include <linux/types.h>
-#include <asm-generic/syscalls.h>
+#include <linux/compat.h>
+
+/* The array of function pointers for syscalls. */
+extern void *sys_call_table[];
+#ifdef CONFIG_COMPAT
+extern void *compat_sys_call_table[];
+#endif
+
+/*
+ * Note that by convention, any syscall which requires the current
+ * register set takes an additional "struct pt_regs *" pointer; the
+ * sys_xxx() function just adds the pointer and tail-calls to _sys_xxx().
+ */
 
 /* kernel/sys.c */
 ssize_t sys32_readahead(int fd, u32 offset_lo, u32 offset_hi, u32 count);
@@ -31,10 +43,66 @@ long sys32_fadvise64(int fd, u32 offset_lo, u32 offset_hi,
 int sys32_fadvise64_64(int fd, u32 offset_lo, u32 offset_hi,
 		       u32 len_lo, u32 len_hi, int advice);
 long sys_flush_cache(void);
+long sys_mmap2(unsigned long addr, unsigned long len,
+	       unsigned long prot, unsigned long flags,
+	       unsigned long fd, unsigned long pgoff);
+#ifdef __tilegx__
+long sys_mmap(unsigned long addr, unsigned long len,
+	      unsigned long prot, unsigned long flags,
+	      unsigned long fd, off_t pgoff);
+#endif
+
+/* kernel/process.c */
+long sys_clone(unsigned long clone_flags, unsigned long newsp,
+	       void __user *parent_tid, void __user *child_tid);
+long _sys_clone(unsigned long clone_flags, unsigned long newsp,
+		void __user *parent_tid, void __user *child_tid,
+		struct pt_regs *regs);
+long sys_fork(void);
+long _sys_fork(struct pt_regs *regs);
+long sys_vfork(void);
+long _sys_vfork(struct pt_regs *regs);
+long sys_execve(char __user *filename, char __user * __user *argv,
+		char __user * __user *envp);
+long _sys_execve(char __user *filename, char __user * __user *argv,
+		 char __user * __user *envp, struct pt_regs *regs);
+
+/* kernel/signal.c */
+long sys_sigaltstack(const stack_t __user *, stack_t __user *);
+long _sys_sigaltstack(const stack_t __user *, stack_t __user *,
+		      struct pt_regs *);
+long sys_rt_sigreturn(void);
+long _sys_rt_sigreturn(struct pt_regs *regs);
+
+/* platform-independent functions */
+long sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize);
+long sys_rt_sigaction(int sig, const struct sigaction __user *act,
+		      struct sigaction __user *oact, size_t sigsetsize);
 
 #ifndef __tilegx__
 /* mm/fault.c */
-int sys_cmpxchg_badaddr(unsigned long address, struct pt_regs *);
+int sys_cmpxchg_badaddr(unsigned long address);
+int _sys_cmpxchg_badaddr(unsigned long address, struct pt_regs *);
+#endif
+
+#ifdef CONFIG_COMPAT
+long compat_sys_execve(char __user *path, compat_uptr_t __user *argv,
+		       compat_uptr_t __user *envp);
+long _compat_sys_execve(char __user *path, compat_uptr_t __user *argv,
+			compat_uptr_t __user *envp, struct pt_regs *regs);
+long compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
+			    struct compat_sigaltstack __user *uoss_ptr);
+long _compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
+			     struct compat_sigaltstack __user *uoss_ptr,
+			     struct pt_regs *regs);
+long compat_sys_rt_sigreturn(void);
+long _compat_sys_rt_sigreturn(struct pt_regs *regs);
+
+/* These four are not defined for 64-bit, but serve as "compat" syscalls. */
+long sys_fcntl64(unsigned int fd, unsigned int cmd, unsigned long arg);
+long sys_fstat64(unsigned long fd, struct stat64 __user *statbuf);
+long sys_truncate64(const char __user *path, loff_t length);
+long sys_ftruncate64(unsigned int fd, loff_t length);
 #endif
 
 #endif /* _ASM_TILE_SYSCALLS_H */
diff --git a/arch/tile/include/asm/system.h b/arch/tile/include/asm/system.h
index d6ca7f8..0935094 100644
--- a/arch/tile/include/asm/system.h
+++ b/arch/tile/include/asm/system.h
@@ -160,6 +160,14 @@ struct task_struct;
 extern struct task_struct *_switch_to(struct task_struct *prev,
 				      struct task_struct *next);
 
+/* Helper function for _switch_to(). */
+extern struct task_struct *__switch_to(struct task_struct *prev,
+				       struct task_struct *next,
+				       unsigned long new_system_save_1_0);
+
+/* Address that switched-away from tasks are at. */
+extern unsigned long get_switch_to_pc(void);
+
 /*
  * On SMP systems, when the scheduler does migration-cost autodetection,
  * it needs a way to flush as much of the CPU's caches as possible:
@@ -187,10 +195,26 @@ extern int unaligned_printk;
 /* Number of unaligned fixups performed */
 extern unsigned int unaligned_fixup_count;
 
+/* Init-time routine to do tile-specific per-cpu setup. */
+void setup_cpu(int boot);
+
 /* User-level DMA management functions */
 void grant_dma_mpls(void);
 void restrict_dma_mpls(void);
 
+#ifdef CONFIG_HARDWALL
+/* User-level network management functions */
+void reset_network_state(void);
+void grant_network_mpls(void);
+void restrict_network_mpls(void);
+int hardwall_deactivate(struct task_struct *task);
+
+/* Hook hardwall code into changes in affinity. */
+#define arch_set_cpus_allowed(p, new_mask) do { \
+	if (p->thread.hardwall && !cpumask_equal(&p->cpus_allowed, new_mask)) \
+		hardwall_deactivate(p); \
+} while (0)
+#endif
 
 /* Invoke the simulator "syscall" mechanism (see arch/tile/kernel/entry.S). */
 extern int _sim_syscall(int syscall_num, ...);
@@ -215,6 +239,12 @@ extern int _sim_syscall(int syscall_num, ...);
 		homecache_migrate_kthread();                              \
 } while (0)
 
+/* Support function for forking a new task. */
+void ret_from_fork(void);
+
+/* Called from ret_from_fork() when a new process starts up. */
+struct task_struct *sim_notify_fork(struct task_struct *prev);
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_TILE_SYSTEM_H */
diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
index 9024bf3..beec872 100644
--- a/arch/tile/include/asm/thread_info.h
+++ b/arch/tile/include/asm/thread_info.h
@@ -55,7 +55,7 @@ struct thread_info {
 	.restart_block	= {			\
 		.fn = do_no_restart_syscall,	\
 	},					\
-	.step_state	= 0,			\
+	.step_state	= NULL,			\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
@@ -86,6 +86,12 @@ register unsigned long stack_pointer __asm__("sp");
 extern struct thread_info *alloc_thread_info(struct task_struct *task);
 extern void free_thread_info(struct thread_info *info);
 
+/* Sit on a nap instruction until interrupted. */
+extern void smp_nap(void);
+
+/* Enable interrupts racelessly and nap forever: helper for cpu_idle(). */
+extern void _cpu_idle(void);
+
 /* Switch boot idle thread to a freshly-allocated stack and free old stack. */
 extern void cpu_idle_on_new_stack(struct thread_info *old_ti,
 				  unsigned long new_sp,
diff --git a/arch/tile/include/asm/traps.h b/arch/tile/include/asm/traps.h
index eab33d4..432a9c1 100644
--- a/arch/tile/include/asm/traps.h
+++ b/arch/tile/include/asm/traps.h
@@ -18,9 +18,28 @@
 /* mm/fault.c */
 void do_page_fault(struct pt_regs *, int fault_num,
 		   unsigned long address, unsigned long write);
+void do_async_page_fault(struct pt_regs *);
+
+#ifndef __tilegx__
+/*
+ * We return this structure in registers to avoid having to write
+ * additional save/restore code in the intvec.S caller.
+ */
+struct intvec_state {
+	void *handler;
+	unsigned long vecnum;
+	unsigned long fault_num;
+	unsigned long info;
+	unsigned long retval;
+};
+struct intvec_state do_page_fault_ics(struct pt_regs *regs, int fault_num,
+				      unsigned long address,
+				      unsigned long info);
+#endif
 
 /* kernel/traps.c */
 void do_trap(struct pt_regs *, int fault_num, unsigned long reason);
+void kernel_double_fault(int dummy, ulong pc, ulong lr, ulong sp, ulong r52);
 
 /* kernel/time.c */
 void do_timer_interrupt(struct pt_regs *, int fault_num);
@@ -31,6 +50,13 @@ void hv_message_intr(struct pt_regs *, int intnum);
 /* kernel/irq.c */
 void tile_dev_intr(struct pt_regs *, int intnum);
 
+#ifdef CONFIG_HARDWALL
+/* kernel/hardwall.c */
+void do_hardwall_trap(struct pt_regs *, int fault_num);
+#endif
+
+/* kernel/ptrace.c */
+void do_breakpoint(struct pt_regs *, int fault_num);
 
 
 #endif /* _ASM_TILE_SYSCALLS_H */
diff --git a/arch/tile/include/asm/uaccess.h b/arch/tile/include/asm/uaccess.h
index f3058af..ed17a80 100644
--- a/arch/tile/include/asm/uaccess.h
+++ b/arch/tile/include/asm/uaccess.h
@@ -89,8 +89,10 @@ int __range_ok(unsigned long addr, unsigned long size);
  * checks that the pointer is in the user space range - after calling
  * this function, memory access functions may still return -EFAULT.
  */
-#define access_ok(type, addr, size) \
-	(likely(__range_ok((unsigned long)addr, size) == 0))
+#define access_ok(type, addr, size) ({ \
+	__chk_user_ptr(addr); \
+	likely(__range_ok((unsigned long)(addr), (size)) == 0);	\
+})
 
 /*
  * The exception table consists of pairs of addresses: the first is the
@@ -134,14 +136,14 @@ struct __get_user {
  * such extended assembler routines, though we will have to use a
  * different return code in that case (1, 2, or 4, rather than -EFAULT).
  */
-extern struct __get_user __get_user_1(const void *);
-extern struct __get_user __get_user_2(const void *);
-extern struct __get_user __get_user_4(const void *);
-extern struct __get_user __get_user_8(const void *);
-extern int __put_user_1(long, void *);
-extern int __put_user_2(long, void *);
-extern int __put_user_4(long, void *);
-extern int __put_user_8(long long, void *);
+extern struct __get_user __get_user_1(const void __user *);
+extern struct __get_user __get_user_2(const void __user *);
+extern struct __get_user __get_user_4(const void __user *);
+extern struct __get_user __get_user_8(const void __user *);
+extern int __put_user_1(long, void __user *);
+extern int __put_user_2(long, void __user *);
+extern int __put_user_4(long, void __user *);
+extern int __put_user_8(long long, void __user *);
 
 /* Unimplemented routines to cause linker failures */
 extern struct __get_user __get_user_bad(void);
diff --git a/arch/tile/include/asm/unistd.h b/arch/tile/include/asm/unistd.h
index 03b3d5d..f2e3ff4 100644
--- a/arch/tile/include/asm/unistd.h
+++ b/arch/tile/include/asm/unistd.h
@@ -15,7 +15,6 @@
 #if !defined(_ASM_TILE_UNISTD_H) || defined(__SYSCALL)
 #define _ASM_TILE_UNISTD_H
 
-
 #ifndef __LP64__
 /* Use the flavor of this syscall that matches the 32-bit API better. */
 #define __ARCH_WANT_SYNC_FILE_RANGE2
@@ -24,6 +23,10 @@
 /* Use the standard ABI for syscalls. */
 #include <asm-generic/unistd.h>
 
+/* Additional Tilera-specific syscalls. */
+#define __NR_flush_cache	(__NR_arch_specific_syscall + 1)
+__SYSCALL(__NR_flush_cache, sys_flush_cache)
+
 #ifndef __tilegx__
 /* "Fast" syscalls provide atomic support for 32-bit chips. */
 #define __NR_FAST_cmpxchg	-1
@@ -33,10 +36,6 @@
 __SYSCALL(__NR_cmpxchg_badaddr, sys_cmpxchg_badaddr)
 #endif
 
-/* Additional Tilera-specific syscalls. */
-#define __NR_flush_cache	(__NR_arch_specific_syscall + 1)
-__SYSCALL(__NR_flush_cache, sys_flush_cache)
-
 #ifdef __KERNEL__
 /* In compat mode, we use sys_llseek() for compat_sys_llseek(). */
 #ifdef CONFIG_COMPAT
diff --git a/arch/tile/kernel/backtrace.c b/arch/tile/kernel/backtrace.c
index 1b0a410..77265f3 100644
--- a/arch/tile/kernel/backtrace.c
+++ b/arch/tile/kernel/backtrace.c
@@ -30,18 +30,18 @@
 
 
 /** A decoded bundle used for backtracer analysis. */
-typedef struct {
+struct BacktraceBundle {
 	tile_bundle_bits bits;
 	int num_insns;
 	struct tile_decoded_instruction
 	insns[TILE_MAX_INSTRUCTIONS_PER_BUNDLE];
-} BacktraceBundle;
+};
 
 
 /* This implementation only makes sense for native tools. */
 /** Default function to read memory. */
-static bool
-bt_read_memory(void *result, VirtualAddress addr, size_t size, void *extra)
+static bool bt_read_memory(void *result, VirtualAddress addr,
+			   size_t size, void *extra)
 {
 	/* FIXME: this should do some horrible signal stuff to catch
 	 * SEGV cleanly and fail.
@@ -58,11 +58,11 @@ bt_read_memory(void *result, VirtualAddress addr, size_t size, void *extra)
  * has the specified mnemonic, and whose first 'num_operands_to_match'
  * operands exactly match those in 'operand_values'.
  */
-static const struct tile_decoded_instruction*
-find_matching_insn(const BacktraceBundle *bundle,
-		   tile_mnemonic mnemonic,
-		   const int *operand_values,
-		   int num_operands_to_match)
+static const struct tile_decoded_instruction *find_matching_insn(
+	const struct BacktraceBundle *bundle,
+	tile_mnemonic mnemonic,
+	const int *operand_values,
+	int num_operands_to_match)
 {
 	int i, j;
 	bool match;
@@ -90,8 +90,7 @@ find_matching_insn(const BacktraceBundle *bundle,
 }
 
 /** Does this bundle contain an 'iret' instruction? */
-static inline bool
-bt_has_iret(const BacktraceBundle *bundle)
+static inline bool bt_has_iret(const struct BacktraceBundle *bundle)
 {
 	return find_matching_insn(bundle, TILE_OPC_IRET, NULL, 0) != NULL;
 }
@@ -99,8 +98,7 @@ bt_has_iret(const BacktraceBundle *bundle)
 /** Does this bundle contain an 'addi sp, sp, OFFSET' or
  * 'addli sp, sp, OFFSET' instruction, and if so, what is OFFSET?
  */
-static bool
-bt_has_addi_sp(const BacktraceBundle *bundle, int *adjust)
+static bool bt_has_addi_sp(const struct BacktraceBundle *bundle, int *adjust)
 {
 	static const int vals[2] = { TREG_SP, TREG_SP };
 
@@ -120,8 +118,7 @@ bt_has_addi_sp(const BacktraceBundle *bundle, int *adjust)
  * as an unsigned value by this code since that's what the caller wants.
  * Returns the number of info ops found.
  */
-static int
-bt_get_info_ops(const BacktraceBundle *bundle,
+static int bt_get_info_ops(const struct BacktraceBundle *bundle,
 		int operands[MAX_INFO_OPS_PER_BUNDLE])
 {
 	int num_ops = 0;
@@ -143,8 +140,7 @@ bt_get_info_ops(const BacktraceBundle *bundle,
 /** Does this bundle contain a jrp instruction, and if so, to which
  * register is it jumping?
  */
-static bool
-bt_has_jrp(const BacktraceBundle *bundle, int *target_reg)
+static bool bt_has_jrp(const struct BacktraceBundle *bundle, int *target_reg)
 {
 	const struct tile_decoded_instruction *insn =
 		find_matching_insn(bundle, TILE_OPC_JRP, NULL, 0);
@@ -156,8 +152,7 @@ bt_has_jrp(const BacktraceBundle *bundle, int *target_reg)
 }
 
 /** Does this bundle modify the specified register in any way? */
-static bool
-bt_modifies_reg(const BacktraceBundle *bundle, int reg)
+static bool bt_modifies_reg(const struct BacktraceBundle *bundle, int reg)
 {
 	int i, j;
 	for (i = 0; i < bundle->num_insns; i++) {
@@ -177,30 +172,26 @@ bt_modifies_reg(const BacktraceBundle *bundle, int reg)
 }
 
 /** Does this bundle modify sp? */
-static inline bool
-bt_modifies_sp(const BacktraceBundle *bundle)
+static inline bool bt_modifies_sp(const struct BacktraceBundle *bundle)
 {
 	return bt_modifies_reg(bundle, TREG_SP);
 }
 
 /** Does this bundle modify lr? */
-static inline bool
-bt_modifies_lr(const BacktraceBundle *bundle)
+static inline bool bt_modifies_lr(const struct BacktraceBundle *bundle)
 {
 	return bt_modifies_reg(bundle, TREG_LR);
 }
 
 /** Does this bundle contain the instruction 'move fp, sp'? */
-static inline bool
-bt_has_move_r52_sp(const BacktraceBundle *bundle)
+static inline bool bt_has_move_r52_sp(const struct BacktraceBundle *bundle)
 {
 	static const int vals[2] = { 52, TREG_SP };
 	return find_matching_insn(bundle, TILE_OPC_MOVE, vals, 2) != NULL;
 }
 
 /** Does this bundle contain the instruction 'sw sp, lr'? */
-static inline bool
-bt_has_sw_sp_lr(const BacktraceBundle *bundle)
+static inline bool bt_has_sw_sp_lr(const struct BacktraceBundle *bundle)
 {
 	static const int vals[2] = { TREG_SP, TREG_LR };
 	return find_matching_insn(bundle, TILE_OPC_SW, vals, 2) != NULL;
@@ -209,11 +200,10 @@ bt_has_sw_sp_lr(const BacktraceBundle *bundle)
 /** Locates the caller's PC and SP for a program starting at the
  * given address.
  */
-static void
-find_caller_pc_and_caller_sp(CallerLocation *location,
-			     const VirtualAddress start_pc,
-			     BacktraceMemoryReader read_memory_func,
-			     void *read_memory_func_extra)
+static void find_caller_pc_and_caller_sp(CallerLocation *location,
+					 const VirtualAddress start_pc,
+					 BacktraceMemoryReader read_memory_func,
+					 void *read_memory_func_extra)
 {
 	/* Have we explicitly decided what the sp is,
 	 * rather than just the default?
@@ -253,7 +243,7 @@ find_caller_pc_and_caller_sp(CallerLocation *location,
 
 	for (pc = start_pc;; pc += sizeof(tile_bundle_bits)) {
 
-		BacktraceBundle bundle;
+		struct BacktraceBundle bundle;
 		int num_info_ops, info_operands[MAX_INFO_OPS_PER_BUNDLE];
 		int one_ago, jrp_reg;
 		bool has_jrp;
@@ -475,12 +465,11 @@ find_caller_pc_and_caller_sp(CallerLocation *location,
 	}
 }
 
-void
-backtrace_init(BacktraceIterator *state,
-	       BacktraceMemoryReader read_memory_func,
-	       void *read_memory_func_extra,
-	       VirtualAddress pc, VirtualAddress lr,
-	       VirtualAddress sp, VirtualAddress r52)
+void backtrace_init(BacktraceIterator *state,
+		    BacktraceMemoryReader read_memory_func,
+		    void *read_memory_func_extra,
+		    VirtualAddress pc, VirtualAddress lr,
+		    VirtualAddress sp, VirtualAddress r52)
 {
 	CallerLocation location;
 	VirtualAddress fp, initial_frame_caller_pc;
@@ -558,8 +547,7 @@ backtrace_init(BacktraceIterator *state,
 	state->read_memory_func_extra = read_memory_func_extra;
 }
 
-bool
-backtrace_next(BacktraceIterator *state)
+bool backtrace_next(BacktraceIterator *state)
 {
 	VirtualAddress next_fp, next_pc, next_frame[2];
 
@@ -614,12 +602,11 @@ backtrace_next(BacktraceIterator *state)
 
 #else /* TILE_CHIP < 10 */
 
-void
-backtrace_init(BacktraceIterator *state,
-	       BacktraceMemoryReader read_memory_func,
-	       void *read_memory_func_extra,
-	       VirtualAddress pc, VirtualAddress lr,
-	       VirtualAddress sp, VirtualAddress r52)
+void backtrace_init(BacktraceIterator *state,
+		    BacktraceMemoryReader read_memory_func,
+		    void *read_memory_func_extra,
+		    VirtualAddress pc, VirtualAddress lr,
+		    VirtualAddress sp, VirtualAddress r52)
 {
 	state->pc = pc;
 	state->sp = sp;
diff --git a/arch/tile/kernel/compat.c b/arch/tile/kernel/compat.c
index a374c99..b1e06d0 100644
--- a/arch/tile/kernel/compat.c
+++ b/arch/tile/kernel/compat.c
@@ -88,34 +88,14 @@ long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 	mm_segment_t old_fs = get_fs();
 
 	set_fs(KERNEL_DS);
-	ret = sys_sched_rr_get_interval(pid, (struct timespec __user *)&t);
+	ret = sys_sched_rr_get_interval(pid,
+					(struct timespec __force __user *)&t);
 	set_fs(old_fs);
 	if (put_compat_timespec(&t, interval))
 		return -EFAULT;
 	return ret;
 }
 
-ssize_t compat_sys_sendfile(int out_fd, int in_fd, compat_off_t __user *offset,
-			    size_t count)
-{
-	mm_segment_t old_fs = get_fs();
-	int ret;
-	off_t of;
-
-	if (offset && get_user(of, offset))
-		return -EFAULT;
-
-	set_fs(KERNEL_DS);
-	ret = sys_sendfile(out_fd, in_fd, offset ? (off_t __user *)&of : NULL,
-			   count);
-	set_fs(old_fs);
-
-	if (offset && put_user(of, offset))
-		return -EFAULT;
-	return ret;
-}
-
-
 /*
  * The usual compat_sys_msgsnd() and _msgrcv() seem to be assuming
  * some different calling convention than our normal 32-bit tile code.
@@ -177,6 +157,10 @@ long tile_compat_sys_msgrcv(int msqid,
 /* Pass full 64-bit values through ptrace. */
 #define compat_sys_ptrace tile_compat_sys_ptrace
 
+/*
+ * Note that we can't include <linux/unistd.h> here since the header
+ * guard will defeat us; <asm/unistd.h> checks for __SYSCALL as well.
+ */
 void *compat_sys_call_table[__NR_syscalls] = {
 	[0 ... __NR_syscalls-1] = sys_ni_syscall,
 #include <asm/unistd.h>
diff --git a/arch/tile/kernel/compat_signal.c b/arch/tile/kernel/compat_signal.c
index 9fa4ba8..d5efb21 100644
--- a/arch/tile/kernel/compat_signal.c
+++ b/arch/tile/kernel/compat_signal.c
@@ -32,13 +32,14 @@
 #include <asm/processor.h>
 #include <asm/ucontext.h>
 #include <asm/sigframe.h>
+#include <asm/syscalls.h>
 #include <arch/interrupts.h>
 
 struct compat_sigaction {
 	compat_uptr_t sa_handler;
 	compat_ulong_t sa_flags;
 	compat_uptr_t sa_restorer;
-	sigset_t sa_mask;		/* mask last for extensibility */
+	sigset_t sa_mask __packed;
 };
 
 struct compat_sigaltstack {
@@ -170,7 +171,7 @@ long compat_sys_rt_sigqueueinfo(int pid, int sig,
 	if (copy_siginfo_from_user32(&info, uinfo))
 		return -EFAULT;
 	set_fs(KERNEL_DS);
-	ret = sys_rt_sigqueueinfo(pid, sig, (siginfo_t __user *)&info);
+	ret = sys_rt_sigqueueinfo(pid, sig, (siginfo_t __force __user *)&info);
 	set_fs(old_fs);
 	return ret;
 }
@@ -274,7 +275,8 @@ long _compat_sys_sigaltstack(const struct compat_sigaltstack __user *uss_ptr,
 	}
 	seg = get_fs();
 	set_fs(KERNEL_DS);
-	ret = do_sigaltstack(uss_ptr ? &uss : NULL, &uoss,
+	ret = do_sigaltstack(uss_ptr ? (stack_t __user __force *)&uss : NULL,
+			     (stack_t __user __force *)&uoss,
 			     (unsigned long)compat_ptr(regs->sp));
 	set_fs(seg);
 	if (ret >= 0 && uoss_ptr)  {
@@ -336,7 +338,7 @@ static inline void __user *compat_get_sigframe(struct k_sigaction *ka,
 	 * will die with SIGSEGV.
 	 */
 	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
-		return (void __user *) -1L;
+		return (void __user __force *)-1UL;
 
 	/* This is the X/Open sanctioned signal stack switching.  */
 	if (ka->sa.sa_flags & SA_ONSTACK) {
diff --git a/arch/tile/kernel/early_printk.c b/arch/tile/kernel/early_printk.c
index e44d441..2c54fd4 100644
--- a/arch/tile/kernel/early_printk.c
+++ b/arch/tile/kernel/early_printk.c
@@ -32,7 +32,7 @@ static struct console early_hv_console = {
 };
 
 /* Direct interface for emergencies */
-struct console *early_console = &early_hv_console;
+static struct console *early_console = &early_hv_console;
 static int early_console_initialized;
 static int early_console_complete;
 
diff --git a/arch/tile/kernel/entry.S b/arch/tile/kernel/entry.S
index 136261f..3d01383 100644
--- a/arch/tile/kernel/entry.S
+++ b/arch/tile/kernel/entry.S
@@ -13,9 +13,9 @@
  */
 
 #include <linux/linkage.h>
-#include <arch/abi.h>
-#include <asm/unistd.h>
+#include <linux/unistd.h>
 #include <asm/irqflags.h>
+#include <arch/abi.h>
 
 #ifdef __tilegx__
 #define bnzt bnezt
diff --git a/arch/tile/kernel/machine_kexec.c b/arch/tile/kernel/machine_kexec.c
index ed3e1cb..ba7a265 100644
--- a/arch/tile/kernel/machine_kexec.c
+++ b/arch/tile/kernel/machine_kexec.c
@@ -75,13 +75,13 @@ void machine_crash_shutdown(struct pt_regs *regs)
 int machine_kexec_prepare(struct kimage *image)
 {
 	if (num_online_cpus() > 1) {
-		printk(KERN_WARNING "%s: detected attempt to kexec "
+		pr_warning("%s: detected attempt to kexec "
 		       "with num_online_cpus() > 1\n",
 		       __func__);
 		return -ENOSYS;
 	}
 	if (image->type != KEXEC_TYPE_DEFAULT) {
-		printk(KERN_WARNING "%s: detected attempt to kexec "
+		pr_warning("%s: detected attempt to kexec "
 		       "with unsupported type: %d\n",
 		       __func__,
 		       image->type);
@@ -124,22 +124,13 @@ static unsigned char *kexec_bn2cl(void *pg)
 		return 0;
 
 	/*
-	 * If we get a checksum mismatch, it's possible that this is
-	 * just a false positive, but relatively unlikely.  We dump
-	 * out the contents of the section so we can diagnose better.
+	 * If we get a checksum mismatch, warn with the checksum
+	 * so we can diagnose better.
 	 */
 	csum = ip_compute_csum(pg, bhdrp->b_size);
 	if (csum != 0) {
-		int i;
-		unsigned char *p = pg;
-		int nbytes = min((Elf32_Word)1000, bhdrp->b_size);
-		printk(KERN_INFO "%s: bad checksum %#x\n", __func__, csum);
-		printk(KERN_INFO "bytes (%d):", bhdrp->b_size);
-		for (i = 0; i < nbytes; ++i)
-			printk(" %02x", p[i]);
-		if (bhdrp->b_size != nbytes)
-			printk(" ...");
-		printk("\n");
+		pr_warning("%s: bad checksum %#x (size %d)\n",
+			   __func__, csum, bhdrp->b_size);
 		return 0;
 	}
 
@@ -156,7 +147,7 @@ static unsigned char *kexec_bn2cl(void *pg)
 		if ((unsigned char *) (nhdrp + 1) >
 		    ((unsigned char *) pg) + bhdrp->b_size) {
 
-			printk(KERN_INFO "%s: out of bounds\n", __func__);
+			pr_info("%s: out of bounds\n", __func__);
 			return 0;
 		}
 	}
@@ -167,7 +158,7 @@ static unsigned char *kexec_bn2cl(void *pg)
 	while (*desc != '\0') {
 		desc++;
 		if (((unsigned long)desc & PAGE_MASK) != (unsigned long)pg) {
-			printk(KERN_INFO "%s: ran off end of page\n",
+			pr_info("%s: ran off end of page\n",
 			       __func__);
 			return 0;
 		}
@@ -202,23 +193,20 @@ static void kexec_find_and_set_command_line(struct kimage *image)
 	}
 
 	if (command_line != 0) {
-		printk(KERN_INFO "setting new command line to \"%s\"\n",
+		pr_info("setting new command line to \"%s\"\n",
 		       command_line);
 
 		hverr = hv_set_command_line(
 			(HV_VirtAddr) command_line, strlen(command_line));
 		kunmap_atomic(command_line, KM_USER0);
 	} else {
-		printk(KERN_INFO "%s: no command line found; making empty\n",
+		pr_info("%s: no command line found; making empty\n",
 		       __func__);
 		hverr = hv_set_command_line((HV_VirtAddr) command_line, 0);
 	}
-	if (hverr) {
-		printk(KERN_WARNING
-		      "%s: call to hv_set_command_line returned error: %d\n",
-		      __func__, hverr);
-
-	}
+	if (hverr)
+		pr_warning("%s: hv_set_command_line returned error: %d\n",
+			   __func__, hverr);
 }
 
 /*
diff --git a/arch/tile/kernel/messaging.c b/arch/tile/kernel/messaging.c
index f991f52..6d23ed2 100644
--- a/arch/tile/kernel/messaging.c
+++ b/arch/tile/kernel/messaging.c
@@ -18,13 +18,14 @@
 #include <linux/ptrace.h>
 #include <asm/hv_driver.h>
 #include <asm/irq_regs.h>
+#include <asm/traps.h>
 #include <hv/hypervisor.h>
 #include <arch/interrupts.h>
 
 /* All messages are stored here */
 static DEFINE_PER_CPU(HV_MsgState, msg_state);
 
-void __cpuinit init_messaging()
+void __cpuinit init_messaging(void)
 {
 	/* Allocate storage for messages in kernel space */
 	HV_MsgState *state = &__get_cpu_var(msg_state);
@@ -58,7 +59,7 @@ void hv_message_intr(struct pt_regs *regs, int intnum)
 	{
 		long sp = stack_pointer - (long) current_thread_info();
 		if (unlikely(sp < (sizeof(struct thread_info) + STACK_WARN))) {
-			printk(KERN_EMERG "hv_message_intr: "
+			pr_emerg("hv_message_intr: "
 			       "stack overflow: %ld\n",
 			       sp - sizeof(struct thread_info));
 			dump_stack();
diff --git a/arch/tile/kernel/module.c b/arch/tile/kernel/module.c
index ed3e911..e2ab82b 100644
--- a/arch/tile/kernel/module.c
+++ b/arch/tile/kernel/module.c
@@ -107,7 +107,7 @@ int apply_relocate(Elf_Shdr *sechdrs,
 		   unsigned int relsec,
 		   struct module *me)
 {
-	printk(KERN_ERR "module %s: .rel relocation unsupported\n", me->name);
+	pr_err("module %s: .rel relocation unsupported\n", me->name);
 	return -ENOEXEC;
 }
 
@@ -119,8 +119,8 @@ int apply_relocate(Elf_Shdr *sechdrs,
 static int validate_hw2_last(long value, struct module *me)
 {
 	if (((value << 16) >> 16) != value) {
-		printk("module %s: Out of range HW2_LAST value %#lx\n",
-		       me->name, value);
+		pr_warning("module %s: Out of range HW2_LAST value %#lx\n",
+			   me->name, value);
 		return 0;
 	}
 	return 1;
@@ -223,10 +223,10 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 			value -= (unsigned long) location;  /* pc-relative */
 			value = (long) value >> 3;     /* count by instrs */
 			if (!validate_jumpoff(value)) {
-				printk("module %s: Out of range jump to"
-				       " %#llx at %#llx (%p)\n", me->name,
-				       sym->st_value + rel[i].r_addend,
-				       rel[i].r_offset, location);
+				pr_warning("module %s: Out of range jump to"
+					   " %#llx at %#llx (%p)\n", me->name,
+					   sym->st_value + rel[i].r_addend,
+					   rel[i].r_offset, location);
 				return -ENOEXEC;
 			}
 			MUNGE(create_JumpOff_X1);
@@ -236,7 +236,7 @@ int apply_relocate_add(Elf_Shdr *sechdrs,
 #undef MUNGE
 
 		default:
-			printk(KERN_ERR "module %s: Unknown relocation: %d\n",
+			pr_err("module %s: Unknown relocation: %d\n",
 			       me->name, (int) ELF_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
 		}
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index c70ff14..ed590ad 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -24,9 +24,14 @@
 #include <linux/compat.h>
 #include <linux/hardirq.h>
 #include <linux/syscalls.h>
+#include <linux/kernel.h>
 #include <asm/system.h>
 #include <asm/stack.h>
 #include <asm/homecache.h>
+#include <asm/syscalls.h>
+#ifdef CONFIG_HARDWALL
+#include <asm/hardwall.h>
+#endif
 #include <arch/chip.h>
 #include <arch/abi.h>
 
@@ -43,7 +48,7 @@ static int __init idle_setup(char *str)
 		return -EINVAL;
 
 	if (!strcmp(str, "poll")) {
-		printk("using polling idle threads.\n");
+		pr_info("using polling idle threads.\n");
 		no_idle_nap = 1;
 	} else if (!strcmp(str, "halt"))
 		no_idle_nap = 0;
@@ -62,7 +67,6 @@ early_param("idle", idle_setup);
  */
 void cpu_idle(void)
 {
-	extern void _cpu_idle(void);
 	int cpu = smp_processor_id();
 
 
@@ -108,7 +112,7 @@ void cpu_idle(void)
 struct thread_info *alloc_thread_info(struct task_struct *task)
 {
 	struct page *page;
-	int flags = GFP_KERNEL;
+	gfp_t flags = GFP_KERNEL;
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	flags |= __GFP_ZERO;
@@ -116,7 +120,7 @@ struct thread_info *alloc_thread_info(struct task_struct *task)
 
 	page = alloc_pages(flags, THREAD_SIZE_ORDER);
 	if (!page)
-		return 0;
+		return NULL;
 
 	return (struct thread_info *)page_address(page);
 }
@@ -129,6 +133,18 @@ void free_thread_info(struct thread_info *info)
 {
 	struct single_step_state *step_state = info->step_state;
 
+#ifdef CONFIG_HARDWALL
+	/*
+	 * We free a thread_info from the context of the task that has
+	 * been scheduled next, so the original task is already dead.
+	 * Calling deactivate here just frees up the data structures.
+	 * If the task we're freeing held the last reference to a
+	 * hardwall fd, it would have been released prior to this point
+	 * anyway via exit_files(), and "hardwall" would be NULL by now.
+	 */
+	if (info->task->thread.hardwall)
+		hardwall_deactivate(info->task);
+#endif
 
 	if (step_state) {
 
@@ -154,8 +170,6 @@ void free_thread_info(struct thread_info *info)
 
 static void save_arch_state(struct thread_struct *t);
 
-extern void ret_from_fork(void);
-
 int copy_thread(unsigned long clone_flags, unsigned long sp,
 		unsigned long stack_size,
 		struct task_struct *p, struct pt_regs *regs)
@@ -235,6 +249,10 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	p->thread.proc_status = 0;
 #endif
 
+#ifdef CONFIG_HARDWALL
+	/* New thread does not own any networks. */
+	p->thread.hardwall = NULL;
+#endif
 
 
 	/*
@@ -257,7 +275,7 @@ struct task_struct *validate_current(void)
 	if (unlikely((unsigned long)tsk < PAGE_OFFSET ||
 		     (void *)tsk > high_memory ||
 		     ((unsigned long)tsk & (__alignof__(*tsk) - 1)) != 0)) {
-		printk("Corrupt 'current' %p (sp %#lx)\n", tsk, stack_pointer);
+		pr_err("Corrupt 'current' %p (sp %#lx)\n", tsk, stack_pointer);
 		tsk = &corrupt;
 	}
 	return tsk;
@@ -447,10 +465,6 @@ void _prepare_arch_switch(struct task_struct *next)
 }
 
 
-extern struct task_struct *__switch_to(struct task_struct *prev,
-				       struct task_struct *next,
-				       unsigned long new_system_save_1_0);
-
 struct task_struct *__sched _switch_to(struct task_struct *prev,
 				       struct task_struct *next)
 {
@@ -486,6 +500,15 @@ struct task_struct *__sched _switch_to(struct task_struct *prev,
 	}
 #endif
 
+#ifdef CONFIG_HARDWALL
+	/* Enable or disable access to the network registers appropriately. */
+	if (prev->thread.hardwall != NULL) {
+		if (next->thread.hardwall == NULL)
+			restrict_network_mpls();
+	} else if (next->thread.hardwall != NULL) {
+		grant_network_mpls();
+	}
+#endif
 
 	/*
 	 * Switch kernel SP, PC, and callee-saved registers.
@@ -496,14 +519,14 @@ struct task_struct *__sched _switch_to(struct task_struct *prev,
 	return __switch_to(prev, next, next_current_ksp0(next));
 }
 
-int _sys_fork(struct pt_regs *regs)
+long _sys_fork(struct pt_regs *regs)
 {
 	return do_fork(SIGCHLD, regs->sp, regs, 0, NULL, NULL);
 }
 
-int _sys_clone(unsigned long clone_flags, unsigned long newsp,
-	       void __user *parent_tidptr, void __user *child_tidptr,
-	       struct pt_regs *regs)
+long _sys_clone(unsigned long clone_flags, unsigned long newsp,
+		void __user *parent_tidptr, void __user *child_tidptr,
+		struct pt_regs *regs)
 {
 	if (!newsp)
 		newsp = regs->sp;
@@ -511,7 +534,7 @@ int _sys_clone(unsigned long clone_flags, unsigned long newsp,
 		       parent_tidptr, child_tidptr);
 }
 
-int _sys_vfork(struct pt_regs *regs)
+long _sys_vfork(struct pt_regs *regs)
 {
 	return do_fork(CLONE_VFORK | CLONE_VM | SIGCHLD, regs->sp,
 		       regs, 0, NULL, NULL);
@@ -520,10 +543,10 @@ int _sys_vfork(struct pt_regs *regs)
 /*
  * sys_execve() executes a new program.
  */
-int _sys_execve(char __user *path, char __user *__user *argv,
-		char __user *__user *envp, struct pt_regs *regs)
+long _sys_execve(char __user *path, char __user *__user *argv,
+		 char __user *__user *envp, struct pt_regs *regs)
 {
-	int error;
+	long error;
 	char *filename;
 
 	filename = getname(path);
@@ -537,10 +560,10 @@ out:
 }
 
 #ifdef CONFIG_COMPAT
-int _compat_sys_execve(char __user *path, compat_uptr_t __user *argv,
-		       compat_uptr_t __user *envp, struct pt_regs *regs)
+long _compat_sys_execve(char __user *path, compat_uptr_t __user *argv,
+			compat_uptr_t __user *envp, struct pt_regs *regs)
 {
-	int error;
+	long error;
 	char *filename;
 
 	filename = getname(path);
@@ -616,31 +639,32 @@ void exit_thread(void)
 	/* Nothing */
 }
 
-#ifdef __tilegx__
-# define LINECOUNT 3
-# define EXTRA_NL "\n"
-#else
-# define LINECOUNT 4
-# define EXTRA_NL ""
-#endif
-
 void show_regs(struct pt_regs *regs)
 {
 	struct task_struct *tsk = validate_current();
-	int i, linebreak;
-	printk("\n");
-	printk(" Pid: %d, comm: %20s, CPU: %d\n",
+	int i;
+
+	pr_err("\n");
+	pr_err(" Pid: %d, comm: %20s, CPU: %d\n",
 	       tsk->pid, tsk->comm, smp_processor_id());
-	for (i = linebreak = 0; i < 53; ++i) {
-		printk(" r%-2d: "REGFMT, i, regs->regs[i]);
-		if (++linebreak == LINECOUNT) {
-			linebreak = 0;
-			printk("\n");
-		}
-	}
-	printk(" tp : "REGFMT EXTRA_NL " sp : "REGFMT" lr : "REGFMT"\n",
-	       regs->tp, regs->sp, regs->lr);
-	printk(" pc : "REGFMT" ex1: %ld     faultnum: %ld\n",
+#ifdef __tilegx__
+	for (i = 0; i < 51; i += 3)
+		pr_err(" r%-2d: "REGFMT" r%-2d: "REGFMT" r%-2d: "REGFMT"\n",
+		       i, regs->regs[i], i+1, regs->regs[i+1],
+		       i+2, regs->regs[i+2]);
+	pr_err(" r51: "REGFMT" r52: "REGFMT" tp : "REGFMT"\n",
+	       regs->regs[51], regs->regs[52], regs->tp);
+	pr_err(" sp : "REGFMT" lr : "REGFMT"\n", regs->sp, regs->lr);
+#else
+	for (i = 0; i < 52; i += 3)
+		pr_err(" r%-2d: "REGFMT" r%-2d: "REGFMT
+		       " r%-2d: "REGFMT" r%-2d: "REGFMT"\n",
+		       i, regs->regs[i], i+1, regs->regs[i+1],
+		       i+2, regs->regs[i+2], i+3, regs->regs[i+3]);
+	pr_err(" r52: "REGFMT" tp : "REGFMT" sp : "REGFMT" lr : "REGFMT"\n",
+	       regs->regs[52], regs->tp, regs->sp, regs->lr);
+#endif
+	pr_err(" pc : "REGFMT" ex1: %ld     faultnum: %ld\n",
 	       regs->pc, regs->ex1, regs->faultnum);
 
 	dump_stack_regs(regs);
diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index 4680549..e5701d1 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -19,6 +19,7 @@
 #include <linux/kprobes.h>
 #include <linux/compat.h>
 #include <linux/uaccess.h>
+#include <asm/traps.h>
 
 void user_enable_single_step(struct task_struct *child)
 {
@@ -76,7 +77,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	if (task_thread_info(child)->status & TS_COMPAT)
 		addr = (u32)addr;
 #endif
-	datap = (unsigned long __user *)data;
+	datap = (unsigned long __user __force *)data;
 
 	switch (request) {
 
diff --git a/arch/tile/kernel/reboot.c b/arch/tile/kernel/reboot.c
index a452392..acd86d2 100644
--- a/arch/tile/kernel/reboot.c
+++ b/arch/tile/kernel/reboot.c
@@ -15,6 +15,7 @@
 #include <linux/stddef.h>
 #include <linux/reboot.h>
 #include <linux/smp.h>
+#include <linux/pm.h>
 #include <asm/page.h>
 #include <asm/setup.h>
 #include <hv/hypervisor.h>
@@ -46,7 +47,5 @@ void machine_restart(char *cmd)
 	hv_restart((HV_VirtAddr) "vmlinux", (HV_VirtAddr) cmd);
 }
 
-/*
- * Power off function, if any
- */
-void (*pm_power_off)(void) = machine_power_off;
+/* No interesting distinction to be made here. */
+void (*pm_power_off)(void) = NULL;
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 934136b..4dd21c1 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -20,6 +20,7 @@
 #include <linux/node.h>
 #include <linux/cpu.h>
 #include <linux/ioport.h>
+#include <linux/irq.h>
 #include <linux/kexec.h>
 #include <linux/pci.h>
 #include <linux/initrd.h>
@@ -109,7 +110,7 @@ static int __init setup_maxmem(char *str)
 
 	maxmem_pfn = (maxmem_mb >> (HPAGE_SHIFT - 20)) <<
 		(HPAGE_SHIFT - PAGE_SHIFT);
-	printk("Forcing RAM used to no more than %dMB\n",
+	pr_info("Forcing RAM used to no more than %dMB\n",
 	       maxmem_pfn >> (20 - PAGE_SHIFT));
 	return 0;
 }
@@ -127,7 +128,7 @@ static int __init setup_maxnodemem(char *str)
 
 	maxnodemem_pfn[node] = (maxnodemem_mb >> (HPAGE_SHIFT - 20)) <<
 		(HPAGE_SHIFT - PAGE_SHIFT);
-	printk("Forcing RAM used on node %ld to no more than %dMB\n",
+	pr_info("Forcing RAM used on node %ld to no more than %dMB\n",
 	       node, maxnodemem_pfn[node] >> (20 - PAGE_SHIFT));
 	return 0;
 }
@@ -140,7 +141,7 @@ static int __init setup_isolnodes(char *str)
 		return -EINVAL;
 
 	nodelist_scnprintf(buf, sizeof(buf), isolnodes);
-	printk("Set isolnodes value to '%s'\n", buf);
+	pr_info("Set isolnodes value to '%s'\n", buf);
 	return 0;
 }
 early_param("isolnodes", setup_isolnodes);
@@ -155,7 +156,7 @@ static int __init setup_pci_reserve(char* str)
 		return -EINVAL;
 
 	pci_reserve_mb = mb;
-	printk("Reserving %dMB for PCIE root complex mappings\n",
+	pr_info("Reserving %dMB for PCIE root complex mappings\n",
 	       pci_reserve_mb);
 	return 0;
 }
@@ -269,7 +270,7 @@ static void *__init setup_pa_va_mapping(void)
  * This is up to 4 mappings for lowmem, one mapping per memory
  * controller, plus one for our text segment.
  */
-void __cpuinit store_permanent_mappings(void)
+static void __cpuinit store_permanent_mappings(void)
 {
 	int i;
 
@@ -320,14 +321,14 @@ static void __init setup_memory(void)
 			break;
 #ifdef CONFIG_FLATMEM
 		if (i > 0) {
-			printk("Can't use discontiguous PAs: %#llx..%#llx\n",
+			pr_err("Can't use discontiguous PAs: %#llx..%#llx\n",
 			       range.size, range.start + range.size);
 			continue;
 		}
 #endif
 #ifndef __tilegx__
 		if ((unsigned long)range.start) {
-			printk("Range not at 4GB multiple: %#llx..%#llx\n",
+			pr_err("Range not at 4GB multiple: %#llx..%#llx\n",
 			       range.start, range.start + range.size);
 			continue;
 		}
@@ -335,51 +336,51 @@ static void __init setup_memory(void)
 		if ((range.start & (HPAGE_SIZE-1)) != 0 ||
 		    (range.size & (HPAGE_SIZE-1)) != 0) {
 			unsigned long long start_pa = range.start;
-			unsigned long long size = range.size;
+			unsigned long long orig_size = range.size;
 			range.start = (start_pa + HPAGE_SIZE - 1) & HPAGE_MASK;
 			range.size -= (range.start - start_pa);
 			range.size &= HPAGE_MASK;
-			printk("Range not hugepage-aligned: %#llx..%#llx:"
+			pr_err("Range not hugepage-aligned: %#llx..%#llx:"
 			       " now %#llx-%#llx\n",
-			       start_pa, start_pa + size,
+			       start_pa, start_pa + orig_size,
 			       range.start, range.start + range.size);
 		}
 		highbits = __pa_to_highbits(range.start);
 		if (highbits >= NR_PA_HIGHBIT_VALUES) {
-			printk("PA high bits too high: %#llx..%#llx\n",
+			pr_err("PA high bits too high: %#llx..%#llx\n",
 			       range.start, range.start + range.size);
 			continue;
 		}
 		if (highbits_seen[highbits]) {
-			printk("Range overlaps in high bits: %#llx..%#llx\n",
+			pr_err("Range overlaps in high bits: %#llx..%#llx\n",
 			       range.start, range.start + range.size);
 			continue;
 		}
 		highbits_seen[highbits] = 1;
 		if (PFN_DOWN(range.size) > maxnodemem_pfn[i]) {
-			int size = maxnodemem_pfn[i];
-			if (size > 0) {
-				printk("Maxnodemem reduced node %d to"
-				       " %d pages\n", i, size);
-				range.size = (HV_PhysAddr)size << PAGE_SHIFT;
+			int max_size = maxnodemem_pfn[i];
+			if (max_size > 0) {
+				pr_err("Maxnodemem reduced node %d to"
+				       " %d pages\n", i, max_size);
+				range.size = PFN_PHYS(max_size);
 			} else {
-				printk("Maxnodemem disabled node %d\n", i);
+				pr_err("Maxnodemem disabled node %d\n", i);
 				continue;
 			}
 		}
 		if (num_physpages + PFN_DOWN(range.size) > maxmem_pfn) {
-			int size = maxmem_pfn - num_physpages;
-			if (size > 0) {
-				printk("Maxmem reduced node %d to %d pages\n",
-				       i, size);
-				range.size = (HV_PhysAddr)size << PAGE_SHIFT;
+			int max_size = maxmem_pfn - num_physpages;
+			if (max_size > 0) {
+				pr_err("Maxmem reduced node %d to %d pages\n",
+				       i, max_size);
+				range.size = PFN_PHYS(max_size);
 			} else {
-				printk("Maxmem disabled node %d\n", i);
+				pr_err("Maxmem disabled node %d\n", i);
 				continue;
 			}
 		}
 		if (i >= MAX_NUMNODES) {
-			printk("Too many PA nodes (#%d): %#llx...%#llx\n",
+			pr_err("Too many PA nodes (#%d): %#llx...%#llx\n",
 			       i, range.size, range.size + range.start);
 			continue;
 		}
@@ -391,7 +392,7 @@ static void __init setup_memory(void)
 #ifndef __tilegx__
 		if (((HV_PhysAddr)end << PAGE_SHIFT) !=
 		    (range.start + range.size)) {
-			printk("PAs too high to represent: %#llx..%#llx\n",
+			pr_err("PAs too high to represent: %#llx..%#llx\n",
 			       range.start, range.start + range.size);
 			continue;
 		}
@@ -412,7 +413,7 @@ static void __init setup_memory(void)
 				NR_CPUS * (PFN_UP(per_cpu_size) >> PAGE_SHIFT);
 			if (end < pci_reserve_end_pfn + percpu_pages) {
 				end = pci_reserve_start_pfn;
-				printk("PCI mapping region reduced node %d to"
+				pr_err("PCI mapping region reduced node %d to"
 				       " %ld pages\n", i, end - start);
 			}
 		}
@@ -456,11 +457,11 @@ static void __init setup_memory(void)
 			}
 		}
 		num_physpages -= dropped_pages;
-		printk(KERN_WARNING "Only using %ldMB memory;"
+		pr_warning("Only using %ldMB memory;"
 		       " ignoring %ldMB.\n",
 		       num_physpages >> (20 - PAGE_SHIFT),
 		       dropped_pages >> (20 - PAGE_SHIFT));
-		printk(KERN_WARNING "Consider using a larger page size.\n");
+		pr_warning("Consider using a larger page size.\n");
 	}
 #endif
 
@@ -478,9 +479,9 @@ static void __init setup_memory(void)
 		MAXMEM_PFN : mappable_physpages;
 	highmem_pages = (long) (num_physpages - lowmem_pages);
 
-	printk(KERN_NOTICE "%ldMB HIGHMEM available.\n",
+	pr_notice("%ldMB HIGHMEM available.\n",
 	       pages_to_mb(highmem_pages > 0 ? highmem_pages : 0));
-	printk(KERN_NOTICE "%ldMB LOWMEM available.\n",
+	pr_notice("%ldMB LOWMEM available.\n",
 			pages_to_mb(lowmem_pages));
 #else
 	/* Set max_low_pfn based on what node 0 can directly address. */
@@ -488,15 +489,15 @@ static void __init setup_memory(void)
 
 #ifndef __tilegx__
 	if (node_end_pfn[0] > MAXMEM_PFN) {
-		printk(KERN_WARNING "Only using %ldMB LOWMEM.\n",
+		pr_warning("Only using %ldMB LOWMEM.\n",
 		       MAXMEM>>20);
-		printk(KERN_WARNING "Use a HIGHMEM enabled kernel.\n");
+		pr_warning("Use a HIGHMEM enabled kernel.\n");
 		max_low_pfn = MAXMEM_PFN;
 		max_pfn = MAXMEM_PFN;
 		num_physpages = MAXMEM_PFN;
 		node_end_pfn[0] = MAXMEM_PFN;
 	} else {
-		printk(KERN_NOTICE "%ldMB memory available.\n",
+		pr_notice("%ldMB memory available.\n",
 		       pages_to_mb(node_end_pfn[0]));
 	}
 	for (i = 1; i < MAX_NUMNODES; ++i) {
@@ -512,7 +513,7 @@ static void __init setup_memory(void)
 		if (pages)
 			high_memory = pfn_to_kaddr(node_end_pfn[i]);
 	}
-	printk(KERN_NOTICE "%ldMB memory available.\n",
+	pr_notice("%ldMB memory available.\n",
 	       pages_to_mb(lowmem_pages));
 #endif
 #endif
@@ -744,7 +745,7 @@ static void __init setup_numa_mapping(void)
 	nodes_andnot(default_nodes, node_online_map, isolnodes);
 	if (nodes_empty(default_nodes)) {
 		BUG_ON(!node_isset(0, node_online_map));
-		printk("Forcing NUMA node zero available as a default node\n");
+		pr_err("Forcing NUMA node zero available as a default node\n");
 		node_set(0, default_nodes);
 	}
 
@@ -822,13 +823,13 @@ static void __init setup_numa_mapping(void)
 		printk(KERN_DEBUG "NUMA cpu-to-node row %d:", y);
 		for (x = 0; x < smp_width; ++x, ++cpu) {
 			if (cpu_to_node(cpu) < 0) {
-				printk(" -");
+				pr_cont(" -");
 				cpu_2_node[cpu] = first_node(default_nodes);
 			} else {
-				printk(" %d", cpu_to_node(cpu));
+				pr_cont(" %d", cpu_to_node(cpu));
 			}
 		}
-		printk("\n");
+		pr_cont("\n");
 	}
 }
 
@@ -856,12 +857,17 @@ subsys_initcall(topology_init);
 #endif /* CONFIG_NUMA */
 
 /**
- * setup_mpls() - Allow the user-space code to access various SPRs.
+ * setup_cpu() - Do all necessary per-cpu, tile-specific initialization.
+ * @boot: Is this the boot cpu?
  *
- * Also called from online_secondary().
+ * Called from setup_arch() on the boot cpu, or online_secondary().
  */
-void __cpuinit setup_mpls(void)
+void __cpuinit setup_cpu(int boot)
 {
+	/* The boot cpu sets up its permanent mappings much earlier. */
+	if (!boot)
+		store_permanent_mappings();
+
 	/* Allow asynchronous TLB interrupts. */
 #if CHIP_HAS_TILE_DMA()
 	raw_local_irq_unmask(INT_DMATLB_MISS);
@@ -892,6 +898,14 @@ void __cpuinit setup_mpls(void)
 	 * as well as the PL 0 interrupt mask.
 	 */
 	__insn_mtspr(SPR_MPL_INTCTRL_0_SET_0, 1);
+
+	/* Initialize IRQ support for this cpu. */
+	setup_irq_regs();
+
+#ifdef CONFIG_HARDWALL
+	/* Reset the network state on this cpu. */
+	reset_network_state();
+#endif
 }
 
 static int __initdata set_initramfs_file;
@@ -922,22 +936,22 @@ static void __init load_hv_initrd(void)
 	fd = hv_fs_findfile((HV_VirtAddr) initramfs_file);
 	if (fd == HV_ENOENT) {
 		if (set_initramfs_file)
-			printk("No such hvfs initramfs file '%s'\n",
-			       initramfs_file);
+			pr_warning("No such hvfs initramfs file '%s'\n",
+				   initramfs_file);
 		return;
 	}
 	BUG_ON(fd < 0);
 	stat = hv_fs_fstat(fd);
 	BUG_ON(stat.size < 0);
 	if (stat.flags & HV_FS_ISDIR) {
-		printk("Ignoring hvfs file '%s': it's a directory.\n",
-		       initramfs_file);
+		pr_warning("Ignoring hvfs file '%s': it's a directory.\n",
+			   initramfs_file);
 		return;
 	}
 	initrd = alloc_bootmem_pages(stat.size);
 	rc = hv_fs_pread(fd, (HV_VirtAddr) initrd, stat.size, 0);
 	if (rc != stat.size) {
-		printk("Error reading %d bytes from hvfs file '%s': %d\n",
+		pr_err("Error reading %d bytes from hvfs file '%s': %d\n",
 		       stat.size, initramfs_file, rc);
 		free_bootmem((unsigned long) initrd, stat.size);
 		return;
@@ -966,9 +980,9 @@ static void __init validate_hv(void)
 	HV_Topology topology = hv_inquire_topology();
 	BUG_ON(topology.coord.x != 0 || topology.coord.y != 0);
 	if (topology.width != 1 || topology.height != 1) {
-		printk("Warning: booting UP kernel on %dx%d grid;"
-		       " will ignore all but first tile.\n",
-		       topology.width, topology.height);
+		pr_warning("Warning: booting UP kernel on %dx%d grid;"
+			   " will ignore all but first tile.\n",
+			   topology.width, topology.height);
 	}
 #endif
 
@@ -1004,7 +1018,7 @@ static void __init validate_hv(void)
 
 	if (hv_confstr(HV_CONFSTR_CHIP_MODEL, (HV_VirtAddr)chip_model,
 		       sizeof(chip_model)) < 0) {
-		printk("Warning: HV_CONFSTR_CHIP_MODEL not available\n");
+		pr_err("Warning: HV_CONFSTR_CHIP_MODEL not available\n");
 		strlcpy(chip_model, "unknown", sizeof(chip_model));
 	}
 }
@@ -1096,7 +1110,7 @@ static int __init disabled_cpus(char *str)
 	if (str == NULL || cpulist_parse_crop(str, &disabled_map) != 0)
 		return -EINVAL;
 	if (cpumask_test_cpu(boot_cpu, &disabled_map)) {
-		printk("disabled_cpus: can't disable boot cpu %d\n", boot_cpu);
+		pr_err("disabled_cpus: can't disable boot cpu %d\n", boot_cpu);
 		cpumask_clear_cpu(boot_cpu, &disabled_map);
 	}
 	return 0;
@@ -1104,12 +1118,12 @@ static int __init disabled_cpus(char *str)
 
 early_param("disabled_cpus", disabled_cpus);
 
-void __init print_disabled_cpus()
+void __init print_disabled_cpus(void)
 {
 	if (!cpumask_empty(&disabled_map)) {
 		char buf[100];
 		cpulist_scnprintf(buf, sizeof(buf), &disabled_map);
-		printk(KERN_INFO "CPUs not available for Linux: %s\n", buf);
+		pr_info("CPUs not available for Linux: %s\n", buf);
 	}
 }
 
@@ -1162,7 +1176,7 @@ static void __init setup_cpu_maps(void)
 			      (HV_VirtAddr) cpumask_bits(&cpu_lotar_map),
 			      sizeof(cpu_lotar_map));
 	if (rc < 0) {
-		printk("warning: no HV_INQ_TILES_LOTAR; using AVAIL\n");
+		pr_err("warning: no HV_INQ_TILES_LOTAR; using AVAIL\n");
 		cpu_lotar_map = cpu_possible_map;
 	}
 
@@ -1182,7 +1196,7 @@ static void __init setup_cpu_maps(void)
 
 static int __init dataplane(char *str)
 {
-	printk("WARNING: dataplane support disabled in this kernel\n");
+	pr_warning("WARNING: dataplane support disabled in this kernel\n");
 	return 0;
 }
 
@@ -1200,8 +1214,8 @@ void __init setup_arch(char **cmdline_p)
 	len = hv_get_command_line((HV_VirtAddr) boot_command_line,
 				  COMMAND_LINE_SIZE);
 	if (boot_command_line[0])
-		printk("WARNING: ignoring dynamic command line \"%s\"\n",
-		       boot_command_line);
+		pr_warning("WARNING: ignoring dynamic command line \"%s\"\n",
+			   boot_command_line);
 	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
 #else
 	char *hv_cmdline;
@@ -1269,7 +1283,7 @@ void __init setup_arch(char **cmdline_p)
 	setup_numa_mapping();
 	zone_sizes_init();
 	set_page_homes();
-	setup_mpls();
+	setup_cpu(1);
 	setup_clock();
 	load_hv_initrd();
 }
diff --git a/arch/tile/kernel/signal.c b/arch/tile/kernel/signal.c
index 45835cf..45b66a3 100644
--- a/arch/tile/kernel/signal.c
+++ b/arch/tile/kernel/signal.c
@@ -33,6 +33,7 @@
 #include <asm/processor.h>
 #include <asm/ucontext.h>
 #include <asm/sigframe.h>
+#include <asm/syscalls.h>
 #include <arch/interrupts.h>
 
 #define DEBUG_SIG 0
@@ -40,11 +41,8 @@
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
 
 
-/* Caller before callee in this file; other callee is in assembler */
-void do_signal(struct pt_regs *regs);
-
 long _sys_sigaltstack(const stack_t __user *uss,
-                      stack_t __user *uoss, struct pt_regs *regs)
+		      stack_t __user *uoss, struct pt_regs *regs)
 {
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
@@ -65,7 +63,7 @@ int restore_sigcontext(struct pt_regs *regs,
 
 	for (i = 0; i < sizeof(struct pt_regs)/sizeof(long); ++i)
 		err |= __get_user(((long *)regs)[i],
-				  &((long *)(&sc->regs))[i]);
+				  &((long __user *)(&sc->regs))[i]);
 
 	regs->faultnum = INT_SWINT_1_SIGRETURN;
 
@@ -73,7 +71,8 @@ int restore_sigcontext(struct pt_regs *regs,
 	return err;
 }
 
-int _sys_rt_sigreturn(struct pt_regs *regs)
+/* sigreturn() returns long since it restores r0 in the interrupted code. */
+long _sys_rt_sigreturn(struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame =
 		(struct rt_sigframe __user *)(regs->sp);
@@ -114,7 +113,7 @@ int setup_sigcontext(struct sigcontext __user *sc, struct pt_regs *regs)
 
 	for (i = 0; i < sizeof(struct pt_regs)/sizeof(long); ++i)
 		err |= __put_user(((long *)regs)[i],
-				  &((long *)(&sc->regs))[i]);
+				  &((long __user *)(&sc->regs))[i]);
 
 	return err;
 }
@@ -137,7 +136,7 @@ static inline void __user *get_sigframe(struct k_sigaction *ka,
 	 * will die with SIGSEGV.
 	 */
 	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
-		return (void __user *) -1L;
+		return (void __user __force *)-1UL;
 
 	/* This is the X/Open sanctioned signal stack switching.  */
 	if (ka->sa.sa_flags & SA_ONSTACK) {
@@ -185,8 +184,8 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	/* Create the ucontext.  */
 	err |= __clear_user(&frame->save_area, sizeof(frame->save_area));
 	err |= __put_user(0, &frame->uc.uc_flags);
-	err |= __put_user(0, &frame->uc.uc_link);
-	err |= __put_user((void *)(current->sas_ss_sp),
+	err |= __put_user(NULL, &frame->uc.uc_link);
+	err |= __put_user((void __user *)(current->sas_ss_sp),
 			  &frame->uc.uc_stack.ss_sp);
 	err |= __put_user(sas_ss_flags(regs->sp),
 			  &frame->uc.uc_stack.ss_flags);
diff --git a/arch/tile/kernel/single_step.c b/arch/tile/kernel/single_step.c
index 266aae1..5ec4b9c 100644
--- a/arch/tile/kernel/single_step.c
+++ b/arch/tile/kernel/single_step.c
@@ -23,6 +23,7 @@
 #include <linux/uaccess.h>
 #include <linux/mman.h>
 #include <linux/types.h>
+#include <linux/err.h>
 #include <asm/cacheflush.h>
 #include <asm/opcode-tile.h>
 #include <asm/opcode_constants.h>
@@ -39,8 +40,8 @@ static int __init setup_unaligned_printk(char *str)
 	if (strict_strtol(str, 0, &val) != 0)
 		return 0;
 	unaligned_printk = val;
-	printk("Printk for each unaligned data accesses is %s\n",
-	       unaligned_printk ? "enabled" : "disabled");
+	pr_info("Printk for each unaligned data accesses is %s\n",
+		unaligned_printk ? "enabled" : "disabled");
 	return 1;
 }
 __setup("unaligned_printk=", setup_unaligned_printk);
@@ -113,7 +114,7 @@ static tile_bundle_bits rewrite_load_store_unaligned(
 	enum mem_op mem_op,
 	int size, int sign_ext)
 {
-	unsigned char *addr;
+	unsigned char __user *addr;
 	int val_reg, addr_reg, err, val;
 
 	/* Get address and value registers */
@@ -148,7 +149,7 @@ static tile_bundle_bits rewrite_load_store_unaligned(
 		return bundle;
 
 	/* If it's aligned, don't handle it specially */
-	addr = (void *)regs->regs[addr_reg];
+	addr = (void __user *)regs->regs[addr_reg];
 	if (((unsigned long)addr % size) == 0)
 		return bundle;
 
@@ -183,7 +184,7 @@ static tile_bundle_bits rewrite_load_store_unaligned(
 		siginfo_t info = {
 			.si_signo = SIGSEGV,
 			.si_code = SEGV_MAPERR,
-			.si_addr = (void __user *)addr
+			.si_addr = addr
 		};
 		force_sig_info(info.si_signo, &info, current);
 		return (tile_bundle_bits) 0;
@@ -193,30 +194,33 @@ static tile_bundle_bits rewrite_load_store_unaligned(
 		siginfo_t info = {
 			.si_signo = SIGBUS,
 			.si_code = BUS_ADRALN,
-			.si_addr = (void __user *)addr
+			.si_addr = addr
 		};
 		force_sig_info(info.si_signo, &info, current);
 		return (tile_bundle_bits) 0;
 	}
 
 	if (unaligned_printk || unaligned_fixup_count == 0) {
-		printk("Process %d/%s: PC %#lx: Fixup of"
-		       " unaligned %s at %#lx.\n",
-		       current->pid, current->comm, regs->pc,
-		       (mem_op == MEMOP_LOAD || mem_op == MEMOP_LOAD_POSTINCR) ?
-			 "load" : "store",
-		       (unsigned long)addr);
+		pr_info("Process %d/%s: PC %#lx: Fixup of"
+			" unaligned %s at %#lx.\n",
+			current->pid, current->comm, regs->pc,
+			(mem_op == MEMOP_LOAD ||
+			 mem_op == MEMOP_LOAD_POSTINCR) ?
+			"load" : "store",
+			(unsigned long)addr);
 		if (!unaligned_printk) {
-			printk("\n"
-"Unaligned fixups in the kernel will slow your application considerably.\n"
-"You can find them by writing \"1\" to /proc/sys/tile/unaligned_fixup/printk,\n"
-"which requests the kernel show all unaligned fixups, or writing a \"0\"\n"
-"to /proc/sys/tile/unaligned_fixup/enabled, in which case each unaligned\n"
-"access will become a SIGBUS you can debug. No further warnings will be\n"
-"shown so as to avoid additional slowdown, but you can track the number\n"
-"of fixups performed via /proc/sys/tile/unaligned_fixup/count.\n"
-"Use the tile-addr2line command (see \"info addr2line\") to decode PCs.\n"
-				"\n");
+#define P pr_info
+P("\n");
+P("Unaligned fixups in the kernel will slow your application considerably.\n");
+P("To find them, write a \"1\" to /proc/sys/tile/unaligned_fixup/printk,\n");
+P("which requests the kernel show all unaligned fixups, or write a \"0\"\n");
+P("to /proc/sys/tile/unaligned_fixup/enabled, in which case each unaligned\n");
+P("access will become a SIGBUS you can debug. No further warnings will be\n");
+P("shown so as to avoid additional slowdown, but you can track the number\n");
+P("of fixups performed via /proc/sys/tile/unaligned_fixup/count.\n");
+P("Use the tile-addr2line command (see \"info addr2line\") to decode PCs.\n");
+P("\n");
+#undef P
 		}
 	}
 	++unaligned_fixup_count;
@@ -276,7 +280,7 @@ void single_step_once(struct pt_regs *regs)
 	struct thread_info *info = (void *)current_thread_info();
 	struct single_step_state *state = info->step_state;
 	int is_single_step = test_ti_thread_flag(info, TIF_SINGLESTEP);
-	tile_bundle_bits *buffer, *pc;
+	tile_bundle_bits __user *buffer, *pc;
 	tile_bundle_bits bundle;
 	int temp_reg;
 	int target_reg = TREG_LR;
@@ -306,21 +310,21 @@ void single_step_once(struct pt_regs *regs)
 		/* allocate a page of writable, executable memory */
 		state = kmalloc(sizeof(struct single_step_state), GFP_KERNEL);
 		if (state == NULL) {
-			printk("Out of kernel memory trying to single-step\n");
+			pr_err("Out of kernel memory trying to single-step\n");
 			return;
 		}
 
 		/* allocate a cache line of writable, executable memory */
 		down_write(&current->mm->mmap_sem);
-		buffer = (void *) do_mmap(0, 0, 64,
+		buffer = (void __user *) do_mmap(NULL, 0, 64,
 					  PROT_EXEC | PROT_READ | PROT_WRITE,
 					  MAP_PRIVATE | MAP_ANONYMOUS,
 					  0);
 		up_write(&current->mm->mmap_sem);
 
-		if ((int)buffer < 0 && (int)buffer > -PAGE_SIZE) {
+		if (IS_ERR((void __force *)buffer)) {
 			kfree(state);
-			printk("Out of kernel pages trying to single-step\n");
+			pr_err("Out of kernel pages trying to single-step\n");
 			return;
 		}
 
@@ -349,11 +353,14 @@ void single_step_once(struct pt_regs *regs)
 	if (regs->faultnum == INT_SWINT_1)
 		regs->pc -= 8;
 
-	pc = (tile_bundle_bits *)(regs->pc);
-	bundle = pc[0];
+	pc = (tile_bundle_bits __user *)(regs->pc);
+	if (get_user(bundle, pc) != 0) {
+		pr_err("Couldn't read instruction at %p trying to step\n", pc);
+		return;
+	}
 
 	/* We'll follow the instruction with 2 ill op bundles */
-	state->orig_pc = (unsigned long) pc;
+	state->orig_pc = (unsigned long)pc;
 	state->next_pc = (unsigned long)(pc + 1);
 	state->branch_next_pc = 0;
 	state->update = 0;
@@ -633,7 +640,7 @@ void single_step_once(struct pt_regs *regs)
 	}
 
 	if (err) {
-		printk("Fault when writing to single-step buffer\n");
+		pr_err("Fault when writing to single-step buffer\n");
 		return;
 	}
 
@@ -641,12 +648,12 @@ void single_step_once(struct pt_regs *regs)
 	 * Flush the buffer.
 	 * We do a local flush only, since this is a thread-specific buffer.
 	 */
-	__flush_icache_range((unsigned long) state->buffer,
-			     (unsigned long) buffer);
+	__flush_icache_range((unsigned long)state->buffer,
+			     (unsigned long)buffer);
 
 	/* Indicate enabled */
 	state->is_enabled = is_single_step;
-	regs->pc = (unsigned long) state->buffer;
+	regs->pc = (unsigned long)state->buffer;
 
 	/* Fault immediately if we are coming back from a syscall. */
 	if (regs->faultnum == INT_SWINT_1)
diff --git a/arch/tile/kernel/smpboot.c b/arch/tile/kernel/smpboot.c
index aa3aafd..74d62d0 100644
--- a/arch/tile/kernel/smpboot.c
+++ b/arch/tile/kernel/smpboot.c
@@ -25,19 +25,13 @@
 #include <linux/percpu.h>
 #include <linux/delay.h>
 #include <linux/err.h>
+#include <linux/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
 #include <asm/sections.h>
 
-/*
- * This assembly function is provided in entry.S.
- * When called, it loops on a nap instruction forever.
- * FIXME: should be in a header somewhere.
- */
-extern void smp_nap(void);
-
 /* State of each CPU. */
-DEFINE_PER_CPU(int, cpu_state) = { 0 };
+static DEFINE_PER_CPU(int, cpu_state) = { 0 };
 
 /* The messaging code jumps to this pointer during boot-up */
 unsigned long start_cpu_function_addr;
@@ -74,7 +68,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	 */
 	rc = sched_setaffinity(current->pid, cpumask_of(boot_cpu));
 	if (rc != 0)
-		printk("Couldn't set init affinity to boot cpu (%ld)\n", rc);
+		pr_err("Couldn't set init affinity to boot cpu (%ld)\n", rc);
 
 	/* Print information about disabled and dataplane cpus. */
 	print_disabled_cpus();
@@ -134,13 +128,13 @@ static __init int reset_init_affinity(void)
 {
 	long rc = sched_setaffinity(current->pid, &init_affinity);
 	if (rc != 0)
-		printk(KERN_WARNING "couldn't reset init affinity (%ld)\n",
+		pr_warning("couldn't reset init affinity (%ld)\n",
 		       rc);
 	return 0;
 }
 late_initcall(reset_init_affinity);
 
-struct cpumask cpu_started __cpuinitdata;
+static struct cpumask cpu_started __cpuinitdata;
 
 /*
  * Activate a secondary processor.  Very minimal; don't add anything
@@ -172,9 +166,6 @@ static void __cpuinit start_secondary(void)
 		BUG();
 	enter_lazy_tlb(&init_mm, current);
 
-	/* Enable IRQs. */
-	init_per_tile_IRQs();
-
 	/* Allow hypervisor messages to be received */
 	init_messaging();
 	local_irq_enable();
@@ -182,7 +173,7 @@ static void __cpuinit start_secondary(void)
 	/* Indicate that we're ready to come up. */
 	/* Must not do this before we're ready to receive messages */
 	if (cpumask_test_and_set_cpu(cpuid, &cpu_started)) {
-		printk(KERN_WARNING "CPU#%d already started!\n", cpuid);
+		pr_warning("CPU#%d already started!\n", cpuid);
 		for (;;)
 			local_irq_enable();
 	}
@@ -190,13 +181,10 @@ static void __cpuinit start_secondary(void)
 	smp_nap();
 }
 
-void setup_mpls(void);  /* from kernel/setup.c */
-void store_permanent_mappings(void);
-
 /*
  * Bring a secondary processor online.
  */
-void __cpuinit online_secondary()
+void __cpuinit online_secondary(void)
 {
 	/*
 	 * low-memory mappings have been cleared, flush them from
@@ -222,17 +210,14 @@ void __cpuinit online_secondary()
 	ipi_call_unlock();
 	__get_cpu_var(cpu_state) = CPU_ONLINE;
 
-	/* Set up MPLs for this processor */
-	setup_mpls();
-
+	/* Set up tile-specific state for this cpu. */
+	setup_cpu(0);
 
 	/* Set up tile-timer clock-event device on this cpu */
 	setup_tile_timer();
 
 	preempt_enable();
 
-	store_permanent_mappings();
-
 	cpu_idle();
 }
 
@@ -242,7 +227,7 @@ int __cpuinit __cpu_up(unsigned int cpu)
 	static int timeout;
 	for (; !cpumask_test_cpu(cpu, &cpu_started); timeout++) {
 		if (timeout >= 50000) {
-			printk(KERN_INFO "skipping unresponsive cpu%d\n", cpu);
+			pr_info("skipping unresponsive cpu%d\n", cpu);
 			local_irq_enable();
 			return -EIO;
 		}
@@ -289,5 +274,5 @@ void __init smp_cpus_done(unsigned int max_cpus)
 		;
 	rc = sched_setaffinity(current->pid, cpumask_of(cpu));
 	if (rc != 0)
-		printk("Couldn't set init affinity to cpu %d (%d)\n", cpu, rc);
+		pr_err("Couldn't set init affinity to cpu %d (%d)\n", cpu, rc);
 }
diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
index 382170b..b6268d3 100644
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -56,13 +56,16 @@ static int valid_address(struct KBacktraceIterator *kbt, VirtualAddress address)
 	HV_PTE pte;
 	struct page *page;
 
+	if (l1_pgtable == NULL)
+		return 0;	/* can't read user space in other tasks */
+
 	pte = l1_pgtable[HV_L1_INDEX(address)];
 	if (!hv_pte_get_present(pte))
 		return 0;
 	pfn = hv_pte_get_pfn(pte);
 	if (pte_huge(pte)) {
 		if (!pfn_valid(pfn)) {
-			printk(KERN_ERR "huge page has bad pfn %#lx\n", pfn);
+			pr_err("huge page has bad pfn %#lx\n", pfn);
 			return 0;
 		}
 		return hv_pte_get_present(pte) && hv_pte_get_readable(pte);
@@ -70,7 +73,7 @@ static int valid_address(struct KBacktraceIterator *kbt, VirtualAddress address)
 
 	page = pfn_to_page(pfn);
 	if (PageHighMem(page)) {
-		printk(KERN_ERR "L2 page table not in LOWMEM (%#llx)\n",
+		pr_err("L2 page table not in LOWMEM (%#llx)\n",
 		       HV_PFN_TO_CPA(pfn));
 		return 0;
 	}
@@ -91,13 +94,12 @@ static bool read_memory_func(void *result, VirtualAddress address,
 		/* We only tolerate kernel-space reads of this task's stack */
 		if (!in_kernel_stack(kbt, address))
 			return 0;
-	} else if (kbt->pgtable == NULL) {
-		return 0;	/* can't read user space in other tasks */
 	} else if (!valid_address(kbt, address)) {
 		return 0;	/* invalid user-space address */
 	}
 	pagefault_disable();
-	retval = __copy_from_user_inatomic(result, (const void *)address,
+	retval = __copy_from_user_inatomic(result,
+					   (void __user __force *)address,
 					   size);
 	pagefault_enable();
 	return (retval == 0);
@@ -131,14 +133,14 @@ static struct pt_regs *valid_fault_handler(struct KBacktraceIterator* kbt)
 	    in_kernel_stack(kbt, p->sp) &&
 	    p->sp >= sp) {
 		if (kbt->verbose)
-			printk(KERN_ERR "  <%s while in kernel mode>\n", fault);
+			pr_err("  <%s while in kernel mode>\n", fault);
 	} else if (EX1_PL(p->ex1) == USER_PL &&
 	    p->pc < PAGE_OFFSET &&
 	    p->sp < PAGE_OFFSET) {
 		if (kbt->verbose)
-			printk(KERN_ERR "  <%s while in user mode>\n", fault);
+			pr_err("  <%s while in user mode>\n", fault);
 	} else if (kbt->verbose) {
-		printk(KERN_ERR "  (odd fault: pc %#lx, sp %#lx, ex1 %#lx?)\n",
+		pr_err("  (odd fault: pc %#lx, sp %#lx, ex1 %#lx?)\n",
 		       p->pc, p->sp, p->ex1);
 		p = NULL;
 	}
@@ -166,13 +168,13 @@ static struct pt_regs *valid_sigframe(struct KBacktraceIterator* kbt)
 		if (!valid_address(kbt, b->sp) ||
 		    !valid_address(kbt, sigframe_top)) {
 			if (kbt->verbose)
-				printk("  (odd signal: sp %#lx?)\n",
+				pr_err("  (odd signal: sp %#lx?)\n",
 				       (unsigned long)(b->sp));
 			return NULL;
 		}
 		frame = (struct rt_sigframe *)b->sp;
 		if (kbt->verbose) {
-			printk(KERN_ERR "  <received signal %d>\n",
+			pr_err("  <received signal %d>\n",
 			       frame->info.si_signo);
 		}
 		return &frame->uc.uc_mcontext.regs;
@@ -180,7 +182,7 @@ static struct pt_regs *valid_sigframe(struct KBacktraceIterator* kbt)
 	return NULL;
 }
 
-int KBacktraceIterator_is_sigreturn(struct KBacktraceIterator *kbt)
+static int KBacktraceIterator_is_sigreturn(struct KBacktraceIterator *kbt)
 {
 	return is_sigreturn(kbt->it.pc);
 }
@@ -231,13 +233,13 @@ static void validate_stack(struct pt_regs *regs)
 	unsigned long sp = stack_pointer;
 
 	if (EX1_PL(regs->ex1) == KERNEL_PL && regs->sp >= ksp0) {
-		printk("WARNING: cpu %d: kernel stack page %#lx underrun!\n"
+		pr_err("WARNING: cpu %d: kernel stack page %#lx underrun!\n"
 		       "  sp %#lx (%#lx in caller), caller pc %#lx, lr %#lx\n",
 		       cpu, ksp0_base, sp, regs->sp, regs->pc, regs->lr);
 	}
 
 	else if (sp < ksp0_base + sizeof(struct thread_info)) {
-		printk("WARNING: cpu %d: kernel stack page %#lx overrun!\n"
+		pr_err("WARNING: cpu %d: kernel stack page %#lx overrun!\n"
 		       "  sp %#lx (%#lx in caller), caller pc %#lx, lr %#lx\n",
 		       cpu, ksp0_base, sp, regs->sp, regs->pc, regs->lr);
 	}
@@ -280,7 +282,7 @@ void KBacktraceIterator_init(struct KBacktraceIterator *kbt,
 			if (!PageHighMem(page))
 				kbt->pgtable = __va(pgdir_pa);
 			else
-				printk(KERN_ERR "page table not in LOWMEM"
+				pr_err("page table not in LOWMEM"
 				       " (%#llx)\n", pgdir_pa);
 		}
 		local_flush_tlb_all();
@@ -288,13 +290,12 @@ void KBacktraceIterator_init(struct KBacktraceIterator *kbt,
 	}
 
 	if (regs == NULL) {
-		extern const void *get_switch_to_pc(void);
 		if (is_current || t->state == TASK_RUNNING) {
 			/* Can't do this; we need registers */
 			kbt->end = 1;
 			return;
 		}
-		pc = (ulong) get_switch_to_pc();
+		pc = get_switch_to_pc();
 		lr = t->thread.pc;
 		sp = t->thread.ksp;
 		r52 = 0;
@@ -344,8 +345,8 @@ void tile_show_stack(struct KBacktraceIterator *kbt, int headers)
 		 * then bust_spinlocks() spit out a space in front of us
 		 * and it will mess up our KERN_ERR.
 		 */
-		printk("\n");
-		printk(KERN_ERR "Starting stack dump of tid %d, pid %d (%s)"
+		pr_err("\n");
+		pr_err("Starting stack dump of tid %d, pid %d (%s)"
 		       " on cpu %d at cycle %lld\n",
 		       kbt->task->pid, kbt->task->tgid, kbt->task->comm,
 		       smp_processor_id(), get_cycles());
@@ -385,17 +386,17 @@ void tile_show_stack(struct KBacktraceIterator *kbt, int headers)
 			namebuf[sizeof(namebuf)-1] = '\0';
 		}
 
-		printk(KERN_ERR "  frame %d: 0x%lx %s(sp 0x%lx)\n",
+		pr_err("  frame %d: 0x%lx %s(sp 0x%lx)\n",
 		       i++, address, namebuf, (unsigned long)(kbt->it.sp));
 
 		if (i >= 100) {
-			printk(KERN_ERR "Stack dump truncated"
+			pr_err("Stack dump truncated"
 			       " (%d frames)\n", i);
 			break;
 		}
 	}
 	if (headers)
-		printk(KERN_ERR "Stack dump complete\n");
+		pr_err("Stack dump complete\n");
 }
 EXPORT_SYMBOL(tile_show_stack);
 
diff --git a/arch/tile/kernel/sys.c b/arch/tile/kernel/sys.c
index 0427978..f0f87ea 100644
--- a/arch/tile/kernel/sys.c
+++ b/arch/tile/kernel/sys.c
@@ -27,11 +27,10 @@
 #include <linux/mempolicy.h>
 #include <linux/binfmts.h>
 #include <linux/fs.h>
-#include <linux/syscalls.h>
+#include <linux/compat.h>
 #include <linux/uaccess.h>
 #include <linux/signal.h>
 #include <asm/syscalls.h>
-
 #include <asm/pgtable.h>
 #include <asm/homecache.h>
 #include <arch/chip.h>
@@ -74,10 +73,7 @@ int sys32_fadvise64_64(int fd, u32 offset_lo, u32 offset_hi,
 
 #endif /* 32-bit syscall wrappers */
 
-/*
- * This API uses a 4KB-page-count offset into the file descriptor.
- * It is likely not the right API to use on a 64-bit platform.
- */
+/* Note: used by the compat code even in 64-bit Linux. */
 SYSCALL_DEFINE6(mmap2, unsigned long, addr, unsigned long, len,
 		unsigned long, prot, unsigned long, flags,
 		unsigned long, fd, unsigned long, off_4k)
@@ -89,10 +85,7 @@ SYSCALL_DEFINE6(mmap2, unsigned long, addr, unsigned long, len,
 			      off_4k >> PAGE_ADJUST);
 }
 
-/*
- * This API uses a byte offset into the file descriptor.
- * It is likely not the right API to use on a 32-bit platform.
- */
+#ifdef __tilegx__
 SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 		unsigned long, prot, unsigned long, flags,
 		unsigned long, fd, off_t, offset)
@@ -102,6 +95,7 @@ SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 	return sys_mmap_pgoff(addr, len, prot, flags, fd,
 			      offset >> PAGE_SHIFT);
 }
+#endif
 
 
 /* Provide the actual syscall number to call mapping. */
@@ -116,6 +110,10 @@ SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
 #define sys_sync_file_range sys_sync_file_range2
 #endif
 
+/*
+ * Note that we can't include <linux/unistd.h> here since the header
+ * guard will defeat us; <asm/unistd.h> checks for __SYSCALL as well.
+ */
 void *sys_call_table[__NR_syscalls] = {
 	[0 ... __NR_syscalls-1] = sys_ni_syscall,
 #include <asm/unistd.h>
diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
index 47500a3..b9ab25a 100644
--- a/arch/tile/kernel/time.c
+++ b/arch/tile/kernel/time.c
@@ -23,6 +23,7 @@
 #include <linux/smp.h>
 #include <linux/delay.h>
 #include <asm/irq_regs.h>
+#include <asm/traps.h>
 #include <hv/hypervisor.h>
 #include <arch/interrupts.h>
 #include <arch/spr_def.h>
@@ -45,13 +46,13 @@ static cycles_t cycles_per_sec __write_once;
  */
 #define TILE_MINSEC 5
 
-cycles_t get_clock_rate()
+cycles_t get_clock_rate(void)
 {
 	return cycles_per_sec;
 }
 
 #if CHIP_HAS_SPLIT_CYCLE()
-cycles_t get_cycles()
+cycles_t get_cycles(void)
 {
 	unsigned int high = __insn_mfspr(SPR_CYCLE_HIGH);
 	unsigned int low = __insn_mfspr(SPR_CYCLE_LOW);
@@ -67,7 +68,7 @@ cycles_t get_cycles()
 }
 #endif
 
-cycles_t clocksource_get_cycles(struct clocksource *cs)
+static cycles_t clocksource_get_cycles(struct clocksource *cs)
 {
 	return get_cycles();
 }
diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
index 12cb10f..3870abb 100644
--- a/arch/tile/kernel/traps.c
+++ b/arch/tile/kernel/traps.c
@@ -20,6 +20,9 @@
 #include <linux/uaccess.h>
 #include <linux/ptrace.h>
 #include <asm/opcode-tile.h>
+#include <asm/opcode_constants.h>
+#include <asm/stack.h>
+#include <asm/traps.h>
 
 #include <arch/interrupts.h>
 #include <arch/spr_def.h>
@@ -42,7 +45,7 @@ static int __init setup_unaligned_fixup(char *str)
 	if (strict_strtol(str, 0, &val) != 0)
 		return 0;
 	unaligned_fixup = val;
-	printk("Fixups for unaligned data accesses are %s\n",
+	pr_info("Fixups for unaligned data accesses are %s\n",
 	       unaligned_fixup >= 0 ?
 	       (unaligned_fixup ? "enabled" : "disabled") :
 	       "completely disabled");
@@ -56,7 +59,7 @@ static int dma_disabled;
 
 static int __init nodma(char *str)
 {
-	printk("User-space DMA is disabled\n");
+	pr_info("User-space DMA is disabled\n");
 	dma_disabled = 1;
 	return 1;
 }
@@ -97,20 +100,106 @@ static int retry_gpv(unsigned int gpv_reason)
 
 #endif /* CHIP_HAS_TILE_DMA() */
 
-/* Defined inside do_trap(), below. */
 #ifdef __tilegx__
-extern tilegx_bundle_bits bpt_code;
+#define bundle_bits tilegx_bundle_bits
 #else
-extern tile_bundle_bits bpt_code;
+#define bundle_bits tile_bundle_bits
 #endif
 
+extern bundle_bits bpt_code;
+
+asm(".pushsection .rodata.bpt_code,\"a\";"
+    ".align 8;"
+    "bpt_code: bpt;"
+    ".size bpt_code,.-bpt_code;"
+    ".popsection");
+
+static int special_ill(bundle_bits bundle, int *sigp, int *codep)
+{
+	int sig, code, maxcode;
+
+	if (bundle == bpt_code) {
+		*sigp = SIGTRAP;
+		*codep = TRAP_BRKPT;
+		return 1;
+	}
+
+	/* If it's a "raise" bundle, then "ill" must be in pipe X1. */
+#ifdef __tilegx__
+	if ((bundle & TILEGX_BUNDLE_MODE_MASK) != 0)
+		return 0;
+	if (get_Opcode_X1(bundle) != UNARY_OPCODE_X1)
+		return 0;
+	if (get_UnaryOpcodeExtension_X1(bundle) != ILL_UNARY_OPCODE_X1)
+		return 0;
+#else
+	if (bundle & TILE_BUNDLE_Y_ENCODING_MASK)
+		return 0;
+	if (get_Opcode_X1(bundle) != SHUN_0_OPCODE_X1)
+		return 0;
+	if (get_UnShOpcodeExtension_X1(bundle) != UN_0_SHUN_0_OPCODE_X1)
+		return 0;
+	if (get_UnOpcodeExtension_X1(bundle) != ILL_UN_0_SHUN_0_OPCODE_X1)
+		return 0;
+#endif
+
+	/* Check that the magic distinguishers are set to mean "raise". */
+	if (get_Dest_X1(bundle) != 29 || get_SrcA_X1(bundle) != 37)
+		return 0;
+
+	/* There must be an "addli zero, zero, VAL" in X0. */
+	if (get_Opcode_X0(bundle) != ADDLI_OPCODE_X0)
+		return 0;
+	if (get_Dest_X0(bundle) != TREG_ZERO)
+		return 0;
+	if (get_SrcA_X0(bundle) != TREG_ZERO)
+		return 0;
+
+	/*
+	 * Validate the proposed signal number and si_code value.
+	 * Note that we embed these in the static instruction itself
+	 * so that we perturb the register state as little as possible
+	 * at the time of the actual fault; it's unlikely you'd ever
+	 * need to dynamically choose which kind of fault to raise
+	 * from user space.
+	 */
+	sig = get_Imm16_X0(bundle) & 0x3f;
+	switch (sig) {
+	case SIGILL:
+		maxcode = NSIGILL;
+		break;
+	case SIGFPE:
+		maxcode = NSIGFPE;
+		break;
+	case SIGSEGV:
+		maxcode = NSIGSEGV;
+		break;
+	case SIGBUS:
+		maxcode = NSIGBUS;
+		break;
+	case SIGTRAP:
+		maxcode = NSIGTRAP;
+		break;
+	default:
+		return 0;
+	}
+	code = (get_Imm16_X0(bundle) >> 6) & 0xf;
+	if (code <= 0 || code > maxcode)
+		return 0;
+
+	/* Make it the requested signal. */
+	*sigp = sig;
+	*codep = code | __SI_FAULT;
+	return 1;
+}
+
 void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 		       unsigned long reason)
 {
 	siginfo_t info = { 0 };
 	int signo, code;
 	unsigned long address;
-	__typeof__(bpt_code) instr;
+	bundle_bits instr;
 
 	/* Re-enable interrupts. */
 	local_irq_enable();
@@ -122,10 +211,10 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 	if (!user_mode(regs)) {
 		if (fixup_exception(regs))  /* only UNALIGN_DATA in practice */
 			return;
-		printk(KERN_ALERT "Kernel took bad trap %d at PC %#lx\n",
+		pr_alert("Kernel took bad trap %d at PC %#lx\n",
 		       fault_num, regs->pc);
 		if (fault_num == INT_GPV)
-			printk(KERN_ALERT "GPV_REASON is %#lx\n", reason);
+			pr_alert("GPV_REASON is %#lx\n", reason);
 		show_regs(regs);
 		do_exit(SIGKILL);  /* FIXME: implement i386 die() */
 		return;
@@ -133,22 +222,14 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 
 	switch (fault_num) {
 	case INT_ILL:
-		asm(".pushsection .rodata.bpt_code,\"a\";"
-		    ".align 8;"
-		    "bpt_code: bpt;"
-		    ".size bpt_code,.-bpt_code;"
-		    ".popsection");
-
-		if (copy_from_user(&instr, (void *)regs->pc, sizeof(instr))) {
-			printk(KERN_ERR "Unreadable instruction for INT_ILL:"
+		if (copy_from_user(&instr, (void __user *)regs->pc,
+				   sizeof(instr))) {
+			pr_err("Unreadable instruction for INT_ILL:"
 			       " %#lx\n", regs->pc);
 			do_exit(SIGKILL);
 			return;
 		}
-		if (instr == bpt_code) {
-			signo = SIGTRAP;
-			code = TRAP_BRKPT;
-		} else {
+		if (!special_ill(instr, &signo, &code)) {
 			signo = SIGILL;
 			code = ILL_ILLOPC;
 		}
@@ -181,7 +262,8 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 		if (unaligned_fixup >= 0) {
 			struct single_step_state *state =
 				current_thread_info()->step_state;
-			if (!state || (void *)(regs->pc) != state->buffer) {
+			if (!state ||
+			    (void __user *)(regs->pc) != state->buffer) {
 				single_step_once(regs);
 				return;
 			}
@@ -221,17 +303,15 @@ void __kprobes do_trap(struct pt_regs *regs, int fault_num,
 
 	info.si_signo = signo;
 	info.si_code = code;
-	info.si_addr = (void *)address;
+	info.si_addr = (void __user *)address;
 	if (signo == SIGILL)
 		info.si_trapno = fault_num;
 	force_sig_info(signo, &info, current);
 }
 
-extern void _dump_stack(int dummy, ulong pc, ulong lr, ulong sp, ulong r52);
-
 void kernel_double_fault(int dummy, ulong pc, ulong lr, ulong sp, ulong r52)
 {
 	_dump_stack(dummy, pc, lr, sp, r52);
-	printk("Double fault: exiting\n");
+	pr_emerg("Double fault: exiting\n");
 	machine_halt();
 }
diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
index 77388c1..25fdc0c 100644
--- a/arch/tile/kernel/vmlinux.lds.S
+++ b/arch/tile/kernel/vmlinux.lds.S
@@ -36,8 +36,8 @@ SECTIONS
 
   /* Now the real code */
   . = ALIGN(0x20000);
-  HEAD_TEXT_SECTION :text =0
   .text : AT (ADDR(.text) - LOAD_OFFSET) {
+    HEAD_TEXT
     SCHED_TEXT
     LOCK_TEXT
     __fix_text_end = .;   /* tile-cpack won't rearrange before this */
@@ -46,7 +46,7 @@ SECTIONS
     *(.coldtext*)
     *(.fixup)
     *(.gnu.warning)
-  }
+  } :text =0
   _etext = .;
 
   /* "Init" is divided into two areas with very different virtual addresses. */
diff --git a/arch/tile/lib/atomic_32.c b/arch/tile/lib/atomic_32.c
index be1e8ac..8040b42 100644
--- a/arch/tile/lib/atomic_32.c
+++ b/arch/tile/lib/atomic_32.c
@@ -18,27 +18,10 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <asm/atomic.h>
+#include <asm/futex.h>
 #include <arch/chip.h>
 
-/* The routines in atomic_asm.S are private, so we only declare them here. */
-extern struct __get_user __atomic_cmpxchg(volatile int *p,
-					  int *lock, int o, int n);
-extern struct __get_user __atomic_xchg(volatile int *p, int *lock, int n);
-extern struct __get_user __atomic_xchg_add(volatile int *p, int *lock, int n);
-extern struct __get_user __atomic_xchg_add_unless(volatile int *p,
-						  int *lock, int o, int n);
-extern struct __get_user __atomic_or(volatile int *p, int *lock, int n);
-extern struct __get_user __atomic_andn(volatile int *p, int *lock, int n);
-extern struct __get_user __atomic_xor(volatile int *p, int *lock, int n);
-
-extern u64 __atomic64_cmpxchg(volatile u64 *p, int *lock, u64 o, u64 n);
-extern u64 __atomic64_xchg(volatile u64 *p, int *lock, u64 n);
-extern u64 __atomic64_xchg_add(volatile u64 *p, int *lock, u64 n);
-extern u64 __atomic64_xchg_add_unless(volatile u64 *p,
-				      int *lock, u64 o, u64 n);
-
-
-/* See <asm/atomic.h> */
+/* See <asm/atomic_32.h> */
 #if ATOMIC_LOCKS_FOUND_VIA_TABLE()
 
 /*
@@ -209,7 +192,7 @@ u64 _atomic64_cmpxchg(atomic64_t *v, u64 o, u64 n)
 EXPORT_SYMBOL(_atomic64_cmpxchg);
 
 
-static inline int *__futex_setup(__user int *v)
+static inline int *__futex_setup(int __user *v)
 {
 	/*
 	 * Issue a prefetch to the counter to bring it into cache.
@@ -217,37 +200,37 @@ static inline int *__futex_setup(__user int *v)
 	 * since it might fault; instead we do a prefetch into the L2.
 	 */
 	__insn_prefetch(v);
-	return __atomic_hashed_lock(v);
+	return __atomic_hashed_lock((int __force *)v);
 }
 
-struct __get_user futex_set(int *v, int i)
+struct __get_user futex_set(int __user *v, int i)
 {
-	return __atomic_xchg(v, __futex_setup(v), i);
+	return __atomic_xchg((int __force *)v, __futex_setup(v), i);
 }
 
-struct __get_user futex_add(int *v, int n)
+struct __get_user futex_add(int __user *v, int n)
 {
-	return __atomic_xchg_add(v, __futex_setup(v), n);
+	return __atomic_xchg_add((int __force *)v, __futex_setup(v), n);
 }
 
-struct __get_user futex_or(int *v, int n)
+struct __get_user futex_or(int __user *v, int n)
 {
-	return __atomic_or(v, __futex_setup(v), n);
+	return __atomic_or((int __force *)v, __futex_setup(v), n);
 }
 
-struct __get_user futex_andn(int *v, int n)
+struct __get_user futex_andn(int __user *v, int n)
 {
-	return __atomic_andn(v, __futex_setup(v), n);
+	return __atomic_andn((int __force *)v, __futex_setup(v), n);
 }
 
-struct __get_user futex_xor(int *v, int n)
+struct __get_user futex_xor(int __user *v, int n)
 {
-	return __atomic_xor(v, __futex_setup(v), n);
+	return __atomic_xor((int __force *)v, __futex_setup(v), n);
 }
 
-struct __get_user futex_cmpxchg(int *v, int o, int n)
+struct __get_user futex_cmpxchg(int __user *v, int o, int n)
 {
-	return __atomic_cmpxchg(v, __futex_setup(v), o, n);
+	return __atomic_cmpxchg((int __force *)v, __futex_setup(v), o, n);
 }
 
 /*
@@ -260,7 +243,7 @@ struct __get_user futex_cmpxchg(int *v, int o, int n)
  * invoked in is the context of the "_atomic_xxx()" routines called
  * by the functions in this file.
  */
-struct __get_user __atomic_bad_address(int *addr)
+struct __get_user __atomic_bad_address(int __user *addr)
 {
 	if (unlikely(!access_ok(VERIFY_WRITE, addr, sizeof(int))))
 		panic("Bad address used for kernel atomic op: %p\n", addr);
@@ -271,7 +254,7 @@ struct __get_user __atomic_bad_address(int *addr)
 #if CHIP_HAS_CBOX_HOME_MAP()
 static int __init noatomichash(char *str)
 {
-	printk("noatomichash is deprecated.\n");
+	pr_warning("noatomichash is deprecated.\n");
 	return 1;
 }
 __setup("noatomichash", noatomichash);
diff --git a/arch/tile/lib/cpumask.c b/arch/tile/lib/cpumask.c
index af745b3..fdc4036 100644
--- a/arch/tile/lib/cpumask.c
+++ b/arch/tile/lib/cpumask.c
@@ -15,6 +15,7 @@
 #include <linux/cpumask.h>
 #include <linux/ctype.h>
 #include <linux/errno.h>
+#include <linux/smp.h>
 
 /*
  * Allow cropping out bits beyond the end of the array.
diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
index af8e70e..6bc7b52 100644
--- a/arch/tile/lib/exports.c
+++ b/arch/tile/lib/exports.c
@@ -21,6 +21,7 @@
 EXPORT_SYMBOL(__get_user_1);
 EXPORT_SYMBOL(__get_user_2);
 EXPORT_SYMBOL(__get_user_4);
+EXPORT_SYMBOL(__get_user_8);
 EXPORT_SYMBOL(__put_user_1);
 EXPORT_SYMBOL(__put_user_2);
 EXPORT_SYMBOL(__put_user_4);
diff --git a/arch/tile/lib/memcpy_tile64.c b/arch/tile/lib/memcpy_tile64.c
index 4f00473..dfedea7 100644
--- a/arch/tile/lib/memcpy_tile64.c
+++ b/arch/tile/lib/memcpy_tile64.c
@@ -60,8 +60,8 @@ typedef unsigned long (*memcpy_t)(void *, const void *, unsigned long);
 static void memcpy_multicache(void *dest, const void *source,
 			      pte_t dst_pte, pte_t src_pte, int len)
 {
-	int idx, i;
-	unsigned long flags, newsrc, newdst, endsrc;
+	int idx;
+	unsigned long flags, newsrc, newdst;
 	pmd_t *pmdp;
 	pte_t *ptep;
 	int cpu = get_cpu();
@@ -121,7 +121,7 @@ static void memcpy_multicache(void *dest, const void *source,
 	 */
 	sim_allow_multiple_caching(0);
 	local_irq_restore(flags);
-	put_cpu_no_resched();
+	put_cpu();
 }
 
 /*
diff --git a/arch/tile/lib/memmove_32.c b/arch/tile/lib/memmove_32.c
index f09d8c4..fd615ae 100644
--- a/arch/tile/lib/memmove_32.c
+++ b/arch/tile/lib/memmove_32.c
@@ -42,7 +42,7 @@ void *memmove(void *dest, const void *src, size_t n)
 			in = (const uint8_t *)src;
 			out = (uint8_t *)dest;
 			stride = 1;
-                }
+		}
 
 		/* Manually software-pipeline this loop. */
 		x = *in;
diff --git a/arch/tile/lib/memset_32.c b/arch/tile/lib/memset_32.c
index 8593bc8..bfde5d8 100644
--- a/arch/tile/lib/memset_32.c
+++ b/arch/tile/lib/memset_32.c
@@ -245,7 +245,8 @@ void *memset(void *s, int c, size_t n)
 				wh += CACHE_LINE_SIZE_IN_WORDS;
 			} while (--i);
 
-			for (j = x * (CACHE_LINE_SIZE_IN_WORDS / 4); j != 0; j--) {
+			for (j = x * (CACHE_LINE_SIZE_IN_WORDS / 4);
+			     j != 0; j--) {
 				*out32++ = v32;
 				*out32++ = v32;
 				*out32++ = v32;
diff --git a/arch/tile/lib/spinlock_common.h b/arch/tile/lib/spinlock_common.h
index 8dffebd..c101098 100644
--- a/arch/tile/lib/spinlock_common.h
+++ b/arch/tile/lib/spinlock_common.h
@@ -35,7 +35,7 @@ relax(int iterations)
 }
 
 /* Perform bounded exponential backoff.*/
-void delay_backoff(int iterations)
+static void delay_backoff(int iterations)
 {
 	u32 exponent, loops;
 
diff --git a/arch/tile/lib/uaccess.c b/arch/tile/lib/uaccess.c
index 9ae1825..f8d398c 100644
--- a/arch/tile/lib/uaccess.c
+++ b/arch/tile/lib/uaccess.c
@@ -18,14 +18,15 @@
 int __range_ok(unsigned long addr, unsigned long size)
 {
 	unsigned long limit = current_thread_info()->addr_limit.seg;
-	__chk_user_ptr(addr);
 	return !((addr < limit && size <= limit - addr) ||
 		 is_arch_mappable_range(addr, size));
 }
 EXPORT_SYMBOL(__range_ok);
 
+#ifdef CONFIG_DEBUG_COPY_FROM_USER
 void copy_from_user_overflow(void)
 {
        WARN(1, "Buffer overflow detected!\n");
 }
 EXPORT_SYMBOL(copy_from_user_overflow);
+#endif
diff --git a/arch/tile/mm/elf.c b/arch/tile/mm/elf.c
index 818c9be..55e58e9 100644
--- a/arch/tile/mm/elf.c
+++ b/arch/tile/mm/elf.c
@@ -20,6 +20,7 @@
 #include <linux/elf.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
+#include <asm/sections.h>
 
 /* Notify a running simulator, if any, that an exec just occurred. */
 static void sim_notify_exec(const char *binary_name)
@@ -77,9 +78,8 @@ static void *vdso_page;
 /* One-entry array used for install_special_mapping. */
 static struct page *vdso_pages[1];
 
-int __init vdso_setup(void)
+static int __init vdso_setup(void)
 {
-	extern char __rt_sigreturn[], __rt_sigreturn_end[];
 	vdso_page = (void *)get_zeroed_page(GFP_ATOMIC);
 	memcpy(vdso_page, __rt_sigreturn, __rt_sigreturn_end - __rt_sigreturn);
 	vdso_pages[0] = virt_to_page(vdso_page);
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index 9b6b92f..0011f06 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -39,32 +39,11 @@
 #include <asm/system.h>
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
+#include <asm/traps.h>
+#include <asm/syscalls.h>
 
 #include <arch/interrupts.h>
 
-/*
- * Unlock any spinlocks which will prevent us from getting the
- * message out
- */
-void bust_spinlocks(int yes)
-{
-	int loglevel_save = console_loglevel;
-
-	if (yes) {
-		oops_in_progress = 1;
-		return;
-	}
-	oops_in_progress = 0;
-	/*
-	 * OK, the message is on the console.  Now we call printk()
-	 * without oops_in_progress set so that printk will give klogd
-	 * a poke.  Hold onto your hats...
-	 */
-	console_loglevel = 15;	/* NMI oopser may have shut the console up */
-	printk(" ");
-	console_loglevel = loglevel_save;
-}
-
 static noinline void force_sig_info_fault(int si_signo, int si_code,
 	unsigned long address, int fault_num, struct task_struct *tsk)
 {
@@ -301,10 +280,10 @@ static int handle_page_fault(struct pt_regs *regs,
 	 */
 	stack_offset = stack_pointer & (THREAD_SIZE-1);
 	if (stack_offset < THREAD_SIZE / 8) {
-		printk(KERN_ALERT "Potential stack overrun: sp %#lx\n",
+		pr_alert("Potential stack overrun: sp %#lx\n",
 		       stack_pointer);
 		show_regs(regs);
-		printk(KERN_ALERT "Killing current process %d/%s\n",
+		pr_alert("Killing current process %d/%s\n",
 		       tsk->pid, tsk->comm);
 		do_group_exit(SIGKILL);
 	}
@@ -422,7 +401,7 @@ good_area:
 	} else if (write) {
 #ifdef TEST_VERIFY_AREA
 		if (!is_page_fault && regs->cs == KERNEL_CS)
-			printk("WP fault at "REGFMT"\n", regs->eip);
+			pr_err("WP fault at "REGFMT"\n", regs->eip);
 #endif
 		if (!(vma->vm_flags & VM_WRITE))
 			goto bad_area;
@@ -450,6 +429,7 @@ good_area:
 	else
 		tsk->min_flt++;
 
+#if CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC()
 	/*
 	 * If this was an asynchronous fault,
 	 * restart the appropriate engine.
@@ -472,6 +452,7 @@ good_area:
 		break;
 #endif
 	}
+#endif
 
 	up_read(&mm->mmap_sem);
 	return 1;
@@ -514,17 +495,17 @@ no_context:
 		pte_t *pte = lookup_address(address);
 
 		if (pte && pte_present(*pte) && !pte_exec_kernel(*pte))
-			printk(KERN_CRIT "kernel tried to execute"
+			pr_crit("kernel tried to execute"
 			       " non-executable page - exploit attempt?"
 			       " (uid: %d)\n", current->uid);
 	}
 #endif
 	if (address < PAGE_SIZE)
-		printk(KERN_ALERT "Unable to handle kernel NULL pointer dereference\n");
+		pr_alert("Unable to handle kernel NULL pointer dereference\n");
 	else
-		printk(KERN_ALERT "Unable to handle kernel paging request\n");
-	printk(" at virtual address "REGFMT", pc "REGFMT"\n",
-	       address, regs->pc);
+		pr_alert("Unable to handle kernel paging request\n");
+	pr_alert(" at virtual address "REGFMT", pc "REGFMT"\n",
+		 address, regs->pc);
 
 	show_regs(regs);
 
@@ -555,7 +536,7 @@ out_of_memory:
 		down_read(&mm->mmap_sem);
 		goto survive;
 	}
-	printk("VM: killing process %s\n", tsk->comm);
+	pr_alert("VM: killing process %s\n", tsk->comm);
 	if (!is_kernel_mode)
 		do_group_exit(SIGKILL);
 	goto no_context;
@@ -573,31 +554,12 @@ do_sigbus:
 
 #ifndef __tilegx__
 
-extern char sys_cmpxchg[], __sys_cmpxchg_end[];
-extern char __sys_cmpxchg_grab_lock[];
-extern char __start_atomic_asm_code[], __end_atomic_asm_code[];
-
-/*
- * We return this structure in registers to avoid having to write
- * additional save/restore code in the intvec.S caller.
- */
-struct intvec_state {
-	void *handler;
-	unsigned long vecnum;
-	unsigned long fault_num;
-	unsigned long info;
-	unsigned long retval;
-};
-
 /* We must release ICS before panicking or we won't get anywhere. */
 #define ics_panic(fmt, ...) do { \
 	__insn_mtspr(SPR_INTERRUPT_CRITICAL_SECTION, 0); \
 	panic(fmt, __VA_ARGS__); \
 } while (0)
 
-void do_page_fault(struct pt_regs *regs, int fault_num,
-		   unsigned long address, unsigned long write);
-
 /*
  * When we take an ITLB or DTLB fault or access violation in the
  * supervisor while the critical section bit is set, the hypervisor is
diff --git a/arch/tile/mm/highmem.c b/arch/tile/mm/highmem.c
index 1fcecc5..ff1cdff 100644
--- a/arch/tile/mm/highmem.c
+++ b/arch/tile/mm/highmem.c
@@ -121,7 +121,7 @@ static struct list_head amp_list = LIST_HEAD_INIT(amp_list);
 struct kmap_amps {
 	struct atomic_mapped_page per_type[KM_TYPE_NR];
 };
-DEFINE_PER_CPU(struct kmap_amps, amps);
+static DEFINE_PER_CPU(struct kmap_amps, amps);
 
 /*
  * Add a page and va, on this cpu, to the list of kmap_atomic pages,
diff --git a/arch/tile/mm/homecache.c b/arch/tile/mm/homecache.c
index 52feb77..97c478e 100644
--- a/arch/tile/mm/homecache.c
+++ b/arch/tile/mm/homecache.c
@@ -46,7 +46,7 @@
  * locally from a remote home.  There's no point in using it if we
  * don't have coherent local caching, though.
  */
-int __write_once noallocl2;
+static int __write_once noallocl2;
 static int __init set_noallocl2(char *str)
 {
 	noallocl2 = 1;
@@ -60,15 +60,11 @@ early_param("noallocl2", set_noallocl2);
 
 #endif
 
-
-
 /* Provide no-op versions of these routines to keep flush_remote() cleaner. */
 #define mark_caches_evicted_start() 0
 #define mark_caches_evicted_finish(mask, timestamp) do {} while (0)
 
 
-
-
 /*
  * Update the irq_stat for cpus that we are going to interrupt
  * with TLB or cache flushes.  Also handle removing dataplane cpus
@@ -171,20 +167,12 @@ void flush_remote(unsigned long cache_pfn, unsigned long cache_control,
 	cpumask_scnprintf(cache_buf, sizeof(cache_buf), &cache_cpumask_copy);
 	cpumask_scnprintf(tlb_buf, sizeof(tlb_buf), &tlb_cpumask_copy);
 
-	printk("hv_flush_remote(%#llx, %#lx, %p [%s],"
+	pr_err("hv_flush_remote(%#llx, %#lx, %p [%s],"
 	       " %#lx, %#lx, %#lx, %p [%s], %p, %d) = %d\n",
 	       cache_pa, cache_control, cache_cpumask, cache_buf,
 	       (unsigned long)tlb_va, tlb_length, tlb_pgsize,
 	       tlb_cpumask, tlb_buf,
 	       asids, asidcount, rc);
-	if (asidcount > 0) {
-		int i;
-		printk(" asids:");
-		for (i = 0; i < asidcount; ++i)
-			printk(" %d,%d,%d",
-			       asids[i].x, asids[i].y, asids[i].asid);
-		printk("\n");
-	}
 	panic("Unsafe to continue.");
 }
 
@@ -293,7 +281,7 @@ pte_t pte_set_home(pte_t pte, int home)
 	 */
 	if (hv_pte_get_nc(pte) && home != PAGE_HOME_IMMUTABLE) {
 		pte = hv_pte_clear_nc(pte);
-		printk("non-immutable page incoherently referenced: %#llx\n",
+		pr_err("non-immutable page incoherently referenced: %#llx\n",
 		       pte.val);
 	}
 
diff --git a/arch/tile/mm/hugetlbpage.c b/arch/tile/mm/hugetlbpage.c
index c38570f..24688b6 100644
--- a/arch/tile/mm/hugetlbpage.c
+++ b/arch/tile/mm/hugetlbpage.c
@@ -332,7 +332,7 @@ static __init int setup_hugepagesz(char *opt)
 	} else if (ps == PUD_SIZE) {
 		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
 	} else {
-		printk(KERN_ERR "hugepagesz: Unsupported page size %lu M\n",
+		pr_err("hugepagesz: Unsupported page size %lu M\n",
 			ps >> 20);
 		return 0;
 	}
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 125ac53..d89c9ea 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -67,7 +67,9 @@
 
 #define clear_pgd(pmdptr) (*(pmdptr) = hv_pte(0))
 
+#ifndef __tilegx__
 unsigned long VMALLOC_RESERVE = CONFIG_VMALLOC_RESERVE;
+#endif
 
 DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
 
@@ -282,9 +284,9 @@ static pgprot_t __init init_pgprot(ulong address)
 	/*
 	 * Everything else that isn't data or bss is heap, so mark it
 	 * with the initial heap home (hash-for-home, or this cpu).  This
-	 * includes any addresses after the loaded image; any address before
-	 * _einittext (since we already captured the case of text before
-	 * _sinittext); and any init-data pages.
+	 * includes any addresses after the loaded image and any address before
+	 * _einitdata, since we already captured the case of text before
+	 * _sinittext, and __pa(einittext) is approximately __pa(sinitdata).
 	 *
 	 * All the LOWMEM pages that we mark this way will get their
 	 * struct page homecache properly marked later, in set_page_homes().
@@ -292,9 +294,7 @@ static pgprot_t __init init_pgprot(ulong address)
 	 * homes, but with a zero free_time we don't have to actually
 	 * do a flush action the first time we use them, either.
 	 */
-	if (address >= (ulong) _end || address < (ulong) _sdata ||
-	    (address >= (ulong) _sinitdata &&
-	     address < (ulong) _einitdata))
+	if (address >= (ulong) _end || address < (ulong) _einitdata)
 		return construct_pgprot(PAGE_KERNEL, initial_heap_home());
 
 #if CHIP_HAS_CBOX_HOME_MAP()
@@ -304,35 +304,38 @@ static pgprot_t __init init_pgprot(ulong address)
 #endif
 
 	/*
+	 * Make the w1data homed like heap to start with, to avoid
+	 * making it part of the page-striped data area when we're just
+	 * going to convert it to read-only soon anyway.
+	 */
+	if (address >= (ulong)__w1data_begin && address < (ulong)__w1data_end)
+		return construct_pgprot(PAGE_KERNEL, initial_heap_home());
+
+	/*
 	 * Otherwise we just hand out consecutive cpus.  To avoid
 	 * requiring this function to hold state, we just walk forward from
 	 * _sdata by PAGE_SIZE, skipping the readonly and init data, to reach
 	 * the requested address, while walking cpu home around kdata_mask.
 	 * This is typically no more than a dozen or so iterations.
 	 */
-	BUG_ON(_einitdata != __bss_start);
-	for (page = (ulong)_sdata, cpu = NR_CPUS; ; ) {
-		cpu = cpumask_next(cpu, &kdata_mask);
-		if (cpu == NR_CPUS)
-			cpu = cpumask_first(&kdata_mask);
-		if (page >= address)
-			break;
-		page += PAGE_SIZE;
-		if (page == (ulong)__start_rodata)
-			page = (ulong)__end_rodata;
-		if (page == (ulong)&init_thread_union)
-			page += THREAD_SIZE;
-		if (page == (ulong)_sinitdata)
-			page = (ulong)_einitdata;
+	page = (((ulong)__w1data_end) + PAGE_SIZE - 1) & PAGE_MASK;
+	BUG_ON(address < page || address >= (ulong)_end);
+	cpu = cpumask_first(&kdata_mask);
+	for (; page < address; page += PAGE_SIZE) {
+		if (page >= (ulong)&init_thread_union &&
+		    page < (ulong)&init_thread_union + THREAD_SIZE)
+			continue;
 		if (page == (ulong)empty_zero_page)
-			page += PAGE_SIZE;
+			continue;
 #ifndef __tilegx__
 #if !ATOMIC_LOCKS_FOUND_VIA_TABLE()
 		if (page == (ulong)atomic_locks)
-			page += PAGE_SIZE;
+			continue;
 #endif
 #endif
-
+		cpu = cpumask_next(cpu, &kdata_mask);
+		if (cpu == NR_CPUS)
+			cpu = cpumask_first(&kdata_mask);
 	}
 	return construct_pgprot(PAGE_KERNEL, cpu);
 }
@@ -362,7 +365,7 @@ static int __init setup_ktext(char *str)
 	/* If you have a leading "nocache", turn off ktext caching */
 	if (strncmp(str, "nocache", 7) == 0) {
 		ktext_nocache = 1;
-		printk("ktext: disabling local caching of kernel text\n");
+		pr_info("ktext: disabling local caching of kernel text\n");
 		str += 7;
 		if (*str == ',')
 			++str;
@@ -374,20 +377,20 @@ static int __init setup_ktext(char *str)
 
 	/* Default setting on Tile64: use a huge page */
 	if (strcmp(str, "huge") == 0)
-		printk("ktext: using one huge locally cached page\n");
+		pr_info("ktext: using one huge locally cached page\n");
 
 	/* Pay TLB cost but get no cache benefit: cache small pages locally */
 	else if (strcmp(str, "local") == 0) {
 		ktext_small = 1;
 		ktext_local = 1;
-		printk("ktext: using small pages with local caching\n");
+		pr_info("ktext: using small pages with local caching\n");
 	}
 
 	/* Neighborhood cache ktext pages on all cpus. */
 	else if (strcmp(str, "all") == 0) {
 		ktext_small = 1;
 		ktext_all = 1;
-		printk("ktext: using maximal caching neighborhood\n");
+		pr_info("ktext: using maximal caching neighborhood\n");
 	}
 
 
@@ -397,10 +400,10 @@ static int __init setup_ktext(char *str)
 		cpulist_scnprintf(buf, sizeof(buf), &ktext_mask);
 		if (cpumask_weight(&ktext_mask) > 1) {
 			ktext_small = 1;
-			printk("ktext: using caching neighborhood %s "
+			pr_info("ktext: using caching neighborhood %s "
 			       "with small pages\n", buf);
 		} else {
-			printk("ktext: caching on cpu %s with one huge page\n",
+			pr_info("ktext: caching on cpu %s with one huge page\n",
 			       buf);
 		}
 	}
@@ -470,19 +473,19 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 
 #if CHIP_HAS_CBOX_HOME_MAP()
 	if (ktext_arg_seen && ktext_hash) {
-		printk("warning: \"ktext\" boot argument ignored"
-		       " if \"kcache_hash\" sets up text hash-for-home\n");
+		pr_warning("warning: \"ktext\" boot argument ignored"
+			   " if \"kcache_hash\" sets up text hash-for-home\n");
 		ktext_small = 0;
 	}
 
 	if (kdata_arg_seen && kdata_hash) {
-		printk("warning: \"kdata\" boot argument ignored"
-		       " if \"kcache_hash\" sets up data hash-for-home\n");
+		pr_warning("warning: \"kdata\" boot argument ignored"
+			   " if \"kcache_hash\" sets up data hash-for-home\n");
 	}
 
 	if (kdata_huge && !hash_default) {
-		printk("warning: disabling \"kdata=huge\"; requires"
-		       " kcache_hash=all or =allbutstack\n");
+		pr_warning("warning: disabling \"kdata=huge\"; requires"
+			  " kcache_hash=all or =allbutstack\n");
 		kdata_huge = 0;
 	}
 #endif
@@ -556,11 +559,11 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 		if (!cpumask_empty(&bad)) {
 			char buf[NR_CPUS * 5];
 			cpulist_scnprintf(buf, sizeof(buf), &bad);
-			printk("ktext: not using unavailable cpus %s\n", buf);
+			pr_info("ktext: not using unavailable cpus %s\n", buf);
 		}
 		if (cpumask_empty(&ktext_mask)) {
-			printk("ktext: no valid cpus; caching on %d.\n",
-			       smp_processor_id());
+			pr_warning("ktext: no valid cpus; caching on %d.\n",
+				   smp_processor_id());
 			cpumask_copy(&ktext_mask,
 				     cpumask_of(smp_processor_id()));
 		}
@@ -737,17 +740,18 @@ static void __init set_non_bootmem_pages_init(void)
 	for_each_zone(z) {
 		unsigned long start, end;
 		int nid = z->zone_pgdat->node_id;
+		int idx = zone_idx(z);
 
 		start = z->zone_start_pfn;
 		if (start == 0)
 			continue;  /* bootmem */
 		end = start + z->spanned_pages;
-		if (zone_idx(z) == ZONE_NORMAL) {
+		if (idx == ZONE_NORMAL) {
 			BUG_ON(start != node_start_pfn[nid]);
 			start = node_free_pfn[nid];
 		}
 #ifdef CONFIG_HIGHMEM
-		if (zone_idx(z) == ZONE_HIGHMEM)
+		if (idx == ZONE_HIGHMEM)
 			totalhigh_pages += z->spanned_pages;
 #endif
 		if (kdata_huge) {
@@ -841,9 +845,9 @@ void __init mem_init(void)
 #ifdef CONFIG_HIGHMEM
 	/* check that fixmap and pkmap do not overlap */
 	if (PKMAP_ADDR(LAST_PKMAP-1) >= FIXADDR_START) {
-		printk(KERN_ERR "fixmap and kmap areas overlap"
+		pr_err("fixmap and kmap areas overlap"
 		       " - this will crash\n");
-		printk(KERN_ERR "pkstart: %lxh pkend: %lxh fixstart %lxh\n",
+		pr_err("pkstart: %lxh pkend: %lxh fixstart %lxh\n",
 		       PKMAP_BASE, PKMAP_ADDR(LAST_PKMAP-1),
 		       FIXADDR_START);
 		BUG();
@@ -863,7 +867,7 @@ void __init mem_init(void)
 	initsize =  (unsigned long)&_einittext - (unsigned long)&_sinittext;
 	initsize += (unsigned long)&_einitdata - (unsigned long)&_sinitdata;
 
-	printk(KERN_INFO "Memory: %luk/%luk available (%dk kernel code, %dk data, %dk init, %ldk highmem)\n",
+	pr_info("Memory: %luk/%luk available (%dk kernel code, %dk data, %dk init, %ldk highmem)\n",
 		(unsigned long) nr_free_pages() << (PAGE_SHIFT-10),
 		num_physpages << (PAGE_SHIFT-10),
 		codesize >> 10,
@@ -968,7 +972,6 @@ static void mark_w1data_ro(void)
 	BUG_ON((addr & (PAGE_SIZE-1)) != 0);
 	for (; addr <= (unsigned long)__w1data_end - 1; addr += PAGE_SIZE) {
 		unsigned long pfn = kaddr_to_pfn((void *)addr);
-		struct page *page = pfn_to_page(pfn);
 		pte_t *ptep = virt_to_pte(NULL, addr);
 		BUG_ON(pte_huge(*ptep));   /* not relevant for kdata_huge */
 		set_pte_at(&init_mm, addr, ptep, pfn_pte(pfn, PAGE_KERNEL_RO));
@@ -986,7 +989,7 @@ static long __write_once initfree = 1;
 static int __init set_initfree(char *str)
 {
 	strict_strtol(str, 0, &initfree);
-	printk("initfree: %s free init pages\n", initfree ? "will" : "won't");
+	pr_info("initfree: %s free init pages\n", initfree ? "will" : "won't");
 	return 1;
 }
 __setup("initfree=", set_initfree);
@@ -996,8 +999,8 @@ static void free_init_pages(char *what, unsigned long begin, unsigned long end)
 	unsigned long addr = (unsigned long) begin;
 
 	if (kdata_huge && !initfree) {
-		printk("Warning: ignoring initfree=0:"
-		       " incompatible with kdata=huge\n");
+		pr_warning("Warning: ignoring initfree=0:"
+			   " incompatible with kdata=huge\n");
 		initfree = 1;
 	}
 	end = (end + PAGE_SIZE - 1) & PAGE_MASK;
@@ -1033,7 +1036,7 @@ static void free_init_pages(char *what, unsigned long begin, unsigned long end)
 		free_page(addr);
 		totalram_pages++;
 	}
-	printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
+	pr_info("Freeing %s: %ldk freed\n", what, (end - begin) >> 10);
 }
 
 void free_initmem(void)
diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index 289e729..28c2314 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -46,7 +46,7 @@ void show_mem(void)
 {
 	struct zone *zone;
 
-	printk("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu"
+	pr_err("Active:%lu inactive:%lu dirty:%lu writeback:%lu unstable:%lu"
 	       " free:%lu\n slab:%lu mapped:%lu pagetables:%lu bounce:%lu"
 	       " pagecache:%lu swap:%lu\n",
 	       (global_page_state(NR_ACTIVE_ANON) +
@@ -71,7 +71,6 @@ void show_mem(void)
 		if (!populated_zone(zone))
 			continue;
 
-		printk("Node %d %7s: ", zone_to_nid(zone), zone->name);
 		spin_lock_irqsave(&zone->lock, flags);
 		for (order = 0; order < MAX_ORDER; order++) {
 			int nr = zone->free_area[order].nr_free;
@@ -80,7 +79,8 @@ void show_mem(void)
 				largest_order = order;
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
-		printk("%lukB (largest %luKb)\n",
+		pr_err("Node %d %7s: %lukB (largest %luKb)\n",
+		       zone_to_nid(zone), zone->name,
 		       K(total), largest_order ? K(1UL) << largest_order : 0);
 	}
 }
@@ -123,42 +123,6 @@ static void set_pte_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags)
 	local_flush_tlb_page(NULL, vaddr, PAGE_SIZE);
 }
 
-/*
- * Associate a huge virtual page frame with a given physical page frame
- * and protection flags for that frame. pfn is for the base of the page,
- * vaddr is what the page gets mapped to - both must be properly aligned.
- * The pmd must already be instantiated.
- */
-void set_pmd_pfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags)
-{
-	pgd_t *pgd;
-	pud_t *pud;
-	pmd_t *pmd;
-
-	if (vaddr & (PMD_SIZE-1)) {		/* vaddr is misaligned */
-		printk(KERN_WARNING "set_pmd_pfn: vaddr misaligned\n");
-		return; /* BUG(); */
-	}
-	if (pfn & (PTRS_PER_PTE-1)) {		/* pfn is misaligned */
-		printk(KERN_WARNING "set_pmd_pfn: pfn misaligned\n");
-		return; /* BUG(); */
-	}
-	pgd = swapper_pg_dir + pgd_index(vaddr);
-	if (pgd_none(*pgd)) {
-		printk(KERN_WARNING "set_pmd_pfn: pgd_none\n");
-		return; /* BUG(); */
-	}
-	pud = pud_offset(pgd, vaddr);
-	pmd = pmd_offset(pud, vaddr);
-	set_pmd(pmd, ptfn_pmd(HV_PFN_TO_PTFN(pfn), flags));
-	/*
-	 * It's enough to flush this one mapping.
-	 * We flush both small and huge TSBs to be sure.
-	 */
-	local_flush_tlb_page(NULL, vaddr, HPAGE_SIZE);
-	local_flush_tlb_pages(NULL, vaddr, PAGE_SIZE, HPAGE_SIZE);
-}
-
 void __set_fixmap(enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
 {
 	unsigned long address = __fix_to_virt(idx);
@@ -257,7 +221,7 @@ void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 
 struct page *pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	int flags = GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO|__GFP_COMP;
+	gfp_t flags = GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO|__GFP_COMP;
 	struct page *p;
 
 #ifdef CONFIG_HIGHPTE
@@ -550,7 +514,7 @@ void iounmap(volatile void __iomem *addr_in)
 	read_unlock(&vmlist_lock);
 
 	if (!p) {
-		printk("iounmap: bad address %p\n", addr);
+		pr_err("iounmap: bad address %p\n", addr);
 		dump_stack();
 		return;
 	}
-- 
1.6.5.2

