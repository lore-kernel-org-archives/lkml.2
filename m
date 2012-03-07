Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030400Ab2CGTuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:50:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030250Ab2CGTt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:49:59 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/29] Disintegrate asm/system.h for PA-RISC
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:49:37 +0000
Message-ID: <20120307194937.15987.16850.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for PA-RISC.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/parisc/include/asm/barrier.h       |   35 +++++++
 arch/parisc/include/asm/delay.h         |    2 
 arch/parisc/include/asm/dma.h           |    1 
 arch/parisc/include/asm/exec.h          |    6 +
 arch/parisc/include/asm/ldcw.h          |   48 +++++++++
 arch/parisc/include/asm/processor.h     |    1 
 arch/parisc/include/asm/psw.h           |   41 ++++++++
 arch/parisc/include/asm/special_insns.h |   40 ++++++++
 arch/parisc/include/asm/switch_to.h     |   12 ++
 arch/parisc/include/asm/system.h        |  165 -------------------------------
 arch/parisc/include/asm/thread_info.h   |    1 
 11 files changed, 185 insertions(+), 167 deletions(-)
 create mode 100644 arch/parisc/include/asm/barrier.h
 create mode 100644 arch/parisc/include/asm/exec.h
 create mode 100644 arch/parisc/include/asm/ldcw.h
 create mode 100644 arch/parisc/include/asm/special_insns.h
 create mode 100644 arch/parisc/include/asm/switch_to.h
 delete mode 100644 arch/parisc/include/asm/system.h

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
index 1f9e484..acdf4ca 100644
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -168,6 +168,7 @@ struct thread_struct {
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
deleted file mode 100644
index b19e63a..0000000
--- a/arch/parisc/include/asm/system.h
+++ /dev/null
@@ -1,165 +0,0 @@
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

