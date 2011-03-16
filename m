Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1CPQVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 12:21:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35797 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab1CPQVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 12:21:45 -0400
Date: Wed, 16 Mar 2011 17:21:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110316162137.GA13172@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
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

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
include/linux/pci_ids.h            # 41b2610: x86, amd: Extend AMD northbridge 

 Thanks,

	Ingo

------------------>
Andreas Herrmann (2):
      x86, amd: Normalize compute unit IDs on multi-node processors
      x86, quirk: Fix SB600 revision check

Boris Ostrovsky (1):
      x86, AMD: Set ARAT feature on AMD processors

Borislav Petkov (2):
      x86, amd: Initialize variable properly
      x86, amd-nb: Misc cleanliness fixes

Hans Rosenfeld (3):
      x86, amd: Enable L3 cache index disable on family 0x15
      x86, amd: Extend AMD northbridge caching code to support "Link Control" devices
      x86, amd: Support L3 Cache Partitioning on AMD family 0x15 CPUs

Jan Beulich (1):
      x86: Adjust section placement in AMD northbridge related code

Mathieu Desnoyers (1):
      x86: stop_machine_text_poke() should issue sync_core()


 arch/x86/include/asm/amd_nb.h         |   16 +++--
 arch/x86/kernel/alternative.c         |    7 ++-
 arch/x86/kernel/amd_nb.c              |  100 +++++++++++++++++++++++++++++----
 arch/x86/kernel/cpu/amd.c             |   14 ++++-
 arch/x86/kernel/cpu/intel_cacheinfo.c |   76 ++++++++++++++++++++-----
 arch/x86/kernel/early-quirks.c        |    7 ++-
 arch/x86/kernel/smpboot.c             |    1 +
 arch/x86/pci/amd_bus.c                |    2 +-
 include/linux/pci_ids.h               |    1 +
 9 files changed, 185 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 64dc82e..527fb96 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -9,15 +9,17 @@ struct amd_nb_bus_dev_range {
 	u8 dev_limit;
 };
 
-extern struct pci_device_id amd_nb_misc_ids[];
+extern const struct pci_device_id amd_nb_misc_ids[];
 extern const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[];
 struct bootnode;
 
-extern int early_is_amd_nb(u32 value);
+extern bool early_is_amd_nb(u32 value);
 extern int amd_cache_northbridges(void);
 extern void amd_flush_garts(void);
 extern int amd_numa_init(unsigned long start_pfn, unsigned long end_pfn);
 extern int amd_scan_nodes(void);
+extern int amd_get_subcaches(int);
+extern int amd_set_subcaches(int, int);
 
 #ifdef CONFIG_NUMA_EMU
 extern void amd_fake_nodes(const struct bootnode *nodes, int nr_nodes);
@@ -26,6 +28,7 @@ extern void amd_get_nodes(struct bootnode *nodes);
 
 struct amd_northbridge {
 	struct pci_dev *misc;
+	struct pci_dev *link;
 };
 
 struct amd_northbridge_info {
@@ -35,17 +38,18 @@ struct amd_northbridge_info {
 };
 extern struct amd_northbridge_info amd_northbridges;
 
-#define AMD_NB_GART			0x1
-#define AMD_NB_L3_INDEX_DISABLE		0x2
+#define AMD_NB_GART			BIT(0)
+#define AMD_NB_L3_INDEX_DISABLE		BIT(1)
+#define AMD_NB_L3_PARTITIONING		BIT(2)
 
 #ifdef CONFIG_AMD_NB
 
-static inline int amd_nb_num(void)
+static inline u16 amd_nb_num(void)
 {
 	return amd_northbridges.num;
 }
 
-static inline int amd_nb_has_feature(int feature)
+static inline bool amd_nb_has_feature(unsigned feature)
 {
 	return ((amd_northbridges.flags & feature) == feature);
 }
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 7038b95..4db3554 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -620,7 +620,12 @@ static int __kprobes stop_machine_text_poke(void *data)
 		flush_icache_range((unsigned long)p->addr,
 				   (unsigned long)p->addr + p->len);
 	}
