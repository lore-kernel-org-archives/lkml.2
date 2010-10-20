Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab0JTUXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:23:53 -0400
Received: from BERING.ISR.CS.CMU.EDU ([128.2.209.223]:44648 "EHLO
	bering.isr.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788Ab0JTUXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:23:51 -0400
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de,
        Yoshihisa Abe <yoshiabe@cs.cmu.edu>, Jan Harkes <jaharkes@cs.cmu.edu>
Subject: [RFC][PATCH 2/3] Coda: push BKL regions into coda_upcall()
Date: Wed, 20 Oct 2010 16:23:03 -0400
Message-Id: <1287606184-26889-3-git-send-email-jaharkes@cs.cmu.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1287606184-26889-1-git-send-email-jaharkes@cs.cmu.edu>
References: <1287606184-26889-1-git-send-email-jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yoshihisa Abe <yoshiabe@cs.cmu.edu>

Now that shared inode state is locked using the cii->c_lock, the BKL is
only used to protect the upcall queues used to communicate with the
userspace cache manager. The remaining state is all local and we can
push the lock further down into coda_upcall().

Signed-off-by: Yoshihisa Abe <yoshiabe@cs.cmu.edu>
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
---
 fs/coda/dir.c     |  152 +++++++++++++++--------------------------------------
 fs/coda/file.c    |   19 +------
 fs/coda/inode.c   |   11 +----
 fs/coda/pioctl.c  |   22 ++------
 fs/coda/psdev.c   |    2 -
 fs/coda/symlink.c |    3 -
 fs/coda/upcall.c  |   17 ++++--
 7 files changed, 65 insertions(+), 161 deletions(-)

diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index 69fbbea..8cc6c61 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -17,7 +17,6 @@
 #include <linux/stat.h>
 #include <linux/errno.h>
 #include <linux/string.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 
 #include <asm/uaccess.h>
@@ -117,15 +116,11 @@ static struct dentry *coda_lookup(struct inode *dir, struct dentry *entry, struc
 		goto exit;
 	}
 
-	lock_kernel();
-
 	error = venus_lookup(dir->i_sb, coda_i2f(dir), name, length,
 			     &type, &resfid);
 	if (!error)
 		error = coda_cnode_make(&inode, &resfid, dir->i_sb);
 
-	unlock_kernel();
-
 	if (error && error != -ENOENT)
 		return ERR_PTR(error);
 
@@ -141,28 +136,24 @@ exit:
 
 int coda_permission(struct inode *inode, int mask)
 {
-        int error = 0;
+	int error;
 
 	mask &= MAY_READ | MAY_WRITE | MAY_EXEC;
  
 	if (!mask)
-		return 0; 
+		return 0;
 
 	if ((mask & MAY_EXEC) && !execute_ok(inode))
 		return -EACCES;
 
-	lock_kernel();
-
 	if (coda_cache_check(inode, mask))
-		goto out; 
+		return 0;
 
         error = venus_access(inode->i_sb, coda_i2f(inode), mask);
     
 	if (!error)
 		coda_cache_enter(inode, mask);
 
- out:
-	unlock_kernel();
 	return error;
 }
 
@@ -201,41 +192,34 @@ static inline void coda_dir_drop_nlink(struct inode *dir)
 /* creation routines: create, mknod, mkdir, link, symlink */
 static int coda_create(struct inode *dir, struct dentry *de, int mode, struct nameidata *nd)
 {
-        int error=0;
+	int error;
 	const char *name=de->d_name.name;
 	int length=de->d_name.len;
 	struct inode *inode;
 	struct CodaFid newfid;
 	struct coda_vattr attrs;
 
-	lock_kernel();
-
-	if (coda_isroot(dir) && coda_iscontrol(name, length)) {
-		unlock_kernel();
+	if (coda_isroot(dir) && coda_iscontrol(name, length))
 		return -EPERM;
-	}
 
 	error = venus_create(dir->i_sb, coda_i2f(dir), name, length, 
 				0, mode, &newfid, &attrs);
-
-        if ( error ) {
-		unlock_kernel();
-		d_drop(de);
-		return error;
-	}
+	if (error)
+		goto err_out;
 
 	inode = coda_iget(dir->i_sb, &newfid, &attrs);
-	if ( IS_ERR(inode) ) {
-		unlock_kernel();
-		d_drop(de);
-		return PTR_ERR(inode);
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
+		goto err_out;
 	}
 
 	/* invalidate the directory cnode's attributes */
 	coda_dir_update_mtime(dir);
-	unlock_kernel();
 	d_instantiate(de, inode);
 	return 0;
+err_out:
+	d_drop(de);
+	return error;
 }
 
 static int coda_mkdir(struct inode *dir, struct dentry *de, int mode)
@@ -247,36 +231,29 @@ static int coda_mkdir(struct inode *dir, struct dentry *de, int mode)
 	int error;
 	struct CodaFid newfid;
 
-	lock_kernel();
-
-	if (coda_isroot(dir) && coda_iscontrol(name, len)) {
-		unlock_kernel();
+	if (coda_isroot(dir) && coda_iscontrol(name, len))
 		return -EPERM;
-	}
 
 	attrs.va_mode = mode;
 	error = venus_mkdir(dir->i_sb, coda_i2f(dir), 
 			       name, len, &newfid, &attrs);
-        
-        if ( error ) {
-		unlock_kernel();
-		d_drop(de);
-		return error;
-        }
+	if (error)
+		goto err_out;
          
 	inode = coda_iget(dir->i_sb, &newfid, &attrs);
-	if ( IS_ERR(inode) ) {
-		unlock_kernel();
-		d_drop(de);
-		return PTR_ERR(inode);
+	if (IS_ERR(inode)) {
+		error = PTR_ERR(inode);
+		goto err_out;
 	}
 
 	/* invalidate the directory cnode's attributes */
 	coda_dir_inc_nlink(dir);
 	coda_dir_update_mtime(dir);
-	unlock_kernel();
 	d_instantiate(de, inode);
 	return 0;
+err_out:
+	d_drop(de);
+	return error;
 }
 
 /* try to make de an entry in dir_inodde linked to source_de */ 
@@ -288,52 +265,39 @@ static int coda_link(struct dentry *source_de, struct inode *dir_inode,
 	int len = de->d_name.len;
 	int error;
 
-	lock_kernel();
-
-	if (coda_isroot(dir_inode) && coda_iscontrol(name, len)) {
-		unlock_kernel();
+	if (coda_isroot(dir_inode) && coda_iscontrol(name, len))
 		return -EPERM;
-	}
 
 	error = venus_link(dir_inode->i_sb, coda_i2f(inode),
 			   coda_i2f(dir_inode), (const char *)name, len);
 
 	if (error) {
 		d_drop(de);
-		goto out;
+		return error;
 	}
 
 	coda_dir_update_mtime(dir_inode);
 	atomic_inc(&inode->i_count);
 	d_instantiate(de, inode);
 	inc_nlink(inode);
-
-out:
-	unlock_kernel();
-	return(error);
+	return 0;
 }
 
 
 static int coda_symlink(struct inode *dir_inode, struct dentry *de,
 			const char *symname)
 {
-        const char *name = de->d_name.name;
+	const char *name = de->d_name.name;
 	int len = de->d_name.len;
 	int symlen;
-	int error = 0;
-
-	lock_kernel();
+	int error;
 
-	if (coda_isroot(dir_inode) && coda_iscontrol(name, len)) {
-		unlock_kernel();
+	if (coda_isroot(dir_inode) && coda_iscontrol(name, len))
 		return -EPERM;
-	}
 
 	symlen = strlen(symname);
-	if ( symlen > CODA_MAXPATHLEN ) {
-		unlock_kernel();
+	if (symlen > CODA_MAXPATHLEN)
 		return -ENAMETOOLONG;
-	}
 
 	/*
 	 * This entry is now negative. Since we do not create
@@ -344,10 +308,9 @@ static int coda_symlink(struct inode *dir_inode, struct dentry *de,
 			      symname, symlen);
 
 	/* mtime is no good anymore */
-	if ( !error )
+	if (!error)
 		coda_dir_update_mtime(dir_inode);
 
-	unlock_kernel();
 	return error;
 }
 
@@ -358,17 +321,12 @@ static int coda_unlink(struct inode *dir, struct dentry *de)
 	const char *name = de->d_name.name;
 	int len = de->d_name.len;
 
-	lock_kernel();
-
 	error = venus_remove(dir->i_sb, coda_i2f(dir), name, len);
-	if ( error ) {
-		unlock_kernel();
+	if (error)
 		return error;
-	}
 
 	coda_dir_update_mtime(dir);
 	drop_nlink(de->d_inode);
-	unlock_kernel();
 	return 0;
 }
 
