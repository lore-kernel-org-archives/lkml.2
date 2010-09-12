Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab0ILUb3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 16:31:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39225 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab0ILUb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 16:31:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=qQFh29JeH2uaAY4RdQ9jPWWgI1v+FJnzBWtU4bx9wg0H6IDbEQHq13MQi0f1PhWvj
	bo/0DpwLcJNUACD0KrORA==
From: Michael Rubin <mrubin@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Cc: fengguang.wu@intel.com, jack@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, david@fromorbit.com,
        kosaki.motohiro@jp.fujitsu.com, npiggin@kernel.dk, hch@lst.de,
        axboe@kernel.dk, Michael Rubin <mrubin@google.com>
Subject: [PATCH 1/5] mm: exporting account_page_dirty
Date: Sun, 12 Sep 2010 13:30:36 -0700
Message-Id: <1284323440-23205-2-git-send-email-mrubin@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284323440-23205-1-git-send-email-mrubin@google.com>
References: <1284323440-23205-1-git-send-email-mrubin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows code outside of the mm core to safely manipulate page state
and not worry about the other accounting. Not using these routines means
that some code will lose track of the accounting and we get bugs. This
has happened once already.

Modified cephs to use the interface.

Signed-off-by: Michael Rubin <mrubin@google.com>
Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/ceph/addr.c      |    8 +-------
 mm/page-writeback.c |    1 +
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 5598a0d..420d469 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -105,13 +105,7 @@ static int ceph_set_page_dirty(struct page *page)
 	spin_lock_irq(&mapping->tree_lock);
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(!PageUptodate(page));
-
-		if (mapping_cap_account_dirty(mapping)) {
-			__inc_zone_page_state(page, NR_FILE_DIRTY);
-			__inc_bdi_stat(mapping->backing_dev_info,
-					BDI_RECLAIMABLE);
-			task_io_account_write(PAGE_CACHE_SIZE);
-		}
+		account_page_dirtied(page, page->mapping);
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 7262aac..9d07a8d 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1131,6 +1131,7 @@ void account_page_dirtied(struct page *page, struct address_space *mapping)
 		task_io_account_write(PAGE_CACHE_SIZE);
 	}
 }
+EXPORT_SYMBOL(account_page_dirtied);
 
 /*
  * For address_spaces which do not use buffers.  Just tag the page as dirty in
-- 
1.7.1

