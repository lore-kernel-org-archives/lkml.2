Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0H0CAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:00:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab0H0CAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:00:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 12/22] Fix IRQ flag handling naming
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 27 Aug 2010 03:00:07 +0100
Message-ID: <20100827020007.27277.49064.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100827015905.27277.39167.stgit@warthog.procyon.org.uk>
References: <20100827015905.27277.39167.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the IRQ flag handling naming.  In linux/irqflags.h under one configuration,
it maps:

	local_irq_enable() -> raw_local_irq_enable()
	local_irq_disable() -> raw_local_irq_disable()
	local_irq_save() -> raw_local_irq_save()
	...

and under the other configuration, it maps:

	raw_local_irq_enable() -> local_irq_enable()
	raw_local_irq_disable() -> local_irq_disable()
	raw_local_irq_save() -> local_irq_save()
	...

This is quite confusing.  There should be one set of names expected of the
arch, and this should be wrapped to give another set of names that are expected
by users of this facility.

Change this to have the arch provide:

	flags = arch_local_save_flags()
	flags = arch_local_irq_save()
	arch_local_irq_restore(flags)
	arch_local_irq_disable()
	arch_local_irq_enable()
	arch_irqs_disabled_flags(flags)
	arch_irqs_disabled()
	arch_safe_halt()

Then linux/irqflags.h wraps these to provide:

	raw_local_save_flags(flags)
	raw_local_irq_save(flags)
	raw_local_irq_restore(flags)
	raw_local_irq_disable()
	raw_local_irq_enable()
	raw_irqs_disabled_flags(flags)
	raw_irqs_disabled()
	raw_safe_halt()

with type checking on the flags 'arguments', and then wraps those to provide:

	local_save_flags(flags)
	local_irq_save(flags)
	local_irq_restore(flags)
	local_irq_disable()
	local_irq_enable()
	irqs_disabled_flags(flags)
	irqs_disabled()
	safe_halt()

with tracing included if enabled.

The arch functions can now all be inline functions rather than some of them
having to be macros.

[Note that this patch only alters X86, FRV, MN10300, ARM and Blackfin at the
 moment.  The other arches will need altering too as part of this patch].

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
---

 arch/arm/include/asm/irqflags.h      |  143 ++++++++++++++++++-------------
 arch/blackfin/include/asm/irqflags.h |   12 ---
 arch/frv/include/asm/irqflags.h      |  158 ++++++++++++++++++++++++++++++++++
 arch/frv/include/asm/system.h        |  136 -----------------------------
 arch/mn10300/include/asm/irqflags.h  |  119 ++++++++++++++++++++++++++
 arch/mn10300/include/asm/system.h    |  109 -----------------------
 arch/mn10300/kernel/entry.S          |    1 
 arch/x86/include/asm/irqflags.h      |   32 +++----
 arch/x86/include/asm/paravirt.h      |   16 ++-
 include/asm-generic/atomic.h         |    3 -
 include/asm-generic/irqflags.h       |   52 +++++------
 include/linux/irqflags.h             |  107 ++++++++++++++---------
 include/linux/spinlock.h             |    1 
 13 files changed, 472 insertions(+), 417 deletions(-)
 create mode 100644 arch/frv/include/asm/irqflags.h
 create mode 100644 arch/mn10300/include/asm/irqflags.h

diff --git a/arch/arm/include/asm/irqflags.h b/arch/arm/include/asm/irqflags.h
index 6d09974..ec52949 100644
--- a/arch/arm/include/asm/irqflags.h
+++ b/arch/arm/include/asm/irqflags.h
@@ -10,66 +10,85 @@
  */
 #if __LINUX_ARM_ARCH__ >= 6
 
-#define raw_local_irq_save(x)					\
-	({							\
-	__asm__ __volatile__(					\
-	"mrs	%0, cpsr		@ local_irq_save\n"	\
-	"cpsid	i"						\
-	: "=r" (x) : : "memory", "cc");				\
-	})
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags;
+
+	asm volatile(
+		"	mrs	%0, cpsr	@ arch_local_irq_save\n"
+		"	cpsid	i"
+		: "=r" (flags) : : "memory", "cc");
+	return flags;
+}
+	
+static inline void arch_local_irq_enable(void)
+{
+	asm volatile(
+		"	cpsie i			@ arch_local_irq_enable"
+		:
+		:
+		: "memory", "cc");
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	asm volatile(
+		"	cpsid i			@ arch_local_irq_disable"
+		:
+		:
+		: "memory", "cc");
+}
 
-#define raw_local_irq_enable()  __asm__("cpsie i	@ __sti" : : : "memory", "cc")
-#define raw_local_irq_disable() __asm__("cpsid i	@ __cli" : : : "memory", "cc")
 #define local_fiq_enable()  __asm__("cpsie f	@ __stf" : : : "memory", "cc")
 #define local_fiq_disable() __asm__("cpsid f	@ __clf" : : : "memory", "cc")
-
 #else
 
 /*
  * Save the current interrupt enable state & disable IRQs
  */
