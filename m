Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965226Ab2B1O4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:56:33 -0500
Received: from mga14.intel.com ([143.182.124.37]:43154 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965127Ab2B1O42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:56:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112219307"
Message-Id: <20120228144747.044421224@intel.com>
User-Agent: quilt/0.51-1
Date: Tue, 28 Feb 2012 22:00:25 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Righi <andrea@betterlinux.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>
cc: Linux Memory Management List <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/9] memcg: add kernel calls for memcg dirty page stats
References: <20120228140022.614718843@intel.com>
Content-Disposition: inline; filename=memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Thelen <gthelen@google.com>

Add calls into memcg dirty page accounting.  Notify memcg when pages
transition between clean, file dirty, writeback, and unstable nfs.  This
allows the memory controller to maintain an accurate view of the amount
of its memory that is dirty.

Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrea Righi <andrea@betterlinux.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 fs/nfs/write.c      |    4 ++++
 mm/filemap.c        |    1 +
 mm/page-writeback.c |    4 ++++
 mm/truncate.c       |    1 +
 4 files changed, 10 insertions(+)

--- linux.orig/fs/nfs/write.c	2012-02-19 10:53:14.000000000 +0800
+++ linux/fs/nfs/write.c	2012-02-19 10:53:21.000000000 +0800
@@ -449,6 +449,7 @@ nfs_mark_request_commit(struct nfs_page 
 	nfsi->ncommit++;
 	spin_unlock(&inode->i_lock);
 	pnfs_mark_request_commit(req, lseg);
+	mem_cgroup_inc_page_stat(req->wb_page, MEMCG_NR_FILE_UNSTABLE_NFS);
 	inc_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
 	inc_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_RECLAIMABLE);
 	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
@@ -460,6 +461,7 @@ nfs_clear_request_commit(struct nfs_page
 	struct page *page = req->wb_page;
 
 	if (test_and_clear_bit(PG_CLEAN, &(req)->wb_flags)) {
+		mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_UNSTABLE_NFS);
 		dec_zone_page_state(page, NR_UNSTABLE_NFS);
 		dec_bdi_stat(page->mapping->backing_dev_info, BDI_RECLAIMABLE);
 		return 1;
@@ -1408,6 +1410,8 @@ void nfs_retry_commit(struct list_head *
 		req = nfs_list_entry(page_list->next);
 		nfs_list_remove_request(req);
 		nfs_mark_request_commit(req, lseg);
+		mem_cgroup_dec_page_stat(req->wb_page,
+					 MEMCG_NR_FILE_UNSTABLE_NFS);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
 		dec_bdi_stat(req->wb_page->mapping->backing_dev_info,
 			     BDI_RECLAIMABLE);
--- linux.orig/mm/filemap.c	2012-02-19 10:53:14.000000000 +0800
+++ linux/mm/filemap.c	2012-02-19 10:53:21.000000000 +0800
@@ -142,6 +142,7 @@ void __delete_from_page_cache(struct pag
 	 * having removed the page entirely.
 	 */
 	if (PageDirty(page) && mapping_cap_account_dirty(mapping)) {
+		mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_DIRTY);
 		dec_zone_page_state(page, NR_FILE_DIRTY);
 		dec_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
 	}
--- linux.orig/mm/page-writeback.c	2012-02-19 10:53:14.000000000 +0800
+++ linux/mm/page-writeback.c	2012-02-19 10:53:21.000000000 +0800
@@ -1933,6 +1933,7 @@ int __set_page_dirty_no_writeback(struct
 void account_page_dirtied(struct page *page, struct address_space *mapping)
 {
 	if (mapping_cap_account_dirty(mapping)) {
+		mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_DIRTY);
 		__inc_zone_page_state(page, NR_FILE_DIRTY);
 		__inc_zone_page_state(page, NR_DIRTIED);
 		__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
@@ -1951,6 +1952,7 @@ EXPORT_SYMBOL(account_page_dirtied);
  */
 void account_page_writeback(struct page *page)
 {
+	mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_WRITEBACK);
 	inc_zone_page_state(page, NR_WRITEBACK);
 }
 EXPORT_SYMBOL(account_page_writeback);
@@ -2152,6 +2154,7 @@ int clear_page_dirty_for_io(struct page 
 		 * for more comments.
 		 */
 		if (TestClearPageDirty(page)) {
+			mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_DIRTY);
 			dec_zone_page_state(page, NR_FILE_DIRTY);
 			dec_bdi_stat(mapping->backing_dev_info,
 					BDI_RECLAIMABLE);
@@ -2188,6 +2191,7 @@ int test_clear_page_writeback(struct pag
 		ret = TestClearPageWriteback(page);
 	}
 	if (ret) {
+		mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_WRITEBACK);
 		dec_zone_page_state(page, NR_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITTEN);
 	}
--- linux.orig/mm/truncate.c	2012-02-19 10:53:14.000000000 +0800
+++ linux/mm/truncate.c	2012-02-19 10:53:21.000000000 +0800
@@ -76,6 +76,7 @@ void cancel_dirty_page(struct page *page
 	if (TestClearPageDirty(page)) {
 		struct address_space *mapping = page->mapping;
 		if (mapping && mapping_cap_account_dirty(mapping)) {
+			mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_DIRTY);
 			dec_zone_page_state(page, NR_FILE_DIRTY);
 			dec_bdi_stat(mapping->backing_dev_info,
 					BDI_RECLAIMABLE);


