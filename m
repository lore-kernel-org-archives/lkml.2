Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab0CVTTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 15:19:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:36508 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab0CVTSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 15:18:24 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 5/8] kgdb,debug_core: Use atomic operators which use barriers
Date: Mon, 22 Mar 2010 14:17:26 -0500
Message-Id: <1269285449-1424-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1269285449-1424-5-git-send-email-jason.wessel@windriver.com>
References: <1269285449-1424-1-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-2-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-3-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-4-git-send-email-jason.wessel@windriver.com>
 <1269285449-1424-5-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 22 Mar 2010 19:17:40.0018 (UTC) FILETIME=[56DFA120:01CAC9F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A cpu_relax() does not mandate that there is an smp memory barrier.
As a result on the arm smp architecture the kernel debugger can hang
on entry from time to time, as shown by the kgdb regression tests.

The solution is simply to use the atomic operators which include a
proper smp memory barrier, instead of using atomic_set() and
atomic_read().

Tested-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/debug_core.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 91286e8..f471268 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -463,8 +463,7 @@ acquirelock:
 	 * Make sure the above info reaches the primary CPU before
 	 * our cpu_in_kgdb[] flag setting does:
 	 */
-	smp_wmb();
-	atomic_set(&cpu_in_kgdb[cpu], 1);
+	atomic_inc(&cpu_in_kgdb[cpu]);
 
 	/*
 	 * CPU will loop if it is a slave or request to become a kgdb
@@ -475,7 +474,7 @@ acquirelock:
 			if (atomic_cmpxchg(&kgdb_active, -1, cpu) == cpu)
 				break;
 		} else if (kgdb_info[cpu].exception_state & DCPU_IS_SLAVE) {
-			if (!atomic_read(&passive_cpu_wait[cpu]))
+			if (!atomic_add_return(0, &passive_cpu_wait[cpu]))
 				goto return_normal;
 		} else {
 return_normal:
@@ -484,7 +483,7 @@ return_normal:
 			 */
 			if (arch_kgdb_ops.correct_hw_break)
 				arch_kgdb_ops.correct_hw_break();
-			atomic_set(&cpu_in_kgdb[cpu], 0);
+			atomic_dec(&cpu_in_kgdb[cpu]);
 			touch_softlockup_watchdog_sync();
 			clocksource_touch_watchdog();
 			local_irq_restore(flags);
@@ -533,7 +532,7 @@ return_normal:
 	 */
 	if (!kgdb_single_step) {
 		for (i = 0; i < NR_CPUS; i++)
-			atomic_set(&passive_cpu_wait[i], 1);
+			atomic_inc(&passive_cpu_wait[i]);
 	}
 
 #ifdef CONFIG_SMP
@@ -546,7 +545,7 @@ return_normal:
 	 * Wait for the other CPUs to be notified and be waiting for us:
 	 */
 	for_each_online_cpu(i) {
-		while (!atomic_read(&cpu_in_kgdb[i]))
+		while (!atomic_add_return(0, &cpu_in_kgdb[i]))
 			cpu_relax();
 	}
 
@@ -567,17 +566,17 @@ return_normal:
 	if (dbg_io_ops->post_exception)
 		dbg_io_ops->post_exception();
 
-	atomic_set(&cpu_in_kgdb[ks->cpu], 0);
+	atomic_dec(&cpu_in_kgdb[ks->cpu]);
 
 	if (!kgdb_single_step) {
 		for (i = NR_CPUS-1; i >= 0; i--)
-			atomic_set(&passive_cpu_wait[i], 0);
+			atomic_dec(&passive_cpu_wait[i]);
 		/*
 		 * Wait till all the CPUs have quit
 		 * from the debugger.
 		 */
 		for_each_online_cpu(i) {
-			while (atomic_read(&cpu_in_kgdb[i]))
+			while (atomic_add_return(0, &cpu_in_kgdb[i]))
 				cpu_relax();
 		}
 	}
@@ -820,11 +819,11 @@ EXPORT_SYMBOL_GPL(kgdb_unregister_io_module);
  */
 void kgdb_breakpoint(void)
 {
-	atomic_set(&kgdb_setting_breakpoint, 1);
+	atomic_inc(&kgdb_setting_breakpoint);
 	wmb(); /* Sync point before breakpoint */
 	arch_kgdb_breakpoint();
 	wmb(); /* Sync point after breakpoint */
-	atomic_set(&kgdb_setting_breakpoint, 0);
+	atomic_dec(&kgdb_setting_breakpoint);
 }
 EXPORT_SYMBOL_GPL(kgdb_breakpoint);
 
-- 
1.6.4.rc1