-#define raw_local_irq_save(x)					\
-	({							\
-		unsigned long temp;				\
-		(void) (&temp == &x);				\
-	__asm__ __volatile__(					\
-	"mrs	%0, cpsr		@ local_irq_save\n"	\
-"	orr	%1, %0, #128\n"					\
-"	msr	cpsr_c, %1"					\
-	: "=r" (x), "=r" (temp)					\
-	:							\
-	: "memory", "cc");					\
-	})
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags, temp;
+
+	asm volatile(
+		"	mrs	%0, cpsr	@ arch_local_irq_save\n"
+		"	orr	%1, %0, #128\n"
+		"	msr	cpsr_c, %1"
+		: "=r" (flags), "=r" (temp)
+		:
+		: "memory", "cc");
+	return flags;
+}
 	
 /*
  * Enable IRQs
  */
-#define raw_local_irq_enable()					\
-	({							\
-		unsigned long temp;				\
-	__asm__ __volatile__(					\
-	"mrs	%0, cpsr		@ local_irq_enable\n"	\
-"	bic	%0, %0, #128\n"					\
-"	msr	cpsr_c, %0"					\
-	: "=r" (temp)						\
-	:							\
-	: "memory", "cc");					\
-	})
+static inline void arch_local_irq_enable(void)
+{
+	unsigned long temp;
+	asm volatile(
+		"	mrs	%0, cpsr	@ arch_local_irq_enable\n"
+		"	bic	%0, %0, #128\n"
+		"	msr	cpsr_c, %0"
+		: "=r" (temp)
+		:
+		: "memory", "cc");
+}
 
 /*
  * Disable IRQs
  */
-#define raw_local_irq_disable()					\
-	({							\
-		unsigned long temp;				\
-	__asm__ __volatile__(					\
-	"mrs	%0, cpsr		@ local_irq_disable\n"	\
-"	orr	%0, %0, #128\n"					\
-"	msr	cpsr_c, %0"					\
-	: "=r" (temp)						\
-	:							\
-	: "memory", "cc");					\
-	})
+static inline void arch_local_irq_disable(void)
+{
+	unsigned long temp;
+	asm volatile(
+		"	mrs	%0, cpsr	@ arch_local_irq_disable\n"
+		"	orr	%0, %0, #128\n"
+		"	msr	cpsr_c, %0"
+		: "=r" (temp)
+		:
+		: "memory", "cc");
+}
 
 /*
  * Enable FIQs
@@ -106,27 +125,31 @@
 /*
  * Save the current interrupt enable state.
  */
-#define raw_local_save_flags(x)					\
-	({							\
-	__asm__ __volatile__(					\
-	"mrs	%0, cpsr		@ local_save_flags"	\
-	: "=r" (x) : : "memory", "cc");				\
-	})
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+	asm volatile(
+		"	mrs	%0, cpsr	@ local_save_flags"
+		: "=r" (flags) : : "memory", "cc");
+	return flags;
+}
 
 /*
  * restore saved IRQ & FIQ state
  */
-#define raw_local_irq_restore(x)				\
-	__asm__ __volatile__(					\
-	"msr	cpsr_c, %0		@ local_irq_restore\n"	\
-	:							\
-	: "r" (x)						\
-	: "memory", "cc")
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	asm volatile(
+		"	msr	cpsr_c, %0	@ local_irq_restore"
+		:
+		: "r" (flags)
+		: "memory", "cc");
+}
 
-#define raw_irqs_disabled_flags(flags)	\
-({					\
-	(int)((flags) & PSR_I_BIT);	\
-})
+static inline int arch_irqs_disabled_flags(unsigned long flags)
+{
+	return flags & PSR_I_BIT;
+}
 
 #endif
 #endif
diff --git a/arch/blackfin/include/asm/irqflags.h b/arch/blackfin/include/asm/irqflags.h
index 88f1ee1..d00fe15 100644
--- a/arch/blackfin/include/asm/irqflags.h
+++ b/arch/blackfin/include/asm/irqflags.h
@@ -218,16 +218,4 @@ static inline void hard_local_irq_restore(unsigned long flags)
 
 
 #endif /* !CONFIG_IPIPE */
-
-/*
- * Raw interface to linux/irqflags.h.
- */
-#define raw_local_save_flags(flags)	do { (flags) = arch_local_save_flags(); } while (0)
-#define raw_local_irq_save(flags)	do { (flags) = arch_local_irq_save(); } while (0)
-#define raw_local_irq_restore(flags)	arch_local_irq_restore(flags)
-#define raw_local_irq_enable()		arch_local_irq_enable()
-#define raw_local_irq_disable()		arch_local_irq_disable()
-#define raw_irqs_disabled_flags(flags)	arch_irqs_disabled_flags(flags)
-#define raw_irqs_disabled()		arch_irqs_disabled()
-
 #endif
