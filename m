Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab0HZOL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 10:11:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab0HZOLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 10:11:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 6/7] Blackfin: Rename IRQ flags handling functions
To: linux-arch@vger.kernel.org, vapier@gentoo.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
Date: Thu, 26 Aug 2010 15:11:36 +0100
Message-ID: <20100826141136.11132.54361.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100826141110.11132.91931.stgit@warthog.procyon.org.uk>
References: <20100826141110.11132.91931.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename h/w IRQ flags handling functions to be in line with what is expected for
the irq renaming patch.  This renames local_*_hw() to hard_local_*() using the
following perl command:

	perl -pi -e 's/local_irq_(restore|enable|disable)_hw/hard_local_irq_\1/ or s/local_irq_save_hw([_a-z]*)[(]flags[)]/flags = hard_local_irq_save\1()/' `find arch/blackfin/ -name "*.[ch]"`

and then fixing up asm/irqflags.h manually.

Additionally, arch/hard_local_save_flags() and arch/hard_local_irq_save() both
return the flags rather than passing it through the argument list.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/blackfin/include/asm/ipipe.h                |    8 -
 arch/blackfin/include/asm/irqflags.h             |  284 +++++++++++-----------
 arch/blackfin/include/asm/mmu_context.h          |    8 -
 arch/blackfin/include/asm/system.h               |    4 
 arch/blackfin/kernel/bfin_gpio.c                 |  102 ++++----
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c          |    8 -
 arch/blackfin/kernel/ipipe.c                     |   38 +--
 arch/blackfin/kernel/process.c                   |    4 
 arch/blackfin/mach-bf518/include/mach/pll.h      |    8 -
 arch/blackfin/mach-bf527/include/mach/pll.h      |    8 -
 arch/blackfin/mach-bf533/include/mach/fio_flag.h |    8 -
 arch/blackfin/mach-bf533/include/mach/pll.h      |    8 -
 arch/blackfin/mach-bf537/include/mach/pll.h      |    8 -
 arch/blackfin/mach-bf538/include/mach/pll.h      |    8 -
 arch/blackfin/mach-bf548/include/mach/pll.h      |    8 -
 arch/blackfin/mach-bf561/include/mach/pll.h      |    8 -
 arch/blackfin/mach-common/cpufreq.c              |    4 
 arch/blackfin/mach-common/ints-priority.c        |   24 +-
 arch/blackfin/mach-common/pm.c                   |   10 -
 19 files changed, 284 insertions(+), 274 deletions(-)

diff --git a/arch/blackfin/include/asm/ipipe.h b/arch/blackfin/include/asm/ipipe.h
index d3b4044..40f94a7 100644
--- a/arch/blackfin/include/asm/ipipe.h
+++ b/arch/blackfin/include/asm/ipipe.h
@@ -49,7 +49,7 @@
 #define prepare_arch_switch(next)		\
 do {						\
 	ipipe_schedule_notify(current, next);	\
-	local_irq_disable_hw();			\
+	hard_local_irq_disable();			\
 } while (0)
 
 #define task_hijacked(p)						\
@@ -57,7 +57,7 @@ do {						\
 		int __x__ = __ipipe_root_domain_p;			\
 		__clear_bit(IPIPE_SYNC_FLAG, &ipipe_root_cpudom_var(status)); \
 		if (__x__)						\
-			local_irq_enable_hw();				\
+			hard_local_irq_enable();				\
 		!__x__;							\
 	})
 
@@ -167,7 +167,7 @@ static inline unsigned long __ipipe_ffnz(unsigned long ul)
 #define __ipipe_run_isr(ipd, irq)					\
 	do {								\
 		if (!__ipipe_pipeline_head_p(ipd))			\
-			local_irq_enable_hw();				\
+			hard_local_irq_enable();				\
 		if (ipd == ipipe_root_domain) {				\
 			if (unlikely(ipipe_virtual_irq_p(irq))) {	\
 				irq_enter();				\
@@ -183,7 +183,7 @@ static inline unsigned long __ipipe_ffnz(unsigned long ul)
 			__ipipe_run_irqtail();				\
 			__set_bit(IPIPE_SYNC_FLAG, &ipipe_cpudom_var(ipd, status)); \
 		}							\
-		local_irq_disable_hw();					\
+		hard_local_irq_disable();					\
 	} while (0)
 
 #define __ipipe_syscall_watched_p(p, sc)	\
diff --git a/arch/blackfin/include/asm/irqflags.h b/arch/blackfin/include/asm/irqflags.h
index f3ed931..88f1ee1 100644
--- a/arch/blackfin/include/asm/irqflags.h
+++ b/arch/blackfin/include/asm/irqflags.h
@@ -33,54 +33,108 @@ static inline unsigned long bfin_cli(void)
 	return flags;
 }
 
-#ifdef CONFIG_IPIPE
-
-#include <linux/compiler.h>
-#include <linux/ipipe_base.h>
-#include <linux/ipipe_trace.h>
-
 #ifdef CONFIG_DEBUG_HWERR
 # define bfin_no_irqs 0x3f
 #else
 # define bfin_no_irqs 0x1f
 #endif
 
-#define raw_local_irq_disable()				\
-	do {						\
-		ipipe_check_context(ipipe_root_domain);	\
-		__ipipe_stall_root();			\
-		barrier();				\
-	} while (0)
+/*****************************************************************************/
+/*
+ * Hard, untraced CPU interrupt flag manipulation and access.
+ */
+static inline void __hard_local_irq_disable(void)
+{
+	bfin_cli();
+}
+
+static inline void __hard_local_irq_enable(void)
+{
+	bfin_sti(bfin_irq_flags);
+}
+
+static inline unsigned long hard_local_save_flags(void)
+{
+	return bfin_read_IMASK();
+}
+
+static inline unsigned long __hard_local_irq_save(void)
+{
+	unsigned long flags;
+	flags = bfin_cli();
+#ifdef CONFIG_DEBUG_HWERR
+	bfin_sti(0x3f);
+#endif
+	return flags;
+}
+
+static inline int hard_irqs_disabled_flags(unsigned long flags)
+{
+	return (flags & ~0x3f) == 0;
+}
 
-#define raw_local_irq_enable()				\
-	do {						\
-		barrier();				\
-		ipipe_check_context(ipipe_root_domain);	\
-		__ipipe_unstall_root();			\
-	} while (0)
+static inline int hard_irqs_disabled(void)
+{
+	unsigned long flags = hard_local_save_flags();
+	return hard_irqs_disabled_flags(flags);
+}
 