-
+	/*
+	 * Intel Archiecture Software Developer's Manual section 7.1.3 specifies
+	 * that a core serializing instruction such as "cpuid" should be
+	 * executed on _each_ core before the new instruction is made visible.
+	 */
+	sync_core();
 	return 0;
 }
 
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 0a99f71..6563419 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -12,7 +12,7 @@
 
 static u32 *flush_words;
 
-struct pci_device_id amd_nb_misc_ids[] = {
+const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_MISC) },
@@ -20,6 +20,11 @@ struct pci_device_id amd_nb_misc_ids[] = {
 };
 EXPORT_SYMBOL(amd_nb_misc_ids);
 
+static struct pci_device_id amd_nb_link_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_LINK) },
+	{}
+};
+
 const struct amd_nb_bus_dev_range amd_nb_bus_dev_ranges[] __initconst = {
 	{ 0x00, 0x18, 0x20 },
 	{ 0xff, 0x00, 0x20 },
@@ -31,7 +36,7 @@ struct amd_northbridge_info amd_northbridges;
 EXPORT_SYMBOL(amd_northbridges);
 
 static struct pci_dev *next_northbridge(struct pci_dev *dev,
-					struct pci_device_id *ids)
+					const struct pci_device_id *ids)
 {
 	do {
 		dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
@@ -43,9 +48,9 @@ static struct pci_dev *next_northbridge(struct pci_dev *dev,
 
 int amd_cache_northbridges(void)
 {
-	int i = 0;
+	u16 i = 0;
 	struct amd_northbridge *nb;
-	struct pci_dev *misc;
+	struct pci_dev *misc, *link;
 
 	if (amd_nb_num())
 		return 0;
@@ -64,10 +69,12 @@ int amd_cache_northbridges(void)
 	amd_northbridges.nb = nb;
 	amd_northbridges.num = i;
 
-	misc = NULL;
+	link = misc = NULL;
 	for (i = 0; i != amd_nb_num(); i++) {
 		node_to_amd_nb(i)->misc = misc =
 			next_northbridge(misc, amd_nb_misc_ids);
+		node_to_amd_nb(i)->link = link =
+			next_northbridge(link, amd_nb_link_ids);
         }
 
 	/* some CPU families (e.g. family 0x11) do not support GART */
@@ -85,26 +92,95 @@ int amd_cache_northbridges(void)
 	     boot_cpu_data.x86_mask >= 0x1))
 		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
 
+	if (boot_cpu_data.x86 == 0x15)
+		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
+
+	/* L3 cache partitioning is supported on family 0x15 */
+	if (boot_cpu_data.x86 == 0x15)
+		amd_northbridges.flags |= AMD_NB_L3_PARTITIONING;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(amd_cache_northbridges);
 
-/* Ignores subdevice/subvendor but as far as I can figure out
-   they're useless anyways */
-int __init early_is_amd_nb(u32 device)
+/*
+ * Ignores subdevice/subvendor but as far as I can figure out
+ * they're useless anyways
+ */
+bool __init early_is_amd_nb(u32 device)
 {
-	struct pci_device_id *id;
+	const struct pci_device_id *id;
 	u32 vendor = device & 0xffff;
+
 	device >>= 16;
 	for (id = amd_nb_misc_ids; id->vendor; id++)
 		if (vendor == id->vendor && device == id->device)
-			return 1;
+			return true;
+	return false;
+}
+
+int amd_get_subcaches(int cpu)
+{
+	struct pci_dev *link = node_to_amd_nb(amd_get_nb_id(cpu))->link;
+	unsigned int mask;
+	int cuid = 0;
+
+	if (!amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		return 0;
+
+	pci_read_config_dword(link, 0x1d4, &mask);
+
+#ifdef CONFIG_SMP
+	cuid = cpu_data(cpu).compute_unit_id;
+#endif
+	return (mask >> (4 * cuid)) & 0xf;
+}
+
+int amd_set_subcaches(int cpu, int mask)
+{
+	static unsigned int reset, ban;
+	struct amd_northbridge *nb = node_to_amd_nb(amd_get_nb_id(cpu));
+	unsigned int reg;
+	int cuid = 0;
+
+	if (!amd_nb_has_feature(AMD_NB_L3_PARTITIONING) || mask > 0xf)
+		return -EINVAL;
+
+	/* if necessary, collect reset state of L3 partitioning and BAN mode */
+	if (reset == 0) {
+		pci_read_config_dword(nb->link, 0x1d4, &reset);
+		pci_read_config_dword(nb->misc, 0x1b8, &ban);
+		ban &= 0x180000;
+	}
+
+	/* deactivate BAN mode if any subcaches are to be disabled */
+	if (mask != 0xf) {
+		pci_read_config_dword(nb->misc, 0x1b8, &reg);
+		pci_write_config_dword(nb->misc, 0x1b8, reg & ~0x180000);
+	}
+
+#ifdef CONFIG_SMP
+	cuid = cpu_data(cpu).compute_unit_id;
+#endif
+	mask <<= 4 * cuid;
+	mask |= (0xf ^ (1 << cuid)) << 26;
+
+	pci_write_config_dword(nb->link, 0x1d4, mask);
+
+	/* reset BAN mode if L3 partitioning returned to reset state */
+	pci_read_config_dword(nb->link, 0x1d4, &reg);
+	if (reg == reset) {
+		pci_read_config_dword(nb->misc, 0x1b8, &reg);
+		reg &= ~0x180000;
+		pci_write_config_dword(nb->misc, 0x1b8, reg | ban);
+	}
+
 	return 0;
 }
 
-int amd_cache_gart(void)
+static int amd_cache_gart(void)
 {
-       int i;
+	u16 i;
 
        if (!amd_nb_has_feature(AMD_NB_GART))
                return 0;
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 7c7bedb..58f1b01 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -261,7 +261,7 @@ static int __cpuinit nearby_node(int apicid)
 #ifdef CONFIG_X86_HT
 static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 {
-	u32 nodes;
+	u32 nodes, cores_per_cu = 1;
 	u8 node_id;
 	int cpu = smp_processor_id();
 
@@ -276,6 +276,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 		/* get compute unit information */
 		smp_num_siblings = ((ebx >> 8) & 3) + 1;
 		c->compute_unit_id = ebx & 0xff;
+		cores_per_cu += ((ebx >> 8) & 3);
 	} else if (cpu_has(c, X86_FEATURE_NODEID_MSR)) {
 		u64 value;
 
@@ -288,15 +289,18 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
 	/* fixup multi-node processor information */
 	if (nodes > 1) {
 		u32 cores_per_node;
+		u32 cus_per_node;
 
 		set_cpu_cap(c, X86_FEATURE_AMD_DCM);
 		cores_per_node = c->x86_max_cores / nodes;
+		cus_per_node = cores_per_node / cores_per_cu;
 
 		/* store NodeID, use llc_shared_map to store sibling info */
 		per_cpu(cpu_llc_id, cpu) = node_id;
 
-		/* core id to be in range from 0 to (cores_per_node - 1) */
-		c->cpu_core_id = c->cpu_core_id % cores_per_node;
+		/* core id has to be in the [0 .. cores_per_node - 1] range */
+		c->cpu_core_id %= cores_per_node;
+		c->compute_unit_id %= cus_per_node;
 	}
 }
 #endif
@@ -594,6 +598,10 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 #endif
+
+	/* As a rule processors have APIC timer running in deep C states */
+	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+		set_cpu_cap(c, X86_FEATURE_ARAT);
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index ec2c19a..90cc675 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -304,8 +304,9 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 
 struct _cache_attr {
 	struct attribute attr;
-	ssize_t (*show)(struct _cpuid4_info *, char *);
-	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count);
+	ssize_t (*show)(struct _cpuid4_info *, char *, unsigned int);
+	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count,
+			 unsigned int);
 };
 
 #ifdef CONFIG_AMD_NB
@@ -400,7 +401,8 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 
 #define SHOW_CACHE_DISABLE(slot)					\
 static ssize_t								\
-show_cache_disable_##slot(struct _cpuid4_info *this_leaf, char *buf)	\
+show_cache_disable_##slot(struct _cpuid4_info *this_leaf, char *buf,	\
+			  unsigned int cpu)				\
 {									\
 	return show_cache_disable(this_leaf, buf, slot);		\
 }
@@ -512,7 +514,8 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 #define STORE_CACHE_DISABLE(slot)					\
 static ssize_t								\
 store_cache_disable_##slot(struct _cpuid4_info *this_leaf,		\
-			   const char *buf, size_t count)		\
+			   const char *buf, size_t count,		\
+			   unsigned int cpu)				\
 {									\
 	return store_cache_disable(this_leaf, buf, count, slot);	\
 }
