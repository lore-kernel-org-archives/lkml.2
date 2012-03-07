Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760089Ab2CGTsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:48:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760005Ab2CGTsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:48:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 11/29] Disintegrate asm/system.h for H8300
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:47:56 +0000
Message-ID: <20120307194756.15987.49068.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for H8300.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/h8300/include/asm/atomic.h    |   53 ++++++++++++++
 arch/h8300/include/asm/barrier.h   |   26 +++++++
 arch/h8300/include/asm/bug.h       |    4 +
 arch/h8300/include/asm/exec.h      |    6 ++
 arch/h8300/include/asm/processor.h |    5 +
 arch/h8300/include/asm/switch_to.h |   50 +++++++++++++
 arch/h8300/include/asm/system.h    |  140 ------------------------------------
 7 files changed, 144 insertions(+), 140 deletions(-)
 create mode 100644 arch/h8300/include/asm/barrier.h
 create mode 100644 arch/h8300/include/asm/exec.h
 create mode 100644 arch/h8300/include/asm/switch_to.h
 delete mode 100644 arch/h8300/include/asm/system.h

diff --git a/arch/h8300/include/asm/atomic.h b/arch/h8300/include/asm/atomic.h
index fbc8517..62b02f1 100644
--- a/arch/h8300/include/asm/atomic.h
+++ b/arch/h8300/include/asm/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_H8300_ATOMIC__
 
 #include <linux/types.h>
+#include <linux/irqflags.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -101,6 +102,58 @@ static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 	return ret;
 }
 
+#define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
+
+struct __xchg_dummy { unsigned long a[100]; };
+#define __xg(x) ((volatile struct __xchg_dummy *)(x))
+
+static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
+{
+  unsigned long tmp, flags;
+
+  local_irq_save(flags);
+
+  switch (size) {
+  case 1:
+    __asm__ __volatile__
+    ("mov.b %2,%0\n\t"
+     "mov.b %1,%2"
+    : "=&r" (tmp) : "r" (x), "m" (*__xg(ptr)) : "memory");
+    break;
+  case 2:
+    __asm__ __volatile__
+    ("mov.w %2,%0\n\t"
+     "mov.w %1,%2"
+    : "=&r" (tmp) : "r" (x), "m" (*__xg(ptr)) : "memory");
+    break;
+  case 4:
+    __asm__ __volatile__
+    ("mov.l %2,%0\n\t"
+     "mov.l %1,%2"
+    : "=&r" (tmp) : "r" (x), "m" (*__xg(ptr)) : "memory");
+    break;
+  default:
+    tmp = 0;	  
+  }
+  local_irq_restore(flags);
+  return tmp;
+}
+
+#include <asm-generic/cmpxchg-local.h>
+
+/*
+ * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
+ * them available.
+ */
+#define cmpxchg_local(ptr, o, n)				  	       \
+	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
+			(unsigned long)(n), sizeof(*(ptr))))
+#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
+
+#ifndef CONFIG_SMP
+#include <asm-generic/cmpxchg.h>
+#endif
+
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 static inline int __atomic_add_unless(atomic_t *v, int a, int u)
diff --git a/arch/h8300/include/asm/barrier.h b/arch/h8300/include/asm/barrier.h
new file mode 100644
index 0000000..96d7a49
--- /dev/null
+++ b/arch/h8300/include/asm/barrier.h
@@ -0,0 +1,26 @@
+#ifndef _H8300_BARRIER_H
+#define _H8300_BARRIER_H
+
+/*
+ * Force strict CPU ordering.
+ * Not really required on H8...
+ */
+#define nop()  asm volatile ("nop"::)
+#define mb()   asm volatile (""   : : :"memory")
+#define rmb()  asm volatile (""   : : :"memory")
+#define wmb()  asm volatile (""   : : :"memory")
+#define set_mb(var, value) do { xchg(&var, value); } while (0)
+
+#ifdef CONFIG_SMP
+#define smp_mb()	mb()
+#define smp_rmb()	rmb()
+#define smp_wmb()	wmb()
+#define smp_read_barrier_depends()	read_barrier_depends()
+#else
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define smp_read_barrier_depends()	do { } while(0)
+#endif
+
+#endif /* _H8300_BARRIER_H */
diff --git a/arch/h8300/include/asm/bug.h b/arch/h8300/include/asm/bug.h
index 887c197..1e1be81 100644
--- a/arch/h8300/include/asm/bug.h
+++ b/arch/h8300/include/asm/bug.h
@@ -5,4 +5,8 @@
 #define is_valid_bugaddr(addr) (1)
 
 #include <asm-generic/bug.h>
+
+struct pt_regs;
+extern void die(const char *str, struct pt_regs *fp, unsigned long err);
+
 #endif
diff --git a/arch/h8300/include/asm/exec.h b/arch/h8300/include/asm/exec.h
new file mode 100644
index 0000000..c01c45c
--- /dev/null
+++ b/arch/h8300/include/asm/exec.h
@@ -0,0 +1,6 @@
+#ifndef _H8300_EXEC_H
+#define _H8300_EXEC_H
+
+#define arch_align_stack(x) (x)
+
+#endif /* _H8300_EXEC_H */
diff --git a/arch/h8300/include/asm/processor.h b/arch/h8300/include/asm/processor.h
index e834b60..61fabf1 100644
--- a/arch/h8300/include/asm/processor.h
+++ b/arch/h8300/include/asm/processor.h
@@ -135,4 +135,9 @@ unsigned long get_wchan(struct task_struct *p);
 
 #define cpu_relax()    barrier()
 