-#define raw_local_save_flags_ptr(x)					\
-	do {								\
-		*(x) = __ipipe_test_root() ? bfin_no_irqs : bfin_irq_flags; \
-	} while (0)
+static inline void __hard_local_irq_restore(unsigned long flags)
+{
+	if (!hard_irqs_disabled_flags(flags))
+		__hard_local_irq_enable();
+}
 
-#define raw_local_save_flags(x)		raw_local_save_flags_ptr(&(x))
+/*****************************************************************************/
+/*
+ * Interrupt pipe handling.
+ */
+#ifdef CONFIG_IPIPE
 
-#define raw_irqs_disabled_flags(x)	((x) == bfin_no_irqs)
+#include <linux/compiler.h>
+#include <linux/ipipe_base.h>
+#include <linux/ipipe_trace.h>
 
-#define raw_local_irq_save_ptr(x)					\
-	do {								\
-		*(x) = __ipipe_test_and_stall_root() ? bfin_no_irqs : bfin_irq_flags; \
-		barrier();						\
-	} while (0)
+/*
+ * Interrupt pipe interface to linux/irqflags.h.
+ */
+static inline void arch_local_irq_disable(void)
+{
+	ipipe_check_context(ipipe_root_domain);
+	__ipipe_stall_root();
+	barrier();
+}
 
-#define raw_local_irq_save(x)				\
-	do {						\
-		ipipe_check_context(ipipe_root_domain);	\
-		raw_local_irq_save_ptr(&(x));		\
-	} while (0)
+static inline void arch_local_irq_enable(void)
+{
+	barrier();
+	ipipe_check_context(ipipe_root_domain);
+	__ipipe_unstall_root();
+}
+	  
+static inline unsigned long arch_local_save_flags(void)
+{
+	return __ipipe_test_root() ? bfin_no_irqs : bfin_irq_flags;
+}
 
-static inline unsigned long raw_mangle_irq_bits(int virt, unsigned long real)
+static inline int arch_irqs_disabled_flags(unsigned long flags)
+{
+	return flags == bfin_no_irqs;
+}
+
+static inline void arch_local_irq_save_ptr(unsigned long *_flags)
+{
+	x = __ipipe_test_and_stall_root() ? bfin_no_irqs : bfin_irq_flags;
+	barrier();
+}
+
+static inline unsigned long arch_local_irq_save(void)
+{
+	ipipe_check_context(ipipe_root_domain);
+	return __hard_local_irq_save();
+}
+
+static inline unsigned long arch_mangle_irq_bits(int virt, unsigned long real)
 {
 	/*
 	 * Merge virtual and real interrupt mask bits into a single
@@ -89,135 +143,91 @@ static inline unsigned long raw_mangle_irq_bits(int virt, unsigned long real)
 	return (real & ~(1 << 31)) | ((virt != 0) << 31);
 }
 
-static inline int raw_demangle_irq_bits(unsigned long *x)
+static inline int arch_demangle_irq_bits(unsigned long *x)
 {
 	int virt = (*x & (1 << 31)) != 0;
 	*x &= ~(1L << 31);
 	return virt;
 }
 
-static inline void local_irq_disable_hw_notrace(void)
+/*
+ * Interface to various arch routines that may be traced.
+ */
+#ifdef CONFIG_IPIPE_TRACE_IRQSOFF
+static inline void hard_local_irq_disable(void)
 {
-	bfin_cli();
+	if (!hard_irqs_disabled()) {
+		__hard_local_irq_disable();
+		ipipe_trace_begin(0x80000000);
+	}
 }
 
-static inline void local_irq_enable_hw_notrace(void)
+static inline void hard_local_irq_enable(void)
 {
-	bfin_sti(bfin_irq_flags);
+	if (hard_irqs_disabled()) {
+		ipipe_trace_end(0x80000000);
+		__hard_local_irq_enable();
+	}
 }
 
-#define local_save_flags_hw(flags)			\
-	do {						\
-		(flags) = bfin_read_IMASK();		\
-	} while (0)
-
-#define irqs_disabled_flags_hw(flags) (((flags) & ~0x3f) == 0)
-
-#define irqs_disabled_hw()			\
-	({					\
-	unsigned long flags;			\
-	local_save_flags_hw(flags);		\
-	irqs_disabled_flags_hw(flags);		\
-	})
-
-static inline void local_irq_save_ptr_hw(unsigned long *flags)
+static inline unsigned long hard_local_irq_save(void)
 {
-	*flags = bfin_cli();
-#ifdef CONFIG_DEBUG_HWERR
-	bfin_sti(0x3f);
-#endif
+	unsigned long flags = hard_local_save_flags();
+	if (!hard_irqs_disabled_flags(flags)) {
+		__hard_local_irq_disable();
+		ipipe_trace_begin(0x80000001);
+	}
+	return flags;
 }
 
-#define local_irq_save_hw_notrace(flags)		\
-	do {						\
-		local_irq_save_ptr_hw(&(flags));	\
-	} while (0)
-
-static inline void local_irq_restore_hw_notrace(unsigned long flags)
+static inline void hard_local_irq_restore(unsigned long flags)
 {
-	if (!irqs_disabled_flags_hw(flags))
-		local_irq_enable_hw_notrace();
+	if (!hard_irqs_disabled_flags(flags)) {
+		ipipe_trace_end(0x80000001);
+		__hard_local_irq_enable();
+	}
 }
 
-#ifdef CONFIG_IPIPE_TRACE_IRQSOFF
-# define local_irq_disable_hw()				\
-	do {						\
-		if (!irqs_disabled_hw()) {		\
-			local_irq_disable_hw_notrace();	\
-			ipipe_trace_begin(0x80000000);	\
-		}					\
-	} while (0)
-# define local_irq_enable_hw()				\
-	do {						\
-		if (irqs_disabled_hw()) {		\
-			ipipe_trace_end(0x80000000);	\
-			local_irq_enable_hw_notrace();	\
-		}					\
-	} while (0)
-# define local_irq_save_hw(flags)			\
-	do {						\
-		local_save_flags_hw(flags);		\
-		if (!irqs_disabled_flags_hw(flags)) {	\
-			local_irq_disable_hw_notrace();	\
-			ipipe_trace_begin(0x80000001);	\
-		}					\
-	} while (0)
-# define local_irq_restore_hw(flags)			\
-	do {						\
-		if (!irqs_disabled_flags_hw(flags)) {	\
-			ipipe_trace_end(0x80000001);	\
-			local_irq_enable_hw_notrace();	\
-		}					\
-	} while (0)
 #else /* !CONFIG_IPIPE_TRACE_IRQSOFF */
-# define local_irq_disable_hw()		local_irq_disable_hw_notrace()
-# define local_irq_enable_hw()		local_irq_enable_hw_notrace()
-# define local_irq_save_hw(flags)	local_irq_save_hw_notrace(flags)
-# define local_irq_restore_hw(flags)	local_irq_restore_hw_notrace(flags)
+# define hard_local_irq_disable()	__hard_local_irq_disable()
+# define hard_local_irq_enable()	__hard_local_irq_enable()
+# define hard_local_irq_save()		__hard_local_irq_save()
+# define hard_local_irq_restore(flags)	__hard_local_irq_restore(flags)
 #endif /* !CONFIG_IPIPE_TRACE_IRQSOFF */
 
 #else /* CONFIG_IPIPE */
 
-static inline void raw_local_irq_disable(void)
-{
-	bfin_cli();
-}
-static inline void raw_local_irq_enable(void)
-{
-	bfin_sti(bfin_irq_flags);
-}
-
-static inline unsigned long arch_local_save_flags(void)
-{
-	return bfin_read_IMASK();
-}
-
-#define raw_local_save_flags(flags) do { (flags) = arch_local_save_flags(); } while (0)
-
-#define raw_irqs_disabled_flags(flags) (((flags) & ~0x3f) == 0)
+/*
+ * Direct interface to linux/irqflags.h.
+ */
+#define arch_local_save_flags()		hard_local_save_flags()
+#define arch_local_irq_save(flags)	__hard_local_irq_save()
+#define arch_local_irq_restore(flags)	__hard_local_irq_restore(flags)
+#define arch_local_irq_enable()		__hard_local_irq_enable()
+#define arch_local_irq_disable()	__hard_local_irq_disable()
+#define arch_irqs_disabled_flags(flags)	hard_irqs_disabled_flags(flags)
+#define arch_irqs_disabled()		hard_irqs_disabled()
 
-static inline unsigned long __raw_local_irq_save(void)
-{
-	unsigned long flags = bfin_cli();
-#ifdef CONFIG_DEBUG_HWERR
-	bfin_sti(0x3f);
-#endif
-	return flags;
-}
-#define raw_local_irq_save(flags) do { (flags) = __raw_local_irq_save(); } while (0)
+/*
+ * Interface to various arch routines that may be traced.
+ */
+#define hard_local_irq_save()		__hard_local_irq_save()
+#define hard_local_irq_restore(flags)	__hard_local_irq_restore(flags)
+#define hard_local_irq_enable()		__hard_local_irq_enable()
+#define hard_local_irq_disable()	__hard_local_irq_disable()
 
-#define local_irq_save_hw(flags)	raw_local_irq_save(flags)
-#define local_irq_restore_hw(flags)	raw_local_irq_restore(flags)
-#define local_irq_enable_hw()		raw_local_irq_enable()
-#define local_irq_disable_hw()		raw_local_irq_disable()
-#define irqs_disabled_hw()		irqs_disabled()
 
 #endif /* !CONFIG_IPIPE */
 
-static inline void raw_local_irq_restore(unsigned long flags)
-{
-	if (!raw_irqs_disabled_flags(flags))
-		raw_local_irq_enable();
-}
+/*
+ * Raw interface to linux/irqflags.h.
+ */
+#define raw_local_save_flags(flags)	do { (flags) = arch_local_save_flags(); } while (0)
+#define raw_local_irq_save(flags)	do { (flags) = arch_local_irq_save(); } while (0)
+#define raw_local_irq_restore(flags)	arch_local_irq_restore(flags)
+#define raw_local_irq_enable()		arch_local_irq_enable()
+#define raw_local_irq_disable()		arch_local_irq_disable()
+#define raw_irqs_disabled_flags(flags)	arch_irqs_disabled_flags(flags)
+#define raw_irqs_disabled()		arch_irqs_disabled()
 
 #endif
diff --git a/arch/blackfin/include/asm/mmu_context.h b/arch/blackfin/include/asm/mmu_context.h
index e1a9b46..3828c70 100644
--- a/arch/blackfin/include/asm/mmu_context.h
+++ b/arch/blackfin/include/asm/mmu_context.h
@@ -97,8 +97,8 @@ static inline void __switch_mm(struct mm_struct *prev_mm, struct mm_struct *next
 }
 
 #ifdef CONFIG_IPIPE
-#define lock_mm_switch(flags)	local_irq_save_hw_cond(flags)
-#define unlock_mm_switch(flags)	local_irq_restore_hw_cond(flags)
+#define lock_mm_switch(flags)	flags = hard_local_irq_save_cond()
+#define unlock_mm_switch(flags)	hard_local_irq_restore_cond(flags)
 #else
 #define lock_mm_switch(flags)	do { (void)(flags); } while (0)
 #define unlock_mm_switch(flags)	do { (void)(flags); } while (0)
@@ -205,9 +205,9 @@ static inline void destroy_context(struct mm_struct *mm)
 }
 
 #define ipipe_mm_switch_protect(flags)		\