diff --git a/arch/frv/include/asm/irqflags.h b/arch/frv/include/asm/irqflags.h
new file mode 100644
index 0000000..a4dc4a8
--- /dev/null
+++ b/arch/frv/include/asm/irqflags.h
@@ -0,0 +1,158 @@
+/* FR-V interrupt handling
+ *
+ * Copyright (C) 2010 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_IRQFLAGS_H
+#define _ASM_IRQFLAGS_H
+
+/*
+ * interrupt flag manipulation
+ * - use virtual interrupt management since touching the PSR is slow
+ *   - ICC2.Z: T if interrupts virtually disabled
+ *   - ICC2.C: F if interrupts really disabled
+ * - if Z==1 upon interrupt:
+ *   - C is set to 0
+ *   - interrupts are really disabled
+ *   - entry.S returns immediately
+ * - uses TIHI (TRAP if Z==0 && C==0) #2 to really reenable interrupts
+ *   - if taken, the trap:
+ *     - sets ICC2.C
+ *     - enables interrupts
+ */
+static inline void arch_local_irq_disable(void)
+{
+	/* set Z flag, but don't change the C flag */
+	asm volatile("	andcc	gr0,gr0,gr0,icc2	\n"
+		     :
+		     :
+		     : "memory", "icc2"
+		     );
+}
+
+static inline void arch_local_irq_enable(void)
+{
+	/* clear Z flag and then test the C flag */
+	asm volatile("  oricc	gr0,#1,gr0,icc2		\n"
+		     "	tihi	icc2,gr0,#2		\n"
+		     :
+		     :
+		     : "memory", "icc2"
+		     );
+}
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+
+	asm volatile("movsg ccr,%0"
+		     : "=r"(flags)
+		     :
+		     : "memory");
+
+	/* shift ICC2.Z to bit 0 */
+	flags >>= 26;
+
+	/* make flags 1 if interrupts disabled, 0 otherwise */
+	return flags & 1UL;
+
+}
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
+	/* load the Z flag by turning 1 if disabled into 0 if disabled
+	 * and thus setting the Z flag but not the C flag */
+	asm volatile("  xoricc	%0,#1,gr0,icc2		\n"
+		     /* then trap if Z=0 and C=0 */
+		     "	tihi	icc2,gr0,#2		\n"
+		     :
+		     : "r"(flags)
+		     : "memory", "icc2"
+		     );
+
+}
+
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
+{
+	return flags;
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+/*
+ * real interrupt flag manipulation
+ */
+#define __arch_local_irq_disable()			\
+do {							\
+	unsigned long psr;				\
+	asm volatile("	movsg	psr,%0		\n"	\
+		     "	andi	%0,%2,%0	\n"	\
+		     "	ori	%0,%1,%0	\n"	\
+		     "	movgs	%0,psr		\n"	\
+		     : "=r"(psr)			\
+		     : "i" (PSR_PIL_14), "i" (~PSR_PIL)	\
+		     : "memory");			\
+} while(0)
+
+#define __arch_local_irq_enable()			\
+do {							\
+	unsigned long psr;				\
+	asm volatile("	movsg	psr,%0		\n"	\
+		     "	andi	%0,%1,%0	\n"	\
+		     "	movgs	%0,psr		\n"	\
+		     : "=r"(psr)			\
+		     : "i" (~PSR_PIL)			\
+		     : "memory");			\
+} while(0)
+
+#define __arch_local_save_flags(flags)		\
+do {						\
+	typecheck(unsigned long, flags);	\
+	asm("movsg psr,%0"			\
+	    : "=r"(flags)			\
+	    :					\
+	    : "memory");			\
+} while(0)
+
+#define	__arch_local_irq_save(flags)			\
+do {							\
+	unsigned long npsr;				\
+	typecheck(unsigned long, flags);		\
+	asm volatile("	movsg	psr,%0		\n"	\
+		     "	andi	%0,%3,%1	\n"	\
+		     "	ori	%1,%2,%1	\n"	\
+		     "	movgs	%1,psr		\n"	\
+		     : "=r"(flags), "=r"(npsr)		\
+		     : "i" (PSR_PIL_14), "i" (~PSR_PIL)	\
+		     : "memory");			\
+} while(0)
+
+#define	__arch_local_irq_restore(flags)			\
+do {							\
+	typecheck(unsigned long, flags);		\
+	asm volatile("	movgs	%0,psr		\n"	\
+		     :					\
+		     : "r" (flags)			\
+		     : "memory");			\
+} while(0)
+
+#define __arch_irqs_disabled()			\
+	((__get_PSR() & PSR_PIL) >= PSR_PIL_14)
+
+#endif /* _ASM_IRQFLAGS_H */
diff --git a/arch/frv/include/asm/system.h b/arch/frv/include/asm/system.h
index efd22d9..0a6d8d9 100644
--- a/arch/frv/include/asm/system.h
+++ b/arch/frv/include/asm/system.h
@@ -37,142 +37,6 @@ do {									\
 } while(0)
 
 /*
- * interrupt flag manipulation
- * - use virtual interrupt management since touching the PSR is slow
- *   - ICC2.Z: T if interrupts virtually disabled
- *   - ICC2.C: F if interrupts really disabled
- * - if Z==1 upon interrupt:
- *   - C is set to 0
- *   - interrupts are really disabled
- *   - entry.S returns immediately
- * - uses TIHI (TRAP if Z==0 && C==0) #2 to really reenable interrupts
- *   - if taken, the trap:
- *     - sets ICC2.C
- *     - enables interrupts
- */
-#define local_irq_disable()					\
-do {								\
-	/* set Z flag, but don't change the C flag */		\
-	asm volatile("	andcc	gr0,gr0,gr0,icc2	\n"	\
-		     :						\
-		     :						\
-		     : "memory", "icc2"				\
-		     );						\
-} while(0)
-
-#define local_irq_enable()					\
-do {								\
-	/* clear Z flag and then test the C flag */		\
-	asm volatile("  oricc	gr0,#1,gr0,icc2		\n"	\
-		     "	tihi	icc2,gr0,#2		\n"	\
-		     :						\
-		     :						\
-		     : "memory", "icc2"				\
-		     );						\
-} while(0)
-
-#define local_save_flags(flags)					\
-do {								\
-	typecheck(unsigned long, flags);			\
-	asm volatile("movsg ccr,%0"				\
-		     : "=r"(flags)				\
-		     :						\
-		     : "memory");				\
-								\
-	/* shift ICC2.Z to bit 0 */				\
-	flags >>= 26;						\
-								\
-	/* make flags 1 if interrupts disabled, 0 otherwise */	\
-	flags &= 1UL;						\
-} while(0)
-
-#define irqs_disabled() \
-	({unsigned long flags; local_save_flags(flags); !!flags; })
-
-#define	local_irq_save(flags)			\
-do {						\
-	typecheck(unsigned long, flags);	\
-	local_save_flags(flags);		\
-	local_irq_disable();			\
-} while(0)
-
-#define	local_irq_restore(flags)					\
-do {									\
-	typecheck(unsigned long, flags);				\
-									\
-	/* load the Z flag by turning 1 if disabled into 0 if disabled	\
-	 * and thus setting the Z flag but not the C flag */		\
-	asm volatile("  xoricc	%0,#1,gr0,icc2		\n"		\
-		     /* then test Z=0 and C=0 */			\
-		     "	tihi	icc2,gr0,#2		\n"		\
-		     :							\
-		     : "r"(flags)					\
-		     : "memory", "icc2"					\
-		     );							\
-									\
-} while(0)
-
-/*
- * real interrupt flag manipulation
- */
-#define __local_irq_disable()				\
-do {							\
-	unsigned long psr;				\
-	asm volatile("	movsg	psr,%0		\n"	\
-		     "	andi	%0,%2,%0	\n"	\
-		     "	ori	%0,%1,%0	\n"	\
-		     "	movgs	%0,psr		\n"	\
-		     : "=r"(psr)			\
-		     : "i" (PSR_PIL_14), "i" (~PSR_PIL)	\
-		     : "memory");			\
-} while(0)
-
-#define __local_irq_enable()				\
-do {							\
-	unsigned long psr;				\
-	asm volatile("	movsg	psr,%0		\n"	\
-		     "	andi	%0,%1,%0	\n"	\
-		     "	movgs	%0,psr		\n"	\
-		     : "=r"(psr)			\
-		     : "i" (~PSR_PIL)			\
-		     : "memory");			\
-} while(0)
-
-#define __local_save_flags(flags)		\
-do {						\
-	typecheck(unsigned long, flags);	\
-	asm("movsg psr,%0"			\
-	    : "=r"(flags)			\
-	    :					\
-	    : "memory");			\
-} while(0)
-
-#define	__local_irq_save(flags)				\
-do {							\
-	unsigned long npsr;				\
-	typecheck(unsigned long, flags);		\
-	asm volatile("	movsg	psr,%0		\n"	\
-		     "	andi	%0,%3,%1	\n"	\
-		     "	ori	%1,%2,%1	\n"	\
-		     "	movgs	%1,psr		\n"	\
-		     : "=r"(flags), "=r"(npsr)		\
-		     : "i" (PSR_PIL_14), "i" (~PSR_PIL)	\
-		     : "memory");			\
-} while(0)
-
-#define	__local_irq_restore(flags)			\
-do {							\
-	typecheck(unsigned long, flags);		\
-	asm volatile("	movgs	%0,psr		\n"	\
-		     :					\
-		     : "r" (flags)			\
-		     : "memory");			\
-} while(0)
-
-#define __irqs_disabled() \
-	((__get_PSR() & PSR_PIL) >= PSR_PIL_14)
-
-/*
  * Force strict CPU ordering.
  */
 #define nop()			asm volatile ("nop"::)
diff --git a/arch/mn10300/include/asm/irqflags.h b/arch/mn10300/include/asm/irqflags.h
new file mode 100644
index 0000000..6a25d05
--- /dev/null
+++ b/arch/mn10300/include/asm/irqflags.h
@@ -0,0 +1,119 @@
+/* MN10300 IRQ flag handling
+ *
+ * Copyright (C) 2010 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#ifndef _ASM_IRQFLAGS_H
+#define _ASM_IRQFLAGS_H
+
+#include <asm/cpu-regs.h>
+
+/*
+ * interrupt control
+ * - "disabled": run in IM1/2
+ *   - level 0 - GDB stub
+ *   - level 1 - virtual serial DMA (if present)
+ *   - level 5 - normal interrupt priority
+ *   - level 6 - timer interrupt
+ * - "enabled":  run in IM7
+ */
+#ifdef CONFIG_MN10300_TTYSM
+#define MN10300_CLI_LEVEL	EPSW_IM_2
+#else
+#define MN10300_CLI_LEVEL	EPSW_IM_1
+#endif
+
+#ifndef __ASSEMBLY__
+
+static inline unsigned long arch_local_save_flags(void)
+{
+	unsigned long flags;
+
+	asm volatile("mov epsw,%0" : "=d"(flags));
+	return flags;
+}
+
+static inline void arch_local_irq_disable(void)
+{
+	asm volatile("	and %0,epsw	\n"
+		     "	or %1,epsw	\n"
+		     "	nop		\n"
+		     "	nop		\n"
+		     "	nop		\n"
+		     :
+		     : "i"(~EPSW_IM), "i"(EPSW_IE | MN10300_CLI_LEVEL));
+}
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	unsigned long flags;
+
+	flags = arch_local_save_flags();
+	arch_local_irq_disable();
+	return flags;
+}
+
+/*
+ * we make sure arch_irq_enable() doesn't cause priority inversion
+ */
+extern unsigned long __mn10300_irq_enabled_epsw;
+
+static inline void arch_local_irq_enable(void)
+{
+	unsigned long tmp;
+
+	asm volatile("	mov	epsw,%0		\n"
+		     "	and	%1,%0		\n"
+		     "	or	%2,%0		\n"
+		     "	mov	%0,epsw		\n"
+		     : "=&d"(tmp)
+		     : "i"(~EPSW_IM), "r"(__mn10300_irq_enabled_epsw)
+		     : "cc");
+}
+
+static inline void arch_local_irq_restore(unsigned long flags)
+{
+	asm volatile("	mov %0,epsw	\n"
+		"	nop		\n"
+		"	nop		\n"
+		"	nop		\n"
+		:
+		: "d"(flags)
+		: "memory", "cc"
+		);
+}
+
+static inline bool arch_irqs_disabled_flags(unsigned long flags)
+{
+	return (flags & EPSW_IM) <= MN10300_CLI_LEVEL;
+}
+
+static inline bool arch_irqs_disabled(void)
+{
+	return arch_irqs_disabled_flags(arch_local_save_flags());
+}
+
+/* hook to save power by halting the CPU
+ * - called from the idle loop
+ * - must reenable interrupts (which takes three instruction cycles to complete)
+ */
+static inline void arch_safe_halt(void)
+{
+	asm volatile("	or	%0,epsw	\n"
+		     "	nop		\n"
+		     "	nop		\n"
+		     "	bset	%2,(%1)	\n"
+		     :
+		     : "i"(EPSW_IE|EPSW_IM), "n"(&CPUM), "i"(CPUM_SLEEP)
+		     : "cc"
+		     );
+}
+
+#endif /* __ASSEMBLY__ */
+#endif /* _ASM_IRQFLAGS_H */
diff --git a/arch/mn10300/include/asm/system.h b/arch/mn10300/include/asm/system.h
index 3636c05..9f7c7e1 100644
--- a/arch/mn10300/include/asm/system.h
+++ b/arch/mn10300/include/asm/system.h
@@ -17,6 +17,7 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/kernel.h>
+#include <linux/irqflags.h>
 
 struct task_struct;
 struct thread_struct;
