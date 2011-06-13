Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab1FMWDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 18:03:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:36862 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab1FMWDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 18:03:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,360,1304319600"; 
   d="scan'208";a="14068684"
From: Tony Luck <tony.luck@intel.com>
To: "Hidetoshi Seto" <seto.hidetoshi@jp.fujitsu.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Borislav Petkov" <bp@amd64.org>,
        linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        "Avi Kivity" <avi@redhat.com>
Subject: Re: [PATCH 09/10] MCE: run through processors with more severe problems first
In-Reply-To: <BANLkTi=1nQy03T4LnfHYoB8LBVgFbgaVXA@mail.gmail.com>
Date: Mon, 13 Jun 2011 15:03:23 -0700
Message-Id: <4df6892b12944b314b@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Or how about checking rip in each mces_seen?
>
> This is equivalent to what I did - but I think the code
> will be cleaner. I'll give it a try.

Here's a patch on top of my previous series that just looks at
mces_seen to choose the order. Obviously I'd fold this into the
other patch for a final version - but this one lets you see what
the "mce_nextcpu()" function would look like (and how removing
the bitmaps cleans up the other parts of the code). It does look
better to me.

Seto-san: Does this fit with what you were thinking?

Compile tested only.

-Tony

---

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a7a8c53..6b4176b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -791,31 +791,47 @@ static void mce_reign(void)
 
 static atomic_t global_nwo;
 
-/*
- * Keep separate bitmaps for cpus that have the option return from
- * machine check handler (MCG_STATUS.RIPV == 1) and those for that
- * cannot.
- */
-static cpumask_t	can_return;
-static cpumask_t	cant_return;
-
 static int	monarch;
 
 /*
- * next cpu choosing first from cant_return, and then from can_return
+ * Find next cpu that will run through the core of do_machine_check()
+ * checking all the banks of machine check registers. We first take
+ * cpus with serious problems (as indicated by MCG_STATUS_RIPV being
+ * clear in the mcgstatus register). A second pass through mces_seen
+ * is made to process the remaining cpus.
+ * We do this because some machine check banks are shared between cpus,
+ * and it is better to find the error on the cpu that has the problem
+ * and clear the bank so that the innocent bystanders do not have to
+ * worry about errors that do not affect them.
  */
-int mce_nextcpu(int this)
+int mce_nextcpu(int cur)
 {
-	int next;
+	struct mce	*m;
+	int		cpu = cur;
+	u64	mask = MCG_STATUS_MCIP;
 
-	if (this == -1 || cpumask_test_cpu(this, &cant_return)) {
-		next = cpumask_next(this, &cant_return);
-		if (next >= nr_cpu_ids)
-			next = cpumask_next(-1, &can_return);
-		return next;
+	if (cpu != -1) {
+		m = &per_cpu(mces_seen, cpu);
+		if (m->mcgstatus & MCG_STATUS_RIPV)
+			mask |= MCG_STATUS_RIPV;
 	}
 
-	return cpumask_next(this, &can_return);
+	while (1) {
+		cpu = cpumask_next(cpu, cpu_possible_mask);
+		if (cpu >= nr_cpu_ids) {
+			if (mask & MCG_STATUS_RIPV)
+				return cpu;
+			mask |= MCG_STATUS_RIPV;
+			cpu = -1;
+			continue;
+		}
+
+		m = &per_cpu(mces_seen, cpu);
+		if ((m->mcgstatus & (MCG_STATUS_MCIP|MCG_STATUS_RIPV)) == mask)
+			break;
+	}
+
+	return cpu;
 }
 
 /*
@@ -825,7 +841,7 @@ int mce_nextcpu(int this)
  * one at a time.
  * TBD double check parallel CPU hotunplug
  */
-static int mce_start(int *no_way_out, int noreturn)
+static int mce_start(int *no_way_out)
 {
 	int order;
 	int cpus = num_online_cpus();
@@ -841,11 +857,6 @@ static int mce_start(int *no_way_out, int noreturn)
 	smp_wmb();
 	order = atomic_inc_return(&mce_callin);
 
-	if (noreturn)
-		cpumask_set_cpu(smp_processor_id(), &cant_return);
-	else
-		cpumask_set_cpu(smp_processor_id(), &can_return);
-
 	/*
 	 * Wait for everyone.
 	 */
@@ -951,8 +962,6 @@ static int mce_end(int order)
 reset:
 	atomic_set(&global_nwo, 0);
 	atomic_set(&mce_callin, 0);
-	cpumask_clear(&can_return);
-	cpumask_clear(&cant_return);
 	barrier();
 
 	/*
@@ -1134,7 +1143,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * This way we don't report duplicated events on shared banks
 	 * because the first one to see it will clear it.
 	 */
-	order = mce_start(&no_way_out, kill_it);
+	order = mce_start(&no_way_out);
 	for (i = 0; i < banks; i++) {
 		__clear_bit(i, toclear);
 		if (!mce_banks[i].ctl)
