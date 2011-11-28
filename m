Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1K1OJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:09:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:49496 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823Ab1K1OJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:09:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,584,1315206000"; 
   d="scan'208";a="79787534"
Message-Id: <20111128140513.401344389@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 28 Nov 2011 21:53:42 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: <linux-fsdevel@vger.kernel.org>
cc: Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Wu Fengguang <fengguang.wu@intel.com>
CC: Christoph Hellwig <hch@lst.de>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] writeback: fix dirtied pages accounting on redirty
References: <20111128135338.249672012@intel.com>
Content-Disposition: inline; filename=writeback-account-redirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

De-account the accumulative dirty counters on page redirty.

Page redirties (very common in ext4) will introduce mismatch between
counters (a) and (b)

a) NR_DIRTIED, BDI_DIRTIED, tsk->nr_dirtied
b) NR_WRITTEN, BDI_WRITTEN

This will introduce systematic errors in balanced_rate and result in
dirty page position errors (ie. the dirty pages are no longer balanced
around the global/bdi setpoints).

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/writeback.h |    2 ++
 mm/page-writeback.c       |   19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

--- linux-next.orig/mm/page-writeback.c	2011-11-28 21:23:23.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-11-28 21:23:24.000000000 +0800
@@ -1806,6 +1806,24 @@ int __set_page_dirty_nobuffers(struct pa
 EXPORT_SYMBOL(__set_page_dirty_nobuffers);
 
 /*
+ * Call this whenever redirtying a page, to de-account the dirty counters
+ * (NR_DIRTIED, BDI_DIRTIED, tsk->nr_dirtied), so that they match the written
+ * counters (NR_WRITTEN, BDI_WRITTEN) in long term. The mismatches will lead to
+ * systematic errors in balanced_dirty_ratelimit and the dirty pages position
+ * control.
+ */
+void account_page_redirty(struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+	if (mapping && mapping_cap_account_dirty(mapping)) {
+		current->nr_dirtied--;
+		dec_zone_page_state(page, NR_DIRTIED);
+		dec_bdi_stat(mapping->backing_dev_info, BDI_DIRTIED);
+	}
+}
+EXPORT_SYMBOL(account_page_redirty);
+
+/*
  * When a writepage implementation decides that it doesn't want to write this
  * page for some reason, it should redirty the locked page via
  * redirty_page_for_writepage() and it should then unlock the page and return 0
@@ -1813,6 +1831,7 @@ EXPORT_SYMBOL(__set_page_dirty_nobuffers
 int redirty_page_for_writepage(struct writeback_control *wbc, struct page *page)
 {
 	wbc->pages_skipped++;
+	account_page_redirty(page);
 	return __set_page_dirty_nobuffers(page);
 }
 EXPORT_SYMBOL(redirty_page_for_writepage);
--- linux-next.orig/include/linux/writeback.h	2011-11-28 21:23:20.000000000 +0800
+++ linux-next/include/linux/writeback.h	2011-11-28 21:23:24.000000000 +0800
@@ -197,6 +197,8 @@ void writeback_set_ratelimit(void);
 void tag_pages_for_writeback(struct address_space *mapping,
 			     pgoff_t start, pgoff_t end);
 
+void account_page_redirty(struct page *page);
+
 /* pdflush.c */
 extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
 				   read-only. */


