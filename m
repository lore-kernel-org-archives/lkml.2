Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab0LOUHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:07:45 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:37130 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755257Ab0LOUHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:07:44 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: FKL1am4VM1m00g2x0cv0S0JVfKadWBGJ5HJGFw5Jn3dCtHY
 6VSLsZYlg4IdobUxFDQ8A1V9WWbJZgnyNNDC35l7N6bcmKHeuK5uXwy7Cvm_
 7lm2HB7K8QRxSqY7a52x6tvVGZ7S51JIslyBPXGP20E7THjxw7FI1l2KzmBC
 3V5SISLAFzuipHNq45xYQOHPox1RQ_rxPbu6I60YftLDlxSxJITKUa9GNkjh
 wKw8kBThz4FoMGtt.NAA7PttinmfVtAnHBYLYuC8K0aaclWoAU9f55StVU6q
 ALoV95T38K4GduxB0CgBtfQWYuvWtJ_Q6gJLneP.lZzPv26g-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 15 Dec 2010 14:07:39 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Tejun Heo <tj@kernel.org>, Pekka Enbeerg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        akpm@linux-foundation.org
Subject: x86: A fast way to check capabilities of the current cpu
Message-ID: <alpine.DEB.2.00.1012151404070.21102@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: x86: A fast way to check capabilities of the current cpu

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
--- linux-2.6.orig/arch/x86/include/asm/cpufeature.h	2010-12-15 12:38:52.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/cpufeature.h	2010-12-15 12:54:48.000000000 -0600
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
+	 this_cpu_test_bit(bit, (unsigned long *)&cpu_info.x86_capability))
+
 #define boot_cpu_has(bit)	cpu_has(&boot_cpu_data, bit)

 #define set_cpu_cap(c, bit)	set_bit(bit, (unsigned long *)((c)->x86_capability))
Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c	2010-12-15 12:38:52.000000000 -0600
+++ linux-2.6/arch/x86/kernel/apic/apic.c	2010-12-15 12:38:53.000000000 -0600
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
--- linux-2.6.orig/arch/x86/include/asm/percpu.h	2010-12-15 12:38:52.000000000 -0600
+++ linux-2.6/arch/x86/include/asm/percpu.h	2010-12-15 13:06:27.000000000 -0600
@@ -545,6 +545,33 @@ do {									\
 	old__;								\
 })

+static __always_inline int this_cpu_constant_test_bit(unsigned int nr,
+                        const unsigned long __percpu *addr)
+{
+	unsigned long __percpu *a = (unsigned long *)addr + nr / BITS_PER_LONG;
+
+	return ((1UL << (nr % BITS_PER_LONG)) & percpu_read_stable(*a)) != 0;
+}
+
+static inline int this_cpu_variable_test_bit(int nr,
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
+#define this_cpu_test_bit(nr, addr)			\
+	(__builtin_constant_p((nr))			\
+	 ? this_cpu_constant_test_bit((nr), (addr))	\
+	 : this_cpu_variable_test_bit((nr), (addr)))
+
+
 #include <asm-generic/percpu.h>

 /* We can use this directly for local CPU (faster). */
Index: linux-2.6/arch/x86/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/process.c	2010-12-15 12:38:52.000000000 -0600
+++ linux-2.6/arch/x86/kernel/process.c	2010-12-15 12:38:53.000000000 -0600
@@ -445,7 +445,7 @@ void mwait_idle_with_hints(unsigned long
 {
 	trace_power_start(POWER_CSTATE, (ax>>4)+1, smp_processor_id());
 	if (!need_resched()) {
-		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);

 		__monitor((void *)&current_thread_info()->flags, 0, 0);
@@ -460,7 +460,7 @@ static void mwait_idle(void)
 {
 	if (!need_resched()) {
 		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
-		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);

 		__monitor((void *)&current_thread_info()->flags, 0, 0);
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c	2010-12-15 12:38:52.000000000 -0600
+++ linux-2.6/arch/x86/kernel/smpboot.c	2010-12-15 12:38:53.000000000 -0600
@@ -1397,9 +1397,9 @@ static inline void mwait_play_dead(void)
 	int i;
 	void *mwait_ptr;

-	if (!cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_MWAIT))
+	if (!this_cpu_has(X86_FEATURE_MWAIT))
 		return;
-	if (!cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLSH))
+	if (!this_cpu_has(X86_FEATURE_CLFLSH))
 		return;
 	if (__this_cpu_read(cpu_info.cpuid_level) < CPUID_MWAIT_LEAF)
 		return;
