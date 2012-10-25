Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935808Ab2JYQN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:13:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62330 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227Ab2JYQNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:13:24 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86 : remove dead code
Date: Thu, 25 Oct 2012 18:13:11 +0200
Message-Id: <1351181591-8710-1-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hlt_use_halt function returns always true and there is only
one definition of it.

The default_idle function can then get ride of the if ... statement and
we can remove the else branch.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/x86/kernel/process.c |   39 ++++++++++++++-------------------------
 1 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index b644e1c..2f99e31 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -306,11 +306,6 @@ void (*pm_idle)(void);
 EXPORT_SYMBOL(pm_idle);
 #endif
 
-static inline int hlt_use_halt(void)
-{
-	return 1;
-}
-
 #ifndef CONFIG_SMP
 static inline void play_dead(void)
 {
@@ -410,28 +405,22 @@ void cpu_idle(void)
  */
 void default_idle(void)
 {
-	if (hlt_use_halt()) {
-		trace_power_start_rcuidle(POWER_CSTATE, 1, smp_processor_id());
-		trace_cpu_idle_rcuidle(1, smp_processor_id());
-		current_thread_info()->status &= ~TS_POLLING;
-		/*
-		 * TS_POLLING-cleared state must be visible before we
-		 * test NEED_RESCHED:
-		 */
-		smp_mb();
+	trace_power_start_rcuidle(POWER_CSTATE, 1, smp_processor_id());
+	trace_cpu_idle_rcuidle(1, smp_processor_id());
+	current_thread_info()->status &= ~TS_POLLING;
+	/*
+	 * TS_POLLING-cleared state must be visible before we
+	 * test NEED_RESCHED:
+	 */
+	smp_mb();
 
-		if (!need_resched())
-			safe_halt();	/* enables interrupts racelessly */
-		else
-			local_irq_enable();
-		current_thread_info()->status |= TS_POLLING;
-		trace_power_end_rcuidle(smp_processor_id());
-		trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
-	} else {
+	if (!need_resched())
+		safe_halt();	/* enables interrupts racelessly */
+	else
 		local_irq_enable();
-		/* loop is done by the caller */
-		cpu_relax();
-	}
+	current_thread_info()->status |= TS_POLLING;
+	trace_power_end_rcuidle(smp_processor_id());
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
 }
 #ifdef CONFIG_APM_MODULE
 EXPORT_SYMBOL(default_idle);
-- 
1.7.5.4

