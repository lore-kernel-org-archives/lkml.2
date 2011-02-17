Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab1BQSCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:02:24 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37867 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1BQSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:20 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 02/14] fs/9p: Add direct IO support in cached mode
Date: Thu, 17 Feb 2011 23:31:53 +0530
Message-Id: <1297965725-25603-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/vfs_file.c |  118 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 114 insertions(+), 4 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index a56a33b..5de87e2 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -590,15 +590,125 @@ out_unlock:
 	return VM_FAULT_NOPAGE;
 }
 
+static ssize_t
+v9fs_direct_read(struct file *filp, char __user *udata, size_t count,
+		 loff_t *offsetp)
+{
+	loff_t size, offset;
+	struct inode *inode;
+	struct address_space *mapping;
+
+	offset = *offsetp;
+	mapping = filp->f_mapping;
+	inode = mapping->host;
+	if (!count)
+		return 0;
+	size = i_size_read(inode);
+	if (offset < size)
+		filemap_write_and_wait_range(mapping, offset,
+					     offset + count - 1);
+
+	return v9fs_file_read(filp, udata, count, offsetp);
+}
+
+/**
+ * v9fs_cached_file_read - read from a file
+ * @filp: file pointer to read
+ * @udata: user data buffer to read data into
+ * @count: size of buffer
+ * @offset: offset at which to read data
+ *
+ */
+static ssize_t
+v9fs_cached_file_read(struct file *filp, char __user *data, size_t count,
+		      loff_t *offset)
+{
+	if (filp->f_flags & O_DIRECT)
+		return v9fs_direct_read(filp, data, count, offset);
+	return do_sync_read(filp, data, count, offset);
+}
+
+static ssize_t
+v9fs_direct_write(struct file *filp, const char __user * data,
+		  size_t count, loff_t *offsetp)
+{
+	loff_t offset;
+	ssize_t retval;
+	struct inode *inode;
+	struct address_space *mapping;
+
+	offset = *offsetp;
+	mapping = filp->f_mapping;
+	inode = mapping->host;
+	if (!count)
+		return 0;
+
+	mutex_lock(&inode->i_mutex);
+	retval = filemap_write_and_wait_range(mapping, offset,
+					      offset + count - 1);
+	if (retval)
+		goto err_out;
+	/*
+	 * After a write we want buffered reads to be sure to go to disk to get
+	 * the new data.  We invalidate clean cached page from the region we're
+	 * about to write.  We do this *before* the write so that if we fail
+	 * here we fall back to buffered write
+	 */
+	if (mapping->nrpages) {
+		pgoff_t pg_start = offset >> PAGE_CACHE_SHIFT;
+		pgoff_t pg_end   = (offset + count - 1) >> PAGE_CACHE_SHIFT;
+
+		retval = invalidate_inode_pages2_range(mapping,
+							pg_start, pg_end);
+		/*
+		 * If a page can not be invalidated, return 0 to fall back
+		 * to buffered write.
+		 */
+		if (retval) {
+			if (retval == -EBUSY) {
+				retval = 0;
+				goto buff_write;
+			}
+			goto err_out;
+		}
+	}
+	retval = v9fs_file_write(filp, data, count, offsetp);
+err_out:
+	mutex_unlock(&inode->i_mutex);
+	return retval;
+
+buff_write:
+	return do_sync_write(filp, data, count, offsetp);
+}
+
+/**
+ * v9fs_cached_file_write - write to a file
+ * @filp: file pointer to write
+ * @data: data buffer to write data from
+ * @count: size of buffer
+ * @offset: offset at which to write data
+ *
+ */
+static ssize_t
+v9fs_cached_file_write(struct file *filp, const char __user * data,
+		       size_t count, loff_t *offset)
+{
+
+	if (filp->f_flags & O_DIRECT)
+		return v9fs_direct_write(filp, data, count, offset);
+	return do_sync_write(filp, data, count, offset);
+}
+
 static const struct vm_operations_struct v9fs_file_vm_ops = {
 	.fault = filemap_fault,
 	.page_mkwrite = v9fs_vm_page_mkwrite,
 };
 
+
 const struct file_operations v9fs_cached_file_operations = {
 	.llseek = generic_file_llseek,
-	.read = do_sync_read,
-	.write = do_sync_write,
+	.read = v9fs_cached_file_read,
+	.write = v9fs_cached_file_write,
 	.aio_read = generic_file_aio_read,
 	.aio_write = generic_file_aio_write,
 	.open = v9fs_file_open,
@@ -610,8 +720,8 @@ const struct file_operations v9fs_cached_file_operations = {
 
 const struct file_operations v9fs_cached_file_operations_dotl = {
 	.llseek = generic_file_llseek,
-	.read = do_sync_read,
-	.write = do_sync_write,
+	.read = v9fs_cached_file_read,
+	.write = v9fs_cached_file_write,
 	.aio_read = generic_file_aio_read,
 	.aio_write = generic_file_aio_write,
 	.open = v9fs_file_open,
-- 
1.7.1

