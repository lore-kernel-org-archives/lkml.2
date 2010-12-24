Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0LXBjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 20:39:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:37546 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab0LXBjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 20:39:04 -0500
Date: Fri, 24 Dec 2010 01:37:33 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com, hpa@linux.intel.com
In-Reply-To: <alpine.DEB.2.00.1012221701360.3701@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1012221701360.3701@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86, numa: Fake apicid and pxm mappings for NUMA emulation
Message-ID: <tip-f51bf3073a145a5b3263fd882c52d6ec04b687da@git.kernel.org>
Git-Commit-ID: f51bf3073a145a5b3263fd882c52d6ec04b687da
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 24 Dec 2010 01:37:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f51bf3073a145a5b3263fd882c52d6ec04b687da
Gitweb:     http://git.kernel.org/tip/f51bf3073a145a5b3263fd882c52d6ec04b687da
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Wed, 22 Dec 2010 17:23:51 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 23 Dec 2010 15:27:14 -0800

x86, numa: Fake apicid and pxm mappings for NUMA emulation

This patch adds the equivalent of acpi_fake_nodes() for AMD Northbridge
platforms.  The goal is to fake the apicid-to-node mappings for NUMA
emulation so the physical topology of the machine is correctly maintained
within the kernel.

This change also fakes proximity domains for both ACPI and k8 code so the
physical distance between emulated nodes is maintained via
node_distance().  This exports the correct distances via
/sys/devices/system/node/.../distance based on the underlying topology.

A new helper function, fake_physnodes(), is introduced to correctly
invoke the correct NUMA code to fake these two mappings based on the
system type.  If there is no underlying NUMA configuration, all cpus are
mapped to node 0 for local distance.

Since acpi_fake_nodes() is no longer called with CONFIG_ACPI_NUMA, it's
prototype can be removed from the header file for such a configuration.

Signed-off-by: David Rientjes <rientjes@google.com>
LKML-Reference: <alpine.DEB.2.00.1012221701360.3701@chino.kir.corp.google.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/acpi.h   |    5 --
 arch/x86/include/asm/amd_nb.h |    1 +
 arch/x86/mm/amdtopology_64.c  |   91 +++++++++++++++++++++++++++++++++-------
 arch/x86/mm/numa_64.c         |   20 +++++++++-
 arch/x86/mm/srat_64.c         |    2 -
 5 files changed, 95 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index b326fa9..8288daf 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -193,11 +193,6 @@ extern int acpi_scan_nodes(unsigned long start, unsigned long end);
 extern void acpi_fake_nodes(const struct bootnode *fake_nodes,
 				   int num_nodes);
 #endif
-#else
-static inline void acpi_fake_nodes(const struct bootnode *fake_nodes,
-				   int num_nodes)
-{
-}
 #endif /* CONFIG_ACPI_NUMA */
 
 #define acpi_unlazy_tlb(x)	leave_mm(x)
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 9c16cde..8f6192c 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -13,6 +13,7 @@ extern int amd_numa_init(unsigned long start_pfn, unsigned long end_pfn);
 extern int amd_scan_nodes(void);
 
 #ifdef CONFIG_NUMA_EMU
+extern void amd_fake_nodes(const struct bootnode *nodes, int nr_nodes);
 extern int amd_get_nodes(struct bootnode *nodes);
 #endif
 
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
index fe050af..eb5cbb9 100644
--- a/arch/x86/mm/amdtopology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -27,6 +27,7 @@
 #include <asm/amd_nb.h>
 
 static struct bootnode __initdata nodes[8];
+static unsigned char __initdata nodeids[8];
 static nodemask_t __initdata nodes_parsed = NODE_MASK_NONE;
 
 static __init int find_northbridge(void)
@@ -69,21 +70,6 @@ static __init void early_get_boot_cpu_id(void)
 	early_init_lapic_mapping();
 }
 
-#ifdef CONFIG_NUMA_EMU
-int __init amd_get_nodes(struct bootnode *physnodes)
-{
-	int i;
-	int ret = 0;
-
-	for_each_node_mask(i, nodes_parsed) {
-		physnodes[ret].start = nodes[i].start;
-		physnodes[ret].end = nodes[i].end;
-		ret++;
-	}
-	return ret;
-}
-#endif /* CONFIG_NUMA_EMU */
-
 int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long start = PFN_PHYS(start_pfn);
@@ -116,7 +102,7 @@ int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
 		base = read_pci_config(0, nb, 1, 0x40 + i*8);
 		limit = read_pci_config(0, nb, 1, 0x44 + i*8);
 
