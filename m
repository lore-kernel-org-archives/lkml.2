Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab0HIFN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 01:13:58 -0400
Received: from mail.windriver.com ([147.11.1.11]:39290 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab0HIFN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 01:13:57 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [RFC PATCH 1/2] debug_core: move all watch dog syncs to a single function
Date: Mon,  9 Aug 2010 00:12:11 -0500
Message-Id: <1281330732-17164-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281330732-17164-1-git-send-email-jason.wessel@windriver.com>
References: <1281330732-17164-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 09 Aug 2010 05:12:48.0725 (UTC) FILETIME=[82572850:01CB3781]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the various clock and watch dog syncs to a single function in
advance of adding another sync for the rcu stall detector.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 3c2d497..e4d6819 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -470,6 +470,12 @@ static void dbg_cpu_switch(int cpu, int next_cpu)
 	kgdb_info[next_cpu].exception_state |= DCPU_NEXT_MASTER;
 }
 
+static void dbg_touch_watchdogs(void)
+{
+	touch_softlockup_watchdog_sync();
+	clocksource_touch_watchdog();
+}
+
 static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs)
 {
 	unsigned long flags;
@@ -523,8 +529,7 @@ return_normal:
 			if (trace_on)
 				tracing_on();
 			atomic_dec(&cpu_in_kgdb[cpu]);
-			touch_softlockup_watchdog_sync();
-			clocksource_touch_watchdog();
+			dbg_touch_watchdogs();
 			local_irq_restore(flags);
 			return 0;
 		}
@@ -541,8 +546,7 @@ return_normal:
 	    (kgdb_info[cpu].task &&
 	     kgdb_info[cpu].task->pid != kgdb_sstep_pid) && --sstep_tries) {
 		atomic_set(&kgdb_active, -1);
-		touch_softlockup_watchdog_sync();
-		clocksource_touch_watchdog();
+		dbg_touch_watchdogs();
 		local_irq_restore(flags);
 
 		goto acquirelock;
@@ -659,8 +663,7 @@ kgdb_restore:
 		tracing_on();
 	/* Free kgdb_active */
 	atomic_set(&kgdb_active, -1);
-	touch_softlockup_watchdog_sync();
-	clocksource_touch_watchdog();
+	dbg_touch_watchdogs();
 	local_irq_restore(flags);
 
 	return kgdb_info[cpu].ret_state;
-- 
1.6.3.3

