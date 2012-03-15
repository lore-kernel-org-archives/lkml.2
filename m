Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161717Ab2COVEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:04:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161695Ab2COU7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:59:19 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 23/38] Disintegrate asm/system.h for Score [ver #3]
To: paul.gortmaker@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, arnd@arndb.de,
        David Howells <dhowells@redhat.com>,
        Chen Liqin <liqin.chen@sunplusct.com>
Date: Thu, 15 Mar 2012 20:58:51 +0000
Message-ID: <20120315205851.28759.10554.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
References: <20120315205514.28759.58969.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for Score.  Not compiled.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Chen Liqin <liqin.chen@sunplusct.com>
---

 arch/score/include/asm/atomic.h    |    1 
 arch/score/include/asm/barrier.h   |   16 ++++++
 arch/score/include/asm/bitops.h    |    1 
 arch/score/include/asm/bug.h       |   11 ++++
 arch/score/include/asm/cmpxchg.h   |   49 +++++++++++++++++++
 arch/score/include/asm/exec.h      |    6 ++
 arch/score/include/asm/switch_to.h |   13 +++++
 arch/score/include/asm/system.h    |   95 ++----------------------------------
 8 files changed, 101 insertions(+), 91 deletions(-)
 create mode 100644 arch/score/include/asm/barrier.h
 create mode 100644 arch/score/include/asm/cmpxchg.h
 create mode 100644 arch/score/include/asm/exec.h
 create mode 100644 arch/score/include/asm/switch_to.h

diff --git a/arch/score/include/asm/atomic.h b/arch/score/include/asm/atomic.h
index 84eb8dd..edf33db 100644
--- a/arch/score/include/asm/atomic.h
+++ b/arch/score/include/asm/atomic.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_SCORE_ATOMIC_H
 #define _ASM_SCORE_ATOMIC_H
 
+#include <asm/cmpxchg.h>
 #include <asm-generic/atomic.h>
 
 #endif /* _ASM_SCORE_ATOMIC_H */
diff --git a/arch/score/include/asm/barrier.h b/arch/score/include/asm/barrier.h
new file mode 100644
index 0000000..0eacb64
--- /dev/null
+++ b/arch/score/include/asm/barrier.h
@@ -0,0 +1,16 @@
+#ifndef _ASM_SCORE_BARRIER_H
+#define _ASM_SCORE_BARRIER_H
+
+#define mb()		barrier()
+#define rmb()		barrier()
+#define wmb()		barrier()
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+
+#define read_barrier_depends()		do {} while (0)
+#define smp_read_barrier_depends()	do {} while (0)
+
+#define set_mb(var, value) 		do {var = value; wmb(); } while (0)
+
+#endif /* _ASM_SCORE_BARRIER_H */
diff --git a/arch/score/include/asm/bitops.h b/arch/score/include/asm/bitops.h
index 2763b05..a304096 100644
--- a/arch/score/include/asm/bitops.h
+++ b/arch/score/include/asm/bitops.h
@@ -2,7 +2,6 @@
 #define _ASM_SCORE_BITOPS_H
 
 #include <asm/byteorder.h> /* swab32 */
-#include <asm/system.h> /* save_flags */
 
 /*
  * clear_bit() doesn't provide any barrier for the compiler.
diff --git a/arch/score/include/asm/bug.h b/arch/score/include/asm/bug.h
index bb76a33..fd7164a 100644
--- a/arch/score/include/asm/bug.h
+++ b/arch/score/include/asm/bug.h
@@ -3,4 +3,15 @@
 
 #include <asm-generic/bug.h>
 
+struct pt_regs;
+extern void __die(const char *, struct pt_regs *, const char *,
+	const char *, unsigned long) __attribute__((noreturn));
+extern void __die_if_kernel(const char *, struct pt_regs *, const char *,
+	const char *, unsigned long);
+
+#define die(msg, regs)							\
+	__die(msg, regs, __FILE__ ":", __func__, __LINE__)
+#define die_if_kernel(msg, regs)					\
+	__die_if_kernel(msg, regs, __FILE__ ":", __func__, __LINE__)
+
 #endif /* _ASM_SCORE_BUG_H */
diff --git a/arch/score/include/asm/cmpxchg.h b/arch/score/include/asm/cmpxchg.h
new file mode 100644
index 0000000..f384839
--- /dev/null
+++ b/arch/score/include/asm/cmpxchg.h
@@ -0,0 +1,49 @@
+#ifndef _ASM_SCORE_CMPXCHG_H
+#define _ASM_SCORE_CMPXCHG_H
+
+#include <linux/irqflags.h>
+
+struct __xchg_dummy { unsigned long a[100]; };
+#define __xg(x) ((struct __xchg_dummy *)(x))
+
+static inline
+unsigned long __xchg(volatile unsigned long *m, unsigned long val)
+{
+	unsigned long retval;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	retval = *m;
+	*m = val;
+	local_irq_restore(flags);
+	return retval;
+}
+
+#define xchg(ptr, v)						\
+	((__typeof__(*(ptr))) __xchg((unsigned long *)(ptr),	\
+					(unsigned long)(v)))
+
+static inline unsigned long __cmpxchg(volatile unsigned long *m,
+				unsigned long old, unsigned long new)
+{
+	unsigned long retval;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	retval = *m;
+	if (retval == old)
+		*m = new;
+	local_irq_restore(flags);
+	return retval;
+}
+
+#define cmpxchg(ptr, o, n)					\
+	((__typeof__(*(ptr))) __cmpxchg((unsigned long *)(ptr),	\
+					(unsigned long)(o),	\
+					(unsigned long)(n)))
+
+#define __HAVE_ARCH_CMPXCHG	1
+
+#include <asm-generic/cmpxchg-local.h>
+
+#endif /* _ASM_SCORE_CMPXCHG_H */
diff --git a/arch/score/include/asm/exec.h b/arch/score/include/asm/exec.h
new file mode 100644
index 0000000..f9f3cd5
--- /dev/null
+++ b/arch/score/include/asm/exec.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_EXEC_H
+#define _ASM_SCORE_EXEC_H
+
+extern unsigned long arch_align_stack(unsigned long sp);
+
+#endif /* _ASM_SCORE_EXEC_H */
diff --git a/arch/score/include/asm/switch_to.h b/arch/score/include/asm/switch_to.h
new file mode 100644
index 0000000..031756b
--- /dev/null
+++ b/arch/score/include/asm/switch_to.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_SCORE_SWITCH_TO_H
+#define _ASM_SCORE_SWITCH_TO_H
+
+extern void *resume(void *last, void *next, void *next_ti);
+
+#define switch_to(prev, next, last)				\
+do {								\
+	(last) = resume(prev, next, task_thread_info(next));	\
+} while (0)
+
+#define finish_arch_switch(prev)	do {} while (0)
+
+#endif /* _ASM_SCORE_SWITCH_TO_H */
diff --git a/arch/score/include/asm/system.h b/arch/score/include/asm/system.h
index 589d5c7..a7f4057 100644
--- a/arch/score/include/asm/system.h
+++ b/arch/score/include/asm/system.h
@@ -1,90 +1,5 @@
-#ifndef _ASM_SCORE_SYSTEM_H
-#define _ASM_SCORE_SYSTEM_H
-
-#include <linux/types.h>
-#include <linux/irqflags.h>
-
-struct pt_regs;
-struct task_struct;
-
-extern void *resume(void *last, void *next, void *next_ti);
-
-#define switch_to(prev, next, last)				\
-do {								\
-	(last) = resume(prev, next, task_thread_info(next));	\
-} while (0)
-
-#define finish_arch_switch(prev)	do {} while (0)
-
-typedef void (*vi_handler_t)(void);
-extern unsigned long arch_align_stack(unsigned long sp);
-
-#define mb()		barrier()
-#define rmb()		barrier()
-#define wmb()		barrier()
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-
-#define read_barrier_depends()		do {} while (0)
-#define smp_read_barrier_depends()	do {} while (0)
-
-#define set_mb(var, value) 		do {var = value; wmb(); } while (0)
-
-#define __HAVE_ARCH_CMPXCHG	1
-
-#include <asm-generic/cmpxchg-local.h>
-
-#ifndef __ASSEMBLY__
-
-struct __xchg_dummy { unsigned long a[100]; };
-#define __xg(x) ((struct __xchg_dummy *)(x))
-
-static inline
-unsigned long __xchg(volatile unsigned long *m, unsigned long val)
-{
-	unsigned long retval;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	retval = *m;
-	*m = val;
-	local_irq_restore(flags);
-	return retval;
-}
-
-#define xchg(ptr, v)						\
-	((__typeof__(*(ptr))) __xchg((unsigned long *)(ptr),	\
-					(unsigned long)(v)))
-
-static inline unsigned long __cmpxchg(volatile unsigned long *m,
-				unsigned long old, unsigned long new)
-{
-	unsigned long retval;
-	unsigned long flags;
-
-	local_irq_save(flags);
-	retval = *m;
-	if (retval == old)
-		*m = new;
-	local_irq_restore(flags);
-	return retval;
-}
-
-#define cmpxchg(ptr, o, n)					\
-	((__typeof__(*(ptr))) __cmpxchg((unsigned long *)(ptr),	\
-					(unsigned long)(o),	\
-					(unsigned long)(n)))
-
-extern void __die(const char *, struct pt_regs *, const char *,
-	const char *, unsigned long) __attribute__((noreturn));
-extern void __die_if_kernel(const char *, struct pt_regs *, const char *,
-	const char *, unsigned long);
-
-#define die(msg, regs)							\
-	__die(msg, regs, __FILE__ ":", __func__, __LINE__)
-#define die_if_kernel(msg, regs)					\
-	__die_if_kernel(msg, regs, __FILE__ ":", __func__, __LINE__)
-
-#endif /* !__ASSEMBLY__ */
-#endif /* _ASM_SCORE_SYSTEM_H */
+/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
+#include <asm/barrier.h>
+#include <asm/cmpxchg.h>
+#include <asm/exec.h>
+#include <asm/switch_to.h>

