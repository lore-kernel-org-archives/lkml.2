Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117Ab2CGTso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:48:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760005Ab2CGTsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:48:38 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/29] Disintegrate asm/system.h for IA64
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:48:20 +0000
Message-ID: <20120307194820.15987.18897.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for IA64.  Not compiled.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/ia64/include/asm/auxvec.h    |    2 
 arch/ia64/include/asm/barrier.h   |   68 ++++++++++++
 arch/ia64/include/asm/exec.h      |   14 +++
 arch/ia64/include/asm/pci.h       |    8 +
 arch/ia64/include/asm/processor.h |    8 +
 arch/ia64/include/asm/setup.h     |   28 +++++
 arch/ia64/include/asm/switch_to.h |   87 ++++++++++++++++
 arch/ia64/include/asm/system.h    |  203 -------------------------------------
 8 files changed, 215 insertions(+), 203 deletions(-)
 create mode 100644 arch/ia64/include/asm/barrier.h
 create mode 100644 arch/ia64/include/asm/exec.h
 create mode 100644 arch/ia64/include/asm/switch_to.h
 delete mode 100644 arch/ia64/include/asm/system.h

diff --git a/arch/ia64/include/asm/auxvec.h b/arch/ia64/include/asm/auxvec.h
index 23cebe5..58277fc 100644
--- a/arch/ia64/include/asm/auxvec.h
+++ b/arch/ia64/include/asm/auxvec.h
@@ -8,4 +8,6 @@
 #define AT_SYSINFO	32
 #define AT_SYSINFO_EHDR	33
 
+#define AT_VECTOR_SIZE_ARCH 2 /* entries in ARCH_DLINFO */
+
 #endif /* _ASM_IA64_AUXVEC_H */
diff --git a/arch/ia64/include/asm/barrier.h b/arch/ia64/include/asm/barrier.h
new file mode 100644
index 0000000..516529c
--- /dev/null
+++ b/arch/ia64/include/asm/barrier.h
@@ -0,0 +1,68 @@
+/*
+ * Memory barrier definitions.  This is based on information published
+ * in the Processor Abstraction Layer and the System Abstraction Layer
+ * manual.
+ *
+ * Copyright (C) 1998-2003 Hewlett-Packard Co
+ *	David Mosberger-Tang <davidm@hpl.hp.com>
+ * Copyright (C) 1999 Asit Mallick <asit.k.mallick@intel.com>
+ * Copyright (C) 1999 Don Dugger <don.dugger@intel.com>
+ */
+#ifndef _ASM_IA64_BARRIER_H
+#define _ASM_IA64_BARRIER_H
+
+#include <asm/compiler.h>
+
+/*
+ * Macros to force memory ordering.  In these descriptions, "previous"
+ * and "subsequent" refer to program order; "visible" means that all
+ * architecturally visible effects of a memory access have occurred
+ * (at a minimum, this means the memory has been read or written).
+ *
+ *   wmb():	Guarantees that all preceding stores to memory-
+ *		like regions are visible before any subsequent
+ *		stores and that all following stores will be
+ *		visible only after all previous stores.
+ *   rmb():	Like wmb(), but for reads.
+ *   mb():	wmb()/rmb() combo, i.e., all previous memory
+ *		accesses are visible before all subsequent
+ *		accesses and vice versa.  This is also known as
+ *		a "fence."
+ *
+ * Note: "mb()" and its variants cannot be used as a fence to order
+ * accesses to memory mapped I/O registers.  For that, mf.a needs to
+ * be used.  However, we don't want to always use mf.a because (a)
+ * it's (presumably) much slower than mf and (b) mf.a is supported for
+ * sequential memory pages only.
+ */
+#define mb()	ia64_mf()
+#define rmb()	mb()
+#define wmb()	mb()
+#define read_barrier_depends()	do { } while(0)
+
+#ifdef CONFIG_SMP
+# define smp_mb()	mb()
+# define smp_rmb()	rmb()
+# define smp_wmb()	wmb()
+# define smp_read_barrier_depends()	read_barrier_depends()
+#else
+# define smp_mb()	barrier()
+# define smp_rmb()	barrier()
+# define smp_wmb()	barrier()
+# define smp_read_barrier_depends()	do { } while(0)
+#endif
+
+/*
+ * XXX check on this ---I suspect what Linus really wants here is
+ * acquire vs release semantics but we can't discuss this stuff with
+ * Linus just yet.  Grrr...
+ */
+#define set_mb(var, value)	do { (var) = (value); mb(); } while (0)
+
+/*
+ * The group barrier in front of the rsm & ssm are necessary to ensure
+ * that none of the previous instructions in the same group are
+ * affected by the rsm/ssm.
+ */
+
+#endif /* _ASM_IA64_BARRIER_H */
diff --git a/arch/ia64/include/asm/exec.h b/arch/ia64/include/asm/exec.h
new file mode 100644
index 0000000..b262424
--- /dev/null
+++ b/arch/ia64/include/asm/exec.h
@@ -0,0 +1,14 @@
+/*
+ * Process execution defines.
+ *
+ * Copyright (C) 1998-2003 Hewlett-Packard Co
+ *	David Mosberger-Tang <davidm@hpl.hp.com>
+ * Copyright (C) 1999 Asit Mallick <asit.k.mallick@intel.com>
+ * Copyright (C) 1999 Don Dugger <don.dugger@intel.com>
+ */
+#ifndef _ASM_IA64_EXEC_H
+#define _ASM_IA64_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* _ASM_IA64_EXEC_H */
diff --git a/arch/ia64/include/asm/pci.h b/arch/ia64/include/asm/pci.h
index 279b38a..c5e6da9 100644
--- a/arch/ia64/include/asm/pci.h
+++ b/arch/ia64/include/asm/pci.h
@@ -11,6 +11,14 @@
 #include <asm/scatterlist.h>
 #include <asm/hw_irq.h>
 
