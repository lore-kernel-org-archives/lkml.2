Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759103Ab1BPMX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:23:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542Ab1BPMWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:22:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=I6pUaKxDaHkBnTTaPy/gVScDx8bNiptQj9BSQXhzxq47eZ0o8x6Ib60kLKVbaKZQIH
         hzmO8kQOApwpto1mDahI60OVpx5TJOh3OBVgZp8VQY/5CEzein2r5Fj7SNWgyD1/RpQo
         I3tV3wohDbj4nSfF87xWzZtpaE2M9WkTImmtk=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 32/33] x86-64, NUMA: Unify emulated apicid -> node mapping transformation
Date: Wed, 16 Feb 2011 13:21:06 +0100
Message-Id: <1297858867-25981-33-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NUMA emulation changes node mappings and thus apicid -> node mapping
needs to be updated accordingly.  srat_64 and amdtopology_64 did this
separately; however, all the necessary information is the mapping from
emulated nodes to physical nodes which is available in
emu_nid_to_phys[].

Implement common __apicid_to_node[] transformation in numa_emulation()
and drop duplicate implementations.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/amdtopology_64.c |    9 ---------
 arch/x86/mm/numa_64.c        |   16 +++++++++++++++-
 arch/x86/mm/srat_64.c        |   24 +-----------------------
 3 files changed, 16 insertions(+), 33 deletions(-)

diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index fd7b609..f37ea2f 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -196,10 +196,6 @@ int __init amd_numa_init(void)
 }
 
 #ifdef CONFIG_NUMA_EMU
-static s16 fake_apicid_to_node[MAX_LOCAL_APIC] __initdata = {
-	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
-};
-
 /*
  * For NUMA emulation, fake proximity domain (_PXM) to node id mappings must be
  * setup to represent the physical topology but reflect the emulated
@@ -224,20 +220,15 @@ void __init amd_fake_nodes(const struct bootnode *nodes, int nr_nodes)
 	for (i = 0; i < nr_nodes; i++) {
 		int index;
 		int nid;
-		int j;
 
 		nid = find_node_by_addr(nodes[i].start);
 		if (nid == NUMA_NO_NODE)
 			continue;
 
 		index = nodeids[nid] << bits;
-		if (fake_apicid_to_node[index + apicid_base] == NUMA_NO_NODE)
-			for (j = apicid_base; j < cores + apicid_base; j++)
-				fake_apicid_to_node[index + j] = i;
 #ifdef CONFIG_ACPI_NUMA
 		__acpi_map_pxm_to_node(nid, i);
 #endif
 	}
-	memcpy(__apicid_to_node, fake_apicid_to_node, sizeof(__apicid_to_node));
 }
 #endif /* CONFIG_NUMA_EMU */
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index c382ed0..288086c 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -858,7 +858,7 @@ static bool __init numa_emulation(int acpi, int amd)
 	static struct numa_meminfo ei __initdata;
 	static struct numa_meminfo pi __initdata;
 	const u64 max_addr = max_pfn << PAGE_SHIFT;
-	int i, ret;
+	int i, j, ret;
 
 	memset(&ei, 0, sizeof(ei));
 	pi = numa_meminfo;
@@ -894,6 +894,20 @@ static bool __init numa_emulation(int acpi, int amd)
 	/* commit */
 	numa_meminfo = ei;
 
+	/*
+	 * Transform __apicid_to_node table to use emulated nids by
+	 * reverse-mapping phys_nid.  The maps should always exist but fall
+	 * back to zero just in case.
+	 */
+	for (i = 0; i < ARRAY_SIZE(__apicid_to_node); i++) {
+		if (__apicid_to_node[i] == NUMA_NO_NODE)
+			continue;
+		for (j = 0; j < ARRAY_SIZE(emu_nid_to_phys); j++)
+			if (__apicid_to_node[i] == emu_nid_to_phys[j])
+				break;
+		__apicid_to_node[i] = j < ARRAY_SIZE(emu_nid_to_phys) ? j : 0;
+	}
+
 	/* make sure all emulated nodes are mapped to a physical node */
 	for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
 		if (emu_nid_to_phys[i] == NUMA_NO_NODE)
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index d2f53f3..d4fbfea 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -265,9 +265,6 @@ int __init x86_acpi_numa_init(void)
 static int fake_node_to_pxm_map[MAX_NUMNODES] __initdata = {
 	[0 ... MAX_NUMNODES-1] = PXM_INVAL
 };
-static s16 fake_apicid_to_node[MAX_LOCAL_APIC] __initdata = {
-	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
-};
 
 /*
  * In NUMA emulation, we need to setup proximity domain (_PXM) to node ID
@@ -279,7 +276,7 @@ static s16 fake_apicid_to_node[MAX_LOCAL_APIC] __initdata = {
  */
 void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 {
-	int i, j;
+	int i;
 
 	for (i = 0; i < num_nodes; i++) {
 		int nid, pxm;
@@ -291,29 +288,10 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 		if (pxm == PXM_INVAL)
 			continue;
 		fake_node_to_pxm_map[i] = pxm;
-		/*
-		 * For each apicid_to_node mapping that exists for this real
-		 * node, it must now point to the fake node ID.
-		 */
-		for (j = 0; j < MAX_LOCAL_APIC; j++)
-			if (__apicid_to_node[j] == nid &&
-			    fake_apicid_to_node[j] == NUMA_NO_NODE)
-				fake_apicid_to_node[j] = i;
 	}
 
-	/*
-	 * If there are apicid-to-node mappings for physical nodes that do not
-	 * have a corresponding emulated node, it should default to a guaranteed
-	 * value.
-	 */
-	for (i = 0; i < MAX_LOCAL_APIC; i++)
-		if (__apicid_to_node[i] != NUMA_NO_NODE &&
-		    fake_apicid_to_node[i] == NUMA_NO_NODE)
-			fake_apicid_to_node[i] = 0;
-
 	for (i = 0; i < num_nodes; i++)
 		__acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
-	memcpy(__apicid_to_node, fake_apicid_to_node, sizeof(__apicid_to_node));
 
 	for (i = 0; i < num_nodes; i++)
 		if (fake_nodes[i].start != fake_nodes[i].end)
-- 
1.7.1

