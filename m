Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab0H0CAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:00:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab0H0CAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:00:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/22] Fix M68K irqflags
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 27 Aug 2010 03:00:38 +0100
Message-ID: <20100827020038.27277.27239.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100827015905.27277.39167.stgit@warthog.procyon.org.uk>
References: <20100827015905.27277.39167.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---

 arch/m68k/include/asm/irqflags.h    |    5 ++
 arch/m68k/include/asm/irqflags_mm.h |   57 +++++++++++++++++++++++
 arch/m68k/include/asm/irqflags_no.h |   86 +++++++++++++++++++++++++++++++++++
 arch/m68k/include/asm/system_mm.h   |   25 ----------
 arch/m68k/include/asm/system_no.h   |   49 --------------------
 5 files changed, 150 insertions(+), 72 deletions(-)
 create mode 100644 arch/m68k/include/asm/irqflags.h
 create mode 100644 arch/m68k/include/asm/irqflags_mm.h
 create mode 100644 arch/m68k/include/asm/irqflags_no.h

diff --git a/arch/m68k/include/asm/irqflags.h b/arch/m68k/include/asm/irqflags.h
new file mode 100644
index 0000000..868c405
--- /dev/null
+++ b/arch/m68k/include/asm/irqflags.h
@@ -0,0 +1,5 @@
+#ifdef __uClinux__
+#include "irqflags_no.h"
+#else
+#include "irqflags_mm.h"
+#endif
diff --git a/arch/m68k/include/asm/irqflags_mm.h b/arch/m68k/include/asm/irqflags_mm.h
new file mode 100644
index 0000000..d00716d
--- /dev/null
+++ b/arch/m68k/include/asm/irqflags_mm.h
@@ -0,0 +1,57 @@
+#ifndef _M68K_IRQFLAGS_MM_H
+#define _M68K_IRQFLAGS_MM_H
+
+#include <linux/types.h>
+#include <linux/hardirq.h>
+#include <asm/thread_info.h>
+#include <asm/entry_mm.h>
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+	asm volatile ("movew %%sr,%0": "=d" (flags) : : "memory");
+	return flags;
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	asm volatile ("oriw  #0x0700,%%sr" : : : "memory");
+}
+
+#if 0
+static inline void arch_local_irq_enable(void)
+{
+		asm volatile ("andiw %0,%%sr" : : "i" (ALLOWINT) : "memory");
+}
+#else
+#define arch_local_irq_enable()						\
+	do {								\
+		if (MACH_IS_Q40 || !hardirq_count())			\
+			asm volatile ("andiw %0,%%sr"			\
+				      : : "i" (ALLOWINT) : "memory");	\
+	} while (0)
+#endif
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags = arch_local_save_flags();
+	arch_local_irq_disable();
+	return flags;
+}
+
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	asm volatile ("movew %0,%%sr": : "d" (flags) : "memory");
+}
+
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
+{
+	return (flags & ~ALLOWINT) != 0;
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+#endif /* _M68K_IRQFLAGS_MM_H */
diff --git a/arch/m68k/include/asm/irqflags_no.h b/arch/m68k/include/asm/irqflags_no.h
new file mode 100644
index 0000000..6f6c217
--- /dev/null
+++ b/arch/m68k/include/asm/irqflags_no.h
@@ -0,0 +1,86 @@
+#ifndef _M68KNOMMU_IRQFLAGS_H
+#define _M68KNOMMU_IRQFLAGS_H
+
+#include <linux/types.h>
+
+
+#ifndef CONFIG_COLDFIRE
+/* portable version */ /* FIXME - see entry.h*/
+#define ALLOWINT 0xf8ff
+#endif
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+	asm volatile ("movew %%sr,%0" : "=d" (flags) : : "memory");
+	return flags;
+}
+
+static inline void arch_local_irq_disable(void)
+{
+#ifdef CONFIG_COLDFIRE
+	asm volatile (
+		"move	%/sr,%%d0	\n\t"
+		"ori.l	#0x0700,%%d0	\n\t"
+		"move	%%d0,%/sr	\n"
+		: /* no outputs */
+		:
+		: "cc", "%d0", "memory");
+#else
+	asm volatile (
+		"oriw  #0x0700,%%sr" : : : "memory");
+#endif
+}
+
+static inline void arch_local_irq_enable(void)
+{
+#ifdef CONFIG_COLDFIRE
+	asm volatile (
+		"move	%/sr,%%d0	\n\t"
+		"andi.l	#0xf8ff,%%d0	\n\t"
+		"move	%%d0,%/sr	\n"
+		: /* no outputs */
+		:
+		: "cc", "%d0", "memory");
+#else
+	asm volatile (
+		"andiw %0,%%sr"
+		:
+		: "i" (ALLOWINT)
+		: "memory")
+#endif
+}
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags = arch_local_save_flags();
+#ifdef CONFIG_COLDFIRE
+	asm volatile (
+		"movew	#0x0700,%%d0	\n\t"
+		"or.l	%0,%%d0		\n\t"
+		"movew	%%d0,%/sr"
+		:
+		: "d" (flags)
+		: "cc", "%d0", "memory")
+#else
+	arch_local_irq_disable();
+#endif
+	return flags;
+}
+
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	asm volatile ("movew %0,%%sr" : : "d" (flags) : "memory");
+}
+
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
+{
+	return (flags & 0x0700) == 0x0700;
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+#endif /* _M68KNOMMU_IRQFLAGS_H */
diff --git a/arch/m68k/include/asm/system_mm.h b/arch/m68k/include/asm/system_mm.h
index dbb6515..12053c4 100644
--- a/arch/m68k/include/asm/system_mm.h
+++ b/arch/m68k/include/asm/system_mm.h
@@ -3,6 +3,7 @@
 
 #include <linux/linkage.h>
 #include <linux/kernel.h>
+#include <linux/irqflags.h>
 #include <asm/segment.h>
 #include <asm/entry.h>
 
@@ -62,30 +63,6 @@ asmlinkage void resume(void);
 #define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	((void)0)
 
-/* interrupt control.. */
-#if 0
-#define local_irq_enable() asm volatile ("andiw %0,%%sr": : "i" (ALLOWINT) : "memory")
-#else
-#include <linux/hardirq.h>
-#define local_irq_enable() ({							\
-	if (MACH_IS_Q40 || !hardirq_count())					\
-		asm volatile ("andiw %0,%%sr": : "i" (ALLOWINT) : "memory");	\
-})
-#endif
-#define local_irq_disable() asm volatile ("oriw  #0x0700,%%sr": : : "memory")
-#define local_save_flags(x) asm volatile ("movew %%sr,%0":"=d" (x) : : "memory")
-#define local_irq_restore(x) asm volatile ("movew %0,%%sr": :"d" (x) : "memory")
-
-static inline int irqs_disabled(void)
-{
-	unsigned long flags;
-	local_save_flags(flags);
-	return flags & ~ALLOWINT;
-}
-
-/* For spinlocks etc */
-#define local_irq_save(x)	({ local_save_flags(x); local_irq_disable(); })
-
 #define xchg(ptr,x) ((__typeof__(*(ptr)))__xchg((unsigned long)(x),(ptr),sizeof(*(ptr))))
 
 struct __xchg_dummy { unsigned long a[100]; };