@@ -81,114 +82,6 @@ do {									\
 
 /*****************************************************************************/
 /*
- * interrupt control
- * - "disabled": run in IM1/2
- *   - level 0 - GDB stub
- *   - level 1 - virtual serial DMA (if present)
- *   - level 5 - normal interrupt priority
- *   - level 6 - timer interrupt
- * - "enabled":  run in IM7
- */
-#ifdef CONFIG_MN10300_TTYSM
-#define MN10300_CLI_LEVEL	EPSW_IM_2
-#else
-#define MN10300_CLI_LEVEL	EPSW_IM_1
-#endif
-
-#define local_save_flags(x)			\
-do {						\
-	typecheck(unsigned long, x);		\
-	asm volatile(				\
-		"	mov epsw,%0	\n"	\
-		: "=d"(x)			\
-		);				\
-} while (0)
-
-#define local_irq_disable()						\
-do {									\
-	asm volatile(							\
-		"	and %0,epsw	\n"				\
-		"	or %1,epsw	\n"				\
-		"	nop		\n"				\
-		"	nop		\n"				\
-		"	nop		\n"				\
-		:							\
-		: "i"(~EPSW_IM), "i"(EPSW_IE | MN10300_CLI_LEVEL)	\
-		);							\
-} while (0)
-
-#define local_irq_save(x)			\
-do {						\
-	local_save_flags(x);			\
-	local_irq_disable();			\
-} while (0)
-
-/*
- * we make sure local_irq_enable() doesn't cause priority inversion
- */
-#ifndef __ASSEMBLY__
-
-extern unsigned long __mn10300_irq_enabled_epsw;
-
-#endif
-
-#define local_irq_enable()						\
-do {									\
-	unsigned long tmp;						\
-									\
-	asm volatile(							\
-		"	mov	epsw,%0		\n"			\
-		"	and	%1,%0		\n"			\
-		"	or	%2,%0		\n"			\
-		"	mov	%0,epsw		\n"			\
-		: "=&d"(tmp)						\
-		: "i"(~EPSW_IM), "r"(__mn10300_irq_enabled_epsw)	\
-		: "cc"							\
-		);							\
-} while (0)
-
-#define local_irq_restore(x)			\
-do {						\
-	typecheck(unsigned long, x);		\
-	asm volatile(				\
-		"	mov %0,epsw	\n"	\
-		"	nop		\n"	\
-		"	nop		\n"	\
-		"	nop		\n"	\
-		:				\
-		: "d"(x)			\
-		: "memory", "cc"		\
-		);				\
-} while (0)
-
-#define irqs_disabled()				\
-({						\
-	unsigned long flags;			\
-	local_save_flags(flags);		\
-	(flags & EPSW_IM) <= MN10300_CLI_LEVEL;	\
-})
-
-/* hook to save power by halting the CPU
- * - called from the idle loop
- * - must reenable interrupts (which takes three instruction cycles to complete)
- */
-#define safe_halt()							\
-do {									\
-	asm volatile("	or	%0,epsw	\n"				\
-		     "	nop		\n"				\
-		     "	nop		\n"				\
-		     "	bset	%2,(%1)	\n"				\
-		     :							\
-		     : "i"(EPSW_IE|EPSW_IM), "n"(&CPUM), "i"(CPUM_SLEEP)\
-		     : "cc"						\
-		     );							\
-} while (0)
-
-#define STI	or EPSW_IE|EPSW_IM,epsw
-#define CLI	and ~EPSW_IM,epsw; or EPSW_IE|MN10300_CLI_LEVEL,epsw; nop; nop; nop
-
-/*****************************************************************************/
-/*
  * MN10300 doesn't actually have an exchange instruction
  */
 #ifndef __ASSEMBLY__
diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index d9ed5a1..3d394b4 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -16,6 +16,7 @@
 #include <linux/linkage.h>
 #include <asm/smp.h>
 #include <asm/system.h>
+#include <asm/irqflags.h>
 #include <asm/thread_info.h>
 #include <asm/intctl-regs.h>
 #include <asm/busctl-regs.h>
diff --git a/arch/x86/include/asm/irqflags.h b/arch/x86/include/asm/irqflags.h
index 9e2b952..5745ce8 100644
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -61,22 +61,22 @@ static inline void native_halt(void)
 #else
 #ifndef __ASSEMBLY__
 
-static inline unsigned long __raw_local_save_flags(void)
+static inline unsigned long arch_local_save_flags(void)
 {
 	return native_save_fl();
 }
 
-static inline void raw_local_irq_restore(unsigned long flags)
+static inline void arch_local_irq_restore(unsigned long flags)
 {
 	native_restore_fl(flags);
 }
 
-static inline void raw_local_irq_disable(void)
+static inline void arch_local_irq_disable(void)
 {
 	native_irq_disable();
 }
 
-static inline void raw_local_irq_enable(void)
+static inline void arch_local_irq_enable(void)
 {
 	native_irq_enable();
 }
@@ -85,7 +85,7 @@ static inline void raw_local_irq_enable(void)
  * Used in the idle loop; sti takes one instruction cycle
  * to complete:
  */
-static inline void raw_safe_halt(void)
+static inline void arch_safe_halt(void)
 {
 	native_safe_halt();
 }
@@ -102,12 +102,10 @@ static inline void halt(void)
 /*
  * For spinlocks, etc:
  */
-static inline unsigned long __raw_local_irq_save(void)
+static inline unsigned long arch_local_irq_save(void)
 {
-	unsigned long flags = __raw_local_save_flags();
-
-	raw_local_irq_disable();
-
+	unsigned long flags = arch_local_save_flags();
+	arch_local_irq_disable();
 	return flags;
 }
 #else
@@ -153,22 +151,16 @@ static inline unsigned long __raw_local_irq_save(void)
 #endif /* CONFIG_PARAVIRT */
 
 #ifndef __ASSEMBLY__
-#define raw_local_save_flags(flags)				\
-	do { (flags) = __raw_local_save_flags(); } while (0)
-
-#define raw_local_irq_save(flags)				\
-	do { (flags) = __raw_local_irq_save(); } while (0)
-
-static inline int raw_irqs_disabled_flags(unsigned long flags)
+static inline int arch_irqs_disabled_flags(unsigned long flags)
 {
 	return !(flags & X86_EFLAGS_IF);
 }
 
-static inline int raw_irqs_disabled(void)
+static inline int arch_irqs_disabled(void)
 {
-	unsigned long flags = __raw_local_save_flags();
+	unsigned long flags = arch_local_save_flags();
 
-	return raw_irqs_disabled_flags(flags);
+	return arch_irqs_disabled_flags(flags);
 }
 
 #else
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 5653f43..499954c 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -105,7 +105,7 @@ static inline void write_cr8(unsigned long x)
 }
 #endif
 
