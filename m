Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab2JZApo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:45:44 -0400
Received: from mail.kernel.org ([198.145.19.201]:52619 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab2JZAGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:06:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 27/31] sparc64: Be less verbose during vmemmap population.
Date: Thu, 25 Oct 2012 17:04:34 -0700
Message-Id: <20121026000217.706892492@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000214.941721299@linuxfoundation.org>
References: <20121026000214.941721299@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/mm/init_64.c |   28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

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
@@ -2148,15 +2151,30 @@ int __meminit vmemmap_populate(struct pa
 
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


