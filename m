Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab1CLLuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 06:50:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61493 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab1CLLuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 06:50:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Xucj9J5lnizLiLYxNcfJhjXEolJ5fCrIa8ZjESZYd7tMYGWYvhtKZHyobC/RbZGLlT
         cs/fWToX+b6KY0MuIxApnntoJNRBQTPGVHnv7jUWS65+LHWMdReuvinVSD8gkm8QuVam
         YOcjj/0OXy0s4eD+ikK65DYvrp63KfFb7S/Gg=
Date: Sat, 12 Mar 2011 12:50:10 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH tip:x86/mm 1/3] x86: A fast way to check capabilities of
 the current cpu
Message-ID: <20110312115010.GC2005@htj.dyndns.org>
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

-tj: Rolled up patch to add x86_ prefix and use percpu_read() instead
     of percpu_read_stable().

Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
Ingo, can you please route these three patches?  These patches are
somewhere inbetween percpu and x86 but fit x86 better.  I generated
them on top of tip:x86/mm but if you want it based on something else,
just let me know.  If you want these to be routed through x86/mm, I
can apply it there and send pull request too.

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
@@ -525,7 +525,7 @@ static void __cpuinit setup_APIC_timer(v
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
@@ -442,7 +442,7 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
 	if (!need_resched()) {
-		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
@@ -458,7 +458,7 @@ static void mwait_idle(void)
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
@@ -1339,9 +1339,9 @@ static inline void mwait_play_dead(void)
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
