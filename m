Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab0KLVyW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:54:22 -0500
Received: from smtp-out.google.com ([74.125.121.35]:27706 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129Ab0KLVyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:54:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=OhY2aR9n7QbkS6gCKSnzqzhIWGMmSor5qWcw6aYXqANicK4B0XWQCEbGPKQ+Lzr6hJ
         KZk48jt9CCiEKAeoGd4Q==
Date: Fri, 12 Nov 2010 13:54:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 5/5] x86: fix cpu to node mapping for sparse node ids
In-Reply-To: <alpine.DEB.2.00.1011121352050.13699@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1011121353360.13699@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1011121352050.13699@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/include/asm/acpi.h   |    3 ++-
 arch/x86/include/asm/amd_nb.h |    2 +-
 arch/x86/mm/k8topology_64.c   |    9 +++------
 arch/x86/mm/numa_64.c         |   18 +++---------------
 arch/x86/mm/srat_64.c         |   22 ++++++++++++++++------
 5 files changed, 25 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
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
