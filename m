Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab0JTUXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 16:23:41 -0400
Received: from BERING.ISR.CS.CMU.EDU ([128.2.209.223]:44645 "EHLO
	bering.isr.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab0JTUXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 16:23:39 -0400
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de,
        Yoshihisa Abe <yoshiabe@cs.cmu.edu>, Jan Harkes <jaharkes@cs.cmu.edu>
Subject: [RFC][PATCH 1/3] Coda: add spin lock to protect accesses to struct coda_inode_info.
Date: Wed, 20 Oct 2010 16:23:02 -0400
Message-Id: <1287606184-26889-2-git-send-email-jaharkes@cs.cmu.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1287606184-26889-1-git-send-email-jaharkes@cs.cmu.edu>
References: <1287606184-26889-1-git-send-email-jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yoshihisa Abe <yoshiabe@cs.cmu.edu>

We mostly need it to protect cached user permissions. The c_flags field
is advisory, reading the wrong value is harmless and in the worst case
we hit a slow path where we have to make an extra upcall to the
userspace cache manager when revalidating a dentry or inode.

Signed-off-by: Yoshihisa Abe <yoshiabe@cs.cmu.edu>
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
---
 fs/coda/cache.c            |   17 ++++++++++++-----
 fs/coda/cnode.c            |   19 ++++++++++++++-----
 fs/coda/dir.c              |    6 ++++++
 fs/coda/file.c             |   12 ++++++++++--
 fs/coda/inode.c            |    2 ++
 include/linux/coda_fs_i.h  |   13 +++++++++----
 include/linux/coda_linux.h |    6 +++++-
 7 files changed, 58 insertions(+), 17 deletions(-)

diff --git a/fs/coda/cache.c b/fs/coda/cache.c
index a5bf577..9060f08 100644
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -17,6 +17,7 @@
 #include <linux/string.h>
 #include <linux/list.h>
 #include <linux/sched.h>
+#include <linux/spinlock.h>
 
 #include <linux/coda.h>
 #include <linux/coda_linux.h>
@@ -31,19 +32,23 @@ void coda_cache_enter(struct inode *inode, int mask)
 {
 	struct coda_inode_info *cii = ITOC(inode);
 
+	spin_lock(&cii->c_lock);
 	cii->c_cached_epoch = atomic_read(&permission_epoch);
 	if (cii->c_uid != current_fsuid()) {
 		cii->c_uid = current_fsuid();
                 cii->c_cached_perm = mask;
         } else
                 cii->c_cached_perm |= mask;
+	spin_unlock(&cii->c_lock);
 }
 
 /* remove cached acl from an inode */
 void coda_cache_clear_inode(struct inode *inode)
 {
 	struct coda_inode_info *cii = ITOC(inode);
+	spin_lock(&cii->c_lock);
 	cii->c_cached_epoch = atomic_read(&permission_epoch) - 1;
+	spin_unlock(&cii->c_lock);
 }
 
 /* remove all acl caches */
@@ -57,13 +62,15 @@ void coda_cache_clear_all(struct super_block *sb)
 int coda_cache_check(struct inode *inode, int mask)
 {
 	struct coda_inode_info *cii = ITOC(inode);
-        int hit;
+	int hit;
 	
-        hit = (mask & cii->c_cached_perm) == mask &&
-		cii->c_uid == current_fsuid() &&
-		cii->c_cached_epoch == atomic_read(&permission_epoch);
+	spin_lock(&cii->c_lock);
+	hit = (mask & cii->c_cached_perm) == mask &&
+	    cii->c_uid == current_fsuid() &&
+	    cii->c_cached_epoch == atomic_read(&permission_epoch);
+	spin_unlock(&cii->c_lock);
 
-        return hit;
+	return hit;
 }
 
 
diff --git a/fs/coda/cnode.c b/fs/coda/cnode.c
index a7a7809..6022405 100644
--- a/fs/coda/cnode.c
+++ b/fs/coda/cnode.c
@@ -45,13 +45,15 @@ static void coda_fill_inode(struct inode *inode, struct coda_vattr *attr)
 static int coda_test_inode(struct inode *inode, void *data)
 {
 	struct CodaFid *fid = (struct CodaFid *)data;
-	return coda_fideq(&(ITOC(inode)->c_fid), fid);
+	struct coda_inode_info *cii = ITOC(inode);
+	return coda_fideq(&cii->c_fid, fid);
 }
 
 static int coda_set_inode(struct inode *inode, void *data)
 {
 	struct CodaFid *fid = (struct CodaFid *)data;
-	ITOC(inode)->c_fid = *fid;
+	struct coda_inode_info *cii = ITOC(inode);
+	cii->c_fid = *fid;
 	return 0;
 }
 
@@ -71,6 +73,7 @@ struct inode * coda_iget(struct super_block * sb, struct CodaFid * fid,
 		cii = ITOC(inode);
 		/* we still need to set i_ino for things like stat(2) */
 		inode->i_ino = hash;
+		/* inode is locked and unique, no need to grab cii->c_lock */
 		cii->c_mapcount = 0;
 		unlock_new_inode(inode);
 	}
@@ -107,14 +110,20 @@ int coda_cnode_make(struct inode **inode, struct CodaFid *fid, struct super_bloc
 }
 
 
+/* Although we treat Coda file identifiers as immutable, there is one
+ * special case for files created during a disconnection where they may
+ * not be globally unique. When an identifier collision is detected we
+ * first try to flush the cached inode from the kernel and finally
+ * resort to renaming/rehashing in-place. Userspace remembers both old
+ * and new values of the identifier to handle any in-flight upcalls.
+ * The real solution is to use globally unique UUIDs as identifiers, but
+ * retrofitting the existing userspace code for this is non-trivial. */
 void coda_replace_fid(struct inode *inode, struct CodaFid *oldfid, 
 		      struct CodaFid *newfid)
 {
-	struct coda_inode_info *cii;
+	struct coda_inode_info *cii = ITOC(inode);
 	unsigned long hash = coda_f2i(newfid);
 	
-	cii = ITOC(inode);
-
 	BUG_ON(!coda_fideq(&cii->c_fid, oldfid));
 
 	/* replace fid and rehash inode */
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index ccd98b0..69fbbea 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -18,6 +18,7 @@
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/smp_lock.h>
+#include <linux/spinlock.h>
 
 #include <asm/uaccess.h>
 
@@ -617,7 +618,9 @@ static int coda_dentry_revalidate(struct dentry *de, struct nameidata *nd)
 		goto out;
 
 	/* clear the flags. */
+	spin_lock(&cii->c_lock);
 	cii->c_flags &= ~(C_VATTR | C_PURGE | C_FLUSH);
+	spin_unlock(&cii->c_lock);
 
 bad:
 	unlock_kernel();
@@ -691,7 +694,10 @@ int coda_revalidate_inode(struct dentry *dentry)
 			goto return_bad;
 		
 		coda_flag_inode_children(inode, C_FLUSH);
+
+		spin_lock(&cii->c_lock);
 		cii->c_flags &= ~(C_VATTR | C_PURGE | C_FLUSH);
+		spin_unlock(&cii->c_lock);
 	}
 
 ok:
diff --git a/fs/coda/file.c b/fs/coda/file.c
index ad3cd2a..c4e3957 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -16,6 +16,7 @@
 #include <linux/cred.h>
 #include <linux/errno.h>
 #include <linux/smp_lock.h>
+#include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
@@ -109,19 +110,24 @@ coda_file_mmap(struct file *coda_file, struct vm_area_struct *vma)
 
 	coda_inode = coda_file->f_path.dentry->d_inode;
 	host_inode = host_file->f_path.dentry->d_inode;
+
+	cii = ITOC(coda_inode);
+	spin_lock(&cii->c_lock);
 	coda_file->f_mapping = host_file->f_mapping;
 	if (coda_inode->i_mapping == &coda_inode->i_data)
 		coda_inode->i_mapping = host_inode->i_mapping;
 
 	/* only allow additional mmaps as long as userspace isn't changing
 	 * the container file on us! */
-	else if (coda_inode->i_mapping != host_inode->i_mapping)
+	else if (coda_inode->i_mapping != host_inode->i_mapping) {
+		spin_unlock(&cii->c_lock);
 		return -EBUSY;
+	}
 
 	/* keep track of how often the coda_inode/host_file has been mmapped */
-	cii = ITOC(coda_inode);
 	cii->c_mapcount++;
 	cfi->cfi_mapcount++;
+	spin_unlock(&cii->c_lock);
 
 	return host_file->f_op->mmap(host_file, vma);
 }
