Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab2FLVZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:25:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:46499 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab2FLVZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:25:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="111331316"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: hpa@zytor.com, eranian@google.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] x86: Track minimum microcode revision globally v2
Date: Tue, 12 Jun 2012 14:25:49 -0700
Message-Id: <1339536350-10463-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For bug workarounds depending on microcode revisions we need to
know the minimum microcode revision shared by all CPUs.

This patch adds infrastructure to track this.

Every time microcode is updated we update a global variable for
the minimum microcode revision of all the CPUs in the system.
At boot time we use the lowest available microcode (and warn
if  they are inconsistent)

At CPU hotplug or S3 resume time there is a short race window
where something might run on the CPUs but before the microcode
update notifier runs. For the current workarounds that need this
this is acceptable and shouldn't be a problem.

Only tested on Intel CPUs, but should work for AMD too.

v2: Use boot_cpu_data.microcode to track minimum revision (H. Peter Anvin)
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/processor.h  |    2 +
 arch/x86/kernel/cpu/amd.c         |    2 +
 arch/x86/kernel/cpu/common.c      |   38 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/cpu.h         |    3 ++
 arch/x86/kernel/cpu/intel.c       |    2 +
 arch/x86/kernel/microcode_amd.c   |    1 +
 arch/x86/kernel/microcode_intel.c |    1 +
 7 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 39bc577..bc0d361 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -984,4 +984,6 @@ bool set_pm_idle_to_default(void);
 
 void stop_this_cpu(void *dummy);
 
+void update_min_microcode(struct cpuinfo_x86 *c);
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 146bb62..e3f9937 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -684,6 +684,8 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 	}
 
 	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
+
+	boot_update_min_microcode(c);
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6b9333b..cfc50e0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1168,6 +1168,44 @@ static void dbg_restore_debug_regs(void)
 #define dbg_restore_debug_regs()
 #endif /* ! CONFIG_KGDB */
 
+
+/*
+ * Track the minimum global microcode version.  On early bootup assume
+ * the BIOS set all CPUs to the same revision. If that's not the case
+ * some code may be already running assuming the newer revision, but
+ * there's not much we can do about that (but it's unlikely to be
+ * problem in early bootup)
+ */
+__cpuinit void boot_update_min_microcode(struct cpuinfo_x86 *c)
+{	
+	static int boot_min_microcode;
+
+	if (!boot_min_microcode) {
+		boot_min_microcode = c->microcode;
+		boot_cpu_data.microcode = c->microcode;
+	} else if (c->microcode < boot_min_microcode) {
+		pr_warn("CPU %d has lower microcode revision %x at boot than boot CPU (%x)\n",
+			smp_processor_id(), 
+			c->microcode,
+			boot_min_microcode);
+		boot_cpu_data.microcode = c->microcode;
+	}
+}
+
+void update_min_microcode(struct cpuinfo_x86 *c)
+{
+	int i;
+
+	for_each_online_cpu (i)
+		if (cpu_data(i).microcode < c->microcode)
+			return;
+	if (boot_cpu_data.microcode != c->microcode) {
+		boot_cpu_data.microcode = c->microcode;
+		pr_info("Minimum microcode revision updated to %x\n", c->microcode);
+	}
+}
+EXPORT_SYMBOL_GPL(update_min_microcode);
+
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
  * initialized (naturally) in the bootstrap process, such as the GDT
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 8bacc78..7f92040 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -34,4 +34,7 @@ extern const struct cpu_dev *const __x86_cpu_dev_start[],
 
 extern void get_cpu_cap(struct cpuinfo_x86 *c);
 extern void cpu_detect_cache_sizes(struct cpuinfo_x86 *c);
+
+extern void boot_update_min_microcode(struct cpuinfo_x86 *c);
+
 #endif /* ARCH_X86_CPU_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 3e6ff6c..d48a13c 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -54,6 +54,8 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 		/* Required by the SDM */
 		sync_core();
 		rdmsr(MSR_IA32_UCODE_REV, lower_word, c->microcode);
+
+		boot_update_min_microcode(c);
 	}
 
 	/*
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 8a2ce8f..b589c7a 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -215,6 +215,7 @@ static int apply_microcode_amd(int cpu)
 	pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
 	uci->cpu_sig.rev = rev;
 	c->microcode = rev;
+	update_min_microcode(c);
 
 	return 0;
 }
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 0327e2b..50afbb9 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -326,6 +326,7 @@ static int apply_microcode(int cpu)
 	uci->cpu_sig.rev = val[1];
 	c->microcode = val[1];
 
+	update_min_microcode(c);
 	return 0;
 }
 
-- 
1.7.7.6