-	local_irq_save_hw_cond(flags)
+	flags = hard_local_irq_save_cond()
 
 #define ipipe_mm_switch_unprotect(flags)	\
-	local_irq_restore_hw_cond(flags)
+	hard_local_irq_restore_cond(flags)
 
 #endif
diff --git a/arch/blackfin/include/asm/system.h b/arch/blackfin/include/asm/system.h
index dde19b1..19e2c7c 100644
--- a/arch/blackfin/include/asm/system.h
+++ b/arch/blackfin/include/asm/system.h
@@ -117,7 +117,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
 	unsigned long tmp = 0;
 	unsigned long flags;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 
 	switch (size) {
 	case 1:
@@ -139,7 +139,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
 			 : "=&d" (tmp) : "d" (x), "m" (*__xg(ptr)) : "memory");
 		break;
 	}
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 	return tmp;
 }
 
diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index dc07ed0..ca1c1f9 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -349,13 +349,13 @@ inline void portmux_setup(unsigned short per)
 void set_gpio_ ## name(unsigned gpio, unsigned short arg) \
 { \
 	unsigned long flags; \
-	local_irq_save_hw(flags); \
+	flags = hard_local_irq_save(); \
 	if (arg) \
 		gpio_array[gpio_bank(gpio)]->name |= gpio_bit(gpio); \
 	else \
 		gpio_array[gpio_bank(gpio)]->name &= ~gpio_bit(gpio); \
 	AWA_DUMMY_READ(name); \
-	local_irq_restore_hw(flags); \
+	hard_local_irq_restore(flags); \
 } \
 EXPORT_SYMBOL(set_gpio_ ## name);
 
@@ -371,14 +371,14 @@ void set_gpio_ ## name(unsigned gpio, unsigned short arg) \
 { \
 	unsigned long flags; \
 	if (ANOMALY_05000311 || ANOMALY_05000323) \
-		local_irq_save_hw(flags); \
+		flags = hard_local_irq_save(); \
 	if (arg) \
 		gpio_array[gpio_bank(gpio)]->name ## _set = gpio_bit(gpio); \
 	else \
 		gpio_array[gpio_bank(gpio)]->name ## _clear = gpio_bit(gpio); \
 	if (ANOMALY_05000311 || ANOMALY_05000323) { \
 		AWA_DUMMY_READ(name); \
-		local_irq_restore_hw(flags); \
+		hard_local_irq_restore(flags); \
 	} \
 } \
 EXPORT_SYMBOL(set_gpio_ ## name);
@@ -391,11 +391,11 @@ void set_gpio_toggle(unsigned gpio)
 {
 	unsigned long flags;
 	if (ANOMALY_05000311 || ANOMALY_05000323)
-		local_irq_save_hw(flags);
+		flags = hard_local_irq_save();
 	gpio_array[gpio_bank(gpio)]->toggle = gpio_bit(gpio);
 	if (ANOMALY_05000311 || ANOMALY_05000323) {
 		AWA_DUMMY_READ(toggle);
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 	}
 }
 EXPORT_SYMBOL(set_gpio_toggle);
@@ -408,11 +408,11 @@ void set_gpiop_ ## name(unsigned gpio, unsigned short arg) \
 { \
 	unsigned long flags; \
 	if (ANOMALY_05000311 || ANOMALY_05000323) \
-		local_irq_save_hw(flags); \
+		flags = hard_local_irq_save(); \
 	gpio_array[gpio_bank(gpio)]->name = arg; \
 	if (ANOMALY_05000311 || ANOMALY_05000323) { \
 		AWA_DUMMY_READ(name); \
-		local_irq_restore_hw(flags); \
+		hard_local_irq_restore(flags); \
 	} \
 } \
 EXPORT_SYMBOL(set_gpiop_ ## name);
@@ -433,11 +433,11 @@ unsigned short get_gpio_ ## name(unsigned gpio) \
 	unsigned long flags; \
 	unsigned short ret; \
 	if (ANOMALY_05000311 || ANOMALY_05000323) \
-		local_irq_save_hw(flags); \
+		flags = hard_local_irq_save(); \
 	ret = 0x01 & (gpio_array[gpio_bank(gpio)]->name >> gpio_sub_n(gpio)); \
 	if (ANOMALY_05000311 || ANOMALY_05000323) { \
 		AWA_DUMMY_READ(name); \
-		local_irq_restore_hw(flags); \
+		hard_local_irq_restore(flags); \
 	} \
 	return ret; \
 } \
@@ -460,11 +460,11 @@ unsigned short get_gpiop_ ## name(unsigned gpio) \
 	unsigned long flags; \
 	unsigned short ret; \
 	if (ANOMALY_05000311 || ANOMALY_05000323) \
-		local_irq_save_hw(flags); \
+		flags = hard_local_irq_save(); \
 	ret = (gpio_array[gpio_bank(gpio)]->name); \
 	if (ANOMALY_05000311 || ANOMALY_05000323) { \
 		AWA_DUMMY_READ(name); \
-		local_irq_restore_hw(flags); \
+		hard_local_irq_restore(flags); \
 	} \
 	return ret; \
 } \
@@ -525,14 +525,14 @@ int gpio_pm_wakeup_ctrl(unsigned gpio, unsigned ctrl)
 	if (check_gpio(gpio) < 0)
 		return -EINVAL;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	if (ctrl)
 		reserve(wakeup, gpio);
 	else
 		unreserve(wakeup, gpio);
 
 	set_gpio_maskb(gpio, ctrl);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 
 	return 0;
 }
