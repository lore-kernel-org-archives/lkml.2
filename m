Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab1JZPeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:34:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45775 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933239Ab1JZPeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:34:03 -0400
Date: Wed, 26 Oct 2011 17:32:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/microcode changes for v3.2
Message-ID: <20111026153227.GA31753@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-microcode-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-microcode-for-linus


out-of-topic modifications in x86-microcode-for-linus:
------------------------------------------------------
drivers/hwmon/coretemp.c           # ca8bc8d: coretemp: Get microcode revision 

 Thanks,

	Ingo

------------------>
Andi Kleen (3):
      x86, intel: Output microcode revision in /proc/cpuinfo
      x86, intel: Use c->microcode for Atom errata check
      coretemp: Get microcode revision from cpu_data

Borislav Petkov (2):
      x86, microcode: Correct microcode revision format
      x86, microcode, AMD: Add microcode revision to /proc/cpuinfo

Srivatsa S. Bhat (1):
      x86, microcode: Don't request microcode from userspace unnecessarily


 arch/x86/include/asm/processor.h  |    4 +++-
 arch/x86/kernel/cpu/amd.c         |    4 ++++
 arch/x86/kernel/cpu/intel.c       |   24 +++++++++++++-----------
 arch/x86/kernel/cpu/mcheck/mce.c  |    9 +++++++--
 arch/x86/kernel/cpu/proc.c        |    2 ++
 arch/x86/kernel/microcode_amd.c   |    5 +++--
 arch/x86/kernel/microcode_core.c  |    8 +++++++-
 arch/x86/kernel/microcode_intel.c |   14 +++++---------
 drivers/hwmon/coretemp.c          |   28 ++++------------------------
 9 files changed, 48 insertions(+), 50 deletions(-)

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
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index b13ed39..d898fab 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -412,6 +412,8 @@ static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 
 static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 {
+	u32 dummy;
+
 	early_init_amd_mc(c);
 
 	/*
@@ -442,6 +444,8 @@ static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
 	}
 #endif
 
+	rdmsr_safe(MSR_AMD64_PATCH_LEVEL, &c->microcode, &dummy);
+
 	/* We need to do the following only once */
 	if (c != &boot_cpu_data)
 		return;
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ed6086e..5231312 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -47,6 +47,15 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 
+	if (c->x86 >= 6 && !cpu_has(c, X86_FEATURE_IA64)) {
+		unsigned lower_word;
+
+		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
+		/* Required by the SDM */
+		sync_core();
+		rdmsr(MSR_IA32_UCODE_REV, lower_word, c->microcode);
+	}
+
 	/*
 	 * Atom erratum AAE44/AAF40/AAG38/AAH41:
 	 *
@@ -55,17 +64,10 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 	 * need the microcode to have already been loaded... so if it is
 	 * not, recommend a BIOS update and disable large pages.
 	 */
-	if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_mask <= 2) {
-		u32 ucode, junk;
-
-		wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-		sync_core();
-		rdmsr(MSR_IA32_UCODE_REV, junk, ucode);
-
-		if (ucode < 0x20e) {
-			printk(KERN_WARNING "Atom PSE erratum detected, BIOS microcode update recommended\n");
-			clear_cpu_cap(c, X86_FEATURE_PSE);
-		}
+	if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_mask <= 2 &&
+	    c->microcode < 0x20e) {
+		printk(KERN_WARNING "Atom PSE erratum detected, BIOS microcode update recommended\n");
+		clear_cpu_cap(c, X86_FEATURE_PSE);
 	}
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 08363b0..ad8d897 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -217,8 +217,13 @@ static void print_mce(struct mce *m)
 		pr_cont("MISC %llx ", m->misc);
 
 	pr_cont("\n");
