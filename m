Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab2ASJb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 04:31:59 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:56641 "HELO nudt.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756325Ab2ASJbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 04:31:55 -0500
Date: Thu, 19 Jan 2012 17:19:20 +0800
From: "Li Wang" <liwang@nudt.edu.cn>
Subject: [PATCH] eCryptfs: truncate optimization (sometimes upto 25000x fa
 ster)
To: dustin.kirkland@gazzang.com, torvalds@linux-foundation.org,
        ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Dustin Kirkland" <kirkland@canonical.com>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        "Tyler Hicks" <tyhicks@canonical.com>, john.johansen@canonical.com,
        akpm@linux-foundation.org
Message-Id: <1201191719207c1a8e2a0d7a3f1e88c2fb8597295f6d@nudt.edu.cn>
MIME-Version: 1.0
X-Mailer: eYou WebMail 5.0.3
X-Eyou-Client: 119.39.21.16
Content-Type: text/plain;
 charset="GBK"
X-Eyou-Sender: <liwang@nudt.edu.cn>
X-Eyou-MID: <1eb27cd6aea6df7a8f7c6c9629c88c68>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0J9WAqL029922

Hi,
Many modern disk-based file systems, such as ext4,
have the truncate optimization feature, kind of delayed allocation, that is, 
when using 'truncate' to produce a big empty file, the file system will not 
allocate disk space until real data are written into, as a result, 
the execution of truncate is very fast and the disk space are saved. 
However, for eCryptfs, it will actually create a equal-size file, and write zeroes into it, 
which results in the allocation of disk space and slow disk write operations. 
Since eCryptfs does not record hole information on disk, therefore, 
when read out a page of zeroes, eCryptfs can not distinguish actual data 
(encrypted data happened to be whole zeroes) from hole, 
therefore, eCryptfs can not rely on the lower file system specific truncate implementation.
However, there is one thing eCryptfs can do is that eCryptfs does record file size itself
on the disk, so that it could be aware of the hole at the end of the file. 
The natural optimization is, while truncate to expand a file to exceed the original size 
(which occurs in many cases while doing truncate), 
record the actual file size (after expansion) in the eCryptfs metadata, 
keep the original size unchanged in the lower file system. 
When reading, if the file size seen from eCryptfs is bigger than from 
the lower file system side, it must contain a hole at the end of the file, 
eCryptfs just return zeroes for that part of data, no disk operations at all, 
and return them to user application, which casues an extremely fast truncation operation. 
For example, we mount eCryptfs on top of ext4, run the following command 
'truncate -s 4G dummy', for the original version, it takes eCryptfs 100 seconds 
to finish, after our optimization, it takes only 4 miro-second, brings a 25000x speedup.
The patch below implements the method mentioned above.

BTW: thanks Tyler to warmly remind us regarding the patch format,
we will follow the rules later to submit the patch. For this truncate optimization issue, 
we think it better to first post the idea to undergo discussions, for the final code,
we will make them strictly follow the kernel patch rule.

Cheers,
Li Wang

Signed-off-by: Li Wang <liwang@nudt.edu.cn>
               Yunchuan Wen <wenyunchuan@kylinos.com.cn>

---
  
diff -prNu a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
--- a/fs/ecryptfs/crypto.c	2012-01-19 15:30:25.656858654 +0800
+++ b/fs/ecryptfs/crypto.c	2012-01-19 16:59:11.492281195 +0800
@@ -515,6 +515,7 @@ int ecryptfs_encrypt_page(struct page *p
 			goto out;
 		}
 	}
