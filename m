Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171Ab2FGQqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 12:46:30 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:49826
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758365Ab2FGQqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 12:46:20 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M59AKX-02-6BD-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>
CC: <tglx@linutronix.de>, <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 3/5] x86, cacheinfo: split intel_cacheinfo.c
Date: Thu, 7 Jun 2012 18:45:57 +0200
Message-ID: <1339087559-32604-3-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1339087559-32604-1-git-send-email-hans.rosenfeld@amd.com>
References: <1339087559-32604-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove anything not Intel-specific from intel_cacheinfo.c. Move
AMD-specific code into amd_cacheinfo.c, move vendor-independent code to
cacheinfo.c. Common declarations used by all three parts go in cacheinfo.h.

Build and link intel_cacheinfo.c and amd_cacheinfo.c only when the
respective vendor support is enabled.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/kernel/cpu/Makefile          |    6 +-
 arch/x86/kernel/cpu/amd_cacheinfo.c   |  455 ++++++++++++++++
 arch/x86/kernel/cpu/cacheinfo.c       |  474 ++++++++++++++++
 arch/x86/kernel/cpu/cacheinfo.h       |   76 +++
 arch/x86/kernel/cpu/intel_cacheinfo.c |  957 +--------------------------------
 5 files changed, 1011 insertions(+), 957 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/amd_cacheinfo.c
 create mode 100644 arch/x86/kernel/cpu/cacheinfo.c
 create mode 100644 arch/x86/kernel/cpu/cacheinfo.h

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 6ab6aa2..4708ba7 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -12,7 +12,7 @@ endif
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_common.o		:= $(nostackp)
 
-obj-y			:= intel_cacheinfo.o scattered.o topology.o
+obj-y			:= cacheinfo.o scattered.o topology.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
 obj-y			+= vmware.o hypervisor.o sched.o mshyperv.o
 obj-y			+= rdrand.o
@@ -21,8 +21,8 @@ obj-y			+= match.o
 obj-$(CONFIG_X86_32)	+= bugs.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
 
-obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o
-obj-$(CONFIG_CPU_SUP_AMD)		+= amd.o
+obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o intel_cacheinfo.o
+obj-$(CONFIG_CPU_SUP_AMD)		+= amd.o amd_cacheinfo.o
 obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
 obj-$(CONFIG_CPU_SUP_CENTAUR)		+= centaur.o
 obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
