Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab3ADSRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 13:17:23 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:54975 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3ADSRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 13:17:21 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH] powerpc/mm: eliminate unneeded for_each_memblock
Date: Fri,  4 Jan 2013 13:06:00 -0500
Message-Id: <1357322760-12197-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010418-7408-0000-0000-00000B8EFE03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only persistent change made by this loop is calling
memblock_set_node() once for each memblock, which is not useful (and has
no effect) as memblock_set_node() is not called with any
memblock-specific parameters.

Subsistute a single memblock_set_node().
---
 arch/powerpc/mm/mem.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 0dba506..50370bb 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -195,13 +195,8 @@ void __init do_init_bootmem(void)
 	min_low_pfn = MEMORY_START >> PAGE_SHIFT;
 	boot_mapsize = init_bootmem_node(NODE_DATA(0), start >> PAGE_SHIFT, min_low_pfn, max_low_pfn);
 
-	/* Add active regions with valid PFNs */
-	for_each_memblock(memory, reg) {
-		unsigned long start_pfn, end_pfn;
-		start_pfn = memblock_region_memory_base_pfn(reg);
-		end_pfn = memblock_region_memory_end_pfn(reg);
-		memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
-	}
+	/* Place all memblock_regions in the same node and merge contiguous memblock_regions */
+	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
 
 	/* Add all physical memory to the bootmem map, mark each area
 	 * present.
-- 
1.8.0.3