-		nodeid = limit & 7;
+		nodeids[i] = nodeid = limit & 7;
 		if ((base & 3) == 0) {
 			if (i < numnodes)
 				pr_info("Skipping disabled node %d\n", i);
@@ -196,6 +182,79 @@ int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
 	return 0;
 }
 
+#ifdef CONFIG_NUMA_EMU
+static s16 fake_apicid_to_node[MAX_LOCAL_APIC] __initdata = {
+	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
+};
+
+int __init amd_get_nodes(struct bootnode *physnodes)
+{
+	int i;
+	int ret = 0;
+
+	for_each_node_mask(i, nodes_parsed) {
+		physnodes[ret].start = nodes[i].start;
+		physnodes[ret].end = nodes[i].end;
+		ret++;
+	}
+	return ret;
+}
+
+static int __init find_node_by_addr(unsigned long addr)
+{
+	int ret = NUMA_NO_NODE;
+	int i;
+
+	for (i = 0; i < 8; i++)
+		if (addr >= nodes[i].start && addr < nodes[i].end) {
+			ret = i;
+			break;
+		}
+	return ret;
+}
+
+/*
+ * For NUMA emulation, fake proximity domain (_PXM) to node id mappings must be
+ * setup to represent the physical topology but reflect the emulated
+ * environment.  For each emulated node, the real node which it appears on is
+ * found and a fake pxm to nid mapping is created which mirrors the actual
+ * locality.  node_distance() then represents the correct distances between
+ * emulated nodes by using the fake acpi mappings to pxms.
+ */
+void __init amd_fake_nodes(const struct bootnode *nodes, int nr_nodes)
+{
+	unsigned int bits;
+	unsigned int cores;
+	unsigned int apicid_base = 0;
+	int i;
+
+	bits = boot_cpu_data.x86_coreid_bits;
+	cores = 1 << bits;
+	early_get_boot_cpu_id();
+	if (boot_cpu_physical_apicid > 0)
+		apicid_base = boot_cpu_physical_apicid;
+
+	for (i = 0; i < nr_nodes; i++) {
+		int index;
+		int nid;
+		int j;
+
+		nid = find_node_by_addr(nodes[i].start);
+		if (nid == NUMA_NO_NODE)
+			continue;
+
+		index = nodeids[nid] << bits;
+		if (fake_apicid_to_node[index + apicid_base] == NUMA_NO_NODE)
+			for (j = apicid_base; j < cores + apicid_base; j++)
+				fake_apicid_to_node[index + j] = i;
+#ifdef CONFIG_ACPI_NUMA
+		__acpi_map_pxm_to_node(nid, i);
+#endif
+	}
+	memcpy(apicid_to_node, fake_apicid_to_node, sizeof(apicid_to_node));
+}
+#endif /* CONFIG_NUMA_EMU */
+
 int __init amd_scan_nodes(void)
 {
 	unsigned int bits;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 7762a51..cc390f3 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -324,6 +324,24 @@ static int __init setup_physnodes(unsigned long start, unsigned long end,
 	return ret;
 }
 
+static void __init fake_physnodes(int acpi, int amd, int nr_nodes)
+{
+	int i;
+
+	BUG_ON(acpi && amd);
+#ifdef CONFIG_ACPI_NUMA
+	if (acpi)
+		acpi_fake_nodes(nodes, nr_nodes);
+#endif
+#ifdef CONFIG_AMD_NUMA
+	if (amd)
+		amd_fake_nodes(nodes, nr_nodes);
+#endif
+	if (!acpi && !amd)
+		for (i = 0; i < nr_cpu_ids; i++)
+			numa_set_node(i, 0);
+}
+
 /*
  * Setups up nid to range from addr to addr + size.  If the end
  * boundary is greater than max_addr, then max_addr is used instead.
@@ -595,7 +613,7 @@ static int __init numa_emulation(unsigned long start_pfn,
 						nodes[i].end >> PAGE_SHIFT);
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	}
-	acpi_fake_nodes(nodes, num_nodes);
+	fake_physnodes(acpi, amd, num_nodes);
 	numa_init_array();
 	return 0;
 }
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 8241bf0..c48b443 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -497,8 +497,6 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 {
 	int i, j;
 
-	printk(KERN_INFO "Faking PXM affinity for fake nodes on real "
-			 "topology.\n");
 	for (i = 0; i < num_nodes; i++) {
 		int nid, pxm;
 
