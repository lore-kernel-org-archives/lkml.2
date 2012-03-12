Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964977Ab2CLXkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:40:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964958Ab2CLXkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:40:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 23/35] Disintegrate asm/system.h for PA-RISC [ver #2]
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>, linux-parisc@vger.kernel.org
Date: Mon, 12 Mar 2012 23:39:55 +0000
Message-ID: <20120312233955.13888.12370.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
References: <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for PA-RISC.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-parisc@vger.kernel.org
---

 arch/parisc/include/asm/atomic.h        |    1 
 arch/parisc/include/asm/barrier.h       |   35 ++++++
 arch/parisc/include/asm/delay.h         |    2 
 arch/parisc/include/asm/dma.h           |    1 
 arch/parisc/include/asm/exec.h          |    6 +
 arch/parisc/include/asm/ldcw.h          |   48 +++++++++
 arch/parisc/include/asm/processor.h     |    2 
 arch/parisc/include/asm/psw.h           |   41 +++++++
 arch/parisc/include/asm/special_insns.h |   40 +++++++
 arch/parisc/include/asm/spinlock.h      |    1 
 arch/parisc/include/asm/switch_to.h     |   12 ++
 arch/parisc/include/asm/system.h        |  171 +------------------------------
 arch/parisc/include/asm/thread_info.h   |    1 
 arch/parisc/include/asm/timex.h         |    1 
 arch/parisc/include/asm/uaccess.h       |    1 
 arch/parisc/kernel/cache.c              |    1 
 arch/parisc/kernel/firmware.c           |    1 
 arch/parisc/kernel/pci.c                |    1 
 arch/parisc/kernel/ptrace.c             |    1 
 arch/parisc/kernel/smp.c                |    1 
 arch/parisc/kernel/traps.c              |    1 
 arch/parisc/lib/bitops.c                |    1 
 22 files changed, 191 insertions(+), 179 deletions(-)
 create mode 100644 arch/parisc/include/asm/barrier.h
 create mode 100644 arch/parisc/include/asm/exec.h
 create mode 100644 arch/parisc/include/asm/ldcw.h
 create mode 100644 arch/parisc/include/asm/special_insns.h
 create mode 100644 arch/parisc/include/asm/switch_to.h

diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
index 4054b31..3ae5607 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -6,7 +6,6 @@
 #define _ASM_PARISC_ATOMIC_H_
 
 #include <linux/types.h>
-#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff --git a/arch/parisc/include/asm/barrier.h b/arch/parisc/include/asm/barrier.h
new file mode 100644
index 0000000..e77d834
--- /dev/null
+++ b/arch/parisc/include/asm/barrier.h
@@ -0,0 +1,35 @@
+#ifndef __PARISC_BARRIER_H
+#define __PARISC_BARRIER_H
+
+/*
+** This is simply the barrier() macro from linux/kernel.h but when serial.c
+** uses tqueue.h uses smp_mb() defined using barrier(), linux/kernel.h
+** hasn't yet been included yet so it fails, thus repeating the macro here.
+**
+** PA-RISC architecture allows for weakly ordered memory accesses although
+** none of the processors use it. There is a strong ordered bit that is
+** set in the O-bit of the page directory entry. Operating systems that
+** can not tolerate out of order accesses should set this bit when mapping
+** pages. The O-bit of the PSW should also be set to 1 (I don't believe any
+** of the processor implemented the PSW O-bit). The PCX-W ERS states that
+** the TLB O-bit is not implemented so the page directory does not need to
+** have the O-bit set when mapping pages (section 3.1). This section also
+** states that the PSW Y, Z, G, and O bits are not implemented.
+** So it looks like nothing needs to be done for parisc-linux (yet).
+** (thanks to chada for the above comment -ggg)
+**
+** The __asm__ op below simple prevents gcc/ld from reordering
+** instructions across the mb() "call".
+*/
+#define mb()		__asm__ __volatile__("":::"memory")	/* barrier() */
+#define rmb()		mb()
+#define wmb()		mb()
+#define smp_mb()	mb()
+#define smp_rmb()	mb()
+#define smp_wmb()	mb()
+#define smp_read_barrier_depends()	do { } while(0)
+#define read_barrier_depends()		do { } while(0)
+
+#define set_mb(var, value)		do { var = value; mb(); } while (0)
+
+#endif /* __PARISC_BARRIER_H */
diff --git a/arch/parisc/include/asm/delay.h b/arch/parisc/include/asm/delay.h
index 7a75e98..912ee7e 100644
--- a/arch/parisc/include/asm/delay.h
+++ b/arch/parisc/include/asm/delay.h
@@ -1,7 +1,7 @@
 #ifndef _PARISC_DELAY_H
 #define _PARISC_DELAY_H
 
-#include <asm/system.h>    /* for mfctl() */
+#include <asm/special_insns.h>    /* for mfctl() */
 #include <asm/processor.h> /* for boot_cpu_data */
 
 
diff --git a/arch/parisc/include/asm/dma.h b/arch/parisc/include/asm/dma.h
index f7a18f9..fd48ae2 100644
--- a/arch/parisc/include/asm/dma.h
+++ b/arch/parisc/include/asm/dma.h
@@ -9,7 +9,6 @@
 #define _ASM_DMA_H
 
 #include <asm/io.h>		/* need byte IO */
-#include <asm/system.h>	
 
 #define dma_outb	outb
 #define dma_inb		inb
diff --git a/arch/parisc/include/asm/exec.h b/arch/parisc/include/asm/exec.h
new file mode 100644
index 0000000..6bb5af7
--- /dev/null
+++ b/arch/parisc/include/asm/exec.h
@@ -0,0 +1,6 @@
+#ifndef __PARISC_EXEC_H
+#define __PARISC_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* __PARISC_EXEC_H */
diff --git a/arch/parisc/include/asm/ldcw.h b/arch/parisc/include/asm/ldcw.h
new file mode 100644
index 0000000..d2d11b7
--- /dev/null
+++ b/arch/parisc/include/asm/ldcw.h
@@ -0,0 +1,48 @@
+#ifndef __PARISC_LDCW_H
+#define __PARISC_LDCW_H
+
+#ifndef CONFIG_PA20
+/* Because kmalloc only guarantees 8-byte alignment for kmalloc'd data,
+   and GCC only guarantees 8-byte alignment for stack locals, we can't
+   be assured of 16-byte alignment for atomic lock data even if we
+   specify "__attribute ((aligned(16)))" in the type declaration.  So,
+   we use a struct containing an array of four ints for the atomic lock
+   type and dynamically select the 16-byte aligned int from the array
+   for the semaphore.  */
+
+#define __PA_LDCW_ALIGNMENT	16
+#define __ldcw_align(a) ({					\
+	unsigned long __ret = (unsigned long) &(a)->lock[0];	\
+	__ret = (__ret + __PA_LDCW_ALIGNMENT - 1)		\
+		& ~(__PA_LDCW_ALIGNMENT - 1);			\
+	(volatile unsigned int *) __ret;			\
+})
+#define __LDCW	"ldcw"
+
+#else /*CONFIG_PA20*/
+/* From: "Jim Hull" <jim.hull of hp.com>
+   I've attached a summary of the change, but basically, for PA 2.0, as
+   long as the ",CO" (coherent operation) completer is specified, then the
+   16-byte alignment requirement for ldcw and ldcd is relaxed, and instead
+   they only require "natural" alignment (4-byte for ldcw, 8-byte for
+   ldcd). */
+
+#define __PA_LDCW_ALIGNMENT	4
+#define __ldcw_align(a) (&(a)->slock)
+#define __LDCW	"ldcw,co"
+
+#endif /*!CONFIG_PA20*/
+
+/* LDCW, the only atomic read-write operation PA-RISC has. *sigh*.  */
+#define __ldcw(a) ({						\
+	unsigned __ret;						\
+	__asm__ __volatile__(__LDCW " 0(%2),%0"			\
+		: "=r" (__ret), "+m" (*(a)) : "r" (a));		\
+	__ret;							\
+})
+
+#ifdef CONFIG_SMP
+# define __lock_aligned __attribute__((__section__(".data..lock_aligned")))
+#endif
+
+#endif /* __PARISC_LDCW_H */
diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
index 7213ec9..acdf4ca 100644
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -16,7 +16,6 @@
 #include <asm/pdc.h>
 #include <asm/ptrace.h>
 #include <asm/types.h>
