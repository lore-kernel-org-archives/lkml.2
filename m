Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab0HTJcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:32:18 -0400
Received: from smtp-out.google.com ([74.125.121.35]:26125 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0HTJcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:32:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=cEP7S/SCqh9d/dMXo2mat46998gJ9Iu/DQPjyA2R6xUwl+irY0KJV0vNB7gL6A/an
	eoF1UmPMtSgqdrYwjRdYg==
From: Michael Rubin <mrubin@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Cc: fengguang.wu@intel.com, jack@suse.cz, riel@redhat.com,
        akpm@linux-foundation.org, david@fromorbit.com, npiggin@kernel.dk,
        hch@lst.de, axboe@kernel.dk, Michael Rubin <mrubin@google.com>
Subject: [PATCH 1/4] mm: exporting account_page_dirty
Date: Fri, 20 Aug 2010 02:31:26 -0700
Message-Id: <1282296689-25618-2-git-send-email-mrubin@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282296689-25618-1-git-send-email-mrubin@google.com>
References: <1282296689-25618-1-git-send-email-mrubin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows code outside of the mm core to safely manipulate page state
and not worry about the other accounting. Not using these routines means
that some code will lose track of the accounting and we get bugs. This
has happened once already.

Signed-off-by: Michael Rubin <mrubin@google.com>
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

