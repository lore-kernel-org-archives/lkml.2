Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab0EQXKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:10:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59032 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620Ab0EQXKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:10:16 -0400
Date: Tue, 18 May 2010 01:09:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm change for v2.6.35
Message-ID: <20100517230943.GA7541@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mm-for-linus

 Thanks,

	Ingo

------------------>
Jan Beulich (1):
      x86-64: Combine SRAT regions when possible


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