-#include <asm/system.h>
 #include <asm/percpu.h>
 
 #endif /* __ASSEMBLY__ */
@@ -169,6 +168,7 @@ struct thread_struct {
  * Return saved PC of a blocked thread.  This is used by ps mostly.
  */
 
+struct task_struct;
 unsigned long thread_saved_pc(struct task_struct *t);
 void show_trace(struct task_struct *task, unsigned long *stack);
 
diff --git a/arch/parisc/include/asm/psw.h b/arch/parisc/include/asm/psw.h
index 5a3e23c..ad69a35 100644
--- a/arch/parisc/include/asm/psw.h
+++ b/arch/parisc/include/asm/psw.h
@@ -59,4 +59,45 @@
 #define USER_PSW_MASK (WIDE_PSW | PSW_T | PSW_N | PSW_X | PSW_B | PSW_V | PSW_CB)
 #define USER_PSW      (PSW_C | PSW_Q | PSW_P | PSW_D | PSW_I)
 
+#ifndef __ASSEMBLY__
+
+/* The program status word as bitfields.  */
+struct pa_psw {
+	unsigned int y:1;
+	unsigned int z:1;
+	unsigned int rv:2;
+	unsigned int w:1;
+	unsigned int e:1;
+	unsigned int s:1;
+	unsigned int t:1;
+
+	unsigned int h:1;
+	unsigned int l:1;
+	unsigned int n:1;
+	unsigned int x:1;
+	unsigned int b:1;
+	unsigned int c:1;
+	unsigned int v:1;
+	unsigned int m:1;
+
+	unsigned int cb:8;
+
+	unsigned int o:1;
+	unsigned int g:1;
+	unsigned int f:1;
+	unsigned int r:1;
+	unsigned int q:1;
+	unsigned int p:1;
+	unsigned int d:1;
+	unsigned int i:1;
+};
+
+#ifdef CONFIG_64BIT
+#define pa_psw(task) ((struct pa_psw *) ((char *) (task) + TASK_PT_PSW + 4))
+#else
+#define pa_psw(task) ((struct pa_psw *) ((char *) (task) + TASK_PT_PSW))
+#endif
+
+#endif /* !__ASSEMBLY__ */
+
 #endif
diff --git a/arch/parisc/include/asm/special_insns.h b/arch/parisc/include/asm/special_insns.h
new file mode 100644
index 0000000..d306b75
--- /dev/null
+++ b/arch/parisc/include/asm/special_insns.h
@@ -0,0 +1,40 @@
+#ifndef __PARISC_SPECIAL_INSNS_H
+#define __PARISC_SPECIAL_INSNS_H
+
+#define mfctl(reg)	({		\
+	unsigned long cr;		\
+	__asm__ __volatile__(		\
+		"mfctl " #reg ",%0" :	\
+		 "=r" (cr)		\
+	);				\
+	cr;				\
+})
+
+#define mtctl(gr, cr) \
+	__asm__ __volatile__("mtctl %0,%1" \
+		: /* no outputs */ \
+		: "r" (gr), "i" (cr) : "memory")
+
+/* these are here to de-mystefy the calling code, and to provide hooks */
+/* which I needed for debugging EIEM problems -PB */
+#define get_eiem() mfctl(15)
+static inline void set_eiem(unsigned long val)
+{
+	mtctl(val, 15);
+}
+
+#define mfsp(reg)	({		\
+	unsigned long cr;		\
+	__asm__ __volatile__(		\
+		"mfsp " #reg ",%0" :	\
+		 "=r" (cr)		\
+	);				\
+	cr;				\
+})
+
+#define mtsp(gr, cr) \
+	__asm__ __volatile__("mtsp %0,%1" \
+		: /* no outputs */ \
+		: "r" (gr), "i" (cr) : "memory")
+
+#endif /* __PARISC_SPECIAL_INSNS_H */
diff --git a/arch/parisc/include/asm/spinlock.h b/arch/parisc/include/asm/spinlock.h
index 74036f4..804aa28 100644
--- a/arch/parisc/include/asm/spinlock.h
+++ b/arch/parisc/include/asm/spinlock.h
@@ -1,7 +1,6 @@
 #ifndef __ASM_SPINLOCK_H
 #define __ASM_SPINLOCK_H
 
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/spinlock_types.h>
 
