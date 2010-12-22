Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0LVPeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:34:09 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33013 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab0LVPeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 10:34:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DruAlooJYnFF+LMHAXVUVbNEL3YDNQw+PKCmwmOtCdO1ZfkTUarkGqz4RfXT+0DSjb
         eQIlPvDVEeLH1MOdeIbIkcJYB1WxOqVi5Mq0m/R4Jc9Z0tURSxNDQKqLNRxG5d7of9kO
         rMeB23GI/zwmqwbD25RSG+YW9eZbDkSryqrjs=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5/7] truncate: Change remove_from_page_cache
Date: Thu, 23 Dec 2010 00:32:47 +0900
Message-Id: <fdafb3fb6ed32ec96f945fdbdd42bd6492d00cd7.1293031047.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1293031046.git.minchan.kim@gmail.com>
References: <cover.1293031046.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1293031046.git.minchan.kim@gmail.com>
References: <cover.1293031046.git.minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series changes remove_from_page_cache's page ref counting
rule. Page cache ref count is decreased in delete_from_page_cache.
So we don't need decreasing page reference by caller.

Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/truncate.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 9ee5673..3adb9c0 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -108,13 +108,12 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
 	cancel_dirty_page(page, PAGE_CACHE_SIZE);
 
 	clear_page_mlock(page);
-	remove_from_page_cache(page);
+	delete_from_page_cache(page);
 	ClearPageMappedToDisk(page);
 	/* this must be after the remove_from_page_cache which
 	 * calls cleancache_put_page (and note page->mapping is now NULL)
 	 */
 	cleancache_flush_page(mapping, page);
-	page_cache_release(page);	/* pagecache ref */
 	return 0;
 }
 
-- 
1.7.0.4

