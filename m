Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab1GNVa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:30:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:39126 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299Ab1GNVaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:30:24 -0400
Date: Thu, 14 Jul 2011 21:30:18 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-34e1845548418e5cecee0568ba721e1f089c092c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1310460395-30913-7-git-send-email-tj@kernel.org>
References: <1310460395-30913-7-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] memblock: Make memblock_alloc_[try_]nid() top-down
Git-Commit-ID: 34e1845548418e5cecee0568ba721e1f089c092c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:30:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34e1845548418e5cecee0568ba721e1f089c092c
Gitweb:     http://git.kernel.org/tip/34e1845548418e5cecee0568ba721e1f089c092c
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 10:46:33 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 11:45:34 -0700

memblock: Make memblock_alloc_[try_]nid() top-down

NUMA aware memblock alloc functions - memblock_alloc_[try_]nid() -
weren't properly top-down because memblock_nid_range() scanned
forward.  This patch reverses memblock_nid_range(), renames it to
memblock_nid_range_rev() and updates related functions to implement
proper top-down allocation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/1310460395-30913-7-git-send-email-tj@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 mm/memblock.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 22cd999..447cf64 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -499,27 +499,26 @@ phys_addr_t __init memblock_alloc(phys_addr_t size, phys_addr_t align)
 
 
 /*
- * Additional node-local allocators. Search for node memory is bottom up
- * and walks memblock regions within that node bottom-up as well, but allocation
- * within an memblock region is top-down. XXX I plan to fix that at some stage
+ * Additional node-local top-down allocators.
  *
  * WARNING: Only available after early_node_map[] has been populated,
  * on some architectures, that is after all the calls to add_active_range()
  * have been done to populate it.
  */
 
-static phys_addr_t __init memblock_nid_range(phys_addr_t start, phys_addr_t end, int *nid)
+static phys_addr_t __init memblock_nid_range_rev(phys_addr_t start,
+						 phys_addr_t end, int *nid)
 {
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
 	unsigned long start_pfn, end_pfn;
 	int i;
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, nid)
-		if (start >= PFN_PHYS(start_pfn) && start < PFN_PHYS(end_pfn))
-			return min(end, PFN_PHYS(end_pfn));
+		if (end > PFN_PHYS(start_pfn) && end <= PFN_PHYS(end_pfn))
+			return max(start, PFN_PHYS(start_pfn));
 #endif
 	*nid = 0;
-	return end;
+	return start;
 }
 
 static phys_addr_t __init memblock_alloc_nid_region(struct memblock_region *mp,
@@ -531,21 +530,19 @@ static phys_addr_t __init memblock_alloc_nid_region(struct memblock_region *mp,
 	start = mp->base;
 	end = start + mp->size;
 
-	start = round_up(start, align);
 	while (start < end) {
-		phys_addr_t this_end;
+		phys_addr_t this_start;
 		int this_nid;
 
-		this_end = memblock_nid_range(start, end, &this_nid);
+		this_start = memblock_nid_range_rev(start, end, &this_nid);
 		if (this_nid == nid) {
-			phys_addr_t ret = memblock_find_region(start, this_end, size, align);
+			phys_addr_t ret = memblock_find_region(this_start, end, size, align);
 			if (ret &&
 			    !memblock_add_region(&memblock.reserved, ret, size))
 				return ret;
 		}
-		start = this_end;
+		end = this_start;
 	}
-
 	return 0;
 }
 
@@ -561,11 +558,7 @@ phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int n
 	 */
 	size = round_up(size, align);
 
-	/* We do a bottom-up search for a region with the right
-	 * nid since that's easier considering how memblock_nid_range()
-	 * works
-	 */
-	for (i = 0; i < mem->cnt; i++) {
+	for (i = mem->cnt - 1; i >= 0; i--) {
 		phys_addr_t ret = memblock_alloc_nid_region(&mem->regions[i],
 					       size, align, nid);
 		if (ret)