diff --git a/arch/parisc/include/asm/switch_to.h b/arch/parisc/include/asm/switch_to.h
new file mode 100644
index 0000000..8ed8fea
--- /dev/null
+++ b/arch/parisc/include/asm/switch_to.h
@@ -0,0 +1,12 @@
+#ifndef __PARISC_SWITCH_TO_H
+#define __PARISC_SWITCH_TO_H
+
+struct task_struct;
+
+extern struct task_struct *_switch_to(struct task_struct *, struct task_struct *);
+
+#define switch_to(prev, next, last) do {			\
+	(last) = _switch_to(prev, next);			\
+} while(0)
+
+#endif /* __PARISC_SWITCH_TO_H */
diff --git a/arch/parisc/include/asm/system.h b/arch/parisc/include/asm/system.h
index b19e63a..fc2c126 100644
--- a/arch/parisc/include/asm/system.h
+++ b/arch/parisc/include/asm/system.h
@@ -1,165 +1,6 @@
-#ifndef __PARISC_SYSTEM_H
-#define __PARISC_SYSTEM_H
-
-#include <linux/irqflags.h>
-
-/* The program status word as bitfields.  */
-struct pa_psw {
-	unsigned int y:1;
-	unsigned int z:1;
-	unsigned int rv:2;
-	unsigned int w:1;
-	unsigned int e:1;
-	unsigned int s:1;
-	unsigned int t:1;
-
-	unsigned int h:1;
-	unsigned int l:1;
-	unsigned int n:1;
-	unsigned int x:1;
-	unsigned int b:1;
-	unsigned int c:1;
-	unsigned int v:1;
-	unsigned int m:1;
-
-	unsigned int cb:8;
-
-	unsigned int o:1;
-	unsigned int g:1;
-	unsigned int f:1;
-	unsigned int r:1;
-	unsigned int q:1;
-	unsigned int p:1;
-	unsigned int d:1;
-	unsigned int i:1;
-};
-
-#ifdef CONFIG_64BIT
-#define pa_psw(task) ((struct pa_psw *) ((char *) (task) + TASK_PT_PSW + 4))
-#else
-#define pa_psw(task) ((struct pa_psw *) ((char *) (task) + TASK_PT_PSW))
-#endif
-
-struct task_struct;
-
-extern struct task_struct *_switch_to(struct task_struct *, struct task_struct *);
-
-#define switch_to(prev, next, last) do {			\
-	(last) = _switch_to(prev, next);			\
-} while(0)
-
-#define mfctl(reg)	({		\
-	unsigned long cr;		\
-	__asm__ __volatile__(		\
-		"mfctl " #reg ",%0" :	\
-		 "=r" (cr)		\
-	);				\
-	cr;				\
-})
-
-#define mtctl(gr, cr) \
-	__asm__ __volatile__("mtctl %0,%1" \
-		: /* no outputs */ \
-		: "r" (gr), "i" (cr) : "memory")
-
-/* these are here to de-mystefy the calling code, and to provide hooks */
-/* which I needed for debugging EIEM problems -PB */
-#define get_eiem() mfctl(15)
-static inline void set_eiem(unsigned long val)
-{
-	mtctl(val, 15);
-}
-
-#define mfsp(reg)	({		\
-	unsigned long cr;		\
-	__asm__ __volatile__(		\
-		"mfsp " #reg ",%0" :	\
-		 "=r" (cr)		\
-	);				\
-	cr;				\
-})
-
-#define mtsp(gr, cr) \
-	__asm__ __volatile__("mtsp %0,%1" \
-		: /* no outputs */ \
-		: "r" (gr), "i" (cr) : "memory")
-
-
-/*
-** This is simply the barrier() macro from linux/kernel.h but when serial.c
-** uses tqueue.h uses smp_mb() defined using barrier(), linux/kernel.h
-** hasn't yet been included yet so it fails, thus repeating the macro here.
-**
-** PA-RISC architecture allows for weakly ordered memory accesses although
-** none of the processors use it. There is a strong ordered bit that is
-** set in the O-bit of the page directory entry. Operating systems that
-** can not tolerate out of order accesses should set this bit when mapping
-** pages. The O-bit of the PSW should also be set to 1 (I don't believe any
-** of the processor implemented the PSW O-bit). The PCX-W ERS states that
-** the TLB O-bit is not implemented so the page directory does not need to
-** have the O-bit set when mapping pages (section 3.1). This section also
-** states that the PSW Y, Z, G, and O bits are not implemented.
-** So it looks like nothing needs to be done for parisc-linux (yet).
-** (thanks to chada for the above comment -ggg)
-**
-** The __asm__ op below simple prevents gcc/ld from reordering
-** instructions across the mb() "call".
-*/
-#define mb()		__asm__ __volatile__("":::"memory")	/* barrier() */
-#define rmb()		mb()
-#define wmb()		mb()
-#define smp_mb()	mb()
-#define smp_rmb()	mb()
-#define smp_wmb()	mb()
-#define smp_read_barrier_depends()	do { } while(0)
-#define read_barrier_depends()		do { } while(0)
-
-#define set_mb(var, value)		do { var = value; mb(); } while (0)
-
-#ifndef CONFIG_PA20
-/* Because kmalloc only guarantees 8-byte alignment for kmalloc'd data,
-   and GCC only guarantees 8-byte alignment for stack locals, we can't
-   be assured of 16-byte alignment for atomic lock data even if we
-   specify "__attribute ((aligned(16)))" in the type declaration.  So,
-   we use a struct containing an array of four ints for the atomic lock
-   type and dynamically select the 16-byte aligned int from the array
-   for the semaphore.  */
-
-#define __PA_LDCW_ALIGNMENT	16
-#define __ldcw_align(a) ({					\
-	unsigned long __ret = (unsigned long) &(a)->lock[0];	\
-	__ret = (__ret + __PA_LDCW_ALIGNMENT - 1)		\
-		& ~(__PA_LDCW_ALIGNMENT - 1);			\
-	(volatile unsigned int *) __ret;			\
-})
-#define __LDCW	"ldcw"
-
-#else /*CONFIG_PA20*/
-/* From: "Jim Hull" <jim.hull of hp.com>
-   I've attached a summary of the change, but basically, for PA 2.0, as
-   long as the ",CO" (coherent operation) completer is specified, then the
-   16-byte alignment requirement for ldcw and ldcd is relaxed, and instead
-   they only require "natural" alignment (4-byte for ldcw, 8-byte for
-   ldcd). */
-
-#define __PA_LDCW_ALIGNMENT	4
-#define __ldcw_align(a) (&(a)->slock)
-#define __LDCW	"ldcw,co"
-
-#endif /*!CONFIG_PA20*/
-
-/* LDCW, the only atomic read-write operation PA-RISC has. *sigh*.  */
-#define __ldcw(a) ({						\
-	unsigned __ret;						\
-	__asm__ __volatile__(__LDCW " 0(%2),%0"			\
-		: "=r" (__ret), "+m" (*(a)) : "r" (a));		\
-	__ret;							\
-})
-
-#ifdef CONFIG_SMP
-# define __lock_aligned __attribute__((__section__(".data..lock_aligned")))
-#endif
-
-#define arch_align_stack(x) (x)
-
-#endif
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/exec.h>
+#include <asm/ldcw.h>
+#include <asm/special_insns.h>
+#include <asm/switch_to.h>
diff --git a/arch/parisc/include/asm/thread_info.h b/arch/parisc/include/asm/thread_info.h
index 6d9c7c7..83ae7dd 100644
--- a/arch/parisc/include/asm/thread_info.h
+++ b/arch/parisc/include/asm/thread_info.h
@@ -5,6 +5,7 @@
 
 #ifndef __ASSEMBLY__
 #include <asm/processor.h>
