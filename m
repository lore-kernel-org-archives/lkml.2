Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab1KCCQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:16:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932672Ab1KCBeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:34:15 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:14:51 2011
Message-Id: <20111102221450.994844373@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:13:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jonathan Nieder <jrnieder@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [010/107] Revert "x86, hotplug: Use mwait to offline a processor, fix the legacy case"
In-Reply-To: <20111102221600.GA26650@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

This reverts commit 226917b0735f31cf5c704e07fdd590d99bbfae58 (upstream
ea53069231f9317062910d6e772cca4ce93de8c8 and
a68e5c94f7d3dd64fef34dd5d97e365cae4bb42a and
ce5f68246bf2385d6174856708d0b746dc378f20 all mushed together) as
Jonathan Nieder reports that this causes a regression on some hardware.

More details can be found at http://bugs.debian.org/622259

Cc: Jonathan Nieder <jrnieder@gmail.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/include/asm/processor.h |   23 ++++++++++
 arch/x86/kernel/smpboot.c        |   85 +-------------------------------------
 2 files changed, 24 insertions(+), 84 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index da35a70..fa04dea 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -765,6 +765,29 @@ extern unsigned long		boot_option_idle_override;
 extern unsigned long		idle_halt;
 extern unsigned long		idle_nomwait;
 
+/*
+ * on systems with caches, caches must be flashed as the absolute
+ * last instruction before going into a suspended halt.  Otherwise,
+ * dirty data can linger in the cache and become stale on resume,
+ * leading to strange errors.
+ *
+ * perform a variety of operations to guarantee that the compiler
+ * will not reorder instructions.  wbinvd itself is serializing
+ * so the processor will not reorder.
+ *
+ * Systems without cache can just go into halt.
+ */
+static inline void wbinvd_halt(void)
+{
+	mb();
+	/* check for clflush to determine if wbinvd is legal */
+	if (cpu_has_clflush)
+		asm volatile("cli; wbinvd; 1: hlt; jmp 1b" : : : "memory");
+	else
+		while (1)
+			halt();
+}
+
 extern void enable_sep_cpu(void);
 extern int sysenter_setup(void);
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 539bb6c..7e8e905 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1338,94 +1338,11 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
-#define MWAIT_SUBSTATE_MASK		0xf
-#define MWAIT_SUBSTATE_SIZE		4
-
-#define CPUID_MWAIT_LEAF		5
-#define CPUID5_ECX_EXTENSIONS_SUPPORTED 0x1
-
-/*
- * We need to flush the caches before going to sleep, lest we have
- * dirty data in our caches when we come back up.
- */
-static inline void mwait_play_dead(void)
-{
-	unsigned int eax, ebx, ecx, edx;
-	unsigned int highest_cstate = 0;
-	unsigned int highest_subcstate = 0;
-	int i;
-	void *mwait_ptr;
-
-	if (!cpu_has(&current_cpu_data, X86_FEATURE_MWAIT))
-		return;
-	if (!cpu_has(&current_cpu_data, X86_FEATURE_CLFLSH))
-		return;
-	if (current_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
-		return;
-
-	eax = CPUID_MWAIT_LEAF;
-	ecx = 0;
-	native_cpuid(&eax, &ebx, &ecx, &edx);
-
-	/*
-	 * eax will be 0 if EDX enumeration is not valid.
-	 * Initialized below to cstate, sub_cstate value when EDX is valid.
-	 */
-	if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED)) {
-		eax = 0;
-	} else {
-		edx >>= MWAIT_SUBSTATE_SIZE;
-		for (i = 0; i < 7 && edx; i++, edx >>= MWAIT_SUBSTATE_SIZE) {
-			if (edx & MWAIT_SUBSTATE_MASK) {
-				highest_cstate = i;
-				highest_subcstate = edx & MWAIT_SUBSTATE_MASK;
-			}
-		}
-		eax = (highest_cstate << MWAIT_SUBSTATE_SIZE) |
-			(highest_subcstate - 1);
-	}
-
-	/*
-	 * This should be a memory location in a cache line which is
-	 * unlikely to be touched by other processors.  The actual
-	 * content is immaterial as it is not actually modified in any way.
-	 */
-	mwait_ptr = &current_thread_info()->flags;
-
-	wbinvd();
-
-	while (1) {
-		/*
-		 * The CLFLUSH is a workaround for erratum AAI65 for
-		 * the Xeon 7400 series.  It's not clear it is actually
-		 * needed, but it should be harmless in either case.
-		 * The WBINVD is insufficient due to the spurious-wakeup
-		 * case where we return around the loop.
-		 */
-		clflush(mwait_ptr);
-		__monitor(mwait_ptr, 0, 0);
-		mb();
-		__mwait(eax, 0);
-	}
-}
-
-static inline void hlt_play_dead(void)
-{
-	if (current_cpu_data.x86 >= 4)
-		wbinvd();
-
-	while (1) {
-		native_halt();
-	}
-}
-
 void native_play_dead(void)
 {
 	play_dead_common();
 	tboot_shutdown(TB_SHUTDOWN_WFS);
-
-	mwait_play_dead();	/* Only returns on failure */
-	hlt_play_dead();
+	wbinvd_halt();
 }
 
 #else /* ... !CONFIG_HOTPLUG_CPU */
-- 
1.7.6.1



