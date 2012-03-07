Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284Ab2CGTtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:49:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030233Ab2CGTtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:49:09 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 16/29] Disintegrate asm/system.h for Microblaze
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:48:55 +0000
Message-ID: <20120307194855.15987.36774.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for Microblaze.  Not compiled.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/microblaze/include/asm/atomic.h    |   36 ++++++++++++
 arch/microblaze/include/asm/barrier.h   |   26 ++++++++
 arch/microblaze/include/asm/exec.h      |   14 +++++
 arch/microblaze/include/asm/processor.h |   11 +++-
 arch/microblaze/include/asm/setup.h     |    6 ++
 arch/microblaze/include/asm/switch_to.h |   24 ++++++++
 arch/microblaze/include/asm/system.h    |   96 -------------------------------
 7 files changed, 116 insertions(+), 97 deletions(-)
 create mode 100644 arch/microblaze/include/asm/barrier.h
 create mode 100644 arch/microblaze/include/asm/exec.h
 create mode 100644 arch/microblaze/include/asm/switch_to.h
 delete mode 100644 arch/microblaze/include/asm/system.h

diff --git a/arch/microblaze/include/asm/atomic.h b/arch/microblaze/include/asm/atomic.h
index 615f539..f3fadd14 100644
--- a/arch/microblaze/include/asm/atomic.h
+++ b/arch/microblaze/include/asm/atomic.h
@@ -22,4 +22,40 @@ static inline int atomic_dec_if_positive(atomic_t *v)
 	return res;
 }
 
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
 #endif /* _ASM_MICROBLAZE_ATOMIC_H */
diff --git a/arch/microblaze/include/asm/barrier.h b/arch/microblaze/include/asm/barrier.h
new file mode 100644
index 0000000..5bdb324
--- /dev/null
+++ b/arch/microblaze/include/asm/barrier.h
@@ -0,0 +1,26 @@
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
+#define smp_read_barrier_depends()	do {} while (0)
+#define read_barrier_depends()		do {} while (0)
+
+#define nop()			asm volatile ("nop")
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
deleted file mode 100644
index 81f9f23..0000000
--- a/arch/microblaze/include/asm/system.h
+++ /dev/null
@@ -1,96 +0,0 @@
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

