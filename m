Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab0IRTBj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:01:39 -0400
Received: from kroah.org ([198.145.64.141]:51095 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab0IRTBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:12 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:53 2010
Message-Id: <20100918185953.321620652@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [006/123] x86, tsc, sched: Recompute cyc2ns_offsets during resume from sleep states
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=x86-tsc-sched-recompute-cyc2ns_offset-s-during-resume-from-sleep-states.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit cd7240c0b900eb6d690ccee088a6c9b46dae815a upstream.

TSC's get reset after suspend/resume (even on cpu's with invariant TSC
which runs at a constant rate across ACPI P-, C- and T-states). And in
some systems BIOS seem to reinit TSC to arbitrary large value (still
sync'd across cpu's) during resume.

This leads to a scenario of scheduler rq->clock (sched_clock_cpu()) less
than rq->age_stamp (introduced in 2.6.32). This leads to a big value
returned by scale_rt_power() and the resulting big group power set by the
update_group_power() is causing improper load balancing between busy and
idle cpu's after suspend/resume.

This resulted in multi-threaded workloads (like kernel-compilation) go
slower after suspend/resume cycle on core i5 laptops.

Fix this by recomputing cyc2ns_offset's during resume, so that
sched_clock() continues from the point where it was left off during
suspend.

Reported-by: Florian Pritz <flo@xssn.at>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1282262618.2675.24.camel@sbsiddha-MOBL3.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/tsc.h |    2 ++
 arch/x86/kernel/tsc.c      |   38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/power/cpu.c       |    2 ++
 3 files changed, 42 insertions(+)

--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -59,5 +59,7 @@ extern void check_tsc_sync_source(int cp
 extern void check_tsc_sync_target(void);
 
 extern int notsc_setup(char *);
+extern void save_sched_clock_state(void);
+extern void restore_sched_clock_state(void);
 
 #endif /* _ASM_X86_TSC_H */
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -626,6 +626,44 @@ static void set_cyc2ns_scale(unsigned lo
 	local_irq_restore(flags);
 }
 
+static unsigned long long cyc2ns_suspend;
+
+void save_sched_clock_state(void)
+{
+	if (!sched_clock_stable)
+		return;
+
+	cyc2ns_suspend = sched_clock();
+}
+
+/*
+ * Even on processors with invariant TSC, TSC gets reset in some the
+ * ACPI system sleep states. And in some systems BIOS seem to reinit TSC to
+ * arbitrary value (still sync'd across cpu's) during resume from such sleep
+ * states. To cope up with this, recompute the cyc2ns_offset for each cpu so
+ * that sched_clock() continues from the point where it was left off during
+ * suspend.
+ */
+void restore_sched_clock_state(void)
+{
+	unsigned long long offset;
+	unsigned long flags;
+	int cpu;
+
+	if (!sched_clock_stable)
+		return;
+
+	local_irq_save(flags);
+
+	get_cpu_var(cyc2ns_offset) = 0;
+	offset = cyc2ns_suspend - sched_clock();
+
+	for_each_possible_cpu(cpu)
+		per_cpu(cyc2ns_offset, cpu) = offset;
+
+	local_irq_restore(flags);
+}
+
 #ifdef CONFIG_CPU_FREQ
 
 /* Frequency scaling support. Adjust the TSC based timer when the cpu frequency
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -112,6 +112,7 @@ static void __save_processor_state(struc
 void save_processor_state(void)
 {
 	__save_processor_state(&saved_context);
+	save_sched_clock_state();
 }
 #ifdef CONFIG_X86_32
 EXPORT_SYMBOL(save_processor_state);
@@ -253,6 +254,7 @@ static void __restore_processor_state(st
 void restore_processor_state(void)
 {
 	__restore_processor_state(&saved_context);
+	restore_sched_clock_state();
 }
 #ifdef CONFIG_X86_32
 EXPORT_SYMBOL(restore_processor_state);