@@ -378,8 +336,6 @@ static int coda_rmdir(struct inode *dir, struct dentry *de)
 	int len = de->d_name.len;
 	int error;
 
-	lock_kernel();
-
 	error = venus_rmdir(dir->i_sb, coda_i2f(dir), name, len);
 	if (!error) {
 		/* VFS may delete the child */
@@ -390,7 +346,6 @@ static int coda_rmdir(struct inode *dir, struct dentry *de)
 		coda_dir_drop_nlink(dir);
 		coda_dir_update_mtime(dir);
 	}
-	unlock_kernel();
 	return error;
 }
 
@@ -404,14 +359,11 @@ static int coda_rename(struct inode *old_dir, struct dentry *old_dentry,
 	int new_length = new_dentry->d_name.len;
 	int error;
 
-	lock_kernel();
-
 	error = venus_rename(old_dir->i_sb, coda_i2f(old_dir),
 			     coda_i2f(new_dir), old_length, new_length,
 			     (const char *) old_name, (const char *)new_name);
-
-	if ( !error ) {
-		if ( new_dentry->d_inode ) {
+	if (!error) {
+		if (new_dentry->d_inode) {
 			if ( S_ISDIR(new_dentry->d_inode->i_mode) ) {
 				coda_dir_drop_nlink(old_dir);
 				coda_dir_inc_nlink(new_dir);
@@ -424,7 +376,6 @@ static int coda_rename(struct inode *old_dir, struct dentry *old_dentry,
 			coda_flag_inode(new_dir, C_VATTR);
 		}
 	}
-	unlock_kernel();
 
 	return error;
 }
@@ -595,17 +546,14 @@ static int coda_dentry_revalidate(struct dentry *de, struct nameidata *nd)
 	struct inode *inode = de->d_inode;
 	struct coda_inode_info *cii;
 
-	if (!inode)
+	if (!inode || coda_isroot(inode))
 		return 1;
-	lock_kernel();
-	if (coda_isroot(inode))
-		goto out;
 	if (is_bad_inode(inode))
-		goto bad;
+		return 0;
 
 	cii = ITOC(de->d_inode);
 	if (!(cii->c_flags & (C_PURGE | C_FLUSH)))
-		goto out;
+		return 1;
 
 	shrink_dcache_parent(de);
 
@@ -615,19 +563,13 @@ static int coda_dentry_revalidate(struct dentry *de, struct nameidata *nd)
 
 	if (atomic_read(&de->d_count) > 1)
 		/* pretend it's valid, but don't change the flags */
-		goto out;
+		return 1;
 
 	/* clear the flags. */
 	spin_lock(&cii->c_lock);
 	cii->c_flags &= ~(C_VATTR | C_PURGE | C_FLUSH);
 	spin_unlock(&cii->c_lock);
-
-bad:
-	unlock_kernel();
 	return 0;
-out:
-	unlock_kernel();
-	return 1;
 }
 
 /*
@@ -659,20 +601,19 @@ static int coda_dentry_delete(struct dentry * dentry)
 int coda_revalidate_inode(struct dentry *dentry)
 {
 	struct coda_vattr attr;
-	int error = 0;
+	int error;
 	int old_mode;
 	ino_t old_ino;
 	struct inode *inode = dentry->d_inode;
 	struct coda_inode_info *cii = ITOC(inode);
 
-	lock_kernel();
-	if ( !cii->c_flags )
-		goto ok;
+	if (!cii->c_flags)
+		return 0;
 
 	if (cii->c_flags & (C_VATTR | C_PURGE | C_FLUSH)) {
 		error = venus_getattr(inode->i_sb, &(cii->c_fid), &attr);
-		if ( error )
-			goto return_bad;
+		if (error)
+			return -EIO;
 
 		/* this inode may be lost if:
 		   - it's ino changed 
@@ -691,7 +632,7 @@ int coda_revalidate_inode(struct dentry *dentry)
 		/* the following can happen when a local fid is replaced 
 		   with a global one, here we lose and declare the inode bad */
 		if (inode->i_ino != old_ino)
-			goto return_bad;
+			return -EIO;
 		
 		coda_flag_inode_children(inode, C_FLUSH);
 
@@ -699,12 +640,5 @@ int coda_revalidate_inode(struct dentry *dentry)
 		cii->c_flags &= ~(C_VATTR | C_PURGE | C_FLUSH);
 		spin_unlock(&cii->c_lock);
 	}
-
-ok:
-	unlock_kernel();
 	return 0;
-
-return_bad:
-	unlock_kernel();
-	return -EIO;
 }
diff --git a/fs/coda/file.c b/fs/coda/file.c
index c4e3957..c8b50ba 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -15,7 +15,6 @@
 #include <linux/stat.h>
 #include <linux/cred.h>
 #include <linux/errno.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/slab.h>
@@ -144,8 +143,6 @@ int coda_open(struct inode *coda_inode, struct file *coda_file)
 	if (!cfi)
 		return -ENOMEM;
 
-	lock_kernel();
-
 	error = venus_open(coda_inode->i_sb, coda_i2f(coda_inode), coda_flags,
 			   &host_file);
 	if (!host_file)
@@ -153,7 +150,6 @@ int coda_open(struct inode *coda_inode, struct file *coda_file)
 
 	if (error) {
 		kfree(cfi);
-		unlock_kernel();
 		return error;
 	}
 
@@ -165,8 +161,6 @@ int coda_open(struct inode *coda_inode, struct file *coda_file)
 
 	BUG_ON(coda_file->private_data != NULL);
 	coda_file->private_data = cfi;
-
-	unlock_kernel();
 	return 0;
 }
 