-static inline void raw_safe_halt(void)
+static inline void arch_safe_halt(void)
 {
 	PVOP_VCALL0(pv_irq_ops.safe_halt);
 }
@@ -829,32 +829,32 @@ static __always_inline void arch_spin_unlock(struct arch_spinlock *lock)
 #define __PV_IS_CALLEE_SAVE(func)			\
 	((struct paravirt_callee_save) { func })
 
-static inline unsigned long __raw_local_save_flags(void)
+static inline unsigned long arch_local_save_flags(void)
 {
 	return PVOP_CALLEE0(unsigned long, pv_irq_ops.save_fl);
 }
 
-static inline void raw_local_irq_restore(unsigned long f)
+static inline void arch_local_irq_restore(unsigned long f)
 {
 	PVOP_VCALLEE1(pv_irq_ops.restore_fl, f);
 }
 
-static inline void raw_local_irq_disable(void)
+static inline void arch_local_irq_disable(void)
 {
 	PVOP_VCALLEE0(pv_irq_ops.irq_disable);
 }
 
-static inline void raw_local_irq_enable(void)
+static inline void arch_local_irq_enable(void)
 {
 	PVOP_VCALLEE0(pv_irq_ops.irq_enable);
 }
 
-static inline unsigned long __raw_local_irq_save(void)
+static inline unsigned long arch_local_irq_save(void)
 {
 	unsigned long f;
 
-	f = __raw_local_save_flags();
-	raw_local_irq_disable();
+	f = arch_local_save_flags();
+	arch_local_irq_disable();
 	return f;
 }
 
diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index e53347f..56f1484 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -43,6 +43,7 @@
  */
 #define atomic_set(v, i) (((v)->counter) = (i))
 
+#include <asm/irqflags.h>
 #include <asm/system.h>
 
 /**
@@ -57,7 +58,7 @@ static inline int atomic_add_return(int i, atomic_t *v)
 	unsigned long flags;
 	int temp;
 
-	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
+	raw_local_irq_save(flags); /* Don't trace it in an irqsoff handler */
 	temp = v->counter;
 	temp += i;
 	v->counter = temp;
diff --git a/include/asm-generic/irqflags.h b/include/asm-generic/irqflags.h
index 9aebf61..1f40d002 100644
--- a/include/asm-generic/irqflags.h
+++ b/include/asm-generic/irqflags.h
@@ -5,68 +5,62 @@
  * All architectures should implement at least the first two functions,
  * usually inline assembly will be the best way.
  */
-#ifndef RAW_IRQ_DISABLED
-#define RAW_IRQ_DISABLED 0
-#define RAW_IRQ_ENABLED 1
+#ifndef ARCH_IRQ_DISABLED
+#define ARCH_IRQ_DISABLED 0
+#define ARCH_IRQ_ENABLED 1
 #endif
 
 /* read interrupt enabled status */
-#ifndef __raw_local_save_flags
-unsigned long __raw_local_save_flags(void);
+#ifndef arch_local_save_flags
+unsigned long arch_local_save_flags(void);
 #endif
 
 /* set interrupt enabled status */
