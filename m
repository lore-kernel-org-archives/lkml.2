Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757675Ab2GNA6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 20:58:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:64292 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306Ab2GNA6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 20:58:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="177155437"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: eranian@google.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] x86: Do microcode updates at CPU_STARTING, not CPU_ONLINE v2
Date: Fri, 13 Jul 2012 17:58:14 -0700
Message-Id: <1342227494-24830-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1342227494-24830-1-git-send-email-andi@firstfloor.org>
References: <1342227494-24830-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Do microcode updates of resuming or newling plugged CPUs earlier
in CPU_STARTING instead of later when ONLINE. This prevents races
with parallel users who may need a microcode update to avoid some
problem.

Since we cannot request the microcode from udev at this stage,
try to grab the microcode from another CPU. This is also more efficient
because it avoids redundant loads. In addition to that
it avoids the need for separate paths for resume and CPU bootup.

This requires invalidating the microcodes on other CPUs on free.
Each CPU does this in parallel, so it's not a big problem. Each
CPU touches at most NR_CPUs memory locations.

When there is no good microcode available the update is delayed
until the update can be requested. In the normal cases it should
be available.

v2: Review updates
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/microcode_core.c  |   65 +++++++++++++++++++++++++------------
 arch/x86/kernel/microcode_intel.c |   13 +++++++-
 2 files changed, 56 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index d4f4d31..5bb4b7e 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -371,20 +371,7 @@ static void microcode_fini_cpu(int cpu)
 	uci->valid = 0;
 }
 
-static enum ucode_state microcode_resume_cpu(int cpu)
-{
-	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-
-	if (!uci->mc)
-		return UCODE_NFOUND;
-
-	pr_debug("CPU%d updated upon resume\n", cpu);
-	apply_microcode_on_target(cpu);
-
-	return UCODE_OK;
-}
-
-static enum ucode_state microcode_init_cpu(int cpu)
+static enum ucode_state microcode_init_cpu_late(int cpu)
 {
 	enum ucode_state ustate;
 
@@ -405,15 +392,44 @@ static enum ucode_state microcode_init_cpu(int cpu)
 	return ustate;
 }
 
-static enum ucode_state microcode_update_cpu(int cpu)
+/* Grab ucode from another CPU */
+
+static void clone_ucode_data(void)
+{
+	int cpu = smp_processor_id();
+	int i;
+
+	for_each_online_cpu (i) {
+		if (ucode_cpu_info[i].mc &&
+			ucode_cpu_info[i].valid &&
+			cpu_data(i).x86 == cpu_data(cpu).x86 &&
+			cpu_data(i).x86_model == cpu_data(cpu).x86_model) {
+			ucode_cpu_info[cpu].mc = ucode_cpu_info[i].mc;
+			break;
+		}
+	}
+}
+
+static void microcode_init_cpu_early(int cpu)
+{
+	clone_ucode_data();
+	/* We can request later when the CPU is online */
+	if (ucode_cpu_info[cpu].mc == NULL)
+		return;
+	if (microcode_ops->collect_cpu_info(cpu, &ucode_cpu_info[cpu].cpu_sig))
+		return;
+	if (microcode_ops->apply_microcode(smp_processor_id()))
+		pr_warn("CPU%d microcode update failed\n", cpu);
+}
+
+static enum ucode_state microcode_update_cpu_late(int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	enum ucode_state ustate;
 
-	if (uci->valid)
-		ustate = microcode_resume_cpu(cpu);
-	else
-		ustate = microcode_init_cpu(cpu);
+	/* Resume already done early */
+	if (!uci->valid)
+		ustate = microcode_init_cpu_late(cpu);
 
 	return ustate;
 }
@@ -431,7 +447,7 @@ static int mc_device_add(struct device *dev, struct subsys_interface *sif)
 	if (err)
 		return err;
 
-	if (microcode_init_cpu(cpu) == UCODE_ERROR)
+	if (microcode_init_cpu_late(cpu) == UCODE_ERROR)
 		return -EINVAL;
 
 	return err;
@@ -481,9 +497,16 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 
 	dev = get_cpu_device(cpu);
 	switch (action) {
+	case CPU_STARTING:
+	case CPU_STARTING_FROZEN:
+		microcode_init_cpu_early(cpu);
+		break;
+
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		microcode_update_cpu(cpu);
+		/* Retry again in case we couldn't request early */
+		if (cpu_data(cpu).microcode != ucode_cpu_info[cpu].cpu_sig.rev)
+			microcode_update_cpu_late(cpu);
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		pr_debug("CPU%d added\n", cpu);
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 0327e2b..899057b 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -329,6 +329,16 @@ static int apply_microcode(int cpu)
 	return 0;
 }
 
+static void invalidate_microcode(void *data)
+{
+	int i;
+
+	for_each_possible_cpu (i) {
+		if (ucode_cpu_info[i].mc == data)
+			ucode_cpu_info[i].mc = NULL;
+	}
+}
+
 static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 				int (*get_ucode_data)(void *, const void *, size_t))
 {
@@ -391,6 +401,7 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
 	}
 
 	vfree(uci->mc);
+	invalidate_microcode(uci->mc);
 	uci->mc = (struct microcode_intel *)new_mc;
 
 	pr_debug("CPU%d found a matching microcode update with version 0x%x (current=0x%x)\n",
@@ -444,7 +455,7 @@ static void microcode_fini_cpu(int cpu)
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
 	vfree(uci->mc);
-	uci->mc = NULL;
+	invalidate_microcode(uci->mc);
 }
 
 static struct microcode_ops microcode_intel_ops = {
-- 
1.7.7.6

