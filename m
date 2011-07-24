Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab1GXKdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 06:33:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:59199 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1GXKdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 06:33:37 -0400
Date: Sun, 24 Jul 2011 12:33:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: [ANNOUNCE] 3.0-rt3
Message-ID: <alpine.LFD.2.02.1107241223560.2702@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear RT Folks,

I'm pleased to announce the 3.0-rt3 release.

Changes versus 3.0-rt2:

  * Fix earlyprintk really

  * AMD NB fix for allocation in smp function call, reported by Ed

  * Disabled a few config options on RT which have known issues

Patch against 3.0 can be found here:

  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-3.0-rt3.patch.bz2

The split quilt queue is available at:

  http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0-rt3.tar.bz2

Delta patch below.

Thanks,

	tglx
----
 arch/x86/include/asm/amd_nb.h         |    6 +
 arch/x86/kernel/cpu/intel_cacheinfo.c |  121 +++++++++++-----------------------
 arch/x86/kernel/early_printk.c        |    2 
 drivers/net/Kconfig                   |    1 
 localversion-rt                       |    2 
 mm/Kconfig                            |    2 
 6 files changed, 51 insertions(+), 83 deletions(-)

Index: linux-2.6/arch/x86/kernel/early_printk.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/early_printk.c
+++ linux-2.6/arch/x86/kernel/early_printk.c
@@ -171,7 +171,7 @@ static struct console early_serial_conso
 
 static inline void early_console_register(struct console *con, int keep_early)
 {
-	if (early_console->index != -1) {
+	if (con->index != -1) {
 		printk(KERN_CRIT "ERROR: earlyprintk= %s already used\n",
 		       con->name);
 		return;
Index: linux-2.6/localversion-rt
===================================================================
--- linux-2.6.orig/localversion-rt
+++ linux-2.6/localversion-rt
@@ -1 +1 @@
--rt2
+-rt3
Index: linux-2.6/arch/x86/kernel/cpu/intel_cacheinfo.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ linux-2.6/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -151,28 +151,17 @@ union _cpuid4_leaf_ecx {
 	u32 full;
 };
 
-struct amd_l3_cache {
-	struct	 amd_northbridge *nb;
-	unsigned indices;
-	u8	 subcaches[4];
-};
-
-struct _cpuid4_info {
+struct _cpuid4_info_regs {
 	union _cpuid4_leaf_eax eax;
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
-	struct amd_l3_cache *l3;
-	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
+	struct amd_northbridge *nb;
 };
 
-/* subset of above _cpuid4_info w/o shared_cpu_map */
-struct _cpuid4_info_regs {
-	union _cpuid4_leaf_eax eax;
-	union _cpuid4_leaf_ebx ebx;
-	union _cpuid4_leaf_ecx ecx;
-	unsigned long size;
-	struct amd_l3_cache *l3;
+struct _cpuid4_info {
+	struct _cpuid4_info_regs base;
+	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
 };
 
 unsigned short			num_cache_leaves;
@@ -314,12 +303,13 @@ struct _cache_attr {
 /*
  * L3 cache descriptors
  */
-static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
+static void __cpuinit amd_calc_l3_indices(struct amd_northbridge *nb)
 {
+	struct amd_l3_cache *l3 = &nb->l3_cache;
 	unsigned int sc0, sc1, sc2, sc3;
 	u32 val = 0;
 
-	pci_read_config_dword(l3->nb->misc, 0x1C4, &val);
+	pci_read_config_dword(nb->misc, 0x1C4, &val);
 
 	/* calculate subcache sizes */
 	l3->subcaches[0] = sc0 = !(val & BIT(0));
@@ -333,33 +323,16 @@ static void __cpuinit amd_calc_l3_indice
 static void __cpuinit amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf,
 					int index)
 {
-	static struct amd_l3_cache *__cpuinitdata l3_caches;
 	int node;
 
 	/* only for L3, and not in virtualized environments */
-	if (index < 3 || amd_nb_num() == 0)
+	if (index < 3)
 		return;
 
-	/*
-	 * Strictly speaking, the amount in @size below is leaked since it is
-	 * never freed but this is done only on shutdown so it doesn't matter.
-	 */
-	if (!l3_caches) {
-		int size = amd_nb_num() * sizeof(struct amd_l3_cache);
-
-		l3_caches = kzalloc(size, GFP_ATOMIC);
-		if (!l3_caches)
-			return;
-	}
-
 	node = amd_get_nb_id(smp_processor_id());
-
-	if (!l3_caches[node].nb) {
-		l3_caches[node].nb = node_to_amd_nb(node);
-		amd_calc_l3_indices(&l3_caches[node]);
-	}
-
-	this_leaf->l3 = &l3_caches[node];
+	this_leaf->nb = node_to_amd_nb(node);
+	if (this_leaf->nb && !this_leaf->nb->l3_cache.indices)
+		amd_calc_l3_indices(this_leaf->nb);
 }
 
 /*
@@ -369,11 +342,11 @@ static void __cpuinit amd_init_l3_cache(
  *
  * @returns: the disabled index if used or negative value if slot free.
  */
-int amd_get_l3_disable_slot(struct amd_l3_cache *l3, unsigned slot)
+int amd_get_l3_disable_slot(struct amd_northbridge *nb, unsigned slot)
 {
 	unsigned int reg = 0;
 
-	pci_read_config_dword(l3->nb->misc, 0x1BC + slot * 4, &reg);
+	pci_read_config_dword(nb->misc, 0x1BC + slot * 4, &reg);
 
 	/* check whether this slot is activated already */
 	if (reg & (3UL << 30))
@@ -387,11 +360,10 @@ static ssize_t show_cache_disable(struct
 {
 	int index;
 
-	if (!this_leaf->l3 ||
-	    !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
+	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
 		return -EINVAL;
 
-	index = amd_get_l3_disable_slot(this_leaf->l3, slot);
+	index = amd_get_l3_disable_slot(this_leaf->base.nb, slot);
 	if (index >= 0)
 		return sprintf(buf, "%d\n", index);
 
@@ -408,7 +380,7 @@ show_cache_disable_##slot(struct _cpuid4
 SHOW_CACHE_DISABLE(0)
 SHOW_CACHE_DISABLE(1)
 
-static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
+static void amd_l3_disable_index(struct amd_northbridge *nb, int cpu,
 				 unsigned slot, unsigned long idx)
 {
 	int i;
@@ -421,10 +393,10 @@ static void amd_l3_disable_index(struct 
 	for (i = 0; i < 4; i++) {
 		u32 reg = idx | (i << 20);
 
-		if (!l3->subcaches[i])
+		if (!nb->l3_cache.subcaches[i])
 			continue;
 
-		pci_write_config_dword(l3->nb->misc, 0x1BC + slot * 4, reg);
+		pci_write_config_dword(nb->misc, 0x1BC + slot * 4, reg);
 
 		/*
 		 * We need to WBINVD on a core on the node containing the L3
@@ -434,7 +406,7 @@ static void amd_l3_disable_index(struct 
 		wbinvd_on_cpu(cpu);
 
 		reg |= BIT(31);
-		pci_write_config_dword(l3->nb->misc, 0x1BC + slot * 4, reg);
+		pci_write_config_dword(nb->misc, 0x1BC + slot * 4, reg);
 	}
 }
 
@@ -448,24 +420,24 @@ static void amd_l3_disable_index(struct 
  *
  * @return: 0 on success, error status on failure
  */
-int amd_set_l3_disable_slot(struct amd_l3_cache *l3, int cpu, unsigned slot,
+int amd_set_l3_disable_slot(struct amd_northbridge *nb, int cpu, unsigned slot,
 			    unsigned long index)
 {
 	int ret = 0;
 
 	/*  check if @slot is already used or the index is already disabled */
-	ret = amd_get_l3_disable_slot(l3, slot);
+	ret = amd_get_l3_disable_slot(nb, slot);
 	if (ret >= 0)
 		return -EINVAL;
 
-	if (index > l3->indices)
+	if (index > nb->l3_cache.indices)
 		return -EINVAL;
 
 	/* check whether the other slot has disabled the same index already */
-	if (index == amd_get_l3_disable_slot(l3, !slot))
+	if (index == amd_get_l3_disable_slot(nb, !slot))
 		return -EINVAL;
 
-	amd_l3_disable_index(l3, cpu, slot, index);
+	amd_l3_disable_index(nb, cpu, slot, index);
 
 	return 0;
 }
@@ -480,8 +452,7 @@ static ssize_t store_cache_disable(struc
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!this_leaf->l3 ||
-	    !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
+	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
 		return -EINVAL;
 
 	cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
@@ -489,7 +460,7 @@ static ssize_t store_cache_disable(struc
 	if (strict_strtoul(buf, 10, &val) < 0)
 		return -EINVAL;
 
-	err = amd_set_l3_disable_slot(this_leaf->l3, cpu, slot, val);
+	err = amd_set_l3_disable_slot(this_leaf->base.nb, cpu, slot, val);
 	if (err) {
 		if (err == -EEXIST)
 			printk(KERN_WARNING "L3 disable slot %d in use!\n",
@@ -518,7 +489,7 @@ static struct _cache_attr cache_disable_
 static ssize_t
 show_subcaches(struct _cpuid4_info *this_leaf, char *buf, unsigned int cpu)
 {
-	if (!this_leaf->l3 || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
 		return -EINVAL;
 
 	return sprintf(buf, "%x\n", amd_get_subcaches(cpu));
@@ -533,7 +504,7 @@ store_subcaches(struct _cpuid4_info *thi
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!this_leaf->l3 || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
 		return -EINVAL;
 
 	if (strict_strtoul(buf, 16, &val) < 0)
@@ -769,7 +740,7 @@ static void __cpuinit cache_shared_cpu_m
 		return;
 	}
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
-	num_threads_sharing = 1 + this_leaf->eax.split.num_threads_sharing;
+	num_threads_sharing = 1 + this_leaf->base.eax.split.num_threads_sharing;
 
 	if (num_threads_sharing == 1)
 		cpumask_set_cpu(cpu, to_cpumask(this_leaf->shared_cpu_map));
@@ -820,29 +791,19 @@ static void __cpuinit free_cache_attribu
 	for (i = 0; i < num_cache_leaves; i++)
 		cache_remove_shared_cpu_map(cpu, i);
 
-	kfree(per_cpu(ici_cpuid4_info, cpu)->l3);
 	kfree(per_cpu(ici_cpuid4_info, cpu));
 	per_cpu(ici_cpuid4_info, cpu) = NULL;
 }
 
-static int
-__cpuinit cpuid4_cache_lookup(int index, struct _cpuid4_info *this_leaf)
-{
-	struct _cpuid4_info_regs *leaf_regs =
-		(struct _cpuid4_info_regs *)this_leaf;
-
-	return cpuid4_cache_lookup_regs(index, leaf_regs);
-}
-
 static void __cpuinit get_cpu_leaves(void *_retval)
 {
 	int j, *retval = _retval, cpu = smp_processor_id();
 
 	/* Do cpuid and store the results */
 	for (j = 0; j < num_cache_leaves; j++) {
-		struct _cpuid4_info *this_leaf;
-		this_leaf = CPUID4_INFO_IDX(cpu, j);
-		*retval = cpuid4_cache_lookup(j, this_leaf);
+		struct _cpuid4_info *this_leaf = CPUID4_INFO_IDX(cpu, j);
+
+		*retval = cpuid4_cache_lookup_regs(j, &this_leaf->base);
 		if (unlikely(*retval < 0)) {
 			int i;
 
@@ -900,16 +861,16 @@ static ssize_t show_##file_name(struct _
 	return sprintf(buf, "%lu\n", (unsigned long)this_leaf->object + val); \
 }
 
-show_one_plus(level, eax.split.level, 0);
-show_one_plus(coherency_line_size, ebx.split.coherency_line_size, 1);
-show_one_plus(physical_line_partition, ebx.split.physical_line_partition, 1);
-show_one_plus(ways_of_associativity, ebx.split.ways_of_associativity, 1);
-show_one_plus(number_of_sets, ecx.split.number_of_sets, 1);
+show_one_plus(level, base.eax.split.level, 0);
+show_one_plus(coherency_line_size, base.ebx.split.coherency_line_size, 1);
+show_one_plus(physical_line_partition, base.ebx.split.physical_line_partition, 1);
+show_one_plus(ways_of_associativity, base.ebx.split.ways_of_associativity, 1);
+show_one_plus(number_of_sets, base.ecx.split.number_of_sets, 1);
 
 static ssize_t show_size(struct _cpuid4_info *this_leaf, char *buf,
 			 unsigned int cpu)
 {
-	return sprintf(buf, "%luK\n", this_leaf->size / 1024);
+	return sprintf(buf, "%luK\n", this_leaf->base.size / 1024);
 }
 
 static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
@@ -946,7 +907,7 @@ static inline ssize_t show_shared_cpu_li
 static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf,
 			 unsigned int cpu)
 {
-	switch (this_leaf->eax.split.type) {
+	switch (this_leaf->base.eax.split.type) {
 	case CACHE_TYPE_DATA:
 		return sprintf(buf, "Data\n");
 	case CACHE_TYPE_INST:
@@ -1135,7 +1096,7 @@ static int __cpuinit cache_add_dev(struc
 
 		ktype_cache.default_attrs = default_attrs;
 #ifdef CONFIG_AMD_NB
-		if (this_leaf->l3)
+		if (this_leaf->base.nb)
 			ktype_cache.default_attrs = amd_l3_attrs();
 #endif
 		retval = kobject_init_and_add(&(this_object->kobj),
Index: linux-2.6/arch/x86/include/asm/amd_nb.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/amd_nb.h
+++ linux-2.6/arch/x86/include/asm/amd_nb.h
@@ -19,9 +19,15 @@ extern int amd_numa_init(void);
 extern int amd_get_subcaches(int);
 extern int amd_set_subcaches(int, int);
 
+struct amd_l3_cache {
+	unsigned indices;
+	u8	 subcaches[4];
+};
+
 struct amd_northbridge {
 	struct pci_dev *misc;
 	struct pci_dev *link;
+	struct amd_l3_cache l3_cache;
 };
 
 struct amd_northbridge_info {
Index: linux-2.6/drivers/net/Kconfig
===================================================================
--- linux-2.6.orig/drivers/net/Kconfig
+++ linux-2.6/drivers/net/Kconfig
@@ -3410,6 +3410,7 @@ config NET_FC
 
 config NETCONSOLE
 	tristate "Network console logging support"
+	depends on !PREEMPT_RT_FULL
 	---help---
 	If you want to log kernel messages over the network, enable this.
 	See <file:Documentation/networking/netconsole.txt> for details.
Index: linux-2.6/mm/Kconfig
===================================================================
--- linux-2.6.orig/mm/Kconfig
+++ linux-2.6/mm/Kconfig
@@ -304,7 +304,7 @@ config NOMMU_INITIAL_TRIM_EXCESS
 
 config TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
-	depends on X86 && MMU
+	depends on X86 && MMU && !PREEMPT_RT_FULL
 	select COMPACTION
 	help
 	  Transparent Hugepages allows the kernel to use huge pages and
