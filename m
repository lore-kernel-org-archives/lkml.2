Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab2ILXgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:36:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601Ab2ILXgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:36:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Ian Abbott <abbotti@mev.co.uk>,
        Jan Kara <jack@suse.cz>
Subject: [ 090/108] udf: Fix data corruption for files in ICB
Date: Wed, 12 Sep 2012 16:29:28 -0700
Message-Id: <20120912232459.933773883@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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

---
 fs/udf/file.c |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

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
@@ -77,6 +81,25 @@ static int udf_adinicb_writepage(struct
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
@@ -98,8 +121,8 @@ static int udf_adinicb_write_end(struct
 const struct address_space_operations udf_adinicb_aops = {
 	.readpage	= udf_adinicb_readpage,
 	.writepage	= udf_adinicb_writepage,
-	.write_begin = simple_write_begin,
-	.write_end = udf_adinicb_write_end,
+	.write_begin	= udf_adinicb_write_begin,
+	.write_end	= udf_adinicb_write_end,
 };
 
 static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,


