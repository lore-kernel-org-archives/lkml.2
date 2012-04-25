Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab2DYGWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 02:22:44 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48168 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057Ab2DYGWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 02:22:43 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-03-4f979831d258
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 1/6] zsmalloc: use PageFlag macro instead of [set|test]_bit
Date: Wed, 25 Apr 2012 15:23:09 +0900
Message-Id: <1335334994-22138-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1335334994-22138-1-git-send-email-minchan@kernel.org>
References: <1335334994-22138-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MM code always uses PageXXX to handle page flags.
Let's keep the consistency.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 917461c..504b6c2 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -45,12 +45,12 @@ static DEFINE_PER_CPU(struct mapping_area, zs_map_area);
 
 static int is_first_page(struct page *page)
 {
-	return test_bit(PG_private, &page->flags);
+	return PagePrivate(page);
 }
 
 static int is_last_page(struct page *page)
 {
-	return test_bit(PG_private_2, &page->flags);
+	return PagePrivate2(page);
 }
 
 static void get_zspage_mapping(struct page *page, unsigned int *class_idx,
@@ -377,7 +377,7 @@ static struct page *alloc_zspage(struct size_class *class, gfp_t flags)
 
 		INIT_LIST_HEAD(&page->lru);
 		if (i == 0) {	/* first page */
-			set_bit(PG_private, &page->flags);
+			SetPagePrivate(page);
 			set_page_private(page, 0);
 			first_page = page;
 			first_page->inuse = 0;
@@ -389,8 +389,7 @@ static struct page *alloc_zspage(struct size_class *class, gfp_t flags)
 		if (i >= 2)
 			list_add(&page->lru, &prev_page->lru);
 		if (i == class->zspage_order - 1)	/* last page */
-			set_bit(PG_private_2, &page->flags);
-
+			SetPagePrivate2(page);
 		prev_page = page;
 	}
 
-- 
1.7.9.5