diff --git a/arch/m68k/include/asm/system_no.h b/arch/m68k/include/asm/system_no.h
index 3c0718d..52ca8da 100644
--- a/arch/m68k/include/asm/system_no.h
+++ b/arch/m68k/include/asm/system_no.h
@@ -2,6 +2,7 @@
 #define _M68KNOMMU_SYSTEM_H
 
 #include <linux/linkage.h>
+#include <linux/irqflags.h>
 #include <asm/segment.h>
 #include <asm/entry.h>
 
@@ -46,54 +47,6 @@ asmlinkage void resume(void);
   (last) = _last;						\
 }
 
-#ifdef CONFIG_COLDFIRE
-#define local_irq_enable() __asm__ __volatile__ (		\
-	"move %/sr,%%d0\n\t"					\
-	"andi.l #0xf8ff,%%d0\n\t"				\
-	"move %%d0,%/sr\n"					\
-	: /* no outputs */					\
-	:							\
-        : "cc", "%d0", "memory")
-#define local_irq_disable() __asm__ __volatile__ (		\
-	"move %/sr,%%d0\n\t"					\
-	"ori.l #0x0700,%%d0\n\t"				\
-	"move %%d0,%/sr\n"					\
-	: /* no outputs */					\
-	:							\
-	: "cc", "%d0", "memory")
-/* For spinlocks etc */
-#define local_irq_save(x) __asm__ __volatile__ (		\
-	"movew %%sr,%0\n\t"					\
-	"movew #0x0700,%%d0\n\t"				\
-	"or.l  %0,%%d0\n\t"					\
-	"movew %%d0,%/sr"					\
-	: "=d" (x)						\
-	:							\
-	: "cc", "%d0", "memory")
-#else
-
-/* portable version */ /* FIXME - see entry.h*/
-#define ALLOWINT 0xf8ff
-
-#define local_irq_enable() asm volatile ("andiw %0,%%sr": : "i" (ALLOWINT) : "memory")
-#define local_irq_disable() asm volatile ("oriw  #0x0700,%%sr": : : "memory")
-#endif
-
-#define local_save_flags(x) asm volatile ("movew %%sr,%0":"=d" (x) : : "memory")
-#define local_irq_restore(x) asm volatile ("movew %0,%%sr": :"d" (x) : "memory")
-
-/* For spinlocks etc */
-#ifndef local_irq_save
-#define local_irq_save(x) do { local_save_flags(x); local_irq_disable(); } while (0)
-#endif
-
-#define	irqs_disabled()			\
-({					\
-	unsigned long flags;		\
-	local_save_flags(flags);	\
-	((flags & 0x0700) == 0x0700);	\
-})
-
 #define iret() __asm__ __volatile__ ("rte": : :"memory", "sp", "cc")
 
 /*

