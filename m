Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab2LMObK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:31:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44828 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935Ab2LMOLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:25 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 172/241] sparc64: Be less verbose during vmemmap population.
Date: Thu, 13 Dec 2012 11:58:57 -0200
Message-Id: <1355407206-17100-173-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit 2856cc2e4d0852c3ddaae9dcb19cb9396512eb08 upstream.

On a 2-node machine with 256GB of ram we get 512 lines of
console output, which is just too much.

This mimicks Yinghai Lu's x86 commit c2b91e2eec9678dbda274e906cc32ea8f711da3b
(x86_64/mm: check and print vmemmap allocation continuous) except that
we aren't ever going to get contiguous block pointers in between calls
so just print when the virtual address or node changes.

This decreases the output by an order of 16.

Also demote this to KERN_DEBUG.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/sparc/mm/init_64.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 6026fdd..d58edf5 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2020,6 +2020,9 @@ EXPORT_SYMBOL(_PAGE_CACHE);
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 unsigned long vmemmap_table[VMEMMAP_SIZE];
 
+static long __meminitdata addr_start, addr_end;
+static int __meminitdata node_start;
+
 int __meminit vmemmap_populate(struct page *start, unsigned long nr, int node)
 {
 	unsigned long vstart = (unsigned long) start;
@@ -2050,15 +2053,30 @@ int __meminit vmemmap_populate(struct page *start, unsigned long nr, int node)
 
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
-- 
1.7.9.5

