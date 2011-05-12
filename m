Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab1ELBYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 21:24:38 -0400
Received: from cobra.newdream.net ([66.33.216.30]:54293 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1ELBYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 21:24:32 -0400
From: Sage Weil <sage@newdream.net>
To: viro@ZenIV.linux.org.uk, hch@lst.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: [PATCH 3/3] ceph: switch I_COMPLETE to D_COMPLETE
Date: Wed, 11 May 2011 18:43:36 -0700
Message-Id: <1305164616-26597-4-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1305164616-26597-1-git-send-email-sage@newdream.net>
References: <1305164616-26597-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used to use a flag on the directory inode to track whether the dcache
contents for a directory were a complete cached copy.  Switch to a dentry
flag CEPH_D_COMPLETE that can be safely updated by ->d_prune().

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/caps.c       |    8 ++----
 fs/ceph/dir.c        |   59 ++++++++++++++++++++++++++++++++++++++++++-------
 fs/ceph/inode.c      |    9 +++----
 fs/ceph/mds_client.c |    6 ++--
 fs/ceph/super.h      |   10 ++++++-
 5 files changed, 68 insertions(+), 24 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 6b61ded..77ae202 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -487,17 +487,15 @@ static void __check_cap_issue(struct ceph_inode_info *ci, struct ceph_cap *cap,
 		ci->i_rdcache_gen++;
 
 	/*
-	 * if we are newly issued FILE_SHARED, clear I_COMPLETE; we
+	 * if we are newly issued FILE_SHARED, clear D_COMPLETE; we
 	 * don't know what happened to this directory while we didn't
 	 * have the cap.
 	 */
 	if ((issued & CEPH_CAP_FILE_SHARED) &&
 	    (had & CEPH_CAP_FILE_SHARED) == 0) {
 		ci->i_shared_gen++;
-		if (S_ISDIR(ci->vfs_inode.i_mode)) {
-			dout(" marking %p NOT complete\n", &ci->vfs_inode);
-			ci->i_ceph_flags &= ~CEPH_I_COMPLETE;
-		}
+		if (S_ISDIR(ci->vfs_inode.i_mode))
+			ceph_dir_clear_complete(&ci->vfs_inode);
 	}
 }
 
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index e2005fa..3b6ac99 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -90,7 +90,7 @@ static unsigned fpos_off(loff_t p)
  * falling back to a "normal" sync readdir if any dentries in the dir
  * are dropped.
  *
- * I_COMPLETE tells indicates we have all dentries in the dir.  It is
+ * D_COMPLETE tells indicates we have all dentries in the dir.  It is
  * defined IFF we hold CEPH_CAP_FILE_SHARED (which will be revoked by
  * the MDS if/when the directory is modified).
  */
@@ -181,8 +181,8 @@ more:
 	filp->f_pos++;
 
 	/* make sure a dentry wasn't dropped while we didn't have parent lock */
-	if (!ceph_i_test(dir, CEPH_I_COMPLETE)) {
-		dout(" lost I_COMPLETE on %p; falling back to mds\n", dir);
+	if (!ceph_dir_test_complete(dir)) {
+		dout(" lost D_COMPLETE on %p; falling back to mds\n", dir);
 		err = -EAGAIN;
 		goto out;
 	}
@@ -267,7 +267,7 @@ static int ceph_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	if ((filp->f_pos == 2 || fi->dentry) &&
 	    !ceph_test_mount_opt(fsc, NOASYNCREADDIR) &&
 	    ceph_snap(inode) != CEPH_SNAPDIR &&
-	    (ci->i_ceph_flags & CEPH_I_COMPLETE) &&
+	    ceph_dir_test_complete(inode) &&
 	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1)) {
 		spin_unlock(&inode->i_lock);
 		err = __dcache_readdir(filp, dirent, filldir);
@@ -332,7 +332,7 @@ more:
 
 		if (!req->r_did_prepopulate) {
 			dout("readdir !did_prepopulate");
-			fi->dir_release_count--;    /* preclude I_COMPLETE */
+			fi->dir_release_count--;    /* preclude D_COMPLETE */
 		}
 
 		/* note next offset and last dentry name */
@@ -411,8 +411,7 @@ more:
 	 */
 	spin_lock(&inode->i_lock);
 	if (ci->i_release_count == fi->dir_release_count) {
-		dout(" marking %p complete\n", inode);
-		/* ci->i_ceph_flags |= CEPH_I_COMPLETE; */
+		ceph_dir_set_complete(inode);
 		ci->i_max_offset = filp->f_pos;
 	}
 	spin_unlock(&inode->i_lock);
@@ -582,7 +581,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
 			    fsc->mount_options->snapdir_name,
 			    dentry->d_name.len) &&
 		    !is_root_ceph_dentry(dir, dentry) &&
-		    (ci->i_ceph_flags & CEPH_I_COMPLETE) &&
+		    ceph_dir_test_complete(dir) &&
 		    (__ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1))) {
 			spin_unlock(&dir->i_lock);
 			dout(" dir %p complete, -ENOENT\n", dir);
@@ -897,7 +896,7 @@ static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
 		 */
 
 		/* d_move screws up d_subdirs order */
-		ceph_i_clear(new_dir, CEPH_I_COMPLETE);
+		ceph_dir_clear_complete(new_dir);
 
 		d_move(old_dentry, new_dentry);
 
@@ -1054,6 +1053,48 @@ static int ceph_snapdir_d_revalidate(struct dentry *dentry,
 }
 
 /*
+ * Set/clear/test dir complete flag on the dir's dentry.
+ */
+static struct dentry * __d_find_any_alias(struct inode *inode)
+{
+	struct dentry *alias;
+
+	if (list_empty(&inode->i_dentry))
+		return NULL;
+	alias = list_first_entry(&inode->i_dentry, struct dentry, d_alias);
+	return alias;
+}
+
+void ceph_dir_set_complete(struct inode *inode)
+{
+	struct dentry *dentry = __d_find_any_alias(inode);
+	
+	if (dentry && ceph_dentry(dentry)) {
+		dout(" marking %p (%p) complete\n", inode, dentry);
+		set_bit(CEPH_D_COMPLETE, &ceph_dentry(dentry)->flags);
+	}
+}
+
+void ceph_dir_clear_complete(struct inode *inode)
+{
+	struct dentry *dentry = __d_find_any_alias(inode);
+
+	if (dentry && ceph_dentry(dentry)) {
+		dout(" marking %p (%p) NOT complete\n", inode, dentry);
+		set_bit(CEPH_D_COMPLETE, &ceph_dentry(dentry)->flags);
+	}
+}
+
+bool ceph_dir_test_complete(struct inode *inode)
+{
+	struct dentry *dentry = __d_find_any_alias(inode);
+
+	if (dentry && ceph_dentry(dentry))
+		return test_bit(CEPH_D_COMPLETE, &ceph_dentry(dentry)->flags);
+	return false;
+}
+
+/*
  * When the VFS prunes a dentry from the cache, we need to clear the
  * complete flag on the parent directory.
  *
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index b54c97d..dc5829a 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -712,9 +712,8 @@ static int fill_inode(struct inode *inode,
 		    ceph_snap(inode) == CEPH_NOSNAP &&
 		    (le32_to_cpu(info->cap.caps) & CEPH_CAP_FILE_SHARED) &&
 		    (issued & CEPH_CAP_FILE_EXCL) == 0 &&
-		    (ci->i_ceph_flags & CEPH_I_COMPLETE) == 0) {
-			dout(" marking %p complete (empty)\n", inode);
-			/* ci->i_ceph_flags |= CEPH_I_COMPLETE; */
+		    !ceph_dir_test_complete(inode) == 0) {
+			ceph_dir_set_complete(inode);
 			ci->i_max_offset = 2;
 		}
 		break;
