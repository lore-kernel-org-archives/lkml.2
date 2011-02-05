Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab1BERry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:47:54 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:35401 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1BERr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:47:26 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V2 16/17] fs/9p: Move writeback fid to v9fs_inode
Date: Sat,  5 Feb 2011 23:16:44 +0530
Message-Id: <1296928005-9529-17-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/v9fs.h           |    1 +
 fs/9p/vfs_addr.c       |   14 +++++++++-----
 fs/9p/vfs_file.c       |   12 ++++++++----
 fs/9p/vfs_inode.c      |   20 ++++++++++++--------
 fs/9p/vfs_inode_dotl.c |   16 +++++++++-------
 5 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index e852b20..aed2a25 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -118,6 +118,7 @@ struct v9fs_inode {
 	struct fscache_cookie *fscache;
 	struct p9_qid *fscache_key;
 #endif
+	struct p9_fid *writeback_fid;
 	struct inode vfs_inode;
 };
 
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 792c68a..8eecfa3 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -163,8 +163,10 @@ static int v9fs_vfs_writepage_locked(struct page *page)
 	int retval, len;
 	loff_t offset, size;
 	mm_segment_t old_fs;
+	struct v9fs_inode *v9inode;
 	struct inode *inode = page->mapping->host;
 
+	v9inode = V9FS_I(inode);
 	size = i_size_read(inode);
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
@@ -178,11 +180,11 @@ static int v9fs_vfs_writepage_locked(struct page *page)
 
 	old_fs = get_fs();
 	set_fs(get_ds());
-	/* We should have i_private always set */
-	BUG_ON(!inode->i_private);
+	/* We should have writeback_fid always set */
+	BUG_ON(!v9inode->writeback_fid);
 
 	retval = v9fs_file_write_internal(inode,
-					  (struct p9_fid *)inode->i_private,
+					  v9inode->writeback_fid,
 					  buffer, len, &offset, 0);
 	if (retval > 0)
 		retval = 0;
