Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab0LVA7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:59:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:49220 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475Ab0LVA7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:59:31 -0500
Date: Wed, 22 Dec 2010 00:59:11 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com, hpa@linux.intel.com
In-Reply-To: <alpine.DEB.2.00.1012011735460.1040@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1012011735460.1040@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86, numa: Fix cpu to node mapping for sparse node ids
Message-ID: <tip-9be550b0d6c7471d81a1016c93d651f2981dc200@git.kernel.org>
Git-Commit-ID: 9be550b0d6c7471d81a1016c93d651f2981dc200
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 00:59:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9be550b0d6c7471d81a1016c93d651f2981dc200
Gitweb:     http://git.kernel.org/tip/9be550b0d6c7471d81a1016c93d651f2981dc200
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Wed, 1 Dec 2010 17:36:34 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 21 Dec 2010 16:09:13 -0800

x86, numa: Fix cpu to node mapping for sparse node ids

NUMA boot code assumes that physical node ids start at 0, but the DIMMs
that the apic id represents may not be reachable.  If this is the case,
node 0 is never online and cpus never end up getting appropriately
assigned to a node.  This causes the cpumask of all online nodes to be
empty and machines crash with kernel code assuming online nodes have
valid cpus.

The fix is to appropriately map all the address ranges for physical nodes
and ensure the cpu to node mapping function checks all possible nodes (up
to MAX_NUMNODES) instead of simply checking nodes 0-N, where N is the
number of physical nodes, for valid address ranges.

This requires no longer "compressing" the address ranges of nodes in the
physical node map from 0-N, but rather leave indices in physnodes[] to
represent the actual node id of the physical node.  Accordingly, the
topology exported by both k8_get_nodes() and acpi_get_nodes() no longer
must return the number of nodes to iterate through; all such iterations
will now be to MAX_NUMNODES.

This change also passes the end address of system RAM (which may be
different from normal operation if mem= is specified on the command line)
before the physnodes[] array is populated.  ACPI parsed nodes are
truncated to fit within the address range that respect the mem=
boundaries and even some physical nodes may become unreachable in such
cases.

When NUMA emulation does succeed, any apicid to node mapping that exists
for unreachable nodes are given default values so that proximity domains
can still be assigned.  This is important for node_distance() to
function as desired.

Signed-off-by: David Rientjes <rientjes@google.com>
LKML-Reference: <alpine.DEB.2.00.1012011735460.1040@chino.kir.corp.google.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/acpi.h   |    3 ++-
 arch/x86/include/asm/amd_nb.h |    2 +-
 arch/x86/mm/k8topology_64.c   |    9 +++------
 arch/x86/mm/numa_64.c         |   18 +++---------------
 arch/x86/mm/srat_64.c         |   22 ++++++++++++++++------
 5 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 8288daf..211ca3f 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -185,7 +185,8 @@ struct bootnode;
 
 #ifdef CONFIG_ACPI_NUMA
 extern int acpi_numa;
-extern int acpi_get_nodes(struct bootnode *physnodes);
+extern void acpi_get_nodes(struct bootnode *physnodes, unsigned long start,
+				unsigned long end);
 extern int acpi_scan_nodes(unsigned long start, unsigned long end);
 #define NR_NODE_MEMBLKS (MAX_NUMNODES*2)
 
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index eb09dc5..808d15e 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -14,7 +14,7 @@ extern int k8_scan_nodes(void);
 
 #ifdef CONFIG_NUMA_EMU
 extern void k8_fake_nodes(const struct bootnode *nodes, int nr_nodes);
