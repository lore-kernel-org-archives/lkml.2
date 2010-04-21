Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab0DUPNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:13:22 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:34954 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab0DUPNV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 21 Apr 2010 11:13:21 -0400
Message-Id: <4BCF3230020000780003B3CA@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 21 Apr 2010 16:13:20 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: combine SRAT regions when possible
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... i.e. when the hole between two regions isn't occupied by memory on
another node. This reduces the memory->node table size, thus reducing
cache footprint of lookups, which got increased significantly some
time ago, and things go back to how they were before that change on
the systems I looked at.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/mm/srat_64.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

--- linux-2.6.34-rc5/arch/x86/mm/srat_64.c	2010-02-24 19:52:17.000000000 +0100
+++ 2.6.34-rc5-x86_64-srat-memblk-join/arch/x86/mm/srat_64.c	2010-01-28 10:43:33.000000000 +0100
@@ -363,6 +363,54 @@ int __init acpi_scan_nodes(unsigned long
 	for (i = 0; i < MAX_NUMNODES; i++)
 		cutoff_node(i, start, end);
 
+	/*
+	 * Join together blocks on the same node, holes between
+	 * which don't overlap with memory on other nodes.
+	 */
+	for (i = 0; i < num_node_memblks; ++i) {
+		int j, k;
+
+		for (j = i + 1; j < num_node_memblks; ++j) {
+			unsigned long start, end;
+
+			if (memblk_nodeid[i] != memblk_nodeid[j])
+				continue;
+			start = min(node_memblk_range[i].end,
+			            node_memblk_range[j].end);
+			end = max(node_memblk_range[i].start,
+			          node_memblk_range[j].start);
+			for (k = 0; k < num_node_memblks; ++k) {
+				if (memblk_nodeid[i] == memblk_nodeid[k])
+					continue;
+				if (start < node_memblk_range[k].end &&
+				    end > node_memblk_range[k].start)
+					break;
+			}
+			if (k < num_node_memblks)
+				continue;
+			start = min(node_memblk_range[i].start,
+			            node_memblk_range[j].start);
+			end = max(node_memblk_range[i].end,
+			          node_memblk_range[j].end);
+			printk(KERN_INFO "SRAT: Node %d "
+			       "[%Lx,%Lx) + [%Lx,%Lx) -> [%lx,%lx)\n",
+			       memblk_nodeid[i],
+			       node_memblk_range[i].start,
+			       node_memblk_range[i].end,
+			       node_memblk_range[j].start,
+			       node_memblk_range[j].end,
+			       start, end);
+			node_memblk_range[i].start = start;
+			node_memblk_range[i].end = end;
+			k = --num_node_memblks - j;
+			memmove(memblk_nodeid + j, memblk_nodeid + j+1,
+				k * sizeof(*memblk_nodeid));
+			memmove(node_memblk_range + j, node_memblk_range + j+1,
+				k * sizeof(*node_memblk_range));
+			--j;
+		}
+	}
+
 	memnode_shift = compute_hash_shift(node_memblk_range, num_node_memblks,
 					   memblk_nodeid);
 	if (memnode_shift < 0) {



