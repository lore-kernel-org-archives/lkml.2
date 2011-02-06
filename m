Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab1BFPJn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 10:09:43 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39502 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab1BFPJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 10:09:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=RCF7Y65GhANEVE62J9T6vDEHIpRFX2zS/+6gBOj+NHrTxdeuuIxtY1zOQvLBkzYhYX
         50z8LVAS45k7UC9Ig5EqcoRzgwv/QM4JvZ/fcBnSyyHaYyJJeLheMDwf5UGrCcnvjeVJ
         +wnbx42Kg5NeOxEcbVXjouSX8uNoQwKXuhD1E=
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan.kim@gmail.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH] mm: Add hook of freepage
Date: Mon,  7 Feb 2011 00:08:54 +0900
Message-Id: <1297004934-4605-1-git-send-email-minchan.kim@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, "Call the filesystem back whenever a page is removed from
the page cache(6072d13c)" added new freepage hook in page cache
drop function.

So, replace_page_cache_page should call freepage to support
page cleanup to fs.

Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/filemap.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 3c89c96..a25c898 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -436,7 +436,10 @@ int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
 	error = radix_tree_preload(gfp_mask & ~__GFP_HIGHMEM);
 	if (!error) {
 		struct address_space *mapping = old->mapping;
+		void (*freepage)(struct page *);
+
 		pgoff_t offset = old->index;
+		freepage = mapping->a_ops->freepage;
 
 		page_cache_get(new);
 		new->mapping = mapping;
@@ -452,6 +455,8 @@ int replace_page_cache_page(struct page *old, struct page *new, gfp_t gfp_mask)
 			__inc_zone_page_state(new, NR_SHMEM);
 		spin_unlock_irq(&mapping->tree_lock);
 		radix_tree_preload_end();
+		if (freepage)
+			freepage(old);
 		page_cache_release(old);
 		mem_cgroup_end_migration(memcg, old, new, true);
 	} else {
-- 
1.7.1

