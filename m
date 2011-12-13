Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab1LMN6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 08:58:50 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:58147 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab1LMN6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 08:58:43 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 3/4] mm: bootmem: drop superfluous range check when freeing pages in bulk
Date: Tue, 13 Dec 2011 14:58:30 +0100
Message-Id: <1323784711-1937-4-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323784711-1937-1-git-send-email-hannes@cmpxchg.org>
References: <1323784711-1937-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The area node_bootmem_map represents is aligned to BITS_PER_LONG, and
all bits in any aligned word of that map valid.  When the represented
area extends beyond the end of the node, the non-existant pages will
be marked as reserved.

As a result, when freeing a page block, doing an explicit range check
for whether that block is within the node's range is redundant as the
bitmap is consulted anyway to see whether all pages in the block are
unreserved.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/bootmem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 3e6f152..1aea171 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -197,7 +197,7 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 		idx = start - bdata->node_min_pfn;
 		vec = ~map[idx / BITS_PER_LONG];
 
-		if (aligned && vec == ~0UL && start + BITS_PER_LONG <= end) {
+		if (aligned && vec == ~0UL) {
 			int order = ilog2(BITS_PER_LONG);
 
 			__free_pages_bootmem(pfn_to_page(start), order);
-- 
1.7.7.3

