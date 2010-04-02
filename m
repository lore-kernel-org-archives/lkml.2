Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab0DBTsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:48:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:35035 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab0DBTsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:48:18 -0400
Message-ID: <4BB649E3.5060606@windriver.com>
Date: Fri, 02 Apr 2010 14:47:47 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: kgdb-bugreport@lists.sourceforge.net, Will Deacon <will.deacon@arm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       linux-arm@vger.kernel.org
Subject: Re: [Kgdb-bugreport] [PATCH 4/5] kgdb: Use atomic operators whichuse
 barriers
References: <1270233145-29335-1-git-send-email-jason.wessel@windriver.com><1270233145-29335-2-git-send-email-jason.wessel@windriver.com><1270233145-29335-3-git-send-email-jason.wessel@windriver.com><1270233145-29335-4-git-send-email-jason.wessel@windriver.com><1270233145-29335-5-git-send-email-jason.wessel@windriver.com><alpine.LFD.2.00.1004021205080.3634@i5.linux-foundation.org> <4BB64762.6040806@windriver.com>
In-Reply-To: <4BB64762.6040806@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Apr 2010 19:47:47.0682 (UTC) FILETIME=[5EDE8420:01CAD29D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here is the revised patch, which is going into the kgdb-fixes branch.

Thanks,
Jason.

--
From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] kgdb: Use atomic operators which use barriers

The cpu_relax() does not mandate that there is an smp memory barrier.
As a result on the arm smp architecture the kernel debugger can hang
on entry from time to time, as shown by the kgdb regression tests.

The solution is simply to use the atomic operators which include a
proper smp memory barrier, instead of using atomic_set().

Tested-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/kgdb.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -1379,8 +1379,7 @@ acquirelock:
 	 * Make sure the above info reaches the primary CPU before
 	 * our cpu_in_kgdb[] flag setting does:
 	 */
-	smp_wmb();
-	atomic_set(&cpu_in_kgdb[cpu], 1);
+	atomic_inc(&cpu_in_kgdb[cpu]);
 
 	/*
 	 * CPU will loop if it is a slave or request to become a kgdb
@@ -1400,7 +1399,7 @@ return_normal:
 			 */
 			if (arch_kgdb_ops.correct_hw_break)
 				arch_kgdb_ops.correct_hw_break();
-			atomic_set(&cpu_in_kgdb[cpu], 0);
+			atomic_dec(&cpu_in_kgdb[cpu]);
 			touch_softlockup_watchdog_sync();
 			clocksource_touch_watchdog();
 			local_irq_restore(flags);
@@ -1449,7 +1448,7 @@ return_normal:
 	 */
 	if (!kgdb_single_step) {
 		for (i = 0; i < NR_CPUS; i++)
-			atomic_set(&passive_cpu_wait[i], 1);
+			atomic_inc(&passive_cpu_wait[i]);
 	}
 
 #ifdef CONFIG_SMP
@@ -1483,11 +1482,11 @@ return_normal:
 	if (kgdb_io_ops->post_exception)
 		kgdb_io_ops->post_exception();
 
-	atomic_set(&cpu_in_kgdb[ks->cpu], 0);
+	atomic_dec(&cpu_in_kgdb[ks->cpu]);
 
 	if (!kgdb_single_step) {
 		for (i = NR_CPUS-1; i >= 0; i--)
-			atomic_set(&passive_cpu_wait[i], 0);
+			atomic_dec(&passive_cpu_wait[i]);
 		/*
 		 * Wait till all the CPUs have quit
 		 * from the debugger.
@@ -1736,11 +1735,11 @@ EXPORT_SYMBOL_GPL(kgdb_unregister_io_mod
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
 
