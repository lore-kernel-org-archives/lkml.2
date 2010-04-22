Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0DVOHY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 10:07:24 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41293 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab0DVOHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 10:07:14 -0400
From: Borislav Petkov <bp@amd64.org>
To: <hpa@zytor.com>, <mingo@elte.hu>, <tglx@linutronix.de>
Cc: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
       Frank Arnold <frank.arnold@amd.com>,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/5] x86, cacheinfo: Reorganize AMD L3 cache structure
Date: Thu, 22 Apr 2010 16:07:00 +0200
Message-Id: <1271945222-5283-4-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271945222-5283-1-git-send-email-bp@amd64.org>
References: <1271945222-5283-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add a struct representing L3 cache attributes (subcache sizes and
indices count) and move the respective members out of _cpuid4_info.
Also, stash the struct pci_dev ptr into the struct simplifying the code
even more.

There should be no functionality change resulting from this patch except
slightly slimming the _cpuid4_info per-cpu vars.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   53 ++++++++++++++++++++-------------
 1 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 5ab14c8..ff663ca 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -148,13 +148,19 @@ union _cpuid4_leaf_ecx {
 	u32 full;
 };
 
+struct amd_l3_cache {
+	struct	 pci_dev *dev;
+	bool	 can_disable;
+	unsigned indices;
+	u8	 subcaches[4];
+};
+
 struct _cpuid4_info {
 	union _cpuid4_leaf_eax eax;
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
-	bool can_disable;
-	unsigned int l3_indices;
+	struct amd_l3_cache *l3;
 	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
 };
 
@@ -164,8 +170,7 @@ struct _cpuid4_info_regs {
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
-	bool can_disable;
-	unsigned int l3_indices;
+	struct amd_l3_cache *l3;
 };
 
 unsigned short			num_cache_leaves;
@@ -302,7 +307,7 @@ struct _cache_attr {
 };
 
 #ifdef CONFIG_CPU_SUP_AMD
-static unsigned int __cpuinit amd_calc_l3_indices(void)
+static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
 {
 	/*
 	 * We're called over smp_call_function_single() and therefore
@@ -317,12 +322,14 @@ static unsigned int __cpuinit amd_calc_l3_indices(void)
 	pci_read_config_dword(dev, 0x1C4, &val);
 
 	/* calculate subcache sizes */
-	sc0 = !(val & BIT(0));
-	sc1 = !(val & BIT(4));
-	sc2 = !(val & BIT(8))  + !(val & BIT(9));
-	sc3 = !(val & BIT(12)) + !(val & BIT(13));
+	l3->subcaches[0] = sc0 = !(val & BIT(0));
+	l3->subcaches[1] = sc1 = !(val & BIT(4));
+	l3->subcaches[2] = sc2 = !(val & BIT(8))  + !(val & BIT(9));
+	l3->subcaches[3] = sc3 = !(val & BIT(12)) + !(val & BIT(13));
+
+	l3->indices = (max(max(max(sc0, sc1), sc2), sc3) << 10) - 1;
 
-	return (max(max(max(sc0, sc1), sc2), sc3) << 10) - 1;
+	l3->dev = dev;
 }
 
 static void __cpuinit
@@ -348,19 +355,23 @@ amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 	if (num_k8_northbridges == 0)
 		return;
 
-	this_leaf->can_disable = true;
-	this_leaf->l3_indices  = amd_calc_l3_indices();
+	this_leaf->l3 = kzalloc(sizeof(struct amd_l3_cache), GFP_ATOMIC);
+	if (!this_leaf->l3) {
+		printk(KERN_WARNING "Error allocating L3 struct\n");
+		return;
+	}
+
+	this_leaf->l3->can_disable = true;
+	amd_calc_l3_indices(this_leaf->l3);
 }
 
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 				  unsigned int index)
 {
-	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = amd_get_nb_id(cpu);
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	struct pci_dev *dev = this_leaf->l3->dev;
 	unsigned int reg = 0;
 
-	if (!this_leaf->can_disable)
+	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
 		return -EINVAL;
 
 	if (!dev)
@@ -382,15 +393,14 @@ SHOW_CACHE_DISABLE(1)
 static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	const char *buf, size_t count, unsigned int index)
 {
+	struct pci_dev *dev = this_leaf->l3->dev;
 	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = amd_get_nb_id(cpu);
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
 	unsigned long val = 0;
 
 #define SUBCACHE_MASK	(3UL << 20)
 #define SUBCACHE_INDEX	0xfff
 
-	if (!this_leaf->can_disable)
+	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
 		return -EINVAL;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -404,7 +414,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 
 	/* do not allow writes outside of allowed bits */
 	if ((val & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
-	    ((val & SUBCACHE_INDEX) > this_leaf->l3_indices))
+	    ((val & SUBCACHE_INDEX) > this_leaf->l3->indices))
 		return -EINVAL;
 
 	val |= BIT(30);
@@ -708,6 +718,7 @@ static void __cpuinit free_cache_attributes(unsigned int cpu)
 	for (i = 0; i < num_cache_leaves; i++)
 		cache_remove_shared_cpu_map(cpu, i);
 
+	kfree(per_cpu(ici_cpuid4_info, cpu)->l3);
 	kfree(per_cpu(ici_cpuid4_info, cpu));
 	per_cpu(ici_cpuid4_info, cpu) = NULL;
 }
@@ -992,7 +1003,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 
 		this_leaf = CPUID4_INFO_IDX(cpu, i);
 
-		if (this_leaf->can_disable)
+		if (this_leaf->l3 && this_leaf->l3->can_disable)
 			ktype_cache.default_attrs = default_l3_attrs;
 		else
 			ktype_cache.default_attrs = default_attrs;
-- 
1.7.1.rc1