@@ -690,7 +690,7 @@ int peripheral_request(unsigned short per, const char *label)
 
 	BUG_ON(ident >= MAX_RESOURCES);
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 
 	/* If a pin can be muxed as either GPIO or peripheral, make
 	 * sure it is not already a GPIO pin when we request it.
@@ -701,7 +701,7 @@ int peripheral_request(unsigned short per, const char *label)
 		printk(KERN_ERR
 		       "%s: Peripheral %d is already reserved as GPIO by %s !\n",
 		       __func__, ident, get_label(ident));
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 		return -EBUSY;
 	}
 
@@ -730,7 +730,7 @@ int peripheral_request(unsigned short per, const char *label)
 			printk(KERN_ERR
 			       "%s: Peripheral %d function %d is already reserved by %s !\n",
 			       __func__, ident, P_FUNCT2MUX(per), get_label(ident));
-			local_irq_restore_hw(flags);
+			hard_local_irq_restore(flags);
 			return -EBUSY;
 		}
 	}
@@ -741,7 +741,7 @@ int peripheral_request(unsigned short per, const char *label)
 	portmux_setup(per);
 	port_setup(ident, PERIPHERAL_USAGE);
 
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 	set_label(ident, label);
 
 	return 0;
@@ -780,10 +780,10 @@ void peripheral_free(unsigned short per)
 	if (!(per & P_DEFINED))
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 
 	if (unlikely(!is_reserved(peri, ident, 0))) {
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 		return;
 	}
 
@@ -794,7 +794,7 @@ void peripheral_free(unsigned short per)
 
 	set_label(ident, "free");
 
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 EXPORT_SYMBOL(peripheral_free);
 
@@ -828,7 +828,7 @@ int bfin_gpio_request(unsigned gpio, const char *label)
 	if (check_gpio(gpio) < 0)
 		return -EINVAL;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 
 	/*
 	 * Allow that the identical GPIO can
@@ -837,7 +837,7 @@ int bfin_gpio_request(unsigned gpio, const char *label)
 	 */
 
 	if (cmp_label(gpio, label) == 0) {
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 		return 0;
 	}
 
