Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab1LJBwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 20:52:20 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52486 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1LJBwS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 20:52:18 -0500
MIME-Version: 1.0
In-Reply-To: <20111209072244.GG24537@elte.hu>
References: <1323101246-2400-1-git-send-email-daniel@numascale-asia.com>
	<tip-44b111b519160e33fdc41eadb39af86a24707edf@git.kernel.org>
	<20111205203130.GA12364@elte.hu>
	<4EDD5D77.3030101@numascale.com>
	<20111206055023.GB1580@elte.hu>
	<CAELBVzBqNHsnRP=dt7nwFWoigfX4FF6nQio+P+Fz71xQY0qK4Q@mail.gmail.com>
	<20111209072244.GG24537@elte.hu>
Date: Fri, 9 Dec 2011 21:52:16 -0400
Message-ID: <CAELBVzAWtTXvc+R1LkHT23SLERsFL5zUh5=_JoizXjJ7s0k8OA@mail.gmail.com>
Subject: Re: [tip:x86/apic] x86: Add NumaChip support
From: Kevin Winchester <kjwinchester@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steffen Persvold <sp@numascale.com>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
        tglx@linutronix.de, daniel@numascale-asia.com,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 December 2011 03:22, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Kevin Winchester <kjwinchester@gmail.com> wrote:
>
>> On 6 December 2011 01:50, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> >
>> > Ideally i think c->phys_proc_id should should be available
>> > regardless of CONFIG_SMP or CONFIG_NUMA considerations - but
>> > that would be a wider change. (feel free to have a shot at it
>> > though, in addition to the fix above)
>> >
>>
>> If Steffen does not plan to do this additional cleanup, I
>> would give it a try.  You would likely prefer the changes
>> against -tip, correct?
>
> On a second thought, the !SMP block in processor.h::cpuinfo_x86
> is pretty self-contained and making it unconditional would
> increase UP kernel size by 4x5==20 bytes.
>
> I have not checked how many further simplifications this allows
> - if it's a really nice cleanup then i guess we could do it and
> keep the all-zeroes-and-ones default value on UP.
>
> The fields *do* make sense on UP as well.
>
> So it's a "try and see how it ends up" thing.
>

So I get the following (gmail-mangled) patch as a cleanup if the
fields are made available on UP.  Is it worth it?  I'll let you be the
judge.  One other thing I noticed that prevented a few more #ifdef
removals was the global smp_num_siblings variable defined in
smpboot.c.  This variable appears related to hyperthreading siblings
from what I can tell, but it gets used in ways related to the cpu
info.  Would it be possible to move this into a new field in struct
cpuinfo_x86?  It seems like a cpu-related property to me, not that I
can imagine there will ever be a processor architecture where
different cpus have different numbers of HT threads.

In any case, if you like the simple cleanup, I can resend with sign
off and no whitespace damage.  If you want me to go further, let me
know and I'll give it a shot.

 arch/x86/include/asm/processor.h     |    2 --
 arch/x86/kernel/amd_nb.c             |    8 ++------
 arch/x86/kernel/cpu/amd.c            |    2 --
 arch/x86/kernel/cpu/common.c         |    7 -------
 arch/x86/kernel/cpu/intel.c          |    2 --
 arch/x86/kernel/cpu/mcheck/mce.c     |    2 --
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    7 +------
 arch/x86/kernel/cpu/proc.c           |    4 +---
 drivers/edac/sb_edac.c               |    2 --
 drivers/hwmon/coretemp.c             |    6 ------
 10 files changed, 4 insertions(+), 38 deletions(-)

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
@@ -192,7 +191,6 @@ static void __cpuinit amd_k7_smp_check(struct
cpuinfo_x86 *c)

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
@@ -764,10 +762,7 @@ static void __cpuinit generic_identify(struct
cpuinfo_x86 *c)
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
 	pr_err("NUMA core number %d differs from configured core number
%d\n", node, c->phys_proc_id);
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
index 2af127d..e9c9d0a 100644
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
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c
b/arch/x86/kernel/cpu/mcheck/mce_amd.c
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

@@ -531,7 +528,6 @@ static __cpuinit int
threshold_create_bank(unsigned int cpu, unsigned int bank)

 	sprintf(name, "threshold_bank%i", bank);

-#ifdef CONFIG_SMP
 	if (cpu_data(cpu).cpu_core_id && shared_bank[bank]) {	/* symlink */
 		i = cpumask_first(cpu_llc_shared_mask(cpu));

@@ -558,7 +554,6 @@ static __cpuinit int
threshold_create_bank(unsigned int cpu, unsigned int bank)

 		goto out;
 	}
-#endif

 	b = kzalloc(sizeof(struct threshold_bank), GFP_KERNEL);
 	if (!b) {
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 14b2314..8022c66 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -64,12 +64,10 @@ static void show_cpuinfo_misc(struct seq_file *m,
struct cpuinfo_x86 *c)
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
index 7a402bf..88df489 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -1609,11 +1609,9 @@ static int sbridge_mce_check_error(struct
notifier_block *nb, unsigned long val,
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
index 104b376..ae8f826 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -57,15 +57,9 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
 #define MAX_CORE_DATA		(NUM_REAL_CORES + BASE_SYSFS_ATTR_NO)

-#ifdef CONFIG_SMP
 #define TO_PHYS_ID(cpu)		cpu_data(cpu).phys_proc_id
 #define TO_CORE_ID(cpu)		cpu_data(cpu).cpu_core_id
 #define for_each_sibling(i, cpu)	for_each_cpu(i, cpu_sibling_mask(cpu))
-#else
-#define TO_PHYS_ID(cpu)		(cpu)
-#define TO_CORE_ID(cpu)		(cpu)
-#define for_each_sibling(i, cpu)	for (i = 0; false; )
-#endif
 #define TO_ATTR_NO(cpu)		(TO_CORE_ID(cpu) + BASE_SYSFS_ATTR_NO)

 /*


If you are happy with the below, let