-#ifndef raw_local_irq_restore
-void raw_local_irq_restore(unsigned long flags);
+#ifndef arch_local_irq_restore
+void arch_local_irq_restore(unsigned long flags);
 #endif
 
 /* get status and disable interrupts */
-#ifndef __raw_local_irq_save
-static inline unsigned long __raw_local_irq_save(void)
+#ifndef arch_local_irq_save
+static inline unsigned long arch_local_irq_save(void)
 {
 	unsigned long flags;
-	flags = __raw_local_save_flags();
-	raw_local_irq_restore(RAW_IRQ_DISABLED);
+	flags = arch_local_save_flags();
+	arch_local_irq_restore(ARCH_IRQ_DISABLED);
 	return flags;
 }
 #endif
 
 /* test flags */
-#ifndef raw_irqs_disabled_flags
-static inline int raw_irqs_disabled_flags(unsigned long flags)
+#ifndef arch_irqs_disabled_flags
+static inline int arch_irqs_disabled_flags(unsigned long flags)
 {
-	return flags == RAW_IRQ_DISABLED;
+	return flags == ARCH_IRQ_DISABLED;
 }
 #endif
 
 /* unconditionally enable interrupts */
-#ifndef raw_local_irq_enable
-static inline void raw_local_irq_enable(void)
+#ifndef arch_local_irq_enable
+static inline void arch_local_irq_enable(void)
 {
-	raw_local_irq_restore(RAW_IRQ_ENABLED);
+	arch_local_irq_restore(ARCH_IRQ_ENABLED);
 }
 #endif
 
 /* unconditionally disable interrupts */
-#ifndef raw_local_irq_disable
-static inline void raw_local_irq_disable(void)
+#ifndef arch_local_irq_disable
+static inline void arch_local_irq_disable(void)
 {
-	raw_local_irq_restore(RAW_IRQ_DISABLED);
+	arch_local_irq_restore(ARCH_IRQ_DISABLED);
 }
 #endif
 
 /* test hardware interrupt enable bit */
-#ifndef raw_irqs_disabled
-static inline int raw_irqs_disabled(void)
+#ifndef arch_irqs_disabled
+static inline int arch_irqs_disabled(void)
 {
-	return raw_irqs_disabled_flags(__raw_local_save_flags());
+	return arch_irqs_disabled_flags(arch_local_save_flags());
 }
 #endif
 
-#define raw_local_save_flags(flags) \
-	do { (flags) = __raw_local_save_flags(); } while (0)
-
-#define raw_local_irq_save(flags) \
-	do { (flags) = __raw_local_irq_save(); } while (0)
-
 #endif /* __ASM_GENERIC_IRQFLAGS_H */
diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index 006bf45..d176d65 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -12,6 +12,7 @@
 #define _LINUX_TRACE_IRQFLAGS_H
 
 #include <linux/typecheck.h>