@@ -846,7 +846,7 @@ int bfin_gpio_request(unsigned gpio, const char *label)
 			dump_stack();
 		printk(KERN_ERR "bfin-gpio: GPIO %d is already reserved by %s !\n",
 		       gpio, get_label(gpio));
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 		return -EBUSY;
 	}
 	if (unlikely(is_reserved(peri, gpio, 1))) {
@@ -855,7 +855,7 @@ int bfin_gpio_request(unsigned gpio, const char *label)
 		printk(KERN_ERR
 		       "bfin-gpio: GPIO %d is already reserved as Peripheral by %s !\n",
 		       gpio, get_label(gpio));
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 		return -EBUSY;
 	}
 	if (unlikely(is_reserved(gpio_irq, gpio, 1))) {
@@ -871,7 +871,7 @@ int bfin_gpio_request(unsigned gpio, const char *label)
 	reserve(gpio, gpio);
 	set_label(gpio, label);
 
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 
 	port_setup(gpio, GPIO_USAGE);
 
@@ -888,13 +888,13 @@ void bfin_gpio_free(unsigned gpio)
 
 	might_sleep();
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 
 	if (unlikely(!is_reserved(gpio, gpio, 0))) {
 		if (system_state == SYSTEM_BOOTING)
 			dump_stack();
 		gpio_error(gpio);
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 		return;
 	}
 
@@ -902,7 +902,7 @@ void bfin_gpio_free(unsigned gpio)
 
 	set_label(gpio, "free");
 
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 EXPORT_SYMBOL(bfin_gpio_free);
 
@@ -913,7 +913,7 @@ int bfin_special_gpio_request(unsigned gpio, const char *label)
 {
 	unsigned long flags;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 
 	/*
 	 * Allow that the identical GPIO can
@@ -922,19 +922,19 @@ int bfin_special_gpio_request(unsigned gpio, const char *label)
 	 */
 
 	if (cmp_label(gpio, label) == 0) {
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 		return 0;
 	}
 
 	if (unlikely(is_reserved(special_gpio, gpio, 1))) {
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 		printk(KERN_ERR "bfin-gpio: GPIO %d is already reserved by %s !\n",
 		       gpio, get_label(gpio));
 
 		return -EBUSY;
 	}
 	if (unlikely(is_reserved(peri, gpio, 1))) {
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 		printk(KERN_ERR
 		       "bfin-gpio: GPIO %d is already reserved as Peripheral by %s !\n",
 		       gpio, get_label(gpio));
@@ -946,7 +946,7 @@ int bfin_special_gpio_request(unsigned gpio, const char *label)
 	reserve(peri, gpio);
 
 	set_label(gpio, label);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 	port_setup(gpio, GPIO_USAGE);
 
 	return 0;
@@ -959,18 +959,18 @@ void bfin_special_gpio_free(unsigned gpio)
 
 	might_sleep();
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 
 	if (unlikely(!is_reserved(special_gpio, gpio, 0))) {
 		gpio_error(gpio);
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 		return;
 	}
 
 	unreserve(special_gpio, gpio);
 	unreserve(peri, gpio);
 	set_label(gpio, "free");
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 EXPORT_SYMBOL(bfin_special_gpio_free);
 #endif
@@ -983,7 +983,7 @@ int bfin_gpio_irq_request(unsigned gpio, const char *label)
 	if (check_gpio(gpio) < 0)
 		return -EINVAL;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 
 	if (unlikely(is_reserved(peri, gpio, 1))) {
 		if (system_state == SYSTEM_BOOTING)
@@ -991,7 +991,7 @@ int bfin_gpio_irq_request(unsigned gpio, const char *label)
 		printk(KERN_ERR
 		       "bfin-gpio: GPIO %d is already reserved as Peripheral by %s !\n",
 		       gpio, get_label(gpio));
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 		return -EBUSY;
 	}
 	if (unlikely(is_reserved(gpio, gpio, 1)))
@@ -1002,7 +1002,7 @@ int bfin_gpio_irq_request(unsigned gpio, const char *label)
 	reserve(gpio_irq, gpio);
 	set_label(gpio, label);
 
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 
 	port_setup(gpio, GPIO_USAGE);
 
@@ -1016,13 +1016,13 @@ void bfin_gpio_irq_free(unsigned gpio)
 	if (check_gpio(gpio) < 0)
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 
 	if (unlikely(!is_reserved(gpio_irq, gpio, 0))) {
 		if (system_state == SYSTEM_BOOTING)
 			dump_stack();
 		gpio_error(gpio);
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 		return;
 	}
 
@@ -1030,7 +1030,7 @@ void bfin_gpio_irq_free(unsigned gpio)
 
 	set_label(gpio, "free");
 
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 static inline void __bfin_gpio_direction_input(unsigned gpio)
@@ -1052,10 +1052,10 @@ int bfin_gpio_direction_input(unsigned gpio)
 		return -EINVAL;
 	}
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	__bfin_gpio_direction_input(gpio);
 	AWA_DUMMY_READ(inen);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 
 	return 0;
 }
@@ -1070,9 +1070,9 @@ void bfin_gpio_irq_prepare(unsigned gpio)
 	port_setup(gpio, GPIO_USAGE);
 
 #ifdef CONFIG_BF54x
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	__bfin_gpio_direction_input(gpio);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 #endif
 }
 
@@ -1094,7 +1094,7 @@ int bfin_gpio_direction_output(unsigned gpio, int value)
 		return -EINVAL;
 	}
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 
 	gpio_array[gpio_bank(gpio)]->inen &= ~gpio_bit(gpio);
 	gpio_set_value(gpio, value);
@@ -1105,7 +1105,7 @@ int bfin_gpio_direction_output(unsigned gpio, int value)
 #endif
 
 	AWA_DUMMY_READ(dir);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 
 	return 0;
 }
@@ -1120,11 +1120,11 @@ int bfin_gpio_get_value(unsigned gpio)
 
 	if (unlikely(get_gpio_edge(gpio))) {
 		int ret;
-		local_irq_save_hw(flags);
+		flags = hard_local_irq_save();
 		set_gpio_edge(gpio, 0);
 		ret = get_gpio_data(gpio);
 		set_gpio_edge(gpio, 1);
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 		return ret;
 	} else
 		return get_gpio_data(gpio);
diff --git a/arch/blackfin/kernel/cplb-mpu/cplbmgr.c b/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
index 87b25b1..8de9229 100644
--- a/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
+++ b/arch/blackfin/kernel/cplb-mpu/cplbmgr.c
@@ -318,7 +318,7 @@ void flush_switched_cplbs(unsigned int cpu)
 
 	nr_cplb_flush[cpu]++;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	_disable_icplb();
 	for (i = first_switched_icplb; i < MAX_CPLBS; i++) {
 		icplb_tbl[cpu][i].data = 0;
@@ -332,7 +332,7 @@ void flush_switched_cplbs(unsigned int cpu)
 		bfin_write32(DCPLB_DATA0 + i * 4, 0);
 	}
 	_enable_dcplb();
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 
 }
 
@@ -348,7 +348,7 @@ void set_mask_dcplbs(unsigned long *masks, unsigned int cpu)
 		return;
 	}
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	current_rwx_mask[cpu] = masks;
 
 	if (L2_LENGTH && addr >= L2_START && addr < L2_START + L2_LENGTH) {
@@ -373,5 +373,5 @@ void set_mask_dcplbs(unsigned long *masks, unsigned int cpu)
 		addr += PAGE_SIZE;
 	}
 	_enable_dcplb();
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
diff --git a/arch/blackfin/kernel/ipipe.c b/arch/blackfin/kernel/ipipe.c
index 1a496cd..3b1da4a 100644
--- a/arch/blackfin/kernel/ipipe.c
+++ b/arch/blackfin/kernel/ipipe.c
@@ -219,10 +219,10 @@ int __ipipe_syscall_root(struct pt_regs *regs)
 
 	ret = __ipipe_dispatch_event(IPIPE_EVENT_SYSCALL, regs);
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 
 	if (!__ipipe_root_domain_p) {
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 		return 1;
 	}
 