@@ -185,11 +191,13 @@ int coda_release(struct inode *coda_inode, struct file *coda_file)
 	cii = ITOC(coda_inode);
 
 	/* did we mmap this file? */
+	spin_lock(&cii->c_lock);
 	if (coda_inode->i_mapping == &host_inode->i_data) {
 		cii->c_mapcount -= cfi->cfi_mapcount;
 		if (!cii->c_mapcount)
 			coda_inode->i_mapping = &coda_inode->i_data;
 	}
+	spin_unlock(&cii->c_lock);
 
 	fput(cfi->cfi_container);
 	kfree(coda_file->private_data);
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 6526e6f..f4ca79d 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <linux/unistd.h>
 #include <linux/smp_lock.h>
+#include <linux/spinlock.h>
 #include <linux/file.h>
 #include <linux/vfs.h>
 #include <linux/slab.h>
@@ -51,6 +52,7 @@ static struct inode *coda_alloc_inode(struct super_block *sb)
 	ei->c_flags = 0;
 	ei->c_uid = 0;
 	ei->c_cached_perm = 0;
+	spin_lock_init(&ei->c_lock);
 	return &ei->vfs_inode;
 }
 
diff --git a/include/linux/coda_fs_i.h b/include/linux/coda_fs_i.h
index b3ef0c4..e35071b 100644
--- a/include/linux/coda_fs_i.h
+++ b/include/linux/coda_fs_i.h
@@ -10,19 +10,24 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
+#include <linux/spinlock.h>
 #include <linux/coda.h>
 
 /*
  * coda fs inode data
+ * c_lock protects accesses to c_flags, c_mapcount, c_cached_epoch, c_uid and
+ * c_cached_perm.
+ * vfs_inode is set only when the inode is created and never changes.
+ * c_fid is set when the inode is created and should be considered immutable.
  */
 struct coda_inode_info {
-        struct CodaFid	   c_fid;	/* Coda identifier */
-        u_short	           c_flags;     /* flags (see below) */
-	struct list_head   c_cilist;    /* list of all coda inodes */
+	struct CodaFid	   c_fid;	/* Coda identifier */
+	u_short	           c_flags;     /* flags (see below) */
 	unsigned int	   c_mapcount;  /* nr of times this inode is mapped */
 	unsigned int	   c_cached_epoch; /* epoch for cached permissions */
 	vuid_t		   c_uid;	/* fsuid for cached permissions */
-        unsigned int       c_cached_perm; /* cached access permissions */
+	unsigned int       c_cached_perm; /* cached access permissions */
+	spinlock_t	   c_lock;
 	struct inode	   vfs_inode;
 };
 
diff --git a/include/linux/coda_linux.h b/include/linux/coda_linux.h
index dcc228a..2e914d0 100644
--- a/include/linux/coda_linux.h
+++ b/include/linux/coda_linux.h
@@ -89,7 +89,11 @@ static __inline__ char *coda_i2s(struct inode *inode)
 /* this will not zap the inode away */
 static __inline__ void coda_flag_inode(struct inode *inode, int flag)
 {
-	ITOC(inode)->c_flags |= flag;
+	struct coda_inode_info *cii = ITOC(inode);
+
+	spin_lock(&cii->c_lock);
+	cii->c_flags |= flag;
+	spin_unlock(&cii->c_lock);
 }		
 
 #endif
-- 
1.6.3.3

