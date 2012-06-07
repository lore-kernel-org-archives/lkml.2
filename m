Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412Ab2FGQqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 12:46:50 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:28240
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758323Ab2FGQqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 12:46:19 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M59AKY-01-047-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 2/5] x86, cacheinfo: it's not only cpuid 4 anymore
Date: Thu, 7 Jun 2012 18:45:56 +0200
Message-ID: <1339087559-32604-2-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1339087559-32604-1-git-send-email-hans.rosenfeld@amd.com>
References: <1339087559-32604-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the code is now no longer only used for cpuid leaf 4 or an
emulation of it, rename everything that isn't really specific to cpuid 4
to cpuid_cacheinfo and the like. Also, rename cache_shared_cpu_map_setup()
to cache_shared_intel_cpu_map_setup() and move the vendor check into a
wrapper function. Pass default_attrs as argument to amd_l3_attrs().
This should make the code a bit less confusing and help splitting
intel_cacheinfo.c in a later patch.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |  213 +++++++++++++++++----------------
 1 files changed, 112 insertions(+), 101 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 0973ca1..14eb6a5 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -122,7 +122,7 @@ enum _cache_type {
 	CACHE_TYPE_UNIFIED = 3
 };
 
-union _cpuid4_leaf_eax {
+union _cpuid_cacheinfo_eax {
 	struct {
 		enum _cache_type	type:5;
 		unsigned int		level:3;
@@ -135,7 +135,7 @@ union _cpuid4_leaf_eax {
 	u32 full;
 };
 
-union _cpuid4_leaf_ebx {
+union _cpuid_cacheinfo_ebx {
 	struct {
 		unsigned int		coherency_line_size:12;
 		unsigned int		physical_line_partition:10;
@@ -144,23 +144,23 @@ union _cpuid4_leaf_ebx {
 	u32 full;
 };
 
-union _cpuid4_leaf_ecx {
+union _cpuid_cacheinfo_ecx {
 	struct {
 		unsigned int		number_of_sets:32;
 	} split;
 	u32 full;
 };
 
-struct _cpuid4_info_regs {
-	union _cpuid4_leaf_eax eax;
-	union _cpuid4_leaf_ebx ebx;
-	union _cpuid4_leaf_ecx ecx;
+struct _cpuid_cacheinfo_regs {
+	union _cpuid_cacheinfo_eax eax;
+	union _cpuid_cacheinfo_ebx ebx;
+	union _cpuid_cacheinfo_ecx ecx;
 	unsigned long size;
 	struct amd_northbridge *nb;
 };
 
-struct _cpuid4_info {
-	struct _cpuid4_info_regs base;
+struct _cpuid_cacheinfo {
+	struct _cpuid_cacheinfo_regs base;
 	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
 };
 
@@ -221,9 +221,9 @@ static const unsigned char __cpuinitconst levels[] = { 1, 1, 2, 3 };
 static const unsigned char __cpuinitconst types[] = { 1, 2, 3, 3 };
 
 static void __cpuinit
-amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
-		     union _cpuid4_leaf_ebx *ebx,
-		     union _cpuid4_leaf_ecx *ecx)
+amd_cpuid4(int leaf, union _cpuid_cacheinfo_eax *eax,
+		     union _cpuid_cacheinfo_ebx *ebx,
+		     union _cpuid_cacheinfo_ecx *ecx)
 {
 	unsigned dummy;
 	unsigned line_size, lines_per_tag, assoc, size_in_kb;
@@ -279,7 +279,8 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 	eax->split.type = types[leaf];
 	eax->split.level = levels[leaf];
 	eax->split.num_threads_sharing = 0;
-	eax->split.num_cores_on_die = __this_cpu_read(cpu_info.x86_max_cores) - 1;
+	eax->split.num_cores_on_die =
+		__this_cpu_read(cpu_info.x86_max_cores) - 1;
 
 
 	if (assoc == 0xffff)
@@ -293,8 +294,8 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 
 struct _cache_attr {
 	struct attribute attr;
-	ssize_t (*show)(struct _cpuid4_info *, char *, unsigned int);
-	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count,
+	ssize_t (*show)(struct _cpuid_cacheinfo *, char *, unsigned int);
+	ssize_t (*store)(struct _cpuid_cacheinfo *, const char *, size_t count,
 			 unsigned int);
 };
 
@@ -326,7 +327,8 @@ static void __cpuinit amd_calc_l3_indices(struct amd_northbridge *nb)
 	l3->indices = (max(max3(sc0, sc1, sc2), sc3) << 10) - 1;
 }
 
-static void __cpuinit amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf, int index)
+static void __cpuinit amd_init_l3_cache(struct _cpuid_cacheinfo_regs *this_leaf,
+					int index)
 {
 	int node;
 
@@ -360,7 +362,7 @@ int amd_get_l3_disable_slot(struct amd_northbridge *nb, unsigned slot)
 	return -1;
 }
 
-static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
+static ssize_t show_cache_disable(struct _cpuid_cacheinfo *this_leaf, char *buf,
 				  unsigned int slot)
 {
 	int index;
@@ -377,7 +379,7 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 
 #define SHOW_CACHE_DISABLE(slot)					\
 static ssize_t								\
-show_cache_disable_##slot(struct _cpuid4_info *this_leaf, char *buf,	\
+show_cache_disable_##slot(struct _cpuid_cacheinfo *this_leaf, char *buf,\
 			  unsigned int cpu)				\
 {									\
 	return show_cache_disable(this_leaf, buf, slot);		\
@@ -447,7 +449,7 @@ int amd_set_l3_disable_slot(struct amd_northbridge *nb, int cpu, unsigned slot,
 	return 0;
 }
 
-static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
+static ssize_t store_cache_disable(struct _cpuid_cacheinfo *this_leaf,
 				  const char *buf, size_t count,
 				  unsigned int slot)
 {
@@ -477,7 +479,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 
 #define STORE_CACHE_DISABLE(slot)					\
 static ssize_t								\
-store_cache_disable_##slot(struct _cpuid4_info *this_leaf,		\
+store_cache_disable_##slot(struct _cpuid_cacheinfo *this_leaf,		\
 			   const char *buf, size_t count,		\
 			   unsigned int cpu)				\
 {									\
@@ -492,7 +494,7 @@ static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 		show_cache_disable_1, store_cache_disable_1);
 
 static ssize_t
-show_subcaches(struct _cpuid4_info *this_leaf, char *buf, unsigned int cpu)
+show_subcaches(struct _cpuid_cacheinfo *this_leaf, char *buf, unsigned int cpu)
 {
 	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
 		return -EINVAL;
@@ -501,8 +503,8 @@ show_subcaches(struct _cpuid4_info *this_leaf, char *buf, unsigned int cpu)
 }
 
 static ssize_t
-store_subcaches(struct _cpuid4_info *this_leaf, const char *buf, size_t count,
-		unsigned int cpu)
+store_subcaches(struct _cpuid_cacheinfo *this_leaf, const char *buf,
+		size_t count, unsigned int cpu)
 {
 	unsigned long val;
 
@@ -529,12 +531,12 @@ static struct _cache_attr subcaches =
 #endif /* CONFIG_AMD_NB */
 
 static int
-__cpuinit cpuid4_cache_lookup_regs(int index,
-				   struct _cpuid4_info_regs *this_leaf)
+__cpuinit cpuid_cacheinfo_lookup_regs(int index,
+				      struct _cpuid_cacheinfo_regs *this_leaf)
 {
-	union _cpuid4_leaf_eax	eax;
-	union _cpuid4_leaf_ebx	ebx;
-	union _cpuid4_leaf_ecx	ecx;
+	union _cpuid_cacheinfo_eax	eax;
+	union _cpuid_cacheinfo_ebx	ebx;
+	union _cpuid_cacheinfo_ecx	ecx;
 	unsigned		edx;
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
@@ -564,7 +566,7 @@ __cpuinit cpuid4_cache_lookup_regs(int index,
 static int __cpuinit find_num_cache_leaves(void)
 {
 	unsigned int		eax, ebx, ecx, edx;
-	union _cpuid4_leaf_eax	cache_eax;
+	union _cpuid_cacheinfo_eax	cache_eax;
 	int 			i = -1;
 
 	do {
@@ -601,10 +603,10 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 		 * parameters cpuid leaf to find the cache details
 		 */
 		for (i = 0; i < num_cache_leaves; i++) {
-			struct _cpuid4_info_regs this_leaf;
+			struct _cpuid_cacheinfo_regs this_leaf;
 			int retval;
 
-			retval = cpuid4_cache_lookup_regs(i, &this_leaf);
+			retval = cpuid_cacheinfo_lookup_regs(i, &this_leaf);
 			if (retval >= 0) {
 				switch (this_leaf.eax.split.level) {
 				case 1:
@@ -723,25 +725,25 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 
 #ifdef CONFIG_SYSFS
 
-/* pointer to _cpuid4_info array (for each cache leaf) */
-static DEFINE_PER_CPU(struct _cpuid4_info *, ici_cpuid4_info);
-#define CPUID4_INFO_IDX(x, y)	(&((per_cpu(ici_cpuid4_info, x))[y]))
+/* pointer to _cpuid_cacheinfo array (for each cache leaf) */
+static DEFINE_PER_CPU(struct _cpuid_cacheinfo *, ci_cpuid_cacheinfo);
+#define CPUID_CACHEINFO_IDX(x, y)	(&((per_cpu(ci_cpuid_cacheinfo, x))[y]))
 
 #ifdef CONFIG_SMP
 
 static int __cpuinit cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
 {
-	struct _cpuid4_info *this_leaf;
+	struct _cpuid_cacheinfo *this_leaf;
 	int i, sibling;
 
 	if (cpu_has_topoext) {
 		unsigned int apicid = cpu_data(cpu).apicid;
 		int nshared, first;
 
-		if (!per_cpu(ici_cpuid4_info, cpu))
+		if (!per_cpu(ci_cpuid_cacheinfo, cpu))
 			return 0;
 
-		this_leaf = CPUID4_INFO_IDX(cpu, index);
+		this_leaf = CPUID_CACHEINFO_IDX(cpu, index);
 		nshared = 1 + this_leaf->base.eax.split.num_threads_sharing;
 		first = apicid - apicid % nshared;
 
@@ -750,10 +752,10 @@ static int __cpuinit cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
 			    cpu_data(i).apicid >= first + nshared)
 				continue;
 
-			if (!per_cpu(ici_cpuid4_info, i))
+			if (!per_cpu(ci_cpuid_cacheinfo, i))
 				continue;
 
-			this_leaf = CPUID4_INFO_IDX(i, index);
+			this_leaf = CPUID_CACHEINFO_IDX(i, index);
 			for_each_online_cpu(sibling) {
 				if (cpu_data(sibling).apicid < first ||
 				    cpu_data(sibling).apicid >= first + nshared)
@@ -764,9 +766,9 @@ static int __cpuinit cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
 		}
 	} else if (index == 3) {
 		for_each_cpu(i, cpu_llc_shared_mask(cpu)) {
-			if (!per_cpu(ici_cpuid4_info, i))
+			if (!per_cpu(ci_cpuid_cacheinfo, i))
 				continue;
-			this_leaf = CPUID4_INFO_IDX(i, index);
+			this_leaf = CPUID_CACHEINFO_IDX(i, index);
 			for_each_cpu(sibling, cpu_llc_shared_mask(cpu)) {
 				if (!cpu_online(sibling))
 					continue;
@@ -780,19 +782,14 @@ static int __cpuinit cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
 	return 1;
 }
 
-static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
+static void __cpuinit cache_shared_intel_cpu_map_setup(unsigned int cpu, int index)
 {
-	struct _cpuid4_info *this_leaf, *sibling_leaf;
+	struct _cpuid_cacheinfo *this_leaf, *sibling_leaf;
 	unsigned long num_threads_sharing;
 	int index_msb, i;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	if (c->x86_vendor == X86_VENDOR_AMD) {
-		if (cache_shared_amd_cpu_map_setup(cpu, index))
-			return;
-	}
-
-	this_leaf = CPUID4_INFO_IDX(cpu, index);
+	this_leaf = CPUID_CACHEINFO_IDX(cpu, index);
 	num_threads_sharing = 1 + this_leaf->base.eax.split.num_threads_sharing;
 
 	if (num_threads_sharing == 1)
@@ -805,9 +802,9 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
 			    c->apicid >> index_msb) {
 				cpumask_set_cpu(i,
 					to_cpumask(this_leaf->shared_cpu_map));
-				if (i != cpu && per_cpu(ici_cpuid4_info, i))  {
+				if (i != cpu && per_cpu(ci_cpuid_cacheinfo, i)){
 					sibling_leaf =
-						CPUID4_INFO_IDX(i, index);
+						CPUID_CACHEINFO_IDX(i, index);
 					cpumask_set_cpu(cpu, to_cpumask(
 						sibling_leaf->shared_cpu_map));
 				}
@@ -815,14 +812,24 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
 		}
 	}
 }
+
+static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
+{
+	if (cpu_data(cpu).x86_vendor == X86_VENDOR_AMD) {
+		cache_shared_amd_cpu_map_setup(cpu, index);
+	} else {
+		cache_shared_intel_cpu_map_setup(cpu, index);
+	}
+}
+
 static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
 {
-	struct _cpuid4_info	*this_leaf, *sibling_leaf;
+	struct _cpuid_cacheinfo	*this_leaf, *sibling_leaf;
 	int sibling;
 
-	this_leaf = CPUID4_INFO_IDX(cpu, index);
+	this_leaf = CPUID_CACHEINFO_IDX(cpu, index);
 	for_each_cpu(sibling, to_cpumask(this_leaf->shared_cpu_map)) {
-		sibling_leaf = CPUID4_INFO_IDX(sibling, index);
+		sibling_leaf = CPUID_CACHEINFO_IDX(sibling, index);
 		cpumask_clear_cpu(cpu,
 				  to_cpumask(sibling_leaf->shared_cpu_map));
 	}
@@ -844,8 +851,8 @@ static void __cpuinit free_cache_attributes(unsigned int cpu)
 	for (i = 0; i < num_cache_leaves; i++)
 		cache_remove_shared_cpu_map(cpu, i);
 
-	kfree(per_cpu(ici_cpuid4_info, cpu));
-	per_cpu(ici_cpuid4_info, cpu) = NULL;
+	kfree(per_cpu(ci_cpuid_cacheinfo, cpu));
+	per_cpu(ci_cpuid_cacheinfo, cpu) = NULL;
 }
 
 static void __cpuinit get_cpu_leaves(void *_retval)
@@ -854,9 +861,10 @@ static void __cpuinit get_cpu_leaves(void *_retval)
 
 	/* Do cpuid and store the results */
 	for (j = 0; j < num_cache_leaves; j++) {
-		struct _cpuid4_info *this_leaf = CPUID4_INFO_IDX(cpu, j);
+		struct _cpuid_cacheinfo *this_leaf =
+			CPUID_CACHEINFO_IDX(cpu, j);
 
-		*retval = cpuid4_cache_lookup_regs(j, &this_leaf->base);
+		*retval = cpuid_cacheinfo_lookup_regs(j, &this_leaf->base);
 		if (unlikely(*retval < 0)) {
 			int i;
 
@@ -875,15 +883,15 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 	if (num_cache_leaves == 0)
 		return -ENOENT;
 
-	per_cpu(ici_cpuid4_info, cpu) = kzalloc(
-	    sizeof(struct _cpuid4_info) * num_cache_leaves, GFP_KERNEL);
-	if (per_cpu(ici_cpuid4_info, cpu) == NULL)
+	per_cpu(ci_cpuid_cacheinfo, cpu) = kzalloc(
+	    sizeof(struct _cpuid_cacheinfo) * num_cache_leaves, GFP_KERNEL);
+	if (per_cpu(ci_cpuid_cacheinfo, cpu) == NULL)
 		return -ENOMEM;
 
 	smp_call_function_single(cpu, get_cpu_leaves, &retval, true);
 	if (retval) {
-		kfree(per_cpu(ici_cpuid4_info, cpu));
-		per_cpu(ici_cpuid4_info, cpu) = NULL;
+		kfree(per_cpu(ci_cpuid_cacheinfo, cpu));
+		per_cpu(ci_cpuid_cacheinfo, cpu) = NULL;
 	}
 
 	return retval;
@@ -894,7 +902,7 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 #include <linux/cpu.h>
 
 /* pointer to kobject for cpuX/cache */
-static DEFINE_PER_CPU(struct kobject *, ici_cache_kobject);
+static DEFINE_PER_CPU(struct kobject *, ci_cache_kobject);
 
 struct _index_kobject {
 	struct kobject kobj;
@@ -903,11 +911,11 @@ struct _index_kobject {
 };
 
 /* pointer to array of kobjects for cpuX/cache/indexY */
-static DEFINE_PER_CPU(struct _index_kobject *, ici_index_kobject);
-#define INDEX_KOBJECT_PTR(x, y)		(&((per_cpu(ici_index_kobject, x))[y]))
+static DEFINE_PER_CPU(struct _index_kobject *, ci_index_kobject);
+#define INDEX_KOBJECT_PTR(x, y)		(&((per_cpu(ci_index_kobject, x))[y]))
 
 #define show_one_plus(file_name, object, val)				\
-static ssize_t show_##file_name(struct _cpuid4_info *this_leaf, char *buf, \
+static ssize_t show_##file_name(struct _cpuid_cacheinfo *this_leaf, char *buf, \
 				unsigned int cpu)			\
 {									\
 	return sprintf(buf, "%lu\n", (unsigned long)this_leaf->object + val); \
@@ -919,13 +927,13 @@ show_one_plus(physical_line_partition, base.ebx.split.physical_line_partition, 1
 show_one_plus(ways_of_associativity, base.ebx.split.ways_of_associativity, 1);
 show_one_plus(number_of_sets, base.ecx.split.number_of_sets, 1);
 
-static ssize_t show_size(struct _cpuid4_info *this_leaf, char *buf,
+static ssize_t show_size(struct _cpuid_cacheinfo *this_leaf, char *buf,
 			 unsigned int cpu)
 {
 	return sprintf(buf, "%luK\n", this_leaf->base.size / 1024);
 }
 
-static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
+static ssize_t show_shared_cpu_map_func(struct _cpuid_cacheinfo *this_leaf,
 					int type, char *buf)
 {
 	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
@@ -944,19 +952,19 @@ static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
 	return n;
 }
 
-static inline ssize_t show_shared_cpu_map(struct _cpuid4_info *leaf, char *buf,
-					  unsigned int cpu)
+static inline ssize_t show_shared_cpu_map(struct _cpuid_cacheinfo *leaf,
+					  char *buf, unsigned int cpu)
 {
 	return show_shared_cpu_map_func(leaf, 0, buf);
 }
 
-static inline ssize_t show_shared_cpu_list(struct _cpuid4_info *leaf, char *buf,
-					   unsigned int cpu)
+static inline ssize_t show_shared_cpu_list(struct _cpuid_cacheinfo *leaf,
+					   char *buf, unsigned int cpu)
 {
 	return show_shared_cpu_map_func(leaf, 1, buf);
 }
 
-static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf,
+static ssize_t show_type(struct _cpuid_cacheinfo *this_leaf, char *buf,
 			 unsigned int cpu)
 {
 	switch (this_leaf->base.eax.split.type) {
@@ -1002,7 +1010,8 @@ static struct attribute *default_attrs[] = {
 };
 
 #ifdef CONFIG_AMD_NB
-static struct attribute ** __cpuinit amd_l3_attrs(void)
+static struct attribute ** __cpuinit amd_l3_attrs(
+	struct attribute **default_attrs)
 {
 	static struct attribute **attrs;
 	int n;
@@ -1044,7 +1053,8 @@ static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
 	ssize_t ret;
 
 	ret = fattr->show ?
-		fattr->show(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
+		fattr->show(CPUID_CACHEINFO_IDX(this_leaf->cpu,
+						this_leaf->index),
 			buf, this_leaf->cpu) :
 		0;
 	return ret;
@@ -1058,7 +1068,8 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
 	ssize_t ret;
 
 	ret = fattr->store ?
-		fattr->store(CPUID4_INFO_IDX(this_leaf->cpu, this_leaf->index),
+		fattr->store(CPUID_CACHEINFO_IDX(this_leaf->cpu,
+						 this_leaf->index),
 			buf, count, this_leaf->cpu) :
 		0;
 	return ret;
@@ -1078,16 +1089,16 @@ static struct kobj_type ktype_percpu_entry = {
 	.sysfs_ops	= &sysfs_ops,
 };
 
-static void __cpuinit cpuid4_cache_sysfs_exit(unsigned int cpu)
+static void __cpuinit cpuid_cacheinfo_sysfs_exit(unsigned int cpu)
 {
-	kfree(per_cpu(ici_cache_kobject, cpu));
-	kfree(per_cpu(ici_index_kobject, cpu));
-	per_cpu(ici_cache_kobject, cpu) = NULL;
-	per_cpu(ici_index_kobject, cpu) = NULL;
+	kfree(per_cpu(ci_cache_kobject, cpu));
+	kfree(per_cpu(ci_index_kobject, cpu));
+	per_cpu(ci_cache_kobject, cpu) = NULL;
+	per_cpu(ci_index_kobject, cpu) = NULL;
 	free_cache_attributes(cpu);
 }
 
-static int __cpuinit cpuid4_cache_sysfs_init(unsigned int cpu)
+static int __cpuinit cpuid_cacheinfo_sysfs_init(unsigned int cpu)
 {
 	int err;
 
@@ -1099,20 +1110,20 @@ static int __cpuinit cpuid4_cache_sysfs_init(unsigned int cpu)
 		return err;
 
 	/* Allocate all required memory */
-	per_cpu(ici_cache_kobject, cpu) =
+	per_cpu(ci_cache_kobject, cpu) =
 		kzalloc(sizeof(struct kobject), GFP_KERNEL);
-	if (unlikely(per_cpu(ici_cache_kobject, cpu) == NULL))
+	if (unlikely(per_cpu(ci_cache_kobject, cpu) == NULL))
 		goto err_out;
 
-	per_cpu(ici_index_kobject, cpu) = kzalloc(
+	per_cpu(ci_index_kobject, cpu) = kzalloc(
 	    sizeof(struct _index_kobject) * num_cache_leaves, GFP_KERNEL);
-	if (unlikely(per_cpu(ici_index_kobject, cpu) == NULL))
+	if (unlikely(per_cpu(ci_index_kobject, cpu) == NULL))
 		goto err_out;
 
 	return 0;
 
 err_out:
-	cpuid4_cache_sysfs_exit(cpu);
+	cpuid_cacheinfo_sysfs_exit(cpu);
 	return -ENOMEM;
 }
 
@@ -1124,18 +1135,18 @@ static int __cpuinit cache_add_dev(struct device *dev)
 	unsigned int cpu = dev->id;
 	unsigned long i, j;
 	struct _index_kobject *this_object;
-	struct _cpuid4_info   *this_leaf;
+	struct _cpuid_cacheinfo *this_leaf;
 	int retval;
 
-	retval = cpuid4_cache_sysfs_init(cpu);
+	retval = cpuid_cacheinfo_sysfs_init(cpu);
 	if (unlikely(retval < 0))
 		return retval;
 
-	retval = kobject_init_and_add(per_cpu(ici_cache_kobject, cpu),
+	retval = kobject_init_and_add(per_cpu(ci_cache_kobject, cpu),
 				      &ktype_percpu_entry,
 				      &dev->kobj, "%s", "cache");
 	if (retval < 0) {
-		cpuid4_cache_sysfs_exit(cpu);
+		cpuid_cacheinfo_sysfs_exit(cpu);
 		return retval;
 	}
 
@@ -1144,29 +1155,29 @@ static int __cpuinit cache_add_dev(struct device *dev)
 		this_object->cpu = cpu;
 		this_object->index = i;
 
-		this_leaf = CPUID4_INFO_IDX(cpu, i);
+		this_leaf = CPUID_CACHEINFO_IDX(cpu, i);
 
 		ktype_cache.default_attrs = default_attrs;
 #ifdef CONFIG_AMD_NB
 		if (this_leaf->base.nb)
-			ktype_cache.default_attrs = amd_l3_attrs();
+			ktype_cache.default_attrs = amd_l3_attrs(default_attrs);
 #endif
 		retval = kobject_init_and_add(&(this_object->kobj),
 					      &ktype_cache,
-					      per_cpu(ici_cache_kobject, cpu),
+					      per_cpu(ci_cache_kobject, cpu),
 					      "index%1lu", i);
 		if (unlikely(retval)) {
 			for (j = 0; j < i; j++)
 				kobject_put(&(INDEX_KOBJECT_PTR(cpu, j)->kobj));
-			kobject_put(per_cpu(ici_cache_kobject, cpu));
-			cpuid4_cache_sysfs_exit(cpu);
+			kobject_put(per_cpu(ci_cache_kobject, cpu));
+			cpuid_cacheinfo_sysfs_exit(cpu);
 			return retval;
 		}
 		kobject_uevent(&(this_object->kobj), KOBJ_ADD);
 	}
 	cpumask_set_cpu(cpu, to_cpumask(cache_dev_map));
 
-	kobject_uevent(per_cpu(ici_cache_kobject, cpu), KOBJ_ADD);
+	kobject_uevent(per_cpu(ci_cache_kobject, cpu), KOBJ_ADD);
 	return 0;
 }
 
@@ -1175,7 +1186,7 @@ static void __cpuinit cache_remove_dev(struct device *dev)
 	unsigned int cpu = dev->id;
 	unsigned long i;
 
-	if (per_cpu(ici_cpuid4_info, cpu) == NULL)
+	if (per_cpu(ci_cpuid_cacheinfo, cpu) == NULL)
 		return;
 	if (!cpumask_test_cpu(cpu, to_cpumask(cache_dev_map)))
 		return;
@@ -1183,8 +1194,8 @@ static void __cpuinit cache_remove_dev(struct device *dev)
 
 	for (i = 0; i < num_cache_leaves; i++)
 		kobject_put(&(INDEX_KOBJECT_PTR(cpu, i)->kobj));
-	kobject_put(per_cpu(ici_cache_kobject, cpu));
-	cpuid4_cache_sysfs_exit(cpu);
+	kobject_put(per_cpu(ci_cache_kobject, cpu));
+	cpuid_cacheinfo_sysfs_exit(cpu);
 }
 
 static int __cpuinit cacheinfo_cpu_callback(struct notifier_block *nfb,
-- 
1.7.7


