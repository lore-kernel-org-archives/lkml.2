Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0E2SYV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 14:24:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44901 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab0E2SYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 14:24:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=b2OGYdJSOId6AMvqxqxBEHeEcs7B5rk7wglf00sEn6BY0NrsPyv3rQIxKYTy/Dbjqz
         /hZI4Ksz8lo201ZNaM9Un5cRWdZtK4H5h7XltO7RHUJKooL8bqdvpMqP//Y4V5+C+paF
         1xS376Sf5yPpPyxjhIjaaajTKhHamuMCMs9C4=
Date: Sat, 29 May 2010 22:24:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Robert Richter <robert.richter@amd.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] perf, x86: Segregate PMU workaraunds into x86_pmu_quirk_ops
	structure
Message-ID: <20100529182409.GJ5322@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would appreciate comments/complains on the following patch. The idea is to implement
PMU quirks with minimal impact. At the moment two quirks are addressed -
PEBS disabling on Clovertown and P4 performance counter double write.
PEBS disabling already was there only moved to x86_pmu_quirk_ops. Note
that I didn't use pointer to the structure intensionally but embed it into
x86_pmu, if the structure grow we will need to use a pointer to the structure.

Comments, complains please? Perhaps there is some idea which allow
to handle this all more gentle?

	-- Cyrill
---
perf, x86: Segregate PMU workaraunds into x86_pmu_quirk_ops structure

This allow us to handle both Clovertown and Netburst quirks in
a general fashion.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   18 ++++++++--
 arch/x86/kernel/cpu/perf_event_intel.c |   55 ++++++++++++++++++---------------
 arch/x86/kernel/cpu/perf_event_p4.c    |   21 ++++++++++++
 3 files changed, 64 insertions(+), 30 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -185,6 +185,11 @@ union perf_capabilities {
 	u64	capabilities;
 };
 
+struct x86_pmu_quirk_ops {
+	void		(*pmu_init)(void);
+	void		(*perfctr_write)(unsigned long addr, u64 value);
+};
+
 /*
  * struct x86_pmu - generic x86 pmu
  */
@@ -218,7 +223,8 @@ struct x86_pmu {
 	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
 						 struct perf_event *event);
 	struct event_constraint *event_constraints;
-	void		(*quirks)(void);
+
+	struct x86_pmu_quirk_ops quirks;
 
 	int		(*cpu_prepare)(int cpu);
 	void		(*cpu_starting)(int cpu);