+struct pci_vector_struct {
+	__u16 segment;	/* PCI Segment number */
+	__u16 bus;	/* PCI Bus number */
+	__u32 pci_id;	/* ACPI split 16 bits device, 16 bits function (see section 6.1.1) */
+	__u8 pin;	/* PCI PIN (0 = A, 1 = B, 2 = C, 3 = D) */
+	__u32 irq;	/* IRQ assigned */
+};
+
 /*
  * Can be used to override the logic in pci_scan_bus for skipping already-configured bus
  * numbers - to be used for buggy BIOSes or architectures with incomplete PCI setup by the
diff --git a/arch/ia64/include/asm/processor.h b/arch/ia64/include/asm/processor.h
index 691be0b..483f6c6 100644
--- a/arch/ia64/include/asm/processor.h
+++ b/arch/ia64/include/asm/processor.h
@@ -19,6 +19,9 @@
 #include <asm/ptrace.h>
 #include <asm/ustack.h>
 
+#define __ARCH_WANT_UNLOCKED_CTXSW
+#define ARCH_HAS_PREFETCH_SWITCH_STACK
+
 #define IA64_NUM_PHYS_STACK_REG	96
 #define IA64_NUM_DBG_REGS	8
 
@@ -720,6 +723,11 @@ extern unsigned long boot_option_idle_override;
 enum idle_boot_override {IDLE_NO_OVERRIDE=0, IDLE_HALT, IDLE_FORCE_MWAIT,
 			 IDLE_NOMWAIT, IDLE_POLL};
 
+void cpu_idle_wait(void);
+void default_idle(void);
+
+#define ia64_platform_is(x) (strcmp(x, platform_name) == 0)
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_IA64_PROCESSOR_H */
diff --git a/arch/ia64/include/asm/setup.h b/arch/ia64/include/asm/setup.h
index 4399a44..d2fb458 100644
--- a/arch/ia64/include/asm/setup.h
+++ b/arch/ia64/include/asm/setup.h
@@ -3,4 +3,32 @@
 
 #define COMMAND_LINE_SIZE	2048
 
+#define GATE_ADDR		RGN_BASE(RGN_GATE)
+
+/*
+ * 0xa000000000000000+2*PERCPU_PAGE_SIZE
+ * - 0xa000000000000000+3*PERCPU_PAGE_SIZE remain unmapped (guard page)
+ */
+#define KERNEL_START		 (GATE_ADDR+__IA64_UL_CONST(0x100000000))
+#define PERCPU_ADDR		(-PERCPU_PAGE_SIZE)
+#define LOAD_OFFSET		(KERNEL_START - KERNEL_TR_PAGE_SIZE)
+
+extern struct ia64_boot_param {
+	__u64 command_line;		/* physical address of command line arguments */
+	__u64 efi_systab;		/* physical address of EFI system table */
+	__u64 efi_memmap;		/* physical address of EFI memory map */
+	__u64 efi_memmap_size;		/* size of EFI memory map */
+	__u64 efi_memdesc_size;		/* size of an EFI memory map descriptor */
+	__u32 efi_memdesc_version;	/* memory descriptor version */
+	struct {
+		__u16 num_cols;	/* number of columns on console output device */
+		__u16 num_rows;	/* number of rows on console output device */
+		__u16 orig_x;	/* cursor's x position */
+		__u16 orig_y;	/* cursor's y position */
+	} console_info;
+	__u64 fpswa;		/* physical address of the fpswa interface */
+	__u64 initrd_start;
+	__u64 initrd_size;
+} *ia64_boot_param;
+
 #endif
