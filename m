Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab1DBHCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 03:02:37 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:59186 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab1DBHB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 03:01:59 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        x86@kernel.org
Subject: [PATCH 10/18] x86 idle: move mwait_idle_with_hints() to where it is
 used
Date: Sat, 02 Apr 2011 02:22:52 -0400
Message-id: <68855c4b4018577c781c464e2598aba0bae957eb.1301724243.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.5.rc0
In-reply-to: <1301725380-10579-1-git-send-email-lenb@kernel.org>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
 <1301725380-10579-1-git-send-email-lenb@kernel.org>
In-reply-to: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
References: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

...and make it static

no functional change

cc: x86@kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/processor.h |    2 --
 arch/x86/kernel/acpi/cstate.c    |   24 ++++++++++++++++++++++++
 arch/x86/kernel/process.c        |   23 -----------------------
 3 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index a8c5fed..fd02787 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -755,8 +755,6 @@ static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 		     :: "a" (eax), "c" (ecx));
 }
 
-extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
-
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
 extern void init_amd_e400_mask(void);
 
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index 5812404..c49281e 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -149,6 +149,30 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
 }
 EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
 
+/*
+ * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
+ * which can obviate IPI to trigger checking of need_resched.
+ * We execute MONITOR against need_resched and enter optimized wait state
+ * through MWAIT. Whenever someone changes need_resched, we would be woken
+ * up from MWAIT (without an IPI).
+ *
+ * New with Core Duo processors, MWAIT can take some hints based on CPU
+ * capability.
+ */
+static void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
+{
+	if (!need_resched()) {
+		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
+
+		__monitor((void *)&current_thread_info()->flags, 0, 0);
+		smp_mb();
+		if (!need_resched())
+			__mwait(ax, cx);
+	}
+}
+
+
 void acpi_processor_ffh_cstate_enter(struct acpi_processor_cx *cx)
 {
 	unsigned int cpu = smp_processor_id();
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1c45a9c..579c78f 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -441,29 +441,6 @@ void cpu_idle_wait(void)
 }
 EXPORT_SYMBOL_GPL(cpu_idle_wait);
 
-/*
- * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
- * which can obviate IPI to trigger checking of need_resched.
- * We execute MONITOR against need_resched and enter optimized wait state
- * through MWAIT. Whenever someone changes need_resched, we would be woken
- * up from MWAIT (without an IPI).
- *
- * New with Core Duo processors, MWAIT can take some hints based on CPU
- * capability.
- */
-void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
-{
-	if (!need_resched()) {
-		if (cpu_has(__this_cpu_ptr(&cpu_info), X86_FEATURE_CLFLUSH_MONITOR))
-			clflush((void *)&current_thread_info()->flags);
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
-		if (!need_resched())
-			__mwait(ax, cx);
-	}
-}
-
 /* Default MONITOR/MWAIT with no hints, used for default C1 state */
 static void mwait_idle(void)
 {
-- 
1.7.5.rc0

