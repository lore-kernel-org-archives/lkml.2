Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2IQA7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:59:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33896 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753196Ab2IQAvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:21 -0400
Message-Id: <20120917003632.057232218@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 042/135] udf: Fix data corruption for files in ICB
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/udf/file.c |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 7f3f7ba..d1c6093 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -39,20 +39,24 @@
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
@@ -77,6 +81,25 @@ static int udf_adinicb_writepage(struct page *page,
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
@@ -98,8 +121,8 @@ static int udf_adinicb_write_end(struct file *file,
 const struct address_space_operations udf_adinicb_aops = {
 	.readpage	= udf_adinicb_readpage,
 	.writepage	= udf_adinicb_writepage,
-	.write_begin = simple_write_begin,
-	.write_end = udf_adinicb_write_end,
+	.write_begin	= udf_adinicb_write_begin,
+	.write_end	= udf_adinicb_write_end,
 };
 
 static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,