@@ -177,9 +171,7 @@ int coda_release(struct inode *coda_inode, struct file *coda_file)
 	struct coda_file_info *cfi;
 	struct coda_inode_info *cii;
 	struct inode *host_inode;
-	int err = 0;
-
-	lock_kernel();
+	int err;
 
 	cfi = CODA_FTOC(coda_file);
 	BUG_ON(!cfi || cfi->cfi_magic != CODA_MAGIC);
@@ -203,8 +195,6 @@ int coda_release(struct inode *coda_inode, struct file *coda_file)
 	kfree(coda_file->private_data);
 	coda_file->private_data = NULL;
 
-	unlock_kernel();
-
 	/* VFS fput ignores the return value from file_operations->release, so
 	 * there is no use returning an error here */
 	return 0;
@@ -215,7 +205,7 @@ int coda_fsync(struct file *coda_file, int datasync)
 	struct file *host_file;
 	struct inode *coda_inode = coda_file->f_path.dentry->d_inode;
 	struct coda_file_info *cfi;
-	int err = 0;
+	int err;
 
 	if (!(S_ISREG(coda_inode->i_mode) || S_ISDIR(coda_inode->i_mode) ||
 	      S_ISLNK(coda_inode->i_mode)))
@@ -226,11 +216,8 @@ int coda_fsync(struct file *coda_file, int datasync)
 	host_file = cfi->cfi_container;
 
 	err = vfs_fsync(host_file, datasync);
