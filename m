Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab0DVTsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:48:14 -0400
Received: from kroah.org ([198.145.64.141]:41084 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756610Ab0DVT3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:29:00 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:17 2010
Message-Id: <20100422190917.467545308@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:09:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [113/197] x86, cacheinfo: Calculate L3 indices
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit 048a8774ca43488d78605031f11cc206d7a2682a upstream.

We need to know the valid L3 indices interval when disabling them over
/sysfs. Do that when the core is brought online and add boundary checks
to the sysfs .store attribute.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
LKML-Reference: <1264172467-25155-6-git-send-email-bp@amd64.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   35 ++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -151,7 +151,8 @@ struct _cpuid4_info {
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
-	unsigned long can_disable;
+	bool can_disable;
+	unsigned int l3_indices;
 	DECLARE_BITMAP(shared_cpu_map, NR_CPUS);
 };
 
@@ -161,7 +162,8 @@ struct _cpuid4_info_regs {
 	union _cpuid4_leaf_ebx ebx;
 	union _cpuid4_leaf_ecx ecx;
 	unsigned long size;
-	unsigned long can_disable;
+	bool can_disable;
+	unsigned int l3_indices;
 };
 
 unsigned short			num_cache_leaves;
@@ -291,6 +293,29 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_
 		(ebx->split.ways_of_associativity + 1) - 1;
 }
 
+static unsigned int __cpuinit amd_calc_l3_indices(void)
+{
+	/*
+	 * We're called over smp_call_function_single() and therefore
+	 * are on the correct cpu.
+	 */
+	int cpu = smp_processor_id();
+	int node = cpu_to_node(cpu);
+	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	unsigned int sc0, sc1, sc2, sc3;
+	u32 val;
+
+	pci_read_config_dword(dev, 0x1C4, &val);
+
+	/* calculate subcache sizes */
+	sc0 = !(val & BIT(0));
+	sc1 = !(val & BIT(4));
+	sc2 = !(val & BIT(8))  + !(val & BIT(9));
+	sc3 = !(val & BIT(12)) + !(val & BIT(13));
+
+	return (max(max(max(sc0, sc1), sc2), sc3) << 10) - 1;
+}
+
 static void __cpuinit
 amd_check_l3_disable(int index, struct _cpuid4_info_regs *this_leaf)
 {
@@ -306,7 +331,8 @@ amd_check_l3_disable(int index, struct _
 	     (boot_cpu_data.x86_mask  < 0x1)))
 		return;
 
-	this_leaf->can_disable = 1;
+	this_leaf->can_disable = true;
+	this_leaf->l3_indices  = amd_calc_l3_indices();
 }
 
 static int
@@ -780,7 +806,8 @@ static ssize_t store_cache_disable(struc
 		return -EINVAL;
 
 	/* do not allow writes outside of allowed bits */
-	if (val & ~(SUBCACHE_MASK | SUBCACHE_INDEX))
+	if ((val & ~(SUBCACHE_MASK | SUBCACHE_INDEX)) ||
+	    ((val & SUBCACHE_INDEX) > this_leaf->l3_indices))
 		return -EINVAL;
 
 	val |= BIT(30);


