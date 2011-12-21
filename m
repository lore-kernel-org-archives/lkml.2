Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab1LUAw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:52:29 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46306 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab1LUAw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:52:26 -0500
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Kevin Winchester <kjwinchester@gmail.com>,
        Steffen Persvold <sp@numascale.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Simplify code by allowing more of struct cpuinfo_x86 for the !SMP case
Date: Tue, 20 Dec 2011 20:52:22 -0400
Message-Id: <1324428742-12498-1-git-send-email-kjwinchester@gmail.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20111219184705.GA6271@elte.hu>
References: <20111219184705.GA6271@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several fields in struct cpuinfo_x86 were not defined for the !SMP
case, likely to save space.  However, those fields still have some
meaning for UP, and keeping them allows some #ifdef removal from
other files.  The additional size of the UP kernel from this
change is not significant enough to worry about keeping up the
distinction:

  text    data     bss     dec     hex filename
4737168	 506459	 972040	6215667	 5ed7f3	vmlinux.o.before
4737444	 506459	 972040	6215943	 5ed907	vmlinux.o.after

for a difference of 276 bytes for an example UP config.

If someone wants those 276 bytes back badly then it should
be implemented in a cleaner way.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
---

I believe this should correct the compilation error, although at the
cost of slightly less simplification. Unfortunately I didn't see a
place to insert a UP version of cpu_sibling_map().  Please let me
know if anyone sees a better way.

Also, if you want it as a separate fixup patch instead, let me know.

 arch/x86/include/asm/processor.h     |    2 --
 arch/x86/kernel/amd_nb.c             |    8 ++------
 arch/x86/kernel/cpu/amd.c            |    2 --
 arch/x86/kernel/cpu/common.c         |    7 -------
 arch/x86/kernel/cpu/intel.c          |    2 --
 arch/x86/kernel/cpu/mcheck/mce.c     |    2 --
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    7 +------
 arch/x86/kernel/cpu/proc.c           |    4 +---
 drivers/edac/sb_edac.c               |    2 --
 drivers/hwmon/coretemp.c             |    7 +++----
 10 files changed, 7 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index b650435..aa9088c 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -99,7 +99,6 @@ struct cpuinfo_x86 {
 	u16			apicid;
 	u16			initial_apicid;
 	u16			x86_clflush_size;
-#ifdef CONFIG_SMP
 	/* number of cores as seen by the OS: */
 	u16			booted_cores;
 	/* Physical processor id: */
@@ -110,7 +109,6 @@ struct cpuinfo_x86 {
 	u8			compute_unit_id;
 	/* Index into per_cpu list: */
 	u16			cpu_index;
-#endif
 	u32			microcode;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 4c39baa..013c181 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -123,16 +123,14 @@ int amd_get_subcaches(int cpu)
 {
 	struct pci_dev *link = node_to_amd_nb(amd_get_nb_id(cpu))->link;
 	unsigned int mask;
-	int cuid = 0;
+	int cuid;
 
 	if (!amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
 		return 0;
 
 	pci_read_config_dword(link, 0x1d4, &mask);
 
-#ifdef CONFIG_SMP
 	cuid = cpu_data(cpu).compute_unit_id;
-#endif
 	return (mask >> (4 * cuid)) & 0xf;
 }
 
@@ -141,7 +139,7 @@ int amd_set_subcaches(int cpu, int mask)
 	static unsigned int reset, ban;
 	struct amd_northbridge *nb = node_to_amd_nb(amd_get_nb_id(cpu));
 	unsigned int reg;
-	int cuid = 0;
+	int cuid;
 
 	if (!amd_nb_has_feature(AMD_NB_L3_PARTITIONING) || mask > 0xf)
 		return -EINVAL;
@@ -159,9 +157,7 @@ int amd_set_subcaches(int cpu, int mask)
 		pci_write_config_dword(nb->misc, 0x1b8, reg & ~0x180000);
 	}
 
-#ifdef CONFIG_SMP
 	cuid = cpu_data(cpu).compute_unit_id;
-#endif
 	mask <<= 4 * cuid;
 	mask |= (0xf ^ (1 << cuid)) << 26;
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ef21bdc..f4773f4 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -148,7 +148,6 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 
 static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_SMP
 	/* calling is from identify_secondary_cpu() ? */
 	if (!c->cpu_index)
 		return;
@@ -192,7 +191,6 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
 
 valid_k7:
 	;
-#endif
 }
 
 static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a70bd5b..850f296 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -676,9 +676,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 	if (this_cpu->c_early_init)
 		this_cpu->c_early_init(c);
 
-#ifdef CONFIG_SMP
 	c->cpu_index = 0;
-#endif
 	filter_cpuid_features(c, false);
 
 	setup_smep(c);
@@ -764,10 +762,7 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 		c->apicid = c->initial_apicid;
 # endif
 #endif
-
-#ifdef CONFIG_X86_HT
 		c->phys_proc_id = c->initial_apicid;
-#endif
 	}
 
 	setup_smep(c);
