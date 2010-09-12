Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0ILUcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 16:32:08 -0400
Received: from smtp-out.google.com ([74.125.121.35]:40386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab0ILUcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 16:32:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=kB2vkMnxJZc8yY5kQ+gsE6LOeoLyH4xjgf+7JfNpQHKMj2dMq6GHd+wFDUZ6UvhT1
	10bzvGJ/aSRRxYBy6JrtA==
From: Michael Rubin <mrubin@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Cc: fengguang.wu@intel.com, jack@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, david@fromorbit.com,
        kosaki.motohiro@jp.fujitsu.com, npiggin@kernel.dk, hch@lst.de,
        axboe@kernel.dk, Michael Rubin <mrubin@google.com>
Subject: [PATCH 2/5] mm: account_page_writeback added
Date: Sun, 12 Sep 2010 13:30:37 -0700
Message-Id: <1284323440-23205-3-git-send-email-mrubin@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284323440-23205-1-git-send-email-mrubin@google.com>
References: <1284323440-23205-1-git-send-email-mrubin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows code outside of the mm core to safely manipulate page
writeback state and not worry about the other accounting. Not using
these routines means that some code will lose track of the accounting
and we get bugs.

Modified nilfs2 to use interface.

Signed-off-by: Michael Rubin <mrubin@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/nilfs2/segment.c |    2 +-
 include/linux/mm.h  |    1 +
 mm/page-writeback.c |   13 ++++++++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 9fd051a..5617f16 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -1599,7 +1599,7 @@ nilfs_copy_replace_page_buffers(struct page *page, struct list_head *out)
 	kunmap_atomic(kaddr, KM_USER0);
 
 	if (!TestSetPageWriteback(clone_page))
-		inc_zone_page_state(clone_page, NR_WRITEBACK);
+		account_page_writeback(clone_page);
 	unlock_page(clone_page);
 
 	return 0;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 709f672..4b2f38b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -856,6 +856,7 @@ int __set_page_dirty_no_writeback(struct page *page);
 int redirty_page_for_writepage(struct writeback_control *wbc,
 				struct page *page);
 void account_page_dirtied(struct page *page, struct address_space *mapping);
+void account_page_writeback(struct page *page);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 9d07a8d..ae5f5d5 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1134,6 +1134,17 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
 EXPORT_SYMBOL(account_page_dirtied);
 
 /*
+ * Helper function for set_page_writeback family.
+ * NOTE: Unlike account_page_dirtied this does not rely on being atomic
+ * wrt interrupts.
+ */
+void account_page_writeback(struct page *page)
+{
+	inc_zone_page_state(page, NR_WRITEBACK);
+}
+EXPORT_SYMBOL(account_page_writeback);
+
+/*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in
  * its radix tree.
  *
@@ -1371,7 +1382,7 @@ int test_set_page_writeback(struct page *page)
 		ret = TestSetPageWriteback(page);
 	}
 	if (!ret)
-		inc_zone_page_state(page, NR_WRITEBACK);
+		account_page_writeback(page);
 	return ret;
 
 }
-- 
1.7.1