diff --git a/arch/x86/kernel/cpu/amd_cacheinfo.c b/arch/x86/kernel/cpu/amd_cacheinfo.c
new file mode 100644
index 0000000..e3fda975
--- /dev/null
+++ b/arch/x86/kernel/cpu/amd_cacheinfo.c
@@ -0,0 +1,455 @@
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/compiler.h>
+#include <linux/cpu.h>
+#include <linux/sched.h>
+#include <linux/pci.h>
+
+#include <asm/processor.h>
+#include <linux/smp.h>
+#include <asm/amd_nb.h>
+#include <asm/smp.h>
+
+#include "cacheinfo.h"
+
+/* AMD CPUs don't have CPUID4, but some newer models have a mostly compatible
+   extended CPUID leaf. On systems that have neither, emulate it here to report
+   the same information to the user.  This makes some assumptions about the
+   machine: L2 not shared, no SMT etc. that is true on those AMD CPUs.
+
+   In theory the TLBs could be reported as fake type (they are in "dummy").
+   Maybe later */
+union l1_cache {
+	struct {
+		unsigned line_size:8;
+		unsigned lines_per_tag:8;
+		unsigned assoc:8;
+		unsigned size_in_kb:8;
+	};
+	unsigned val;
+};
+
+union l2_cache {
+	struct {
+		unsigned line_size:8;
+		unsigned lines_per_tag:4;
+		unsigned assoc:4;
+		unsigned size_in_kb:16;
+	};
+	unsigned val;
+};
+
+union l3_cache {
+	struct {
+		unsigned line_size:8;
+		unsigned lines_per_tag:4;
+		unsigned assoc:4;
+		unsigned res:2;
+		unsigned size_encoded:14;
+	};
+	unsigned val;
+};
+
+static const unsigned short __cpuinitconst assocs[] = {
+	[1] = 1,
+	[2] = 2,
+	[4] = 4,
+	[6] = 8,
+	[8] = 16,
+	[0xa] = 32,
+	[0xb] = 48,
+	[0xc] = 64,
+	[0xd] = 96,
+	[0xe] = 128,
+	[0xf] = 0xffff /* fully associative - no way to show this currently */
+};
+
+static const unsigned char __cpuinitconst levels[] = { 1, 1, 2, 3 };
+static const unsigned char __cpuinitconst types[] = { 1, 2, 3, 3 };
+
+void __cpuinit amd_cpuid4(int leaf,
+			  union _cpuid_cacheinfo_eax *eax,
+			  union _cpuid_cacheinfo_ebx *ebx,
+			  union _cpuid_cacheinfo_ecx *ecx)
+{
+	unsigned dummy;
+	unsigned line_size, lines_per_tag, assoc, size_in_kb;
+	union l1_cache l1i, l1d;
+	union l2_cache l2;
+	union l3_cache l3;
+	union l1_cache *l1 = &l1d;
+
+	eax->full = 0;
+	ebx->full = 0;
+	ecx->full = 0;
+
+	cpuid(0x80000005, &dummy, &dummy, &l1d.val, &l1i.val);
+	cpuid(0x80000006, &dummy, &dummy, &l2.val, &l3.val);
+
+	switch (leaf) {
+	case 1:
+		l1 = &l1i;
+	case 0:
+		if (!l1->val)
+			return;
+		assoc = assocs[l1->assoc];
+		line_size = l1->line_size;
+		lines_per_tag = l1->lines_per_tag;
+		size_in_kb = l1->size_in_kb;
+		break;
+	case 2:
+		if (!l2.val)
+			return;
+		assoc = assocs[l2.assoc];
+		line_size = l2.line_size;
+		lines_per_tag = l2.lines_per_tag;
+		/* cpu_data has errata corrections for K7 applied */
+		size_in_kb = __this_cpu_read(cpu_info.x86_cache_size);
+		break;
+	case 3:
+		if (!l3.val)
+			return;
+		assoc = assocs[l3.assoc];
+		line_size = l3.line_size;
+		lines_per_tag = l3.lines_per_tag;
+		size_in_kb = l3.size_encoded * 512;
+		if (boot_cpu_has(X86_FEATURE_AMD_DCM)) {
+			size_in_kb = size_in_kb >> 1;
+			assoc = assoc >> 1;
+		}
+		break;
+	default:
+		return;
+	}
+
+	eax->split.is_self_initializing = 1;
+	eax->split.type = types[leaf];
+	eax->split.level = levels[leaf];
+	eax->split.num_threads_sharing = 0;
+	eax->split.num_cores_on_die =
+		__this_cpu_read(cpu_info.x86_max_cores) - 1;
+
+
+	if (assoc == 0xffff)
+		eax->split.is_fully_associative = 1;
+	ebx->split.coherency_line_size = line_size - 1;
+	ebx->split.ways_of_associativity = assoc - 1;
+	ebx->split.physical_line_partition = lines_per_tag - 1;
+	ecx->split.number_of_sets = (size_in_kb * 1024) / line_size /
+		(ebx->split.ways_of_associativity + 1) - 1;
+}
+
+#ifdef CONFIG_SMP
+void __cpuinit cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
+{
+	struct _cpuid_cacheinfo *this_leaf;
+	int i, sibling;
+
+	if (cpu_has_topoext) {
+		unsigned int apicid = cpu_data(cpu).apicid;
+		int nshared, first;
+
+		if (!per_cpu(ci_cpuid_cacheinfo, cpu))
+			return;
+
+		this_leaf = CPUID_CACHEINFO_IDX(cpu, index);
+		nshared = 1 + this_leaf->base.eax.split.num_threads_sharing;
+		first = apicid - apicid % nshared;
+
+		for_each_online_cpu(i) {
+			if (cpu_data(i).apicid < first ||
+			    cpu_data(i).apicid >= first + nshared)
+				continue;
+
+			if (!per_cpu(ci_cpuid_cacheinfo, i))
+				continue;
+
+			this_leaf = CPUID_CACHEINFO_IDX(i, index);
+			for_each_online_cpu(sibling) {
+				if (cpu_data(sibling).apicid < first ||
+				    cpu_data(sibling).apicid >= first + nshared)
+					continue;
+
+				set_bit(sibling, this_leaf->shared_cpu_map);
+			}
+		}
+	} else if (index == 3) {
+		for_each_cpu(i, cpu_llc_shared_mask(cpu)) {
+			if (!per_cpu(ci_cpuid_cacheinfo, i))
+				continue;
+			this_leaf = CPUID_CACHEINFO_IDX(i, index);
+			for_each_cpu(sibling, cpu_llc_shared_mask(cpu)) {
+				if (!cpu_online(sibling))
+					continue;
+				set_bit(sibling, this_leaf->shared_cpu_map);
+			}
+		}
+	}
+}
+#endif
+
+#ifdef CONFIG_AMD_NB
+
+/*
+ * L3 cache descriptors
+ */
+static void __cpuinit amd_calc_l3_indices(struct amd_northbridge *nb)
+{
+	struct amd_l3_cache *l3 = &nb->l3_cache;
+	unsigned int sc0, sc1, sc2, sc3;
+	u32 val = 0;
+
+	pci_read_config_dword(nb->misc, 0x1C4, &val);
+
+	/* calculate subcache sizes */
+	l3->subcaches[0] = sc0 = !(val & BIT(0));
+	l3->subcaches[1] = sc1 = !(val & BIT(4));
+
+	if (boot_cpu_data.x86 == 0x15) {
+		l3->subcaches[0] = sc0 += !(val & BIT(1));
+		l3->subcaches[1] = sc1 += !(val & BIT(5));
+	}
+
+	l3->subcaches[2] = sc2 = !(val & BIT(8))  + !(val & BIT(9));
+	l3->subcaches[3] = sc3 = !(val & BIT(12)) + !(val & BIT(13));
+
+	l3->indices = (max(max3(sc0, sc1, sc2), sc3) << 10) - 1;
+}
+
+void __cpuinit amd_init_l3_cache(struct _cpuid_cacheinfo_regs *this_leaf,
+				 int index)
+{
+	int node;
+
+	/* only for L3, and not in virtualized environments */
+	if (index < 3)
+		return;
+
+	node = amd_get_nb_id(smp_processor_id());
+	this_leaf->nb = node_to_amd_nb(node);
+	if (this_leaf->nb && !this_leaf->nb->l3_cache.indices)
+		amd_calc_l3_indices(this_leaf->nb);
+}
+
+/*
+ * check whether a slot used for disabling an L3 index is occupied.
+ * @l3: L3 cache descriptor
+ * @slot: slot number (0..1)
+ *
+ * @returns: the disabled index if used or negative value if slot free.
+ */
+int amd_get_l3_disable_slot(struct amd_northbridge *nb, unsigned slot)
+{
+	unsigned int reg = 0;
+
+	pci_read_config_dword(nb->misc, 0x1BC + slot * 4, &reg);
+
+	/* check whether this slot is activated already */
+	if (reg & (3UL << 30))
+		return reg & 0xfff;
+
+	return -1;
+}
+
+static ssize_t show_cache_disable(struct _cpuid_cacheinfo *this_leaf, char *buf,
+				  unsigned int slot)
+{
+	int index;
+
+	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
+		return -EINVAL;
+
+	index = amd_get_l3_disable_slot(this_leaf->base.nb, slot);
+	if (index >= 0)
+		return sprintf(buf, "%d\n", index);
+
+	return sprintf(buf, "FREE\n");
+}
+
+#define SHOW_CACHE_DISABLE(slot)					\
+static ssize_t								\
+show_cache_disable_##slot(struct _cpuid_cacheinfo *this_leaf, char *buf,\
+			  unsigned int cpu)				\
+{									\
+	return show_cache_disable(this_leaf, buf, slot);		\
+}
+SHOW_CACHE_DISABLE(0)
+SHOW_CACHE_DISABLE(1)
+
+static void amd_l3_disable_index(struct amd_northbridge *nb, int cpu,
+				 unsigned slot, unsigned long idx)
+{
+	int i;
+
+	idx |= BIT(30);
+
+	/*
+	 *  disable index in all 4 subcaches
+	 */
+	for (i = 0; i < 4; i++) {
+		u32 reg = idx | (i << 20);
+
+		if (!nb->l3_cache.subcaches[i])
+			continue;
+
+		pci_write_config_dword(nb->misc, 0x1BC + slot * 4, reg);
+
+		/*
+		 * We need to WBINVD on a core on the node containing the L3
+		 * cache which indices we disable therefore a simple wbinvd()
+		 * is not sufficient.
+		 */
+		wbinvd_on_cpu(cpu);
+
+		reg |= BIT(31);
+		pci_write_config_dword(nb->misc, 0x1BC + slot * 4, reg);
+	}
+}
+
+/*
+ * disable a L3 cache index by using a disable-slot
+ *
+ * @l3:    L3 cache descriptor
+ * @cpu:   A CPU on the node containing the L3 cache
+ * @slot:  slot number (0..1)
+ * @index: index to disable
+ *
+ * @return: 0 on success, error status on failure
+ */
+int amd_set_l3_disable_slot(struct amd_northbridge *nb, int cpu, unsigned slot,
+			    unsigned long index)
+{
+	int ret = 0;
+
+	/*  check if @slot is already used or the index is already disabled */
+	ret = amd_get_l3_disable_slot(nb, slot);
+	if (ret >= 0)
+		return -EEXIST;
+
+	if (index > nb->l3_cache.indices)
+		return -EINVAL;
+
+	/* check whether the other slot has disabled the same index already */
+	if (index == amd_get_l3_disable_slot(nb, !slot))
+		return -EEXIST;
+
+	amd_l3_disable_index(nb, cpu, slot, index);
+
+	return 0;
+}
+
+static ssize_t store_cache_disable(struct _cpuid_cacheinfo *this_leaf,
+				  const char *buf, size_t count,
+				  unsigned int slot)
+{
+	unsigned long val = 0;
+	int cpu, err = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
+		return -EINVAL;
+
+	cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
+
+	if (strict_strtoul(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	err = amd_set_l3_disable_slot(this_leaf->base.nb, cpu, slot, val);
+	if (err) {
+		if (err == -EEXIST)
+			pr_warning("L3 slot %d in use/index already disabled!\n",
+				   slot);
+		return err;
+	}
+	return count;
+}
+
+#define STORE_CACHE_DISABLE(slot)					\
+static ssize_t								\
+store_cache_disable_##slot(struct _cpuid_cacheinfo *this_leaf,		\
+			   const char *buf, size_t count,		\
+			   unsigned int cpu)				\
+{									\
+	return store_cache_disable(this_leaf, buf, count, slot);	\
+}
+STORE_CACHE_DISABLE(0)
+STORE_CACHE_DISABLE(1)
+
+static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
+		show_cache_disable_0, store_cache_disable_0);
+static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
+		show_cache_disable_1, store_cache_disable_1);
+
+static ssize_t
+show_subcaches(struct _cpuid_cacheinfo *this_leaf, char *buf, unsigned int cpu)
+{
+	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		return -EINVAL;
+
+	return sprintf(buf, "%x\n", amd_get_subcaches(cpu));
+}
+
+static ssize_t
+store_subcaches(struct _cpuid_cacheinfo *this_leaf, const char *buf,
+		size_t count, unsigned int cpu)
+{
+	unsigned long val;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
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
+struct attribute ** __cpuinit amd_l3_attrs(struct attribute **default_attrs)
+{
+	static struct attribute **attrs;
+	int n = 1;
+
+	if (attrs)
+		return attrs;
+
+	attrs = default_attrs;
+	while (*attrs++)
+		n++;
+
+	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
+		n += 2;
+
+	if (amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		n += 1;
+
+	attrs = kzalloc(n * sizeof (struct attribute *), GFP_KERNEL);
+	if (attrs == NULL)
+		return attrs = default_attrs;
+
+	for (n = 0; default_attrs[n]; n++)
+		attrs[n] = default_attrs[n];
+
+	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE)) {
+		attrs[n++] = &cache_disable_0.attr;
+		attrs[n++] = &cache_disable_1.attr;
+	}
+
+	if (amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
+		attrs[n++] = &subcaches.attr;
+
+	return attrs;
+}
+
+#endif /* CONFIG_AMD_NB */
diff --git a/arch/x86/kernel/cpu/cacheinfo.c b/arch/x86/kernel/cpu/cacheinfo.c
new file mode 100644
index 0000000..111617e
--- /dev/null
+++ b/arch/x86/kernel/cpu/cacheinfo.c
@@ -0,0 +1,474 @@
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/compiler.h>
+#include <linux/cpu.h>
+#include <linux/sched.h>
+#include <linux/pci.h>
+
+#include <asm/processor.h>
+#include <linux/smp.h>
+#include <asm/amd_nb.h>
+#include <asm/smp.h>
+
+#include "cacheinfo.h"
+
+unsigned short			num_cache_leaves;
+
+int __cpuinit cpuid_cacheinfo_lookup_regs(int index,
+					struct _cpuid_cacheinfo_regs *this_leaf)
+{
+	union _cpuid_cacheinfo_eax	eax;
+	union _cpuid_cacheinfo_ebx	ebx;
+	union _cpuid_cacheinfo_ecx	ecx;
+#if defined(CONFIG_CPU_SUP_AMD) || defined(CONFIG_CPU_SUP_INTEL)
+	unsigned		edx;
+#endif
+
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
+#if defined(CONFIG_CPU_SUP_AMD)
+		if (cpu_has_topoext)
+			cpuid_count(0x8000001d, index, &eax.full, &ebx.full,
+				    &ecx.full, &edx);
+		else
+			amd_cpuid4(index, &eax, &ebx, &ecx);
+		amd_init_l3_cache(this_leaf, index);
+#endif
+	} else {
+#if defined(CONFIG_CPU_SUP_INTEL)
+		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full, &edx);
+#endif
+	}
+
+	if (eax.split.type == CACHE_TYPE_NULL)
+		return -EIO; /* better error ? */
+
+	this_leaf->eax = eax;
+	this_leaf->ebx = ebx;
+	this_leaf->ecx = ecx;
+	this_leaf->size = (ecx.split.number_of_sets          + 1) *
+			  (ebx.split.coherency_line_size     + 1) *
+			  (ebx.split.physical_line_partition + 1) *
+			  (ebx.split.ways_of_associativity   + 1);
+	return 0;
+}
+
+int __cpuinit find_num_cache_leaves(void)
+{
+	unsigned int		eax, ebx, ecx, edx;
+	union _cpuid_cacheinfo_eax	cache_eax;
+	int			i = -1;
+
+	do {
+		++i;
+		/* Do cpuid(4) loop to find out num_cache_leaves */
+		cpuid_count(4, i, &eax, &ebx, &ecx, &edx);
+		cache_eax.full = eax;
+	} while (cache_eax.split.type != CACHE_TYPE_NULL);
+	return i;
+}
+
+#ifdef CONFIG_SYSFS
+
+/* pointer to _cpuid_cacheinfo array (for each cache leaf) */
+DEFINE_PER_CPU(struct _cpuid_cacheinfo *, ci_cpuid_cacheinfo);
+
+#ifdef CONFIG_SMP
+static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
+{
+	if (cpu_data(cpu).x86_vendor == X86_VENDOR_AMD) {
+#ifdef CONFIG_CPU_SUP_AMD
+		cache_shared_amd_cpu_map_setup(cpu, index);
+#endif
+	} else {
+#ifdef CONFIG_CPU_SUP_INTEL
+		cache_shared_intel_cpu_map_setup(cpu, index);
+#endif
+	}
+}
+
+static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
+{
+	struct _cpuid_cacheinfo	*this_leaf, *sibling_leaf;
+	int sibling;
+
+	this_leaf = CPUID_CACHEINFO_IDX(cpu, index);
+	for_each_cpu(sibling, to_cpumask(this_leaf->shared_cpu_map)) {
+		sibling_leaf = CPUID_CACHEINFO_IDX(sibling, index);
+		cpumask_clear_cpu(cpu,
+				  to_cpumask(sibling_leaf->shared_cpu_map));
+	}
+}
+#else
+static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
+{
+}
+
+static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
+{
+}
+#endif
+
+static void __cpuinit free_cache_attributes(unsigned int cpu)
+{
+	int i;
+
+	for (i = 0; i < num_cache_leaves; i++)
+		cache_remove_shared_cpu_map(cpu, i);
+
+	kfree(per_cpu(ci_cpuid_cacheinfo, cpu));
+	per_cpu(ci_cpuid_cacheinfo, cpu) = NULL;
+}
+
+static void __cpuinit get_cpu_leaves(void *_retval)
+{
+	int j, *retval = _retval, cpu = smp_processor_id();
+
+	/* Do cpuid and store the results */
+	for (j = 0; j < num_cache_leaves; j++) {
+		struct _cpuid_cacheinfo *this_leaf =
+			CPUID_CACHEINFO_IDX(cpu, j);
+
+		*retval = cpuid_cacheinfo_lookup_regs(j, &this_leaf->base);
+		if (unlikely(*retval < 0)) {
+			int i;
+
+			for (i = 0; i < j; i++)
+				cache_remove_shared_cpu_map(cpu, i);
+			break;
+		}
+		cache_shared_cpu_map_setup(cpu, j);
+	}
+}
+
+static int __cpuinit detect_cache_attributes(unsigned int cpu)
+{
+	int			retval;
+
+	if (num_cache_leaves == 0)
+		return -ENOENT;
+
+	per_cpu(ci_cpuid_cacheinfo, cpu) = kzalloc(
+	    sizeof(struct _cpuid_cacheinfo) * num_cache_leaves, GFP_KERNEL);
+	if (per_cpu(ci_cpuid_cacheinfo, cpu) == NULL)
+		return -ENOMEM;
+
+	smp_call_function_single(cpu, get_cpu_leaves, &retval, true);
+	if (retval) {
+		kfree(per_cpu(ci_cpuid_cacheinfo, cpu));
+		per_cpu(ci_cpuid_cacheinfo, cpu) = NULL;
+	}
+
+	return retval;
+}
+
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/cpu.h>
+
+/* pointer to kobject for cpuX/cache */
+static DEFINE_PER_CPU(struct kobject *, ci_cache_kobject);
+
+struct _index_kobject {
+	struct kobject kobj;
+	unsigned int cpu;
+	unsigned short index;
+};
+
+/* pointer to array of kobjects for cpuX/cache/indexY */
+static DEFINE_PER_CPU(struct _index_kobject *, ci_index_kobject);
+#define INDEX_KOBJECT_PTR(x, y)		(&((per_cpu(ci_index_kobject, x))[y]))
+
+#define show_one_plus(file_name, object, val)				\
+static ssize_t show_##file_name(struct _cpuid_cacheinfo *this_leaf, char *buf, \
+				unsigned int cpu)			\
+{									\
+	return sprintf(buf, "%lu\n", (unsigned long)this_leaf->object + val); \
+}
+
+show_one_plus(level, base.eax.split.level, 0);
+show_one_plus(coherency_line_size, base.ebx.split.coherency_line_size, 1);
+show_one_plus(physical_line_partition, base.ebx.split.physical_line_partition, 1);
+show_one_plus(ways_of_associativity, base.ebx.split.ways_of_associativity, 1);
+show_one_plus(number_of_sets, base.ecx.split.number_of_sets, 1);
+
+static ssize_t show_size(struct _cpuid_cacheinfo *this_leaf, char *buf,
+			 unsigned int cpu)
+{
+	return sprintf(buf, "%luK\n", this_leaf->base.size / 1024);
+}
+
+static ssize_t show_shared_cpu_map_func(struct _cpuid_cacheinfo *this_leaf,
+					int type, char *buf)
+{
+	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
+	int n = 0;
+
+	if (len > 1) {
+		const struct cpumask *mask;
+
+		mask = to_cpumask(this_leaf->shared_cpu_map);
+		n = type ?
+			cpulist_scnprintf(buf, len-2, mask) :
+			cpumask_scnprintf(buf, len-2, mask);
+		buf[n++] = '\n';
+		buf[n] = '\0';
+	}
+	return n;
+}
+
+static inline ssize_t show_shared_cpu_map(struct _cpuid_cacheinfo *leaf,
+					  char *buf, unsigned int cpu)
+{
+	return show_shared_cpu_map_func(leaf, 0, buf);
+}
+
+static inline ssize_t show_shared_cpu_list(struct _cpuid_cacheinfo *leaf,
+					   char *buf, unsigned int cpu)
+{
+	return show_shared_cpu_map_func(leaf, 1, buf);
+}
+
+static ssize_t show_type(struct _cpuid_cacheinfo *this_leaf, char *buf,
+			 unsigned int cpu)
+{
+	switch (this_leaf->base.eax.split.type) {
+	case CACHE_TYPE_DATA:
+		return sprintf(buf, "Data\n");
+	case CACHE_TYPE_INST:
+		return sprintf(buf, "Instruction\n");
+	case CACHE_TYPE_UNIFIED:
+		return sprintf(buf, "Unified\n");
+	default:
+		return sprintf(buf, "Unknown\n");
+	}
+}
+
+#define to_object(k)	container_of(k, struct _index_kobject, kobj)
+#define to_attr(a)	container_of(a, struct _cache_attr, attr)
+
+#define define_one_ro(_name) \
+static struct _cache_attr _name = \
+	__ATTR(_name, 0444, show_##_name, NULL)
+
+define_one_ro(level);
+define_one_ro(type);
+define_one_ro(coherency_line_size);
+define_one_ro(physical_line_partition);
+define_one_ro(ways_of_associativity);
+define_one_ro(number_of_sets);
+define_one_ro(size);
+define_one_ro(shared_cpu_map);
+define_one_ro(shared_cpu_list);
+
+static struct attribute *default_attrs[] = {
+	&type.attr,
+	&level.attr,
+	&coherency_line_size.attr,
+	&physical_line_partition.attr,
+	&ways_of_associativity.attr,
+	&number_of_sets.attr,
+	&size.attr,
+	&shared_cpu_map.attr,
+	&shared_cpu_list.attr,
+	NULL
+};
+
+static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
+{
+	struct _cache_attr *fattr = to_attr(attr);
+	struct _index_kobject *this_leaf = to_object(kobj);
+	ssize_t ret;
+
+	ret = fattr->show ?
+		fattr->show(CPUID_CACHEINFO_IDX(this_leaf->cpu,
+						this_leaf->index),
+			buf, this_leaf->cpu) :
+		0;
+	return ret;
+}
+
+static ssize_t store(struct kobject *kobj, struct attribute *attr,
+		     const char *buf, size_t count)
+{
+	struct _cache_attr *fattr = to_attr(attr);
+	struct _index_kobject *this_leaf = to_object(kobj);
+	ssize_t ret;
+
+	ret = fattr->store ?
+		fattr->store(CPUID_CACHEINFO_IDX(this_leaf->cpu,
+						 this_leaf->index),
+			buf, count, this_leaf->cpu) :
+		0;
+	return ret;
+}
+
+static const struct sysfs_ops sysfs_ops = {
+	.show   = show,
+	.store  = store,
+};
+
+static struct kobj_type ktype_cache = {
+	.sysfs_ops	= &sysfs_ops,
+	.default_attrs	= default_attrs,
+};
+
+static struct kobj_type ktype_percpu_entry = {
+	.sysfs_ops	= &sysfs_ops,
+};
+
+static void __cpuinit cpuid_cacheinfo_sysfs_exit(unsigned int cpu)
+{
+	kfree(per_cpu(ci_cache_kobject, cpu));
+	kfree(per_cpu(ci_index_kobject, cpu));
+	per_cpu(ci_cache_kobject, cpu) = NULL;
+	per_cpu(ci_index_kobject, cpu) = NULL;
+	free_cache_attributes(cpu);
+}
+
+static int __cpuinit cpuid_cacheinfo_sysfs_init(unsigned int cpu)
+{
+	int err;
+
+	if (num_cache_leaves == 0)
+		return -ENOENT;
+
+	err = detect_cache_attributes(cpu);
+	if (err)
+		return err;
+
+	/* Allocate all required memory */
+	per_cpu(ci_cache_kobject, cpu) =
+		kzalloc(sizeof(struct kobject), GFP_KERNEL);
+	if (unlikely(per_cpu(ci_cache_kobject, cpu) == NULL))
+		goto err_out;
+
+	per_cpu(ci_index_kobject, cpu) = kzalloc(
+	    sizeof(struct _index_kobject) * num_cache_leaves, GFP_KERNEL);
+	if (unlikely(per_cpu(ci_index_kobject, cpu) == NULL))
+		goto err_out;
+
+	return 0;
+
+err_out:
+	cpuid_cacheinfo_sysfs_exit(cpu);
+	return -ENOMEM;
+}
+
+static DECLARE_BITMAP(cache_dev_map, NR_CPUS);
+
+/* Add/Remove cache interface for CPU device */
+static int __cpuinit cache_add_dev(struct device *dev)
+{
+	unsigned int cpu = dev->id;
+	unsigned long i, j;
+	struct _index_kobject *this_object;
+	struct _cpuid_cacheinfo   *this_leaf;
+	int retval;
+
+	retval = cpuid_cacheinfo_sysfs_init(cpu);
+	if (unlikely(retval < 0))
+		return retval;
+
+	retval = kobject_init_and_add(per_cpu(ci_cache_kobject, cpu),
+				      &ktype_percpu_entry,
+				      &dev->kobj, "%s", "cache");
+	if (retval < 0) {
+		cpuid_cacheinfo_sysfs_exit(cpu);
+		return retval;
+	}
+
+	for (i = 0; i < num_cache_leaves; i++) {
+		this_object = INDEX_KOBJECT_PTR(cpu, i);
+		this_object->cpu = cpu;
+		this_object->index = i;
+
+		this_leaf = CPUID_CACHEINFO_IDX(cpu, i);
+
+		ktype_cache.default_attrs = default_attrs;
+#ifdef CONFIG_AMD_NB
+		if (this_leaf->base.nb)
+			ktype_cache.default_attrs = amd_l3_attrs(default_attrs);
+#endif
+		retval = kobject_init_and_add(&(this_object->kobj),
+					      &ktype_cache,
+					      per_cpu(ci_cache_kobject, cpu),
+					      "index%1lu", i);
+		if (unlikely(retval)) {
+			for (j = 0; j < i; j++)
+				kobject_put(&(INDEX_KOBJECT_PTR(cpu, j)->kobj));
+			kobject_put(per_cpu(ci_cache_kobject, cpu));
+			cpuid_cacheinfo_sysfs_exit(cpu);
+			return retval;
+		}
+		kobject_uevent(&(this_object->kobj), KOBJ_ADD);
+	}
+	cpumask_set_cpu(cpu, to_cpumask(cache_dev_map));
+
+	kobject_uevent(per_cpu(ci_cache_kobject, cpu), KOBJ_ADD);
+	return 0;
+}
+
+static void __cpuinit cache_remove_dev(struct device *dev)
+{
+	unsigned int cpu = dev->id;
+	unsigned long i;
+
+	if (per_cpu(ci_cpuid_cacheinfo, cpu) == NULL)
+		return;
+	if (!cpumask_test_cpu(cpu, to_cpumask(cache_dev_map)))
+		return;
+	cpumask_clear_cpu(cpu, to_cpumask(cache_dev_map));
+
+	for (i = 0; i < num_cache_leaves; i++)
+		kobject_put(&(INDEX_KOBJECT_PTR(cpu, i)->kobj));
+	kobject_put(per_cpu(ci_cache_kobject, cpu));
+	cpuid_cacheinfo_sysfs_exit(cpu);
+}
+
+static int __cpuinit cacheinfo_cpu_callback(struct notifier_block *nfb,
+					unsigned long action, void *hcpu)
+{
+	unsigned int cpu = (unsigned long)hcpu;
+	struct device *dev;
+
+	dev = get_cpu_device(cpu);
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		cache_add_dev(dev);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		cache_remove_dev(dev);
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block __cpuinitdata cacheinfo_cpu_notifier = {
+	.notifier_call = cacheinfo_cpu_callback,
+};
+
+static int __cpuinit cache_sysfs_init(void)
+{
+	int i;
+
+	if (num_cache_leaves == 0)
+		return 0;
+
+	for_each_online_cpu(i) {
+		int err;
+		struct device *dev = get_cpu_device(i);
+
+		err = cache_add_dev(dev);
+		if (err)
+			return err;
+	}
+	register_hotcpu_notifier(&cacheinfo_cpu_notifier);
+	return 0;
+}
+
+device_initcall(cache_sysfs_init);
+
+#endif
diff --git a/arch/x86/kernel/cpu/cacheinfo.h b/arch/x86/kernel/cpu/cacheinfo.h
new file mode 100644
index 0000000..df5b83e
--- /dev/null
+++ b/arch/x86/kernel/cpu/cacheinfo.h
@@ -0,0 +1,76 @@
+#ifndef __CACHEINFO_H
+#define __CACHEINFO_H
+
+#include <asm/percpu.h>
+
+
+enum _cache_type {
+	CACHE_TYPE_NULL	= 0,
+	CACHE_TYPE_DATA = 1,
+	CACHE_TYPE_INST = 2,
+	CACHE_TYPE_UNIFIED = 3
+};
+
+union _cpuid_cacheinfo_eax {
+	struct {
+		enum _cache_type	type:5;
+		unsigned int		level:3;
+		unsigned int		is_self_initializing:1;
+		unsigned int		is_fully_associative:1;
+		unsigned int		reserved:4;
+		unsigned int		num_threads_sharing:12;
+		unsigned int		num_cores_on_die:6;
+	} split;
+	u32 full;
+};
+
+union _cpuid_cacheinfo_ebx {
+	struct {
+		unsigned int		coherency_line_size:12;
+		unsigned int		physical_line_partition:10;
+		unsigned int		ways_of_associativity:10;
+	} split;
+	u32 full;
+};
+
+union _cpuid_cacheinfo_ecx {
+	struct {
+		unsigned int		number_of_sets:32;
+	} split;
+	u32 full;
+};
+
+struct _cpuid_cacheinfo_regs {
+	union _cpuid_cacheinfo_eax eax;
+	union _cpuid_cacheinfo_ebx ebx;
+	union _cpuid_cacheinfo_ecx ecx;
+	unsigned long size;
+	struct amd_northbridge *nb;
+};
+
+struct _cpuid_cacheinfo {
+	struct _cpuid_cacheinfo_regs base;
+	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
+};
+
+DECLARE_PER_CPU(struct _cpuid_cacheinfo *, ci_cpuid_cacheinfo);
+#define CPUID_CACHEINFO_IDX(x, y)	(&((per_cpu(ci_cpuid_cacheinfo, x))[y]))
+
+struct _cache_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct _cpuid_cacheinfo *, char *, unsigned int);
+	ssize_t (*store)(struct _cpuid_cacheinfo *, const char *, size_t count,
+			 unsigned int);
+};
+
+extern struct attribute ** amd_l3_attrs(struct attribute **);
+extern void amd_cpuid4(int, union _cpuid_cacheinfo_eax *,
+		       union _cpuid_cacheinfo_ebx *,
+		       union _cpuid_cacheinfo_ecx *);
+extern void amd_init_l3_cache(struct _cpuid_cacheinfo_regs *, int);
+extern void cache_shared_amd_cpu_map_setup(unsigned int, int);
+extern void cache_shared_intel_cpu_map_setup(unsigned int, int);
+extern int cpuid_cacheinfo_lookup_regs(int, struct _cpuid_cacheinfo_regs *);
+extern int find_num_cache_leaves(void);
+
+#endif /* __CACHEINFO_H */
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 14eb6a5..7e5b1fb 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -20,6 +20,8 @@
 #include <asm/amd_nb.h>
 #include <asm/smp.h>
 
