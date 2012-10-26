Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab2JZLSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:18:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52716 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab2JZLSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:18:47 -0400
Date: Fri, 26 Oct 2012 04:18:28 -0700
From: tip-bot for Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <tip-4d0e42cc66f4e7e0bf08b29da1ae6ebd60549c4e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, daniel.lezcano@linaro.org
In-Reply-To: <1351181591-8710-1-git-send-email-daniel.lezcano@linaro.org>
References: <1351181591-8710-1-git-send-email-daniel.lezcano@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Remove dead hlt_use_halt code
Git-Commit-ID: 4d0e42cc66f4e7e0bf08b29da1ae6ebd60549c4e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 26 Oct 2012 04:18:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d0e42cc66f4e7e0bf08b29da1ae6ebd60549c4e
Gitweb:     http://git.kernel.org/tip/4d0e42cc66f4e7e0bf08b29da1ae6ebd60549c4e
Author:     Daniel Lezcano <daniel.lezcano@linaro.org>
AuthorDate: Thu, 25 Oct 2012 18:13:11 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 26 Oct 2012 12:25:03 +0200

x86: Remove dead hlt_use_halt code

The hlt_use_halt function returns always true and there is only
one definition of it.

The default_idle function can then get ride of the if ...
statement and we can remove the else branch.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linaro-dev@lists.linaro.org
Cc: patches@linaro.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1351181591-8710-1-git-send-email-daniel.lezcano@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
