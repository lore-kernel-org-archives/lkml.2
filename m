Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab2GXMRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 08:17:20 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:50872 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763Ab2GXMRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 08:17:19 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: lkml <linux-kernel@vger.kernel.org>
CC: Jan Kara <jack@suze.cz>, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH] UDF: Add support for O_DIRECT
Date: Tue, 24 Jul 2012 13:17:06 +0100
Message-ID: <1343132226-3806-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.7.8.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the O_DIRECT flag.  There are two cases to deal with:

1. Small files stored in the ICB (inode control block?): just return 0
from the new udf_adinicb_direct_IO() handler to fall back to buffered
I/O.  For direct writes, there is a "gotcha" to deal with when
generic_file_direct_write() in mm/filemap.c invalidates the pages.  In
the udf_adinicb_writepage() handler, only part of the page data will be
valid and the rest will be zeroed out, so only copy the valid part into
the ICB.  (This is actually a bit inefficient as udf_adinicb_write_end()
will have already copied the data into the ICB once, but it's pretty
likely that the file will grow to the point where its data can no longer
be stored in the ICB and will be moved to a different area of the file
system.  At that point, a different direct_IO handler will be used - see
below.)

2. Larger files, not stored in the ICB: nothing special here.  Just call
blockdev_direct_IO() from our new udf_direct_IO() handler and tidy up
any blocks instantiated outside i_size on error.  This is pretty
standard.

Also change the whitespace in udf_aops and udf_adinicb_aops to make them
a bit neater.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 fs/udf/file.c  |   29 +++++++++++++++++++++++++----
 fs/udf/inode.c |   31 +++++++++++++++++++++++++++++--
 2 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 7f3f7ba..f5f9ddd 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -34,6 +34,7 @@
 #include <linux/errno.h>
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
+#include <linux/writeback.h>
 #include <linux/aio.h>
 
 #include "udf_i.h"
@@ -64,12 +65,23 @@ static int udf_adinicb_writepage(struct page *page,
 	struct inode *inode = page->mapping->host;
 	char *kaddr;
 	struct udf_inode_info *iinfo = UDF_I(inode);
+	loff_t start, end, page_start, page_offset;
 
 	BUG_ON(!PageLocked(page));
 
 	kaddr = kmap(page);
-	memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr, kaddr, inode->i_size);
-	mark_inode_dirty(inode);
+	/* The beginning and/or end of the page data is likely to be invalid
+	 * for O_DIRECT, so only copy the valid part. */
+	page_start = (loff_t)page->index << PAGE_CACHE_SHIFT;
+	start = max(page_start, wbc->range_start);
+	end = min3(page_start + (loff_t)PAGE_CACHE_SIZE - 1,
+		   wbc->range_end, inode->i_size - 1);
+	if (likely(start <= end)) {
+		page_offset = start - page_start;
+		memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr + start,
+		       kaddr + page_offset, (end + 1 - start));
+		mark_inode_dirty(inode);
+	}
 	SetPageUptodate(page);
 	kunmap(page);
 	unlock_page(page);
@@ -95,11 +107,20 @@ static int udf_adinicb_write_end(struct file *file,
 	return simple_write_end(file, mapping, pos, len, copied, page, fsdata);
 }
 
+static ssize_t udf_adinicb_direct_IO(int rw, struct kiocb *iocb,
+				     const struct iovec *iov,
+				     loff_t offset, unsigned long nr_segs)
+{
+	/* Fallback to buffered I/O. */
+	return 0;
+}
+
 const struct address_space_operations udf_adinicb_aops = {
 	.readpage	= udf_adinicb_readpage,
 	.writepage	= udf_adinicb_writepage,
-	.write_begin = simple_write_begin,
-	.write_end = udf_adinicb_write_end,
+	.write_begin	= simple_write_begin,
+	.write_end	= udf_adinicb_write_end,
+	.direct_IO	= udf_adinicb_direct_IO,
 };
 
 static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index fafaad7..5efad41 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -136,6 +136,32 @@ static int udf_write_begin(struct file *file, struct address_space *mapping,
 	return ret;
 }
 
+static ssize_t udf_direct_IO(int rw, struct kiocb *iocb,
+			     const struct iovec *iov,
+			     loff_t offset, unsigned long nr_segs)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file->f_path.dentry->d_inode;
+	ssize_t ret;
+
+	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+				  udf_get_block);
+
+	/*
+	 * In case of error extending write may have instantiated a few
+	 * blocks outside i_size. Trim these off again.
+	 */
+	if (unlikely((rw & WRITE) && ret < 0)) {
+		loff_t isize = i_size_read(inode);
+		loff_t end = offset + iov_length(iov, nr_segs);
+
+		if (end > isize)
+			vmtruncate(inode, isize);
+	}
+
+	return ret;
+}
+
 static sector_t udf_bmap(struct address_space *mapping, sector_t block)
 {
 	return generic_block_bmap(mapping, block, udf_get_block);
@@ -145,8 +171,9 @@ const struct address_space_operations udf_aops = {
 	.readpage	= udf_readpage,
 	.readpages	= udf_readpages,
 	.writepage	= udf_writepage,
-	.write_begin		= udf_write_begin,
-	.write_end		= generic_write_end,
+	.write_begin	= udf_write_begin,
+	.write_end	= generic_write_end,
+	.direct_IO	= udf_direct_IO,
 	.bmap		= udf_bmap,
 };
 
-- 
1.7.8.6