@@ -524,6 +527,39 @@ static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
 static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 		show_cache_disable_1, store_cache_disable_1);
 
+static ssize_t
+show_subcaches(struct _cpuid4_info *this_leaf, char *buf, unsigned int cpu)
+{
+	if (!this_leaf->l3 || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		return -EINVAL;
+
+	return sprintf(buf, "%x\n", amd_get_subcaches(cpu));
+}
+
+static ssize_t
+store_subcaches(struct _cpuid4_info *this_leaf, const char *buf, size_t count,
+		unsigned int cpu)
+{
+	unsigned long val;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!this_leaf->l3 || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		return -EINVAL;
+
+	if (strict_strtoul(buf, 16, &val) < 0)
+		return -EINVAL;
+
+	if (amd_set_subcaches(cpu, val))
+		return -EINVAL;
+
+	return count;
+}
+
+static struct _cache_attr subcaches =
+	__ATTR(subcaches, 0644, show_subcaches, store_subcaches);
+
 #else	/* CONFIG_AMD_NB */
 #define amd_init_l3_cache(x, y)
 #endif /* CONFIG_AMD_NB */
@@ -532,9 +568,9 @@ static int
 __cpuinit cpuid4_cache_lookup_regs(int index,
 				   struct _cpuid4_info_regs *this_leaf)
 {
-	union _cpuid4_leaf_eax 	eax;
-	union _cpuid4_leaf_ebx 	ebx;
-	union _cpuid4_leaf_ecx 	ecx;
+	union _cpuid4_leaf_eax	eax;
+	union _cpuid4_leaf_ebx	ebx;
+	union _cpuid4_leaf_ecx	ecx;
 	unsigned		edx;
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
@@ -870,8 +906,8 @@ static DEFINE_PER_CPU(struct _index_kobject *, ici_index_kobject);
 #define INDEX_KOBJECT_PTR(x, y)		(&((per_cpu(ici_index_kobject, x))[y]))
 
 #define show_one_plus(file_name, object, val)				\
-static ssize_t show_##file_name						\
-			(struct _cpuid4_info *this_leaf, char *buf)	\
+static ssize_t show_##file_name(struct _cpuid4_info *this_leaf, char *buf, \
+				unsigned int cpu)			\
 {									\
 	return sprintf(buf, "%lu\n", (unsigned long)this_leaf->object + val); \
 }
@@ -882,7 +918,8 @@ show_one_plus(physical_line_partition, ebx.split.physical_line_partition, 1);
 show_one_plus(ways_of_associativity, ebx.split.ways_of_associativity, 1);
 show_one_plus(number_of_sets, ecx.split.number_of_sets, 1);
 
-static ssize_t show_size(struct _cpuid4_info *this_leaf, char *buf)
+static ssize_t show_size(struct _cpuid4_info *this_leaf, char *buf,
+			 unsigned int cpu)
 {
 	return sprintf(buf, "%luK\n", this_leaf->size / 1024);
 }
@@ -906,17 +943,20 @@ static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
 	return n;
 }
 