+#include "cacheinfo.h"
+
 #define LVL_1_INST	1
 #define LVL_1_DATA	2
 #define LVL_2		3
@@ -114,470 +116,6 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x00, 0, 0}
 };
 
-
-enum _cache_type {
-	CACHE_TYPE_NULL	= 0,
-	CACHE_TYPE_DATA = 1,
-	CACHE_TYPE_INST = 2,
-	CACHE_TYPE_UNIFIED = 3
-};
-
-union _cpuid_cacheinfo_eax {
-	struct {
-		enum _cache_type	type:5;
-		unsigned int		level:3;
-		unsigned int		is_self_initializing:1;
-		unsigned int		is_fully_associative:1;
-		unsigned int		reserved:4;
-		unsigned int		num_threads_sharing:12;
-		unsigned int		num_cores_on_die:6;
-	} split;
-	u32 full;
-};
-
-union _cpuid_cacheinfo_ebx {
-	struct {
-		unsigned int		coherency_line_size:12;
-		unsigned int		physical_line_partition:10;
-		unsigned int		ways_of_associativity:10;
-	} split;
-	u32 full;
-};
-
-union _cpuid_cacheinfo_ecx {
-	struct {
-		unsigned int		number_of_sets:32;
-	} split;
-	u32 full;
-};
-
-struct _cpuid_cacheinfo_regs {
-	union _cpuid_cacheinfo_eax eax;
-	union _cpuid_cacheinfo_ebx ebx;
-	union _cpuid_cacheinfo_ecx ecx;
-	unsigned long size;
-	struct amd_northbridge *nb;
-};
-
-struct _cpuid_cacheinfo {
-	struct _cpuid_cacheinfo_regs base;
-	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
-};
-
-unsigned short			num_cache_leaves;
-
-/* AMD doesn't have CPUID4. Emulate it here to report the same
-   information to the user.  This makes some assumptions about the machine:
-   L2 not shared, no SMT etc. that is currently true on AMD CPUs.
-
-   In theory the TLBs could be reported as fake type (they are in "dummy").
-   Maybe later */
-union l1_cache {
-	struct {
-		unsigned line_size:8;
-		unsigned lines_per_tag:8;
-		unsigned assoc:8;
-		unsigned size_in_kb:8;
-	};
-	unsigned val;
-};
-
-union l2_cache {
-	struct {
-		unsigned line_size:8;
-		unsigned lines_per_tag:4;
-		unsigned assoc:4;
-		unsigned size_in_kb:16;
-	};
-	unsigned val;
-};
-
-union l3_cache {
-	struct {
-		unsigned line_size:8;
-		unsigned lines_per_tag:4;
-		unsigned assoc:4;
-		unsigned res:2;
-		unsigned size_encoded:14;
-	};
-	unsigned val;
-};
-
-static const unsigned short __cpuinitconst assocs[] = {
-	[1] = 1,
-	[2] = 2,
-	[4] = 4,
-	[6] = 8,
-	[8] = 16,
-	[0xa] = 32,
-	[0xb] = 48,
-	[0xc] = 64,
-	[0xd] = 96,
-	[0xe] = 128,
-	[0xf] = 0xffff /* fully associative - no way to show this currently */
-};
-
-static const unsigned char __cpuinitconst levels[] = { 1, 1, 2, 3 };
-static const unsigned char __cpuinitconst types[] = { 1, 2, 3, 3 };
-
-static void __cpuinit
-amd_cpuid4(int leaf, union _cpuid_cacheinfo_eax *eax,
-		     union _cpuid_cacheinfo_ebx *ebx,
-		     union _cpuid_cacheinfo_ecx *ecx)
-{
-	unsigned dummy;
-	unsigned line_size, lines_per_tag, assoc, size_in_kb;
-	union l1_cache l1i, l1d;
-	union l2_cache l2;
-	union l3_cache l3;
-	union l1_cache *l1 = &l1d;
-
-	eax->full = 0;
-	ebx->full = 0;
-	ecx->full = 0;
-
-	cpuid(0x80000005, &dummy, &dummy, &l1d.val, &l1i.val);
-	cpuid(0x80000006, &dummy, &dummy, &l2.val, &l3.val);
-
-	switch (leaf) {
-	case 1:
-		l1 = &l1i;
-	case 0:
-		if (!l1->val)
-			return;
-		assoc = assocs[l1->assoc];
-		line_size = l1->line_size;
-		lines_per_tag = l1->lines_per_tag;
-		size_in_kb = l1->size_in_kb;
-		break;
-	case 2:
-		if (!l2.val)
-			return;
-		assoc = assocs[l2.assoc];
-		line_size = l2.line_size;
-		lines_per_tag = l2.lines_per_tag;
-		/* cpu_data has errata corrections for K7 applied */
-		size_in_kb = __this_cpu_read(cpu_info.x86_cache_size);
-		break;
-	case 3:
-		if (!l3.val)
-			return;
-		assoc = assocs[l3.assoc];
-		line_size = l3.line_size;
-		lines_per_tag = l3.lines_per_tag;
-		size_in_kb = l3.size_encoded * 512;
-		if (boot_cpu_has(X86_FEATURE_AMD_DCM)) {
-			size_in_kb = size_in_kb >> 1;
-			assoc = assoc >> 1;
-		}
-		break;
-	default:
-		return;
-	}
-
-	eax->split.is_self_initializing = 1;
-	eax->split.type = types[leaf];
-	eax->split.level = levels[leaf];
-	eax->split.num_threads_sharing = 0;
-	eax->split.num_cores_on_die =
-		__this_cpu_read(cpu_info.x86_max_cores) - 1;
-
-
-	if (assoc == 0xffff)
-		eax->split.is_fully_associative = 1;
-	ebx->split.coherency_line_size = line_size - 1;
-	ebx->split.ways_of_associativity = assoc - 1;
-	ebx->split.physical_line_partition = lines_per_tag - 1;
-	ecx->split.number_of_sets = (size_in_kb * 1024) / line_size /
-		(ebx->split.ways_of_associativity + 1) - 1;
-}
-
-struct _cache_attr {
-	struct attribute attr;
-	ssize_t (*show)(struct _cpuid_cacheinfo *, char *, unsigned int);
-	ssize_t (*store)(struct _cpuid_cacheinfo *, const char *, size_t count,
-			 unsigned int);
-};
-
-#ifdef CONFIG_AMD_NB
-
-/*
- * L3 cache descriptors
- */
-static void __cpuinit amd_calc_l3_indices(struct amd_northbridge *nb)
-{
-	struct amd_l3_cache *l3 = &nb->l3_cache;
-	unsigned int sc0, sc1, sc2, sc3;
-	u32 val = 0;
-
-	pci_read_config_dword(nb->misc, 0x1C4, &val);
-
-	/* calculate subcache sizes */
-	l3->subcaches[0] = sc0 = !(val & BIT(0));
-	l3->subcaches[1] = sc1 = !(val & BIT(4));
-
-	if (boot_cpu_data.x86 == 0x15) {
-		l3->subcaches[0] = sc0 += !(val & BIT(1));
-		l3->subcaches[1] = sc1 += !(val & BIT(5));
-	}
-
-	l3->subcaches[2] = sc2 = !(val & BIT(8))  + !(val & BIT(9));
-	l3->subcaches[3] = sc3 = !(val & BIT(12)) + !(val & BIT(13));
-
-	l3->indices = (max(max3(sc0, sc1, sc2), sc3) << 10) - 1;
-}
-
-static void __cpuinit amd_init_l3_cache(struct _cpuid_cacheinfo_regs *this_leaf,
-					int index)
-{
-	int node;
-
-	/* only for L3, and not in virtualized environments */
-	if (index < 3)
-		return;
-
-	node = amd_get_nb_id(smp_processor_id());
-	this_leaf->nb = node_to_amd_nb(node);
-	if (this_leaf->nb && !this_leaf->nb->l3_cache.indices)
-		amd_calc_l3_indices(this_leaf->nb);
-}
-
-/*
- * check whether a slot used for disabling an L3 index is occupied.
- * @l3: L3 cache descriptor
- * @slot: slot number (0..1)
- *
- * @returns: the disabled index if used or negative value if slot free.
- */
-int amd_get_l3_disable_slot(struct amd_northbridge *nb, unsigned slot)
-{
-	unsigned int reg = 0;
-
-	pci_read_config_dword(nb->misc, 0x1BC + slot * 4, &reg);
-
-	/* check whether this slot is activated already */
-	if (reg & (3UL << 30))
-		return reg & 0xfff;
-
-	return -1;
-}
-
-static ssize_t show_cache_disable(struct _cpuid_cacheinfo *this_leaf, char *buf,
-				  unsigned int slot)
-{
-	int index;
-
-	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
-		return -EINVAL;
-
-	index = amd_get_l3_disable_slot(this_leaf->base.nb, slot);
-	if (index >= 0)
-		return sprintf(buf, "%d\n", index);
-
-	return sprintf(buf, "FREE\n");
-}
-
-#define SHOW_CACHE_DISABLE(slot)					\
-static ssize_t								\
-show_cache_disable_##slot(struct _cpuid_cacheinfo *this_leaf, char *buf,\
-			  unsigned int cpu)				\
-{									\
-	return show_cache_disable(this_leaf, buf, slot);		\
-}
-SHOW_CACHE_DISABLE(0)
-SHOW_CACHE_DISABLE(1)
-
-static void amd_l3_disable_index(struct amd_northbridge *nb, int cpu,
-				 unsigned slot, unsigned long idx)
-{
-	int i;
-
-	idx |= BIT(30);
-
-	/*
-	 *  disable index in all 4 subcaches
-	 */
-	for (i = 0; i < 4; i++) {
-		u32 reg = idx | (i << 20);
-
-		if (!nb->l3_cache.subcaches[i])
-			continue;
-
-		pci_write_config_dword(nb->misc, 0x1BC + slot * 4, reg);
-
-		/*
-		 * We need to WBINVD on a core on the node containing the L3
-		 * cache which indices we disable therefore a simple wbinvd()
-		 * is not sufficient.
-		 */
-		wbinvd_on_cpu(cpu);
-
-		reg |= BIT(31);
-		pci_write_config_dword(nb->misc, 0x1BC + slot * 4, reg);
-	}
-}
-
-/*
- * disable a L3 cache index by using a disable-slot
- *
- * @l3:    L3 cache descriptor
- * @cpu:   A CPU on the node containing the L3 cache
- * @slot:  slot number (0..1)
- * @index: index to disable
- *
- * @return: 0 on success, error status on failure
- */
-int amd_set_l3_disable_slot(struct amd_northbridge *nb, int cpu, unsigned slot,
-			    unsigned long index)
-{
-	int ret = 0;
-
-	/*  check if @slot is already used or the index is already disabled */
-	ret = amd_get_l3_disable_slot(nb, slot);
-	if (ret >= 0)
-		return -EEXIST;
-
-	if (index > nb->l3_cache.indices)
-		return -EINVAL;
-
-	/* check whether the other slot has disabled the same index already */
-	if (index == amd_get_l3_disable_slot(nb, !slot))
-		return -EEXIST;
-
-	amd_l3_disable_index(nb, cpu, slot, index);
-
-	return 0;
-}
-
-static ssize_t store_cache_disable(struct _cpuid_cacheinfo *this_leaf,
-				  const char *buf, size_t count,
-				  unsigned int slot)
-{
-	unsigned long val = 0;
-	int cpu, err = 0;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
-		return -EINVAL;
-
-	cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
-
-	err = amd_set_l3_disable_slot(this_leaf->base.nb, cpu, slot, val);
-	if (err) {
-		if (err == -EEXIST)
-			pr_warning("L3 slot %d in use/index already disabled!\n",
-				   slot);
-		return err;
-	}
-	return count;
-}
-
-#define STORE_CACHE_DISABLE(slot)					\
-static ssize_t								\
-store_cache_disable_##slot(struct _cpuid_cacheinfo *this_leaf,		\
-			   const char *buf, size_t count,		\
-			   unsigned int cpu)				\
-{									\
-	return store_cache_disable(this_leaf, buf, count, slot);	\
-}
-STORE_CACHE_DISABLE(0)
-STORE_CACHE_DISABLE(1)
-
-static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
-		show_cache_disable_0, store_cache_disable_0);
-static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
-		show_cache_disable_1, store_cache_disable_1);
-
-static ssize_t
-show_subcaches(struct _cpuid_cacheinfo *this_leaf, char *buf, unsigned int cpu)
-{
-	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
-		return -EINVAL;
-
-	return sprintf(buf, "%x\n", amd_get_subcaches(cpu));
-}
-
-static ssize_t
-store_subcaches(struct _cpuid_cacheinfo *this_leaf, const char *buf,
-		size_t count, unsigned int cpu)
-{
-	unsigned long val;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	if (!this_leaf->base.nb || !amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
-		return -EINVAL;
-
-	if (strict_strtoul(buf, 16, &val) < 0)
-		return -EINVAL;
-
-	if (amd_set_subcaches(cpu, val))
-		return -EINVAL;
-
-	return count;
-}
-
-static struct _cache_attr subcaches =
-	__ATTR(subcaches, 0644, show_subcaches, store_subcaches);
-
-#else	/* CONFIG_AMD_NB */
-#define amd_init_l3_cache(x, y)
-#endif /* CONFIG_AMD_NB */
-
-static int
-__cpuinit cpuid_cacheinfo_lookup_regs(int index,
-				      struct _cpuid_cacheinfo_regs *this_leaf)
-{
-	union _cpuid_cacheinfo_eax	eax;
-	union _cpuid_cacheinfo_ebx	ebx;
-	union _cpuid_cacheinfo_ecx	ecx;
-	unsigned		edx;
-
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
-		if (cpu_has_topoext)
-			cpuid_count(0x8000001d, index, &eax.full, &ebx.full,
-				    &ecx.full, &edx);
-		else
-			amd_cpuid4(index, &eax, &ebx, &ecx);
-		amd_init_l3_cache(this_leaf, index);
-	} else {
-		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full, &edx);
-	}
-
-	if (eax.split.type == CACHE_TYPE_NULL)
-		return -EIO; /* better error ? */
-
-	this_leaf->eax = eax;
-	this_leaf->ebx = ebx;
-	this_leaf->ecx = ecx;
-	this_leaf->size = (ecx.split.number_of_sets          + 1) *
-			  (ebx.split.coherency_line_size     + 1) *
-			  (ebx.split.physical_line_partition + 1) *
-			  (ebx.split.ways_of_associativity   + 1);
-	return 0;
-}
-
-static int __cpuinit find_num_cache_leaves(void)
-{
-	unsigned int		eax, ebx, ecx, edx;
-	union _cpuid_cacheinfo_eax	cache_eax;
-	int 			i = -1;
-
-	do {
-		++i;
-		/* Do cpuid(4) loop to find out num_cache_leaves */
-		cpuid_count(4, i, &eax, &ebx, &ecx, &edx);
-		cache_eax.full = eax;
-	} while (cache_eax.split.type != CACHE_TYPE_NULL);
-	return i;
-}
-
 unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 {
 	/* Cache sizes */
@@ -723,66 +261,8 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 	return l2;
 }
 
