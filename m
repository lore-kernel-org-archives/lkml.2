Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932894Ab1CaGEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:04:25 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:44960 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab1CaGDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:03:52 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 8/9] x86 idle: move mwait_idle_with_hints() to where it is used
Date: Thu, 31 Mar 2011 02:03:23 -0400
Message-id: <4d2078e66b3a1ccde091c952449bcd780fe53de4.1301550524.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.4.2.406.gbe91
In-reply-to: <1301551404-8263-1-git-send-email-lenb@kernel.org>
References: <1300950508-22746-1-git-send-email-lenb@kernel.org>
 <1301551404-8263-1-git-send-email-lenb@kernel.org>
In-reply-to: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1301550524.git.len.brown@intel.com>
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1301550524.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

no functional change

Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/processor.h |    2 --
 arch/x86/kernel/acpi/cstate.c    |   24 ++++++++++++++++++++++++
 arch/x86/kernel/process.c        |   23 -----------------------
 3 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 8776232..3b288ca 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -745,8 +745,6 @@ static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 		     :: "a" (eax), "c" (ecx));
 }
 
-extern void mwait_idle_with_hints(unsigned long eax, unsigned long ecx);
-
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
 extern void init_c1e_mask(void);
 
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
index 9d485d9..9f08e7b 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -399,29 +399,6 @@ void cpu_idle_wait(void)
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
1.7.4.2.406.gbe91

