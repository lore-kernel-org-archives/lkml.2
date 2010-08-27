Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab0H0CBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:01:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997Ab0H0CAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:00:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 20/22] Fix powerpc irqflags
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 27 Aug 2010 03:00:48 +0100
Message-ID: <20100827020048.27277.3248.stgit@warthog.procyon.org.uk>
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

 arch/powerpc/include/asm/hw_irq.h    |  115 +++++++++++++++++++---------------
 arch/powerpc/include/asm/irqflags.h  |    2 -
 arch/powerpc/kernel/exceptions-64s.S |    4 +
 arch/powerpc/kernel/irq.c            |    4 +
 4 files changed, 69 insertions(+), 56 deletions(-)

diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index bd100fc..4255de6 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -16,42 +16,57 @@ extern void timer_interrupt(struct pt_regs *);
 #ifdef CONFIG_PPC64
 #include <asm/paca.h>
 
-static inline unsigned long local_get_flags(void)
+static inline unsigned long arch_local_save_flags(void)
 {
 	unsigned long flags;
 
-	__asm__ __volatile__("lbz %0,%1(13)"
-	: "=r" (flags)
-	: "i" (offsetof(struct paca_struct, soft_enabled)));
+	asm volatile(
+		"lbz %0,%1(13)"
+		: "=r" (flags)
+		: "i" (offsetof(struct paca_struct, soft_enabled)));
 
 	return flags;
 }
 
-static inline unsigned long raw_local_irq_disable(void)
+static inline unsigned long arch_local_irq_disable(void)
 {
 	unsigned long flags, zero;
 
-	__asm__ __volatile__("li %1,0; lbz %0,%2(13); stb %1,%2(13)"
-	: "=r" (flags), "=&r" (zero)
-	: "i" (offsetof(struct paca_struct, soft_enabled))
-	: "memory");
+	asm volatile(
+		"li %1,0; lbz %0,%2(13); stb %1,%2(13)"
+		: "=r" (flags), "=&r" (zero)
+		: "i" (offsetof(struct paca_struct, soft_enabled))
+		: "memory");
 
 	return flags;
 }
 
-extern void raw_local_irq_restore(unsigned long);
+extern void arch_local_irq_restore(unsigned long);
 extern void iseries_handle_interrupts(void);
 
-#define raw_local_irq_enable()		raw_local_irq_restore(1)
-#define raw_local_save_flags(flags)	((flags) = local_get_flags())
-#define raw_local_irq_save(flags)	((flags) = raw_local_irq_disable())
+static inline void arch_local_irq_enable(void)
+{
+	arch_local_irq_restore(1);
+}
 
-#define raw_irqs_disabled()		(local_get_flags() == 0)
-#define raw_irqs_disabled_flags(flags)	((flags) == 0)
+static inline unsigned long arch_local_irq_save(void)
+{
+	return arch_local_irq_disable();
+}
+
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
+{
+	return flags == 0;
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
 
 #ifdef CONFIG_PPC_BOOK3E
-#define __hard_irq_enable()	__asm__ __volatile__("wrteei 1": : :"memory");
-#define __hard_irq_disable()	__asm__ __volatile__("wrteei 0": : :"memory");
+#define __hard_irq_enable()	asm volatile("wrteei 1" : : :"memory");
+#define __hard_irq_disable()	asm volatile("wrteei 0" : : :"memory");
 #else
 #define __hard_irq_enable()	__mtmsrd(mfmsr() | MSR_EE, 1)
 #define __hard_irq_disable()	__mtmsrd(mfmsr() & ~MSR_EE, 1)
@@ -64,64 +79,62 @@ extern void iseries_handle_interrupts(void);
 		get_paca()->hard_enabled = 0;	\
 	} while(0)
 
-#else
+#else /* CONFIG_PPC64 */
 
-#if defined(CONFIG_BOOKE)
-#define SET_MSR_EE(x)	mtmsr(x)
-#define raw_local_irq_restore(flags)	__asm__ __volatile__("wrtee %0" : : "r" (flags) : "memory")
-#else
 #define SET_MSR_EE(x)	mtmsr(x)
-#define raw_local_irq_restore(flags)	mtmsr(flags)
-#endif
 
-static inline void raw_local_irq_disable(void)
+static inline unsigned long arch_local_save_flags(void)
 {
-#ifdef CONFIG_BOOKE
-	__asm__ __volatile__("wrteei 0": : :"memory");
-#else
-	unsigned long msr;
+	return mfmsr();
+}
 
