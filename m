Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030510Ab2CGTxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:53:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030234Ab2CGTtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:49:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 15/29] Disintegrate asm/system.h for M68K
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:48:45 +0000
Message-ID: <20120307194844.15987.96515.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for M68K.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/m68k/include/asm/atomic.h    |  124 ++++++++++++++++++++++++
 arch/m68k/include/asm/barrier.h   |   20 ++++
 arch/m68k/include/asm/exec.h      |    6 +
 arch/m68k/include/asm/switch_to.h |   41 ++++++++
 arch/m68k/include/asm/system.h    |  193 -------------------------------------
 5 files changed, 191 insertions(+), 193 deletions(-)
 create mode 100644 arch/m68k/include/asm/barrier.h
 create mode 100644 arch/m68k/include/asm/exec.h
 create mode 100644 arch/m68k/include/asm/switch_to.h
 delete mode 100644 arch/m68k/include/asm/system.h

diff --git a/arch/m68k/include/asm/atomic.h b/arch/m68k/include/asm/atomic.h
index bf7c809..e8113e0 100644
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_M68K_ATOMIC__
 
 #include <linux/types.h>
+#include <linux/irqflags.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -17,6 +18,129 @@
 #define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = i)
 
+struct __xchg_dummy { unsigned long a[100]; };
+#define __xg(x) ((volatile struct __xchg_dummy *)(x))
+
+#ifndef CONFIG_RMW_INSNS
+static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
+{
+	unsigned long flags, tmp;
+
+	local_irq_save(flags);
+
+	switch (size) {
+	case 1:
+		tmp = *(u8 *)ptr;
+		*(u8 *)ptr = x;
+		x = tmp;
+		break;
+	case 2:
+		tmp = *(u16 *)ptr;
+		*(u16 *)ptr = x;
+		x = tmp;
+		break;
+	case 4:
+		tmp = *(u32 *)ptr;
+		*(u32 *)ptr = x;
+		x = tmp;
+		break;
+	default:
+		BUG();
+	}
+
+	local_irq_restore(flags);
+	return x;
+}
+#else
+static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
+{
+	switch (size) {
+	    case 1:
+		__asm__ __volatile__
+			("moveb %2,%0\n\t"
+			 "1:\n\t"
+			 "casb %0,%1,%2\n\t"
+			 "jne 1b"
+			 : "=&d" (x) : "d" (x), "m" (*__xg(ptr)) : "memory");
+		break;
+	    case 2:
+		__asm__ __volatile__
+			("movew %2,%0\n\t"
+			 "1:\n\t"
+			 "casw %0,%1,%2\n\t"
+			 "jne 1b"
+			 : "=&d" (x) : "d" (x), "m" (*__xg(ptr)) : "memory");
+		break;
+	    case 4:
+		__asm__ __volatile__
+			("movel %2,%0\n\t"
+			 "1:\n\t"
+			 "casl %0,%1,%2\n\t"
+			 "jne 1b"
+			 : "=&d" (x) : "d" (x), "m" (*__xg(ptr)) : "memory");
+		break;
+	}
+	return x;
+}
+#endif
+
+#define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
+
+#include <asm-generic/cmpxchg-local.h>
+
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+/*
+ * Atomic compare and exchange.  Compare OLD with MEM, if identical,
+ * store NEW in MEM.  Return the initial value in MEM.  Success is
+ * indicated by comparing RETURN with OLD.
+ */
+#ifdef CONFIG_RMW_INSNS
+#define __HAVE_ARCH_CMPXCHG	1
+
+static inline unsigned long __cmpxchg(volatile void *p, unsigned long old,
+				      unsigned long new, int size)
+{
+	switch (size) {
+	case 1:
+		__asm__ __volatile__ ("casb %0,%2,%1"
+				      : "=d" (old), "=m" (*(char *)p)
+				      : "d" (new), "0" (old), "m" (*(char *)p));
+		break;
+	case 2:
+		__asm__ __volatile__ ("casw %0,%2,%1"
+				      : "=d" (old), "=m" (*(short *)p)
+				      : "d" (new), "0" (old), "m" (*(short *)p));
+		break;
+	case 4:
+		__asm__ __volatile__ ("casl %0,%2,%1"
+				      : "=d" (old), "=m" (*(int *)p)
+				      : "d" (new), "0" (old), "m" (*(int *)p));
+		break;
+	}
+	return old;
+}
+
+#define cmpxchg(ptr, o, n)						    \
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	    \
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg_local(ptr, o, n)					    \
+	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	    \
+			(unsigned long)(n), sizeof(*(ptr))))
+#else
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+
+#include <asm-generic/cmpxchg.h>
+
+#endif
+
 /*
  * The ColdFire parts cannot do some immediate to memory operations,
  * so for them we do not specify the "i" asm constraint.
diff --git a/arch/m68k/include/asm/barrier.h b/arch/m68k/include/asm/barrier.h
new file mode 100644
index 0000000..445ce22
--- /dev/null
+++ b/arch/m68k/include/asm/barrier.h
@@ -0,0 +1,20 @@
+#ifndef _M68K_BARRIER_H
+#define _M68K_BARRIER_H
+
+/*
+ * Force strict CPU ordering.
+ * Not really required on m68k...
+ */
+#define nop()		do { asm volatile ("nop"); barrier(); } while (0)
+#define mb()		barrier()
+#define rmb()		barrier()
+#define wmb()		barrier()
+#define read_barrier_depends()	((void)0)
+#define set_mb(var, value)	({ (var) = (value); wmb(); })
+
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define smp_read_barrier_depends()	((void)0)
+
+#endif /* _M68K_BARRIER_H */
diff --git a/arch/m68k/include/asm/exec.h b/arch/m68k/include/asm/exec.h
new file mode 100644
index 0000000..0499adf
--- /dev/null
+++ b/arch/m68k/include/asm/exec.h
@@ -0,0 +1,6 @@
+#ifndef _M68K_EXEC_H
+#define _M68K_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* _M68K_EXEC_H */
diff --git a/arch/m68k/include/asm/switch_to.h b/arch/m68k/include/asm/switch_to.h
new file mode 100644
index 0000000..16fd6b6
--- /dev/null
+++ b/arch/m68k/include/asm/switch_to.h
@@ -0,0 +1,41 @@
+#ifndef _M68K_SWITCH_TO_H
+#define _M68K_SWITCH_TO_H
+
+/*
+ * switch_to(n) should switch tasks to task ptr, first checking that
+ * ptr isn't the current task, in which case it does nothing.  This
+ * also clears the TS-flag if the task we switched to has used the
+ * math co-processor latest.
+ */
+/*
+ * switch_to() saves the extra registers, that are not saved
+ * automatically by SAVE_SWITCH_STACK in resume(), ie. d0-d5 and
+ * a0-a1. Some of these are used by schedule() and its predecessors
+ * and so we might get see unexpected behaviors when a task returns
+ * with unexpected register values.
+ *
+ * syscall stores these registers itself and none of them are used
+ * by syscall after the function in the syscall has been called.
+ *
+ * Beware that resume now expects *next to be in d1 and the offset of
+ * tss to be in a1. This saves a few instructions as we no longer have
+ * to push them onto the stack and read them back right after.
+ *
+ * 02/17/96 - Jes Sorensen (jds@kom.auc.dk)
+ *
+ * Changed 96/09/19 by Andreas Schwab
+ * pass prev in a0, next in a1
+ */
+asmlinkage void resume(void);
+#define switch_to(prev,next,last) do { \
+  register void *_prev __asm__ ("a0") = (prev); \
+  register void *_next __asm__ ("a1") = (next); \
+  register void *_last __asm__ ("d1"); \
+  __asm__ __volatile__("jbsr resume" \
+		       : "=a" (_prev), "=a" (_next), "=d" (_last) \
+		       : "0" (_prev), "1" (_next) \
+		       : "d0", "d2", "d3", "d4", "d5"); \
+  (last) = _last; \
+} while (0)
+
+#endif /* _M68K_SWITCH_TO_H */
diff --git a/arch/m68k/include/asm/system.h b/arch/m68k/include/asm/system.h
deleted file mode 100644
index 47b01f4..0000000
--- a/arch/m68k/include/asm/system.h
+++ /dev/null
@@ -1,193 +0,0 @@
-#ifndef _M68K_SYSTEM_H
-#define _M68K_SYSTEM_H
-
-#include <linux/linkage.h>
-#include <linux/kernel.h>
-#include <linux/irqflags.h>
-#include <asm/segment.h>
-#include <asm/entry.h>
-
-#ifdef __KERNEL__
-
-/*
- * switch_to(n) should switch tasks to task ptr, first checking that
- * ptr isn't the current task, in which case it does nothing.  This
- * also clears the TS-flag if the task we switched to has used the
- * math co-processor latest.
- */
-/*
- * switch_to() saves the extra registers, that are not saved
- * automatically by SAVE_SWITCH_STACK in resume(), ie. d0-d5 and
- * a0-a1. Some of these are used by schedule() and its predecessors
- * and so we might get see unexpected behaviors when a task returns
- * with unexpected register values.
- *
- * syscall stores these registers itself and none of them are used
- * by syscall after the function in the syscall has been called.
- *
- * Beware that resume now expects *next to be in d1 and the offset of
- * tss to be in a1. This saves a few instructions as we no longer have
- * to push them onto the stack and read them back right after.
- *
- * 02/17/96 - Jes Sorensen (jds@kom.auc.dk)
- *
- * Changed 96/09/19 by Andreas Schwab
- * pass prev in a0, next in a1
- */
-asmlinkage void resume(void);
-#define switch_to(prev,next,last) do { \
-  register void *_prev __asm__ ("a0") = (prev); \
-  register void *_next __asm__ ("a1") = (next); \
-  register void *_last __asm__ ("d1"); \
-  __asm__ __volatile__("jbsr resume" \
-		       : "=a" (_prev), "=a" (_next), "=d" (_last) \
-		       : "0" (_prev), "1" (_next) \
-		       : "d0", "d2", "d3", "d4", "d5"); \
-  (last) = _last; \
-} while (0)
-
-
-/*
- * Force strict CPU ordering.
- * Not really required on m68k...
- */
-#define nop()		do { asm volatile ("nop"); barrier(); } while (0)
-#define mb()		barrier()
-#define rmb()		barrier()
-#define wmb()		barrier()
-#define read_barrier_depends()	((void)0)
-#define set_mb(var, value)	({ (var) = (value); wmb(); })
-
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	((void)0)
-
-#define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-
-struct __xchg_dummy { unsigned long a[100]; };
-#define __xg(x) ((volatile struct __xchg_dummy *)(x))
-
-#ifndef CONFIG_RMW_INSNS
-static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
-{
-	unsigned long flags, tmp;
-
-	local_irq_save(flags);
-
-	switch (size) {
-	case 1:
-		tmp = *(u8 *)ptr;
-		*(u8 *)ptr = x;
-		x = tmp;
-		break;
-	case 2:
-		tmp = *(u16 *)ptr;
-		*(u16 *)ptr = x;
-		x = tmp;
-		break;
-	case 4:
-		tmp = *(u32 *)ptr;
-		*(u32 *)ptr = x;
-		x = tmp;
-		break;
-	default:
-		BUG();
-	}
-
-	local_irq_restore(flags);
-	return x;
-}
-#else
-static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
-{
-	switch (size) {
-	    case 1:
-		__asm__ __volatile__
-			("moveb %2,%0\n\t"
-			 "1:\n\t"
-			 "casb %0,%1,%2\n\t"
-			 "jne 1b"
-			 : "=&d" (x) : "d" (x), "m" (*__xg(ptr)) : "memory");
-		break;
-	    case 2:
-		__asm__ __volatile__
-			("movew %2,%0\n\t"
-			 "1:\n\t"
-			 "casw %0,%1,%2\n\t"
-			 "jne 1b"
-			 : "=&d" (x) : "d" (x), "m" (*__xg(ptr)) : "memory");
-		break;
-	    case 4:
-		__asm__ __volatile__
-			("movel %2,%0\n\t"
-			 "1:\n\t"
-			 "casl %0,%1,%2\n\t"
-			 "jne 1b"
-			 : "=&d" (x) : "d" (x), "m" (*__xg(ptr)) : "memory");
-		break;
-	}
-	return x;
-}
-#endif
-
-#include <asm-generic/cmpxchg-local.h>
-
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-/*
- * Atomic compare and exchange.  Compare OLD with MEM, if identical,
- * store NEW in MEM.  Return the initial value in MEM.  Success is
- * indicated by comparing RETURN with OLD.
- */
-#ifdef CONFIG_RMW_INSNS
-#define __HAVE_ARCH_CMPXCHG	1
-
-static inline unsigned long __cmpxchg(volatile void *p, unsigned long old,
-				      unsigned long new, int size)
-{
-	switch (size) {
-	case 1:
-		__asm__ __volatile__ ("casb %0,%2,%1"
-				      : "=d" (old), "=m" (*(char *)p)
-				      : "d" (new), "0" (old), "m" (*(char *)p));
-		break;
-	case 2:
-		__asm__ __volatile__ ("casw %0,%2,%1"
-				      : "=d" (old), "=m" (*(short *)p)
-				      : "d" (new), "0" (old), "m" (*(short *)p));
-		break;
-	case 4:
-		__asm__ __volatile__ ("casl %0,%2,%1"
-				      : "=d" (old), "=m" (*(int *)p)
-				      : "d" (new), "0" (old), "m" (*(int *)p));
-		break;
-	}
-	return old;
-}
-
-#define cmpxchg(ptr, o, n)						    \
-	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	    \
-			(unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg_local(ptr, o, n)					    \
-	((__typeof__(*(ptr)))__cmpxchg((ptr), (unsigned long)(o),	    \
-			(unsigned long)(n), sizeof(*(ptr))))
-#else
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)				  	       \
-	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
-			(unsigned long)(n), sizeof(*(ptr))))
-
-#include <asm-generic/cmpxchg.h>
-
-#endif
-
-#define arch_align_stack(x) (x)
-
-#endif /* __KERNEL__ */
-
-#endif /* _M68K_SYSTEM_H */