@@ -230,7 +230,7 @@ int __ipipe_syscall_root(struct pt_regs *regs)
 	if ((p->irqpend_himask & IPIPE_IRQMASK_VIRT) != 0)
 		__ipipe_sync_pipeline(IPIPE_IRQMASK_VIRT);
 
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 
 	return -ret;
 }
@@ -239,14 +239,14 @@ unsigned long ipipe_critical_enter(void (*syncfn) (void))
 {
 	unsigned long flags;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 
 	return flags;
 }
 
 void ipipe_critical_exit(unsigned long flags)
 {
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 static void __ipipe_no_irqtail(void)
@@ -279,9 +279,9 @@ int ipipe_trigger_irq(unsigned irq)
 		return -EINVAL;
 #endif
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	__ipipe_handle_irq(irq, NULL);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 
 	return 1;
 }
@@ -293,7 +293,7 @@ asmlinkage void __ipipe_sync_root(void)
 
 	BUG_ON(irqs_disabled());
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 
 	if (irq_tail_hook)
 		irq_tail_hook();
@@ -303,7 +303,7 @@ asmlinkage void __ipipe_sync_root(void)
 	if (ipipe_root_cpudom_var(irqpend_himask) != 0)
 		__ipipe_sync_pipeline(IPIPE_IRQMASK_ANY);
 
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 void ___ipipe_sync_pipeline(unsigned long syncmask)
@@ -344,10 +344,10 @@ void __ipipe_stall_root(void)
 {
 	unsigned long *p, flags;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	p = &__ipipe_root_status;
 	__set_bit(IPIPE_STALL_FLAG, p);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 EXPORT_SYMBOL(__ipipe_stall_root);
 
@@ -356,10 +356,10 @@ unsigned long __ipipe_test_and_stall_root(void)
 	unsigned long *p, flags;
 	int x;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	p = &__ipipe_root_status;
 	x = __test_and_set_bit(IPIPE_STALL_FLAG, p);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 
 	return x;
 }
@@ -371,10 +371,10 @@ unsigned long __ipipe_test_root(void)
 	unsigned long flags;
 	int x;
 
-	local_irq_save_hw_smp(flags);
+	flags = hard_local_irq_save_smp();
 	p = &__ipipe_root_status;
 	x = test_bit(IPIPE_STALL_FLAG, p);
-	local_irq_restore_hw_smp(flags);
+	hard_local_irq_restore_smp(flags);
 
 	return x;
 }
