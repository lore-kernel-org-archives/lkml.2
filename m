Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946178Ab2JYPPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:15:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946106Ab2JYPOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:14:00 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi.kleen@intel.com>, Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Akira Fujita <a-fujita@rs.jp.nec.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org
Subject: [PATCH 2/3] ext4: introduce ext4_error_remove_page
Date: Thu, 25 Oct 2012 11:12:48 -0400
Message-Id: <1351177969-893-3-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1351177969-893-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1351177969-893-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ext4 has its own configurable error handling policy, so it's helpful
if we can use it also in the context of memory error handling.
With this patch, when we detect a memory error on a dirty pagecache in
ext4 filesystem, we can allow users to choose to trigger kernel panic
to avoid consuming corrupted data.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 fs/ext4/inode.c | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git v3.7-rc2.orig/fs/ext4/inode.c v3.7-rc2/fs/ext4/inode.c
index b3c243b..513badb 100644
--- v3.7-rc2.orig/fs/ext4/inode.c
+++ v3.7-rc2/fs/ext4/inode.c
@@ -3163,6 +3163,33 @@ static int ext4_journalled_set_page_dirty(struct page *page)
 	return __set_page_dirty_nobuffers(page);
 }
 
+static int ext4_error_remove_page(struct address_space *mapping,
+				struct page *page)
+{
+	struct inode *inode = mapping->host;
+	struct buffer_head *bh, *head;
+	ext4_fsblk_t block;
+
+	if (!PageDirty(page) || !page_has_buffers(page))
+		goto remove_page;
+
+	/* Lost data. Handle as critical fs error. */
+	bh = head = page_buffers(page);
+	do {
+		if (buffer_dirty(bh) && !buffer_delay(bh)) {
+			block = bh->b_blocknr;
+			EXT4_ERROR_INODE_BLOCK(inode, block,
+						"Removing dirty pagecache page");
+		} else
+			EXT4_ERROR_INODE(inode,
+					"Removing dirty pagecache page");
+		bh = bh->b_this_page;
+	} while (bh != head);
+
+remove_page:
+	return generic_error_remove_page(mapping, page);
+}
+
 static const struct address_space_operations ext4_ordered_aops = {
 	.readpage		= ext4_readpage,
 	.readpages		= ext4_readpages,
@@ -3175,7 +3202,7 @@ static const struct address_space_operations ext4_ordered_aops = {
 	.direct_IO		= ext4_direct_IO,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
-	.error_remove_page	= generic_error_remove_page,
+	.error_remove_page	= ext4_error_remove_page,
 };
 
 static const struct address_space_operations ext4_writeback_aops = {
@@ -3190,7 +3217,7 @@ static const struct address_space_operations ext4_writeback_aops = {
 	.direct_IO		= ext4_direct_IO,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
-	.error_remove_page	= generic_error_remove_page,
+	.error_remove_page	= ext4_error_remove_page,
 };
 
 static const struct address_space_operations ext4_journalled_aops = {
@@ -3205,7 +3232,7 @@ static const struct address_space_operations ext4_journalled_aops = {
 	.releasepage		= ext4_releasepage,
 	.direct_IO		= ext4_direct_IO,
 	.is_partially_uptodate  = block_is_partially_uptodate,
-	.error_remove_page	= generic_error_remove_page,
+	.error_remove_page	= ext4_error_remove_page,
 };
 
 static const struct address_space_operations ext4_da_aops = {
@@ -3221,7 +3248,7 @@ static const struct address_space_operations ext4_da_aops = {
 	.direct_IO		= ext4_direct_IO,
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
-	.error_remove_page	= generic_error_remove_page,
+	.error_remove_page	= ext4_error_remove_page,
 };
 
 void ext4_set_aops(struct inode *inode)
-- 
1.7.11.7

