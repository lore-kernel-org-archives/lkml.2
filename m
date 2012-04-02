Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab2DBOOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:14:41 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47709 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2DBOOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:14:40 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] staging: zsmalloc: fix memory leak
Date: Mon,  2 Apr 2012 09:13:56 -0500
Message-Id: <1333376036-9841-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040214-5518-0000-0000-000003634440
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nitin Gupta <ngupta@vflare.org>

This patch fixes a memory leak in zsmalloc where the first
subpage of each zspage is leaked when the zspage is freed.

Based on 3.4-rc1.

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |   30 ++++++++++++++++++------------
 1 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 09caa4f..917461c 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -267,33 +267,39 @@ static unsigned long obj_idx_to_offset(struct page *page,
 	return off + obj_idx * class_size;
 }
 
+static void reset_page(struct page *page)
+{
+	clear_bit(PG_private, &page->flags);
+	clear_bit(PG_private_2, &page->flags);
+	set_page_private(page, 0);
+	page->mapping = NULL;
+	page->freelist = NULL;
+	reset_page_mapcount(page);
+}
+
 static void free_zspage(struct page *first_page)
 {
-	struct page *nextp, *tmp;
+	struct page *nextp, *tmp, *head_extra;
 
 	BUG_ON(!is_first_page(first_page));
 	BUG_ON(first_page->inuse);
 
-	nextp = (struct page *)page_private(first_page);
+	head_extra = (struct page *)page_private(first_page);
 
-	clear_bit(PG_private, &first_page->flags);
-	clear_bit(PG_private_2, &first_page->flags);
-	set_page_private(first_page, 0);
-	first_page->mapping = NULL;
-	first_page->freelist = NULL;
-	reset_page_mapcount(first_page);
+	reset_page(first_page);
 	__free_page(first_page);
 
 	/* zspage with only 1 system page */
-	if (!nextp)
+	if (!head_extra)
 		return;
 
-	list_for_each_entry_safe(nextp, tmp, &nextp->lru, lru) {
+	list_for_each_entry_safe(nextp, tmp, &head_extra->lru, lru) {
 		list_del(&nextp->lru);
-		clear_bit(PG_private_2, &nextp->flags);
-		nextp->index = 0;
+		reset_page(nextp);
 		__free_page(nextp);
 	}
+	reset_page(head_extra);
+	__free_page(head_extra);
 }
 
 /* Initialize a newly allocated zspage */
-- 
1.7.5.4