+#define HARD_RESET_NOW() ({		\
+        local_irq_disable();		\
+        asm("jmp @@0");			\
+})
+
 #endif
diff --git a/arch/h8300/include/asm/switch_to.h b/arch/h8300/include/asm/switch_to.h
new file mode 100644
index 0000000..cdd8731
--- /dev/null
+++ b/arch/h8300/include/asm/switch_to.h
@@ -0,0 +1,50 @@
+#ifndef _H8300_SWITCH_TO_H
+#define _H8300_SWITCH_TO_H
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
+ * pass prev in a0, next in a1, offset of tss in d1, and whether
+ * the mm structures are shared in d2 (to avoid atc flushing).
+ *
+ * H8/300 Porting 2002/09/04 Yoshinori Sato
+ */
+
+asmlinkage void resume(void);
+#define switch_to(prev,next,last) {                         \
+  void *_last;						    \
+  __asm__ __volatile__(					    \
+  			"mov.l	%1, er0\n\t"		    \
+			"mov.l	%2, er1\n\t"		    \
+                        "mov.l  %3, er2\n\t"                \
+			"jsr @_resume\n\t"                  \
+                        "mov.l  er2,%0\n\t"                 \
+		       : "=r" (_last)			    \
+		       : "r" (&(prev->thread)),		    \
+			 "r" (&(next->thread)),		    \
+                         "g" (prev)                         \
+		       : "cc", "er0", "er1", "er2", "er3"); \
+  (last) = _last; 					    \
+}
+
+#endif /* _H8300_SWITCH_TO_H */
diff --git a/arch/h8300/include/asm/system.h b/arch/h8300/include/asm/system.h
deleted file mode 100644
index 2c2382e..0000000
--- a/arch/h8300/include/asm/system.h
+++ /dev/null
@@ -1,140 +0,0 @@
-#ifndef _H8300_SYSTEM_H
-#define _H8300_SYSTEM_H
-
-#include <linux/linkage.h>
-#include <linux/irqflags.h>
-
-struct pt_regs;
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
- * pass prev in a0, next in a1, offset of tss in d1, and whether
- * the mm structures are shared in d2 (to avoid atc flushing).
- *
- * H8/300 Porting 2002/09/04 Yoshinori Sato
- */
-
-asmlinkage void resume(void);
-#define switch_to(prev,next,last) {                         \
-  void *_last;						    \
-  __asm__ __volatile__(					    \
-  			"mov.l	%1, er0\n\t"		    \
-			"mov.l	%2, er1\n\t"		    \
-                        "mov.l  %3, er2\n\t"                \
-			"jsr @_resume\n\t"                  \
-                        "mov.l  er2,%0\n\t"                 \
-		       : "=r" (_last)			    \
-		       : "r" (&(prev->thread)),		    \
-			 "r" (&(next->thread)),		    \
-                         "g" (prev)                         \
-		       : "cc", "er0", "er1", "er2", "er3"); \
-  (last) = _last; 					    \
-}
-
-#define iret() __asm__ __volatile__ ("rte": : :"memory", "sp", "cc")
-
-/*
- * Force strict CPU ordering.
- * Not really required on H8...
- */
-#define nop()  asm volatile ("nop"::)
-#define mb()   asm volatile (""   : : :"memory")
-#define rmb()  asm volatile (""   : : :"memory")
-#define wmb()  asm volatile (""   : : :"memory")
-#define set_mb(var, value) do { xchg(&var, value); } while (0)
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
-#define smp_read_barrier_depends()	read_barrier_depends()
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while(0)
-#endif
-
-#define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
-
-struct __xchg_dummy { unsigned long a[100]; };
-#define __xg(x) ((volatile struct __xchg_dummy *)(x))
-
-static inline unsigned long __xchg(unsigned long x, volatile void * ptr, int size)
-{
-  unsigned long tmp, flags;
-
-  local_irq_save(flags);
-
-  switch (size) {
-  case 1:
-    __asm__ __volatile__
-    ("mov.b %2,%0\n\t"
-     "mov.b %1,%2"
-    : "=&r" (tmp) : "r" (x), "m" (*__xg(ptr)) : "memory");
-    break;
-  case 2:
-    __asm__ __volatile__
-    ("mov.w %2,%0\n\t"
-     "mov.w %1,%2"
-    : "=&r" (tmp) : "r" (x), "m" (*__xg(ptr)) : "memory");
-    break;
-  case 4:
-    __asm__ __volatile__
-    ("mov.l %2,%0\n\t"
-     "mov.l %1,%2"
-    : "=&r" (tmp) : "r" (x), "m" (*__xg(ptr)) : "memory");
-    break;
-  default:
-    tmp = 0;	  
-  }
-  local_irq_restore(flags);
-  return tmp;
-}
-
-#define HARD_RESET_NOW() ({		\
-        local_irq_disable();		\
-        asm("jmp @@0");			\
-})
-
-#include <asm-generic/cmpxchg-local.h>
-
-/*
- * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
- * them available.
- */
-#define cmpxchg_local(ptr, o, n)				  	       \
-	((__typeof__(*(ptr)))__cmpxchg_local_generic((ptr), (unsigned long)(o),\
-			(unsigned long)(n), sizeof(*(ptr))))
-#define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
-
-#ifndef CONFIG_SMP
-#include <asm-generic/cmpxchg.h>
-#endif
-
-#define arch_align_stack(x) (x)
-
-extern void die(const char *str, struct pt_regs *fp, unsigned long err);
-
-#endif /* _H8300_SYSTEM_H */

