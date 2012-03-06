Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2CFQUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:20:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14856 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab2CFQT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:19:58 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=N1KGNxIzn5cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=cVYi709e7yyLlad0BE4A:9 a=3bZ1-uYuXBmA7nafq4QA:7 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=4A8LiVGnmeiOwjAs:21 a=Xn3oGOWwgOX73DOd:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120306161949.777549942@goodmis.org>
User-Agent: quilt/0.50-1
Date: Tue, 06 Mar 2012 11:16:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 14/25][RFC 3.0.23-rt39-rc1] fs: dentry use seqlock
References: <20120306161636.491172179@goodmis.org>
Content-Disposition: inline; filename=0014-fs-dentry-use-seqlock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Replace the open coded seqlock with a real seqlock, so RT can handle
it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/platforms/cell/spufs/inode.c |    6 +-
 drivers/infiniband/hw/ipath/ipath_fs.c    |    6 +-
 drivers/infiniband/hw/qib/qib_fs.c        |    6 +-
 drivers/usb/core/inode.c                  |   12 +-
 fs/9p/vfs_dir.c                           |    4 +-
 fs/afs/dir.c                              |    4 +-
 fs/autofs4/autofs_i.h                     |   24 ++--
 fs/autofs4/expire.c                       |   44 +++---
 fs/autofs4/root.c                         |   38 ++--
 fs/btrfs/export.c                         |    4 +-
 fs/ceph/caps.c                            |    8 +-
 fs/ceph/debugfs.c                         |    8 +-
 fs/ceph/dir.c                             |   26 ++--
 fs/ceph/inode.c                           |   20 +-
 fs/ceph/mds_client.c                      |   16 +-
 fs/cifs/dir.c                             |    6 +-
 fs/coda/cache.c                           |    4 +-
 fs/configfs/configfs_internal.h           |    4 +-
 fs/configfs/inode.c                       |    6 +-
 fs/dcache.c                               |  269 ++++++++++++++---------------
 fs/dcookies.c                             |    8 +-
 fs/exportfs/expfs.c                       |   12 +-
 fs/fat/inode.c                            |    4 +-
 fs/fat/namei_vfat.c                       |    4 +-
 fs/fs-writeback.c                         |    4 +-
 fs/fuse/inode.c                           |    4 +-
 fs/gfs2/export.c                          |    4 +-
 fs/isofs/export.c                         |    4 +-
 fs/libfs.c                                |   36 ++--
 fs/namei.c                                |   42 +++---
 fs/namespace.c                            |    8 +-
 fs/ncpfs/dir.c                            |    6 +-
 fs/ncpfs/ncplib_kernel.h                  |    8 +-
 fs/nfs/dir.c                              |    6 +-
 fs/nfs/getroot.c                          |   12 +-
 fs/nfs/namespace.c                        |   16 +-
 fs/nfs/unlink.c                           |   20 +-
 fs/nilfs2/namei.c                         |    4 +-
 fs/notify/fsnotify.c                      |    8 +-
 fs/notify/vfsmount_mark.c                 |   24 ++--
 fs/ocfs2/dcache.c                         |    6 +-
 fs/ocfs2/export.c                         |    4 +-
 fs/reiserfs/inode.c                       |    4 +-
 fs/udf/namei.c                            |    4 +-
 fs/xfs/linux-2.6/xfs_export.c             |    8 +-
 include/linux/dcache.h                    |   15 +-
 include/linux/fs.h                        |    4 +-
 include/linux/fsnotify_backend.h          |    6 +-
 kernel/cgroup.c                           |   22 ++--
 net/sunrpc/rpc_pipe.c                     |    6 +-
 security/selinux/selinuxfs.c              |   14 +-
 51 files changed, 419 insertions(+), 423 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 856e9c3..1baf322 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -165,18 +165,18 @@ static void spufs_prune_dir(struct dentry *dir)
 
 	mutex_lock(&dir->d_inode->i_mutex);
 	list_for_each_entry_safe(dentry, tmp, &dir->d_subdirs, d_u.d_child) {
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry)) && dentry->d_inode) {
 			dget_dlock(dentry);
 			__d_drop(dentry);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			simple_unlink(dir->d_inode, dentry);
 			/* XXX: what was dcache_lock protecting here? Other
 			 * filesystems (IB, configfs) release dcache_lock
 			 * before unlink */
 			dput(dentry);
 		} else {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 		}
 	}
 	shrink_dcache_parent(dir);
diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/infiniband/hw/ipath/ipath_fs.c
index 31ae1b1..21319f7 100644
--- a/drivers/infiniband/hw/ipath/ipath_fs.c
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -277,14 +277,14 @@ static int remove_file(struct dentry *parent, char *name)
 		goto bail;
 	}
 
-	spin_lock(&tmp->d_lock);
+	seq_spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
 		dget_dlock(tmp);
 		__d_drop(tmp);
-		spin_unlock(&tmp->d_lock);
+		seq_spin_unlock(&tmp->d_lock);
 		simple_unlink(parent->d_inode, tmp);
 	} else
-		spin_unlock(&tmp->d_lock);
+		seq_spin_unlock(&tmp->d_lock);
 
 	ret = 0;
 bail:
diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index df7fa25..b20c7f8 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -453,14 +453,14 @@ static int remove_file(struct dentry *parent, char *name)
 		goto bail;
 	}
 
-	spin_lock(&tmp->d_lock);
+	seq_spin_lock(&tmp->d_lock);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
 		dget_dlock(tmp);
 		__d_drop(tmp);
-		spin_unlock(&tmp->d_lock);
+		seq_spin_unlock(&tmp->d_lock);
 		simple_unlink(parent->d_inode, tmp);
 	} else {
-		spin_unlock(&tmp->d_lock);
+		seq_spin_unlock(&tmp->d_lock);
 	}
 
 	ret = 0;
diff --git a/drivers/usb/core/inode.c b/drivers/usb/core/inode.c
index 2278dad..731f03f 100644
--- a/drivers/usb/core/inode.c
+++ b/drivers/usb/core/inode.c
@@ -343,19 +343,19 @@ static int usbfs_empty (struct dentry *dentry)
 {
 	struct list_head *list;
 
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	list_for_each(list, &dentry->d_subdirs) {
 		struct dentry *de = list_entry(list, struct dentry, d_u.d_child);
 
-		spin_lock_nested(&de->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&de->d_lock, DENTRY_D_LOCK_NESTED);
 		if (usbfs_positive(de)) {
-			spin_unlock(&de->d_lock);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&de->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			return 0;
 		}
-		spin_unlock(&de->d_lock);
+		seq_spin_unlock(&de->d_lock);
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return 1;
 }
 
diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 9c2bdda..0ca9433 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -107,7 +107,7 @@ static int v9fs_alloc_rdir_buf(struct file *filp, int buflen)
 			err = -ENOMEM;
 			goto exit;
 		}
-		spin_lock(&filp->f_dentry->d_lock);
+		seq_spin_lock(&filp->f_dentry->d_lock);
 		if (!fid->rdir) {
 			rdir->buf = (uint8_t *)rdir + sizeof(struct p9_rdir);
 			mutex_init(&rdir->mutex);
@@ -115,7 +115,7 @@ static int v9fs_alloc_rdir_buf(struct file *filp, int buflen)
 			fid->rdir = (void *) rdir;
 			rdir = NULL;
 		}
