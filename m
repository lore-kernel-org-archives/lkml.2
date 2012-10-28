Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab2J1Xvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:51:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41755 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756234Ab2J1X07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:26:59 -0400
Message-Id: <20121028231541.648888107@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:51 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 015/105] sparc64: Be less verbose during vmemmap population.
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 2856cc2e4d0852c3ddaae9dcb19cb9396512eb08 ]

On a 2-node machine with 256GB of ram we get 512 lines of
console output, which is just too much.

This mimicks Yinghai Lu's x86 commit c2b91e2eec9678dbda274e906cc32ea8f711da3b
(x86_64/mm: check and print vmemmap allocation continuous) except that
we aren't ever going to get contiguous block pointers in between calls
so just print when the virtual address or node changes.

This decreases the output by an order of 16.

Also demote this to KERN_DEBUG.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/sparc/mm/init_64.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 8e073d8..6ff4d78 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2118,6 +2118,9 @@ EXPORT_SYMBOL(_PAGE_CACHE);
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 unsigned long vmemmap_table[VMEMMAP_SIZE];
 
+static long __meminitdata addr_start, addr_end;
+static int __meminitdata node_start;
+
 int __meminit vmemmap_populate(struct page *start, unsigned long nr, int node)
 {
 	unsigned long vstart = (unsigned long) start;
@@ -2148,15 +2151,30 @@ int __meminit vmemmap_populate(struct page *start, unsigned long nr, int node)
 
 			*vmem_pp = pte_base | __pa(block);
 
-			printk(KERN_INFO "[%p-%p] page_structs=%lu "
-			       "node=%d entry=%lu/%lu\n", start, block, nr,
-			       node,
-			       addr >> VMEMMAP_CHUNK_SHIFT,
-			       VMEMMAP_SIZE);
+			/* check to see if we have contiguous blocks */
+			if (addr_end != addr || node_start != node) {
+				if (addr_start)
+					printk(KERN_DEBUG " [%lx-%lx] on node %d\n",
+					       addr_start, addr_end-1, node_start);
+				addr_start = addr;
+				node_start = node;
+			}
+			addr_end = addr + VMEMMAP_CHUNK;
 		}
 	}
 	return 0;
 }
+
+void __meminit vmemmap_populate_print_last(void)
+{
+	if (addr_start) {
+		printk(KERN_DEBUG " [%lx-%lx] on node %d\n",
+		       addr_start, addr_end-1, node_start);
+		addr_start = 0;
+		addr_end = 0;
+		node_start = 0;
+	}
+}
 #endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 static void prot_init_common(unsigned long page_none,