@@ -924,7 +930,11 @@ x86_perf_event_set_period(struct perf_ev
 	 */
 	atomic64_set(&hwc->prev_count, (u64)-left);
 
-	wrmsrl(hwc->event_base + idx,
+	if (x86_pmu.quirks.perfctr_write)
+		x86_pmu.quirks.perfctr_write(hwc->event_base + idx,
+				(u64)(-left) & x86_pmu.cntval_mask);
+	else
+		wrmsrl(hwc->event_base + idx,
 			(u64)(-left) & x86_pmu.cntval_mask);
 
 	perf_event_update_userpage(event);
@@ -1316,8 +1326,8 @@ void __init init_hw_perf_events(void)
 
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
-	if (x86_pmu.quirks)
-		x86_pmu.quirks();
+	if (x86_pmu.quirks.pmu_init)
+		x86_pmu.quirks.pmu_init();
 
 	if (x86_pmu.num_counters > X86_PMC_MAX_GENERIC) {
 		WARN(1, KERN_ERR "hw perf events %d > max(%d), clipping!",
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_intel.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_intel.c
@@ -822,6 +822,36 @@ static void intel_pmu_cpu_dying(int cpu)
 	fini_debug_store_on_cpu(cpu);
 }
 
+static void intel_clovertown_pmu_init(void)
+{
+	/*
+	 * PEBS is unreliable due to:
+	 *
+	 *   AJ67  - PEBS may experience CPL leaks
+	 *   AJ68  - PEBS PMI may be delayed by one event
+	 *   AJ69  - GLOBAL_STATUS[62] will only be set when DEBUGCTL[12]
+	 *   AJ106 - FREEZE_LBRS_ON_PMI doesn't work in combination with PEBS
+	 *
+	 * AJ67 could be worked around by restricting the OS/USR flags.
+	 * AJ69 could be worked around by setting PMU_FREEZE_ON_PMI.
+	 *
+	 * AJ106 could possibly be worked around by not allowing LBR
+	 *       usage from PEBS, including the fixup.
+	 * AJ68  could possibly be worked around by always programming
+	 * 	 a pebs_event_reset[0] value and coping with the lost events.
+	 *
+	 * But taken together it might just make sense to not enable PEBS on
+	 * these chips.
+	 */
+	printk(KERN_WARNING "PEBS disabled due to CPU errata.\n");
+	x86_pmu.pebs = 0;
+	x86_pmu.pebs_constraints = NULL;
+}
+
+static __initconst const struct x86_pmu_quirk_ops intel_clovertown_quirks = {
+	.pmu_init = intel_clovertown_pmu_init,
+};
+
 static __initconst const struct x86_pmu intel_pmu = {
 	.name			= "Intel",
 	.handle_irq		= intel_pmu_handle_irq,
@@ -848,31 +878,6 @@ static __initconst const struct x86_pmu 
 	.cpu_dying		= intel_pmu_cpu_dying,
 };
 
-static void intel_clovertown_quirks(void)
-{
-	/*
-	 * PEBS is unreliable due to:
-	 *
-	 *   AJ67  - PEBS may experience CPL leaks
-	 *   AJ68  - PEBS PMI may be delayed by one event
-	 *   AJ69  - GLOBAL_STATUS[62] will only be set when DEBUGCTL[12]
-	 *   AJ106 - FREEZE_LBRS_ON_PMI doesn't work in combination with PEBS
-	 *
-	 * AJ67 could be worked around by restricting the OS/USR flags.
-	 * AJ69 could be worked around by setting PMU_FREEZE_ON_PMI.
-	 *
-	 * AJ106 could possibly be worked around by not allowing LBR
-	 *       usage from PEBS, including the fixup.
-	 * AJ68  could possibly be worked around by always programming
-	 * 	 a pebs_event_reset[0] value and coping with the lost events.
-	 *
-	 * But taken together it might just make sense to not enable PEBS on
-	 * these chips.
-	 */
-	printk(KERN_WARNING "PEBS disabled due to CPU errata.\n");
-	x86_pmu.pebs = 0;
-	x86_pmu.pebs_constraints = NULL;
-}
 
 static __init int intel_pmu_init(void)
 {
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -804,6 +804,24 @@ done:
 	return num ? -ENOSPC : 0;
 }
 
+/*
+ * This handles errata N15 in intel doc 249199-029,
+ * the counter may not be updated correctly on write
+ * so we repeat write operation twice to do the trick
+ * (the official workaround didn't work)
+ *
+ * the former idea is taken from OProfile code
+ */
+static void p4_perfctr_write(unsigned long addr, u64 value)
+{
+	wrmsrl(addr, value);
+	wrmsrl(addr, value);
+}
+
+static __initconst const struct x86_pmu_quirk_ops p4_pmu_quirks = {
+	.perfctr_write = p4_perfctr_write,
+};
+
 static __initconst const struct x86_pmu p4_pmu = {
 	.name			= "Netburst P4/Xeon",
 	.handle_irq		= p4_pmu_handle_irq,
@@ -850,7 +868,8 @@ static __init int p4_pmu_init(void)
 
 	pr_cont("Netburst events, ");
 
-	x86_pmu = p4_pmu;
+	x86_pmu		= p4_pmu;
+	x86_pmu.quirks	= p4_pmu_quirks;
 
 	return 0;
 }
