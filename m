Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab1IHXOc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:14:32 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:61977 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab1IHXOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:14:14 -0400
X-IronPort-AV: E=Sophos;i="4.68,351,1312156800"; 
   d="scan'208";a="7684322"
Date: Thu, 8 Sep 2011 19:45:08 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH v4 1/2] xen: add an "highmem" parameter to
 alloc_xenballooned_pages
Message-ID: <alpine.DEB.2.00.1109081942470.12963@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an highmem parameter to alloc_xenballooned_pages, to allow callers to
request lowmem or highmem pages.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/balloon.c |   12 ++++++++----
 drivers/xen/gntdev.c  |    2 +-
 include/xen/balloon.h |    3 ++-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 5dfd8f8..7f7d463 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -501,20 +501,24 @@ EXPORT_SYMBOL_GPL(balloon_set_new_target);
  * alloc_xenballooned_pages - get pages that have been ballooned out
  * @nr_pages: Number of pages to get
  * @pages: pages returned
+ * @highmem: highmem or lowmem pages
  * @return 0 on success, error otherwise
  */
-int alloc_xenballooned_pages(int nr_pages, struct page** pages)
+int alloc_xenballooned_pages(int nr_pages, struct page** pages, bool highmem)
 {
 	int pgno = 0;
 	struct page* page;
 	mutex_lock(&balloon_mutex);
 	while (pgno < nr_pages) {
-		page = balloon_retrieve(true);
-		if (page) {
+		page = balloon_retrieve(highmem);
+		if (page && PageHighMem(page) == highmem) {
 			pages[pgno++] = page;
 		} else {
 			enum bp_state st;
-			st = decrease_reservation(nr_pages - pgno, GFP_HIGHUSER);
+			if (page)
+				balloon_append(page);
+			st = decrease_reservation(nr_pages - pgno,
+					highmem ? GFP_HIGHUSER : GFP_USER);
 			if (st != BP_DONE)
 				goto out_undo;
 		}
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index f914b26..7b9b1d1 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -123,7 +123,7 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
 	    NULL == add->pages)
 		goto err;
 
-	if (alloc_xenballooned_pages(count, add->pages))
+	if (alloc_xenballooned_pages(count, add->pages, false /* lowmem */))
 		goto err;
 
 	for (i = 0; i < count; i++) {
diff --git a/include/xen/balloon.h b/include/xen/balloon.h
index 76f7538..b1a8233 100644
--- a/include/xen/balloon.h
+++ b/include/xen/balloon.h
@@ -25,7 +25,8 @@ extern struct balloon_stats balloon_stats;
 
 void balloon_set_new_target(unsigned long target);
 
-int alloc_xenballooned_pages(int nr_pages, struct page** pages);
+int alloc_xenballooned_pages(int nr_pages, struct page** pages,
+		bool highmem);
 void free_xenballooned_pages(int nr_pages, struct page** pages);
 
 struct sys_device;
-- 
1.7.2.3