@@ -384,10 +384,10 @@ void __ipipe_lock_root(void)
 {
 	unsigned long *p, flags;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	p = &__ipipe_root_status;
 	__set_bit(IPIPE_SYNCDEFER_FLAG, p);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 EXPORT_SYMBOL(__ipipe_lock_root);
 
@@ -395,9 +395,9 @@ void __ipipe_unlock_root(void)
 {
 	unsigned long *p, flags;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	p = &__ipipe_root_status;
 	__clear_bit(IPIPE_SYNCDEFER_FLAG, p);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 EXPORT_SYMBOL(__ipipe_unlock_root);
diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 01f98cb..c86a3ed 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -65,11 +65,11 @@ static void default_idle(void)
 #ifdef CONFIG_IPIPE
 	ipipe_suspend_domain();
 #endif
-	local_irq_disable_hw();
+	hard_local_irq_disable();
 	if (!need_resched())
 		idle_with_irq_disabled();
 
-	local_irq_enable_hw();
+	hard_local_irq_enable();
 }
 
 /*
diff --git a/arch/blackfin/mach-bf518/include/mach/pll.h b/arch/blackfin/mach-bf518/include/mach/pll.h
index 9c19a07..d550298 100644
--- a/arch/blackfin/mach-bf518/include/mach/pll.h
+++ b/arch/blackfin/mach-bf518/include/mach/pll.h
@@ -18,7 +18,7 @@ static __inline__ void bfin_write_PLL_CTL(unsigned int val)
 	if (val == bfin_read_PLL_CTL())
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr0 = bfin_read32(SIC_IWR0);
 	iwr1 = bfin_read32(SIC_IWR1);
@@ -32,7 +32,7 @@ static __inline__ void bfin_write_PLL_CTL(unsigned int val)
 
 	bfin_write32(SIC_IWR0, iwr0);
 	bfin_write32(SIC_IWR1, iwr1);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 /* Writing to VR_CTL initiates a PLL relock sequence. */
@@ -43,7 +43,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	if (val == bfin_read_VR_CTL())
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr0 = bfin_read32(SIC_IWR0);
 	iwr1 = bfin_read32(SIC_IWR1);
@@ -57,7 +57,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 
 	bfin_write32(SIC_IWR0, iwr0);
 	bfin_write32(SIC_IWR1, iwr1);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 #endif /* _MACH_PLL_H */
diff --git a/arch/blackfin/mach-bf527/include/mach/pll.h b/arch/blackfin/mach-bf527/include/mach/pll.h
index a910522..24f1d7c 100644
--- a/arch/blackfin/mach-bf527/include/mach/pll.h
+++ b/arch/blackfin/mach-bf527/include/mach/pll.h
@@ -18,7 +18,7 @@ static __inline__ void bfin_write_PLL_CTL(unsigned int val)
 	if (val == bfin_read_PLL_CTL())
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr0 = bfin_read32(SIC_IWR0);
 	iwr1 = bfin_read32(SIC_IWR1);
@@ -32,7 +32,7 @@ static __inline__ void bfin_write_PLL_CTL(unsigned int val)
 
 	bfin_write32(SIC_IWR0, iwr0);
 	bfin_write32(SIC_IWR1, iwr1);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 /* Writing to VR_CTL initiates a PLL relock sequence. */
@@ -43,7 +43,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	if (val == bfin_read_VR_CTL())
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr0 = bfin_read32(SIC_IWR0);
 	iwr1 = bfin_read32(SIC_IWR1);
@@ -57,7 +57,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 
 	bfin_write32(SIC_IWR0, iwr0);
 	bfin_write32(SIC_IWR1, iwr1);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 #endif /* _MACH_PLL_H */
diff --git a/arch/blackfin/mach-bf533/include/mach/fio_flag.h b/arch/blackfin/mach-bf533/include/mach/fio_flag.h
index b81905a..d0bfba0 100644
--- a/arch/blackfin/mach-bf533/include/mach/fio_flag.h
+++ b/arch/blackfin/mach-bf533/include/mach/fio_flag.h
@@ -15,10 +15,10 @@
 static inline void bfin_write_FIO_FLAG_##name(unsigned short val) \
 { \
 	unsigned long flags; \
-	local_irq_save_hw(flags); \
+	flags = hard_local_irq_save(); \
 	bfin_write16(FIO_FLAG_##name, val); \
 	bfin_read_CHIPID(); \
-	local_irq_restore_hw(flags); \
+	hard_local_irq_restore(flags); \
 }
 BFIN_WRITE_FIO_FLAG(D)
 BFIN_WRITE_FIO_FLAG(C)
@@ -30,10 +30,10 @@ static inline u16 bfin_read_FIO_FLAG_##name(void) \
 { \
 	unsigned long flags; \
 	u16 ret; \
-	local_irq_save_hw(flags); \
+	flags = hard_local_irq_save(); \
 	ret = bfin_read16(FIO_FLAG_##name); \
 	bfin_read_CHIPID(); \
-	local_irq_restore_hw(flags); \
+	hard_local_irq_restore(flags); \
 	return ret; \
 }
 BFIN_READ_FIO_FLAG(D)
diff --git a/arch/blackfin/mach-bf533/include/mach/pll.h b/arch/blackfin/mach-bf533/include/mach/pll.h
index 9a0c9a2..169c106 100644
--- a/arch/blackfin/mach-bf533/include/mach/pll.h
+++ b/arch/blackfin/mach-bf533/include/mach/pll.h
@@ -18,7 +18,7 @@ static __inline__ void bfin_write_PLL_CTL(unsigned int val)
 	if (val == bfin_read_PLL_CTL())
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr = bfin_read32(SIC_IWR);
 	/* Only allow PPL Wakeup) */
@@ -29,7 +29,7 @@ static __inline__ void bfin_write_PLL_CTL(unsigned int val)
 	asm("IDLE;");
 
 	bfin_write32(SIC_IWR, iwr);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 /* Writing to VR_CTL initiates a PLL relock sequence. */
@@ -40,7 +40,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	if (val == bfin_read_VR_CTL())
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr = bfin_read32(SIC_IWR);
 	/* Only allow PPL Wakeup) */
@@ -51,7 +51,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	asm("IDLE;");
 
 	bfin_write32(SIC_IWR, iwr);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 #endif /* _MACH_PLL_H */
diff --git a/arch/blackfin/mach-bf537/include/mach/pll.h b/arch/blackfin/mach-bf537/include/mach/pll.h
index 9a0c9a2..169c106 100644
--- a/arch/blackfin/mach-bf537/include/mach/pll.h
+++ b/arch/blackfin/mach-bf537/include/mach/pll.h
@@ -18,7 +18,7 @@ static __inline__ void bfin_write_PLL_CTL(unsigned int val)
 	if (val == bfin_read_PLL_CTL())
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr = bfin_read32(SIC_IWR);
 	/* Only allow PPL Wakeup) */
@@ -29,7 +29,7 @@ static __inline__ void bfin_write_PLL_CTL(unsigned int val)
 	asm("IDLE;");
 
 	bfin_write32(SIC_IWR, iwr);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 /* Writing to VR_CTL initiates a PLL relock sequence. */
@@ -40,7 +40,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	if (val == bfin_read_VR_CTL())
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr = bfin_read32(SIC_IWR);
 	/* Only allow PPL Wakeup) */
@@ -51,7 +51,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	asm("IDLE;");
 
 	bfin_write32(SIC_IWR, iwr);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 #endif /* _MACH_PLL_H */
diff --git a/arch/blackfin/mach-bf538/include/mach/pll.h b/arch/blackfin/mach-bf538/include/mach/pll.h
index 0e67452..b30bbcd 100644
--- a/arch/blackfin/mach-bf538/include/mach/pll.h
+++ b/arch/blackfin/mach-bf538/include/mach/pll.h
@@ -18,7 +18,7 @@ static __inline__ void bfin_write_PLL_CTL(unsigned int val)
 	if (val == bfin_read_PLL_CTL())
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr0 = bfin_read32(SIC_IWR0);
 	iwr1 = bfin_read32(SIC_IWR1);
@@ -32,7 +32,7 @@ static __inline__ void bfin_write_PLL_CTL(unsigned int val)
 
 	bfin_write32(SIC_IWR0, iwr0);
 	bfin_write32(SIC_IWR1, iwr1);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 /* Writing to VR_CTL initiates a PLL relock sequence. */
@@ -43,7 +43,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	if (val == bfin_read_VR_CTL())
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr0 = bfin_read32(SIC_IWR0);
 	iwr1 = bfin_read32(SIC_IWR1);
@@ -57,7 +57,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 
 	bfin_write32(SIC_IWR0, iwr0);
 	bfin_write32(SIC_IWR1, iwr1);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 #endif /* _MACH_PLL_H */
diff --git a/arch/blackfin/mach-bf548/include/mach/pll.h b/arch/blackfin/mach-bf548/include/mach/pll.h
index 777fee6..7865a09 100644
--- a/arch/blackfin/mach-bf548/include/mach/pll.h
+++ b/arch/blackfin/mach-bf548/include/mach/pll.h
@@ -18,7 +18,7 @@ static __inline__ void bfin_write_PLL_CTL(unsigned int val)
 	if (val == bfin_read_PLL_CTL())
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr0 = bfin_read32(SIC_IWR0);
 	iwr1 = bfin_read32(SIC_IWR1);
@@ -35,7 +35,7 @@ static __inline__ void bfin_write_PLL_CTL(unsigned int val)
 	bfin_write32(SIC_IWR0, iwr0);
 	bfin_write32(SIC_IWR1, iwr1);
 	bfin_write32(SIC_IWR2, iwr2);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 /* Writing to VR_CTL initiates a PLL relock sequence. */
@@ -46,7 +46,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	if (val == bfin_read_VR_CTL())
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr0 = bfin_read32(SIC_IWR0);
 	iwr1 = bfin_read32(SIC_IWR1);
@@ -63,7 +63,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	bfin_write32(SIC_IWR0, iwr0);
 	bfin_write32(SIC_IWR1, iwr1);
 	bfin_write32(SIC_IWR2, iwr2);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 #endif /* _MACH_PLL_H */
diff --git a/arch/blackfin/mach-bf561/include/mach/pll.h b/arch/blackfin/mach-bf561/include/mach/pll.h
index 4baa44f..f2b1fbd 100644
--- a/arch/blackfin/mach-bf561/include/mach/pll.h
+++ b/arch/blackfin/mach-bf561/include/mach/pll.h
@@ -18,7 +18,7 @@ static __inline__ void bfin_write_PLL_CTL(unsigned int val)
 	if (val == bfin_read_PLL_CTL())
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr0 = bfin_read32(SICA_IWR0);
 	iwr1 = bfin_read32(SICA_IWR1);
@@ -32,7 +32,7 @@ static __inline__ void bfin_write_PLL_CTL(unsigned int val)
 
 	bfin_write32(SICA_IWR0, iwr0);
 	bfin_write32(SICA_IWR1, iwr1);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 /* Writing to VR_CTL initiates a PLL relock sequence. */
@@ -43,7 +43,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 	if (val == bfin_read_VR_CTL())
 		return;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	/* Enable the PLL Wakeup bit in SIC IWR */
 	iwr0 = bfin_read32(SICA_IWR0);
 	iwr1 = bfin_read32(SICA_IWR1);
@@ -57,7 +57,7 @@ static __inline__ void bfin_write_VR_CTL(unsigned int val)
 
 	bfin_write32(SICA_IWR0, iwr0);
 	bfin_write32(SICA_IWR1, iwr1);
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 #endif /* _MACH_PLL_H */
diff --git a/arch/blackfin/mach-common/cpufreq.c b/arch/blackfin/mach-common/cpufreq.c
index 4391d03..f4cf11d 100644
--- a/arch/blackfin/mach-common/cpufreq.c
+++ b/arch/blackfin/mach-common/cpufreq.c
@@ -134,7 +134,7 @@ static int bfin_target(struct cpufreq_policy *poli,
 
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 		if (cpu == CPUFREQ_CPU) {
-			local_irq_save_hw(flags);
+			flags = hard_local_irq_save();
 			plldiv = (bfin_read_PLL_DIV() & SSEL) |
 						dpm_state_table[index].csel;
 			bfin_write_PLL_DIV(plldiv);
@@ -155,7 +155,7 @@ static int bfin_target(struct cpufreq_policy *poli,
 				loops_per_jiffy = cpufreq_scale(lpj_ref,
 						lpj_ref_freq, freqs.new);
 			}
-			local_irq_restore_hw(flags);
+			hard_local_irq_restore(flags);
 		}
 		/* TODO: just test case for cycles clock source, remove later */
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
diff --git a/arch/blackfin/mach-common/ints-priority.c b/arch/blackfin/mach-common/ints-priority.c
index 1c8c4c7..eaece5f 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -132,8 +132,8 @@ static void bfin_ack_noop(unsigned int irq)
 static void bfin_core_mask_irq(unsigned int irq)
 {
 	bfin_irq_flags &= ~(1 << irq);
-	if (!irqs_disabled_hw())
-		local_irq_enable_hw();
+	if (!hard_irqs_disabled())
+		hard_local_irq_enable();
 }
 
 static void bfin_core_unmask_irq(unsigned int irq)
@@ -148,8 +148,8 @@ static void bfin_core_unmask_irq(unsigned int irq)
 	 * local_irq_enable just does "STI bfin_irq_flags", so it's exactly
 	 * what we need.
 	 */
-	if (!irqs_disabled_hw())
-		local_irq_enable_hw();
+	if (!hard_irqs_disabled())
+		hard_local_irq_enable();
 	return;
 }
 
@@ -158,12 +158,12 @@ static void bfin_internal_mask_irq(unsigned int irq)
 	unsigned long flags;
 
 #ifdef CONFIG_BF53x
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	bfin_write_SIC_IMASK(bfin_read_SIC_IMASK() &
 			     ~(1 << SIC_SYSIRQ(irq)));
 #else
 	unsigned mask_bank, mask_bit;
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	mask_bank = SIC_SYSIRQ(irq) / 32;
 	mask_bit = SIC_SYSIRQ(irq) % 32;
 	bfin_write_SIC_IMASK(mask_bank, bfin_read_SIC_IMASK(mask_bank) &
@@ -173,7 +173,7 @@ static void bfin_internal_mask_irq(unsigned int irq)
 			     ~(1 << mask_bit));
 #endif
 #endif
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 #ifdef CONFIG_SMP
@@ -186,12 +186,12 @@ static void bfin_internal_unmask_irq(unsigned int irq)
 	unsigned long flags;
 
 #ifdef CONFIG_BF53x
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	bfin_write_SIC_IMASK(bfin_read_SIC_IMASK() |
 			     (1 << SIC_SYSIRQ(irq)));
 #else
 	unsigned mask_bank, mask_bit;
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	mask_bank = SIC_SYSIRQ(irq) / 32;
 	mask_bit = SIC_SYSIRQ(irq) % 32;
 #ifdef CONFIG_SMP
@@ -207,7 +207,7 @@ static void bfin_internal_unmask_irq(unsigned int irq)
 			(1 << mask_bit));
 #endif
 #endif
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 #ifdef CONFIG_SMP
@@ -264,7 +264,7 @@ int bfin_internal_set_wake(unsigned int irq, unsigned int state)
 	break;
 	}
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 
 	if (state) {
 		bfin_sic_iwr[bank] |= (1 << bit);
@@ -275,7 +275,7 @@ int bfin_internal_set_wake(unsigned int irq, unsigned int state)
 		vr_wakeup  &= ~wakeup;
 	}
 
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 
 	return 0;
 }
