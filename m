Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab1H2XrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:47:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:62788 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab1H2XrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:47:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="43429485"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] x86, intel: Output microcode revision v4
Date: Mon, 29 Aug 2011 16:47:18 -0700
Message-Id: <1314661640-10991-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

I got a request to make it easier to determine the microcode update level
on Intel CPUs. This patch adds a new "microcode" field to /proc/cpuinfo.

The microcode level is also outputed on fatal machine checks together
with the other CPUID model information.

I removed the respective code from the microcode update driver, it
just reads the field from cpu_data. Also when the microcode is updated
it fills in the new values too.

I had to add a memory barrier to native_cpuid to prevent it being
optimized away when the result is not used.

This turns out to clean up further code which already got this
information manually. This is done in followon patches.

v2:  Lots of updates based on feedback.
v3:  Rename cpu_update to microcode. Misc changes from feedback.
v4:  minor updates. rebased.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/processor.h  |    4 +++-
 arch/x86/kernel/cpu/intel.c       |    9 +++++++++
 arch/x86/kernel/cpu/mcheck/mce.c  |    9 +++++++--
 arch/x86/kernel/cpu/proc.c        |    3 ++-
 arch/x86/kernel/microcode_intel.c |   14 +++++---------
 5 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 0d1171c..b650435 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -111,6 +111,7 @@ struct cpuinfo_x86 {
 	/* Index into per_cpu list: */
 	u16			cpu_index;
 #endif
+	u32			microcode;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define X86_VENDOR_INTEL	0
@@ -179,7 +180,8 @@ static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 	      "=b" (*ebx),
 	      "=c" (*ecx),
 	      "=d" (*edx)
-	    : "0" (*eax), "2" (*ecx));
+	    : "0" (*eax), "2" (*ecx)
+	    : "memory");
 }
 
 static inline void load_cr3(pgd_t *pgdir)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ed6086e..5c9670d 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -364,6 +364,15 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 	early_init_intel(c);
 
+	if (c->x86 >= 6 && !cpu_has(c, X86_FEATURE_IA64)) {
+		unsigned lower_word;
+
+		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
+		/* The CPUID 1 fills in the MSR as documented in the SDM */
+		cpuid_eax(1);
+		rdmsr(MSR_IA32_UCODE_REV, lower_word, c->microcode);
+	}
+
 	intel_workarounds(c);
 
 	/*
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 08363b0..b84b3cf 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -217,8 +217,13 @@ static void print_mce(struct mce *m)
 		pr_cont("MISC %llx ", m->misc);
 
 	pr_cont("\n");
-	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
-		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid);
+	/* 
+ 	 * Note this output is parsed by external tools and old fields
+ 	 * should not be changed.
+ 	 */
+	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x microcode %u\n",
+		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid,
+		cpu_data(m->extcpu).microcode);
 
 	/*
 	 * Print out human-readable details about the MCE error,
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 62ac8cb..48ac015 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -85,6 +85,8 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		seq_printf(m, "stepping\t: %d\n", c->x86_mask);
 	else
 		seq_printf(m, "stepping\t: unknown\n");
+	if (c->microcode)
+		seq_printf(m, "microcode\t: %u\n", c->microcode);
 
 	if (cpu_has(c, X86_FEATURE_TSC)) {
 		unsigned int freq = cpufreq_quick_get(cpu);
@@ -132,7 +134,6 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 				seq_printf(m, " [%d]", i);
 		}
 	}
-
 	seq_printf(m, "\n\n");
 
 	return 0;
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 1a1b606..3ca42d0 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -161,12 +161,7 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 		csig->pf = 1 << ((val[1] >> 18) & 7);
 	}
 
-	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-	/* see notes above for revision 1.07.  Apparent chip bug */
-	sync_core();
-	/* get the current revision from MSR 0x8B */
-	rdmsr(MSR_IA32_UCODE_REV, val[0], csig->rev);
-
+	csig->rev = c->microcode;
 	pr_info("CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
 		cpu_num, csig->sig, csig->pf, csig->rev);
 
@@ -299,9 +294,9 @@ static int apply_microcode(int cpu)
 	struct microcode_intel *mc_intel;
 	struct ucode_cpu_info *uci;
 	unsigned int val[2];
-	int cpu_num;
+	int cpu_num = raw_smp_processor_id();
+	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
 
-	cpu_num = raw_smp_processor_id();
 	uci = ucode_cpu_info + cpu;
 	mc_intel = uci->mc;
 
@@ -317,7 +312,7 @@ static int apply_microcode(int cpu)
 	      (unsigned long) mc_intel->bits >> 16 >> 16);
 	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
 
-	/* see notes above for revision 1.07.  Apparent chip bug */
+	/* As documented in the SDM: Do a CPUID 1 here */
 	sync_core();
 
 	/* get the current revision from MSR 0x8B */
@@ -335,6 +330,7 @@ static int apply_microcode(int cpu)
 		(mc_intel->hdr.date >> 16) & 0xff);
 
 	uci->cpu_sig.rev = val[1];
+	c->microcode = val[1];
 
 	return 0;
 }
-- 
1.7.4.4

