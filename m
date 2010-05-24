Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab0EXXOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:14:49 -0400
Received: from kroah.org ([198.145.64.141]:36414 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758968Ab0EXXJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:09:23 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 16:03:50 2010
Message-Id: <20100524230350.326578430@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 15:59:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [11/34] powerpc/perf_event: Fix oops due to perf_event_do_pending call
In-Reply-To: <20100524230418.GA12770@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paul Mackerras <paulus@samba.org>

commit 0fe1ac48bef018bed896307cd12f6ca9b5e704ab upstream.

Anton Blanchard found that large POWER systems would occasionally
crash in the exception exit path when profiling with perf_events.
The symptom was that an interrupt would occur late in the exit path
when the MSR[RI] (recoverable interrupt) bit was clear.  Interrupts
should be hard-disabled at this point but they were enabled.  Because
the interrupt was not recoverable the system panicked.

The reason is that the exception exit path was calling
perf_event_do_pending after hard-disabling interrupts, and
perf_event_do_pending will re-enable interrupts.

The simplest and cleanest fix for this is to use the same mechanism
that 32-bit powerpc does, namely to cause a self-IPI by setting the
decrementer to 1.  This means we can remove the tests in the exception
exit path and raw_local_irq_restore.

This also makes sure that the call to perf_event_do_pending from
timer_interrupt() happens within irq_enter/irq_exit.  (Note that
calling perf_event_do_pending from timer_interrupt does not mean that
there is a possible 1/HZ latency; setting the decrementer to 1 ensures
that the timer interrupt will happen immediately, i.e. within one
timebase tick, which is a few nanoseconds or 10s of nanoseconds.)

Signed-off-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/include/asm/hw_irq.h |   38 ------------------------
 arch/powerpc/kernel/asm-offsets.c |    1 
 arch/powerpc/kernel/entry_64.S    |    9 -----
 arch/powerpc/kernel/irq.c         |    6 ---
 arch/powerpc/kernel/time.c        |   60 ++++++++++++++++++++++++++++++--------
 5 files changed, 48 insertions(+), 66 deletions(-)

--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -135,43 +135,5 @@ static inline int irqs_disabled_flags(un
  */
 struct irq_chip;
 
-#ifdef CONFIG_PERF_EVENTS
-
-#ifdef CONFIG_PPC64
-static inline unsigned long test_perf_event_pending(void)
-{
-	unsigned long x;
-
-	asm volatile("lbz %0,%1(13)"
-		: "=r" (x)
-		: "i" (offsetof(struct paca_struct, perf_event_pending)));
-	return x;
-}
-
-static inline void set_perf_event_pending(void)
-{
-	asm volatile("stb %0,%1(13)" : :
-		"r" (1),
-		"i" (offsetof(struct paca_struct, perf_event_pending)));
-}
-
-static inline void clear_perf_event_pending(void)
-{
-	asm volatile("stb %0,%1(13)" : :
-		"r" (0),
-		"i" (offsetof(struct paca_struct, perf_event_pending)));
-}
-#endif /* CONFIG_PPC64 */
-
-#else  /* CONFIG_PERF_EVENTS */
-
-static inline unsigned long test_perf_event_pending(void)
-{
-	return 0;
-}
-
-static inline void clear_perf_event_pending(void) {}
-#endif /* CONFIG_PERF_EVENTS */
-
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_HW_IRQ_H */
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -133,7 +133,6 @@ int main(void)
 	DEFINE(PACAKMSR, offsetof(struct paca_struct, kernel_msr));
 	DEFINE(PACASOFTIRQEN, offsetof(struct paca_struct, soft_enabled));
 	DEFINE(PACAHARDIRQEN, offsetof(struct paca_struct, hard_enabled));
-	DEFINE(PACAPERFPEND, offsetof(struct paca_struct, perf_event_pending));
 	DEFINE(PACACONTEXTID, offsetof(struct paca_struct, context.id));
 #ifdef CONFIG_PPC_MM_SLICES
 	DEFINE(PACALOWSLICESPSIZE, offsetof(struct paca_struct,
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -556,15 +556,6 @@ ALT_FW_FTR_SECTION_END_IFCLR(FW_FEATURE_
 2:
 	TRACE_AND_RESTORE_IRQ(r5);
 
-#ifdef CONFIG_PERF_EVENTS
-	/* check paca->perf_event_pending if we're enabling ints */
-	lbz	r3,PACAPERFPEND(r13)
-	and.	r3,r3,r5
-	beq	27f
-	bl	.perf_event_do_pending
-27:
-#endif /* CONFIG_PERF_EVENTS */
-
 	/* extract EE bit and use it to restore paca->hard_enabled */
 	ld	r3,_MSR(r1)
 	rldicl	r4,r3,49,63		/* r0 = (r3 >> 15) & 1 */
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -53,7 +53,6 @@
 #include <linux/bootmem.h>
 #include <linux/pci.h>
 #include <linux/debugfs.h>
-#include <linux/perf_event.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -138,11 +137,6 @@ notrace void raw_local_irq_restore(unsig
 	}
 #endif /* CONFIG_PPC_STD_MMU_64 */
 
-	if (test_perf_event_pending()) {
-		clear_perf_event_pending();
-		perf_event_do_pending();
-	}
-
 	/*
 	 * if (get_paca()->hard_enabled) return;
 	 * But again we need to take care that gcc gets hard_enabled directly
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -530,25 +530,60 @@ void __init iSeries_time_init_early(void
 }
 #endif /* CONFIG_PPC_ISERIES */
 
-#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_PPC32)
-DEFINE_PER_CPU(u8, perf_event_pending);
+#ifdef CONFIG_PERF_EVENTS
 
-void set_perf_event_pending(void)
+/*
+ * 64-bit uses a byte in the PACA, 32-bit uses a per-cpu variable...
+ */
+#ifdef CONFIG_PPC64
+static inline unsigned long test_perf_event_pending(void)
 {
-	get_cpu_var(perf_event_pending) = 1;
-	set_dec(1);
-	put_cpu_var(perf_event_pending);
+	unsigned long x;
+
+	asm volatile("lbz %0,%1(13)"
+		: "=r" (x)
+		: "i" (offsetof(struct paca_struct, perf_event_pending)));
+	return x;
 }
 
+static inline void set_perf_event_pending_flag(void)
+{
+	asm volatile("stb %0,%1(13)" : :
+		"r" (1),
+		"i" (offsetof(struct paca_struct, perf_event_pending)));
+}
+
+static inline void clear_perf_event_pending(void)
+{
+	asm volatile("stb %0,%1(13)" : :
+		"r" (0),
+		"i" (offsetof(struct paca_struct, perf_event_pending)));
+}
+
+#else /* 32-bit */
+
+DEFINE_PER_CPU(u8, perf_event_pending);
+
+#define set_perf_event_pending_flag()	__get_cpu_var(perf_event_pending) = 1
 #define test_perf_event_pending()	__get_cpu_var(perf_event_pending)
 #define clear_perf_event_pending()	__get_cpu_var(perf_event_pending) = 0
 
-#else  /* CONFIG_PERF_EVENTS && CONFIG_PPC32 */
+#endif /* 32 vs 64 bit */
+
+void set_perf_event_pending(void)
+{
+	preempt_disable();
+	set_perf_event_pending_flag();
+	set_dec(1);
+	preempt_enable();
+}
+
+#else  /* CONFIG_PERF_EVENTS */
 
 #define test_perf_event_pending()	0
 #define clear_perf_event_pending()
 
-#endif /* CONFIG_PERF_EVENTS && CONFIG_PPC32 */
+#endif /* CONFIG_PERF_EVENTS */
 
 /*
  * For iSeries shared processors, we have to let the hypervisor
@@ -576,10 +611,6 @@ void timer_interrupt(struct pt_regs * re
 	set_dec(DECREMENTER_MAX);
 
 #ifdef CONFIG_PPC32
-	if (test_perf_event_pending()) {
-		clear_perf_event_pending();
-		perf_event_do_pending();
-	}
 	if (atomic_read(&ppc_n_lost_interrupts) != 0)
 		do_IRQ(regs);
 #endif
@@ -597,6 +628,11 @@ void timer_interrupt(struct pt_regs * re
 
 	calculate_steal_time();
 
+	if (test_perf_event_pending()) {
+		clear_perf_event_pending();
+		perf_event_do_pending();
+	}
+
 #ifdef CONFIG_PPC_ISERIES
 	if (firmware_has_feature(FW_FEATURE_ISERIES))
 		get_lppaca()->int_dword.fields.decr_int = 0;