-#ifdef CONFIG_SYSFS
-
-/* pointer to _cpuid_cacheinfo array (for each cache leaf) */
-static DEFINE_PER_CPU(struct _cpuid_cacheinfo *, ci_cpuid_cacheinfo);
-#define CPUID_CACHEINFO_IDX(x, y)	(&((per_cpu(ci_cpuid_cacheinfo, x))[y]))
-
 #ifdef CONFIG_SMP
-
-static int __cpuinit cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
-{
-	struct _cpuid_cacheinfo *this_leaf;
-	int i, sibling;
-
-	if (cpu_has_topoext) {
-		unsigned int apicid = cpu_data(cpu).apicid;
-		int nshared, first;
-
-		if (!per_cpu(ci_cpuid_cacheinfo, cpu))
-			return 0;
-
-		this_leaf = CPUID_CACHEINFO_IDX(cpu, index);
-		nshared = 1 + this_leaf->base.eax.split.num_threads_sharing;
-		first = apicid - apicid % nshared;
-
-		for_each_online_cpu(i) {
-			if (cpu_data(i).apicid < first ||
-			    cpu_data(i).apicid >= first + nshared)
-				continue;
-
-			if (!per_cpu(ci_cpuid_cacheinfo, i))
-				continue;
-
-			this_leaf = CPUID_CACHEINFO_IDX(i, index);
-			for_each_online_cpu(sibling) {
-				if (cpu_data(sibling).apicid < first ||
-				    cpu_data(sibling).apicid >= first + nshared)
-					continue;
-
-				set_bit(sibling, this_leaf->shared_cpu_map);
-			}
-		}
-	} else if (index == 3) {
-		for_each_cpu(i, cpu_llc_shared_mask(cpu)) {
-			if (!per_cpu(ci_cpuid_cacheinfo, i))
-				continue;
-			this_leaf = CPUID_CACHEINFO_IDX(i, index);
-			for_each_cpu(sibling, cpu_llc_shared_mask(cpu)) {
-				if (!cpu_online(sibling))
-					continue;
-				set_bit(sibling, this_leaf->shared_cpu_map);
-			}
-		}
-	} else {
-		return 0;
-	}
-
-	return 1;
-}
-
-static void __cpuinit cache_shared_intel_cpu_map_setup(unsigned int cpu, int index)
+void __cpuinit cache_shared_intel_cpu_map_setup(unsigned int cpu, int index)
 {
 	struct _cpuid_cacheinfo *this_leaf, *sibling_leaf;
 	unsigned long num_threads_sharing;
@@ -812,435 +292,4 @@ static void __cpuinit cache_shared_intel_cpu_map_setup(unsigned int cpu, int ind
 		}
 	}
 }