diff --git a/arch/ia64/include/asm/switch_to.h b/arch/ia64/include/asm/switch_to.h
new file mode 100644
index 0000000..cb2412f
--- /dev/null
+++ b/arch/ia64/include/asm/switch_to.h
@@ -0,0 +1,87 @@
+/*
+ * Low-level task switching. This is based on information published in
+ * the Processor Abstraction Layer and the System Abstraction Layer
+ * manual.
+ *
+ * Copyright (C) 1998-2003 Hewlett-Packard Co
+ *	David Mosberger-Tang <davidm@hpl.hp.com>
+ * Copyright (C) 1999 Asit Mallick <asit.k.mallick@intel.com>
+ * Copyright (C) 1999 Don Dugger <don.dugger@intel.com>
+ */
+#ifndef _ASM_IA64_SWITCH_TO_H
+#define _ASM_IA64_SWITCH_TO_H
+
+#include <linux/percpu.h>
+
+struct task_struct;
+
+/*
+ * Context switch from one thread to another.  If the two threads have
+ * different address spaces, schedule() has already taken care of
+ * switching to the new address space by calling switch_mm().
+ *
+ * Disabling access to the fph partition and the debug-register
+ * context switch MUST be done before calling ia64_switch_to() since a
+ * newly created thread returns directly to
+ * ia64_ret_from_syscall_clear_r8.
+ */
+extern struct task_struct *ia64_switch_to (void *next_task);
+
+extern void ia64_save_extra (struct task_struct *task);
+extern void ia64_load_extra (struct task_struct *task);
+
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+extern void ia64_account_on_switch (struct task_struct *prev, struct task_struct *next);
+# define IA64_ACCOUNT_ON_SWITCH(p,n) ia64_account_on_switch(p,n)
+#else
+# define IA64_ACCOUNT_ON_SWITCH(p,n)
+#endif
+
+#ifdef CONFIG_PERFMON
+  DECLARE_PER_CPU(unsigned long, pfm_syst_info);
+# define PERFMON_IS_SYSWIDE() (__get_cpu_var(pfm_syst_info) & 0x1)
+#else
+# define PERFMON_IS_SYSWIDE() (0)
+#endif
+
+#define IA64_HAS_EXTRA_STATE(t)							\
+	((t)->thread.flags & (IA64_THREAD_DBG_VALID|IA64_THREAD_PM_VALID)	\
+	 || PERFMON_IS_SYSWIDE())
+
+#define __switch_to(prev,next,last) do {							 \
+	IA64_ACCOUNT_ON_SWITCH(prev, next);							 \
+	if (IA64_HAS_EXTRA_STATE(prev))								 \
+		ia64_save_extra(prev);								 \
+	if (IA64_HAS_EXTRA_STATE(next))								 \
+		ia64_load_extra(next);								 \
+	ia64_psr(task_pt_regs(next))->dfh = !ia64_is_local_fpu_owner(next);			 \
+	(last) = ia64_switch_to((next));							 \
+} while (0)
+
+#ifdef CONFIG_SMP
+/*
+ * In the SMP case, we save the fph state when context-switching away from a thread that
+ * modified fph.  This way, when the thread gets scheduled on another CPU, the CPU can
+ * pick up the state from task->thread.fph, avoiding the complication of having to fetch
+ * the latest fph state from another CPU.  In other words: eager save, lazy restore.
+ */
+# define switch_to(prev,next,last) do {						\
+	if (ia64_psr(task_pt_regs(prev))->mfh && ia64_is_local_fpu_owner(prev)) {				\
+		ia64_psr(task_pt_regs(prev))->mfh = 0;			\
+		(prev)->thread.flags |= IA64_THREAD_FPH_VALID;			\
+		__ia64_save_fpu((prev)->thread.fph);				\
+	}									\
+	__switch_to(prev, next, last);						\
+	/* "next" in old context is "current" in new context */			\
+	if (unlikely((current->thread.flags & IA64_THREAD_MIGRATION) &&	       \
+		     (task_cpu(current) !=				       \
+		      		      task_thread_info(current)->last_cpu))) { \
+		platform_migrate(current);				       \
+		task_thread_info(current)->last_cpu = task_cpu(current);       \
+	}								       \
+} while (0)
+#else
+# define switch_to(prev,next,last)	__switch_to(prev, next, last)
+#endif
+
+#endif /* _ASM_IA64_SWITCH_TO_H */
diff --git a/arch/ia64/include/asm/system.h b/arch/ia64/include/asm/system.h
deleted file mode 100644
index 6cca307..0000000
--- a/arch/ia64/include/asm/system.h
+++ /dev/null
@@ -1,203 +0,0 @@
-#ifndef _ASM_IA64_SYSTEM_H
-#define _ASM_IA64_SYSTEM_H
-
-/*
- * System defines. Note that this is included both from .c and .S
- * files, so it does only defines, not any C code.  This is based
- * on information published in the Processor Abstraction Layer
- * and the System Abstraction Layer manual.
- *
- * Copyright (C) 1998-2003 Hewlett-Packard Co
- *	David Mosberger-Tang <davidm@hpl.hp.com>
- * Copyright (C) 1999 Asit Mallick <asit.k.mallick@intel.com>
- * Copyright (C) 1999 Don Dugger <don.dugger@intel.com>
- */
-
-#include <asm/kregs.h>
-#include <asm/page.h>
-#include <asm/pal.h>
-#include <asm/percpu.h>
-
-#define GATE_ADDR		RGN_BASE(RGN_GATE)
-
-/*
- * 0xa000000000000000+2*PERCPU_PAGE_SIZE
- * - 0xa000000000000000+3*PERCPU_PAGE_SIZE remain unmapped (guard page)
- */
-#define KERNEL_START		 (GATE_ADDR+__IA64_UL_CONST(0x100000000))
-#define PERCPU_ADDR		(-PERCPU_PAGE_SIZE)
-#define LOAD_OFFSET		(KERNEL_START - KERNEL_TR_PAGE_SIZE)
-
-#ifndef __ASSEMBLY__
-
-#include <linux/kernel.h>
-#include <linux/types.h>
-
-#define AT_VECTOR_SIZE_ARCH 2 /* entries in ARCH_DLINFO */
-
-struct pci_vector_struct {
-	__u16 segment;	/* PCI Segment number */
-	__u16 bus;	/* PCI Bus number */
-	__u32 pci_id;	/* ACPI split 16 bits device, 16 bits function (see section 6.1.1) */
-	__u8 pin;	/* PCI PIN (0 = A, 1 = B, 2 = C, 3 = D) */
-	__u32 irq;	/* IRQ assigned */
-};
-
-extern struct ia64_boot_param {
-	__u64 command_line;		/* physical address of command line arguments */
-	__u64 efi_systab;		/* physical address of EFI system table */
-	__u64 efi_memmap;		/* physical address of EFI memory map */
-	__u64 efi_memmap_size;		/* size of EFI memory map */
-	__u64 efi_memdesc_size;		/* size of an EFI memory map descriptor */
-	__u32 efi_memdesc_version;	/* memory descriptor version */
-	struct {
-		__u16 num_cols;	/* number of columns on console output device */
-		__u16 num_rows;	/* number of rows on console output device */
-		__u16 orig_x;	/* cursor's x position */
-		__u16 orig_y;	/* cursor's y position */
-	} console_info;
-	__u64 fpswa;		/* physical address of the fpswa interface */
-	__u64 initrd_start;
-	__u64 initrd_size;
-} *ia64_boot_param;
-
-/*
- * Macros to force memory ordering.  In these descriptions, "previous"
- * and "subsequent" refer to program order; "visible" means that all
- * architecturally visible effects of a memory access have occurred
- * (at a minimum, this means the memory has been read or written).
- *
- *   wmb():	Guarantees that all preceding stores to memory-
- *		like regions are visible before any subsequent
- *		stores and that all following stores will be
- *		visible only after all previous stores.
- *   rmb():	Like wmb(), but for reads.
- *   mb():	wmb()/rmb() combo, i.e., all previous memory
- *		accesses are visible before all subsequent
- *		accesses and vice versa.  This is also known as
- *		a "fence."
- *
- * Note: "mb()" and its variants cannot be used as a fence to order
- * accesses to memory mapped I/O registers.  For that, mf.a needs to
- * be used.  However, we don't want to always use mf.a because (a)
- * it's (presumably) much slower than mf and (b) mf.a is supported for
- * sequential memory pages only.
- */
-#define mb()	ia64_mf()
-#define rmb()	mb()
-#define wmb()	mb()
-#define read_barrier_depends()	do { } while(0)
-
-#ifdef CONFIG_SMP
-# define smp_mb()	mb()
-# define smp_rmb()	rmb()
-# define smp_wmb()	wmb()
-# define smp_read_barrier_depends()	read_barrier_depends()
-#else
-# define smp_mb()	barrier()
-# define smp_rmb()	barrier()
-# define smp_wmb()	barrier()
-# define smp_read_barrier_depends()	do { } while(0)
-#endif
-
-/*
- * XXX check on this ---I suspect what Linus really wants here is
- * acquire vs release semantics but we can't discuss this stuff with
- * Linus just yet.  Grrr...
- */
-#define set_mb(var, value)	do { (var) = (value); mb(); } while (0)
-
-/*
- * The group barrier in front of the rsm & ssm are necessary to ensure
- * that none of the previous instructions in the same group are
- * affected by the rsm/ssm.
- */
-
-#ifdef __KERNEL__
-
-/*
- * Context switch from one thread to another.  If the two threads have
- * different address spaces, schedule() has already taken care of
- * switching to the new address space by calling switch_mm().
- *
- * Disabling access to the fph partition and the debug-register
- * context switch MUST be done before calling ia64_switch_to() since a
- * newly created thread returns directly to
- * ia64_ret_from_syscall_clear_r8.
- */
-extern struct task_struct *ia64_switch_to (void *next_task);
-
-struct task_struct;
-
-extern void ia64_save_extra (struct task_struct *task);
-extern void ia64_load_extra (struct task_struct *task);
-
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void ia64_account_on_switch (struct task_struct *prev, struct task_struct *next);
-# define IA64_ACCOUNT_ON_SWITCH(p,n) ia64_account_on_switch(p,n)
-#else
-# define IA64_ACCOUNT_ON_SWITCH(p,n)
-#endif
-
-#ifdef CONFIG_PERFMON
-  DECLARE_PER_CPU(unsigned long, pfm_syst_info);
-# define PERFMON_IS_SYSWIDE() (__get_cpu_var(pfm_syst_info) & 0x1)
-#else
-# define PERFMON_IS_SYSWIDE() (0)
-#endif
-
-#define IA64_HAS_EXTRA_STATE(t)							\
-	((t)->thread.flags & (IA64_THREAD_DBG_VALID|IA64_THREAD_PM_VALID)	\
-	 || PERFMON_IS_SYSWIDE())
-
-#define __switch_to(prev,next,last) do {							 \
-	IA64_ACCOUNT_ON_SWITCH(prev, next);							 \
-	if (IA64_HAS_EXTRA_STATE(prev))								 \
-		ia64_save_extra(prev);								 \
-	if (IA64_HAS_EXTRA_STATE(next))								 \
-		ia64_load_extra(next);								 \
-	ia64_psr(task_pt_regs(next))->dfh = !ia64_is_local_fpu_owner(next);			 \
-	(last) = ia64_switch_to((next));							 \
-} while (0)
-
-#ifdef CONFIG_SMP
-/*
- * In the SMP case, we save the fph state when context-switching away from a thread that
- * modified fph.  This way, when the thread gets scheduled on another CPU, the CPU can
- * pick up the state from task->thread.fph, avoiding the complication of having to fetch
- * the latest fph state from another CPU.  In other words: eager save, lazy restore.
- */
-# define switch_to(prev,next,last) do {						\
-	if (ia64_psr(task_pt_regs(prev))->mfh && ia64_is_local_fpu_owner(prev)) {				\
-		ia64_psr(task_pt_regs(prev))->mfh = 0;			\
-		(prev)->thread.flags |= IA64_THREAD_FPH_VALID;			\
-		__ia64_save_fpu((prev)->thread.fph);				\
-	}									\
-	__switch_to(prev, next, last);						\
-	/* "next" in old context is "current" in new context */			\
-	if (unlikely((current->thread.flags & IA64_THREAD_MIGRATION) &&	       \
-		     (task_cpu(current) !=				       \
-		      		      task_thread_info(current)->last_cpu))) { \
-		platform_migrate(current);				       \
-		task_thread_info(current)->last_cpu = task_cpu(current);       \
-	}								       \
-} while (0)
-#else
-# define switch_to(prev,next,last)	__switch_to(prev, next, last)
-#endif
-
-#define __ARCH_WANT_UNLOCKED_CTXSW
-#define ARCH_HAS_PREFETCH_SWITCH_STACK
-#define ia64_platform_is(x) (strcmp(x, platform_name) == 0)
-
-void cpu_idle_wait(void);
-
-#define arch_align_stack(x) (x)
-
-void default_idle(void);
-
-#endif /* __KERNEL__ */
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* _ASM_IA64_SYSTEM_H */

