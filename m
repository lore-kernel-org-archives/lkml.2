Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161661Ab2COU6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:58:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161608Ab2COU6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:58:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 17/38] Disintegrate asm/system.h for Microblaze [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, microblaze-uclinux@itee.uq.edu.au
Date: Thu, 15 Mar 2012 20:57:54 +0000
Message-ID: <20120315205754.28759.56543.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for Microblaze.  Not compiled.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: microblaze-uclinux@itee.uq.edu.au
---

 arch/microblaze/include/asm/atomic.h      |    1 
 arch/microblaze/include/asm/barrier.h     |   27 ++++++++
 arch/microblaze/include/asm/cmpxchg.h     |   40 +++++++++++
 arch/microblaze/include/asm/exec.h        |   14 ++++
 arch/microblaze/include/asm/processor.h   |   11 +++
 arch/microblaze/include/asm/setup.h       |    6 ++
 arch/microblaze/include/asm/switch_to.h   |   24 +++++++
 arch/microblaze/include/asm/system.h      |  104 ++---------------------------
 arch/microblaze/kernel/cpu/pvr.c          |    1 
 arch/microblaze/kernel/microblaze_ksyms.c |    1 
 arch/microblaze/kernel/process.c          |    1 
 arch/microblaze/kernel/prom.c             |    1 
 arch/microblaze/kernel/setup.c            |    1 
 arch/microblaze/kernel/timer.c            |    1 
 arch/microblaze/kernel/traps.c            |    1 
 arch/microblaze/lib/memcpy.c              |    1 
 arch/microblaze/mm/fault.c                |    1 
 17 files changed, 129 insertions(+), 107 deletions(-)
 create mode 100644 arch/microblaze/include/asm/barrier.h
 create mode 100644 arch/microblaze/include/asm/cmpxchg.h
 create mode 100644 arch/microblaze/include/asm/exec.h
 create mode 100644 arch/microblaze/include/asm/switch_to.h

diff --git a/arch/microblaze/include/asm/atomic.h b/arch/microblaze/include/asm/atomic.h
index 615f539..472d8bf 100644
--- a/arch/microblaze/include/asm/atomic.h
+++ b/arch/microblaze/include/asm/atomic.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_MICROBLAZE_ATOMIC_H
 #define _ASM_MICROBLAZE_ATOMIC_H
 
+#include <asm/cmpxchg.h>
 #include <asm-generic/atomic.h>
 #include <asm-generic/atomic64.h>
 
diff --git a/arch/microblaze/include/asm/barrier.h b/arch/microblaze/include/asm/barrier.h
new file mode 100644
index 0000000..df5be3e8
--- /dev/null
+++ b/arch/microblaze/include/asm/barrier.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_BARRIER_H
+#define _ASM_MICROBLAZE_BARRIER_H
+
+#define nop()                  asm volatile ("nop")
+
+#define smp_read_barrier_depends()	do {} while (0)
+#define read_barrier_depends()		do {} while (0)
+
+#define mb()			barrier()
+#define rmb()			mb()
+#define wmb()			mb()
+#define set_mb(var, value)	do { var = value; mb(); } while (0)
+#define set_wmb(var, value)	do { var = value; wmb(); } while (0)
+
+#define smp_mb()		mb()
+#define smp_rmb()		rmb()
+#define smp_wmb()		wmb()
+
+#endif /* _ASM_MICROBLAZE_BARRIER_H */
diff --git a/arch/microblaze/include/asm/cmpxchg.h b/arch/microblaze/include/asm/cmpxchg.h
new file mode 100644
index 0000000..0094859
--- /dev/null
+++ b/arch/microblaze/include/asm/cmpxchg.h
@@ -0,0 +1,40 @@
+#ifndef _ASM_MICROBLAZE_CMPXCHG_H
+#define _ASM_MICROBLAZE_CMPXCHG_H
+
+void __bad_xchg(volatile void *ptr, int size);
+
+static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
+								int size)
+{
+	unsigned long ret;
+	unsigned long flags;
+
+	switch (size) {
+	case 1:
+		local_irq_save(flags);
+		ret = *(volatile unsigned char *)ptr;
+		*(volatile unsigned char *)ptr = x;
+		local_irq_restore(flags);
+		break;
+
+	case 4:
+		local_irq_save(flags);
+		ret = *(volatile unsigned long *)ptr;
+		*(volatile unsigned long *)ptr = x;
+		local_irq_restore(flags);
+		break;
+	default:
+		__bad_xchg(ptr, size), ret = 0;
+		break;
+	}
+
+	return ret;
+}
+
+#define xchg(ptr, x) \
+	((__typeof__(*(ptr))) __xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
+
+#include <asm-generic/cmpxchg.h>
+#include <asm-generic/cmpxchg-local.h>
+
+#endif /* _ASM_MICROBLAZE_CMPXCHG_H */
diff --git a/arch/microblaze/include/asm/exec.h b/arch/microblaze/include/asm/exec.h
new file mode 100644
index 0000000..e750de1
--- /dev/null
+++ b/arch/microblaze/include/asm/exec.h
@@ -0,0 +1,14 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_EXEC_H
+#define _ASM_MICROBLAZE_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* _ASM_MICROBLAZE_EXEC_H */
diff --git a/arch/microblaze/include/asm/processor.h b/arch/microblaze/include/asm/processor.h
index 7283bfb..510a8e1 100644
--- a/arch/microblaze/include/asm/processor.h
+++ b/arch/microblaze/include/asm/processor.h
@@ -125,7 +125,6 @@ struct thread_struct {
 	.pgdir = swapper_pg_dir, \
 }
 
-
 /* Free all resources held by a thread. */
 extern inline void release_thread(struct task_struct *dead_task)
 {
@@ -144,6 +143,8 @@ static inline void exit_thread(void)
 
 unsigned long get_wchan(struct task_struct *p);
 
+extern void ret_from_fork(void);
+
 /* The size allocated for kernel stacks. This _must_ be a power of two! */
 # define KERNEL_STACK_SIZE	0x2000
 
@@ -166,6 +167,14 @@ unsigned long get_wchan(struct task_struct *p);
 #  define STACK_TOP	TASK_SIZE
 #  define STACK_TOP_MAX	STACK_TOP
 
+void disable_hlt(void);
+void enable_hlt(void);
+void default_idle(void);
+
+#ifdef CONFIG_DEBUG_FS
+extern struct dentry *of_debugfs_root;
+#endif
+
 #  endif /* __ASSEMBLY__ */
 # endif /* CONFIG_MMU */
 #endif /* _ASM_MICROBLAZE_PROCESSOR_H */
diff --git a/arch/microblaze/include/asm/setup.h b/arch/microblaze/include/asm/setup.h
index 6c72ed7..aa22511 100644
--- a/arch/microblaze/include/asm/setup.h
+++ b/arch/microblaze/include/asm/setup.h
@@ -20,6 +20,8 @@ extern unsigned int boot_cpuid; /* move to smp.h */
 
 extern char cmd_line[COMMAND_LINE_SIZE];
 
+extern char *klimit;
+
 void early_printk(const char *fmt, ...);
 
 int setup_early_printk(char *opt);
@@ -46,6 +48,10 @@ void machine_shutdown(void);
 void machine_halt(void);
 void machine_power_off(void);
 
+void free_init_pages(char *what, unsigned long begin, unsigned long end);
+extern void *alloc_maybe_bootmem(size_t size, gfp_t mask);
+extern void *zalloc_maybe_bootmem(size_t size, gfp_t mask);
+
 #  endif/* __KERNEL__ */
 # endif /* __ASSEMBLY__ */
 #endif /* _ASM_MICROBLAZE_SETUP_H */
diff --git a/arch/microblaze/include/asm/switch_to.h b/arch/microblaze/include/asm/switch_to.h
new file mode 100644
index 0000000..f45baa2
--- /dev/null
+++ b/arch/microblaze/include/asm/switch_to.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_SWITCH_TO_H
+#define _ASM_MICROBLAZE_SWITCH_TO_H
+
+struct task_struct;
+struct thread_info;
+
+extern struct task_struct *_switch_to(struct thread_info *prev,
+					struct thread_info *next);
+
+#define switch_to(prev, next, last)					\
+	do {								\
+		(last) = _switch_to(task_thread_info(prev),		\
+					task_thread_info(next));	\
+	} while (0)
+
+#endif /* _ASM_MICROBLAZE_SWITCH_TO_H */
diff --git a/arch/microblaze/include/asm/system.h b/arch/microblaze/include/asm/system.h
index 5a433cb..ccc4f86 100644
--- a/arch/microblaze/include/asm/system.h
+++ b/arch/microblaze/include/asm/system.h
@@ -1,97 +1,7 @@
-/*
- * Copyright (C) 2006 Atmark Techno, Inc.
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License. See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-
-#ifndef _ASM_MICROBLAZE_SYSTEM_H
-#define _ASM_MICROBLAZE_SYSTEM_H
-
-#include <asm/registers.h>
-#include <asm/setup.h>
-#include <asm/irqflags.h>
-#include <asm/cache.h>
-
-#include <asm-generic/cmpxchg.h>
-#include <asm-generic/cmpxchg-local.h>
-
-struct task_struct;
-struct thread_info;
-
-extern struct task_struct *_switch_to(struct thread_info *prev,
-					struct thread_info *next);
-
-#define switch_to(prev, next, last)					\
-	do {								\
-		(last) = _switch_to(task_thread_info(prev),		\
-					task_thread_info(next));	\
-	} while (0)
-
-#define smp_read_barrier_depends()	do {} while (0)
-#define read_barrier_depends()		do {} while (0)
-
-#define nop()			asm volatile ("nop")
-#define mb()			barrier()
-#define rmb()			mb()
-#define wmb()			mb()
-#define set_mb(var, value)	do { var = value; mb(); } while (0)
-#define set_wmb(var, value)	do { var = value; wmb(); } while (0)
-
-#define smp_mb()		mb()
-#define smp_rmb()		rmb()
-#define smp_wmb()		wmb()
-
-void __bad_xchg(volatile void *ptr, int size);
-
-static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
-								int size)
-{
-	unsigned long ret;
-	unsigned long flags;
-
-	switch (size) {
-	case 1:
-		local_irq_save(flags);
-		ret = *(volatile unsigned char *)ptr;
-		*(volatile unsigned char *)ptr = x;
-		local_irq_restore(flags);
-		break;
-
-	case 4:
-		local_irq_save(flags);
-		ret = *(volatile unsigned long *)ptr;
-		*(volatile unsigned long *)ptr = x;
-		local_irq_restore(flags);
-		break;
-	default:
-		__bad_xchg(ptr, size), ret = 0;
-		break;
-	}
-
-	return ret;
-}
-
-void disable_hlt(void);
-void enable_hlt(void);
-void default_idle(void);
-
-#define xchg(ptr, x) \
-	((__typeof__(*(ptr))) __xchg((unsigned long)(x), (ptr), sizeof(*(ptr))))
-
-void free_init_pages(char *what, unsigned long begin, unsigned long end);
-void free_initmem(void);
-extern char *klimit;
-extern void ret_from_fork(void);
-
-extern void *alloc_maybe_bootmem(size_t size, gfp_t mask);
-extern void *zalloc_maybe_bootmem(size_t size, gfp_t mask);
-
-#ifdef CONFIG_DEBUG_FS
-extern struct dentry *of_debugfs_root;
-#endif
-
-#define arch_align_stack(x) (x)
-
-#endif /* _ASM_MICROBLAZE_SYSTEM_H */
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/exec.h>
+#include <asm/special_insns.h>
+#include <asm/switch_to.h>
+extern void free_initmem(void);
diff --git a/arch/microblaze/kernel/cpu/pvr.c b/arch/microblaze/kernel/cpu/pvr.c
index 488c1ed..3a749d5 100644
--- a/arch/microblaze/kernel/cpu/pvr.c
+++ b/arch/microblaze/kernel/cpu/pvr.c
@@ -12,7 +12,6 @@
 
 #include <linux/kernel.h>
 #include <linux/compiler.h>
-#include <asm/system.h>
 #include <asm/exceptions.h>
 #include <asm/pvr.h>
 
diff --git a/arch/microblaze/kernel/microblaze_ksyms.c b/arch/microblaze/kernel/microblaze_ksyms.c
index 49faeb4..bb4907c 100644
--- a/arch/microblaze/kernel/microblaze_ksyms.c
+++ b/arch/microblaze/kernel/microblaze_ksyms.c
@@ -18,7 +18,6 @@
 #include <asm/cacheflush.h>
 #include <linux/io.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <linux/ftrace.h>
 #include <linux/uaccess.h>
 
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 7dcb5bf..831c960 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -13,7 +13,6 @@
 #include <linux/pm.h>
 #include <linux/tick.h>
 #include <linux/bitops.h>
-#include <asm/system.h>
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h> /* for USER_DS macros */
 #include <asm/cacheflush.h>
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index 80d314e..4a764cc 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -36,7 +36,6 @@
 #include <asm/processor.h>
 #include <asm/irq.h>
 #include <linux/io.h>
-#include <asm/system.h>
 #include <asm/mmu.h>
 #include <asm/pgtable.h>
 #include <asm/sections.h>
diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
index 604cd9d..a953788 100644
--- a/arch/microblaze/kernel/setup.c
+++ b/arch/microblaze/kernel/setup.c
@@ -30,7 +30,6 @@
 #include <asm/entry.h>
 #include <asm/cpuinfo.h>
 
-#include <asm/system.h>
 #include <asm/prom.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
index 3cb0bf6..d3a38ec 100644
--- a/arch/microblaze/kernel/timer.c
+++ b/arch/microblaze/kernel/timer.c
@@ -27,7 +27,6 @@
 #include <asm/setup.h>
 #include <asm/prom.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <linux/cnt32_to_63.h>
 
 #ifdef CONFIG_SELFMOD_TIMER
diff --git a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
index ba034d4..5541ac5 100644
--- a/arch/microblaze/kernel/traps.c
+++ b/arch/microblaze/kernel/traps.c
@@ -15,7 +15,6 @@
 #include <linux/debug_locks.h>
 
 #include <asm/exceptions.h>
-#include <asm/system.h>
 #include <asm/unwind.h>
 
 void trap_init(void)
diff --git a/arch/microblaze/lib/memcpy.c b/arch/microblaze/lib/memcpy.c
index 52746e7..fe9c53f 100644
--- a/arch/microblaze/lib/memcpy.c
+++ b/arch/microblaze/lib/memcpy.c
@@ -30,7 +30,6 @@
 #include <linux/module.h>
 
 #include <linux/string.h>
-#include <asm/system.h>
 
 #ifdef __HAVE_ARCH_MEMCPY
 #ifndef CONFIG_OPT_LIB_FUNCTION
diff --git a/arch/microblaze/mm/fault.c b/arch/microblaze/mm/fault.c
index ae97d2c..c38a265 100644
--- a/arch/microblaze/mm/fault.c
+++ b/arch/microblaze/mm/fault.c
@@ -33,7 +33,6 @@
 #include <asm/pgtable.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <asm/exceptions.h>
 