-static inline ssize_t show_shared_cpu_map(struct _cpuid4_info *leaf, char *buf)
+static inline ssize_t show_shared_cpu_map(struct _cpuid4_info *leaf, char *buf,
+					  unsigned int cpu)
 {
 	return show_shared_cpu_map_func(leaf, 0, buf);
 }
 
-static inline ssize_t show_shared_cpu_list(struct _cpuid4_info *leaf, char *buf)
+static inline ssize_t show_shared_cpu_list(struct _cpuid4_info *leaf, char *buf,
+					   unsigned int cpu)
 {
 	return show_shared_cpu_map_func(leaf, 1, buf);
 }
 
-static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf)
+static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf,
+			 unsigned int cpu)
 {
 	switch (this_leaf->eax.split.type) {
 	case CACHE_TYPE_DATA:
@@ -974,6 +1014,9 @@ static struct attribute ** __cpuinit amd_l3_attrs(void)
 	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
 		n += 2;
 
+	if (amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		n += 1;
+
 	attrs = kzalloc(n * sizeof (struct attribute *), GFP_KERNEL);
 	if (attrs == NULL)
 		return attrs = default_attrs;
@@ -986,6 +1029,9 @@ static struct attribute ** __cpuinit amd_l3_attrs(void)
 		attrs[n++] = &cache_disable_1.attr;
 	}
 
+	if (amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		attrs[n++] = &subcaches.attr;
+
 	return attrs;
 }
 #endif
@@ -998,7 +1044,7 @@ static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
 
 	ret = fattr->show ?
 		fattr->show(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
-			buf) :
+			buf, this_leaf->cpu) :
 		0;
 	return ret;
 }
