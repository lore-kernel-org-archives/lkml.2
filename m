Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab2FHN0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 09:26:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50274 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab2FHN02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 09:26:28 -0400
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <1339149613.23343.52.camel@twins>
References: <20120607071531.GA4849@quad> <1339064319.23343.13.camel@twins>
	 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	 <1339065932.23343.18.camel@twins>
	 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	 <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com>
	 <1339149613.23343.52.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jun 2012 15:26:12 +0200
Message-ID: <1339161972.2507.13.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 12:00 +0200, Peter Zijlstra wrote:
> > > Or we could put a hook in the ucode loader.
> > 
> > I'd really suggest the latter - I doubt this will be our only 
> > ucode dependent quirk, going forward ...
> 
> Yeah, am in the middle of writing that.. 

OK so the micro-code stuff is a complete trainwreck.

The very worst is that it does per-cpu micro-code updates, not machine
wide. This results in it being able to have different revisions on
different cpus. This in turn makes the below O(n^2) :/

The biggest problem is finding when the minimum revision changes, at
best this is a n log n sorting problem due to the per-cpu setup, but I
couldn't be arsed to implement a tree or anything fancy since it all
stinks anyway.

Why do we have per-cpu firmware anyway?

Anyway, I have the below in two patches, but I thought to first post the
entire mess since if anybody has a better idea I'm all ears.

It does work though..