@@ -1146,9 +1141,7 @@ static void dbg_restore_debug_regs(void)
  */
 void __cpuinit x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node)
 {
-#ifdef CONFIG_NUMA
 	pr_err("NUMA core number %d differs from configured core number %d\n", node, c->phys_proc_id);
-#endif
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 5231312..3e6ff6c 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -181,7 +181,6 @@ static void __cpuinit trap_init_f00f_bug(void)
 
 static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_SMP
 	/* calling is from identify_secondary_cpu() ? */
 	if (!c->cpu_index)
 		return;
@@ -198,7 +197,6 @@ static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
 		WARN_ONCE(1, "WARNING: SMP operation may be unreliable"
 				    "with B stepping processors.\n");
 	}
-#endif
 }
 
 static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5be2464..cbe82b5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -118,9 +118,7 @@ void mce_setup(struct mce *m)
 	m->time = get_seconds();
 	m->cpuvendor = boot_cpu_data.x86_vendor;
 	m->cpuid = cpuid_eax(1);
-#ifdef CONFIG_SMP
 	m->socketid = cpu_data(m->extcpu).phys_proc_id;
-#endif
 	m->apicid = cpu_data(m->extcpu).initial_apicid;
 	rdmsrl(MSR_IA32_MCG_CAP, m->mcgcap);
 }
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index f547421..1d76872 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -64,11 +64,9 @@ struct threshold_bank {
 };
 static DEFINE_PER_CPU(struct threshold_bank * [NR_BANKS], threshold_banks);
 
-#ifdef CONFIG_SMP
 static unsigned char shared_bank[NR_BANKS] = {
 	0, 0, 0, 0, 1
 };
-#endif
 
 static DEFINE_PER_CPU(unsigned char, bank_map);	/* see which banks are on */
 
@@ -202,10 +200,9 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 
 			if (!block)
 				per_cpu(bank_map, cpu) |= (1 << bank);
-#ifdef CONFIG_SMP
 			if (shared_bank[bank] && c->cpu_core_id)
 				break;
-#endif
+
 			offset = setup_APIC_mce(offset,
 						(high & MASK_LVTOFF_HI) >> 20);
 
@@ -531,7 +528,6 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 	sprintf(name, "threshold_bank%i", bank);
 
-#ifdef CONFIG_SMP
 	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
 		i = cpumask_first(cpu_llc_shared_mask(cpu));
 
@@ -558,7 +554,6 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 
 		goto out;
 	}
-#endif
 
 	b = kzalloc(sizeof(struct threshold_bank), GFP_KERNEL);
 	if (!b) {
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 14b2314..8022c66 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -64,12 +64,10 @@ static void show_cpuinfo_misc(struct seq_file *m, struct cpuinfo_x86 *c)
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
 	struct cpuinfo_x86 *c = v;
-	unsigned int cpu = 0;
+	unsigned int cpu;
 	int i;
 
-#ifdef CONFIG_SMP
 	cpu = c->cpu_index;
-#endif
 	seq_printf(m, "processor\t: %u\n"
 		   "vendor_id\t: %s\n"
 		   "cpu family\t: %d\n"
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 965bc0c..1dc118d 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1609,11 +1609,9 @@ static int sbridge_mce_check_error(struct notifier_block *nb, unsigned long val,
 		mce->cpuvendor, mce->cpuid, mce->time,
 		mce->socketid, mce->apicid);
 
-#ifdef CONFIG_SMP
 	/* Only handle if it is the right mc controller */
 	if (cpu_data(mce->cpu).phys_proc_id != pvt->sbridge_dev->mc)
 		return NOTIFY_DONE;
-#endif
 
 	smp_rmb();
 	if ((pvt->mce_out + 1) % MCE_LOG_LEN == pvt->mce_in) {
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 104b376..1fdef88 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -57,16 +57,15 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
 #define MAX_CORE_DATA		(NUM_REAL_CORES + BASE_SYSFS_ATTR_NO)
 
-#ifdef CONFIG_SMP
 #define TO_PHYS_ID(cpu)		cpu_data(cpu).phys_proc_id
 #define TO_CORE_ID(cpu)		cpu_data(cpu).cpu_core_id
+#define TO_ATTR_NO(cpu)		(TO_CORE_ID(cpu) + BASE_SYSFS_ATTR_NO)
+
+#ifdef CONFIG_SMP
 #define for_each_sibling(i, cpu)	for_each_cpu(i, cpu_sibling_mask(cpu))
 #else
-#define TO_PHYS_ID(cpu)		(cpu)
-#define TO_CORE_ID(cpu)		(cpu)
 #define for_each_sibling(i, cpu)	for (i = 0; false; )
 #endif
-#define TO_ATTR_NO(cpu)		(TO_CORE_ID(cpu) + BASE_SYSFS_ATTR_NO)
 
 /*
  * Per-Core Temperature Data
-- 
1.7.8

