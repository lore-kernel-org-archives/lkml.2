Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab1GLIsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 04:48:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42054 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1GLIqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 04:46:47 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, yinghai@kernel.org, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/8] memblock: Improve generic memblock_nid_range() using for_each_mem_pfn_range()
Date: Tue, 12 Jul 2011 10:46:31 +0200
Message-Id: <1310460395-30913-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1310460395-30913-1-git-send-email-tj@kernel.org>
References: <1310460395-30913-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given an address range, memblock_nid_range() determines the node the
start of the range belongs to and upto where the range stays in the
same node.

It's implemented by calling get_pfn_range_for_nid(), which determines
min and max pfns for a given node, for each node and testing whether
start address falls in there.  This is not only inefficient but also
incorrect when nodes interleave as min-max ranges for nodes overlap.

This patch reimplements memblock_nid_range() using
for_each_mem_pfn_range().  It's simpler, walks the mem ranges once and
can find the exact range the start address falls in.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 mm/memblock.c |   20 +++-----------------
 1 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 0f9626f..97f3486 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -511,28 +511,14 @@ phys_addr_t __init memblock_alloc(phys_addr_t size, phys_addr_t align)
 phys_addr_t __weak __init memblock_nid_range(phys_addr_t start, phys_addr_t end, int *nid)
 {
 #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
-	/*
-	 * This code originates from sparc which really wants use to walk by addresses
-	 * and returns the nid. This is not very convenient for early_pfn_map[] users
-	 * as the map isn't sorted yet, and it really wants to be walked by nid.
-	 *
-	 * For now, I implement the inefficient method below which walks the early
-	 * map multiple times. Eventually we may want to use an ARCH config option
-	 * to implement a completely different method for both case.
-	 */
 	unsigned long start_pfn, end_pfn;
 	int i;
 
-	for (i = 0; i < MAX_NUMNODES; i++) {
-		get_pfn_range_for_nid(i, &start_pfn, &end_pfn);
-		if (start < PFN_PHYS(start_pfn) || start >= PFN_PHYS(end_pfn))
-			continue;
-		*nid = i;
-		return min(end, PFN_PHYS(end_pfn));
-	}
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, nid)
+		if (start >= PFN_PHYS(start_pfn) && start < PFN_PHYS(end_pfn))
+			return min(end, PFN_PHYS(end_pfn));
 #endif
 	*nid = 0;
-
 	return end;
 }
 
-- 
1.7.6

