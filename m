Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab1FEFIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 01:08:49 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:54444 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab1FEFIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 01:08:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=XR4tRwauFkSzKz6TDZ08O4tWP0R/mIG5msQgsOeHAlOQm5sBaZKeTG+FhI2AkmX3lV
         ZCnUwg9gFbOINXTRWwsPZjfLsrdjfUUTC6UkqL7B7x5v/PXDlYQPU2oK+yEoXRt3vjT9
         Md1xK+wxvpgTvxR3ZAct2yWlP0GLrwLRinuqg=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH] Fix page isolated count mismatch
Date: Sun,  5 Jun 2011 14:08:36 +0900
Message-Id: <1307250516-10756-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If migration is failed, normally we call putback_lru_pages which
decreases NR_ISOLATE_[ANON|FILE].
It means we should increase NR_ISOLATE_[ANON|FILE] before calling
putback_lru_pages. But soft_offline_page dosn't it.

It can make NR_ISOLATE_[ANON|FILE] with negative value and in UP build
, zone_page_state will say huge isolated pages so too_many_isolated
functions be deceived completely. At last, some process stuck in D state
as it expect while loop ending with congestion_wait.
But it's never ending story.

If it is right, it would be -stable stuff.

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/memory-failure.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5c8f7e0..eac0ba5 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -52,6 +52,7 @@
 #include <linux/swapops.h>
 #include <linux/hugetlb.h>
 #include <linux/memory_hotplug.h>
+#include <linux/mm_inline.h>
 #include "internal.h"
 
 int sysctl_memory_failure_early_kill __read_mostly = 0;
@@ -1468,7 +1469,8 @@ int soft_offline_page(struct page *page, int flags)
 	put_page(page);
 	if (!ret) {
 		LIST_HEAD(pagelist);
-
+		inc_zone_page_state(page, NR_ISOLATED_ANON +
+					    page_is_file_cache(page));
 		list_add(&page->lru, &pagelist);
 		ret = migrate_pages(&pagelist, new_page, MPOL_MF_MOVE_ALL,
 								0, true);
-- 
1.7.0.4