diff --git a/arch/blackfin/mach-common/pm.c b/arch/blackfin/mach-common/pm.c
index 09c1fb4..80884b1 100644
--- a/arch/blackfin/mach-common/pm.c
+++ b/arch/blackfin/mach-common/pm.c
@@ -25,7 +25,7 @@ void bfin_pm_suspend_standby_enter(void)
 {
 	unsigned long flags;
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 	bfin_pm_standby_setup();
 
 #ifdef CONFIG_PM_BFIN_SLEEP_DEEPER
@@ -56,7 +56,7 @@ void bfin_pm_suspend_standby_enter(void)
 	bfin_write_SIC_IWR(IWR_DISABLE_ALL);
 #endif
 
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 }
 
 int bf53x_suspend_l1_mem(unsigned char *memptr)
@@ -149,12 +149,12 @@ int bfin_pm_suspend_mem_enter(void)
 	wakeup |= GPWE;
 #endif
 
-	local_irq_save_hw(flags);
+	flags = hard_local_irq_save();
 
 	ret = blackfin_dma_suspend();
 
 	if (ret) {
-		local_irq_restore_hw(flags);
+		hard_local_irq_restore(flags);
 		kfree(memptr);
 		return ret;
 	}
@@ -178,7 +178,7 @@ int bfin_pm_suspend_mem_enter(void)
 	bfin_gpio_pm_hibernate_restore();
 	blackfin_dma_resume();
 
-	local_irq_restore_hw(flags);
+	hard_local_irq_restore(flags);
 	kfree(memptr);
 
 	return 0;