-		spin_unlock(&filp->f_dentry->d_lock);
+		seq_spin_unlock(&filp->f_dentry->d_lock);
 		kfree(rdir);
 	}
 exit:
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 1b0b195..84f6bf6 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -705,9 +705,9 @@ out_skip:
 
 	/* the dirent, if it exists, now points to a different vnode */
 not_found:
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dentry->d_flags |= DCACHE_NFSFS_RENAMED;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 
 out_bad:
 	if (dentry->d_inode) {
diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 475f9c5..b620114 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -207,9 +207,9 @@ static inline void __managed_dentry_set_automount(struct dentry *dentry)
 
 static inline void managed_dentry_set_automount(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__managed_dentry_set_automount(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 static inline void __managed_dentry_clear_automount(struct dentry *dentry)
@@ -219,9 +219,9 @@ static inline void __managed_dentry_clear_automount(struct dentry *dentry)
 
 static inline void managed_dentry_clear_automount(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__managed_dentry_clear_automount(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 static inline void __managed_dentry_set_transit(struct dentry *dentry)
@@ -231,9 +231,9 @@ static inline void __managed_dentry_set_transit(struct dentry *dentry)
 
 static inline void managed_dentry_set_transit(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__managed_dentry_set_transit(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 static inline void __managed_dentry_clear_transit(struct dentry *dentry)
@@ -243,9 +243,9 @@ static inline void __managed_dentry_clear_transit(struct dentry *dentry)
 
 static inline void managed_dentry_clear_transit(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__managed_dentry_clear_transit(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 static inline void __managed_dentry_set_managed(struct dentry *dentry)
@@ -255,9 +255,9 @@ static inline void __managed_dentry_set_managed(struct dentry *dentry)
 
 static inline void managed_dentry_set_managed(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__managed_dentry_set_managed(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 static inline void __managed_dentry_clear_managed(struct dentry *dentry)
@@ -267,9 +267,9 @@ static inline void __managed_dentry_clear_managed(struct dentry *dentry)
 
 static inline void managed_dentry_clear_managed(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__managed_dentry_clear_managed(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 /* Initializing function */
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 450f529..d8b6184 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -99,7 +99,7 @@ static struct dentry *get_next_positive_subdir(struct dentry *prev,
 	spin_lock(&sbi->lookup_lock);
 
 	if (prev == NULL) {
-		spin_lock(&root->d_lock);
+		seq_spin_lock(&root->d_lock);
 		prev = dget_dlock(root);
 		next = prev->d_subdirs.next;
 		p = prev;
@@ -107,12 +107,12 @@ static struct dentry *get_next_positive_subdir(struct dentry *prev,
 	}
 
 	p = prev;
-	spin_lock(&p->d_lock);
+	seq_spin_lock(&p->d_lock);
 again:
 	next = p->d_u.d_child.next;
 start:
 	if (next == &root->d_subdirs) {
-		spin_unlock(&p->d_lock);
+		seq_spin_unlock(&p->d_lock);
 		spin_unlock(&sbi->lookup_lock);
 		dput(prev);
 		return NULL;
@@ -120,16 +120,16 @@ start:
 
 	q = list_entry(next, struct dentry, d_u.d_child);
 
-	spin_lock_nested(&q->d_lock, DENTRY_D_LOCK_NESTED);
+	seq_spin_lock_nested(&q->d_lock, DENTRY_D_LOCK_NESTED);
 	/* Negative dentry - try next */
 	if (!simple_positive(q)) {
-		spin_unlock(&p->d_lock);
+		seq_spin_unlock(&p->d_lock);
 		p = q;
 		goto again;
 	}
 	dget_dlock(q);
-	spin_unlock(&q->d_lock);
-	spin_unlock(&p->d_lock);
+	seq_spin_unlock(&q->d_lock);
+	seq_spin_unlock(&p->d_lock);
 	spin_unlock(&sbi->lookup_lock);
 
 	dput(prev);
@@ -153,7 +153,7 @@ static struct dentry *get_next_positive_dentry(struct dentry *prev,
 	spin_lock(&sbi->lookup_lock);
 relock:
 	p = prev;
-	spin_lock(&p->d_lock);
+	seq_spin_lock(&p->d_lock);
 again:
 	next = p->d_subdirs.next;
 	if (next == &p->d_subdirs) {
@@ -161,19 +161,19 @@ again:
 			struct dentry *parent;
 
 			if (p == root) {
-				spin_unlock(&p->d_lock);
+				seq_spin_unlock(&p->d_lock);
 				spin_unlock(&sbi->lookup_lock);
 				dput(prev);
 				return NULL;
 			}
 
 			parent = p->d_parent;
-			if (!spin_trylock(&parent->d_lock)) {
-				spin_unlock(&p->d_lock);
+			if (!seq_spin_trylock(&parent->d_lock)) {
+				seq_spin_unlock(&p->d_lock);
 				cpu_relax();
 				goto relock;
 			}
-			spin_unlock(&p->d_lock);
+			seq_spin_unlock(&p->d_lock);
 			next = p->d_u.d_child.next;
 			p = parent;
 			if (next != &parent->d_subdirs)
@@ -182,16 +182,16 @@ again:
 	}
 	ret = list_entry(next, struct dentry, d_u.d_child);
 
-	spin_lock_nested(&ret->d_lock, DENTRY_D_LOCK_NESTED);
+	seq_spin_lock_nested(&ret->d_lock, DENTRY_D_LOCK_NESTED);
 	/* Negative dentry - try next */
 	if (!simple_positive(ret)) {
-		spin_unlock(&p->d_lock);
+		seq_spin_unlock(&p->d_lock);
 		p = ret;
 		goto again;
 	}
 	dget_dlock(ret);
-	spin_unlock(&ret->d_lock);
-	spin_unlock(&p->d_lock);
+	seq_spin_unlock(&ret->d_lock);
+	seq_spin_unlock(&p->d_lock);
 	spin_unlock(&sbi->lookup_lock);
 
 	dput(prev);
@@ -462,11 +462,11 @@ found:
 	init_completion(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
 	spin_lock(&sbi->lookup_lock);
-	spin_lock(&expired->d_parent->d_lock);
-	spin_lock_nested(&expired->d_lock, DENTRY_D_LOCK_NESTED);
+	seq_spin_lock(&expired->d_parent->d_lock);
+	seq_spin_lock_nested(&expired->d_lock, DENTRY_D_LOCK_NESTED);
 	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
-	spin_unlock(&expired->d_lock);
-	spin_unlock(&expired->d_parent->d_lock);
+	seq_spin_unlock(&expired->d_lock);
+	seq_spin_unlock(&expired->d_parent->d_lock);
 	spin_unlock(&sbi->lookup_lock);
 	return expired;
 }
@@ -556,7 +556,7 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 
 		spin_lock(&sbi->fs_lock);
 		ino->flags &= ~AUTOFS_INF_EXPIRING;
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (!ret) {
 			if ((IS_ROOT(dentry) ||
 			    (autofs_type_indirect(sbi->type) &&
@@ -564,7 +564,7 @@ int autofs4_do_expire_multi(struct super_block *sb, struct vfsmount *mnt,
 			    !(dentry->d_flags & DCACHE_NEED_AUTOMOUNT))
 				__managed_dentry_set_automount(dentry);
 		}
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		complete_all(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);
 		dput(dentry);
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index f55ae23..4a52674 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -124,13 +124,13 @@ static int autofs4_dir_open(struct inode *inode, struct file *file)
 	 * it.
 	 */
 	spin_lock(&sbi->lookup_lock);
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		spin_unlock(&sbi->lookup_lock);
 		return -ENOENT;
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	spin_unlock(&sbi->lookup_lock);
 
 out:
@@ -179,7 +179,7 @@ static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 		ino = list_entry(p, struct autofs_info, active);
 		active = ino->dentry;
 
-		spin_lock(&active->d_lock);
+		seq_spin_lock(&active->d_lock);
 
 		/* Already gone? */
 		if (active->d_count == 0)
@@ -199,12 +199,12 @@ static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 
 		if (d_unhashed(active)) {
 			dget_dlock(active);
-			spin_unlock(&active->d_lock);
+			seq_spin_unlock(&active->d_lock);
 			spin_unlock(&sbi->lookup_lock);
 			return active;
 		}
 next:
-		spin_unlock(&active->d_lock);
+		seq_spin_unlock(&active->d_lock);
 	}
 	spin_unlock(&sbi->lookup_lock);
 
@@ -231,7 +231,7 @@ static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
 		ino = list_entry(p, struct autofs_info, expiring);
 		expiring = ino->dentry;
 
-		spin_lock(&expiring->d_lock);
+		seq_spin_lock(&expiring->d_lock);
 
 		/* Bad luck, we've already been dentry_iput */
 		if (!expiring->d_inode)
@@ -251,12 +251,12 @@ static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
 
 		if (d_unhashed(expiring)) {
 			dget_dlock(expiring);
-			spin_unlock(&expiring->d_lock);
+			seq_spin_unlock(&expiring->d_lock);
 			spin_unlock(&sbi->lookup_lock);
 			return expiring;
 		}
 next:
-		spin_unlock(&expiring->d_lock);
+		seq_spin_unlock(&expiring->d_lock);
 	}
 	spin_unlock(&sbi->lookup_lock);
 
@@ -382,12 +382,12 @@ static struct vfsmount *autofs4_d_automount(struct path *path)
 			if (have_submounts(dentry))
 				goto done;
 		} else {
-			spin_lock(&dentry->d_lock);
+			seq_spin_lock(&dentry->d_lock);
 			if (!list_empty(&dentry->d_subdirs)) {
-				spin_unlock(&dentry->d_lock);
+				seq_spin_unlock(&dentry->d_lock);
 				goto done;
 			}
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 		}
 		ino->flags |= AUTOFS_INF_PENDING;
 		spin_unlock(&sbi->fs_lock);
@@ -410,12 +410,12 @@ done:
 		 * an actual mount so ->d_automount() won't be called during
 		 * the follow.
 		 */
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if ((!d_mountpoint(dentry) &&
 		    !list_empty(&dentry->d_subdirs)) ||
 		    (dentry->d_inode && S_ISLNK(dentry->d_inode->i_mode)))
 			__managed_dentry_clear_automount(dentry);
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
 	spin_unlock(&sbi->fs_lock);
 
@@ -597,9 +597,9 @@ static int autofs4_dir_unlink(struct inode *dir, struct dentry *dentry)
 
 	spin_lock(&sbi->lookup_lock);
 	__autofs4_add_expiring(dentry);
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	spin_unlock(&sbi->lookup_lock);
 
 	return 0;
@@ -670,15 +670,15 @@ static int autofs4_dir_rmdir(struct inode *dir, struct dentry *dentry)
 		return -EACCES;
 
 	spin_lock(&sbi->lookup_lock);
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (!list_empty(&dentry->d_subdirs)) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		spin_unlock(&sbi->lookup_lock);
 		return -ENOTEMPTY;
 	}
 	__autofs4_add_expiring(dentry);
 	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	spin_unlock(&sbi->lookup_lock);
 
 	if (sbi->version < 5)
diff --git a/fs/btrfs/export.c b/fs/btrfs/export.c
index 1b8dc33..c473324 100644
--- a/fs/btrfs/export.c
+++ b/fs/btrfs/export.c
@@ -40,14 +40,14 @@ static int btrfs_encode_fh(struct dentry *dentry, u32 *fh, int *max_len,
 		struct inode *parent;
 		u64 parent_root_id;
 
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 
 		parent = dentry->d_parent->d_inode;
 		fid->parent_objectid = BTRFS_I(parent)->location.objectid;
 		fid->parent_gen = parent->i_generation;
 		parent_root_id = BTRFS_I(parent)->root->objectid;
 
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 
 		if (parent_root_id != fid->root_objectid) {
 			fid->parent_root_objectid = parent_root_id;
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index f605753..2c2ac3a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -3065,14 +3065,14 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 	 * doesn't have to be perfect; the mds will revoke anything we don't
 	 * release.
 	 */
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (di->lease_session && di->lease_session->s_mds == mds)
 		force = 1;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 
 	ret = ceph_encode_inode_release(p, dir, mds, drop, unless, force);
 
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (ret && di->lease_session && di->lease_session->s_mds == mds) {
 		dout("encode_dentry_release %p mds%d seq %d\n",
 		     dentry, mds, (int)di->lease_seq);
@@ -3082,6 +3082,6 @@ int ceph_encode_dentry_release(void **p, struct dentry *dentry,
 		rel->dname_seq = cpu_to_le32(di->lease_seq);
 		__ceph_mdsc_drop_dentry_lease(dentry);
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return ret;
 }
diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 0dba691..0ecffe2 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -82,13 +82,13 @@ static int mdsc_show(struct seq_file *s, void *p)
 						    &pathbase, 0);
 			if (IS_ERR(path))
 				path = NULL;
-			spin_lock(&req->r_dentry->d_lock);
+			seq_spin_lock(&req->r_dentry->d_lock);
 			seq_printf(s, " #%llx/%.*s (%s)",
 				   ceph_ino(req->r_dentry->d_parent->d_inode),
 				   req->r_dentry->d_name.len,
 				   req->r_dentry->d_name.name,
 				   path ? path : "");
-			spin_unlock(&req->r_dentry->d_lock);
+			seq_spin_unlock(&req->r_dentry->d_lock);
 			kfree(path);
 		} else if (req->r_path1) {
 			seq_printf(s, " #%llx/%s", req->r_ino1.ino,
@@ -100,13 +100,13 @@ static int mdsc_show(struct seq_file *s, void *p)
 						    &pathbase, 0);
 			if (IS_ERR(path))
 				path = NULL;
-			spin_lock(&req->r_old_dentry->d_lock);
+			seq_spin_lock(&req->r_old_dentry->d_lock);
 			seq_printf(s, " #%llx/%.*s (%s)",
 			   ceph_ino(req->r_old_dentry->d_parent->d_inode),
 				   req->r_old_dentry->d_name.len,
 				   req->r_old_dentry->d_name.name,
 				   path ? path : "");
-			spin_unlock(&req->r_old_dentry->d_lock);
+			seq_spin_unlock(&req->r_old_dentry->d_lock);
 			kfree(path);
 		} else if (req->r_path2) {
 			if (req->r_ino2.ino)
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index ef8f08c..f0f6efd 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -52,7 +52,7 @@ int ceph_init_dentry(struct dentry *dentry)
 	if (!di)
 		return -ENOMEM;          /* oh well */
 
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (dentry->d_fsdata) {
 		/* lost a race */
 		kmem_cache_free(ceph_dentry_cachep, di);
@@ -64,7 +64,7 @@ int ceph_init_dentry(struct dentry *dentry)
 	dentry->d_time = jiffies;
 	ceph_dentry_lru_add(dentry);
 out_unlock:
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return 0;
 }
 
@@ -112,7 +112,7 @@ static int __dcache_readdir(struct file *filp,
 	dout("__dcache_readdir %p at %llu (last %p)\n", dir, filp->f_pos,
 	     last);
 
-	spin_lock(&parent->d_lock);
+	seq_spin_lock(&parent->d_lock);
 
 	/* start at beginning? */
 	if (filp->f_pos == 2 || last == NULL ||
@@ -136,7 +136,7 @@ more:
 			fi->at_end = 1;
 			goto out_unlock;
 		}
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		if (!d_unhashed(dentry) && dentry->d_inode &&
 		    ceph_snap(dentry->d_inode) != CEPH_SNAPDIR &&
 		    ceph_ino(dentry->d_inode) != CEPH_INO_CEPH &&
@@ -146,15 +146,15 @@ more:
 		     dentry->d_name.len, dentry->d_name.name, di->offset,
 		     filp->f_pos, d_unhashed(dentry) ? " unhashed" : "",
 		     !dentry->d_inode ? " null" : "");
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		p = p->prev;
 		dentry = list_entry(p, struct dentry, d_u.d_child);
 		di = ceph_dentry(dentry);
 	}
 
 	dget_dlock(dentry);
-	spin_unlock(&dentry->d_lock);
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 
 	dout(" %llu (%llu) dentry %p %.*s %p\n", di->offset, filp->f_pos,
 	     dentry, dentry->d_name.len, dentry->d_name.name, dentry->d_inode);
@@ -187,12 +187,12 @@ more:
 		goto out;
 	}
 
-	spin_lock(&parent->d_lock);
+	seq_spin_lock(&parent->d_lock);
 	p = p->prev;	/* advance to next dentry */
 	goto more;
 
 out_unlock:
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 out:
 	if (last)
 		dput(last);
@@ -917,10 +917,10 @@ static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
  */
 void ceph_invalidate_dentry_lease(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dentry->d_time = jiffies;
 	ceph_dentry(dentry)->lease_shared_gen = 0;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 /*
@@ -938,7 +938,7 @@ static int dentry_lease_is_valid(struct dentry *dentry)
 	struct inode *dir = NULL;
 	u32 seq = 0;
 
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	di = ceph_dentry(dentry);
 	if (di && di->lease_session) {
 		s = di->lease_session;
@@ -962,7 +962,7 @@ static int dentry_lease_is_valid(struct dentry *dentry)
 			}
 		}
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 
 	if (session) {
 		ceph_mdsc_lease_send_msg(session, dir, dentry,
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index d8858e9..11f11ed 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -804,7 +804,7 @@ static void update_dentry_lease(struct dentry *dentry,
 	if (dentry->d_op != &ceph_dentry_ops)
 		return;
 
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dout("update_dentry_lease %p mask %d duration %lu ms ttl %lu\n",
 	     dentry, le16_to_cpu(lease->mask), duration, ttl);
 
@@ -832,7 +832,7 @@ static void update_dentry_lease(struct dentry *dentry,
 	di->lease_renew_from = 0;
 	dentry->d_time = ttl;
 out_unlock:
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return;
 }
 
@@ -858,13 +858,13 @@ static void ceph_set_dentry_offset(struct dentry *dn)
 	di->offset = ceph_inode(inode)->i_max_offset++;
 	spin_unlock(&inode->i_lock);
 
-	spin_lock(&dir->d_lock);
-	spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
+	seq_spin_lock(&dir->d_lock);
+	seq_spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
 	list_move(&dn->d_u.d_child, &dir->d_subdirs);
 	dout("set_dentry_offset %p %lld (%p %p)\n", dn, di->offset,
 	     dn->d_u.d_child.prev, dn->d_u.d_child.next);
-	spin_unlock(&dn->d_lock);
-	spin_unlock(&dir->d_lock);
+	seq_spin_unlock(&dn->d_lock);
+	seq_spin_unlock(&dir->d_lock);
 }
 
 /*
@@ -1248,11 +1248,11 @@ retry_lookup:
 			goto retry_lookup;
 		} else {
 			/* reorder parent's d_subdirs */
-			spin_lock(&parent->d_lock);
-			spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
+			seq_spin_lock(&parent->d_lock);
+			seq_spin_lock_nested(&dn->d_lock, DENTRY_D_LOCK_NESTED);
 			list_move(&dn->d_u.d_child, &parent->d_subdirs);
-			spin_unlock(&dn->d_lock);
-			spin_unlock(&parent->d_lock);
+			seq_spin_unlock(&dn->d_lock);
+			seq_spin_unlock(&parent->d_lock);
 		}
 
 		di = dn->d_fsdata;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 0c1d917..da64709 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1476,7 +1476,7 @@ retry:
 	for (temp = dentry; !IS_ROOT(temp) && pos != 0; ) {
 		struct inode *inode;
 
-		spin_lock(&temp->d_lock);
+		seq_spin_lock(&temp->d_lock);
 		inode = temp->d_inode;
 		if (inode && ceph_snap(inode) == CEPH_SNAPDIR) {
 			dout("build_path path+%d: %p SNAPDIR\n",
@@ -1487,13 +1487,13 @@ retry:
 		} else {
 			pos -= temp->d_name.len;
 			if (pos < 0) {
-				spin_unlock(&temp->d_lock);
+				seq_spin_unlock(&temp->d_lock);
 				break;
 			}
 			strncpy(path + pos, temp->d_name.name,
 				temp->d_name.len);
 		}
-		spin_unlock(&temp->d_lock);
+		seq_spin_unlock(&temp->d_lock);
 		if (pos)
 			path[--pos] = '/';
 		temp = temp->d_parent;
@@ -2758,7 +2758,7 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 	if (!dentry)
 		goto release;
 
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	di = ceph_dentry(dentry);
 	switch (h->action) {
 	case CEPH_MDS_LEASE_REVOKE:
@@ -2786,7 +2786,7 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 		}
 		break;
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	dput(dentry);
 
 	if (!release)
@@ -2861,7 +2861,7 @@ void ceph_mdsc_lease_release(struct ceph_mds_client *mdsc, struct inode *inode,
 	BUG_ON(mask == 0);
 
 	/* is dentry lease valid? */
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	di = ceph_dentry(dentry);
 	if (!di || !di->lease_session ||
 	    di->lease_session->s_mds < 0 ||
@@ -2870,7 +2870,7 @@ void ceph_mdsc_lease_release(struct ceph_mds_client *mdsc, struct inode *inode,
 		dout("lease_release inode %p dentry %p -- "
 		     "no lease on %d\n",
 		     inode, dentry, mask);
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		return;
 	}
 
@@ -2878,7 +2878,7 @@ void ceph_mdsc_lease_release(struct ceph_mds_client *mdsc, struct inode *inode,
 	session = ceph_get_mds_session(di->lease_session);
 	seq = di->lease_seq;
 	__ceph_mdsc_drop_dentry_lease(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 
 	dout("lease_release inode %p dentry %p mask %d to mds%d\n",
 	     inode, dentry, mask, session->s_mds);
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 16cdd6d..337abab 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -88,10 +88,10 @@ cifs_bp_rename_retry:
 	full_path[namelen] = 0;	/* trailing null */
 	rcu_read_lock();
 	for (temp = direntry; !IS_ROOT(temp);) {
-		spin_lock(&temp->d_lock);
+		seq_spin_lock(&temp->d_lock);
 		namelen -= 1 + temp->d_name.len;
 		if (namelen < 0) {
-			spin_unlock(&temp->d_lock);
+			seq_spin_unlock(&temp->d_lock);
 			break;
 		} else {
 			full_path[namelen] = dirsep;
@@ -99,7 +99,7 @@ cifs_bp_rename_retry:
 				temp->d_name.len);
 			cFYI(0, "name: %s", full_path + namelen);
 		}
-		spin_unlock(&temp->d_lock);
+		seq_spin_unlock(&temp->d_lock);
 		temp = temp->d_parent;
 		if (temp == NULL) {
 			cERROR(1, "corrupt dentry");
diff --git a/fs/coda/cache.c b/fs/coda/cache.c
index 6901578..93b5810 100644
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -92,7 +92,7 @@ static void coda_flag_children(struct dentry *parent, int flag)
 	struct list_head *child;
 	struct dentry *de;
 
-	spin_lock(&parent->d_lock);
+	seq_spin_lock(&parent->d_lock);
 	list_for_each(child, &parent->d_subdirs)
 	{
 		de = list_entry(child, struct dentry, d_u.d_child);
@@ -101,7 +101,7 @@ static void coda_flag_children(struct dentry *parent, int flag)
 			continue;
 		coda_flag_inode(de->d_inode, flag);
 	}
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 	return; 
 }
 
diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index 82bda8f..2ebef5e 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -121,7 +121,7 @@ static inline struct config_item *configfs_get_config_item(struct dentry *dentry
 {
 	struct config_item * item = NULL;
 
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (!d_unhashed(dentry)) {
 		struct configfs_dirent * sd = dentry->d_fsdata;
 		if (sd->s_type & CONFIGFS_ITEM_LINK) {
@@ -130,7 +130,7 @@ static inline struct config_item *configfs_get_config_item(struct dentry *dentry
 		} else
 			item = config_item_get(sd->s_element);
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 
 	return item;
 }
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index c83f476..84d7e95 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -250,14 +250,14 @@ void configfs_drop_dentry(struct configfs_dirent * sd, struct dentry * parent)
 	struct dentry * dentry = sd->s_dentry;
 
 	if (dentry) {
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry) && dentry->d_inode)) {
 			dget_dlock(dentry);
 			__d_drop(dentry);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			simple_unlink(parent->d_inode, dentry);
 		} else
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 	}
 }
 
diff --git a/fs/dcache.c b/fs/dcache.c
index f598b98..10580be 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -171,9 +171,9 @@ static void d_free(struct dentry *dentry)
  */
 static inline void dentry_rcuwalk_barrier(struct dentry *dentry)
 {
-	assert_spin_locked(&dentry->d_lock);
+	assert_seq_spin_locked(&dentry->d_lock);
 	/* Go through a barrier */
-	write_seqcount_barrier(&dentry->d_seq);
+	write_seqlock_barrier(&dentry->d_lock);
 }
 
 /*
@@ -189,7 +189,7 @@ static void dentry_iput(struct dentry * dentry)
 	if (inode) {
 		dentry->d_inode = NULL;
 		list_del_init(&dentry->d_alias);
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		spin_unlock(&inode->i_lock);
 		if (!inode->i_nlink)
 			fsnotify_inoderemove(inode);
@@ -198,7 +198,7 @@ static void dentry_iput(struct dentry * dentry)
 		else
 			iput(inode);
 	} else {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
 }
 
@@ -214,7 +214,7 @@ static void dentry_unlink_inode(struct dentry * dentry)
 	dentry->d_inode = NULL;
 	list_del_init(&dentry->d_alias);
 	dentry_rcuwalk_barrier(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	spin_unlock(&inode->i_lock);
 	if (!inode->i_nlink)
 		fsnotify_inoderemove(inode);
@@ -292,7 +292,7 @@ static struct dentry *d_kill(struct dentry *dentry, struct dentry *parent)
 	 */
 	dentry->d_flags |= DCACHE_DISCONNECTED;
 	if (parent)
-		spin_unlock(&parent->d_lock);
+		seq_spin_unlock(&parent->d_lock);
 	dentry_iput(dentry);
 	/*
 	 * dentry_iput drops the locks, at which point nobody (except
@@ -338,9 +338,9 @@ EXPORT_SYMBOL(__d_drop);
 
 void d_drop(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 EXPORT_SYMBOL(d_drop);
 
@@ -359,7 +359,7 @@ static inline struct dentry *dentry_kill(struct dentry *dentry, int ref)
 	inode = dentry->d_inode;
 	if (inode && !spin_trylock(&inode->i_lock)) {
 relock:
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		cpu_relax();
 		return dentry; /* try again with same dentry */
 	}
@@ -367,7 +367,7 @@ relock:
 		parent = NULL;
 	else
 		parent = dentry->d_parent;
-	if (parent && !spin_trylock(&parent->d_lock)) {
+	if (parent && !seq_spin_trylock(&parent->d_lock)) {
 		if (inode)
 			spin_unlock(&inode->i_lock);
 		goto relock;
@@ -416,11 +416,11 @@ void dput(struct dentry *dentry)
 repeat:
 	if (dentry->d_count == 1)
 		might_sleep();
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	BUG_ON(!dentry->d_count);
 	if (dentry->d_count > 1) {
 		dentry->d_count--;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		return;
 	}
 
@@ -438,7 +438,7 @@ repeat:
 	dentry_lru_add(dentry);
 
 	dentry->d_count--;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return;
 
 kill_it:
@@ -465,9 +465,9 @@ int d_invalidate(struct dentry * dentry)
 	/*
 	 * If it's already been dropped, return OK.
 	 */
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (d_unhashed(dentry)) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		return 0;
 	}
 	/*
@@ -475,9 +475,9 @@ int d_invalidate(struct dentry * dentry)
 	 * to get rid of unused child entries.
 	 */
 	if (!list_empty(&dentry->d_subdirs)) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		shrink_dcache_parent(dentry);
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 	}
 
 	/*
@@ -492,13 +492,13 @@ int d_invalidate(struct dentry * dentry)
 	 */
 	if (dentry->d_count > 1) {
 		if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode)) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			return -EBUSY;
 		}
 	}
 
 	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return 0;
 }
 EXPORT_SYMBOL(d_invalidate);
@@ -511,9 +511,9 @@ static inline void __dget_dlock(struct dentry *dentry)
 
 static inline void __dget(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__dget_dlock(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 struct dentry *dget_parent(struct dentry *dentry)
@@ -531,16 +531,16 @@ repeat:
 		rcu_read_unlock();
 		goto out;
 	}
-	spin_lock(&ret->d_lock);
+	seq_spin_lock(&ret->d_lock);
 	if (unlikely(ret != dentry->d_parent)) {
-		spin_unlock(&ret->d_lock);
+		seq_spin_unlock(&ret->d_lock);
 		rcu_read_unlock();
 		goto repeat;
 	}
 	rcu_read_unlock();
 	BUG_ON(!ret->d_count);
 	ret->d_count++;
-	spin_unlock(&ret->d_lock);
+	seq_spin_unlock(&ret->d_lock);
 out:
 	return ret;
 }
@@ -569,31 +569,31 @@ static struct dentry *__d_find_alias(struct inode *inode, int want_discon)
 again:
 	discon_alias = NULL;
 	list_for_each_entry(alias, &inode->i_dentry, d_alias) {
-		spin_lock(&alias->d_lock);
+		seq_spin_lock(&alias->d_lock);
  		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
 			    (alias->d_flags & DCACHE_DISCONNECTED)) {
 				discon_alias = alias;
 			} else if (!want_discon) {
 				__dget_dlock(alias);
-				spin_unlock(&alias->d_lock);
+				seq_spin_unlock(&alias->d_lock);
 				return alias;
 			}
 		}
-		spin_unlock(&alias->d_lock);
+		seq_spin_unlock(&alias->d_lock);
 	}
 	if (discon_alias) {
 		alias = discon_alias;
-		spin_lock(&alias->d_lock);
+		seq_spin_lock(&alias->d_lock);
 		if (S_ISDIR(inode->i_mode) || !d_unhashed(alias)) {
 			if (IS_ROOT(alias) &&
 			    (alias->d_flags & DCACHE_DISCONNECTED)) {
 				__dget_dlock(alias);
-				spin_unlock(&alias->d_lock);
+				seq_spin_unlock(&alias->d_lock);
 				return alias;
 			}
 		}
-		spin_unlock(&alias->d_lock);
+		seq_spin_unlock(&alias->d_lock);
 		goto again;
 	}
 	return NULL;
@@ -622,16 +622,16 @@ void d_prune_aliases(struct inode *inode)
 restart:
 	spin_lock(&inode->i_lock);
 	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (!dentry->d_count) {
 			__dget_dlock(dentry);
 			__d_drop(dentry);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			spin_unlock(&inode->i_lock);
 			dput(dentry);
 			goto restart;
 		}
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
 	spin_unlock(&inode->i_lock);
 }
@@ -668,10 +668,10 @@ static void try_prune_one_dentry(struct dentry *dentry)
 	/* Prune ancestors. */
 	dentry = parent;
 	while (dentry) {
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (dentry->d_count > 1) {
 			dentry->d_count--;
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			return;
 		}
 		dentry = dentry_kill(dentry, 1);
@@ -687,9 +687,9 @@ static void shrink_dentry_list(struct list_head *list)
 		dentry = list_entry_rcu(list->prev, struct dentry, d_lru);
 		if (&dentry->d_lru == list)
 			break; /* empty */
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (dentry != list_entry(list->prev, struct dentry, d_lru)) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			continue;
 		}
 
@@ -700,7 +700,7 @@ static void shrink_dentry_list(struct list_head *list)
 		 */
 		if (dentry->d_count) {
 			dentry_lru_del(dentry);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			continue;
 		}
 
@@ -736,7 +736,7 @@ relock:
 				struct dentry, d_lru);
 		BUG_ON(dentry->d_sb != sb);
 
-		if (!spin_trylock(&dentry->d_lock)) {
+		if (!seq_spin_trylock(&dentry->d_lock)) {
 			spin_unlock(&dcache_lru_lock);
 			cpu_relax();
 			goto relock;
@@ -751,11 +751,11 @@ relock:
 				dentry->d_flags & DCACHE_REFERENCED) {
 			dentry->d_flags &= ~DCACHE_REFERENCED;
 			list_move(&dentry->d_lru, &referenced);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 		} else {
 			list_move_tail(&dentry->d_lru, &tmp);
 			dentry->d_flags |= DCACHE_SHRINK_LIST;
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			if (!--cnt)
 				break;
 		}
@@ -880,10 +880,10 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 	BUG_ON(!IS_ROOT(dentry));
 
 	/* detach this root from the system */
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dentry_lru_del(dentry);
 	__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 
 	for (;;) {
 		/* descend to the first leaf in the current subtree */
@@ -892,16 +892,16 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 
 			/* this is a branch with children - detach all of them
 			 * from the system in one go */
-			spin_lock(&dentry->d_lock);
+			seq_spin_lock(&dentry->d_lock);
 			list_for_each_entry(loop, &dentry->d_subdirs,
 					    d_u.d_child) {
-				spin_lock_nested(&loop->d_lock,
+				seq_spin_lock_nested(&loop->d_lock,
 						DENTRY_D_LOCK_NESTED);
 				dentry_lru_del(loop);
 				__d_drop(loop);
-				spin_unlock(&loop->d_lock);
+				seq_spin_unlock(&loop->d_lock);
 			}
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 
 			/* move to the first child */
 			dentry = list_entry(dentry->d_subdirs.next,
@@ -933,10 +933,10 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 				list_del(&dentry->d_u.d_child);
 			} else {
 				parent = dentry->d_parent;
-				spin_lock(&parent->d_lock);
+				seq_spin_lock(&parent->d_lock);
 				parent->d_count--;
 				list_del(&dentry->d_u.d_child);
-				spin_unlock(&parent->d_lock);
+				seq_spin_unlock(&parent->d_lock);
 			}
 
 			detached++;
@@ -985,9 +985,9 @@ void shrink_dcache_for_umount(struct super_block *sb)
 
 	dentry = sb->s_root;
 	sb->s_root = NULL;
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dentry->d_count--;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	shrink_dcache_for_umount_subtree(dentry);
 
 	while (!hlist_bl_empty(&sb->s_anon)) {
@@ -1007,8 +1007,8 @@ static struct dentry *try_to_ascend(struct dentry *old, int locked, unsigned seq
 	struct dentry *new = old->d_parent;
 
 	rcu_read_lock();
-	spin_unlock(&old->d_lock);
-	spin_lock(&new->d_lock);
+	seq_spin_unlock(&old->d_lock);
+	seq_spin_lock(&new->d_lock);
 
 	/*
 	 * might go back up the wrong parent if we have had a rename
@@ -1017,7 +1017,7 @@ static struct dentry *try_to_ascend(struct dentry *old, int locked, unsigned seq
 	if (new != old->d_parent ||
 		 (old->d_flags & DCACHE_DISCONNECTED) ||
 		 (!locked && read_seqretry(&rename_lock, seq))) {
-		spin_unlock(&new->d_lock);
+		seq_spin_unlock(&new->d_lock);
 		new = NULL;
 	}
 	rcu_read_unlock();
@@ -1051,7 +1051,7 @@ again:
 
 	if (d_mountpoint(parent))
 		goto positive;
-	spin_lock(&this_parent->d_lock);
+	seq_spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -1060,21 +1060,21 @@ resume:
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
 
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		/* Have we found a mount point ? */
 		if (d_mountpoint(dentry)) {
-			spin_unlock(&dentry->d_lock);
-			spin_unlock(&this_parent->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&this_parent->d_lock);
 			goto positive;
 		}
 		if (!list_empty(&dentry->d_subdirs)) {
-			spin_unlock(&this_parent->d_lock);
-			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
+			seq_spin_unlock(&this_parent->d_lock);
+			spin_release(&dentry->d_lock.lock.dep_map, 1, _RET_IP_);
 			this_parent = dentry;
-			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
+			spin_acquire(&this_parent->d_lock.lock.dep_map, 0, 1, _RET_IP_);
 			goto repeat;
 		}
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
 	/*
 	 * All done at this level ... ascend and resume the search.
@@ -1087,7 +1087,7 @@ resume:
 		next = child->d_u.d_child.next;
 		goto resume;
 	}
-	spin_unlock(&this_parent->d_lock);
+	seq_spin_unlock(&this_parent->d_lock);
 	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	if (locked)
@@ -1132,7 +1132,7 @@ static int select_parent(struct dentry * parent)
 	seq = read_seqbegin(&rename_lock);
 again:
 	this_parent = parent;
-	spin_lock(&this_parent->d_lock);
+	seq_spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -1141,7 +1141,7 @@ resume:
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
 
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 
 		/* 
 		 * move only zero ref count dentries to the end 
@@ -1164,7 +1164,7 @@ resume:
 		 * the rest.
 		 */
 		if (found && need_resched()) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			goto out;
 		}
 
@@ -1172,14 +1172,14 @@ resume:
 		 * Descend a level if the d_subdirs list is non-empty.
 		 */
 		if (!list_empty(&dentry->d_subdirs)) {
-			spin_unlock(&this_parent->d_lock);
-			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
+			seq_spin_unlock(&this_parent->d_lock);
+			spin_release(&dentry->d_lock.lock.dep_map, 1, _RET_IP_);
 			this_parent = dentry;
-			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
+			spin_acquire(&this_parent->d_lock.lock.dep_map, 0, 1, _RET_IP_);
 			goto repeat;
 		}
 
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
 	/*
 	 * All done at this level ... ascend and resume the search.
@@ -1193,7 +1193,7 @@ resume:
 		goto resume;
 	}
 out:
-	spin_unlock(&this_parent->d_lock);
+	seq_spin_unlock(&this_parent->d_lock);
 	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	if (locked)
@@ -1294,8 +1294,7 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 
 	dentry->d_count = 1;
 	dentry->d_flags = 0;
-	spin_lock_init(&dentry->d_lock);
-	seqcount_init(&dentry->d_seq);
+	seqlock_init(&dentry->d_lock);
 	dentry->d_inode = NULL;
 	dentry->d_parent = NULL;
 	dentry->d_sb = NULL;
@@ -1308,7 +1307,7 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 	INIT_LIST_HEAD(&dentry->d_u.d_child);
 
 	if (parent) {
-		spin_lock(&parent->d_lock);
+		seq_spin_lock(&parent->d_lock);
 		/*
 		 * don't need child lock because it is not subject
 		 * to concurrency here
@@ -1318,7 +1317,7 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 		dentry->d_sb = parent->d_sb;
 		d_set_d_op(dentry, dentry->d_sb->s_d_op);
 		list_add(&dentry->d_u.d_child, &parent->d_subdirs);
-		spin_unlock(&parent->d_lock);
+		seq_spin_unlock(&parent->d_lock);
 	}
 
 	this_cpu_inc(nr_dentry);
@@ -1375,7 +1374,7 @@ EXPORT_SYMBOL(d_set_d_op);
 
 static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (inode) {
 		if (unlikely(IS_AUTOMOUNT(inode)))
 			dentry->d_flags |= DCACHE_NEED_AUTOMOUNT;
@@ -1383,7 +1382,7 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 	}
 	dentry->d_inode = inode;
 	dentry_rcuwalk_barrier(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	fsnotify_d_instantiate(dentry, inode);
 }
 
@@ -1589,7 +1588,7 @@ struct dentry *d_obtain_alias(struct inode *inode)
 	}
 
 	/* attach a disconnected dentry */
-	spin_lock(&tmp->d_lock);
+	seq_spin_lock(&tmp->d_lock);
 	tmp->d_sb = inode->i_sb;
 	d_set_d_op(tmp, tmp->d_sb->s_d_op);
 	tmp->d_inode = inode;
@@ -1598,7 +1597,7 @@ struct dentry *d_obtain_alias(struct inode *inode)
 	hlist_bl_lock(&tmp->d_sb->s_anon);
 	hlist_bl_add_head(&tmp->d_hash, &tmp->d_sb->s_anon);
 	hlist_bl_unlock(&tmp->d_sb->s_anon);
-	spin_unlock(&tmp->d_lock);
+	seq_spin_unlock(&tmp->d_lock);
 	spin_unlock(&inode->i_lock);
 	security_d_instantiate(tmp, inode);
 
@@ -1810,7 +1809,7 @@ struct dentry *__d_lookup_rcu(struct dentry *parent, struct qstr *name,
 			continue;
 
 seqretry:
-		*seq = read_seqcount_begin(&dentry->d_seq);
+		*seq = read_seqbegin(&dentry->d_lock);
 		if (dentry->d_parent != parent)
 			continue;
 		if (d_unhashed(dentry))
@@ -1825,7 +1824,7 @@ seqretry:
 		 * edge of memory when walking. If we could load this
 		 * atomically some other way, we could drop this check.
 		 */
-		if (read_seqcount_retry(&dentry->d_seq, *seq))
+		if (read_seqretry(&dentry->d_lock, *seq))
 			goto seqretry;
 		if (parent->d_flags & DCACHE_OP_COMPARE) {
 			if (parent->d_op->d_compare(parent, *inode,
@@ -1928,7 +1927,7 @@ struct dentry *__d_lookup(struct dentry *parent, struct qstr *name)
 		if (dentry->d_name.hash != hash)
 			continue;
 
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (dentry->d_parent != parent)
 			goto next;
 		if (d_unhashed(dentry))
@@ -1952,10 +1951,10 @@ struct dentry *__d_lookup(struct dentry *parent, struct qstr *name)
 
 		dentry->d_count++;
 		found = dentry;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		break;
 next:
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
  	}
  	rcu_read_unlock();
 
@@ -2003,17 +2002,17 @@ int d_validate(struct dentry *dentry, struct dentry *dparent)
 {
 	struct dentry *child;
 
-	spin_lock(&dparent->d_lock);
+	seq_spin_lock(&dparent->d_lock);
 	list_for_each_entry(child, &dparent->d_subdirs, d_u.d_child) {
 		if (dentry == child) {
-			spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+			seq_spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 			__dget_dlock(dentry);
-			spin_unlock(&dentry->d_lock);
-			spin_unlock(&dparent->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dparent->d_lock);
 			return 1;
 		}
 	}
-	spin_unlock(&dparent->d_lock);
+	seq_spin_unlock(&dparent->d_lock);
 
 	return 0;
 }
@@ -2048,12 +2047,12 @@ void d_delete(struct dentry * dentry)
 	 * Are we the only user?
 	 */
 again:
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	inode = dentry->d_inode;
 	isdir = S_ISDIR(inode->i_mode);
 	if (dentry->d_count == 1) {
 		if (inode && !spin_trylock(&inode->i_lock)) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			cpu_relax();
 			goto again;
 		}
@@ -2066,7 +2065,7 @@ again:
 	if (!d_unhashed(dentry))
 		__d_drop(dentry);
 
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 
 	fsnotify_nameremove(dentry, isdir);
 }
@@ -2095,9 +2094,9 @@ static void _d_rehash(struct dentry * entry)
  
 void d_rehash(struct dentry * entry)
 {
-	spin_lock(&entry->d_lock);
+	seq_spin_lock(&entry->d_lock);
 	_d_rehash(entry);
-	spin_unlock(&entry->d_lock);
+	seq_spin_unlock(&entry->d_lock);
 }
 EXPORT_SYMBOL(d_rehash);
 
@@ -2120,11 +2119,9 @@ void dentry_update_name_case(struct dentry *dentry, struct qstr *name)
 	BUG_ON(!mutex_is_locked(&dentry->d_parent->d_inode->i_mutex));
 	BUG_ON(dentry->d_name.len != name->len); /* d_lookup gives this */
 
-	spin_lock(&dentry->d_lock);
-	write_seqcount_begin(&dentry->d_seq);
+	write_seqlock(&dentry->d_lock);
 	memcpy((unsigned char *)dentry->d_name.name, name->name, name->len);
-	write_seqcount_end(&dentry->d_seq);
-	spin_unlock(&dentry->d_lock);
+	write_sequnlock(&dentry->d_lock);
 }
 EXPORT_SYMBOL(dentry_update_name_case);
 
@@ -2175,24 +2172,24 @@ static void dentry_lock_for_move(struct dentry *dentry, struct dentry *target)
 	 * XXXX: do we really need to take target->d_lock?
 	 */
 	if (IS_ROOT(dentry) || dentry->d_parent == target->d_parent)
-		spin_lock(&target->d_parent->d_lock);
+		seq_spin_lock(&target->d_parent->d_lock);
 	else {
 		if (d_ancestor(dentry->d_parent, target->d_parent)) {
-			spin_lock(&dentry->d_parent->d_lock);
-			spin_lock_nested(&target->d_parent->d_lock,
-						DENTRY_D_LOCK_NESTED);
+			seq_spin_lock(&dentry->d_parent->d_lock);
+			seq_spin_lock_nested(&target->d_parent->d_lock,
+					    DENTRY_D_LOCK_NESTED);
 		} else {
-			spin_lock(&target->d_parent->d_lock);
-			spin_lock_nested(&dentry->d_parent->d_lock,
-						DENTRY_D_LOCK_NESTED);
+			seq_spin_lock(&target->d_parent->d_lock);
+			seq_spin_lock_nested(&dentry->d_parent->d_lock,
+					    DENTRY_D_LOCK_NESTED);
 		}
 	}
 	if (target < dentry) {
-		spin_lock_nested(&target->d_lock, 2);
-		spin_lock_nested(&dentry->d_lock, 3);
+		seq_spin_lock_nested(&target->d_lock, 2);
+		seq_spin_lock_nested(&dentry->d_lock, 3);
 	} else {
-		spin_lock_nested(&dentry->d_lock, 2);
-		spin_lock_nested(&target->d_lock, 3);
+		seq_spin_lock_nested(&dentry->d_lock, 2);
+		seq_spin_lock_nested(&target->d_lock, 3);
 	}
 }
 
@@ -2200,9 +2197,9 @@ static void dentry_unlock_parents_for_move(struct dentry *dentry,
 					struct dentry *target)
 {
 	if (target->d_parent != dentry->d_parent)
-		spin_unlock(&dentry->d_parent->d_lock);
+		seq_spin_unlock(&dentry->d_parent->d_lock);
 	if (target->d_parent != target)
-		spin_unlock(&target->d_parent->d_lock);
+		seq_spin_unlock(&target->d_parent->d_lock);
 }
 
 /*
@@ -2235,8 +2232,8 @@ static void __d_move(struct dentry * dentry, struct dentry * target)
 
 	dentry_lock_for_move(dentry, target);
 
-	write_seqcount_begin(&dentry->d_seq);
-	write_seqcount_begin(&target->d_seq);
+	write_seqlock_begin(&dentry->d_lock);
+	write_seqlock_begin(&target->d_lock);
 
 	/* __d_drop does write_seqcount_barrier, but they're OK to nest. */
 
@@ -2271,13 +2268,13 @@ static void __d_move(struct dentry * dentry, struct dentry * target)
 
 	list_add(&dentry->d_u.d_child, &dentry->d_parent->d_subdirs);
 
-	write_seqcount_end(&target->d_seq);
-	write_seqcount_end(&dentry->d_seq);
+	write_seqlock_end(&target->d_lock);
+	write_seqlock_end(&dentry->d_lock);
 
 	dentry_unlock_parents_for_move(dentry, target);
-	spin_unlock(&target->d_lock);
+	seq_spin_unlock(&target->d_lock);
 	fsnotify_d_move(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 /*
@@ -2365,8 +2362,8 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
 
 	dentry_lock_for_move(anon, dentry);
 
-	write_seqcount_begin(&dentry->d_seq);
-	write_seqcount_begin(&anon->d_seq);
+	write_seqlock_begin(&dentry->d_lock);
+	write_seqlock_begin(&anon->d_lock);
 
 	dparent = dentry->d_parent;
 	aparent = anon->d_parent;
@@ -2388,11 +2385,11 @@ static void __d_materialise_dentry(struct dentry *dentry, struct dentry *anon)
 	else
 		INIT_LIST_HEAD(&anon->d_u.d_child);
 
-	write_seqcount_end(&dentry->d_seq);
-	write_seqcount_end(&anon->d_seq);
+	write_seqlock_end(&dentry->d_lock);
+	write_seqlock_end(&anon->d_lock);
 
 	dentry_unlock_parents_for_move(anon, dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 
 	/* anon->d_lock still locked, returns locked */
 	anon->d_flags &= ~DCACHE_DISCONNECTED;
@@ -2459,10 +2456,10 @@ struct dentry *d_materialise_unique(struct dentry *dentry, struct inode *inode)
 	else
 		BUG_ON(!d_unhashed(actual));
 
-	spin_lock(&actual->d_lock);
+	seq_spin_lock(&actual->d_lock);
 found:
 	_d_rehash(actual);
-	spin_unlock(&actual->d_lock);
+	seq_spin_unlock(&actual->d_lock);
 	spin_unlock(&inode->i_lock);
 out_nolock:
 	if (actual == dentry) {
@@ -2523,9 +2520,9 @@ static int prepend_path(const struct path *path,
 		}
 		parent = dentry->d_parent;
 		prefetch(parent);
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		error = prepend_name(buffer, buflen, &dentry->d_name);
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		if (!error)
 			error = prepend(buffer, buflen, "/", 1);
 		if (error)
@@ -2750,9 +2747,9 @@ static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
 		int error;
 
 		prefetch(parent);
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		error = prepend_name(&end, &buflen, &dentry->d_name);
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		if (error != 0 || prepend(&end, &buflen, "/", 1) != 0)
 			goto Elong;
 
@@ -2942,7 +2939,7 @@ void d_genocide(struct dentry *root)
 	seq = read_seqbegin(&rename_lock);
 again:
 	this_parent = root;
-	spin_lock(&this_parent->d_lock);
+	seq_spin_lock(&this_parent->d_lock);
 repeat:
 	next = this_parent->d_subdirs.next;
 resume:
@@ -2951,23 +2948,23 @@ resume:
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
 
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		if (d_unhashed(dentry) || !dentry->d_inode) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			continue;
 		}
 		if (!list_empty(&dentry->d_subdirs)) {
-			spin_unlock(&this_parent->d_lock);
-			spin_release(&dentry->d_lock.dep_map, 1, _RET_IP_);
+			seq_spin_unlock(&this_parent->d_lock);
+			spin_release(&dentry->d_lock.lock.dep_map, 1, _RET_IP_);
 			this_parent = dentry;
-			spin_acquire(&this_parent->d_lock.dep_map, 0, 1, _RET_IP_);
+			spin_acquire(&this_parent->d_lock.lock.dep_map, 0, 1, _RET_IP_);
 			goto repeat;
 		}
 		if (!(dentry->d_flags & DCACHE_GENOCIDE)) {
 			dentry->d_flags |= DCACHE_GENOCIDE;
 			dentry->d_count--;
 		}
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
 	if (this_parent != root) {
 		struct dentry *child = this_parent;
@@ -2981,7 +2978,7 @@ resume:
 		next = child->d_u.d_child.next;
 		goto resume;
 	}
-	spin_unlock(&this_parent->d_lock);
+	seq_spin_unlock(&this_parent->d_lock);
 	if (!locked && read_seqretry(&rename_lock, seq))
 		goto rename_retry;
 	if (locked)
diff --git a/fs/dcookies.c b/fs/dcookies.c
index dda0dc7..3805e33 100644
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -98,9 +98,9 @@ static struct dcookie_struct *alloc_dcookie(struct path *path)
 		return NULL;
 
 	d = path->dentry;
-	spin_lock(&d->d_lock);
+	seq_spin_lock(&d->d_lock);
 	d->d_flags |= DCACHE_COOKIE;
-	spin_unlock(&d->d_lock);
+	seq_spin_unlock(&d->d_lock);
 
 	dcs->path = *path;
 	path_get(path);
@@ -267,9 +267,9 @@ static void free_dcookie(struct dcookie_struct * dcs)
 {
 	struct dentry *d = dcs->path.dentry;
 
-	spin_lock(&d->d_lock);
+	seq_spin_lock(&d->d_lock);
 	d->d_flags &= ~DCACHE_COOKIE;
-	spin_unlock(&d->d_lock);
+	seq_spin_unlock(&d->d_lock);
 
 	path_put(&dcs->path);
 	kmem_cache_free(dcookie_cache, dcs);
diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index b05acb7..4515886 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -114,15 +114,15 @@ reconnect_path(struct vfsmount *mnt, struct dentry *target_dir, char *nbuf)
 
 		if (!IS_ROOT(pd)) {
 			/* must have found a connected parent - great */
-			spin_lock(&pd->d_lock);
+			seq_spin_lock(&pd->d_lock);
 			pd->d_flags &= ~DCACHE_DISCONNECTED;
-			spin_unlock(&pd->d_lock);
+			seq_spin_unlock(&pd->d_lock);
 			noprogress = 0;
 		} else if (pd == mnt->mnt_sb->s_root) {
 			printk(KERN_ERR "export: Eeek filesystem root is not connected, impossible\n");
-			spin_lock(&pd->d_lock);
+			seq_spin_lock(&pd->d_lock);
 			pd->d_flags &= ~DCACHE_DISCONNECTED;
-			spin_unlock(&pd->d_lock);
+			seq_spin_unlock(&pd->d_lock);
 			noprogress = 0;
 		} else {
 			/*
@@ -335,11 +335,11 @@ static int export_encode_fh(struct dentry *dentry, struct fid *fid,
 	if (connectable && !S_ISDIR(inode->i_mode)) {
 		struct inode *parent;
 
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		parent = dentry->d_parent->d_inode;
 		fid->i32.parent_ino = parent->i_ino;
 		fid->i32.parent_gen = parent->i_generation;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		len = 4;
 		type = FILEID_INO32_GEN_PARENT;
 	}
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 44ab357..6df880d 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -770,9 +770,9 @@ fat_encode_fh(struct dentry *de, __u32 *fh, int *lenp, int connectable)
 	fh[1] = inode->i_generation;
 	fh[2] = ipos_h;
 	fh[3] = ipos_m | MSDOS_I(inode)->i_logstart;
-	spin_lock(&de->d_lock);
+	seq_spin_lock(&de->d_lock);
 	fh[4] = ipos_l | MSDOS_I(de->d_parent->d_inode)->i_logstart;
-	spin_unlock(&de->d_lock);
+	seq_spin_unlock(&de->d_lock);
 	return 3;
 }
 
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index 20b4ea5..74a0c20 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -34,10 +34,10 @@
 static int vfat_revalidate_shortname(struct dentry *dentry)
 {
 	int ret = 1;
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (dentry->d_time != dentry->d_parent->d_inode->i_version)
 		ret = 0;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return ret;
 }
 
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index fe190a8..50aed02 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -985,7 +985,7 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 
 		dentry = d_find_alias(inode);
 		if (dentry) {
-			spin_lock(&dentry->d_lock);
+			seq_spin_lock(&dentry->d_lock);
 			name = (const char *) dentry->d_name.name;
 		}
 		printk(KERN_DEBUG
@@ -993,7 +993,7 @@ static noinline void block_dump___mark_inode_dirty(struct inode *inode)
 		       current->comm, task_pid_nr(current), inode->i_ino,
 		       name, inode->i_sb->s_id);
 		if (dentry) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			dput(dentry);
 		}
 	}
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 38f84cd..77e6c1c 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -652,11 +652,11 @@ static int fuse_encode_fh(struct dentry *dentry, u32 *fh, int *max_len,
 	if (encode_parent) {
 		struct inode *parent;
 
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		parent = dentry->d_parent->d_inode;
 		nodeid = get_fuse_inode(parent)->nodeid;
 		generation = parent->i_generation;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 
 		fh[3] = (u32)(nodeid >> 32);
 		fh[4] = (u32)(nodeid & 0xffffffff);
diff --git a/fs/gfs2/export.c b/fs/gfs2/export.c
index fe9945f..dcc2f5a 100644
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -53,11 +53,11 @@ static int gfs2_encode_fh(struct dentry *dentry, __u32 *p, int *len,
 	if (!connectable || inode == sb->s_root->d_inode)
 		return *len;
 
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	inode = dentry->d_parent->d_inode;
 	ip = GFS2_I(inode);
 	igrab(inode);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 
 	fh[4] = cpu_to_be32(ip->i_no_formal_ino >> 32);
 	fh[5] = cpu_to_be32(ip->i_no_formal_ino & 0xFFFFFFFF);
diff --git a/fs/isofs/export.c b/fs/isofs/export.c
index dd4687f..378505b 100644
--- a/fs/isofs/export.c
+++ b/fs/isofs/export.c
@@ -139,13 +139,13 @@ isofs_export_encode_fh(struct dentry *dentry,
 	if (connectable && !S_ISDIR(inode->i_mode)) {
 		struct inode *parent;
 		struct iso_inode_info *eparent;
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		parent = dentry->d_parent->d_inode;
 		eparent = ISOFS_I(parent);
 		fh32[3] = eparent->i_iget5_block;
 		fh16[3] = (__u16)eparent->i_iget5_offset;  /* fh16 [sic] */
 		fh32[4] = parent->i_generation;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		len = 5;
 		type = 2;
 	}
diff --git a/fs/libfs.c b/fs/libfs.c
index 275ca474..b06c1a0 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -100,21 +100,21 @@ loff_t dcache_dir_lseek(struct file *file, loff_t offset, int origin)
 			struct dentry *cursor = file->private_data;
 			loff_t n = file->f_pos - 2;
 
-			spin_lock(&dentry->d_lock);
+			seq_spin_lock(&dentry->d_lock);
 			/* d_lock not required for cursor */
 			list_del(&cursor->d_u.d_child);
 			p = dentry->d_subdirs.next;
 			while (n && p != &dentry->d_subdirs) {
 				struct dentry *next;
 				next = list_entry(p, struct dentry, d_u.d_child);
-				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
+				seq_spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
 				if (simple_positive(next))
 					n--;
-				spin_unlock(&next->d_lock);
+				seq_spin_unlock(&next->d_lock);
 				p = p->next;
 			}
 			list_add_tail(&cursor->d_u.d_child, p);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 		}
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
@@ -157,35 +157,35 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			i++;
 			/* fallthrough */
 		default:
-			spin_lock(&dentry->d_lock);
+			seq_spin_lock(&dentry->d_lock);
 			if (filp->f_pos == 2)
 				list_move(q, &dentry->d_subdirs);
 
 			for (p=q->next; p != &dentry->d_subdirs; p=p->next) {
 				struct dentry *next;
 				next = list_entry(p, struct dentry, d_u.d_child);
-				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
+				seq_spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
 				if (!simple_positive(next)) {
-					spin_unlock(&next->d_lock);
+					seq_spin_unlock(&next->d_lock);
 					continue;
 				}
 
-				spin_unlock(&next->d_lock);
-				spin_unlock(&dentry->d_lock);
+				seq_spin_unlock(&next->d_lock);
+				seq_spin_unlock(&dentry->d_lock);
 				if (filldir(dirent, next->d_name.name, 
 					    next->d_name.len, filp->f_pos, 
 					    next->d_inode->i_ino, 
 					    dt_type(next->d_inode)) < 0)
 					return 0;
-				spin_lock(&dentry->d_lock);
-				spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
+				seq_spin_lock(&dentry->d_lock);
+				seq_spin_lock_nested(&next->d_lock, DENTRY_D_LOCK_NESTED);
 				/* next is still alive */
 				list_move(q, p);
-				spin_unlock(&next->d_lock);
+				seq_spin_unlock(&next->d_lock);
 				p = q;
 				filp->f_pos++;
 			}
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 	}
 	return 0;
 }
@@ -281,18 +281,18 @@ int simple_empty(struct dentry *dentry)
 	struct dentry *child;
 	int ret = 0;
 
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
-		spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
 		if (simple_positive(child)) {
-			spin_unlock(&child->d_lock);
+			seq_spin_unlock(&child->d_lock);
 			goto out;
 		}
-		spin_unlock(&child->d_lock);
+		seq_spin_unlock(&child->d_lock);
 	}
 	ret = 1;
 out:
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return ret;
 }
 
diff --git a/fs/namei.c b/fs/namei.c
index b364372..4993e8f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -429,7 +429,7 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 				nd->root.dentry != fs->root.dentry)
 			goto err_root;
 	}
-	spin_lock(&parent->d_lock);
+	seq_spin_lock(&parent->d_lock);
 	if (!dentry) {
 		if (!__d_rcu_to_refcount(parent, nd->seq))
 			goto err_parent;
@@ -437,7 +437,7 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 	} else {
 		if (dentry->d_parent != parent)
 			goto err_parent;
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 		if (!__d_rcu_to_refcount(dentry, nd->seq))
 			goto err_child;
 		/*
@@ -449,9 +449,9 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 		BUG_ON(!IS_ROOT(dentry) && dentry->d_parent != parent);
 		BUG_ON(!parent->d_count);
 		parent->d_count++;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 	if (want_root) {
 		path_get(&nd->root);
 		seq_spin_unlock(&fs->lock);
@@ -464,9 +464,9 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 	return 0;
 
 err_child:
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 err_parent:
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 err_root:
 	if (want_root)
 		seq_spin_unlock(&fs->lock);
@@ -535,15 +535,15 @@ static int complete_walk(struct nameidata *nd)
 		nd->flags &= ~LOOKUP_RCU;
 		if (!(nd->flags & LOOKUP_ROOT))
 			nd->root.mnt = NULL;
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (unlikely(!__d_rcu_to_refcount(dentry, nd->seq))) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			rcu_read_unlock();
 			br_read_unlock(vfsmount_lock);
 			return -ECHILD;
 		}
 		BUG_ON(nd->inode != dentry->d_inode);
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		mntget(nd->path.mnt);
 		rcu_read_unlock();
 		br_read_unlock(vfsmount_lock);
@@ -621,7 +621,7 @@ static __always_inline void set_root_rcu(struct nameidata *nd)
 		do {
 			seq = read_seqbegin(&fs->lock);
 			nd->root = fs->root;
-			nd->seq = __read_seqcount_begin(&nd->root.dentry->d_seq);
+			nd->seq = __read_seqbegin(&nd->root.dentry->d_lock);
 		} while (read_seqretry(&fs->lock, seq));
 	}
 }
@@ -959,7 +959,7 @@ static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
 		path->mnt = mounted;
 		path->dentry = mounted->mnt_root;
 		nd->flags |= LOOKUP_JUMPED;
-		nd->seq = read_seqcount_begin(&path->dentry->d_seq);
+		nd->seq = read_seqbegin(&path->dentry->d_lock);
 		/*
 		 * Update the inode too. We don't need to re-check the
 		 * dentry sequence number here after this d_inode read,
@@ -979,7 +979,7 @@ static void follow_mount_rcu(struct nameidata *nd)
 			break;
 		nd->path.mnt = mounted;
 		nd->path.dentry = mounted->mnt_root;
-		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
+		nd->seq = read_seqbegin(&nd->path.dentry->d_lock);
 	}
 }
 
@@ -997,8 +997,8 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 			struct dentry *parent = old->d_parent;
 			unsigned seq;
 
-			seq = read_seqcount_begin(&parent->d_seq);
-			if (read_seqcount_retry(&old->d_seq, nd->seq))
+			seq = read_seqbegin(&parent->d_lock);
+			if (read_seqretry(&old->d_lock, nd->seq))
 				goto failed;
 			nd->path.dentry = parent;
 			nd->seq = seq;
@@ -1006,7 +1006,7 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 		}
 		if (!follow_up_rcu(&nd->path))
 			break;
-		nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
+		nd->seq = read_seqbegin(&nd->path.dentry->d_lock);
 	}
 	follow_mount_rcu(nd);
 	nd->inode = nd->path.dentry->d_inode;
@@ -1166,7 +1166,7 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 			goto unlazy;
 
 		/* Memory barrier in read_seqcount_begin of child is enough */
-		if (__read_seqcount_retry(&parent->d_seq, nd->seq))
+		if (__read_seqretry(&parent->d_lock, nd->seq))
 			return -ECHILD;
 		nd->seq = seq;
 
@@ -1473,7 +1473,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		if (flags & LOOKUP_RCU) {
 			br_read_lock(vfsmount_lock);
 			rcu_read_lock();
-			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
+			nd->seq = __read_seqbegin(&nd->path.dentry->d_lock);
 		} else {
 			path_get(&nd->path);
 		}
@@ -1503,7 +1503,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 			do {
 				seq = read_seqbegin(&fs->lock);
 				nd->path = fs->pwd;
-				nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
+				nd->seq = __read_seqbegin(&nd->path.dentry->d_lock);
 			} while (read_seqretry(&fs->lock, seq));
 		} else {
 			get_fs_pwd(current->fs, &nd->path);
@@ -1532,7 +1532,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		if (flags & LOOKUP_RCU) {
 			if (fput_needed)
 				*fp = file;
-			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
+			nd->seq = __read_seqbegin(&nd->path.dentry->d_lock);
 			br_read_lock(vfsmount_lock);
 			rcu_read_lock();
 		} else {
@@ -2591,10 +2591,10 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, int, mode)
 void dentry_unhash(struct dentry *dentry)
 {
 	shrink_dcache_parent(dentry);
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (dentry->d_count == 1)
 		__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 int vfs_rmdir(struct inode *dir, struct dentry *dentry)
diff --git a/fs/namespace.c b/fs/namespace.c
index 472caea..c563781 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -564,9 +564,9 @@ static void dentry_reset_mounted(struct vfsmount *mnt, struct dentry *dentry)
 				return;
 		}
 	}
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dentry->d_flags &= ~DCACHE_MOUNTED;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 /*
@@ -591,9 +591,9 @@ void mnt_set_mountpoint(struct vfsmount *mnt, struct dentry *dentry,
 {
 	child_mnt->mnt_parent = mntget(mnt);
 	child_mnt->mnt_mountpoint = dget(dentry);
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dentry->d_flags |= DCACHE_MOUNTED;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 /*
diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 9c51f62..3c7d069 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -388,7 +388,7 @@ ncp_dget_fpos(struct dentry *dentry, struct dentry *parent, unsigned long fpos)
 	}
 
 	/* If a pointer is invalid, we search the dentry. */
-	spin_lock(&parent->d_lock);
+	seq_spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dent = list_entry(next, struct dentry, d_u.d_child);
@@ -397,12 +397,12 @@ ncp_dget_fpos(struct dentry *dentry, struct dentry *parent, unsigned long fpos)
 				dget(dent);
 			else
 				dent = NULL;
-			spin_unlock(&parent->d_lock);
+			seq_spin_unlock(&parent->d_lock);
 			goto out;
 		}
 		next = next->next;
 	}
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 	return NULL;
 
 out:
diff --git a/fs/ncpfs/ncplib_kernel.h b/fs/ncpfs/ncplib_kernel.h
index 09881e6..d9ac5e5 100644
--- a/fs/ncpfs/ncplib_kernel.h
+++ b/fs/ncpfs/ncplib_kernel.h
@@ -191,7 +191,7 @@ ncp_renew_dentries(struct dentry *parent)
 	struct list_head *next;
 	struct dentry *dentry;
 
-	spin_lock(&parent->d_lock);
+	seq_spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dentry = list_entry(next, struct dentry, d_u.d_child);
@@ -203,7 +203,7 @@ ncp_renew_dentries(struct dentry *parent)
 
 		next = next->next;
 	}
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 }
 
 static inline void
@@ -213,7 +213,7 @@ ncp_invalidate_dircache_entries(struct dentry *parent)
 	struct list_head *next;
 	struct dentry *dentry;
 
-	spin_lock(&parent->d_lock);
+	seq_spin_lock(&parent->d_lock);
 	next = parent->d_subdirs.next;
 	while (next != &parent->d_subdirs) {
 		dentry = list_entry(next, struct dentry, d_u.d_child);
@@ -221,7 +221,7 @@ ncp_invalidate_dircache_entries(struct dentry *parent)
 		ncp_age_dentry(server, dentry);
 		next = next->next;
 	}
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 }
 
 struct ncp_cache_head {
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 462a006..e0ce566 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1813,9 +1813,9 @@ static int nfs_unlink(struct inode *dir, struct dentry *dentry)
 	dfprintk(VFS, "NFS: unlink(%s/%ld, %s)\n", dir->i_sb->s_id,
 		dir->i_ino, dentry->d_name.name);
 
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (dentry->d_count > 1) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		/* Start asynchronous writeout of the inode */
 		write_inode_now(dentry->d_inode, 0);
 		error = nfs_sillyrename(dir, dentry);
@@ -1825,7 +1825,7 @@ static int nfs_unlink(struct inode *dir, struct dentry *dentry)
 		__d_drop(dentry);
 		need_rehash = 1;
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	error = nfs_safe_remove(dentry);
 	if (!error || error == -ENOENT) {
 		nfs_set_verifier(dentry, nfs_save_change_attribute(dir));
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index dcb6154..02ecd4d 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -64,9 +64,9 @@ static int nfs_superblock_set_dummy_root(struct super_block *sb, struct inode *i
 		 * Oops, since the test for IS_ROOT() will fail.
 		 */
 		spin_lock(&sb->s_root->d_inode->i_lock);
-		spin_lock(&sb->s_root->d_lock);
+		seq_spin_lock(&sb->s_root->d_lock);
 		list_del_init(&sb->s_root->d_alias);
-		spin_unlock(&sb->s_root->d_lock);
+		seq_spin_unlock(&sb->s_root->d_lock);
 		spin_unlock(&sb->s_root->d_inode->i_lock);
 	}
 	return 0;
@@ -126,12 +126,12 @@ struct dentry *nfs_get_root(struct super_block *sb, struct nfs_fh *mntfh,
 	}
 
 	security_d_instantiate(ret, inode);
-	spin_lock(&ret->d_lock);
+	seq_spin_lock(&ret->d_lock);
 	if (IS_ROOT(ret) && !(ret->d_flags & DCACHE_NFSFS_RENAMED)) {
 		ret->d_fsdata = name;
 		name = NULL;
 	}
-	spin_unlock(&ret->d_lock);
+	seq_spin_unlock(&ret->d_lock);
 out:
 	if (name)
 		kfree(name);
@@ -250,12 +250,12 @@ struct dentry *nfs4_get_root(struct super_block *sb, struct nfs_fh *mntfh,
 	}
 
 	security_d_instantiate(ret, inode);
-	spin_lock(&ret->d_lock);
+	seq_spin_lock(&ret->d_lock);
 	if (IS_ROOT(ret) && !(ret->d_flags & DCACHE_NFSFS_RENAMED)) {
 		ret->d_fsdata = name;
 		name = NULL;
 	}
-	spin_unlock(&ret->d_lock);
+	seq_spin_unlock(&ret->d_lock);
 out:
 	if (name)
 		kfree(name);
diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 1f063ba..4b3ffaa 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -60,7 +60,7 @@ rename_retry:
 	seq = read_seqbegin(&rename_lock);
 	rcu_read_lock();
 	while (1) {
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (IS_ROOT(dentry))
 			break;
 		namelen = dentry->d_name.len;
@@ -70,17 +70,17 @@ rename_retry:
 		end -= namelen;
 		memcpy(end, dentry->d_name.name, namelen);
 		*--end = '/';
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		dentry = dentry->d_parent;
 	}
 	if (read_seqretry(&rename_lock, seq)) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		rcu_read_unlock();
 		goto rename_retry;
 	}
 	if (*end != '/') {
 		if (--buflen < 0) {
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			rcu_read_unlock();
 			goto Elong;
 		}
@@ -89,7 +89,7 @@ rename_retry:
 	*p = end;
 	base = dentry->d_fsdata;
 	if (!base) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		rcu_read_unlock();
 		WARN_ON(1);
 		return end;
@@ -100,17 +100,17 @@ rename_retry:
 		namelen--;
 	buflen -= namelen;
 	if (buflen < 0) {
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		rcu_read_unlock();
 		goto Elong;
 	}
 	end -= namelen;
 	memcpy(end, base, namelen);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	rcu_read_unlock();
 	return end;
 Elong_unlock:
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	rcu_read_unlock();
 	if (read_seqretry(&rename_lock, seq))
 		goto rename_retry;
diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index 8d6864c..5d2740d 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -155,7 +155,7 @@ static int nfs_do_call_unlink(struct dentry *parent, struct inode *dir, struct n
 		 * the sillyrename information to the aliased dentry.
 		 */
 		nfs_free_dname(data);
-		spin_lock(&alias->d_lock);
+		seq_spin_lock(&alias->d_lock);
 		if (alias->d_inode != NULL &&
 		    !(alias->d_flags & DCACHE_NFSFS_RENAMED)) {
 			devname_garbage = alias->d_fsdata;
@@ -163,7 +163,7 @@ static int nfs_do_call_unlink(struct dentry *parent, struct inode *dir, struct n
 			alias->d_flags |= DCACHE_NFSFS_RENAMED;
 			ret = 1;
 		}
-		spin_unlock(&alias->d_lock);
+		seq_spin_unlock(&alias->d_lock);
 		nfs_dec_sillycount(dir);
 		dput(alias);
 		/*
@@ -275,13 +275,13 @@ nfs_async_unlink(struct inode *dir, struct dentry *dentry)
 	data->res.dir_attr = &data->dir_attr;
 
 	status = -EBUSY;
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (dentry->d_flags & DCACHE_NFSFS_RENAMED)
 		goto out_unlock;
 	dentry->d_flags |= DCACHE_NFSFS_RENAMED;
 	devname_garbage = dentry->d_fsdata;
 	dentry->d_fsdata = data;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	/*
 	 * If we'd displaced old cached devname, free it.  At that
 	 * point dentry is definitely not a root, so we won't need
@@ -291,7 +291,7 @@ nfs_async_unlink(struct inode *dir, struct dentry *dentry)
 		kfree(devname_garbage);
 	return 0;
 out_unlock:
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	put_rpccred(data->cred);
 out_free:
 	kfree(data);
@@ -313,13 +313,13 @@ nfs_complete_unlink(struct dentry *dentry, struct inode *inode)
 {
 	struct nfs_unlinkdata	*data = NULL;
 
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (dentry->d_flags & DCACHE_NFSFS_RENAMED) {
 		dentry->d_flags &= ~DCACHE_NFSFS_RENAMED;
 		data = dentry->d_fsdata;
 		dentry->d_fsdata = NULL;
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 
 	if (data != NULL && (NFS_STALE(inode) || !nfs_call_unlink(dentry, data)))
 		nfs_free_unlinkdata(data);
@@ -329,17 +329,17 @@ nfs_complete_unlink(struct dentry *dentry, struct inode *inode)
 static void
 nfs_cancel_async_unlink(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	if (dentry->d_flags & DCACHE_NFSFS_RENAMED) {
 		struct nfs_unlinkdata *data = dentry->d_fsdata;
 
 		dentry->d_flags &= ~DCACHE_NFSFS_RENAMED;
 		dentry->d_fsdata = NULL;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		nfs_free_unlinkdata(data);
 		return;
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 struct nfs_renamedata {
diff --git a/fs/nilfs2/namei.c b/fs/nilfs2/namei.c
index 546849b..e068a66 100644
--- a/fs/nilfs2/namei.c
+++ b/fs/nilfs2/namei.c
@@ -543,11 +543,11 @@ static int nilfs_encode_fh(struct dentry *dentry, __u32 *fh, int *lenp,
 	if (connectable && !S_ISDIR(inode->i_mode)) {
 		struct inode *parent;
 
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		parent = dentry->d_parent->d_inode;
 		fid->parent_ino = parent->i_ino;
 		fid->parent_gen = parent->i_generation;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 
 		type = FILEID_NILFS_WITH_PARENT;
 		*lenp = NILFS_FID_SIZE_CONNECTABLE;
diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index 79b47cb..f3c5bd5 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -68,19 +68,19 @@ void __fsnotify_update_child_dentry_flags(struct inode *inode)
 		/* run all of the children of the original inode and fix their
 		 * d_flags to indicate parental interest (their parent is the
 		 * original inode) */
-		spin_lock(&alias->d_lock);
+		seq_spin_lock(&alias->d_lock);
 		list_for_each_entry(child, &alias->d_subdirs, d_u.d_child) {
 			if (!child->d_inode)
 				continue;
 
-			spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
+			seq_spin_lock_nested(&child->d_lock, DENTRY_D_LOCK_NESTED);
 			if (watched)
 				child->d_flags |= DCACHE_FSNOTIFY_PARENT_WATCHED;
 			else
 				child->d_flags &= ~DCACHE_FSNOTIFY_PARENT_WATCHED;
-			spin_unlock(&child->d_lock);
+			seq_spin_unlock(&child->d_lock);
 		}
-		spin_unlock(&alias->d_lock);
+		seq_spin_unlock(&alias->d_lock);
 	}
 	spin_unlock(&inode->i_lock);
 }
diff --git a/fs/notify/vfsmount_mark.c b/fs/notify/vfsmount_mark.c
index e86577d..2384a34 100644
--- a/fs/notify/vfsmount_mark.c
+++ b/fs/notify/vfsmount_mark.c
@@ -35,13 +35,13 @@ void fsnotify_clear_marks_by_mount(struct vfsmount *mnt)
 	struct hlist_node *pos, *n;
 	LIST_HEAD(free_list);
 
-	spin_lock(&mnt->mnt_root->d_lock);
+	seq_spin_lock(&mnt->mnt_root->d_lock);
 	hlist_for_each_entry_safe(mark, pos, n, &mnt->mnt_fsnotify_marks, m.m_list) {
 		list_add(&mark->m.free_m_list, &free_list);
 		hlist_del_init_rcu(&mark->m.m_list);
 		fsnotify_get_mark(mark);
 	}
-	spin_unlock(&mnt->mnt_root->d_lock);
+	seq_spin_unlock(&mnt->mnt_root->d_lock);
 
 	list_for_each_entry_safe(mark, lmark, &free_list, m.free_m_list) {
 		fsnotify_destroy_mark(mark);
@@ -63,7 +63,7 @@ static void fsnotify_recalc_vfsmount_mask_locked(struct vfsmount *mnt)
 	struct hlist_node *pos;
 	__u32 new_mask = 0;
 
-	assert_spin_locked(&mnt->mnt_root->d_lock);
+	assert_seq_spin_locked(&mnt->mnt_root->d_lock);
 
 	hlist_for_each_entry(mark, pos, &mnt->mnt_fsnotify_marks, m.m_list)
 		new_mask |= mark->mask;
@@ -76,9 +76,9 @@ static void fsnotify_recalc_vfsmount_mask_locked(struct vfsmount *mnt)
  */
 void fsnotify_recalc_vfsmount_mask(struct vfsmount *mnt)
 {
-	spin_lock(&mnt->mnt_root->d_lock);
+	seq_spin_lock(&mnt->mnt_root->d_lock);
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
-	spin_unlock(&mnt->mnt_root->d_lock);
+	seq_spin_unlock(&mnt->mnt_root->d_lock);
 }
 
 void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark)
@@ -88,14 +88,14 @@ void fsnotify_destroy_vfsmount_mark(struct fsnotify_mark *mark)
 	assert_spin_locked(&mark->lock);
 	assert_spin_locked(&mark->group->mark_lock);
 
-	spin_lock(&mnt->mnt_root->d_lock);
+	seq_spin_lock(&mnt->mnt_root->d_lock);
 
 	hlist_del_init_rcu(&mark->m.m_list);
 	mark->m.mnt = NULL;
 
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
 
-	spin_unlock(&mnt->mnt_root->d_lock);
+	seq_spin_unlock(&mnt->mnt_root->d_lock);
 }
 
 static struct fsnotify_mark *fsnotify_find_vfsmount_mark_locked(struct fsnotify_group *group,
@@ -104,7 +104,7 @@ static struct fsnotify_mark *fsnotify_find_vfsmount_mark_locked(struct fsnotify_
 	struct fsnotify_mark *mark;
 	struct hlist_node *pos;
 
-	assert_spin_locked(&mnt->mnt_root->d_lock);
+	assert_seq_spin_locked(&mnt->mnt_root->d_lock);
 
 	hlist_for_each_entry(mark, pos, &mnt->mnt_fsnotify_marks, m.m_list) {
 		if (mark->group == group) {
@@ -124,9 +124,9 @@ struct fsnotify_mark *fsnotify_find_vfsmount_mark(struct fsnotify_group *group,
 {
 	struct fsnotify_mark *mark;
 
-	spin_lock(&mnt->mnt_root->d_lock);
+	seq_spin_lock(&mnt->mnt_root->d_lock);
 	mark = fsnotify_find_vfsmount_mark_locked(group, mnt);
-	spin_unlock(&mnt->mnt_root->d_lock);
+	seq_spin_unlock(&mnt->mnt_root->d_lock);
 
 	return mark;
 }
@@ -149,7 +149,7 @@ int fsnotify_add_vfsmount_mark(struct fsnotify_mark *mark,
 	assert_spin_locked(&mark->lock);
 	assert_spin_locked(&group->mark_lock);
 
-	spin_lock(&mnt->mnt_root->d_lock);
+	seq_spin_lock(&mnt->mnt_root->d_lock);
 
 	mark->m.mnt = mnt;
 
@@ -184,7 +184,7 @@ int fsnotify_add_vfsmount_mark(struct fsnotify_mark *mark,
 	hlist_add_after_rcu(last, &mark->m.m_list);
 out:
 	fsnotify_recalc_vfsmount_mask_locked(mnt);
-	spin_unlock(&mnt->mnt_root->d_lock);
+	seq_spin_unlock(&mnt->mnt_root->d_lock);
 
 	return ret;
 }
diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
index e5ba348..d59a4c7 100644
--- a/fs/ocfs2/dcache.c
+++ b/fs/ocfs2/dcache.c
@@ -177,16 +177,16 @@ struct dentry *ocfs2_find_local_alias(struct inode *inode,
 	list_for_each(p, &inode->i_dentry) {
 		dentry = list_entry(p, struct dentry, d_alias);
 
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		if (ocfs2_match_dentry(dentry, parent_blkno, skip_unhashed)) {
 			trace_ocfs2_find_local_alias(dentry->d_name.len,
 						     dentry->d_name.name);
 
 			dget_dlock(dentry);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			break;
 		}
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 
 		dentry = NULL;
 	}
diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
index 745db42..b48fa52 100644
--- a/fs/ocfs2/export.c
+++ b/fs/ocfs2/export.c
@@ -214,7 +214,7 @@ static int ocfs2_encode_fh(struct dentry *dentry, u32 *fh_in, int *max_len,
 	if (connectable && !S_ISDIR(inode->i_mode)) {
 		struct inode *parent;
 
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 
 		parent = dentry->d_parent->d_inode;
 		blkno = OCFS2_I(parent)->ip_blkno;
@@ -224,7 +224,7 @@ static int ocfs2_encode_fh(struct dentry *dentry, u32 *fh_in, int *max_len,
 		fh[4] = cpu_to_le32((u32)(blkno & 0xffffffff));
 		fh[5] = cpu_to_le32(generation);
 
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 
 		len = 6;
 		type = 2;
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 4fd5bb3..8307f15 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1609,7 +1609,7 @@ int reiserfs_encode_fh(struct dentry *dentry, __u32 * data, int *lenp,
 	if (maxlen < 5 || !need_parent)
 		return 3;
 
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	inode = dentry->d_parent->d_inode;
 	data[3] = inode->i_ino;
 	data[4] = le32_to_cpu(INODE_PKEY(inode)->k_dir_id);
@@ -1618,7 +1618,7 @@ int reiserfs_encode_fh(struct dentry *dentry, __u32 * data, int *lenp,
 		data[5] = inode->i_generation;
 		*lenp = 6;
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return *lenp;
 }
 
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index f1dce84..e2487a0 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1300,13 +1300,13 @@ static int udf_encode_fh(struct dentry *de, __u32 *fh, int *lenp,
 	fid->udf.generation = inode->i_generation;
 
 	if (connectable && !S_ISDIR(inode->i_mode)) {
-		spin_lock(&de->d_lock);
+		seq_spin_lock(&de->d_lock);
 		inode = de->d_parent->d_inode;
 		location = UDF_I(inode)->i_location;
 		fid->udf.parent_block = location.logicalBlockNum;
 		fid->udf.parent_partref = location.partitionReferenceNum;
 		fid->udf.parent_generation = inode->i_generation;
-		spin_unlock(&de->d_lock);
+		seq_spin_unlock(&de->d_lock);
 		*lenp = 5;
 		type = FILEID_UDF_WITH_PARENT;
 	}
diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
index fed3f3c..0470488 100644
--- a/fs/xfs/linux-2.6/xfs_export.c
+++ b/fs/xfs/linux-2.6/xfs_export.c
@@ -97,20 +97,20 @@ xfs_fs_encode_fh(
 
 	switch (fileid_type) {
 	case FILEID_INO32_GEN_PARENT:
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		fid->i32.parent_ino = XFS_I(dentry->d_parent->d_inode)->i_ino;
 		fid->i32.parent_gen = dentry->d_parent->d_inode->i_generation;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		/*FALLTHRU*/
 	case FILEID_INO32_GEN:
 		fid->i32.ino = XFS_I(inode)->i_ino;
 		fid->i32.gen = inode->i_generation;
 		break;
 	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		fid64->parent_ino = XFS_I(dentry->d_parent->d_inode)->i_ino;
 		fid64->parent_gen = dentry->d_parent->d_inode->i_generation;
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 		/*FALLTHRU*/
 	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
 		fid64->ino = XFS_I(inode)->i_ino;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index f13bb6d..92e23a0 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -116,7 +116,7 @@ full_name_hash(const unsigned char *name, unsigned int len)
 struct dentry {
 	/* RCU lookup touched fields */
 	unsigned int d_flags;		/* protected by d_lock */
-	seqcount_t d_seq;		/* per dentry seqlock */
+	seqlock_t d_lock;		/* per dentry seqlock */
 	struct hlist_bl_node d_hash;	/* lookup hash list */
 	struct dentry *d_parent;	/* parent directory */
 	struct qstr d_name;
@@ -126,7 +126,6 @@ struct dentry {
 
 	/* Ref lookup also touches following */
 	unsigned int d_count;		/* protected by d_lock */
-	spinlock_t d_lock;		/* per dentry lock */
 	const struct dentry_operations *d_op;
 	struct super_block *d_sb;	/* The root of the dentry tree */
 	unsigned long d_time;		/* used by d_revalidate */
@@ -324,8 +323,8 @@ static inline int __d_rcu_to_refcount(struct dentry *dentry, unsigned seq)
 {
 	int ret = 0;
 
-	assert_spin_locked(&dentry->d_lock);
-	if (!read_seqcount_retry(&dentry->d_seq, seq)) {
+	assert_seq_spin_locked(&dentry->d_lock);
+	if (!read_seqretry(&dentry->d_lock, seq)) {
 		ret = 1;
 		dentry->d_count++;
 	}
@@ -368,9 +367,9 @@ static inline struct dentry *dget_dlock(struct dentry *dentry)
 static inline struct dentry *dget(struct dentry *dentry)
 {
 	if (dentry) {
-		spin_lock(&dentry->d_lock);
+		seq_spin_lock(&dentry->d_lock);
 		dget_dlock(dentry);
-		spin_unlock(&dentry->d_lock);
+		seq_spin_unlock(&dentry->d_lock);
 	}
 	return dentry;
 }
@@ -401,9 +400,9 @@ static inline int cant_mount(struct dentry *dentry)
 
 static inline void dont_mount(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	dentry->d_flags |= DCACHE_CANT_MOUNT;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 extern void dput(struct dentry *);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 223bdde..9c85217 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2500,9 +2500,9 @@ static inline ino_t parent_ino(struct dentry *dentry)
 	 * Don't strictly need d_lock here? If the parent ino could change
 	 * then surely we'd have a deeper race in the caller?
 	 */
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	res = dentry->d_parent->d_inode->i_ino;
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 	return res;
 }
 
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index 69ad89b..82d6939 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -329,7 +329,7 @@ static inline void __fsnotify_update_dcache_flags(struct dentry *dentry)
 {
 	struct dentry *parent;
 
-	assert_spin_locked(&dentry->d_lock);
+	assert_seq_spin_locked(&dentry->d_lock);
 
 	/*
 	 * Serialisation of setting PARENT_WATCHED on the dentries is provided
@@ -353,9 +353,9 @@ static inline void __fsnotify_d_instantiate(struct dentry *dentry, struct inode
 	if (!inode)
 		return;
 
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	__fsnotify_update_dcache_flags(dentry);
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 /* called from fsnotify listeners, such as fanotify or dnotify */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index feb47ec..761816c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -868,29 +868,29 @@ static void cgroup_clear_directory(struct dentry *dentry)
 	struct list_head *node;
 
 	BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
-	spin_lock(&dentry->d_lock);
+	seq_spin_lock(&dentry->d_lock);
 	node = dentry->d_subdirs.next;
 	while (node != &dentry->d_subdirs) {
 		struct dentry *d = list_entry(node, struct dentry, d_u.d_child);
 
-		spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
 		list_del_init(node);
 		if (d->d_inode) {
 			/* This should never be called on a cgroup
 			 * directory with child cgroups */
 			BUG_ON(d->d_inode->i_mode & S_IFDIR);
 			dget_dlock(d);
-			spin_unlock(&d->d_lock);
-			spin_unlock(&dentry->d_lock);
+			seq_spin_unlock(&d->d_lock);
+			seq_spin_unlock(&dentry->d_lock);
 			d_delete(d);
 			simple_unlink(dentry->d_inode, d);
 			dput(d);
-			spin_lock(&dentry->d_lock);
+			seq_spin_lock(&dentry->d_lock);
 		} else
-			spin_unlock(&d->d_lock);
+			seq_spin_unlock(&d->d_lock);
 		node = dentry->d_subdirs.next;
 	}
-	spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
 }
 
 /*
@@ -903,11 +903,11 @@ static void cgroup_d_remove_dir(struct dentry *dentry)
 	cgroup_clear_directory(dentry);
 
 	parent = dentry->d_parent;
-	spin_lock(&parent->d_lock);
-	spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+	seq_spin_lock(&parent->d_lock);
+	seq_spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 	list_del_init(&dentry->d_u.d_child);
-	spin_unlock(&dentry->d_lock);
-	spin_unlock(&parent->d_lock);
+	seq_spin_unlock(&dentry->d_lock);
+	seq_spin_unlock(&parent->d_lock);
 	remove_dir(dentry);
 }
 
diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 72bc536..aeb9960 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -377,14 +377,14 @@ rpc_info_open(struct inode *inode, struct file *file)
 	if (!ret) {
 		struct seq_file *m = file->private_data;
 
-		spin_lock(&file->f_path.dentry->d_lock);
+		seq_spin_lock(&file->f_path.dentry->d_lock);
 		if (!d_unhashed(file->f_path.dentry))
 			clnt = RPC_I(inode)->private;
 		if (clnt != NULL && atomic_inc_not_zero(&clnt->cl_count)) {
-			spin_unlock(&file->f_path.dentry->d_lock);
+			seq_spin_unlock(&file->f_path.dentry->d_lock);
 			m->private = clnt;
 		} else {
-			spin_unlock(&file->f_path.dentry->d_lock);
+			seq_spin_unlock(&file->f_path.dentry->d_lock);
 			single_release(inode, file);
 			ret = -EINVAL;
 		}
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 3545934..f188c79 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1197,28 +1197,28 @@ static void sel_remove_entries(struct dentry *de)
 {
 	struct list_head *node;
 
-	spin_lock(&de->d_lock);
+	seq_spin_lock(&de->d_lock);
 	node = de->d_subdirs.next;
 	while (node != &de->d_subdirs) {
 		struct dentry *d = list_entry(node, struct dentry, d_u.d_child);
 
-		spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
+		seq_spin_lock_nested(&d->d_lock, DENTRY_D_LOCK_NESTED);
 		list_del_init(node);
 
 		if (d->d_inode) {
 			dget_dlock(d);
-			spin_unlock(&de->d_lock);
-			spin_unlock(&d->d_lock);
+			seq_spin_unlock(&de->d_lock);
+			seq_spin_unlock(&d->d_lock);
 			d_delete(d);
 			simple_unlink(de->d_inode, d);
 			dput(d);
-			spin_lock(&de->d_lock);
+			seq_spin_lock(&de->d_lock);
 		} else
-			spin_unlock(&d->d_lock);
+			seq_spin_unlock(&d->d_lock);
 		node = de->d_subdirs.next;
 	}
 
-	spin_unlock(&de->d_lock);
+	seq_spin_unlock(&de->d_lock);
 }
 
 #define BOOL_DIR_NAME "booleans"
-- 
1.7.8.3


