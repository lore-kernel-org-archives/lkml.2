Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030453Ab2CGTuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:50:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030293Ab2CGTua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:50:30 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 23/29] Disintegrate asm/system.h for Score
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:50:13 +0000
Message-ID: <20120307195013.15987.33152.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disintegrate asm/system.h for Score.  Not compiled.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/score/include/asm/atomic.h    |   43 +++++++++++++++++
 arch/score/include/asm/barrier.h   |   16 ++++++
 arch/score/include/asm/bug.h       |   10 ++++
 arch/score/include/asm/exec.h      |    6 ++
 arch/score/include/asm/switch_to.h |   13 +++++
 arch/score/include/asm/system.h    |   90 ------------------------------------
 6 files changed, 88 insertions(+), 90 deletions(-)
 create mode 100644 arch/score/include/asm/barrier.h
 create mode 100644 arch/score/include/asm/exec.h
 create mode 100644 arch/score/include/asm/switch_to.h
 delete mode 100644 arch/score/include/asm/system.h

diff --git a/arch/score/include/asm/atomic.h b/arch/score/include/asm/atomic.h
index 84eb8dd..77b44de 100644
--- a/arch/score/include/asm/atomic.h
+++ b/arch/score/include/asm/atomic.h
@@ -3,4 +3,47 @@
 
 #include <asm-generic/atomic.h>
 
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
diff --git a/arch/score/include/asm/bug.h b/arch/score/include/asm/bug.h
index bb76a33..d1ddaa4 100644
--- a/arch/score/include/asm/bug.h
+++ b/arch/score/include/asm/bug.h
@@ -3,4 +3,14 @@
 
 #include <asm-generic/bug.h>
 
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
deleted file mode 100644
index 589d5c7..0000000
--- a/arch/score/include/asm/system.h
+++ /dev/null
@@ -1,90 +0,0 @@
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

