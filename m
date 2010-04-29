Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab0D2BhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 21:37:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:50938 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755534Ab0D2BhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 21:37:03 -0400
Date: Thu, 29 Apr 2010 01:36:39 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de
In-Reply-To: <4BCF3230020000780003B3CA@vpn.id2.novell.com>
References: <4BCF3230020000780003B3CA@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86-64: Combine SRAT regions when possible
Message-ID: <tip-2e61878698781d6a9a8bfbaa4ea9c5ddb5a178c3@git.kernel.org>
Git-Commit-ID: 2e61878698781d6a9a8bfbaa4ea9c5ddb5a178c3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 29 Apr 2010 01:36:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2e61878698781d6a9a8bfbaa4ea9c5ddb5a178c3
Gitweb:     http://git.kernel.org/tip/2e61878698781d6a9a8bfbaa4ea9c5ddb5a178c3
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Wed, 21 Apr 2010 16:13:20 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 28 Apr 2010 17:14:11 -0700

x86-64: Combine SRAT regions when possible

... i.e. when the hole between two regions isn't occupied by memory on
another node. This reduces the memory->node table size, thus reducing
cache footprint of lookups, which got increased significantly some
time ago, and things go back to how they were before that change on
the systems I looked at.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4BCF3230020000780003B3CA@vpn.id2.novell.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/srat_64.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index 28c6876..3ebe651 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -363,6 +363,54 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
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
