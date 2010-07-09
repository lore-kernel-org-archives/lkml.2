Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0GIDTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 23:19:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab0GIDTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 23:19:53 -0400
Message-ID: <4C3694BA.4080204@ds.jp.nec.com>
Date: Thu, 08 Jul 2010 23:17:14 -0400
From: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Munehiro Ikeda <m-ikeda@ds.jp.nec.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       Vivek Goyal <vgoyal@redhat.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
       Andrea Righi <righi.andrea@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com
Subject: [RFC][PATCH 05/11] blkiocg async: __set_page_dirty_nobuffer not to
 record process info
References: <4C369009.80503@ds.jp.nec.com>
In-Reply-To: <4C369009.80503@ds.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For same reason of introducing block_commit_write_noiotrack()
in the previous patch, this patch introduces
__set_page_dirty_nobuffer_noiotrack().
redirty_page_for_writepage() calls
__set_page_dirty_nobuffers_noiotrack()
because overwriting the process info for iotrack isn't needed
when redirtying.

Signed-off-by: Munehiro "Muuhh" Ikeda <m-ikeda@ds.jp.nec.com>
---
 include/linux/mm.h  |    1 +
 mm/page-writeback.c |   55 +++++++++++++++++++++++++++++++++++---------------
 2 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b969efb..08a957b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -851,6 +851,7 @@ extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned long offset);
 
 int __set_page_dirty_nobuffers(struct page *page);
+int __set_page_dirty_nobuffers_noiotrack(struct page *page);
 int __set_page_dirty_no_writeback(struct page *page);
 int redirty_page_for_writepage(struct writeback_control *wbc,
 				struct page *page);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index f3e6b2c..bdd6fdb 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1099,22 +1099,11 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
 	}
 }
 
-/*
- * For address_spaces which do not use buffers.  Just tag the page as dirty in
- * its radix tree.
- *
- * This is also used when a single buffer is being dirtied: we want to set the
- * page dirty in that case, but not all the buffers.  This is a "bottom-up"
- * dirtying, whereas __set_page_dirty_buffers() is a "top-down" dirtying.
- *
- * Most callers have locked the page, which pins the address_space in memory.
- * But zap_pte_range() does not lock the page, however in that case the
- * mapping is pinned by the vma's ->vm_file reference.
- *
- * We take care to handle the case where the page was truncated from the
- * mapping by re-checking page_mapping() inside tree_lock.
+/**
+ * ____set_page_dirty_nobuffers - helper function for __set_page_dirty_nobuffers*
+ * If track is true, dirtying process info will be recorded for iotrack
  */
-int __set_page_dirty_nobuffers(struct page *page)
+static int ____set_page_dirty_nobuffers(struct page *page, int track)
 {
 	if (!TestSetPageDirty(page)) {
 		struct address_space *mapping = page_mapping(page);
@@ -1129,7 +1118,9 @@ int __set_page_dirty_nobuffers(struct page *page)
 			BUG_ON(mapping2 != mapping);
 			WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
 			account_page_dirtied(page, mapping);
-			blk_iotrack_reset_owner_pagedirty(page, current->mm);
+			if (track)
+				blk_iotrack_reset_owner_pagedirty(page,
+					current->mm);
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 		}
@@ -1142,8 +1133,38 @@ int __set_page_dirty_nobuffers(struct page *page)
 	}
 	return 0;
 }
+
+/*
+ * For address_spaces which do not use buffers.  Just tag the page as dirty in
+ * its radix tree.
+ *
+ * This is also used when a single buffer is being dirtied: we want to set the
+ * page dirty in that case, but not all the buffers.  This is a "bottom-up"
+ * dirtying, whereas __set_page_dirty_buffers() is a "top-down" dirtying.
+ *
+ * Most callers have locked the page, which pins the address_space in memory.
+ * But zap_pte_range() does not lock the page, however in that case the
+ * mapping is pinned by the vma's ->vm_file reference.
+ *
+ * We take care to handle the case where the page was truncated from the
+ * mapping by re-checking page_mapping() inside tree_lock.
+ */
+int __set_page_dirty_nobuffers(struct page *page)
+{
+	return ____set_page_dirty_nobuffers(page, 1);
+}
 EXPORT_SYMBOL(__set_page_dirty_nobuffers);
 
+/**
+ * Same as __set_page_dirty_nobuffers, but doesn't record process
+ * info for iotrack.
+ */
+int __set_page_dirty_nobuffers_noiotrack(struct page *page)
+{
+	return ____set_page_dirty_nobuffers(page, 0);
+}
+EXPORT_SYMBOL(__set_page_dirty_nobuffers_noiotrack);
+
 /*
  * When a writepage implementation decides that it doesn't want to write this
  * page for some reason, it should redirty the locked page via
@@ -1152,7 +1173,7 @@ EXPORT_SYMBOL(__set_page_dirty_nobuffers);
 int redirty_page_for_writepage(struct writeback_control *wbc, struct page *page)
 {
 	wbc->pages_skipped++;
-	return __set_page_dirty_nobuffers(page);
+	return __set_page_dirty_nobuffers_noiotrack(page);
 }
 EXPORT_SYMBOL(redirty_page_for_writepage);
 
-- 
1.6.2.5