-	if ( !err && !datasync ) {
-		lock_kernel();
+	if (!err && !datasync)
 		err = venus_fsync(coda_inode->i_sb, coda_i2f(coda_inode));
-		unlock_kernel();
-	}
 
 	return err;
 }
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index f4ca79d..d287bed 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -15,7 +15,6 @@
 #include <linux/stat.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
-#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/file.h>
 #include <linux/vfs.h>
@@ -247,8 +246,6 @@ int coda_setattr(struct dentry *de, struct iattr *iattr)
 	struct coda_vattr vattr;
 	int error;
 
-	lock_kernel();
-	
 	memset(&vattr, 0, sizeof(vattr)); 
 
 	inode->i_ctime = CURRENT_TIME_SEC;
@@ -258,13 +255,11 @@ int coda_setattr(struct dentry *de, struct iattr *iattr)
 	/* Venus is responsible for truncating the container-file!!! */
 	error = venus_setattr(inode->i_sb, coda_i2f(inode), &vattr);
 
-	if ( !error ) {
+	if (!error) {
 	        coda_vattr_to_iattr(inode, &vattr); 
 		coda_cache_clear_inode(inode);
 	}
 
-	unlock_kernel();
-
 	return error;
 }
 
@@ -278,12 +273,8 @@ static int coda_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	int error;
 	
-	lock_kernel();
-
 	error = venus_statfs(dentry, buf);
 