---
 arch/x86/include/asm/microcode.h       |   12 ++++++
 arch/x86/kernel/cpu/perf_event.c       |   14 +++----
 arch/x86/kernel/cpu/perf_event.h       |    2 +-
 arch/x86/kernel/cpu/perf_event_intel.c |   63 ++++++++++++++++++++++++++++++--
 arch/x86/kernel/microcode_amd.c        |    1 +
 arch/x86/kernel/microcode_core.c       |   53 +++++++++++++++++++++++----
 arch/x86/kernel/microcode_intel.c      |    1 +
 arch/x86/kernel/setup.c                |    5 +++
 8 files changed, 132 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 4ebe157..1cd2dc5 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -32,6 +32,7 @@ struct microcode_ops {
 
 struct ucode_cpu_info {
 	struct cpu_signature	cpu_sig;
+	int			new_rev;
 	int			valid;
 	void			*mc;
 };
@@ -63,4 +64,15 @@ static inline struct microcode_ops * __init init_amd_microcode(void)
 static inline void __exit exit_amd_microcode(void) {}
 #endif
 
+extern struct blocking_notifier_head microcode_notifier;
+
+#define MICROCODE_CAN_UPDATE	0x01
+#define MICROCODE_UPDATED	0x02
+
+#define microcode_notifier(fn)						\
+do {									\
+	static struct notifier_block fn##_nb ={ .notifier_call = fn };	\
+	blocking_notifier_chain_register(&microcode_notifier, &fn##_nb);\
+} while (0)
+
 #endif /* _ASM_X86_MICROCODE_H */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 000a474..d3ef86c1 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -377,7 +377,7 @@ int x86_pmu_hw_config(struct perf_event *event)
 		int precise = 0;
 
 		/* Support for constant skid */
-		if (x86_pmu.pebs_active) {
+		if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
 			precise++;
 
 			/* Support for IP fixup */
@@ -1677,9 +1677,9 @@ static struct pmu pmu = {
 	.pmu_enable		= x86_pmu_enable,
 	.pmu_disable		= x86_pmu_disable,
 
-	.attr_groups	= x86_pmu_attr_groups,
+	.attr_groups		= x86_pmu_attr_groups,
 
-	.event_init	= x86_pmu_event_init,
+	.event_init		= x86_pmu_event_init,
 
 	.add			= x86_pmu_add,
 	.del			= x86_pmu_del,
@@ -1687,11 +1687,11 @@ static struct pmu pmu = {
 	.stop			= x86_pmu_stop,
 	.read			= x86_pmu_read,
 
-	.start_txn	= x86_pmu_start_txn,
-	.cancel_txn	= x86_pmu_cancel_txn,
-	.commit_txn	= x86_pmu_commit_txn,
+	.start_txn		= x86_pmu_start_txn,
+	.cancel_txn		= x86_pmu_cancel_txn,
+	.commit_txn		= x86_pmu_commit_txn,
 
-	.event_idx	= x86_pmu_event_idx,
+	.event_idx		= x86_pmu_event_idx,
 	.flush_branch_stack	= x86_pmu_flush_branch_stack,
 };
 
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3df3de9..a5ecfe8 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -373,7 +373,7 @@ struct x86_pmu {
 	 * Intel DebugStore bits
 	 */
 	int		bts, pebs;
-	int		bts_active, pebs_active;
+	int		bts_active, pebs_active, pebs_broken;
 	int		pebs_record_size;
 	void		(*drain_pebs)(struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 5ec146c..bde86cf 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -15,6 +15,7 @@
 
 #include <asm/hardirq.h>
 #include <asm/apic.h>
+#include <asm/microcode.h>
 
 #include "perf_event.h"
 
@@ -1714,11 +1715,67 @@ static __init void intel_clovertown_quirk(void)
 	x86_pmu.pebs_constraints = NULL;
 }
 
+static const u32 snb_ucode_rev = 0x28;
+
+static void intel_snb_verify_ucode(void)
+{
+	u32 rev = UINT_MAX;
+	int pebs_broken = 0;
+	int cpu;
+
+	get_online_cpus();
+	/*
+	 * Because the microcode loader is bloody stupid and allows different
+	 * revisions per cpu and does strictly per-cpu loading, we now have to
+	 * check all cpus to determine the minimally installed revision.
+	 *
+	 * This makes updating the microcode O(n^2) in the number of CPUs :/
+	 */
+	for_each_online_cpu(cpu)
+		rev = min(cpu_data(cpu).microcode, rev);
+	put_online_cpus();
+
+	pebs_broken = (rev < snb_ucode_rev);
+
+	if (pebs_broken == x86_pmu.pebs_broken)
+		return;
+
+	/*
+	 * Serialized by the microcode lock..
+	 */
+	if (x86_pmu.pebs_broken) {
+		pr_info("PEBS enabled due to micro-code update\n");
+		x86_pmu.pebs_broken = 0;
+	} else {
+		pr_info("PEBS disabled due to CPU errata, "
+			"please upgrade micro-code to at least %x (current: %x)\n",
+			snb_ucode_rev, rev);
+		x86_pmu.pebs_broken = 1;
+	}
+}
+
+static int intel_snb_ucode_notifier(struct notifier_block *self,
+				   unsigned long action, void *_uci)
+{
+	/*
+	 * Since ucode cannot be down-graded, and no future ucode revision
+	 * is known to break PEBS again, we're ok with MICROCODE_CAN_UPDATE.
+	 */
+
+	if (action == MICROCODE_UPDATED)
+		intel_snb_verify_ucode();
+
+	return NOTIFY_DONE;
+}
+
 static __init void intel_sandybridge_quirk(void)
 {
-	pr_warn("PEBS disabled due to CPU errata\n");
-	x86_pmu.pebs = 0;
-	x86_pmu.pebs_constraints = NULL;
+	intel_snb_verify_ucode();
+	/*
+	 * we're still single threaded, so while there's a hole here,
+	 * you can't trigger it.
+	 */
+	microcode_notifier(intel_snb_ucode_notifier);
 }
 
 static const struct { int id; char *name; } intel_arch_events_map[] __initconst = {
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 8a2ce8f..265831e 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -294,6 +294,7 @@ generic_load_microcode(int cpu, const u8 *data, size_t size)
 	}
 
 out_ok:
+	uci->new_rev = new_rev;
 	uci->mc = new_mc;
 	state = UCODE_OK;
 	pr_debug("CPU%d update ucode (0x%08x -> 0x%08x)\n",
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index fbdfc69..a6cad81 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -167,15 +167,43 @@ static void apply_microcode_local(void *arg)
 	ctx->err = microcode_ops->apply_microcode(smp_processor_id());
 }
 
+/*
+ * Call the notifier chain before we update to verify we can indeed
+ * update to the desired revision.
+ */
+
+static int microcode_notifier_check(struct ucode_cpu_info *uci)
+{
+	int ret = blocking_notifier_call_chain(&microcode_notifier,
+			MICROCODE_CAN_UPDATE, uci);
+	return notifier_to_errno(ret);
+}
+
+/*
+ * Call the notifier chain after we've updated to
+ */
+
+static void microcode_notifier_done(void)
+{
+	blocking_notifier_call_chain(&microcode_notifier, MICROCODE_UPDATED, NULL);
+}
+
 static int apply_microcode_on_target(int cpu)
 {
 	struct apply_microcode_ctx ctx = { .err = 0 };
 	int ret;
 
+	ret = microcode_notifier_check(ucode_cpu_info + cpu);
+	if (ret)
+		return ret;
+
 	ret = smp_call_function_single(cpu, apply_microcode_local, &ctx, 1);
 	if (!ret)
 		ret = ctx.err;
 
+	if (!ret)
+		microcode_notifier_done();
+
 	return ret;
 }
 
@@ -196,8 +224,11 @@ static int do_microcode_update(const void __user *buf, size_t size)
 		if (ustate == UCODE_ERROR) {
 			error = -1;
 			break;
-		} else if (ustate == UCODE_OK)
-			apply_microcode_on_target(cpu);
+		} else if (ustate == UCODE_OK) {
+			error = apply_microcode_on_target(cpu);
+			if (error)
+				break;
+		}
 	}
 
 	return error;
@@ -282,11 +313,12 @@ static int reload_for_cpu(int cpu)
 		enum ucode_state ustate;
 
 		ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
-		if (ustate == UCODE_OK)
-			apply_microcode_on_target(cpu);
-		else
+		if (ustate == UCODE_OK) {
+			err = apply_microcode_on_target(cpu);
+		} else {
 			if (ustate == UCODE_ERROR)
 				err = -EINVAL;
+		}
 	}
 	mutex_unlock(&microcode_mutex);
 
@@ -361,14 +393,15 @@ static void microcode_fini_cpu(int cpu)
 static enum ucode_state microcode_resume_cpu(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
+	int err;
 
 	if (!uci->mc)
 		return UCODE_NFOUND;
 
 	pr_debug("CPU%d updated upon resume\n", cpu);
-	apply_microcode_on_target(cpu);
+	err = apply_microcode_on_target(cpu);
 
-	return UCODE_OK;
+	return !err ? UCODE_OK : UCODE_ERROR;
 }
 
 static enum ucode_state microcode_init_cpu(int cpu)
@@ -385,8 +418,12 @@ static enum ucode_state microcode_init_cpu(int cpu)
 	ustate = microcode_ops->request_microcode_fw(cpu, &microcode_pdev->dev);
 
 	if (ustate == UCODE_OK) {
+		int err;
+
 		pr_debug("CPU%d updated upon init\n", cpu);
-		apply_microcode_on_target(cpu);
+		err = apply_microcode_on_target(cpu);
+		if (err)
+			ustate = UCODE_ERROR;
 	}
 
 	return ustate;
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 0327e2b..6b87bd5 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -391,6 +391,7 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 	}
 
 	vfree(uci->mc);
+	uci->new_rev = new_rev;
 	uci->mc = (struct microcode_intel *)new_mc;
 
 	pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f4b9b80..98b5b5c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -68,6 +68,7 @@
 #include <linux/percpu.h>
 #include <linux/crash_dump.h>
 #include <linux/tboot.h>
+#include <linux/notifier.h>
 
 #include <video/edid.h>
 
@@ -205,6 +206,10 @@ struct cpuinfo_x86 boot_cpu_data __read_mostly = {
 EXPORT_SYMBOL(boot_cpu_data);
 #endif
 
+/*
+ * Lives here because the microcode stuff is modular.
+ */
+struct atomic_notifier_head microcode_notifier;
 
 #if !defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
 unsigned long mmu_cr4_features;


