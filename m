Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab0IQXrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 19:47:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:48400 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab0IQXrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 19:47:15 -0400
Date: Fri, 17 Sep 2010 23:46:54 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        arjan@linux.intel.com, venkatesh.pallipadi@intel.com,
        a.p.zijlstra@chello.hl, lenb@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, venkatesh.pallipadi@intel.com,
        a.p.zijlstra@chello.hl, lenb@kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, venki@google.com
In-Reply-To: <20090522232230.162239000@intel.com>
References: <20090522232230.162239000@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/idle] x86, hotplug: Use mwait to offline a processor, fix the legacy case
Message-ID: <tip-ea53069231f9317062910d6e772cca4ce93de8c8@git.kernel.org>
Git-Commit-ID: ea53069231f9317062910d6e772cca4ce93de8c8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 17 Sep 2010 23:46:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea53069231f9317062910d6e772cca4ce93de8c8
Gitweb:     http://git.kernel.org/tip/ea53069231f9317062910d6e772cca4ce93de8c8
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 17 Sep 2010 15:39:11 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 17 Sep 2010 15:39:11 -0700

x86, hotplug: Use mwait to offline a processor, fix the legacy case

The code in native_play_dead() has a number of problems:

1. We should use MWAIT when available, to put ourselves into a deeper
   sleep state.
2. We use the existence of CLFLUSH to determine if WBINVD is safe, but
   that is totally bogus -- WBINVD is 486+, whereas CLFLUSH is a much
   later addition.
3. We should do WBINVD inside the loop, just in case of something like
   setting an A bit on page tables.  Pointed out by Arjan van de Ven.

This code is based in part of a previous patch by Venki Pallipadi, but
unlike that patch this one keeps all the detection code local instead
of pre-caching a bunch of information.  We're shutting down the CPU;
there is absolutely no hurry.

This patch moves all the code to C and deletes the global
wbinvd_halt() which is broken anyway.

Originally-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Reviewed-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.hl>
LKML-Reference: <20090522232230.162239000@intel.com>
---
 arch/x86/include/asm/processor.h |   23 --------------
 arch/x86/kernel/smpboot.c        |   63 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 62 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 325b7bd..f358241 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -764,29 +764,6 @@ extern unsigned long		idle_halt;
 extern unsigned long		idle_nomwait;
 extern bool			c1e_detected;
 
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
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8b3bfc4..07bf423 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -62,6 +62,7 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mtrr.h>
+#include <asm/mwait.h>
 #include <asm/vmi.h>
 #include <asm/apic.h>
 #include <asm/setup.h>
@@ -1383,11 +1384,71 @@ void play_dead_common(void)
 	local_irq_disable();
 }
 
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
+
+	if (!cpu_has(&current_cpu_data, X86_FEATURE_MWAIT))
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
+	while (1) {
+		mb();
+		wbinvd();
+		__monitor(&current_thread_info()->flags, 0, 0);
+		mb();
+		__mwait(eax, 0);
+	}
+}
+
+static inline void hlt_play_dead(void)
+{
+	while (1) {
+		mb();
+		if (current_cpu_data.x86 >= 4)
+			wbinvd();
+		mb();
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
