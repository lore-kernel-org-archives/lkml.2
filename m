Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933272Ab1EXXEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:04:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:20484 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757778Ab1EXXEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:04:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,264,1304319600"; 
   d="scan'208";a="4213430"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/3] x86, intel: Output microcode revision
Date: Tue, 24 May 2011 16:03:28 -0700
Message-Id: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

I got a request to make it easier to determine the microcode update level
on Intel CPUs. This patch adds a new "cpu update" field to /proc/cpuinfo,
which I added at the end to minimize impact on parsers.

The update level is also outputed on fatal machine checks together
with the other CPUID model information.

I removed the respective code from the microcode update driver, it
just reads the field from cpu_data. Also when the microcode is updated
it fills in the new values too.

I had to add a memory barrier to native_cpuid to prevent it being
optimized away when the result is not used.

This turns out to clean up further code which already got this
information manually. This is done in followon patches.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/processor.h  |    5 ++++-
 arch/x86/kernel/cpu/intel.c       |   10 ++++++++++
 arch/x86/kernel/cpu/mcheck/mce.c  |    5 +++--
 arch/x86/kernel/cpu/proc.c        |    6 +++++-
 arch/x86/kernel/microcode_intel.c |    9 +++------
 5 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 4c25ab4..23b7e26 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -111,6 +111,8 @@ struct cpuinfo_x86 {
 	/* Index into per_cpu list: */
 	u16			cpu_index;
 #endif
+	/* CPU update signature */
+	u32			x86_cpu_update;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define X86_VENDOR_INTEL	0
@@ -179,7 +181,8 @@ static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 	      "=b" (*ebx),
 	      "=c" (*ecx),
 	      "=d" (*edx)
-	    : "0" (*eax), "2" (*ecx));
+	    : "0" (*eax), "2" (*ecx)
+	    : "memory");
 }
 
 static inline void load_cr3(pgd_t *pgdir)
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 1edf5ba..150623a 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -364,6 +364,16 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 
 	early_init_intel(c);
 
+	/* Determine CPU update level */
+	if (c->x86 >= 6 && !(cpu_has(c, X86_FEATURE_IA64))) {	
+		unsigned lo;
+
+		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
+		/* The CPUID 1 fills in the MSR */
+		cpuid_eax(1);
+		rdmsr(MSR_IA32_UCODE_REV, lo, c->x86_cpu_update);
+	}
+
 	intel_workarounds(c);
 
 	/*
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ff1ae9b..e93c41f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -220,8 +220,9 @@ static void print_mce(struct mce *m)
 		pr_cont("MISC %llx ", m->misc);
 
 	pr_cont("\n");
-	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
-		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid);
+	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x CPU-UPDATE %u\n",
+		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid, 
+		cpu_data(m->extcpu).x86_cpu_update);
 
 	/*
 	 * Print out human-readable details about the MCE error,
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 62ac8cb..cefcc27 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -132,8 +132,12 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 				seq_printf(m, " [%d]", i);
 		}
 	}
+	seq_printf(m, "\n");
 
-	seq_printf(m, "\n\n");
+	if (c->x86_cpu_update)
+		seq_printf(m, "cpu update\t: %u\n", c->x86_cpu_update);
+
+	seq_printf(m, "\n");
 
 	return 0;
 }
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 1a1b606..bb1fec6 100644
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
+	csig->rev = c->x86_cpu_update;
 	pr_info("CPU%d sig=0x%x, pf=0x%x, revision=0x%x\n",
 		cpu_num, csig->sig, csig->pf, csig->rev);
 
@@ -300,6 +295,7 @@ static int apply_microcode(int cpu)
 	struct ucode_cpu_info *uci;
 	unsigned int val[2];
 	int cpu_num;
+	struct cpuinfo_x86 *c = &cpu_data(cpu_num);
 
 	cpu_num = raw_smp_processor_id();
 	uci = ucode_cpu_info + cpu;
@@ -335,6 +331,7 @@ static int apply_microcode(int cpu)
 		(mc_intel->hdr.date >> 16) & 0xff);
 
 	uci->cpu_sig.rev = val[1];
+	c->x86_cpu_update = val[1];
 
 	return 0;
 }
-- 
1.7.4.4