+#include <asm/special_insns.h>
 
 struct thread_info {
 	struct task_struct *task;	/* main task structure */
diff --git a/arch/parisc/include/asm/timex.h b/arch/parisc/include/asm/timex.h
index 3b68d77..2bd51f6 100644
--- a/arch/parisc/include/asm/timex.h
+++ b/arch/parisc/include/asm/timex.h
@@ -6,7 +6,6 @@
 #ifndef _ASMPARISC_TIMEX_H
 #define _ASMPARISC_TIMEX_H
 
-#include <asm/system.h>
 
 #define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
 
diff --git a/arch/parisc/include/asm/uaccess.h b/arch/parisc/include/asm/uaccess.h
index ff4cf9d..9ac0660 100644
--- a/arch/parisc/include/asm/uaccess.h
+++ b/arch/parisc/include/asm/uaccess.h
@@ -5,7 +5,6 @@
  * User space memory access functions
  */
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/cache.h>
 #include <asm/errno.h>
 #include <asm-generic/uaccess-unaligned.h>
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 83335f3..9d18189 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -22,7 +22,6 @@
 #include <asm/cache.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/processor.h>
diff --git a/arch/parisc/kernel/firmware.c b/arch/parisc/kernel/firmware.c
index 4896ed0..f65fa48 100644
--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -67,7 +67,6 @@
 #include <asm/page.h>
 #include <asm/pdc.h>
 #include <asm/pdcpat.h>
-#include <asm/system.h>
 #include <asm/processor.h>	/* for boot_cpu_data */
 
 static DEFINE_SPINLOCK(pdc_lock);
diff --git a/arch/parisc/kernel/pci.c b/arch/parisc/kernel/pci.c
index 9efd974..4f0cf0c 100644
--- a/arch/parisc/kernel/pci.c
+++ b/arch/parisc/kernel/pci.c
@@ -16,7 +16,6 @@
 #include <linux/types.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/superio.h>
 
 #define DEBUG_RESOURCES 0
diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
index 2905b1f..857c2f5 100644
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -22,7 +22,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/asm-offsets.h>
 
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 32d5884..5006e8e 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -32,7 +32,6 @@
 #include <linux/bitops.h>
 #include <linux/ftrace.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/current.h>
 #include <asm/delay.h>
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index f19e660..45ba99f 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -27,7 +27,6 @@
 #include <linux/bug.h>
 
 #include <asm/assembly.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/arch/parisc/lib/bitops.c b/arch/parisc/lib/bitops.c
index a8bffd8..1871188 100644
--- a/arch/parisc/lib/bitops.c
+++ b/arch/parisc/lib/bitops.c
@@ -8,7 +8,6 @@
 
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
-#include <asm/system.h>
 #include <linux/atomic.h>
 
 #ifdef CONFIG_SMP

