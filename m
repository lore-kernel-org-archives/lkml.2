Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab3AIWkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:40:40 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54096 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758132Ab3AIWkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 17:40:39 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Linux PPC <linuxppc-dev@lists.ozlabs.org>, galak@kernel.crashing.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2] powerpc/mm: eliminate unneeded for_each_memblock
Date: Wed,  9 Jan 2013 14:40:18 -0800
Message-Id: <1357771218-6499-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <82A31E2D-FA24-44CF-9812-9E8062AFA6F4@kernel.crashing.org>
References: <82A31E2D-FA24-44CF-9812-9E8062AFA6F4@kernel.crashing.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010922-5806-0000-0000-00001E0794C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only persistent change made by this loop is calling
memblock_set_node() once for each memblock, which is not useful (and has
no effect) as memblock_set_node() is not called with any
memblock-specific parameters.

Subsistute a single memblock_set_node().

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---

Now with a signoff & wrapped comment line.

 arch/powerpc/mm/mem.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 0dba506..40df7c8 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -195,13 +195,10 @@ void __init do_init_bootmem(void)
 	min_low_pfn = MEMORY_START >> PAGE_SHIFT;
 	boot_mapsize = init_bootmem_node(NODE_DATA(0), start >> PAGE_SHIFT, min_low_pfn, max_low_pfn);
 
-	/* Add active regions with valid PFNs */
-	for_each_memblock(memory, reg) {
-		unsigned long start_pfn, end_pfn;
-		start_pfn = memblock_region_memory_base_pfn(reg);
-		end_pfn = memblock_region_memory_end_pfn(reg);
-		memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
-	}
+	/* Place all memblock_regions in the same node and merge contiguous
+	 * memblock_regions
+	 */
+	memblock_set_node(0, (phys_addr_t)ULLONG_MAX, 0);
 
 	/* Add all physical memory to the bootmem map, mark each area
 	 * present.
-- 
1.8.0.3

