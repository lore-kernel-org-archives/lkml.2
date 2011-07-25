Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1GYUit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:38:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab1GYUir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:38:47 -0400
From: Johannes Weiner <jweiner@redhat.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch] mm: thp: disable defrag for page faults per default
Date: Mon, 25 Jul 2011 22:38:41 +0200
Message-Id: <1311626321-14364-1-git-send-email-jweiner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With defrag mode enabled per default, huge page allocations pass
__GFP_WAIT and may drop compaction into sync-mode where they wait for
pages under writeback.

I observe applications hang for several minutes(!) when they fault in
huge pages and compaction starts to wait on in-"flight" USB stick IO.

This patch disables defrag mode for page fault allocations unless the
VMA is madvised explicitely.  Khugepaged will continue to allocate
with __GFP_WAIT per default, but stalls are not a problem of
application responsiveness there.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 mm/huge_memory.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 81532f2..8c8ff29 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -35,7 +35,7 @@ unsigned long transparent_hugepage_flags __read_mostly =
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE_MADVISE
 	(1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)|
 #endif
-	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_FLAG)|
+	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG)|
 	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG);
 
 /* default scan 8*512 pte (or vmas) every 30 second */
-- 
1.7.6

