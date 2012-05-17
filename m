Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762066Ab2EQOuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 10:50:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762025Ab2EQOul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 10:50:41 -0400
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 07/17] mm: Ignore mempolicies when using ALLOC_NO_WATERMARK
Date: Thu, 17 May 2012 15:50:21 +0100
Message-Id: <1337266231-8031-8-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1337266231-8031-1-git-send-email-mgorman@suse.de>
References: <1337266231-8031-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reserve is proportionally distributed over all !highmem zones
in the system. So we need to allow an emergency allocation access to
all zones.  In order to do that we need to break out of any mempolicy
boundaries we might have.

In my opinion that does not break mempolicies as those are user
oriented and not system oriented. That is, system allocations are
not guaranteed to be within mempolicy boundaries. For instance IRQs
do not even have a mempolicy.

So breaking out of mempolicy boundaries for 'rare' emergency
allocations, which are always system allocations (as opposed to user)
is ok.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/page_alloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7ecc002..06a5d5c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2293,6 +2293,13 @@ rebalance:
 
 	/* Allocate without watermarks if the context allows */
 	if (alloc_flags & ALLOC_NO_WATERMARKS) {
+		/*
+		 * Ignore mempolicies if ALLOC_NO_WATERMARKS on the grounds
+		 * the allocation is high priority and these type of
+		 * allocations are system rather than user orientated
+		 */
+		zonelist = node_zonelist(numa_node_id(), gfp_mask);
+
 		page = __alloc_pages_high_priority(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
 				preferred_zone, migratetype);
-- 
1.7.9.2

