Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2GWB4P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:56:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54230 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753305Ab2GWBnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:01 -0400
Message-Id: <20120723010702.248100524@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:02 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Boaz Harrosh <bharrosh@panasas.com>
Subject: [ 071/108] pnfs-obj: Fix __r4w_get_page when offset is beyond i_size
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boaz Harrosh <bharrosh@panasas.com>

commit c999ff68029ebd0f56ccae75444f640f6d5a27d2 upstream.

It is very common for the end of the file to be unaligned on
stripe size. But since we know it's beyond file's end then
the XOR should be preformed with all zeros.

Old code used to just read zeros out of the OSD devices, which is a great
waist. But what scares me more about this situation is that, we now have
pages attached to the file's mapping that are beyond i_size. I don't
like the kind of bugs this calls for.

Fix both birds, by returning a global zero_page, if offset is beyond
i_size.

TODO:
	Change the API to ->__r4w_get_page() so a NULL can be
	returned without being considered as error, since XOR API
	treats NULL entries as zero_pages.

[Bug since 3.2. Should apply the same way to all Kernels since]
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
[bwh: Backported to 3.2: adjust for lack of wdata->header]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/nfs/objlayout/objio_osd.c
+++ b/fs/nfs/objlayout/objio_osd.c
@@ -467,8 +467,16 @@ static struct page *__r4w_get_page(void
 	struct objio_state *objios = priv;
 	struct nfs_write_data *wdata = objios->oir.rpcdata;
 	pgoff_t index = offset / PAGE_SIZE;
-	struct page *page = find_get_page(wdata->inode->i_mapping, index);
+	struct page *page;
+	loff_t i_size = i_size_read(wdata->inode);
 
+	if (offset >= i_size) {
+		*uptodate = true;
+		dprintk("%s: g_zero_page index=0x%lx\n", __func__, index);
+		return ZERO_PAGE(0);
+	}
+
+	page = find_get_page(wdata->inode->i_mapping, index);
 	if (!page) {
 		page = find_or_create_page(wdata->inode->i_mapping,
 						index, GFP_NOFS);
@@ -489,8 +497,10 @@ static struct page *__r4w_get_page(void
 
 static void __r4w_put_page(void *priv, struct page *page)
 {
-	dprintk("%s: index=0x%lx\n", __func__, page->index);
-	page_cache_release(page);
+	dprintk("%s: index=0x%lx\n", __func__,
+		(page == ZERO_PAGE(0)) ? -1UL : page->index);
+	if (ZERO_PAGE(0) != page)
+		page_cache_release(page);
 	return;
 }
 


