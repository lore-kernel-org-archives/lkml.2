Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546Ab2GZVb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:31:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40055 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2GZVbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:31:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan@kernel.org>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Nai Xia <nai.xia@gmail.com>, Johannes Weiner <jweiner@redhat.com>
Subject: [ 25/40] mm: compaction: make isolate_lru_page() filter-aware again
Date: Thu, 26 Jul 2012 14:29:43 -0700
Message-Id: <20120726211413.373722629@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211411.164006056@linuxfoundation.org>
References: <20120726211424.GA7709@kroah.com>
 <20120726211411.164006056@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mel Gorman <mgorman@suse.de>

commit c82449352854ff09e43062246af86bdeb628f0c3 upstream.

Stable note: Not tracked in Bugzilla. A fix aimed at preserving page aging
	information by reducing LRU list churning had the side-effect of
	reducing THP allocation success rates. This was part of a series
	to restore the success rates while preserving the reclaim fix.

Commit 39deaf85 ("mm: compaction: make isolate_lru_page() filter-aware")
noted that compaction does not migrate dirty or writeback pages and that
is was meaningless to pick the page and re-add it to the LRU list.  This
had to be partially reverted because some dirty pages can be migrated by
compaction without blocking.

This patch updates "mm: compaction: make isolate_lru_page" by skipping
over pages that migration has no possibility of migrating to minimise LRU
disruption.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel<riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/mmzone.h |    2 ++
 mm/compaction.c        |    3 +++
 mm/vmscan.c            |   35 +++++++++++++++++++++++++++++++++--
 3 files changed, 38 insertions(+), 2 deletions(-)

--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -166,6 +166,8 @@ static inline int is_unevictable_lru(enu
 #define ISOLATE_CLEAN		((__force isolate_mode_t)0x4)
 /* Isolate unmapped file */
 #define ISOLATE_UNMAPPED	((__force isolate_mode_t)0x8)
+/* Isolate for asynchronous migration */
+#define ISOLATE_ASYNC_MIGRATE	((__force isolate_mode_t)0x10)
 
 /* LRU Isolation modes. */
 typedef unsigned __bitwise__ isolate_mode_t;
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -371,6 +371,9 @@ static isolate_migrate_t isolate_migrate
 			continue;
 		}
 
+		if (!cc->sync)
+			mode |= ISOLATE_ASYNC_MIGRATE;
+
 		/* Try isolate the page */
 		if (__isolate_lru_page(page, mode, 0) != 0)
 			continue;
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1045,8 +1045,39 @@ int __isolate_lru_page(struct page *page
 
 	ret = -EBUSY;
 
-	if ((mode & ISOLATE_CLEAN) && (PageDirty(page) || PageWriteback(page)))
-		return ret;
+	/*
+	 * To minimise LRU disruption, the caller can indicate that it only
+	 * wants to isolate pages it will be able to operate on without
+	 * blocking - clean pages for the most part.
+	 *
+	 * ISOLATE_CLEAN means that only clean pages should be isolated. This
+	 * is used by reclaim when it is cannot write to backing storage
+	 *
+	 * ISOLATE_ASYNC_MIGRATE is used to indicate that it only wants to pages
+	 * that it is possible to migrate without blocking
+	 */
+	if (mode & (ISOLATE_CLEAN|ISOLATE_ASYNC_MIGRATE)) {
+		/* All the caller can do on PageWriteback is block */
+		if (PageWriteback(page))
+			return ret;
+
+		if (PageDirty(page)) {
+			struct address_space *mapping;
+
+			/* ISOLATE_CLEAN means only clean pages */
+			if (mode & ISOLATE_CLEAN)
+				return ret;
+
+			/*
+			 * Only pages without mappings or that have a
+			 * ->migratepage callback are possible to migrate
+			 * without blocking
+			 */
+			mapping = page_mapping(page);
+			if (mapping && !mapping->a_ops->migratepage)
+				return ret;
+		}
+	}
 
 	if ((mode & ISOLATE_UNMAPPED) && page_mapped(page))
 		return ret;