-	msr = mfmsr();
-	SET_MSR_EE(msr & ~MSR_EE);
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+#if defined(CONFIG_BOOKE)
+	asm volatile("wrtee %0" : : "r" (flags) : "memory");
+#else
+	mtmsr(flags);
 #endif
 }
 
-static inline void raw_local_irq_enable(void)
+static inline unsigned long arch_local_irq_save(void)
 {
+	unsigned long flags = arch_local_save_flags();
 #ifdef CONFIG_BOOKE
-	__asm__ __volatile__("wrteei 1": : :"memory");
+	asm volatile("wrteei 0": : :"memory");
 #else
-	unsigned long msr;
-
-	msr = mfmsr();
-	SET_MSR_EE(msr | MSR_EE);
+	SET_MSR_EE(flags & ~MSR_EE);
 #endif
+	return flags;
 }
 
-static inline void raw_local_irq_save_ptr(unsigned long *flags)
+static inline void arch_local_irq_disable(void)
+{
+	arch_local_irq_save();
+}
+
+static inline void arch_local_irq_enable(void)
 {
-	unsigned long msr;
-	msr = mfmsr();
-	*flags = msr;
 #ifdef CONFIG_BOOKE
-	__asm__ __volatile__("wrteei 0": : :"memory");
+	asm volatile("wrteei 1" : : :"memory");
 #else
-	SET_MSR_EE(msr & ~MSR_EE);
+	unsigned long msr = mfmsr();
+	SET_MSR_EE(msr | MSR_EE);
 #endif
 }
 
-#define raw_local_save_flags(flags)	((flags) = mfmsr())
-#define raw_local_irq_save(flags)	raw_local_irq_save_ptr(&flags)
-#define raw_irqs_disabled()		((mfmsr() & MSR_EE) == 0)
-#define raw_irqs_disabled_flags(flags)	(((flags) & MSR_EE) == 0)
-
-#define hard_irq_disable()		raw_local_irq_disable()
-
-static inline int irqs_disabled_flags(unsigned long flags)
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
 {
 	return (flags & MSR_EE) == 0;
 }
 
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+#define hard_irq_disable()		arch_local_irq_disable()
+
 #endif /* CONFIG_PPC64 */
 
 /*
diff --git a/arch/powerpc/include/asm/irqflags.h b/arch/powerpc/include/asm/irqflags.h
index 5f68ecf..b85d8dd 100644
--- a/arch/powerpc/include/asm/irqflags.h
+++ b/arch/powerpc/include/asm/irqflags.h
@@ -6,7 +6,7 @@
 
 #ifndef __ASSEMBLY__
 /*
- * Get definitions for raw_local_save_flags(x), etc.
+ * Get definitions for arch_local_save_flags(x), etc.
  */
 #include <asm/hw_irq.h>
 
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index f53029a..39b0c48 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -818,12 +818,12 @@ END_FW_FTR_SECTION_IFCLR(FW_FEATURE_ISERIES)
 
 	/*
 	 * hash_page couldn't handle it, set soft interrupt enable back
-	 * to what it was before the trap.  Note that .raw_local_irq_restore
+	 * to what it was before the trap.  Note that .arch_local_irq_restore
 	 * handles any interrupts pending at this point.
 	 */
 	ld	r3,SOFTE(r1)
 	TRACE_AND_RESTORE_IRQ_PARTIAL(r3, 11f)
-	bl	.raw_local_irq_restore
+	bl	.arch_local_irq_restore
 	b	11f
 
 /* We have a data breakpoint exception - handle it */
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 4a65386..1903290 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -116,7 +116,7 @@ static inline notrace void set_soft_enabled(unsigned long enable)
 	: : "r" (enable), "i" (offsetof(struct paca_struct, soft_enabled)));
 }
 
-notrace void raw_local_irq_restore(unsigned long en)
+notrace void arch_local_irq_restore(unsigned long en)
 {
 	/*
 	 * get_paca()->soft_enabled = en;
@@ -192,7 +192,7 @@ notrace void raw_local_irq_restore(unsigned long en)
 
 	__hard_irq_enable();
 }
-EXPORT_SYMBOL(raw_local_irq_restore);
+EXPORT_SYMBOL(arch_local_irq_restore);
 #endif /* CONFIG_PPC64 */
 
 static int show_other_interrupts(struct seq_file *p, int prec)

