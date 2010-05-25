Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055Ab0EYWRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 18:17:14 -0400
Received: from smtp123.mail.ukl.yahoo.com ([77.238.184.54]:32705 "HELO
	smtp123.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754912Ab0EYWRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 18:17:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Cc:Subject:Date:Message-Id:X-Mailer;
  b=EBlmCnBJlMbHevk+3DDOQdeNfCPS6vrsOUTj45StGAwDwQiruk96nr+W9VJGgYL3bNDDRq8VkwiwfcnLfXgLxmCNj7fqCrHlel8MSR4yJ5XdNleHLnIKna630ls4IqDPb2VoVrduEMNl2ap4z0Wi1s7LSGl9iTa6LVBXeTmdeYM=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: AF.r6J4VM1nUP.9xXIschBO8Kbt_vAZUgtWH_v9KRQiFJ4FCA9Yk.naohkcv6v2OLIv5xcCZdlc9W4nRpBS3musTicDZS42CcbqoVGdqbeN1x.vJxf5_Isi06Qf3Xx3ACl3ZyoNCXkdIjMwOxwYXpmaU_sWZp8bwLWyQVe2Gt.7JcPPBEVP7gAMO07Sc8sA1qNDqKWgS71eA4KeeLwPBTWYrjDpaLKPZwZA2Bq..ClQcukd5fDufbBkkZE0WULZJ1IMlGrVhY2e5cDG9gM4BXAim9At005hh
X-Yahoo-Newman-Property: ymail-3
From: Albert Herranz <albert_herranz@yahoo.es>
To: npiggin@suse.de, jayakumar.lkml@gmail.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fbdev@vger.kernel.org
Cc: Albert Herranz <albert_herranz@yahoo.es>
Subject: [RFT PATCH 1/2] Revert "fb_defio: fix for non-dirty ptes"
Date: Wed, 26 May 2010 00:16:59 +0200
Message-Id: <1274825820-10246-1-git-send-email-albert_herranz@yahoo.es>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 49bbd815fd8ba26d0354900b783b767c7f47c816.
Although the fix provided is correct, it's been suggested to avoid the
underlying race in the same way as it is currently done in filesystems
like NFS, for maintainability.

A following patch "fb_defio: redo fix for non-dirty ptes" will provide
such an alternate fix.

LKML-Reference: <20100525160149.GE20853@laptop>
Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
---
 drivers/video/fb_defio.c |   40 ++++++++--------------------------------
 1 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
index 6e10a3a..0e4dcdb 100644
--- a/drivers/video/fb_defio.c
+++ b/drivers/video/fb_defio.c
@@ -155,41 +155,25 @@ static void fb_deferred_io_work(struct work_struct *work)
 {
 	struct fb_info *info = container_of(work, struct fb_info,
 						deferred_work.work);
+	struct list_head *node, *next;
+	struct page *cur;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
-	struct page *page, *tmp_page;
-	struct list_head *node, *tmp_node;
-	struct list_head non_dirty;
-
-	INIT_LIST_HEAD(&non_dirty);
 
 	/* here we mkclean the pages, then do all deferred IO */
 	mutex_lock(&fbdefio->lock);
-	list_for_each_entry_safe(page, tmp_page, &fbdefio->pagelist, lru) {
-		lock_page(page);
-		/*
-		 * The workqueue callback can be triggered after a
-		 * ->page_mkwrite() call but before the PTE has been marked
-		 * dirty. In this case page_mkclean() won't "rearm" the page.
-		 *
-		 * To avoid this, remove those "non-dirty" pages from the
-		 * pagelist before calling the driver's callback, then add
-		 * them back to get processed on the next work iteration.
-		 * At that time, their PTEs will hopefully be dirty for real.
-		 */
-		if (!page_mkclean(page))
-			list_move_tail(&page->lru, &non_dirty);
-		unlock_page(page);
+	list_for_each_entry(cur, &fbdefio->pagelist, lru) {
+		lock_page(cur);
+		page_mkclean(cur);
+		unlock_page(cur);
 	}
 
 	/* driver's callback with pagelist */
 	fbdefio->deferred_io(info, &fbdefio->pagelist);
 
-	/* clear the list... */
-	list_for_each_safe(node, tmp_node, &fbdefio->pagelist) {
+	/* clear the list */
+	list_for_each_safe(node, next, &fbdefio->pagelist) {
 		list_del(node);
 	}
-	/* ... and add back the "non-dirty" pages to the list */
-	list_splice_tail(&non_dirty, &fbdefio->pagelist);
 	mutex_unlock(&fbdefio->lock);
 }
 
@@ -218,20 +202,12 @@ EXPORT_SYMBOL_GPL(fb_deferred_io_open);
 void fb_deferred_io_cleanup(struct fb_info *info)
 {
 	struct fb_deferred_io *fbdefio = info->fbdefio;
-	struct list_head *node, *tmp_node;
 	struct page *page;
 	int i;
 
 	BUG_ON(!fbdefio);
 	flush_delayed_work(&info->deferred_work);
 
-	/*  the list may have still some non-dirty pages at this point */
-	mutex_lock(&fbdefio->lock);
-	list_for_each_safe(node, tmp_node, &fbdefio->pagelist) {
-		list_del(node);
-	}
-	mutex_unlock(&fbdefio->lock);
-
 	/* clear out the mapping that we setup */
 	for (i = 0 ; i < info->fix.smem_len; i += PAGE_SIZE) {
 		page = fb_deferred_io_page(info, i);
-- 
1.7.0.4

