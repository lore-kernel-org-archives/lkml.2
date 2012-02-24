Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab2BXWeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:34:10 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45740 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab2BXWeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:34:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of venki@google.com designates 10.68.129.73 as permitted sender) smtp.mail=venki@google.com; dkim=pass header.i=venki@google.com
MIME-Version: 1.0
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 3/4] x86: Extend IPIless wake to C1_mwait and poll_idle
Date: Fri, 24 Feb 2012 14:33:19 -0800
Message-Id: <1330122800-834-4-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1330122800-834-1-git-send-email-venki@google.com>
References: <1330122800-834-1-git-send-email-venki@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

poll_idle(), mwait_idle() [which is used for C1 mwait] and any other
polling based idle loops can also use the IPIless wakeup logic added
with mwait_idle_with_hints() in the earlier patch.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
---
 arch/x86/kernel/process.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 99a8109..43bb0a5 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -22,6 +22,7 @@
 #include <asm/uaccess.h>
 #include <asm/i387.h>
 #include <asm/debugreg.h>
+#include <asm/ipiless_wake.h>
 
 struct kmem_cache *task_xstate_cachep;
 EXPORT_SYMBOL_GPL(task_xstate_cachep);
@@ -445,7 +446,8 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
 /* Default MONITOR/MWAIT with no hints, used for default C1 state */
 static void mwait_idle(void)
 {
-	if (!need_resched()) {
+	enter_ipiless_idle();
+	if (!is_ipiless_wakeup_pending()) {
 		trace_power_start(POWER_CSTATE, 1, smp_processor_id());
 		trace_cpu_idle(1, smp_processor_id());
 		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
@@ -453,7 +455,7 @@ static void mwait_idle(void)
 
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
-		if (!need_resched())
+		if (!is_ipiless_wakeup_pending())
 			__sti_mwait(0, 0);
 		else
 			local_irq_enable();
@@ -461,6 +463,7 @@ static void mwait_idle(void)
 		trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
 	} else
 		local_irq_enable();
+	exit_ipiless_idle();
 }
 
 /*
@@ -470,13 +473,15 @@ static void mwait_idle(void)
  */
 static void poll_idle(void)
 {
+	enter_ipiless_idle();
 	trace_power_start(POWER_CSTATE, 0, smp_processor_id());
 	trace_cpu_idle(0, smp_processor_id());
 	local_irq_enable();
-	while (!need_resched())
+	while (!is_ipiless_wakeup_pending())
 		cpu_relax();
 	trace_power_end(smp_processor_id());
 	trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
+	exit_ipiless_idle();
 }
 
 /*
-- 
1.7.7.3

