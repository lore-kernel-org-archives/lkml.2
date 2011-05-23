Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934249Ab1EWWPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 18:15:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:36377 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852Ab1EWWO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 18:14:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,258,1304319600"; 
   d="scan'208";a="7370554"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        "Andi Kleen" <andi@firstfloor.org>, "Borislav Petkov" <bp@alien8.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
Subject: [RFC 8/9] mce: run through processors with more severe problems first
Date: Mon, 23 May 2011 15:14:58 -0700
Message-Id: <4ddadc621717295209@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

Instead of letting cpus run through the MC bank scanning code
in the order that they turned up in the handler, we arrange to
deal with those that have more severe problems (mcgstatus.ripv=0)
first. This will make life simpler in the case that banks are
shared between processors, since the cpu with the problem will
see it and clear it, leaving the other cpu(s) that share the
bank with nothing to do.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   87 +++++++++++++++++++++++++++-----------
 1 files changed, 62 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 6b2fa20..7da4a75 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -646,7 +646,7 @@ static int mce_no_way_out(struct mce *m, char **msg)
  * Variable to establish order between CPUs while scanning.
  * Each CPU spins initially until executing is equal its number.
  */
-static atomic_t mce_executing;
+static atomic_t mce_executing = ATOMIC_INIT(-1);
 
 /*
  * Defines order of CPUs on entry. First CPU becomes Monarch.
@@ -762,13 +762,40 @@ static void mce_reign(void)
 static atomic_t global_nwo;
 
 /*
+ * Keep separate bitmaps for cpus that have the option return from
+ * machine check handler (MCG_STATUS.RIPV == 1) and those for that
+ * cannot.
+ */
+static cpumask_t	can_return;
+static cpumask_t	cant_return;
+
+static int	monarch;
+
+/*
+ * next cpu choosing first from cant_return, and then from can_return
+ */
+int mce_nextcpu(int this)
+{
+	int next;
+
+	if (this == -1 || cpumask_test_cpu(this, &cant_return)) {
+		next = cpumask_next(this, &cant_return);
+		if (next >= nr_cpu_ids)
+			next = cpumask_next(-1, &can_return);
+		return next;
+	}
+
+	return cpumask_next(this, &can_return);
+}
+
+/*
  * Start of Monarch synchronization. This waits until all CPUs have
  * entered the exception handler and then determines if any of them
  * saw a fatal event that requires panic. Then it executes them
- * in the entry order.
+ * one at a time.
  * TBD double check parallel CPU hotunplug
  */
-static int mce_start(int *no_way_out)
+static int mce_start(int *no_way_out, int noreturn)
 {
 	int order;
 	int cpus = num_online_cpus();
@@ -784,6 +811,11 @@ static int mce_start(int *no_way_out)
 	smp_wmb();
 	order = atomic_inc_return(&mce_callin);
 
+	if (noreturn)
+		cpumask_set_cpu(smp_processor_id(), &cant_return);
+	else
+		cpumask_set_cpu(smp_processor_id(), &can_return);
+
 	/*
 	 * Wait for everyone.
 	 */
@@ -802,23 +834,26 @@ static int mce_start(int *no_way_out)
 
 	if (order == 1) {
 		/*
-		 * Monarch: Starts executing now, the others wait.
+		 * Choose a cpu to be monarch.  It will run first
 		 */
-		atomic_set(&mce_executing, 1);
-	} else {
-		/*
-		 * Subject: Now start the scanning loop one by one in
-		 * the original callin order.
-		 * This way when there are any shared banks it will be
-		 * only seen by one CPU before cleared, avoiding duplicates.
-		 */
-		while (atomic_read(&mce_executing) < order) {
-			if (mce_timed_out(&timeout)) {
-				atomic_set(&global_nwo, 0);
-				return -1;
-			}
-			ndelay(SPINUNIT);
+		monarch = mce_nextcpu(-1);
+		atomic_set(&mce_executing, monarch);
+	}
+	/*
+	 * Subject: Now start the scanning loop one by one in
+	 * choosing first the "cant_return" cpus and the the others.
+	 * This way when there are any shared banks it will be
+	 * only seen by one CPU before cleared, avoiding duplicates.
+	 * Letting the "cant_return" folks go first means that for
+	 * "action required" errors, the cpu that hit the problem
+	 * will find its error in the shared bank first.
+	 */
+	while (atomic_read(&mce_executing) != smp_processor_id()) {
+		if (mce_timed_out(&timeout)) {
+			atomic_set(&global_nwo, 0);
+			return -1;
 		}
+		ndelay(SPINUNIT);
 	}
 
 	/*
@@ -846,9 +881,9 @@ static int mce_end(int order)
 	/*
 	 * Allow others to run.
 	 */
-	atomic_inc(&mce_executing);
+	atomic_set(&mce_executing, mce_nextcpu(smp_processor_id()));
 
-	if (order == 1) {
+	if (smp_processor_id() == monarch) {
 		/* CHECKME: Can this race with a parallel hotplug? */
 		int cpus = num_online_cpus();
 
@@ -856,7 +891,7 @@ static int mce_end(int order)
 		 * Monarch: Wait for everyone to go through their scanning
 		 * loops.
 		 */
-		while (atomic_read(&mce_executing) <= cpus) {
+		while (atomic_read(&mce_executing) != nr_cpu_ids) {
 			if (mce_timed_out(&timeout))
 				goto reset;
 			ndelay(SPINUNIT);
@@ -869,7 +904,7 @@ static int mce_end(int order)
 		/*
 		 * Subject: Wait for Monarch to finish.
 		 */
-		while (atomic_read(&mce_executing) != 0) {
+		while (atomic_read(&mce_executing) != -1) {
 			if (mce_timed_out(&timeout))
 				goto reset;
 			ndelay(SPINUNIT);
@@ -887,12 +922,14 @@ static int mce_end(int order)
 reset:
 	atomic_set(&global_nwo, 0);
 	atomic_set(&mce_callin, 0);
+	cpumask_clear(&can_return);
+	cpumask_clear(&cant_return);
 	barrier();
 
 	/*
 	 * Let others run again.
 	 */
-	atomic_set(&mce_executing, 0);
+	atomic_set(&mce_executing, -1);
 	return ret;
 }
 
@@ -991,7 +1028,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * This way we don't report duplicated events on shared banks
 	 * because the first one to see it will clear it.
 	 */
-	order = mce_start(&no_way_out);
+	order = mce_start(&no_way_out, kill_it);
 	for (i = 0; i < banks; i++) {
 		__clear_bit(i, toclear);
 		if (!mce_banks[i].ctl)
@@ -2193,7 +2230,7 @@ static void mce_reset(void)
 {
 	cpu_missing = 0;
 	atomic_set(&mce_fake_paniced, 0);
-	atomic_set(&mce_executing, 0);
+	atomic_set(&mce_executing, -1);
 	atomic_set(&mce_callin, 0);
 	atomic_set(&global_nwo, 0);
 }
-- 
1.7.3.1