-extern int k8_get_nodes(struct bootnode *nodes);
+extern void k8_get_nodes(struct bootnode *nodes);
 #endif
 
 struct k8_northbridge_info {
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index b07f9846..ce02ea8 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -187,17 +187,14 @@ static s16 fake_apicid_to_node[MAX_LOCAL_APIC] __initdata = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 
-int __init k8_get_nodes(struct bootnode *physnodes)
+void __init k8_get_nodes(struct bootnode *physnodes)
 {
 	int i;
-	int ret = 0;
 
 	for_each_node_mask(i, nodes_parsed) {
-		physnodes[ret].start = nodes[i].start;
-		physnodes[ret].end = nodes[i].end;
-		ret++;
+		physnodes[i].start = nodes[i].start;
+		physnodes[i].end = nodes[i].end;
 	}
-	return ret;
 }
 
 static int __init find_node_by_addr(unsigned long addr)
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index d312db6..d14e61e 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -266,25 +266,24 @@ static char *cmdline __initdata;
 static int __init setup_physnodes(unsigned long start, unsigned long end,
 					int acpi, int k8)
 {
-	int nr_nodes = 0;
 	int ret = 0;
 	int i;
 
 	memset(physnodes, 0, sizeof(physnodes));
 #ifdef CONFIG_ACPI_NUMA
 	if (acpi)
-		nr_nodes = acpi_get_nodes(physnodes);
+		acpi_get_nodes(physnodes, start, end);
 #endif
 #ifdef CONFIG_K8_NUMA
 	if (k8)
-		nr_nodes = k8_get_nodes(physnodes);
+		k8_get_nodes(physnodes);
 #endif
 	/*
 	 * Basic sanity checking on the physical node map: there may be errors
 	 * if the SRAT or K8 incorrectly reported the topology or the mem=
 	 * kernel parameter is used.
 	 */
-	for (i = 0; i < nr_nodes; i++) {
+	for (i = 0; i < MAX_NUMNODES; i++) {
 		if (physnodes[i].start == physnodes[i].end)
 			continue;
 		if (physnodes[i].start > end) {
@@ -299,17 +298,6 @@ static int __init setup_physnodes(unsigned long start, unsigned long end,
 			physnodes[i].start = start;
 		if (physnodes[i].end > end)
 			physnodes[i].end = end;
-	}
-
-	/*
-	 * Remove all nodes that have no memory or were truncated because of the
-	 * limited address range.
-	 */
-	for (i = 0; i < nr_nodes; i++) {
-		if (physnodes[i].start == physnodes[i].end)
-			continue;
-		physnodes[ret].start = physnodes[i].start;
-		physnodes[ret].end = physnodes[i].end;
 		ret++;
 	}
 
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index c48b443..a756bcf 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -340,17 +340,16 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 void __init acpi_numa_arch_fixup(void) {}
 
 #ifdef CONFIG_NUMA_EMU
-int __init acpi_get_nodes(struct bootnode *physnodes)
+void __init acpi_get_nodes(struct bootnode *physnodes, unsigned long start,
+				unsigned long end)
 {
 	int i;
-	int ret = 0;
 
 	for_each_node_mask(i, nodes_parsed) {
-		physnodes[ret].start = nodes[i].start;
-		physnodes[ret].end = nodes[i].end;
-		ret++;
+		cutoff_node(i, start, end);
+		physnodes[i].start = nodes[i].start;
+		physnodes[i].end = nodes[i].end;
 	}
-	return ret;
 }
 #endif /* CONFIG_NUMA_EMU */
 
@@ -516,6 +515,17 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
 			    fake_apicid_to_node[j] == NUMA_NO_NODE)
 				fake_apicid_to_node[j] = i;
 	}
+
+	/*
+	 * If there are apicid-to-node mappings for physical nodes that do not
+	 * have a corresponding emulated node, it should default to a guaranteed
+	 * value.
+	 */
+	for (i = 0; i < MAX_LOCAL_APIC; i++)
+		if (apicid_to_node[i] != NUMA_NO_NODE &&
+		    fake_apicid_to_node[i] == NUMA_NO_NODE)
+			fake_apicid_to_node[i] = 0;
+
 	for (i = 0; i < num_nodes; i++)
 		__acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
 	memcpy(apicid_to_node, fake_apicid_to_node, sizeof(apicid_to_node));
