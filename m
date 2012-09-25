Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab2IYPGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:06:48 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:56768 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab2IYPGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:06:46 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/6] ia64: Consolidate user vtime accounting
Date: Tue, 25 Sep 2012 17:06:04 +0200
Message-Id: <1348585567-2925-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1348585567-2925-1-git-send-email-fweisbec@gmail.com>
References: <1348585567-2925-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factorize the code that accounts user time into a
single function to avoid code duplication.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 arch/ia64/kernel/time.c |   28 +++++++++++++++-------------
 1 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 01cd43e..351df58 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -83,6 +83,18 @@ static struct clocksource *itc_clocksource;
 
 extern cputime_t cycle_to_cputime(u64 cyc);
 
+static void vtime_account_user(struct task_struct *tsk)
+{
+	cputime_t delta_utime;
+	struct thread_info *ti = task_thread_info(tsk);
+
+	if (ti->ac_utime) {
+		delta_utime = cycle_to_cputime(ti->ac_utime);
+		account_user_time(tsk, delta_utime, delta_utime);
+		ti->ac_utime = 0;
+	}
+}
+
 /*
  * Called from the context switch with interrupts disabled, to charge all
  * accumulated times to the current process, and to prepare accounting on
@@ -92,7 +104,7 @@ void vtime_task_switch(struct task_struct *prev)
 {
 	struct thread_info *pi = task_thread_info(prev);
 	struct thread_info *ni = task_thread_info(current);
-	cputime_t delta_stime, delta_utime;
+	cputime_t delta_stime;
 	__u64 now;
 
 	now = ia64_get_itc();
@@ -103,10 +115,7 @@ void vtime_task_switch(struct task_struct *prev)
 	else
 		account_idle_time(delta_stime);
 
-	if (pi->ac_utime) {
-		delta_utime = cycle_to_cputime(pi->ac_utime);
-		account_user_time(prev, delta_utime, delta_utime);
-	}
+	vtime_account_user(prev);
 
 	pi->ac_stamp = ni->ac_stamp = now;
 	ni->ac_stime = ni->ac_utime = 0;
@@ -149,14 +158,7 @@ void vtime_account_idle(struct task_struct *tsk)
  */
 void account_process_tick(struct task_struct *p, int user_tick)
 {
-	struct thread_info *ti = task_thread_info(p);
-	cputime_t delta_utime;
-
-	if (ti->ac_utime) {
-		delta_utime = cycle_to_cputime(ti->ac_utime);
-		account_user_time(p, delta_utime, delta_utime);
-		ti->ac_utime = 0;
-	}
+	vtime_account_user(p);
 }
 
 #endif /* CONFIG_VIRT_CPU_ACCOUNTING */
-- 
1.7.5.4