@@ -1012,7 +1058,7 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
 
 	ret = fattr->store ?
 		fattr->store(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
-			buf, count) :
+			buf, count, this_leaf->cpu) :
 		0;
 	return ret;
 }
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 9efbdcc..3755ef4 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -159,7 +159,12 @@ static void __init ati_bugs_contd(int num, int slot, int func)
 	if (rev >= 0x40)
 		acpi_fix_pin2_polarity = 1;
 
-	if (rev > 0x13)
+	/*
+	 * SB600: revisions 0x11, 0x12, 0x13, 0x14, ...
+	 * SB700: revisions 0x39, 0x3a, ...
+	 * SB800: revisions 0x40, 0x41, ...
+	 */
+	if (rev >= 0x39)
 		return;
 
 	if (acpi_use_timer_override)
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 08776a9..1bfb1c6 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -414,6 +414,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 
 			if (cpu_has(c, X86_FEATURE_TOPOEXT)) {
 				if (c->phys_proc_id == o->phys_proc_id &&
+				    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i) &&
 				    c->compute_unit_id == o->compute_unit_id)
 					link_thread_siblings(cpu, i);
 			} else if (c->phys_proc_id == o->phys_proc_id &&
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index e27dffbb..026e493 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -350,7 +350,7 @@ static int __init early_fill_mp_bus_info(void)
 
 #define ENABLE_CF8_EXT_CFG      (1ULL << 46)
 
-static void enable_pci_io_ecs(void *unused)
+static void __cpuinit enable_pci_io_ecs(void *unused)
 {
 	u64 reg;
 	rdmsrl(MSR_AMD64_NB_CFG, reg);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3adb06e..580de67 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -518,6 +518,7 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
 #define PCI_DEVICE_ID_AMD_15H_NB_MISC	0x1603
+#define PCI_DEVICE_ID_AMD_15H_NB_LINK	0x1604
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
