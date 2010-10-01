Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0JAHGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:06:35 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:45266 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab0JAHG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:06:29 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org
Cc: paulus@samba.org, Ian Munsie <imunsie@au1.ibm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wolfram Sang <w.sang@pengutronix.de>, Michal Simek <monstr@monstr.eu>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 09/18] powerpc: Support device tree regardless of CPU endianness
Date: Fri,  1 Oct 2010 17:06:02 +1000
Message-Id: <1285916771-18033-10-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

On PowerPC the device tree is always big endian, but the CPU could be
either, so add be32_to_cpu where appropriate and change the types of
device tree data to __be32 etc to allow sparse to locate endian issues.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/kernel/prom.c |   60 ++++++++++++++++++++++----------------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index fed9bf6..9b9ebb2 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -188,16 +188,16 @@ static void __init check_cpu_pa_features(unsigned long node)
 #ifdef CONFIG_PPC_STD_MMU_64
 static void __init check_cpu_slb_size(unsigned long node)
 {
-	u32 *slb_size_ptr;
+	__be32 *slb_size_ptr;
 
 	slb_size_ptr = of_get_flat_dt_prop(node, "slb-size", NULL);
 	if (slb_size_ptr != NULL) {
-		mmu_slb_size = *slb_size_ptr;
+		mmu_slb_size = be32_to_cpup(slb_size_ptr);
 		return;
 	}
 	slb_size_ptr = of_get_flat_dt_prop(node, "ibm,slb-size", NULL);
 	if (slb_size_ptr != NULL) {
-		mmu_slb_size = *slb_size_ptr;
+		mmu_slb_size = be32_to_cpup(slb_size_ptr);
 	}
 }
 #else
