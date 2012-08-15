Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2HOA1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 20:27:05 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:38491 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab2HOA1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 20:27:02 -0400
X-Sasl-enc: wRscxivI3Z7JzA9c02a284qlgieTRXQDW/AdOYbzAPm6 1344990420
Date: Tue, 14 Aug 2012 21:26:54 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Borislav Petkov <borislav.petkov@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [ 36/44] x86, microcode: Sanitize per-cpu microcode reloading
 interface
Message-ID: <20120815002654.GA11666@khazad-dum.debian.net>
References: <20120813220142.113186818@linuxfoundation.org>
 <20120813220145.337264645@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120813220145.337264645@linuxfoundation.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe the patch bellow, which was required on 3.2, will also be
necessary.

From: Kevin Winchester <kjwinchester@gmail.com>
Subject: [PATCH] x86: Simplify code by removing a !SMP #ifdefs from 'struct
 cpuinfo_x86'

commit 141168c36cdee3ff23d9c7700b0edc47cb65479f and
commit 3f806e50981825fa56a7f1938f24c0680816be45 upstream.

Several fields in struct cpuinfo_x86 were not defined for the
!SMP case, likely to save space.  However, those fields still
have some meaning for UP, and keeping them allows some #ifdef
removal from other files.  The additional size of the UP kernel
from this change is not significant enough to worry about
keeping up the distinction:

	   text    data     bss     dec     hex filename
	4737168	 506459	 972040	6215667	 5ed7f3	vmlinux.o.before
	4737444	 506459	 972040	6215943	 5ed907	vmlinux.o.after

for a difference of 276 bytes for an example UP config.

If someone wants those 276 bytes back badly then it should
be implemented in a cleaner way.

Signed-off-by: Kevin Winchester <kjwinchester@gmail.com>
Cc: Steffen Persvold <sp@numascale.com>
Link: http://lkml.kernel.org/r/1324428742-12498-1-git-send-email-kjwinchester@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/processor.h     |    2 --
 arch/x86/kernel/amd_nb.c             |    8 ++------
 arch/x86/kernel/cpu/amd.c            |    2 --
 arch/x86/kernel/cpu/common.c         |    5 -----
 arch/x86/kernel/cpu/intel.c          |    2 --
 arch/x86/kernel/cpu/mcheck/mce.c     |    2 --
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    5 +----
 arch/x86/kernel/cpu/proc.c           |    4 +---
 drivers/edac/sb_edac.c               |    2 --
 drivers/hwmon/coretemp.c             |    7 +++----
 10 files changed, 7 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index bb3ee36..f7c89e2 100644
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
index bae1efe..be16854 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -154,16 +154,14 @@ int amd_get_subcaches(int cpu)
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
 
@@ -172,7 +170,7 @@ int amd_set_subcaches(int cpu, int mask)
 	static unsigned int reset, ban;
 	struct amd_northbridge *nb = node_to_amd_nb(amd_get_nb_id(cpu));
 	unsigned int reg;
-	int cuid = 0;
+	int cuid;
 
 	if (!amd_nb_has_feature(AMD_NB_L3_PARTITIONING) || mask > 0xf)
 		return -EINVAL;
@@ -190,9 +188,7 @@ int amd_set_subcaches(int cpu, int mask)
 		pci_write_config_dword(nb->misc, 0x1b8, reg & ~0x180000);
 	}
 
-#ifdef CONFIG_SMP
 	cuid = cpu_data(cpu).compute_unit_id;
-#endif
 	mask <<= 4 * cuid;
 	mask |= (0xf ^ (1 << cuid)) << 26;
 
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 3524e1f..ff8557e 100644
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
index aa003b1..ca93cc7 100644
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
index b0f1271..3b67877 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -119,9 +119,7 @@ void mce_setup(struct mce *m)
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
index 445a61c..d4444be 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -65,11 +65,9 @@ struct threshold_bank {
 };
 static DEFINE_PER_CPU(struct threshold_bank * [NR_BANKS], threshold_banks);
 
-#ifdef CONFIG_SMP
 static unsigned char shared_bank[NR_BANKS] = {
 	0, 0, 0, 0, 1
 };
-#endif
 
 static DEFINE_PER_CPU(unsigned char, bank_map);	/* see which banks are on */
 
@@ -227,10 +225,9 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 
 			if (!block)
 				per_cpu(bank_map, cpu) |= (1 << bank);
-#ifdef CONFIG_SMP
+
 			if (shared_bank[bank] && c->cpu_core_id)
 				break;
-#endif
 
 			memset(&b, 0, sizeof(b));
 			b.cpu			= cpu;
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
index 18a1293..0db57b5 100644
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
index 0790c98..19b4412 100644
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
1.7.10


-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