+#include <asm/irqflags.h>
 
 #ifdef CONFIG_TRACE_IRQFLAGS
   extern void trace_softirqs_on(unsigned long ip);
@@ -52,17 +53,45 @@
 # define start_critical_timings() do { } while (0)
 #endif
 
-#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
-
-#include <asm/irqflags.h>
+/*
+ * Wrap the arch provided IRQ routines to provide appropriate checks.
+ */
+#define raw_local_irq_disable()		arch_local_irq_disable()
+#define raw_local_irq_enable()		arch_local_irq_enable()
+#define raw_local_irq_save(flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		flags = arch_local_irq_save();		\
+	} while (0)
+#define raw_local_irq_restore(flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		arch_local_irq_restore(flags);		\
+	} while (0)
+#define raw_local_save_flags(flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		flags = arch_local_save_flags();	\
+	} while (0)
+#define raw_irqs_disabled_flags(flags)			\
+	({						\
+		typecheck(unsigned long, flags);	\
+		arch_irqs_disabled_flags(flags);	\
+	})
+#define raw_irqs_disabled()		(arch_irqs_disabled())
+#define raw_safe_halt()			arch_safe_halt()
 
+/*
+ * The local_irq_*() APIs are equal to the raw_local_irq*()
+ * if !TRACE_IRQFLAGS.
+ */
+#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
 #define local_irq_enable() \
 	do { trace_hardirqs_on(); raw_local_irq_enable(); } while (0)
 #define local_irq_disable() \
 	do { raw_local_irq_disable(); trace_hardirqs_off(); } while (0)
 #define local_irq_save(flags)				\
 	do {						\
-		typecheck(unsigned long, flags);	\
 		raw_local_irq_save(flags);		\
 		trace_hardirqs_off();			\
 	} while (0)
@@ -70,7 +99,6 @@
 
 #define local_irq_restore(flags)			\
 	do {						\
-		typecheck(unsigned long, flags);	\
 		if (raw_irqs_disabled_flags(flags)) {	\
 			raw_local_irq_restore(flags);	\
 			trace_hardirqs_off();		\
@@ -79,51 +107,44 @@
 			raw_local_irq_restore(flags);	\
 		}					\
 	} while (0)
-#else /* !CONFIG_TRACE_IRQFLAGS_SUPPORT */
-/*
- * The local_irq_*() APIs are equal to the raw_local_irq*()
- * if !TRACE_IRQFLAGS.
- */
-# define raw_local_irq_disable()	local_irq_disable()
-# define raw_local_irq_enable()		local_irq_enable()
-# define raw_local_irq_save(flags)			\
-	do {						\
-		typecheck(unsigned long, flags);	\
-		local_irq_save(flags);			\
-	} while (0)
-# define raw_local_irq_restore(flags)			\
+#define local_save_flags(flags)				\
 	do {						\
-		typecheck(unsigned long, flags);	\
-		local_irq_restore(flags);		\
+		raw_local_save_flags(flags);		\
 	} while (0)
-#endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
 
-#ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
-#define safe_halt()						\
-	do {							\
-		trace_hardirqs_on();				\
-		raw_safe_halt();				\
-	} while (0)
+#define irqs_disabled_flags(flags)			\
+	({						\
+		raw_irqs_disabled_flags(flags);		\
+	})
 
-#define local_save_flags(flags)				\
-	do {						\
-		typecheck(unsigned long, flags);	\
-		raw_local_save_flags(flags);		\
+#define irqs_disabled()					\
+	({						\
+		unsigned long _flags;			\
+		raw_local_save_flags(_flags);		\
+		raw_irqs_disabled_flags(_flags);	\
+	})
+
+#define safe_halt()				\
+	do {					\
+		trace_hardirqs_on();		\
+		raw_safe_halt();		\
 	} while (0)
 
-#define irqs_disabled()						\
-({								\
-	unsigned long _flags;					\
-								\
-	raw_local_save_flags(_flags);				\
-	raw_irqs_disabled_flags(_flags);			\
-})
 
-#define irqs_disabled_flags(flags)		\
-({						\
-	typecheck(unsigned long, flags);	\
-	raw_irqs_disabled_flags(flags);		\
-})
+#else /* !CONFIG_TRACE_IRQFLAGS_SUPPORT */
+
+#define local_irq_enable()	do { raw_local_irq_enable(); } while (0)
+#define local_irq_disable()	do { raw_local_irq_disable(); } while (0)
+#define local_irq_save(flags)					\
+	do {							\
+		raw_local_irq_save(flags);			\
+	} while (0)
+#define local_irq_restore(flags) do { raw_local_irq_restore(flags); } while (0)
+#define local_save_flags(flags)	do { raw_local_save_flags(flags); } while (0)
+#define irqs_disabled()		(raw_irqs_disabled())
+#define irqs_disabled_flags(flags) (raw_irqs_disabled_flags(flags))
+#define safe_halt()		do { raw_safe_halt(); } while (0)
+
 #endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
 
 #endif
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index f885465..80e5358 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -50,6 +50,7 @@
 #include <linux/preempt.h>
 #include <linux/linkage.h>
 #include <linux/compiler.h>
+#include <linux/irqflags.h>
 #include <linux/thread_info.h>
 #include <linux/kernel.h>
 #include <linux/stringify.h>