@@ -850,7 +849,7 @@ static void ceph_set_dentry_offset(struct dentry *dn)
 	di = ceph_dentry(dn);
 
 	spin_lock(&inode->i_lock);
-	if ((ceph_inode(inode)->i_ceph_flags & CEPH_I_COMPLETE) == 0) {
+	if (!ceph_dir_test_complete(inode)) {
 		spin_unlock(&inode->i_lock);
 		return;
 	}
@@ -1052,7 +1051,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req,
 			 * d_move() puts the renamed dentry at the end of
 			 * d_subdirs.  We need to assign it an appropriate
 			 * directory offset so we can behave when holding
-			 * I_COMPLETE.
+			 * D_COMPLETE.
 			 */
 			ceph_set_dentry_offset(req->r_old_dentry);
 			dout("dn %p gets new offset %lld\n", req->r_old_dentry, 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a1ee8fa..22673b9 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1974,7 +1974,7 @@ out:
 }
 
 /*
- * Invalidate dir I_COMPLETE, dentry lease state on an aborted MDS
+ * Invalidate dir D_COMPLETE, dentry lease state on an aborted MDS
  * namespace request.
  */
 void ceph_invalidate_dir_request(struct ceph_mds_request *req)
@@ -1982,9 +1982,9 @@ void ceph_invalidate_dir_request(struct ceph_mds_request *req)
 	struct inode *inode = req->r_locked_dir;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
-	dout("invalidate_dir_request %p (I_COMPLETE, lease(s))\n", inode);
+	dout("invalidate_dir_request %p (D_COMPLETE, lease(s))\n", inode);
 	spin_lock(&inode->i_lock);
-	ci->i_ceph_flags &= ~CEPH_I_COMPLETE;
+	ceph_dir_clear_complete(inode);
 	ci->i_release_count++;
 	spin_unlock(&inode->i_lock);
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index b6bf098..6bcf0f5 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -262,7 +262,7 @@ struct ceph_inode_info {
 	struct timespec i_rctime;
 	u64 i_rbytes, i_rfiles, i_rsubdirs;
 	u64 i_files, i_subdirs;
-	u64 i_max_offset;  /* largest readdir offset, set with I_COMPLETE */
+	u64 i_max_offset;  /* largest readdir offset, set with D_COMPLETE */
 
 	struct rb_root i_fragtree;
 	struct mutex i_fragtree_mutex;
@@ -426,7 +426,6 @@ static inline struct inode *ceph_find_inode(struct super_block *sb,
 /*
  * Ceph inode.
  */
-#define CEPH_I_COMPLETE  1  /* we have complete directory cached */
 #define CEPH_I_NODELAY   4  /* do not delay cap release */
 #define CEPH_I_FLUSH     8  /* do not delay flush of dirty metadata */
 #define CEPH_I_NOFLUSH  16  /* do not flush dirty caps */
@@ -484,6 +483,13 @@ static inline loff_t ceph_make_fpos(unsigned frag, unsigned off)
 }
 
 /*
+ * set/clear directory D_COMPLETE flag
+ */
+void ceph_dir_set_complete(struct inode *inode);
+void ceph_dir_clear_complete(struct inode *inode);
+bool ceph_dir_test_complete(struct inode *inode);
+
+/*
  * caps helpers
  */
 static inline bool __ceph_is_any_real_caps(struct ceph_inode_info *ci)
-- 
1.7.0

