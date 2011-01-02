Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab1ABPpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 10:45:20 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:63051 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab1ABPpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 10:45:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mcNpguRhYMjoRWwNLhPcPruyille46NlENVOpZjqR/12bDhV7okMHY82eoEZziNlkJ
         WZ9nKKKlM+SMCvqnNl2tSh3NWxd92A4RDHBgBZb7VJxdZYTcg/q/7+/FDvWjMy6CbHRQ
         jm5BRXwStZa4cBjhe7rWca7Es0YhCGpUnEhx8=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v2 5/7] truncate: Change remove_from_page_cache
Date: Mon,  3 Jan 2011 00:44:34 +0900
Message-Id: <05cf42eb7ae72d22b5cf050f02b95874ce216ace.1293982522.git.minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1293982522.git.minchan.kim@gmail.com>
References: <cover.1293982522.git.minchan.kim@gmail.com>
In-Reply-To: <cover.1293982522.git.minchan.kim@gmail.com>
References: <cover.1293982522.git.minchan.kim@gmail.com>
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
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/truncate.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 9ee5673..85404b0 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -108,13 +108,12 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
 	cancel_dirty_page(page, PAGE_CACHE_SIZE);
 
 	clear_page_mlock(page);
-	remove_from_page_cache(page);
+	delete_from_page_cache(page);
 	ClearPageMappedToDisk(page);
-	/* this must be after the remove_from_page_cache which
+	/* this must be after the delete_from_page_cache which
 	 * calls cleancache_put_page (and note page->mapping is now NULL)
 	 */
 	cleancache_flush_page(mapping, page);
-	page_cache_release(page);	/* pagecache ref */
 	return 0;
 }
 
-- 
1.7.0.4

