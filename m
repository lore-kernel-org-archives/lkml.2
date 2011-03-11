Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1CKQXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:23:39 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:38489 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752223Ab1CKQXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:23:36 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 5gyCAGsVM1lYD0x8JnVuOH1riAqTKc.OCRmYtk7KQa2__Mc
 mOO8kO0TsPomeG2fICz32YpG8QKpiaO6HZLZhTMwmsKUu9_qU2.JqUc0BFQZ
 k8rVPf0Ze9m7gtu7yEzOWNb5M0w6tf5Z6C6Q30oMACCI03tO59hSoaxeCGWG
 u7o4mlJZBBPldZJpc7HLeTaol33iDfnzDbKrNPxYplEGhDEmDbBAYl0KDLWH
 yjj_Fi0_FXMRmjfmYl4BreYwZTZ_F6MWrCk5kgt5HPlG.qBll3dYoKMGRWYt
 FAAn.84CVzdtk7N1L4ZViouL03uYQ
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110311162333.589915518@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 11 Mar 2011 10:23:11 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [x86 this_cpu_has V1 1/4] x86: A fast way to check capabilities of the current cpu
References: <20110311162310.124405247@linux.com>
Content-Disposition: inline; filename=myfeat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add this_cpu_has() which determines if the current cpu has a certain
ability using a segment prefix and a bit test operation.

For that we need to add bit operations to x86s percpu.h.

Many uses of cpu_has use a pointer passed to a function to determine
the current flags. That is no longer necessary after this patch.

However, this patch only converts the straightforward cases where
cpu_has is used with this_cpu_ptr. The rest is work for later.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/include/asm/cpufeature.h |   13 +++++++++----
 arch/x86/include/asm/percpu.h     |   27 +++++++++++++++++++++++++++
 arch/x86/kernel/apic/apic.c       |    2 +-
 arch/x86/kernel/process.c         |    4 ++--
 arch/x86/kernel/smpboot.c         |    4 ++--
 5 files changed, 41 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/include/asm/cpufeature.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/cpufeature.h	2011-03-11 08:41:12.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/cpufeature.h	2011-03-11 10:18:06.000000000 -0600
@@ -206,8 +206,7 @@ extern const char * const x86_power_flag
 #define test_cpu_cap(c, bit)						\
 	 test_bit(bit, (unsigned long *)((c)->x86_capability))
 
-#define cpu_has(c, bit)							\
-	(__builtin_constant_p(bit) &&					\
+#define REQUIRED_MASK_BIT_SET(bit)					\
 	 ( (((bit)>>5)==0 && (1UL<<((bit)&31) & REQUIRED_MASK0)) ||	\
 	   (((bit)>>5)==1 && (1UL<<((bit)&31) & REQUIRED_MASK1)) ||	\
 	   (((bit)>>5)==2 && (1UL<<((bit)&31) & REQUIRED_MASK2)) ||	\
@@ -217,10 +216,16 @@ extern const char * const x86_power_flag
 	   (((bit)>>5)==6 && (1UL<<((bit)&31) & REQUIRED_MASK6)) ||	\
 	   (((bit)>>5)==7 && (1UL<<((bit)&31) & REQUIRED_MASK7)) ||	\
 	   (((bit)>>5)==8 && (1UL<<((bit)&31) & REQUIRED_MASK8)) ||	\
-	   (((bit)>>5)==9 && (1UL<<((bit)&31) & REQUIRED_MASK9)) )	\
-	  ? 1 :								\
+	   (((bit)>>5)==9 && (1UL<<((bit)&31) & REQUIRED_MASK9)) )
+
+#define cpu_has(c, bit)							\
+	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
 	 test_cpu_cap(c, bit))
 
+#define this_cpu_has(bit)						\
+	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 : 	\
+	 x86_this_cpu_test_bit(bit, (unsigned long *)&cpu_info.x86_capability))
+
 #define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)
 
 #define set_cpu_cap(c, bit)	set_bit(bit, (unsigned long *)((c)->x86_capability))
Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c	2011-03-11 08:41:12.000000000 -0600
+++ linux-2.6/arch/x86/kernel/apic/apic.c	2011-03-11 09:29:46.000000000 -0600
@@ -516,7 +516,7 @@ static void __cpuinit setup_APIC_timer(v
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 
-	if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_ARAT)) {
+	if (this_cpu_has(X86_FEATURE_ARAT)) {
 		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_C3STOP;
 		/* Make LAPIC timer preferrable over percpu HPET */
 		lapic_clockevent.rating = 150;
Index: linux-2.6/arch/x86/include/asm/percpu.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2011-03-11 08:41:12.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2011-03-11 10:18:06.000000000 -0600
@@ -492,6 +492,33 @@ do {									\
 	old__;								\
 })
 
+static __always_inline int x86_this_cpu_constant_test_bit(unsigned int nr,
+                        const unsigned long __percpu *addr)
+{
+	unsigned long __percpu *a = (unsigned long *)addr + nr / BITS_PER_LONG;
+
+	return ((1UL << (nr % BITS_PER_LONG)) & percpu_read(*a)) != 0;
+}
+
+static inline int x86_this_cpu_variable_test_bit(int nr,
+                        const unsigned long __percpu *addr)
+{
+	int oldbit;
+
+	asm volatile("bt "__percpu_arg(2)",%1\n\t"
+			"sbb %0,%0"
+			: "=r" (oldbit)
+			: "m" (*(unsigned long *)addr), "Ir" (nr));
+
+	return oldbit;
+}
+
+#define x86_this_cpu_test_bit(nr, addr)			\
+	(__builtin_constant_p((nr))			\
+	 ? x86_this_cpu_constant_test_bit((nr), (addr))	\
+	 : x86_this_cpu_variable_test_bit((nr), (addr)))
+
+
 #include <asm-generic/percpu.h>
 
 /* We can use this directly for local CPU (faster). */
Index: linux-2.6/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process.c	2011-03-11 08:41:12.000000000 -0600
+++ linux-2.6/arch/x86/kernel/process.c	2011-03-11 09:29:46.000000000 -0600
@@ -452,7 +452,7 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
 	if (!need_resched()) {
-		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
@@ -468,7 +468,7 @@ static void mwait_idle(void)
 	if (!need_resched()) {
 		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
 		trace_cpu_idle(1, smp_processor_id());
-		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c	2011-03-11 08:41:12.000000000 -0600
+++ linux-2.6/arch/x86/kernel/smpboot.c	2011-03-11 09:29:46.000000000 -0600
@@ -1404,9 +1404,9 @@ static inline void mwait_play_dead(void)
 	void *mwait_ptr;
 	struct cpuinfo_x86 *c = __this_cpu_ptr(&cpu_info);
 
-	if (!(cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)))
+	if (!this_cpu_has(X86_FEATURE_MWAIT) && mwait_usable(c))
 		return;
-	if (!cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLSH))
+	if (!this_cpu_has(X86_FEATURE_CLFLSH))
 		return;
 	if (__this_cpu_read(cpu_info.cpuid_level) < CPUID_MWAIT_LEAF)
 		return;

