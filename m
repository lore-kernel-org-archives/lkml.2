Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab1BBAnG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:43:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:60274 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab1BBAnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028212"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: lenb@kernel.org, linux-pm@lists.linux-foundation.org, x86@kernel.org,
        hpa@linux.intel.com, len.brown@intel.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [1/139] x86, hotplug: Use mwait to offline a processor, fix the legacy case
Message-Id: <20110202004314.B53413E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: H. Peter Anvin <hpa@linux.intel.com>

upstream ea53069231f9317062910d6e772cca4ce93de8c8
x86, hotplug: Use mwait to offline a processor, fix the legacy case

Here included also some small follow-on patches to the same code:

upstream a68e5c94f7d3dd64fef34dd5d97e365cae4bb42a
x86, hotplug: Move WBINVD back outside the play_dead loop

upstream ce5f68246bf2385d6174856708d0b746dc378f20
x86, hotplug: In the MWAIT case of play_dead, CLFLUSH the cache line

https://bugzilla.kernel.org/show_bug.cgi?id=5471

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/processor.h |   23 ----------
 arch/x86/kernel/smpboot.c        |   85 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 84 insertions(+), 24 deletions(-)

Index: linux-2.6.35.y/arch/x86/include/asm/processor.h
===================================================================
--- linux-2.6.35.y.orig/arch/x86/include/asm/processor.h
+++ linux-2.6.35.y/arch/x86/include/asm/processor.h
@@ -763,29 +763,6 @@ extern unsigned long		boot_option_idle_o
 extern unsigned long		idle_halt;
 extern unsigned long		idle_nomwait;
 
-/*
- * on systems with caches, caches must be flashed as the absolute
- * last instruction before going into a suspended halt.  Otherwise,
- * dirty data can linger in the cache and become stale on resume,
- * leading to strange errors.
- *
- * perform a variety of operations to guarantee that the compiler
- * will not reorder instructions.  wbinvd itself is serializing
- * so the processor will not reorder.
- *
- * Systems without cache can just go into halt.
- */
-static inline void wbinvd_halt(void)
-{
-	mb();
-	/* check for clflush to determine if wbinvd is legal */
-	if (cpu_has_clflush)
-		asm volatile("cli; wbinvd; 1: hlt; jmp 1b" : : : "memory");
-	else
-		while (1)
-			halt();
-}
-
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
Index: linux-2.6.35.y/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.35.y.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.35.y/arch/x86/kernel/smpboot.c
@@ -1387,11 +1387,94 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
+#define MWAIT_SUBSTATE_MASK		0xf
+#define MWAIT_SUBSTATE_SIZE		4
+
+#define CPUID_MWAIT_LEAF		5
+#define CPUID5_ECX_EXTENSIONS_SUPPORTED 0x1
+
+/*
+ * We need to flush the caches before going to sleep, lest we have
+ * dirty data in our caches when we come back up.
+ */
+static inline void mwait_play_dead(void)
+{
+	unsigned int eax, ebx, ecx, edx;
+	unsigned int highest_cstate = 0;
+	unsigned int highest_subcstate = 0;
+	int i;
+	void *mwait_ptr;
+
+	if (!cpu_has(&current_cpu_data, X86_FEATURE_MWAIT))
+		return;
+	if (!cpu_has(&current_cpu_data, X86_FEATURE_CLFLSH))
+		return;
+	if (current_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
+		return;
+
+	eax = CPUID_MWAIT_LEAF;
+	ecx = 0;
+	native_cpuid(&eax, &ebx, &ecx, &edx);
+
+	/*
+	 * eax will be 0 if EDX enumeration is not valid.
+	 * Initialized below to cstate, sub_cstate value when EDX is valid.
+	 */
+	if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED)) {
+		eax = 0;
+	} else {
+		edx >>= MWAIT_SUBSTATE_SIZE;
+		for (i = 0; i < 7 && edx; i++, edx >>= MWAIT_SUBSTATE_SIZE) {
+			if (edx & MWAIT_SUBSTATE_MASK) {
+				highest_cstate = i;
+				highest_subcstate = edx & MWAIT_SUBSTATE_MASK;
+			}
+		}
+		eax = (highest_cstate << MWAIT_SUBSTATE_SIZE) |
+			(highest_subcstate - 1);
+	}
+
+	/*
+	 * This should be a memory location in a cache line which is
+	 * unlikely to be touched by other processors.  The actual
+	 * content is immaterial as it is not actually modified in any way.
+	 */
+	mwait_ptr = &current_thread_info()->flags;
+
+	wbinvd();
+
+	while (1) {
+		/*
+		 * The CLFLUSH is a workaround for erratum AAI65 for
+		 * the Xeon 7400 series.  It's not clear it is actually
+		 * needed, but it should be harmless in either case.
+		 * The WBINVD is insufficient due to the spurious-wakeup
+		 * case where we return around the loop.
+		 */
+		clflush(mwait_ptr);
+		__monitor(mwait_ptr, 0, 0);
+		mb();
+		__mwait(eax, 0);
+	}
+}
+
+static inline void hlt_play_dead(void)
+{
+	if (current_cpu_data.x86 >= 4)
+		wbinvd();
+
+	while (1) {
+		native_halt();
+	}
+}
+
 void native_play_dead(void)
 {
 	play_dead_common();
 	tboot_shutdown(TB_SHUTDOWN_WFS);
-	wbinvd_halt();
+
+	mwait_play_dead();	/* Only returns on failure */
+	hlt_play_dead();
 }
 
 #else /* ... !CONFIG_HOTPLUG_CPU */
