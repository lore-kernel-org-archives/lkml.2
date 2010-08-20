Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab0HTAEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 20:04:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:42709 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab0HTAEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 20:04:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,236,1280732400"; 
   d="scan'208";a="598422155"
Subject: Re: [patch 1/3] sched: init rt_avg stat whenever rq comes online
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chris@frostnet.net" <chris@frostnet.net>,
        "debian00@aliceadsl.fr" <debian00@aliceadsl.fr>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jonathan.protzenko@gmail.com" <jonathan.protzenko@gmail.com>,
        "mans@mansr.com" <mans@mansr.com>,
        "psastudio@mail.ru" <psastudio@mail.ru>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "stephan.eicher@web.de" <stephan.eicher@web.de>,
        "sxxe@gmx.de" <sxxe@gmx.de>,
        "thomas@archlinux.org" <thomas@archlinux.org>,
        "venki@google.com" <venki@google.com>,
        "wonghow@gmail.com" <wonghow@gmail.com>,
        "stable@kernel.org" <stable@kernel.org>, tglx <tglx@linutronix.de>
In-Reply-To: <1282208006.1926.4517.camel@laptop>
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
	 <20100813193911.827207098@sbsiddha-MOBL3.sc.intel.com>
	 <1281944854.1926.948.camel@laptop>
	 <1281980179.2676.22.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1281986708.1926.1877.camel@laptop>  <1282035085.1926.2164.camel@laptop>
	 <1282177213.7801.17.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1282208006.1926.4517.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 19 Aug 2010 17:03:38 -0700
Message-Id: <1282262618.2675.24.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 01:53 -0700, Peter Zijlstra wrote:
> ARGH, please kill all SMM support for future CPUs ;-)
> 
> Are the TSCs still sync'ed though? 

Yes.

> If so, we can still compute a offset
> and continue with things, albeit it requires something like:
> 
>   local_irq_save(flags);
>   __get_cpu_var(cyc2ns_offset) = 0;
>   offset = cyc2ns_suspend - sched_clock();
>   local_irq_restore(flags);
> 
>   for_each_possible_cpu(i)
>     per_cpu(cyc2ns_offset, i) = offset;
> 
> Which would take the funny offset into account and make it resume at
> where we left off.
> 
> If they got out of sync, we need to flip sched_clock_stable and work on
> getting the sched_clock.c code to be monotonic over such a flip.
> 
> > So such large values of TSC (leading to a very big difference between
> > rq->clock and rq->age_stamp) wont be correctly handled by
> > scale_rt_power() either.
> 
> Still, we need to fix the clock, not fudge the users.

Ok. I have appended a patch doing this. Seems to fix the scheduler
performance issue triggered by suspend/resume. Can you please Ack it?

Thomas/Peter/Ingo: can you please pick this up if you have no other
objections. Thanks.
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, tsc: recompute cyc2ns_offset's during resume from sleep states

TSC's get reset after suspend/resume (even on cpu's with invariant TSC which
runs at a constant rate across ACPI P-, C- and T-states). And in some systems
BIOS seem to reinit TSC to arbitrary large value (still sync'd across cpu's)
during resume.

This leads to a scenario of scheduler rq->clock (sched_clock_cpu()) less than
rq->age_stamp (introduced in 2.6.32). This leads to a big value returned by
scale_rt_power() and the resulting big group power set by the update_group_power()
is causing improper load balancing between busy and idle cpu's after suspend/resume.

This resulted in multi-threaded workloads (like kernel-compilation) go slower
after suspend/resume cycle on core i5 laptops.

Fix this by recomputing cyc2ns_offset's during resume, so that sched_clock()
continues from the point where it was left off during suspend.

Reported-by: Florian Pritz <flo@xssn.at>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org [2.6.32+]
---

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


