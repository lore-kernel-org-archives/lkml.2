Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab1JZHfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 03:35:04 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:39265 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932262Ab1JZHe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 03:34:59 -0400
From: Tao Ma <tm@tao.ma>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, adilger@dilger.ca
Subject: [PATCH V1 05/17] ext4: Add journalled write support for inline data.
Date: Wed, 26 Oct 2011 15:34:16 +0800
Message-Id: <1319614468-11227-5-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319614468-11227-1-git-send-email-tm@tao.ma>
References: <4EA7B788.3040503@tao.ma>
 <1319614468-11227-1-git-send-email-tm@tao.ma>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inode.c |   81 ++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 63 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 876cdfd..bbd4b3c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1196,16 +1196,21 @@ static int ext4_journalled_write_end(struct file *file,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	if (copied < len) {
-		if (!PageUptodate(page))
-			copied = 0;
-		page_zero_new_buffers(page, from+copied, to);
-	}
+	if (ext4_has_inline_data(inode))
+		copied = ext4_write_inline_data_end(inode, pos, len,
+						    copied, page);
+	else {
+		if (copied < len) {
+			if (!PageUptodate(page))
+				copied = 0;
+			page_zero_new_buffers(page, from+copied, to);
+		}
 
-	ret = walk_page_buffers(handle, page_buffers(page), from,
-				to, &partial, write_end_fn);
-	if (!partial)
-		SetPageUptodate(page);
+		ret = walk_page_buffers(handle, page_buffers(page), from,
+					to, &partial, write_end_fn);
+		if (!partial)
+			SetPageUptodate(page);
+	}
 	new_i_size = pos + copied;
 	if (new_i_size > inode->i_size)
 		i_size_write(inode, pos+copied);
@@ -1893,20 +1898,50 @@ static int bput_one(handle_t *handle, struct buffer_head *bh)
 	return 0;
 }
 
+static struct buffer_head *
+ext4_journalled_write_inline_data(struct inode *inode,
+				  unsigned len,
+				  struct page *page)
+{
+	int ret;
+	void *kaddr;
+	struct ext4_iloc iloc;
+
+	ret = ext4_get_inode_loc(inode, &iloc);
+	if (ret) {
+		ext4_std_error(inode->i_sb, ret);
+		return NULL;
+	}
+
+	kaddr = kmap_atomic(page, KM_USER0);
+	ext4_write_inline_data(inode, &iloc, kaddr, 0, len);
+	kunmap_atomic(kaddr, KM_USER0);
+
+	return iloc.bh;
+}
+
 static int __ext4_journalled_writepage(struct page *page,
 				       unsigned int len)
 {
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
-	struct buffer_head *page_bufs;
+	struct buffer_head *page_bufs = NULL;
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
+	struct buffer_head *inode_bh = NULL;
 
 	ClearPageChecked(page);
-	page_bufs = page_buffers(page);
-	BUG_ON(!page_bufs);
-	walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
+
+	if (ext4_has_inline_data(inode)) {
+		BUG_ON(page->index != 0);
+		BUG_ON(len > ext4_get_max_inline_size(inode));
+		inode_bh = ext4_journalled_write_inline_data(inode, len, page);
+	} else {
+		page_bufs = page_buffers(page);
+		BUG_ON(!page_bufs);
+		walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
+	}
 	/* As soon as we unlock the page, it can go away, but we have
 	 * references to buffers so we are safe */
 	unlock_page(page);
@@ -1919,11 +1954,19 @@ static int __ext4_journalled_writepage(struct page *page,
 
 	BUG_ON(!ext4_handle_valid(handle));
 
-	ret = walk_page_buffers(handle, page_bufs, 0, len, NULL,
-				do_journal_get_write_access);
+	if (ext4_has_inline_data(inode) && inode_bh) {
+		ret = ext4_journal_get_write_access(handle, inode_bh);
+
+		err = ext4_handle_dirty_metadata(handle, inode, inode_bh);
+
+	} else {
+		ret = walk_page_buffers(handle, page_bufs, 0, len, NULL,
+					do_journal_get_write_access);
+
+		err = walk_page_buffers(handle, page_bufs, 0, len, NULL,
+					write_end_fn);
+	}
 
-	err = walk_page_buffers(handle, page_bufs, 0, len, NULL,
-				write_end_fn);
 	if (ret == 0)
 		ret = err;
 	EXT4_I(inode)->i_datasync_tid = handle->h_transaction->t_tid;
@@ -1931,9 +1974,11 @@ static int __ext4_journalled_writepage(struct page *page,
 	if (!ret)
 		ret = err;
 
-	walk_page_buffers(handle, page_bufs, 0, len, NULL, bput_one);
+	if (!ext4_has_inline_data(inode))
+		walk_page_buffers(handle, page_bufs, 0, len, NULL, bput_one);
 	ext4_set_inode_state(inode, EXT4_STATE_JDATA);
 out:
+	brelse(inode_bh);
 	return ret;
 }
 
-- 
1.7.0.4