@@ -252,11 +252,11 @@ static void __init check_cpu_feature_properties(unsigned long node)
 {
 	unsigned long i;
 	struct feature_property *fp = feature_properties;
-	const u32 *prop;
+	const __be32 *prop;
 
 	for (i = 0; i < ARRAY_SIZE(feature_properties); ++i, ++fp) {
 		prop = of_get_flat_dt_prop(node, fp->name, NULL);
-		if (prop && *prop >= fp->min_value) {
+		if (prop && be32_to_cpup(prop) >= fp->min_value) {
 			cur_cpu_spec->cpu_features |= fp->cpu_feature;
 			cur_cpu_spec->cpu_user_features |= fp->cpu_user_ftr;
 		}
@@ -269,8 +269,8 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 {
 	static int logical_cpuid = 0;
 	char *type = of_get_flat_dt_prop(node, "device_type", NULL);
-	const u32 *prop;
-	const u32 *intserv;
+	const __be32 *prop;
+	const __be32 *intserv;
 	int i, nthreads;
 	unsigned long len;
 	int found = 0;
@@ -297,9 +297,9 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 		 * version 2 of the kexec param format adds the phys cpuid of
 		 * booted proc.
 		 */
-		if (initial_boot_params && initial_boot_params->version >= 2) {
-			if (intserv[i] ==
-					initial_boot_params->boot_cpuid_phys) {
+		if (initial_boot_params && be32_to_cpu(initial_boot_params->version) >= 2) {
+			if (be32_to_cpu(intserv[i]) ==
+					be32_to_cpu(initial_boot_params->boot_cpuid_phys)) {
 				found = 1;
 				break;
 			}
@@ -324,9 +324,9 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 
 	if (found) {
 		DBG("boot cpu: logical %d physical %d\n", logical_cpuid,
-			intserv[i]);
+			be32_to_cpu(intserv[i]));
 		boot_cpuid = logical_cpuid;
-		set_hard_smp_processor_id(boot_cpuid, intserv[i]);
+		set_hard_smp_processor_id(boot_cpuid, be32_to_cpu(intserv[i]));
 
 		/*
 		 * PAPR defines "logical" PVR values for cpus that
@@ -343,8 +343,8 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 		 * it uses 0x0f000001.
 		 */
 		prop = of_get_flat_dt_prop(node, "cpu-version", NULL);
-		if (prop && (*prop & 0xff000000) == 0x0f000000)
-			identify_cpu(0, *prop);
+		if (prop && (be32_to_cpup(prop) & 0xff000000) == 0x0f000000)
+			identify_cpu(0, be32_to_cpup(prop));
 
 		identical_pvr_fixup(node);
 	}
@@ -365,7 +365,7 @@ static int __init early_init_dt_scan_cpus(unsigned long node,
 
 void __init early_init_dt_scan_chosen_arch(unsigned long node)
 {
-	unsigned long *lprop;
+	unsigned long *lprop; /* All these set by kernel, so no need to convert endian */
 
 #ifdef CONFIG_PPC64
 	/* check if iommu is forced on or off */
@@ -524,16 +524,16 @@ void __init early_init_dt_setup_initrd_arch(unsigned long start,
 static void __init early_reserve_mem(void)
 {
 	u64 base, size;
-	u64 *reserve_map;
+	__be64 *reserve_map;
 	unsigned long self_base;
 	unsigned long self_size;
 
-	reserve_map = (u64 *)(((unsigned long)initial_boot_params) +
-					initial_boot_params->off_mem_rsvmap);
+	reserve_map = (__be64 *)(((unsigned long)initial_boot_params) +
+			be32_to_cpu(initial_boot_params->off_mem_rsvmap));
 
 	/* before we do anything, lets reserve the dt blob */
 	self_base = __pa((unsigned long)initial_boot_params);
-	self_size = initial_boot_params->totalsize;
+	self_size = be32_to_cpu(initial_boot_params->totalsize);
 	memblock_reserve(self_base, self_size);
 
 #ifdef CONFIG_BLK_DEV_INITRD
@@ -547,13 +547,13 @@ static void __init early_reserve_mem(void)
 	 * Handle the case where we might be booting from an old kexec
 	 * image that setup the mem_rsvmap as pairs of 32-bit values
 	 */
-	if (*reserve_map > 0xffffffffull) {
+	if (be64_to_cpup(reserve_map) > 0xffffffffull) {
 		u32 base_32, size_32;
-		u32 *reserve_map_32 = (u32 *)reserve_map;
+		__be32 *reserve_map_32 = (__be32 *)reserve_map;
 
 		while (1) {
-			base_32 = *(reserve_map_32++);
-			size_32 = *(reserve_map_32++);
+			base_32 = be32_to_cpup(reserve_map_32++);
+			size_32 = be32_to_cpup(reserve_map_32++);
 			if (size_32 == 0)
 				break;
 			/* skip if the reservation is for the blob */
@@ -566,8 +566,8 @@ static void __init early_reserve_mem(void)
 	}
 #endif
 	while (1) {
-		base = *(reserve_map++);
-		size = *(reserve_map++);
+		base = be64_to_cpup(reserve_map++);
+		size = be64_to_cpup(reserve_map++);
 		if (size == 0)
 			break;
 		DBG("reserving: %llx -> %llx\n", base, size);
@@ -860,7 +860,7 @@ struct device_node *of_get_cpu_node(int cpu, unsigned int *thread)
 	hardid = get_hard_smp_processor_id(cpu);
 
 	for_each_node_by_type(np, "cpu") {
-		const u32 *intserv;
+		const __be32 *intserv;
 		unsigned int plen, t;
 
 		/* Check for ibm,ppc-interrupt-server#s. If it doesn't exist
@@ -869,10 +869,10 @@ struct device_node *of_get_cpu_node(int cpu, unsigned int *thread)
 		intserv = of_get_property(np, "ibm,ppc-interrupt-server#s",
 				&plen);
 		if (intserv == NULL) {
-			const u32 *reg = of_get_property(np, "reg", NULL);
+			const __be32 *reg = of_get_property(np, "reg", NULL);
 			if (reg == NULL)
 				continue;
-			if (*reg == hardid) {
+			if (be32_to_cpup(reg) == hardid) {
 				if (thread)
 					*thread = 0;
 				return np;
@@ -880,7 +880,7 @@ struct device_node *of_get_cpu_node(int cpu, unsigned int *thread)
 		} else {
 			plen /= sizeof(u32);
 			for (t = 0; t < plen; t++) {
-				if (hardid == intserv[t]) {
+				if (hardid == be32_to_cpu(intserv[t])) {
 					if (thread)
 						*thread = t;
 					return np;
@@ -900,7 +900,7 @@ static int __init export_flat_device_tree(void)
 	struct dentry *d;
 
 	flat_dt_blob.data = initial_boot_params;
-	flat_dt_blob.size = initial_boot_params->totalsize;
+	flat_dt_blob.size = be32_to_cpu(initial_boot_params->totalsize);
 
 	d = debugfs_create_blob("flat-device-tree", S_IFREG | S_IRUSR,
 				powerpc_debugfs_root, &flat_dt_blob);
-- 
1.7.1