-	unlock_kernel();
-
 	if (error) {
 		/* fake something like AFS does */
 		buf->f_blocks = 9000000;
diff --git a/fs/coda/pioctl.c b/fs/coda/pioctl.c
index ca25d96..600dc46 100644
--- a/fs/coda/pioctl.c
+++ b/fs/coda/pioctl.c
@@ -23,8 +23,6 @@
 #include <linux/coda_fs_i.h>
 #include <linux/coda_psdev.h>
 
-#include <linux/smp_lock.h>
-
 /* pioctl ops */
 static int coda_ioctl_permission(struct inode *inode, int mask);
 static long coda_pioctl(struct file *filp, unsigned int cmd,
@@ -57,13 +55,9 @@ static long coda_pioctl(struct file *filp, unsigned int cmd,
 	struct inode *target_inode = NULL;
 	struct coda_inode_info *cnp;
 
-	lock_kernel();
-
 	/* get the Pioctl data arguments from user space */
-	if (copy_from_user(&data, (void __user *)user_data, sizeof(data))) {
-		error = -EINVAL;
-		goto out;
-	}
+	if (copy_from_user(&data, (void __user *)user_data, sizeof(data)))
+		return -EINVAL;
 
 	/*
 	 * Look up the pathname. Note that the pathname is in
@@ -75,13 +69,12 @@ static long coda_pioctl(struct file *filp, unsigned int cmd,
 		error = user_lpath(data.path, &path);
 
 	if (error)
-		goto out;
-	else
-		target_inode = path.dentry->d_inode;
+		return error;
+
+	target_inode = path.dentry->d_inode;
 
 	/* return if it is not a Coda inode */
 	if (target_inode->i_sb != inode->i_sb) {
-		path_put(&path);
 		error = -EINVAL;
 		goto out;
 	}
@@ -90,10 +83,7 @@ static long coda_pioctl(struct file *filp, unsigned int cmd,
 	cnp = ITOC(target_inode);
 
 	error = venus_pioctl(inode->i_sb, &(cnp->c_fid), cmd, &data);
-
-	path_put(&path);
-
 out:
-	unlock_kernel();
+	path_put(&path);
 	return error;
 }
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index 116af75..f786759 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -137,9 +137,7 @@ static ssize_t coda_psdev_write(struct file *file, const char __user *buf,
 		}
 
 		/* what downcall errors does Venus handle ? */
-		lock_kernel();
 		error = coda_downcall(hdr.opcode, dcbuf, sb);
-		unlock_kernel();
 
 		CODA_FREE(dcbuf, nbytes);
 		if (error) {
diff --git a/fs/coda/symlink.c b/fs/coda/symlink.c
index 4513b72..af78f00 100644
--- a/fs/coda/symlink.c
+++ b/fs/coda/symlink.c
@@ -14,7 +14,6 @@
 #include <linux/stat.h>
 #include <linux/errno.h>
 #include <linux/pagemap.h>
-#include <linux/smp_lock.h>
 
 #include <linux/coda.h>
 #include <linux/coda_linux.h>
@@ -29,11 +28,9 @@ static int coda_symlink_filler(struct file *file, struct page *page)
 	unsigned int len = PAGE_SIZE;
 	char *p = kmap(page);
 
-	lock_kernel();
 	cii = ITOC(inode);
 
 	error = venus_readlink(inode->i_sb, &cii->c_fid, p, &len);
-	unlock_kernel();
 	if (error)
 		goto fail;
 	SetPageUptodate(page);
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index b8893ab..e53847f 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -27,6 +27,7 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <linux/vmalloc.h>
 #include <linux/vfs.h>
@@ -667,18 +668,23 @@ static int coda_upcall(struct venus_comm *vcp,
 {
 	union outputArgs *out;
 	union inputArgs *sig_inputArgs;
-	struct upc_req *req, *sig_req;
-	int error = 0;
+	struct upc_req *req = NULL, *sig_req;
+	int error;
+
+	lock_kernel();
 
 	if (!vcp->vc_inuse) {
 		printk(KERN_NOTICE "coda: Venus dead, not sending upcall\n");
-		return -ENXIO;
+		error = -ENXIO;
+		goto exit;
 	}
 
 	/* Format the request message. */
 	req = kmalloc(sizeof(struct upc_req), GFP_KERNEL);
-	if (!req)
-		return -ENOMEM;
+	if (!req) {
+		error = -ENOMEM;
+		goto exit;
+	}
 
 	req->uc_data = (void *)buffer;
 	req->uc_flags = 0;
@@ -759,6 +765,7 @@ static int coda_upcall(struct venus_comm *vcp,
 
 exit:
 	kfree(req);
+	unlock_kernel();
 	return error;
 }
 
-- 
1.6.3.3

