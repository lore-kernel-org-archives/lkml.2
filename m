Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1BLRMn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 12:12:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44248 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab1BLRL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 12:11:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=r0dptWQ85OTFWYhLbKENdIQsqq5jMefHyGUUgJjXhGO2+5IKb8DEXUFIAsZ568xybc
         K/nmqjoeLDfZa4AH9h5leHhTnAnZyio8n7wf79u0sONede+yQ0w5ERT2ivkXyQbjVJJ9
         FbzyWUSoeqQp6KMIYsPTMeQ6kybv1fk7YRUgY=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/26] x86-64, NUMA: Move apicid to numa mapping initialization from amd_scan_nodes() to amd_numa_init()
Date: Sat, 12 Feb 2011 18:10:47 +0100
Message-Id: <1297530663-26234-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297530663-26234-1-git-send-email-tj@kernel.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings amd initialization behavior closer to that of acpi.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/amdtopology_64.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index c5eddfa..4056333 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -74,8 +74,9 @@ int __init amd_numa_init(void)
 	unsigned long end = PFN_PHYS(max_pfn);
 	unsigned numnodes;
 	unsigned long prevbase;
-	int i, nb;
+	int i, j, nb;
 	u32 nodeid, reg;
+	unsigned int bits, cores, apicid_base;
 
 	if (!early_pci_allowed())
 		return -EINVAL;
@@ -176,6 +177,26 @@ int __init amd_numa_init(void)
 
 	if (!nodes_weight(mem_nodes_parsed))
 		return -ENOENT;
+
+	/*
+	 * We seem to have valid NUMA configuration.  Map apicids to nodes
+	 * using the coreid bits from early_identify_cpu.
+	 */
+	bits = boot_cpu_data.x86_coreid_bits;
+	cores = 1 << bits;
+	apicid_base = 0;
+
+	/* get the APIC ID of the BSP early for systems with apicid lifting */
+	early_get_boot_cpu_id();
+	if (boot_cpu_physical_apicid > 0) {
+		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
+		apicid_base = boot_cpu_physical_apicid;
+	}
+
+	for_each_node_mask(i, cpu_nodes_parsed)
+		for (j = apicid_base; j < cores + apicid_base; j++)
+			set_apicid_to_node((i << bits) + j, i);
+
 	return 0;
 }
 
@@ -251,9 +272,6 @@ void __init amd_fake_nodes(const struct bootnode *nodes, int nr_nodes)
 
 int __init amd_scan_nodes(void)
 {
-	unsigned int bits;
-	unsigned int cores;
-	unsigned int apicid_base;
 	int i;
 
 	memnode_shift = compute_hash_shift(nodes, 8, NULL);
@@ -264,24 +282,10 @@ int __init amd_scan_nodes(void)
 	pr_info("Using node hash shift of %d\n", memnode_shift);
 
 	/* use the coreid bits from early_identify_cpu */
-	bits = boot_cpu_data.x86_coreid_bits;
-	cores = (1<<bits);
-	apicid_base = 0;
-	/* get the APIC ID of the BSP early for systems with apicid lifting */
-	early_get_boot_cpu_id();
-	if (boot_cpu_physical_apicid > 0) {
-		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
-		apicid_base = boot_cpu_physical_apicid;
-	}
-
 	for_each_node_mask(i, node_possible_map) {
-		int j;
-
 		memblock_x86_register_active_regions(i,
 				nodes[i].start >> PAGE_SHIFT,
 				nodes[i].end >> PAGE_SHIFT);
-		for (j = apicid_base; j < cores + apicid_base; j++)
-			set_apicid_to_node((i << bits) + j, i);
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
 
-- 
1.7.1

