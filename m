Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403Ab2JAXIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:08:54 -0400
Received: from 1wt.eu ([62.212.114.60]:35624 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933151Ab2JAXDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:03:01 -0400
Message-Id: <20121001225203.377100429@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:13 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 136/180] udf: Fix data corruption for files in ICB
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 9c2fc0de1a6e638fe58c354a463f544f42a90a09 upstream.

When a file is stored in ICB (inode), we overwrite part of the file, and
the page containing file's data is not in page cache, we end up corrupting
file's data by overwriting them with zeros. The problem is we use
simple_write_begin() which simply zeroes parts of the page which are not
written to. The problem has been introduced by be021ee4 (udf: convert to
new aops).

Fix the problem by providing a ->write_begin function which makes the page
properly uptodate.

Reported-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/udf/file.c |   35 +++++++++++++++++++++++++++++------
 1 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index b80cbd7..78bdef3 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -40,20 +40,24 @@
 #include "udf_i.h"
 #include "udf_sb.h"
 
-static int udf_adinicb_readpage(struct file *file, struct page *page)
+static void __udf_adinicb_readpage(struct page *page)
 {
 	struct inode *inode = page->mapping->host;
 	char *kaddr;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
-	BUG_ON(!PageLocked(page));
-
 	kaddr = kmap(page);
-	memset(kaddr, 0, PAGE_CACHE_SIZE);
 	memcpy(kaddr, iinfo->i_ext.i_data + iinfo->i_lenEAttr, inode->i_size);
+	memset(kaddr + inode->i_size, 0, PAGE_CACHE_SIZE - inode->i_size);
 	flush_dcache_page(page);
 	SetPageUptodate(page);
 	kunmap(page);
+}
+
+static int udf_adinicb_readpage(struct file *file, struct page *page)
+{
+	BUG_ON(!PageLocked(page));
+	__udf_adinicb_readpage(page);
 	unlock_page(page);
 
 	return 0;
@@ -78,6 +82,25 @@ static int udf_adinicb_writepage(struct page *page,
 	return 0;
 }
 
+static int udf_adinicb_write_begin(struct file *file,
+			struct address_space *mapping, loff_t pos,
+			unsigned len, unsigned flags, struct page **pagep,
+			void **fsdata)
+{
+	struct page *page;
+
+	if (WARN_ON_ONCE(pos >= PAGE_CACHE_SIZE))
+		return -EIO;
+	page = grab_cache_page_write_begin(mapping, 0, flags);
+	if (!page)
+		return -ENOMEM;
+	*pagep = page;
+
+	if (!PageUptodate(page) && len != PAGE_CACHE_SIZE)
+		__udf_adinicb_readpage(page);
+	return 0;
+}
+
 static int udf_adinicb_write_end(struct file *file,
 			struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
@@ -100,8 +123,8 @@ const struct address_space_operations udf_adinicb_aops = {
 	.readpage	= udf_adinicb_readpage,
 	.writepage	= udf_adinicb_writepage,
 	.sync_page	= block_sync_page,
-	.write_begin = simple_write_begin,
-	.write_end = udf_adinicb_write_end,
+	.write_begin	= udf_adinicb_write_begin,
+	.write_end	= udf_adinicb_write_end,
 };
 
 static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
-- 
1.7.2.1.45.g54fbc



