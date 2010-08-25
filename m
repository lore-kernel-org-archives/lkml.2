Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0HYMBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 08:01:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60863 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440Ab0HYMBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 08:01:01 -0400
Date: Wed, 25 Aug 2010 14:00:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20100825120050.GA23891@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      sched: Fix rq->clock synchronization when migrating tasks

Suresh Siddha (1):
      x86, tsc, sched: Recompute cyc2ns_offset's during resume from sleep states


 arch/x86/include/asm/tsc.h |    2 ++
 arch/x86/kernel/tsc.c      |   38 ++++++++++++++++++++++++++++++++++++++
 arch/x86/power/cpu.c       |    2 ++
 kernel/sched_fair.c        |    2 ++
 4 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index c042729..1ca132f 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -59,5 +59,7 @@ extern void check_tsc_sync_source(int cpu);
 extern void check_tsc_sync_target(void);
 
 extern int notsc_setup(char *);
+extern void save_sched_clock_state(void);
+extern void restore_sched_clock_state(void);
 
 #endif /* _ASM_X86_TSC_H */
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index ce8e502..d632934 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -626,6 +626,44 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
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
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index e7e8c5f..87bb35e 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -113,6 +113,7 @@ static void __save_processor_state(struct saved_context *ctxt)
 void save_processor_state(void)
 {
 	__save_processor_state(&saved_context);
+	save_sched_clock_state();
 }
 #ifdef CONFIG_X86_32
 EXPORT_SYMBOL(save_processor_state);
@@ -229,6 +230,7 @@ static void __restore_processor_state(struct saved_context *ctxt)
 void restore_processor_state(void)
 {
 	__restore_processor_state(&saved_context);
+	restore_sched_clock_state();
 }
 #ifdef CONFIG_X86_32
 EXPORT_SYMBOL(restore_processor_state);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 806d1b2..ab661eb 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3752,6 +3752,8 @@ static void task_fork_fair(struct task_struct *p)
 
 	raw_spin_lock_irqsave(&rq->lock, flags);
 
+	update_rq_clock(rq);
+
 	if (unlikely(task_cpu(p) != this_cpu))
 		__set_task_cpu(p, this_cpu);
 
