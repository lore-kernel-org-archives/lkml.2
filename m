Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915Ab0HCWT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 18:19:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8413 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0HCWTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 18:19:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=kVY6nFxRaXhwkV+o1XITaUjqqotEm4j5NPR0gI5gBwaLKr9P5cSF4NPEx/MmqznRf
	K+FADUlw7Jy8cjNOcteZQ==
From: Michael Rubin <mrubin@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Cc: jack@suse.cz, akpm@linux-foundation.org, david@fromorbit.com, hch@lst.de,
        axboe@kernel.dk, Michael Rubin <mrubin@google.com>
Subject: [PATCH 1/2] mm: helper functions for dirty and writeback accounting
Date: Tue,  3 Aug 2010 15:19:08 -0700
Message-Id: <1280873949-20460-2-git-send-email-mrubin@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280873949-20460-1-git-send-email-mrubin@google.com>
References: <1280873949-20460-1-git-send-email-mrubin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exporting account_pages_dirty and adding a symmetric routine
account_pages_writeback.

This allows code outside of the mm core to safely manipulate page state
and not worry about the other accounting. Not using these routines means
that some code will lose track of the accounting and we get bugs.

These routines are in use by ceph and nilfs2.

Signed-off-by: Michael Rubin <mrubin@google.com>
---
 fs/ceph/addr.c      |    8 ++------
 fs/nilfs2/segment.c |    2 +-
 include/linux/mm.h  |    1 +
 mm/page-writeback.c |   15 +++++++++++++++
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index d9c60b8..359aa3a 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -106,12 +106,8 @@ static int ceph_set_page_dirty(struct page *page)
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(!PageUptodate(page));
 
-		if (mapping_cap_account_dirty(mapping)) {
-			__inc_zone_page_state(page, NR_FILE_DIRTY);
-			__inc_bdi_stat(mapping->backing_dev_info,
-					BDI_RECLAIMABLE);
-			task_io_account_write(PAGE_CACHE_SIZE);
-		}
+		if (mapping_cap_account_dirty(mapping))
+			account_page_dirtied(page, page->mapping);
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index c920164..967ed7d 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1599,7 +1599,7 @@ nilfs_copy_replace_page_buffers(struct page *page, struct list_head *out)
 	kunmap_atomic(kaddr, KM_USER0);
 
 	if (!TestSetPageWriteback(clone_page))
-		inc_zone_page_state(clone_page, NR_WRITEBACK);
+		account_page_writeback(clone_page, page_mapping(clone_page));
 	unlock_page(clone_page);
 
 	return 0;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index a2b4804..b138392 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -855,6 +855,7 @@ int __set_page_dirty_no_writeback(struct page *page);
 int redirty_page_for_writepage(struct writeback_control *wbc,
 				struct page *page);
 void account_page_dirtied(struct page *page, struct address_space *mapping);
+void account_page_writeback(struct page *page, struct address_space *mapping);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 37498ef..b8e7b3b 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1096,6 +1096,21 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
 		task_io_account_write(PAGE_CACHE_SIZE);
 	}
 }
+EXPORT_SYMBOL(account_page_dirtied);
+
+/*
+ * Helper function for set_page_writeback family.
+ * NOTE: Unlike account_page_dirtied this does not rely on being atomic
+ * wrt interrupts.
+ */
+
+void account_page_writeback(struct page *page, struct address_space *mapping)
+{
+	if (mapping_cap_account_dirty(mapping))
+		inc_zone_page_state(page, NR_WRITEBACK);
+}
+EXPORT_SYMBOL(account_page_writeback);
+
 
 /*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in
-- 
1.7.1

