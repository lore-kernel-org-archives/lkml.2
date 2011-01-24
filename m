Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab1AXRYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:24:06 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48561 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab1AXRYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:24:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=v1sW7D5aSHgMPXXb+4lV1frGMmhwutNXKUaeqqrz04374590M2uJIHq5PIy4zDrHmt
         /NNThs0FjN2+oXUCLC/T5SVB6BanpruNs4hNvke+xg7Lm8K8jAC1k1gf0x8edSi4m8XH
         VURl2TNTo2GTSt16H0qoF+89lF9fJI3m93DAY=
Date: Mon, 24 Jan 2011 18:23:57 +0100
From: Tejun Heo <tj@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: cl@linux.com, Pekka Enbeerg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org
Subject: [PATCH 1/3] x86: A fast way to check capabilities of the current
 cpu
Message-ID: <20110124172357.GI27510@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux.com>

Add this_cpu_has() which determines if the current cpu has a certain
ability using a segment prefix and a bit test operation.

For that we need to add bit operations to x86s percpu.h.

Many uses of cpu_has use a pointer passed to a function to determine
the current flags. That is no longer necessary after this patch.

However, this patch only converts the straightforward cases where
cpu_has is used with this_cpu_ptr. The rest is work for later.

tj: rolled up patch to add x86_ prefix and use percpu_read() instead
    of percpu_read_stable().

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
hpa, I think it's better to route these three patches through x86 tree
rather than percpu.  Can you please take these?

Thanks.

 arch/x86/include/asm/cpufeature.h |   13 +++++++++----
 arch/x86/include/asm/percpu.h     |   27 +++++++++++++++++++++++++++
 arch/x86/kernel/apic/apic.c       |    2 +-
 arch/x86/kernel/process.c         |    4 ++--
 arch/x86/kernel/smpboot.c         |    4 ++--
 5 files changed, 41 insertions(+), 9 deletions(-)

Index: work/arch/x86/include/asm/cpufeature.h
===================================================================
--- work.orig/arch/x86/include/asm/cpufeature.h
+++ work/arch/x86/include/asm/cpufeature.h
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
Index: work/arch/x86/kernel/apic/apic.c
===================================================================
--- work.orig/arch/x86/kernel/apic/apic.c
+++ work/arch/x86/kernel/apic/apic.c
@@ -516,7 +516,7 @@ static void __cpuinit setup_APIC_timer(v
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 
-	if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_ARAT)) {
+	if (this_cpu_has(X86_FEATURE_ARAT)) {
 		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_C3STOP;
 		/* Make LAPIC timer preferrable over percpu HPET */
 		lapic_clockevent.rating = 150;
Index: work/arch/x86/include/asm/percpu.h
===================================================================
--- work.orig/arch/x86/include/asm/percpu.h
+++ work/arch/x86/include/asm/percpu.h
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
Index: work/arch/x86/kernel/process.c
===================================================================
--- work.orig/arch/x86/kernel/process.c
+++ work/arch/x86/kernel/process.c
@@ -441,7 +441,7 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
 	if (!need_resched()) {
-		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
@@ -457,7 +457,7 @@ static void mwait_idle(void)
 	if (!need_resched()) {
 		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
 		trace_cpu_idle(1, smp_processor_id());
-		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
Index: work/arch/x86/kernel/smpboot.c
===================================================================
--- work.orig/arch/x86/kernel/smpboot.c
+++ work/arch/x86/kernel/smpboot.c
@@ -1403,9 +1403,9 @@ static inline void mwait_play_dead(void)
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
