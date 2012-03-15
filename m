Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161605Ab2COU5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:57:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161557Ab2COU52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:57:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/38] Disintegrate asm/system.h for H8300 [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Date: Thu, 15 Mar 2012 20:57:07 +0000
Message-ID: <20120315205707.28759.22221.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for H8300.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---

 arch/h8300/include/asm/atomic.h    |    4 -
 arch/h8300/include/asm/barrier.h   |   27 +++++++
 arch/h8300/include/asm/bitops.h    |    1 
 arch/h8300/include/asm/bug.h       |    4 +
 arch/h8300/include/asm/cmpxchg.h   |   60 +++++++++++++++
 arch/h8300/include/asm/exec.h      |    6 +
 arch/h8300/include/asm/processor.h |    5 +
 arch/h8300/include/asm/switch_to.h |   50 ++++++++++++
 arch/h8300/include/asm/system.h    |  145 +-----------------------------------
 arch/h8300/kernel/irq.c            |    1 
 arch/h8300/kernel/process.c        |    1 
 arch/h8300/kernel/ptrace.c         |    1 
 arch/h8300/kernel/traps.c          |    1 
 arch/h8300/mm/fault.c              |    1 
 arch/h8300/mm/init.c               |    1 
 arch/h8300/mm/kmap.c               |    1 
 arch/h8300/mm/memory.c             |    1 
 17 files changed, 158 insertions(+), 152 deletions(-)
 create mode 100644 arch/h8300/include/asm/barrier.h
 create mode 100644 arch/h8300/include/asm/cmpxchg.h
 create mode 100644 arch/h8300/include/asm/exec.h
 create mode 100644 arch/h8300/include/asm/switch_to.h

diff --git a/arch/h8300/include/asm/atomic.h b/arch/h8300/include/asm/atomic.h
index f5a38c1..40901e3 100644
--- a/arch/h8300/include/asm/atomic.h
+++ b/arch/h8300/include/asm/atomic.h
@@ -2,6 +2,7 @@
 #define __ARCH_H8300_ATOMIC__
 
 #include <linux/types.h>
+#include <asm/cmpxchg.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
@@ -13,7 +14,6 @@
 #define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = i)
 
-#include <asm/system.h>
 #include <linux/kernel.h>
 
 static __inline__ int atomic_add_return(int i, atomic_t *v)
@@ -102,8 +102,6 @@ static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
 	return ret;
 }
 
-#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
-
 static inline int __atomic_add_unless(atomic_t *v, int a, int u)
 {
 	int ret;
diff --git a/arch/h8300/include/asm/barrier.h b/arch/h8300/include/asm/barrier.h
new file mode 100644
index 0000000..c7283c3
--- /dev/null
+++ b/arch/h8300/include/asm/barrier.h
@@ -0,0 +1,27 @@
+#ifndef _H8300_BARRIER_H
+#define _H8300_BARRIER_H
+
+#define nop()  asm volatile ("nop"::)
+
+/*
+ * Force strict CPU ordering.
+ * Not really required on H8...
+ */
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
diff --git a/arch/h8300/include/asm/bitops.h b/arch/h8300/include/asm/bitops.h
index e856c1b..eb34e0c 100644
--- a/arch/h8300/include/asm/bitops.h
+++ b/arch/h8300/include/asm/bitops.h
@@ -7,7 +7,6 @@
  */
 
 #include <linux/compiler.h>
-#include <asm/system.h>
 
 #ifdef __KERNEL__
 
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
diff --git a/arch/h8300/include/asm/cmpxchg.h b/arch/h8300/include/asm/cmpxchg.h
new file mode 100644
index 0000000..cdb203e
--- /dev/null
+++ b/arch/h8300/include/asm/cmpxchg.h
@@ -0,0 +1,60 @@
+#ifndef __ARCH_H8300_CMPXCHG__
+#define __ARCH_H8300_CMPXCHG__
+
+#include <linux/irqflags.h>
+
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
+#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+
+#endif /* __ARCH_H8300_CMPXCHG__ */
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
index 2c2382e..a7f4057 100644
--- a/arch/h8300/include/asm/system.h
+++ b/arch/h8300/include/asm/system.h
@@ -1,140 +1,5 @@
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
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/exec.h>
+#include <asm/switch_to.h>
diff --git a/arch/h8300/kernel/irq.c b/arch/h8300/kernel/irq.c
index 1f67fed..2fa8ac7 100644
--- a/arch/h8300/kernel/irq.c
+++ b/arch/h8300/kernel/irq.c
@@ -16,7 +16,6 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/io.h>
 #include <asm/setup.h>
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index 933bd38..c5d0ba9 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -38,7 +38,6 @@
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/setup.h>
 #include <asm/pgtable.h>
diff --git a/arch/h8300/kernel/ptrace.c b/arch/h8300/kernel/ptrace.c
index 497fa89..748cf65 100644
--- a/arch/h8300/kernel/ptrace.c
+++ b/arch/h8300/kernel/ptrace.c
@@ -27,7 +27,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/signal.h>
 
diff --git a/arch/h8300/kernel/traps.c b/arch/h8300/kernel/traps.c
index dfa05bd..7833aa3 100644
--- a/arch/h8300/kernel/traps.c
+++ b/arch/h8300/kernel/traps.c
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/bug.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/traps.h>
 #include <asm/page.h>
diff --git a/arch/h8300/mm/fault.c b/arch/h8300/mm/fault.c
index 1d092ab..4725359 100644
--- a/arch/h8300/mm/fault.c
+++ b/arch/h8300/mm/fault.c
@@ -17,7 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/ptrace.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 
 /*
diff --git a/arch/h8300/mm/init.c b/arch/h8300/mm/init.c
index 7cc3380..973369c 100644
--- a/arch/h8300/mm/init.c
+++ b/arch/h8300/mm/init.c
@@ -36,7 +36,6 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 #undef DEBUG
 
diff --git a/arch/h8300/mm/kmap.c b/arch/h8300/mm/kmap.c
index 944a502..f79edcd 100644
--- a/arch/h8300/mm/kmap.c
+++ b/arch/h8300/mm/kmap.c
@@ -19,7 +19,6 @@
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #undef DEBUG
 
diff --git a/arch/h8300/mm/memory.c b/arch/h8300/mm/memory.c
index 5552ddf..06e3646 100644
--- a/arch/h8300/mm/memory.c
+++ b/arch/h8300/mm/memory.c
@@ -26,7 +26,6 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/io.h>
 