-	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
-		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid);
+	/*
+	 * Note this output is parsed by external tools and old fields
+	 * should not be changed.
+	 */
+	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x microcode %x\n",
+		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid,
+		cpu_data(m->extcpu).microcode);
 
 	/*
 	 * Print out human-readable details about the MCE error,
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 62ac8cb..14b2314 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -85,6 +85,8 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		seq_printf(m, "stepping\t: %d\n", c->x86_mask);
 	else
 		seq_printf(m, "stepping\t: unknown\n");
+	if (c->microcode)
+		seq_printf(m, "microcode\t: 0x%x\n", c->microcode);
 
 	if (cpu_has(c, X86_FEATURE_TSC)) {
 		unsigned int freq = cpufreq_quick_get(cpu);
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 591be0e..d494799 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -74,14 +74,13 @@ static struct equiv_cpu_entry *equiv_cpu_table;
 static int collect_cpu_info_amd(int cpu, struct cpu_signature *csig)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	u32 dummy;
 
 	if (c->x86_vendor != X86_VENDOR_AMD || c->x86 < 0x10) {
 		pr_warning("CPU%d: family %d not supported\n", cpu, c->x86);
 		return -1;
 	}
 
-	rdmsr(MSR_AMD64_PATCH_LEVEL, csig->rev, dummy);
+	csig->rev = c->microcode;
 	pr_info("CPU%d: patch_level=0x%08x\n", cpu, csig->rev);
 
 	return 0;
@@ -130,6 +129,7 @@ static int apply_microcode_amd(int cpu)
 	int cpu_num = raw_smp_processor_id();
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
 	struct microcode_amd *mc_amd = uci->mc;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu_num != cpu);
@@ -150,6 +150,7 @@ static int apply_microcode_amd(int cpu)
 
 	pr_info("CPU%d: new patch_level=0x%08x\n", cpu, rev);
 	uci->cpu_sig.rev = rev;
+	c->microcode = rev;
 
 	return 0;
 }
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index f924280..f2d2a66 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -483,7 +483,13 @@ mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 		sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
 		pr_debug("CPU%d removed\n", cpu);
 		break;
-	case CPU_DEAD:
+
+	/*
+	 * When a CPU goes offline, don't free up or invalidate the copy of
+	 * the microcode in kernel memory, so that we can reuse it when the
+	 * CPU comes back online without unnecessarily requesting the userspace
+	 * for it again.
+	 */
 	case CPU_UP_CANCELED_FROZEN:
 		/* The CPU refused to come up during a system resume */
 		microcode_fini_cpu(cpu);
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
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 9323837..ce18c04 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -325,15 +325,6 @@ static int get_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
 	return adjust_tjmax(c, id, dev);
 }
 
-static void __devinit get_ucode_rev_on_cpu(void *edx)
-{
-	u32 eax;
-
-	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
-	sync_core();
-	rdmsr(MSR_IA32_UCODE_REV, eax, *(u32 *)edx);
-}
-
 static int create_name_attr(struct platform_data *pdata, struct device *dev)
 {
 	sysfs_attr_init(&pdata->name_attr.attr);
@@ -380,27 +371,16 @@ exit_free:
 static int __cpuinit chk_ucode_version(unsigned int cpu)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	int err;
-	u32 edx;
 
 	/*
 	 * Check if we have problem with errata AE18 of Core processors:
 	 * Readings might stop update when processor visited too deep sleep,
 	 * fixed for stepping D0 (6EC).
 	 */
-	if (c->x86_model == 0xe && c->x86_mask < 0xc) {
-		/* check for microcode update */
-		err = smp_call_function_single(cpu, get_ucode_rev_on_cpu,
-					       &edx, 1);
-		if (err) {
-			pr_err("Cannot determine microcode revision of "
-			       "CPU#%u (%d)!\n", cpu, err);
-			return -ENODEV;
-		} else if (edx < 0x39) {
-			pr_err("Errata AE18 not fixed, update BIOS or "
-			       "microcode of the CPU!\n");
-			return -ENODEV;
-		}
+	if (c->x86_model == 0xe && c->x86_mask < 0xc && c->microcode < 0x39) {
+		pr_err("Errata AE18 not fixed, update BIOS or "
+		       "microcode of the CPU!\n");
+		return -ENODEV;
 	}
 	return 0;
 }
