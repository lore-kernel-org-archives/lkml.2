Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab1BGRM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 12:12:29 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:2052 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab1BGRM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 12:12:27 -0500
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LG9BPT-02-JXW-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <mingo@elte.hu>
CC: <hpa@zytor.com>, <tglx@linutronix.de>, <Andreas.Herrmann3@amd.com>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 4/4] x86, amd: Support L3 Cache Partitioning on AMD family 0x15 CPUs
Date: Mon, 7 Feb 2011 18:10:39 +0100
Message-ID: <1297098639-431383-1-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20110127124756.GA16094@elte.hu>
References: <20110127124756.GA16094@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

L3 Cache Partitioning allows selecting which of the 4 L3 subcaches can
be used for evictions by the L2 cache of each compute unit. By writing a
4-bit hexadecimal mask into the the sysfs file /sys/devices/system/cpu/\
cpuX/cache/index3/subcaches, the user can set the enabled subcaches for
a CPU. The settings are directly read from and written to the hardware,
so there is no way to have contradicting settings for two CPUs belonging
to the same compute unit. Writing will always overwrite any previous
setting for a compute unit.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/amd_nb.h         |    3 +
 arch/x86/kernel/amd_nb.c              |   63 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/intel_cacheinfo.c |   73 +++++++++++++++++++++++++++-----
 3 files changed, 127 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 3e70700..423f11c 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -18,6 +18,8 @@ extern int amd_cache_northbridges(void);
 extern void amd_flush_garts(void);
 extern int amd_numa_init(unsigned long start_pfn, unsigned long end_pfn);
 extern int amd_scan_nodes(void);
+extern int amd_get_subcaches(int);
+extern int amd_set_subcaches(int, int);
 
 #ifdef CONFIG_NUMA_EMU
 extern void amd_fake_nodes(const struct bootnode *nodes, int nr_nodes);
@@ -38,6 +40,7 @@ extern struct amd_northbridge_info amd_northbridges;
 
 #define AMD_NB_GART			0x1
 #define AMD_NB_L3_INDEX_DISABLE		0x2
+#define AMD_NB_L3_PARTITIONING		0x4
 
 #ifdef CONFIG_AMD_NB
 
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 4ae9a96..bf79a4a 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -95,6 +95,10 @@ int amd_cache_northbridges(void)
 	if (boot_cpu_data.x86 == 0x15)
 		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
 
+	/* L3 cache partitioning is supported on family 0x15 */
+	if (boot_cpu_data.x86 == 0x15)
+		amd_northbridges.flags |= AMD_NB_L3_PARTITIONING;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(amd_cache_northbridges);
@@ -112,6 +116,65 @@ int __init early_is_amd_nb(u32 device)
 	return 0;
 }
 
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
+	return 0;
+}
+
 int amd_cache_gart(void)
 {
        int i;
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index ec2c19a..4017a61 100644
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
@@ -524,6 +527,41 @@ static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
 static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 		show_cache_disable_1, store_cache_disable_1);
 
+static ssize_t
+show_subcaches(struct _cpuid4_info *this_leaf, char *buf, unsigned int cpu)
+{
+	if (!this_leaf->l3 ||
+	    !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
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
+	if (!this_leaf->l3 ||
+	    !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
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
@@ -870,8 +908,8 @@ static DEFINE_PER_CPU(struct _index_kobject *, ici_index_kobject);
 #define INDEX_KOBJECT_PTR(x, y)		(&((per_cpu(ici_index_kobject, x))[y]))
 
 #define show_one_plus(file_name, object, val)				\
-static ssize_t show_##file_name						\
-			(struct _cpuid4_info *this_leaf, char *buf)	\
+static ssize_t show_##file_name(struct _cpuid4_info *this_leaf, char *buf, \
+				unsigned int cpu)			\
 {									\
 	return sprintf(buf, "%lu\n", (unsigned long)this_leaf->object + val); \
 }
@@ -882,7 +920,8 @@ show_one_plus(physical_line_partition, ebx.split.physical_line_partition, 1);
 show_one_plus(ways_of_associativity, ebx.split.ways_of_associativity, 1);
 show_one_plus(number_of_sets, ecx.split.number_of_sets, 1);
 
-static ssize_t show_size(struct _cpuid4_info *this_leaf, char *buf)
+static ssize_t show_size(struct _cpuid4_info *this_leaf, char *buf,
+			 unsigned int cpu)
 {
 	return sprintf(buf, "%luK\n", this_leaf->size / 1024);
 }
@@ -906,17 +945,20 @@ static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
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
@@ -974,6 +1016,9 @@ static struct attribute ** __cpuinit amd_l3_attrs(void)
 	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
 		n += 2;
 
+	if (amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		n += 1;
+
 	attrs = kzalloc(n * sizeof (struct attribute *), GFP_KERNEL);
 	if (attrs == NULL)
 		return attrs = default_attrs;
@@ -986,6 +1031,10 @@ static struct attribute ** __cpuinit amd_l3_attrs(void)
 		attrs[n++] = &cache_disable_1.attr;
 	}
 
+	if (amd_nb_has_feature(AMD_NB_L3_PARTITIONING)) {
+		attrs[n++] = &subcaches.attr;
+	}
+
 	return attrs;
 }
 #endif
@@ -998,7 +1047,7 @@ static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
 
 	ret = fattr->show ?
 		fattr->show(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
-			buf) :
+			buf, this_leaf->cpu) :
 		0;
 	return ret;
 }
@@ -1012,7 +1061,7 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
 
 	ret = fattr->store ?
 		fattr->store(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
-			buf, count) :
+			buf, count, this_leaf->cpu) :
 		0;
 	return ret;
 }
-- 
1.5.6.5


