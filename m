Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0H0CBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:01:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067Ab0H0CBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:01:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 22/22] Fix Sparc irqflags
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 27 Aug 2010 03:00:58 +0100
Message-ID: <20100827020058.27277.4560.stgit@warthog.procyon.org.uk>
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

 arch/sparc/include/asm/irqflags_32.h |   35 ++++++++++++++++++++--------------
 arch/sparc/include/asm/irqflags_64.h |   29 +++++++++-------------------
 arch/sparc/kernel/irq_32.c           |   12 ++++++------
 3 files changed, 36 insertions(+), 40 deletions(-)

diff --git a/arch/sparc/include/asm/irqflags_32.h b/arch/sparc/include/asm/irqflags_32.h
index 0fca9d9..081d130 100644
--- a/arch/sparc/include/asm/irqflags_32.h
+++ b/arch/sparc/include/asm/irqflags_32.h
@@ -5,33 +5,40 @@
  *
  * This file gets included from lowlevel asm headers too, to provide
  * wrapped versions of the local_irq_*() APIs, based on the
- * raw_local_irq_*() functions from the lowlevel headers.
+ * arch_local_irq_*() functions from the lowlevel headers.
  */
 #ifndef _ASM_IRQFLAGS_H
 #define _ASM_IRQFLAGS_H
 
 #ifndef __ASSEMBLY__
 
-extern void raw_local_irq_restore(unsigned long);
-extern unsigned long __raw_local_irq_save(void);
-extern void raw_local_irq_enable(void);
+#include <linux/types.h>
 
-static inline unsigned long getipl(void)
+extern void arch_local_irq_restore(unsigned long);
+extern unsigned long arch_local_irq_save(void);
+extern void arch_local_irq_enable(void);
+
+static inline unsigned long arch_local_save_flags(void)
 {
-        unsigned long retval;
+        unsigned long flags;
+
+        asm volatile("rd        %%psr, %0" : "=r" (flags));
+        return flags;
+}
 
-        __asm__ __volatile__("rd        %%psr, %0" : "=r" (retval));
-        return retval;
+static inline void arch_local_irq_disable(void)
+{
+	arch_local_irq_save();
 }
 
-#define raw_local_save_flags(flags) ((flags) = getipl())
-#define raw_local_irq_save(flags)   ((flags) = __raw_local_irq_save())
-#define raw_local_irq_disable()     ((void) __raw_local_irq_save())
-#define raw_irqs_disabled()         ((getipl() & PSR_PIL) != 0)
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
+{
+        return (flags & PSR_PIL) != 0;
+}
 
-static inline int raw_irqs_disabled_flags(unsigned long flags)
+static inline bool arch_irqs_disabled(void)
 {
-        return ((flags & PSR_PIL) != 0);
+	return arch_irqs_disabled_flags(arch_local_save_flags());
 }
 
 #endif /* (__ASSEMBLY__) */
diff --git a/arch/sparc/include/asm/irqflags_64.h b/arch/sparc/include/asm/irqflags_64.h
index bfa1ea4..aab969c 100644
--- a/arch/sparc/include/asm/irqflags_64.h
+++ b/arch/sparc/include/asm/irqflags_64.h
@@ -5,7 +5,7 @@
  *
  * This file gets included from lowlevel asm headers too, to provide
  * wrapped versions of the local_irq_*() APIs, based on the
- * raw_local_irq_*() functions from the lowlevel headers.
+ * arch_local_irq_*() functions from the lowlevel headers.
  */
 #ifndef _ASM_IRQFLAGS_H
 #define _ASM_IRQFLAGS_H
@@ -14,7 +14,7 @@
 
 #ifndef __ASSEMBLY__
 
-static inline unsigned long __raw_local_save_flags(void)
+static inline unsigned long arch_local_save_flags(void)
 {
 	unsigned long flags;
 
@@ -26,10 +26,7 @@ static inline unsigned long __raw_local_save_flags(void)
 	return flags;
 }
 
-#define raw_local_save_flags(flags) \
-		do { (flags) = __raw_local_save_flags(); } while (0)
-
-static inline void raw_local_irq_restore(unsigned long flags)
+static inline void arch_local_irq_restore(unsigned long flags)
 {
 	__asm__ __volatile__(
 		"wrpr	%0, %%pil"
@@ -39,7 +36,7 @@ static inline void raw_local_irq_restore(unsigned long flags)
 	);
 }
 
-static inline void raw_local_irq_disable(void)
+static inline void arch_local_irq_disable(void)
 {
 	__asm__ __volatile__(
 		"wrpr	%0, %%pil"
@@ -49,7 +46,7 @@ static inline void raw_local_irq_disable(void)
 	);
 }
 
-static inline void raw_local_irq_enable(void)
+static inline void arch_local_irq_enable(void)
 {
 	__asm__ __volatile__(
 		"wrpr	0, %%pil"
@@ -59,22 +56,17 @@ static inline void raw_local_irq_enable(void)
 	);
 }
 
-static inline int raw_irqs_disabled_flags(unsigned long flags)
+static inline int arch_irqs_disabled_flags(unsigned long flags)
 {
 	return (flags > 0);
 }
 
-static inline int raw_irqs_disabled(void)
+static inline int arch_irqs_disabled(void)
 {
-	unsigned long flags = __raw_local_save_flags();
-
-	return raw_irqs_disabled_flags(flags);
+	return arch_irqs_disabled_flags(arch_local_save_flags());
 }
 
-/*
- * For spinlocks, etc:
- */
-static inline unsigned long __raw_local_irq_save(void)
+static inline unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags, tmp;
 
@@ -100,9 +92,6 @@ static inline unsigned long __raw_local_irq_save(void)
 	return flags;
 }
 
-#define raw_local_irq_save(flags) \
-		do { (flags) = __raw_local_irq_save(); } while (0)
-
 #endif /* (__ASSEMBLY__) */
 
 #endif /* !(_ASM_IRQFLAGS_H) */
diff --git a/arch/sparc/kernel/irq_32.c b/arch/sparc/kernel/irq_32.c
index e1af437..51bea83 100644
--- a/arch/sparc/kernel/irq_32.c
+++ b/arch/sparc/kernel/irq_32.c
@@ -57,7 +57,7 @@
 #define SMP_NOP2
 #define SMP_NOP3
 #endif /* SMP */
-unsigned long __raw_local_irq_save(void)
+unsigned long arch_local_irq_save(void)
 {
 	unsigned long retval;
 	unsigned long tmp;
@@ -75,7 +75,7 @@ unsigned long __raw_local_irq_save(void)
 	return retval;
 }
 
-void raw_local_irq_enable(void)
+void arch_local_irq_enable(void)
 {
 	unsigned long tmp;
 
@@ -90,7 +90,7 @@ void raw_local_irq_enable(void)
 		: "memory");
 }
 
-void raw_local_irq_restore(unsigned long old_psr)
+void arch_local_irq_restore(unsigned long old_psr)
 {
 	unsigned long tmp;
 
@@ -106,9 +106,9 @@ void raw_local_irq_restore(unsigned long old_psr)
 		: "memory");
 }
 
-EXPORT_SYMBOL(__raw_local_irq_save);
-EXPORT_SYMBOL(raw_local_irq_enable);
-EXPORT_SYMBOL(raw_local_irq_restore);
+EXPORT_SYMBOL(arch_local_irq_save);
+EXPORT_SYMBOL(arch_local_irq_enable);
+EXPORT_SYMBOL(arch_local_irq_restore);
 
 /*
  * Dave Redman (djhr@tadpole.co.uk)

