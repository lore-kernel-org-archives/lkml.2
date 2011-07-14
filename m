Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab1GNV3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 17:29:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:39079 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab1GNV3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 17:29:33 -0400
Date: Thu, 14 Jul 2011 21:29:17 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-b2fea988f4f3b38ff4edfc1556a843c91932804c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        benh@kernel.crashing.org, yinghai@kernel.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, benh@kernel.crashing.org, tj@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1310460395-30913-5-git-send-email-tj@kernel.org>
References: <1310460395-30913-5-git-send-email-tj@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/memblock] memblock: Improve generic memblock_nid_range() using for_each_mem_pfn_range()
Git-Commit-ID: b2fea988f4f3b38ff4edfc1556a843c91932804c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Jul 2011 21:29:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2fea988f4f3b38ff4edfc1556a843c91932804c
Gitweb:     http://git.kernel.org/tip/b2fea988f4f3b38ff4edfc1556a843c91932804c
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 12 Jul 2011 10:46:31 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 14 Jul 2011 11:45:32 -0700

memblock: Improve generic memblock_nid_range() using for_each_mem_pfn_range()

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
Link: http://lkml.kernel.org/r/1310460395-30913-5-git-send-email-tj@kernel.org
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
 