+	SetPageMappedToDisk(page);
 	rc = 0;
 out:
 	if (enc_extent_page) {
@@ -599,11 +600,14 @@ out:
  */
 int ecryptfs_decrypt_page(struct page *page)
 {
+	loff_t offset;
 	struct inode *ecryptfs_inode;
 	struct ecryptfs_crypt_stat *crypt_stat;
 	char *enc_extent_virt;
 	struct page *enc_extent_page = NULL;
 	unsigned long extent_offset;
+	unsigned long extent_offset_max;
+	unsigned long zero_nums;
 	int rc = 0;
 
 	ecryptfs_inode = page->mapping->host;
@@ -618,24 +622,39 @@ int ecryptfs_decrypt_page(struct page *p
 		goto out;
 	}
 	enc_extent_virt = kmap(enc_extent_page);
+
+	ecryptfs_lower_offset_for_extent(
+		&offset, ((page->index * (PAGE_CACHE_SIZE
+					  / crypt_stat->extent_size))
+			  ), crypt_stat);
+	rc = ecryptfs_read_lower(enc_extent_virt, offset,
+				 PAGE_CACHE_SIZE,
+				 ecryptfs_inode);
+	if (rc < 0) {
+		ecryptfs_printk(KERN_ERR, "Error attempting "
+				"to read lower page; rc = [%d]"
+				"\n", rc);
+		goto out;
+	}
+
+	extent_offset_max = (rc + crypt_stat->extent_size - 1) /
+		crypt_stat->extent_size;
+	zero_nums = PAGE_CACHE_SIZE 
+		- extent_offset_max * crypt_stat->extent_size;
+
+	if (zero_nums != 0) {
+		char *address = kmap(page);
+		address += PAGE_CACHE_SIZE - zero_nums;
+		memset(address, 0, zero_nums);
+		kunmap(page);
+	}
+	
+	if (extent_offset_max == 0)
+		goto out;
+
 	for (extent_offset = 0;
-	     extent_offset < (PAGE_CACHE_SIZE / crypt_stat->extent_size);
+	     extent_offset < extent_offset_max;
 	     extent_offset++) {
-		loff_t offset;
-
-		ecryptfs_lower_offset_for_extent(
-			&offset, ((page->index * (PAGE_CACHE_SIZE
-						  / crypt_stat->extent_size))
-				  + extent_offset), crypt_stat);
-		rc = ecryptfs_read_lower(enc_extent_virt, offset,
-					 crypt_stat->extent_size,
-					 ecryptfs_inode);
-		if (rc < 0) {
-			ecryptfs_printk(KERN_ERR, "Error attempting "
-					"to read lower page; rc = [%d]"
-					"\n", rc);
-			goto out;
-		}
 		rc = ecryptfs_decrypt_extent(page, crypt_stat, enc_extent_page,
 					     extent_offset);
 		if (rc) {
@@ -644,6 +663,7 @@ int ecryptfs_decrypt_page(struct page *p
 			goto out;
 		}
 	}
+	SetPageMappedToDisk(page);
 out:
 	if (enc_extent_page) {
 		kunmap(enc_extent_page);
diff -prNu a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c	2012-01-19 15:30:25.657858641 +0800
+++ b/fs/ecryptfs/inode.c	2012-01-19 15:35:58.822693506 +0800
@@ -811,6 +811,7 @@ static int truncate_upper(struct dentry
 	struct inode *inode = dentry->d_inode;
 	struct ecryptfs_crypt_stat *crypt_stat;
 	loff_t i_size = i_size_read(inode);
+	loff_t i_lower_size;
 	loff_t lower_size_before_truncate;
 	loff_t lower_size_after_truncate;
 
@@ -822,8 +823,26 @@ static int truncate_upper(struct dentry
 	if (rc)
 		return rc;
 	crypt_stat = &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
+	i_lower_size = i_size_read(ecryptfs_inode_to_lower(inode)) 
+		- ecryptfs_lower_header_size(crypt_stat);
 	/* Switch on growing or shrinking file */
-	if (ia->ia_size > i_size) {
+	if (ia->ia_size > i_lower_size) {
+		if (crypt_stat->flags & ECRYPTFS_ENCRYPTED) {
+			truncate_setsize(inode, ia->ia_size);
+			lower_ia->ia_valid &= ~ATTR_SIZE;
+			rc = ecryptfs_write_inode_size_to_metadata(inode);
+			if (rc) {
+				printk(KERN_ERR	"Problem with "
+				       "ecryptfs_write_inode_size_to_metadata; "
+					   "rc = [%d]\n", rc);
+				goto out;
+			}
+		} else {
+			truncate_setsize(inode, ia->ia_size);
+			lower_ia->ia_size = ia->ia_size;
+			lower_ia->ia_valid |= ATTR_SIZE;
+		}
+	} else if (ia->ia_size > i_size) {
 		char zero[] = { 0x00 };
 
 		lower_ia->ia_valid &= ~ATTR_SIZE;
@@ -832,7 +851,7 @@ static int truncate_upper(struct dentry
 		 * the intermediate portion of the previous end of the
 		 * file and the new and of the file */
 		rc = ecryptfs_write(inode, zero,
-				    (ia->ia_size - 1), 1);
+					(ia->ia_size - 1), 1);
 	} else { /* ia->ia_size < i_size_read(inode) */
 		/* We're chopping off all the pages down to the page
 		 * in which ia->ia_size is located. Fill in the end of
diff -prNu a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
--- a/fs/ecryptfs/mmap.c	2011-10-24 15:10:05.000000000 +0800
+++ b/fs/ecryptfs/mmap.c	2012-01-19 15:36:02.119652666 +0800
@@ -52,6 +52,39 @@ struct page *ecryptfs_get_locked_page(st
 	return page;
 }
 
+static int ecryptfs_fill_hole(struct inode *inode, pgoff_t end)
+{
+	pgoff_t index;
+	int rc = 0;
+	struct inode *lower_inode;
+	struct ecryptfs_crypt_stat *crypt_stat;
+
+	lower_inode = ecryptfs_inode_to_lower(inode);
+	crypt_stat = &ecryptfs_inode_to_private(inode)->crypt_stat;
+
+	index = (i_size_read(lower_inode) - ecryptfs_lower_header_size(crypt_stat))
+		>> PAGE_CACHE_SHIFT;
+
+	while (index <= end) {
+		struct page *page = ecryptfs_get_locked_page(inode, index);
+		if (unlikely(IS_ERR(page))) {
+			rc = PTR_ERR(page);
+			goto out;
+		}
+		if (!PageMappedToDisk(page))
+			rc = ecryptfs_encrypt_page(page);
+		else
+			rc = 0;
+		unlock_page(page);
+		page_cache_release(page);
+		if (unlikely(rc))
+			goto out;
+		++index;
+	}
+out:
+	return rc;
+}
+
 /**
  * ecryptfs_writepage
  * @page: Page that is locked before this call is made
@@ -74,6 +107,14 @@ static int ecryptfs_writepage(struct pag
 		goto out;
 	}
 
+	if (page->index > 0) {
+		rc = ecryptfs_fill_hole(page->mapping->host, page->index - 1);
+		if (rc) {
+			ClearPageUptodate(page);
+			goto out;
+		}
+	}
+
 	rc = ecryptfs_encrypt_page(page);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "Error encrypting "
diff -prNu a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
--- a/fs/ecryptfs/read_write.c	2011-10-24 15:10:05.000000000 +0800
+++ b/fs/ecryptfs/read_write.c	2012-01-19 15:36:02.118652694 +0800
@@ -177,7 +177,6 @@ int ecryptfs_write(struct inode *ecryptf
 		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
 		flush_dcache_page(ecryptfs_page);
 		SetPageUptodate(ecryptfs_page);
-		unlock_page(ecryptfs_page);
 		if (crypt_stat->flags & ECRYPTFS_ENCRYPTED)
 			rc = ecryptfs_encrypt_page(ecryptfs_page);
 		else
@@ -185,6 +184,7 @@ int ecryptfs_write(struct inode *ecryptf
 						ecryptfs_page,
 						start_offset_in_page,
 						data_offset);
+		unlock_page(ecryptfs_page);
 		page_cache_release(ecryptfs_page);
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting "
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