-
-static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
-{
-	if (cpu_data(cpu).x86_vendor == X86_VENDOR_AMD) {
-		cache_shared_amd_cpu_map_setup(cpu, index);
-	} else {
-		cache_shared_intel_cpu_map_setup(cpu, index);
-	}
-}
-
-static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
-{
-	struct _cpuid_cacheinfo	*this_leaf, *sibling_leaf;
-	int sibling;
-
-	this_leaf = CPUID_CACHEINFO_IDX(cpu, index);
-	for_each_cpu(sibling, to_cpumask(this_leaf->shared_cpu_map)) {
-		sibling_leaf = CPUID_CACHEINFO_IDX(sibling, index);
-		cpumask_clear_cpu(cpu,
-				  to_cpumask(sibling_leaf->shared_cpu_map));
-	}
-}
-#else
-static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
-{
-}
-
-static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
-{
-}
-#endif
-
-static void __cpuinit free_cache_attributes(unsigned int cpu)
-{
-	int i;
-
-	for (i = 0; i < num_cache_leaves; i++)
-		cache_remove_shared_cpu_map(cpu, i);
-
-	kfree(per_cpu(ci_cpuid_cacheinfo, cpu));
-	per_cpu(ci_cpuid_cacheinfo, cpu) = NULL;
-}
-
-static void __cpuinit get_cpu_leaves(void *_retval)
-{
-	int j, *retval = _retval, cpu = smp_processor_id();
-
-	/* Do cpuid and store the results */
-	for (j = 0; j < num_cache_leaves; j++) {
-		struct _cpuid_cacheinfo *this_leaf =
-			CPUID_CACHEINFO_IDX(cpu, j);
-
-		*retval = cpuid_cacheinfo_lookup_regs(j, &this_leaf->base);
-		if (unlikely(*retval < 0)) {
-			int i;
-
-			for (i = 0; i < j; i++)
-				cache_remove_shared_cpu_map(cpu, i);
-			break;
-		}
-		cache_shared_cpu_map_setup(cpu, j);
-	}
-}
-
-static int __cpuinit detect_cache_attributes(unsigned int cpu)
-{
-	int			retval;
-
-	if (num_cache_leaves == 0)
-		return -ENOENT;
-
-	per_cpu(ci_cpuid_cacheinfo, cpu) = kzalloc(
-	    sizeof(struct _cpuid_cacheinfo) * num_cache_leaves, GFP_KERNEL);
-	if (per_cpu(ci_cpuid_cacheinfo, cpu) == NULL)
-		return -ENOMEM;
-
-	smp_call_function_single(cpu, get_cpu_leaves, &retval, true);
-	if (retval) {
-		kfree(per_cpu(ci_cpuid_cacheinfo, cpu));
-		per_cpu(ci_cpuid_cacheinfo, cpu) = NULL;
-	}
-
-	return retval;
-}
-
-#include <linux/kobject.h>
-#include <linux/sysfs.h>
-#include <linux/cpu.h>
-
-/* pointer to kobject for cpuX/cache */
-static DEFINE_PER_CPU(struct kobject *, ci_cache_kobject);
-
-struct _index_kobject {
-	struct kobject kobj;
-	unsigned int cpu;
-	unsigned short index;
-};
-
-/* pointer to array of kobjects for cpuX/cache/indexY */
-static DEFINE_PER_CPU(struct _index_kobject *, ci_index_kobject);
-#define INDEX_KOBJECT_PTR(x, y)		(&((per_cpu(ci_index_kobject, x))[y]))
-
-#define show_one_plus(file_name, object, val)				\
-static ssize_t show_##file_name(struct _cpuid_cacheinfo *this_leaf, char *buf, \
-				unsigned int cpu)			\
-{									\
-	return sprintf(buf, "%lu\n", (unsigned long)this_leaf->object + val); \
-}
-
-show_one_plus(level, base.eax.split.level, 0);
-show_one_plus(coherency_line_size, base.ebx.split.coherency_line_size, 1);
-show_one_plus(physical_line_partition, base.ebx.split.physical_line_partition, 1);
-show_one_plus(ways_of_associativity, base.ebx.split.ways_of_associativity, 1);
-show_one_plus(number_of_sets, base.ecx.split.number_of_sets, 1);
-
-static ssize_t show_size(struct _cpuid_cacheinfo *this_leaf, char *buf,
-			 unsigned int cpu)
-{
-	return sprintf(buf, "%luK\n", this_leaf->base.size / 1024);
-}
-
-static ssize_t show_shared_cpu_map_func(struct _cpuid_cacheinfo *this_leaf,
-					int type, char *buf)
-{
-	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
-	int n = 0;
-
-	if (len > 1) {
-		const struct cpumask *mask;
-
-		mask = to_cpumask(this_leaf->shared_cpu_map);
-		n = type ?
-			cpulist_scnprintf(buf, len-2, mask) :
-			cpumask_scnprintf(buf, len-2, mask);
-		buf[n++] = '\n';
-		buf[n] = '\0';
-	}
-	return n;
-}
-
-static inline ssize_t show_shared_cpu_map(struct _cpuid_cacheinfo *leaf,
-					  char *buf, unsigned int cpu)
-{
-	return show_shared_cpu_map_func(leaf, 0, buf);
-}
-
-static inline ssize_t show_shared_cpu_list(struct _cpuid_cacheinfo *leaf,
-					   char *buf, unsigned int cpu)
-{
-	return show_shared_cpu_map_func(leaf, 1, buf);
-}
-
-static ssize_t show_type(struct _cpuid_cacheinfo *this_leaf, char *buf,
-			 unsigned int cpu)
-{
-	switch (this_leaf->base.eax.split.type) {
-	case CACHE_TYPE_DATA:
-		return sprintf(buf, "Data\n");
-	case CACHE_TYPE_INST:
-		return sprintf(buf, "Instruction\n");
-	case CACHE_TYPE_UNIFIED:
-		return sprintf(buf, "Unified\n");
-	default:
-		return sprintf(buf, "Unknown\n");
-	}
-}
-
-#define to_object(k)	container_of(k, struct _index_kobject, kobj)
-#define to_attr(a)	container_of(a, struct _cache_attr, attr)
-
-#define define_one_ro(_name) \
-static struct _cache_attr _name = \
-	__ATTR(_name, 0444, show_##_name, NULL)
-
-define_one_ro(level);
-define_one_ro(type);
-define_one_ro(coherency_line_size);
-define_one_ro(physical_line_partition);
-define_one_ro(ways_of_associativity);
-define_one_ro(number_of_sets);
-define_one_ro(size);
-define_one_ro(shared_cpu_map);
-define_one_ro(shared_cpu_list);
-
-static struct attribute *default_attrs[] = {
-	&type.attr,
-	&level.attr,
-	&coherency_line_size.attr,
-	&physical_line_partition.attr,
-	&ways_of_associativity.attr,
-	&number_of_sets.attr,
-	&size.attr,
-	&shared_cpu_map.attr,
-	&shared_cpu_list.attr,
-	NULL
-};
-
-#ifdef CONFIG_AMD_NB
-static struct attribute ** __cpuinit amd_l3_attrs(
-	struct attribute **default_attrs)
-{
-	static struct attribute **attrs;
-	int n;
-
-	if (attrs)
-		return attrs;
-
-	n = sizeof (default_attrs) / sizeof (struct attribute *);
-
-	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
-		n += 2;
-
-	if (amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
-		n += 1;
-
-	attrs = kzalloc(n * sizeof (struct attribute *), GFP_KERNEL);
-	if (attrs == NULL)
-		return attrs = default_attrs;
-
-	for (n = 0; default_attrs[n]; n++)
-		attrs[n] = default_attrs[n];
-
-	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE)) {
-		attrs[n++] = &cache_disable_0.attr;
-		attrs[n++] = &cache_disable_1.attr;
-	}
-
-	if (amd_nb_has_feature(AMD_NB_L3_PARTITIONING))
-		attrs[n++] = &subcaches.attr;
-
-	return attrs;
-}
-#endif
-
-static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
-{
-	struct _cache_attr *fattr = to_attr(attr);
-	struct _index_kobject *this_leaf = to_object(kobj);
-	ssize_t ret;
-
-	ret = fattr->show ?
-		fattr->show(CPUID_CACHEINFO_IDX(this_leaf->cpu,
-						this_leaf->index),
-			buf, this_leaf->cpu) :
-		0;
-	return ret;
-}
-
-static ssize_t store(struct kobject *kobj, struct attribute *attr,
-		     const char *buf, size_t count)
-{
-	struct _cache_attr *fattr = to_attr(attr);
-	struct _index_kobject *this_leaf = to_object(kobj);
-	ssize_t ret;
-
-	ret = fattr->store ?
-		fattr->store(CPUID_CACHEINFO_IDX(this_leaf->cpu,
-						 this_leaf->index),
-			buf, count, this_leaf->cpu) :
-		0;
-	return ret;
-}
-
-static const struct sysfs_ops sysfs_ops = {
-	.show   = show,
-	.store  = store,
-};
-
-static struct kobj_type ktype_cache = {
-	.sysfs_ops	= &sysfs_ops,
-	.default_attrs	= default_attrs,
-};
-
-static struct kobj_type ktype_percpu_entry = {
-	.sysfs_ops	= &sysfs_ops,
-};
-
-static void __cpuinit cpuid_cacheinfo_sysfs_exit(unsigned int cpu)
-{
-	kfree(per_cpu(ci_cache_kobject, cpu));
-	kfree(per_cpu(ci_index_kobject, cpu));
-	per_cpu(ci_cache_kobject, cpu) = NULL;
-	per_cpu(ci_index_kobject, cpu) = NULL;
-	free_cache_attributes(cpu);
-}
-
-static int __cpuinit cpuid_cacheinfo_sysfs_init(unsigned int cpu)
-{
-	int err;
-
-	if (num_cache_leaves == 0)
-		return -ENOENT;
-
-	err = detect_cache_attributes(cpu);
-	if (err)
-		return err;
-
-	/* Allocate all required memory */
-	per_cpu(ci_cache_kobject, cpu) =
-		kzalloc(sizeof(struct kobject), GFP_KERNEL);
-	if (unlikely(per_cpu(ci_cache_kobject, cpu) == NULL))
-		goto err_out;
-
-	per_cpu(ci_index_kobject, cpu) = kzalloc(
-	    sizeof(struct _index_kobject) * num_cache_leaves, GFP_KERNEL);
-	if (unlikely(per_cpu(ci_index_kobject, cpu) == NULL))
-		goto err_out;
-
-	return 0;
-
-err_out:
-	cpuid_cacheinfo_sysfs_exit(cpu);
-	return -ENOMEM;
-}
-
-static DECLARE_BITMAP(cache_dev_map, NR_CPUS);
-
-/* Add/Remove cache interface for CPU device */
-static int __cpuinit cache_add_dev(struct device *dev)
-{
-	unsigned int cpu = dev->id;
-	unsigned long i, j;
-	struct _index_kobject *this_object;
-	struct _cpuid_cacheinfo *this_leaf;
-	int retval;
-
-	retval = cpuid_cacheinfo_sysfs_init(cpu);
-	if (unlikely(retval < 0))
-		return retval;
-
-	retval = kobject_init_and_add(per_cpu(ci_cache_kobject, cpu),
-				      &ktype_percpu_entry,
-				      &dev->kobj, "%s", "cache");
-	if (retval < 0) {
-		cpuid_cacheinfo_sysfs_exit(cpu);
-		return retval;
-	}
-
-	for (i = 0; i < num_cache_leaves; i++) {
-		this_object = INDEX_KOBJECT_PTR(cpu, i);
-		this_object->cpu = cpu;
-		this_object->index = i;
-
-		this_leaf = CPUID_CACHEINFO_IDX(cpu, i);
-
-		ktype_cache.default_attrs = default_attrs;
-#ifdef CONFIG_AMD_NB
-		if (this_leaf->base.nb)
-			ktype_cache.default_attrs = amd_l3_attrs(default_attrs);
-#endif
-		retval = kobject_init_and_add(&(this_object->kobj),
-					      &ktype_cache,
-					      per_cpu(ci_cache_kobject, cpu),
-					      "index%1lu", i);
-		if (unlikely(retval)) {
-			for (j = 0; j < i; j++)
-				kobject_put(&(INDEX_KOBJECT_PTR(cpu, j)->kobj));
-			kobject_put(per_cpu(ci_cache_kobject, cpu));
-			cpuid_cacheinfo_sysfs_exit(cpu);
-			return retval;
-		}
-		kobject_uevent(&(this_object->kobj), KOBJ_ADD);
-	}
-	cpumask_set_cpu(cpu, to_cpumask(cache_dev_map));
-
-	kobject_uevent(per_cpu(ci_cache_kobject, cpu), KOBJ_ADD);
-	return 0;
-}
-
-static void __cpuinit cache_remove_dev(struct device *dev)
-{
-	unsigned int cpu = dev->id;
-	unsigned long i;
-
-	if (per_cpu(ci_cpuid_cacheinfo, cpu) == NULL)
-		return;
-	if (!cpumask_test_cpu(cpu, to_cpumask(cache_dev_map)))
-		return;
-	cpumask_clear_cpu(cpu, to_cpumask(cache_dev_map));
-
-	for (i = 0; i < num_cache_leaves; i++)
-		kobject_put(&(INDEX_KOBJECT_PTR(cpu, i)->kobj));
-	kobject_put(per_cpu(ci_cache_kobject, cpu));
-	cpuid_cacheinfo_sysfs_exit(cpu);
-}
-
-static int __cpuinit cacheinfo_cpu_callback(struct notifier_block *nfb,
-					unsigned long action, void *hcpu)
-{
-	unsigned int cpu = (unsigned long)hcpu;
-	struct device *dev;
-
-	dev = get_cpu_device(cpu);
-	switch (action) {
-	case CPU_ONLINE:
-	case CPU_ONLINE_FROZEN:
-		cache_add_dev(dev);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		cache_remove_dev(dev);
-		break;
-	}
-	return NOTIFY_OK;
-}
-
-static struct notifier_block __cpuinitdata cacheinfo_cpu_notifier = {
-	.notifier_call = cacheinfo_cpu_callback,
-};
-
-static int __cpuinit cache_sysfs_init(void)
-{
-	int i;
-
-	if (num_cache_leaves == 0)
-		return 0;
-
-	for_each_online_cpu(i) {
-		int err;
-		struct device *dev = get_cpu_device(i);
-
-		err = cache_add_dev(dev);
-		if (err)
-			return err;
-	}
-	register_hotcpu_notifier(&cacheinfo_cpu_notifier);
-	return 0;
-}
-
-device_initcall(cache_sysfs_init);
-
 #endif
-- 
1.7.7