@@ -273,23 +275,25 @@ static int v9fs_write_begin(struct file *filp, struct address_space *mapping,
 {
 	int retval = 0;
 	struct page *page;
+	struct v9fs_inode *v9inode;
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 	struct inode *inode = mapping->host;
 
+	v9inode = V9FS_I(inode);
 start:
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
 		retval = -ENOMEM;
 		goto out;
 	}
-	BUG_ON(!inode->i_private);
+	BUG_ON(!v9inode->writeback_fid);
 	if (PageUptodate(page))
 		goto out;
 
 	if (len == PAGE_CACHE_SIZE)
 		goto out;
 
-	retval = v9fs_fid_readpage(inode->i_private, page);
+	retval = v9fs_fid_readpage(v9inode->writeback_fid, page);
 	page_cache_release(page);
 	if (!retval)
 		goto start;
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 6e38947..67f01bb 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -56,11 +56,13 @@ static const struct vm_operations_struct v9fs_file_vm_ops;
 int v9fs_file_open(struct inode *inode, struct file *file)
 {
 	int err;
+	struct v9fs_inode *v9inode;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid;
 	int omode;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "inode: %p file: %p\n", inode, file);
+	v9inode = V9FS_I(inode);
 	v9ses = v9fs_inode2v9ses(inode);
 	if (v9fs_proto_dotl(v9ses))
 		omode = file->f_flags;
@@ -95,9 +97,9 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 	 * mode so that a partial page write which result in page
 	 * read can work.
 	 */
-	if (v9ses->cache && !inode->i_private) {
+	if (v9ses->cache && !v9inode->writeback_fid) {
 		/*
-		 * clone a fid and add it to inode->i_private
+		 * clone a fid and add it to writeback_fid
 		 * we do it during open time instead of
 		 * page dirty time via write_begin/page_mkwrite
 		 * because we want write after unlink usecase
@@ -113,7 +115,7 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 			p9_client_clunk(fid);
 			goto out_error;
 		}
-		inode->i_private = (void *) fid;
+		v9inode->writeback_fid = (void *) fid;
 	}
 #ifdef CONFIG_9P_FSCACHE
 	if (v9ses->cache)
@@ -562,6 +564,7 @@ v9fs_file_mmap(struct file *file, struct vm_area_struct *vma)
 static int
 v9fs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
+	struct v9fs_inode *v9inode;
 	struct page *page = vmf->page;
 	struct file *filp = vma->vm_file;
 	struct inode *inode = filp->f_path.dentry->d_inode;
@@ -570,9 +573,10 @@ v9fs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	P9_DPRINTK(P9_DEBUG_VFS, "page %p fid %lx\n",
 		   page, (unsigned long)filp->private_data);
 
+	v9inode = V9FS_I(inode);
 	/* make sure the cache has finished storing the page */
 	v9fs_fscache_wait_on_page_write(inode, page);
-	BUG_ON(!inode->i_private);
+	BUG_ON(!v9inode->writeback_fid);
 	lock_page(page);
 	if (page->mapping != inode->i_mapping)
 		goto out_unlock;
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 2de196b..b68f116 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -413,6 +413,8 @@ error:
  */
 void v9fs_evict_inode(struct inode *inode)
 {
+	struct v9fs_inode *v9inode = V9FS_I(inode);
+
 	truncate_inode_pages(inode->i_mapping, 0);
 	end_writeback(inode);
 	filemap_fdatawrite(inode->i_mapping);
@@ -420,10 +422,10 @@ void v9fs_evict_inode(struct inode *inode)
 #ifdef CONFIG_9P_FSCACHE
 	v9fs_cache_inode_put_cookie(inode);
 #endif
-	/* clunk the fid stashed in inode->i_private */
-	if (inode->i_private) {
-		p9_client_clunk((struct p9_fid *)inode->i_private);
-		inode->i_private = 0;
+	/* clunk the fid stashed in writeback_fid */
+	if (v9inode->writeback_fid) {
+		p9_client_clunk(v9inode->writeback_fid);
+		v9inode->writeback_fid = 0;
 	}
 }
 
@@ -606,9 +608,10 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	int err;
 	u32 perm;
 	int flags;
+	struct file *filp;
+	struct v9fs_inode *v9inode;
 	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid, *inode_fid;
-	struct file *filp;
 
 	err = 0;
 	fid = NULL;
@@ -630,6 +633,7 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 
 	/* if we are opening a file, assign the open fid to the file */
 	if (nd && nd->flags & LOOKUP_OPEN) {
+		v9inode = V9FS_I(dentry->d_inode);
 		/*
 		 * In cached mode we need to attach a fid to inode. The fid
 		 * attached to inode will only be used to write back the
@@ -637,9 +641,9 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 		 * mode so that a partial page write which result in page
 		 * read can work.
 		 */
-		if (v9ses->cache && !dentry->d_inode->i_private) {
+		if (v9ses->cache && !v9inode->writeback_fid) {
 			/*
-			 * clone a fid and add it to inode->i_private
+			 * clone a fid and add it to writeback_fid
 			 * we do it during open time instead of
 			 * page dirty time via write_begin/page_mkwrite
 			 * because we want write after unlink usecase
@@ -655,7 +659,7 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 				p9_client_clunk(inode_fid);
 				goto error;
 			}
-			dentry->d_inode->i_private = (void *) inode_fid;
+			v9inode->writeback_fid = (void *) inode_fid;
 		}
 		filp = lookup_instantiate_filp(nd, dentry, generic_file_open);
 		if (IS_ERR(filp)) {
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 95da317..aebe532 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -159,16 +159,17 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 		struct nameidata *nd)
 {
 	int err = 0;
-	char *name = NULL;
 	gid_t gid;
 	int flags;
 	mode_t mode;
-	struct v9fs_session_info *v9ses;
-	struct p9_fid *fid = NULL;
-	struct p9_fid *dfid, *ofid, *inode_fid;
+	char *name = NULL;
 	struct file *filp;
 	struct p9_qid qid;
 	struct inode *inode;
+	struct p9_fid *fid = NULL;
+	struct v9fs_inode *v9inode;
+	struct p9_fid *dfid, *ofid, *inode_fid;
+	struct v9fs_session_info *v9ses;
 	struct posix_acl *pacl = NULL, *dacl = NULL;
 
 	v9ses = v9fs_inode2v9ses(dir);
@@ -248,9 +249,10 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 	 * mode so that a partial page write which result in page
 	 * read can work.
 	 */
-	if (v9ses->cache && !inode->i_private) {
+	v9inode = V9FS_I(inode);
+	if (v9ses->cache && !v9inode->writeback_fid) {
 		/*
-		 * clone a fid and add it to inode->i_private
+		 * clone a fid and add it to writeback_fid
 		 * we do it during open time instead of
 		 * page dirty time via write_begin/page_mkwrite
 		 * because we want write after unlink usecase
@@ -266,7 +268,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 			p9_client_clunk(inode_fid);
 			goto error;
 		}
-		inode->i_private = (void *) inode_fid;
+		v9inode->writeback_fid = (void *) inode_fid;
 	}
 	/* Since we are opening a file, assign the open fid to the file */
 	filp = lookup_instantiate_filp(nd, dentry, generic_file_open);
-- 
1.7.1

