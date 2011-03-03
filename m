Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab1CCQ60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:58:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab1CCQ6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:58:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/3] Make VFS handle mount autoexpiry
To: viro@ZenIV.linux.org.uk, hch@infradead.org, raven@themaw.net
Cc: linux-devel@vger.kernel.org, autofs@linux.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Thu, 03 Mar 2011 16:57:48 +0000
Message-ID: <20110303165748.9550.25913.stgit@warthog.procyon.org.uk>
In-Reply-To: <20110303165738.9550.2251.stgit@warthog.procyon.org.uk>
References: <20110303165738.9550.2251.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the VFS handle mount autoexpiry, rather than doing it in the filesystems
(such as AFS, CIFS and NFS).  This simplifies the reference counting, since
do_add_mount() once again adds mounts to the expiration list, and simplifies
the filesystems since they no longer have to do anything barring set
MNT_EXPIRABLE on an expirable mount before returning it.

Additionally, provide a tuning knob to set the periodicity of the reaper in
seconds:

	/proc/sys/fs/mount-expiry-period

The default is 10 minutes.

The NFS sysctl (nfs_mountpoint_timeout) is removed in its favour.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/filesystems/vfs.txt |    7 +-
 fs/afs/internal.h                 |    1 
 fs/afs/mntpt.c                    |   60 ++-------------------
 fs/afs/super.c                    |    1 
 fs/cifs/cifs_dfs_ref.c            |   53 ++-----------------
 fs/cifs/cifsfs.c                  |    3 -
 fs/cifs/cifsproto.h               |    1 
 fs/namei.c                        |    8 +--
 fs/namespace.c                    |  106 ++++++++++++++++---------------------
 fs/nfs/client.c                   |    1 
 fs/nfs/namespace.c                |   26 ---------
 fs/nfs/sysctl.c                   |    7 --
 include/linux/mount.h             |    5 +-
 kernel/sysctl.c                   |   11 ++++
 14 files changed, 76 insertions(+), 214 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index c6878a0..3a40c31 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -943,10 +943,9 @@ struct dentry_operations {
 	ordinary directory and returned to pathwalk to continue walking.
 
 	If a vfsmount is returned, the caller will attempt to mount it on the
-	mountpoint and will remove the vfsmount from its expiration list in
-	the case of failure.  The vfsmount should be returned with 2 refs on
-	it to prevent automatic expiration - the caller will clean up the
-	additional ref.
+	mountpoint and will clean it up on failure.  If mnt_expiry_mark is set
+	on the vfsmount, the caller will add it to the global expiration list
+	if successfully mounted and clear the mark.
 
 	This function is only used if DCACHE_NEED_AUTOMOUNT is set on the
 	dentry.  This is set by __d_instantiate() if S_AUTOMOUNT is set on the
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 5a9b684..cb7d2c7 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -594,7 +594,6 @@ extern const struct file_operations afs_mntpt_file_operations;
 
 extern struct vfsmount *afs_d_automount(struct path *);
 extern int afs_mntpt_check_symlink(struct afs_vnode *, struct key *);
-extern void afs_mntpt_kill_timer(void);
 
 /*
  * proc.c
diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index aa59184..74b43b9 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -24,7 +24,6 @@ static struct dentry *afs_mntpt_lookup(struct inode *dir,
 				       struct dentry *dentry,
 				       struct nameidata *nd);
 static int afs_mntpt_open(struct inode *inode, struct file *file);
-static void afs_mntpt_expiry_timed_out(struct work_struct *work);
 
 const struct file_operations afs_mntpt_file_operations = {
 	.open		= afs_mntpt_open,
@@ -41,11 +40,6 @@ const struct inode_operations afs_autocell_inode_operations = {
 	.getattr	= afs_getattr,
 };
 
-static LIST_HEAD(afs_vfsmounts);
-static DECLARE_DELAYED_WORK(afs_mntpt_expiry_timer, afs_mntpt_expiry_timed_out);
-
-static unsigned long afs_mntpt_expiry_timeout = 10 * 60;
-
 /*
  * check a symbolic link to see whether it actually encodes a mountpoint
  * - sets the AFS_VNODE_MOUNTPOINT flag on the vnode appropriately
@@ -136,11 +130,12 @@ static int afs_mntpt_open(struct inode *inode, struct file *file)
 /*
  * create a vfsmount to be automounted
  */
-static struct vfsmount *afs_mntpt_do_automount(struct dentry *mntpt)
+struct vfsmount *afs_d_automount(struct path *mountpoint)
 {
 	struct afs_super_info *super;
 	struct vfsmount *mnt;
 	struct afs_vnode *vnode;
+	struct dentry *mntpt = mountpoint->dentry;
 	struct page *page;
 	char *devname, *options;
 	bool rwpath = false;
@@ -219,6 +214,9 @@ static struct vfsmount *afs_mntpt_do_automount(struct dentry *mntpt)
 	mnt = vfs_kern_mount(&afs_fs_type, 0, devname, options);
 	_debug("--- mount result %p ---", mnt);
 
+	if (!IS_ERR(mnt))
+		mnt->mnt_expiry_mark = 1;
+
 	free_page((unsigned long) devname);
 	free_page((unsigned long) options);
 	_leave(" = %p", mnt);
@@ -234,51 +232,3 @@ error_no_devname:
 	_leave(" = %d", ret);
 	return ERR_PTR(ret);
 }
-
-/*
- * handle an automount point
- */
-struct vfsmount *afs_d_automount(struct path *path)
-{
-	struct vfsmount *newmnt;
-
-	_enter("{%s,%s}", path->mnt->mnt_devname, path->dentry->d_name.name);
-
-	newmnt = afs_mntpt_do_automount(path->dentry);
-	if (IS_ERR(newmnt))
-		return newmnt;
-
-	mntget(newmnt); /* prevent immediate expiration */
-	mnt_set_expiry(newmnt, &afs_vfsmounts);
-	queue_delayed_work(afs_wq, &afs_mntpt_expiry_timer,
-			   afs_mntpt_expiry_timeout * HZ);
-	_leave(" = %p {%s}", newmnt, newmnt->mnt_devname);
-	return newmnt;
-}
-
-/*
- * handle mountpoint expiry timer going off
- */
-static void afs_mntpt_expiry_timed_out(struct work_struct *work)
-{
-	_enter("");
-
-	if (!list_empty(&afs_vfsmounts)) {
-		mark_mounts_for_expiry(&afs_vfsmounts);
-		queue_delayed_work(afs_wq, &afs_mntpt_expiry_timer,
-				   afs_mntpt_expiry_timeout * HZ);
-	}
-
-	_leave("");
-}
-
-/*
- * kill the AFS mountpoint timer if it's still running
- */
-void afs_mntpt_kill_timer(void)
-{
-	_enter("");
-
-	ASSERT(list_empty(&afs_vfsmounts));
-	cancel_delayed_work_sync(&afs_mntpt_expiry_timer);
-}
diff --git a/fs/afs/super.c b/fs/afs/super.c
index fb240e8..3217a42 100644
--- a/fs/afs/super.c
+++ b/fs/afs/super.c
@@ -115,7 +115,6 @@ void __exit afs_fs_exit(void)
 {
 	_enter("");
 
-	afs_mntpt_kill_timer();
 	unregister_filesystem(&afs_fs_type);
 
 	if (atomic_read(&afs_count_active_inodes) != 0) {
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index 0a265ad..923a92b 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -24,29 +24,6 @@
 #include "dns_resolve.h"
 #include "cifs_debug.h"
 
-static LIST_HEAD(cifs_dfs_automount_list);
-
-static void cifs_dfs_expire_automounts(struct work_struct *work);
-static DECLARE_DELAYED_WORK(cifs_dfs_automount_task,
-			    cifs_dfs_expire_automounts);
-static int cifs_dfs_mountpoint_expiry_timeout = 500 * HZ;
-
-static void cifs_dfs_expire_automounts(struct work_struct *work)
-{
-	struct list_head *list = &cifs_dfs_automount_list;
-
-	mark_mounts_for_expiry(list);
-	if (!list_empty(list))
-		schedule_delayed_work(&cifs_dfs_automount_task,
-				      cifs_dfs_mountpoint_expiry_timeout);
-}
-
-void cifs_dfs_release_automount_timer(void)
-{
-	BUG_ON(!list_empty(&cifs_dfs_automount_list));
-	cancel_delayed_work_sync(&cifs_dfs_automount_task);
-}
-
 /**
  * cifs_get_share_name	-	extracts share name from UNC
  * @node_name:	pointer to UNC string
@@ -267,8 +244,9 @@ static void dump_referral(const struct dfs_info3_param *ref)
 /*
  * Create a vfsmount that we can automount
  */
-static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
+struct vfsmount *cifs_dfs_d_automount(struct path *mountpoint)
 {
+	struct dentry *mntpt = mountpoint->dentry;
 	struct dfs_info3_param *referrals = NULL;
 	unsigned int num_referrals = 0;
 	struct cifs_sb_info *cifs_sb;
@@ -325,8 +303,10 @@ static struct vfsmount *cifs_dfs_do_automount(struct dentry *mntpt)
 				full_path, referrals + i);
 		cFYI(1, "%s: cifs_dfs_do_refmount:%s , mnt:%p", __func__,
 					referrals[i].node_name, mnt);
-		if (!IS_ERR(mnt))
+		if (!IS_ERR(mnt)) {
+			mnt->mnt_expiry_mark = 1;
 			goto success;
+		}
 	}
 
 	/* no valid submounts were found; return error from get_dfs_path() by
@@ -343,28 +323,5 @@ cdda_exit:
 	return mnt;
 }
 
-/*
- * Attempt to automount the referral
- */
-struct vfsmount *cifs_dfs_d_automount(struct path *path)
-{
-	struct vfsmount *newmnt;
-
-	cFYI(1, "in %s", __func__);
-
-	newmnt = cifs_dfs_do_automount(path->dentry);
-	if (IS_ERR(newmnt)) {
-		cFYI(1, "leaving %s [automount failed]" , __func__);
-		return newmnt;
-	}
-
-	mntget(newmnt); /* prevent immediate expiration */
-	mnt_set_expiry(newmnt, &cifs_dfs_automount_list);
-	schedule_delayed_work(&cifs_dfs_automount_task,
-			      cifs_dfs_mountpoint_expiry_timeout);
-	cFYI(1, "leaving %s [ok]" , __func__);
-	return newmnt;
-}
-
 const struct inode_operations cifs_dfs_referral_inode_operations = {
 };
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f297013..c91ae83 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1067,9 +1067,6 @@ exit_cifs(void)
 	cFYI(DBG2, "exit_cifs");
 	cifs_proc_clean();
 	cifs_fscache_unregister();
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	cifs_dfs_release_automount_timer();
-#endif
 #ifdef CONFIG_CIFS_UPCALL
 	unregister_key_type(&cifs_spnego_key_type);
 #endif
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 8096f27..f3f8099 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -147,7 +147,6 @@ extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, struct inode *,
 extern int cifs_mount(struct super_block *, struct cifs_sb_info *, char *,
 			const char *);
 extern int cifs_umount(struct super_block *, struct cifs_sb_info *);
-extern void cifs_dfs_release_automount_timer(void);
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
 
diff --git a/fs/namei.c b/fs/namei.c
index 97c92a2..aac0375 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -923,11 +923,13 @@ static int follow_automount(struct path *path, unsigned flags,
 		return 0;
 
 	err = finish_automount(mnt, path);
-
 	switch (err) {
 	case -EBUSY:
 		/* Someone else made a mount here whilst we were busy */
-		return 0;
+		err = 0;
+	default:
+		mntput(mnt);
+		return err;
 	case 0:
 		dput(path->dentry);
 		if (*need_mntput)
@@ -936,8 +938,6 @@ static int follow_automount(struct path *path, unsigned flags,
 		path->dentry = dget(mnt->mnt_root);
 		*need_mntput = true;
 		return 0;
-	default:
-		return err;
 	}
 
 }
diff --git a/fs/namespace.c b/fs/namespace.c
index d1edf26..b9cb274 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -50,6 +50,11 @@ static struct list_head *mount_hashtable __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
 static struct rw_semaphore namespace_sem;
 
+unsigned long mnt_expiry_period = 15;
+static LIST_HEAD(mnt_expirable_mounts);
+static void do_periodic_mount_expiry(struct work_struct *);
+static DECLARE_DELAYED_WORK(periodic_mount_expiry, do_periodic_mount_expiry);
+
 /* /sys/fs */
 struct kobject *fs_kobj;
 EXPORT_SYMBOL_GPL(fs_kobj);
@@ -1882,7 +1887,6 @@ static int do_new_mount(struct path *path, char *type, int flags,
 			int mnt_flags, char *name, void *data)
 {
 	struct vfsmount *mnt;
-	int err;
 
 	if (!type)
 		return -EINVAL;
@@ -1895,45 +1899,26 @@ static int do_new_mount(struct path *path, char *type, int flags,
 	if (IS_ERR(mnt))
 		return PTR_ERR(mnt);
 
-	err = do_add_mount(mnt, path, mnt_flags);
-	if (err)
-		mntput(mnt);
-	return err;
+	return do_add_mount(mnt, path, mnt_flags);
 }
 
+/*
+ * Mount the given mount on the specified mountpoint.
+ * - does not drop the caller's ref from the mount.
+ */
 int finish_automount(struct vfsmount *m, struct path *path)
 {
-	int err;
-	/* The new mount record should have at least 2 refs to prevent it being
-	 * expired before we get a chance to add it
-	 */
-	BUG_ON(mnt_get_count(m) < 2);
-
 	if (m->mnt_sb == path->mnt->mnt_sb &&
-	    m->mnt_root == path->dentry) {
-		err = -ELOOP;
-		goto fail;
-	}
+	    m->mnt_root == path->dentry)
+		return -ELOOP;
 
-	err = do_add_mount(m, path, path->mnt->mnt_flags | MNT_SHRINKABLE);
-	if (!err)
-		return 0;
-fail:
-	/* remove m from any expiration list it may be on */
-	if (!list_empty(&m->mnt_expire)) {
-		down_write(&namespace_sem);
-		br_write_lock(vfsmount_lock);
-		list_del_init(&m->mnt_expire);
-		br_write_unlock(vfsmount_lock);
-		up_write(&namespace_sem);
-	}
-	mntput(m);
-	mntput(m);
-	return err;
+	mntget(m);
+	return do_add_mount(m, path, path->mnt->mnt_flags | MNT_SHRINKABLE);
 }
 
 /*
- * add a mount into a namespace's mount tree
+ * Add a mount into a namespace's mount tree.
+ * - the caller's ref on the new mount is consumed unconditionally.
  */
 static int do_add_mount(struct vfsmount *newmnt, struct path *path, int mnt_flags)
 {
@@ -1942,62 +1927,59 @@ static int do_add_mount(struct vfsmount *newmnt, struct path *path, int mnt_flag
 	mnt_flags &= ~(MNT_SHARED | MNT_WRITE_HOLD | MNT_INTERNAL);
 
 	down_write(&namespace_sem);
-	/* Something was mounted here while we slept */
+	/* Something may have been mounted here while we slept */
 	err = follow_down(path, true);
 	if (err < 0)
-		goto unlock;
+		goto error;
 
 	err = -EINVAL;
 	if (!(mnt_flags & MNT_SHRINKABLE) && !check_mnt(path->mnt))
-		goto unlock;
+		goto error;
 
 	/* Refuse the same filesystem on the same mount point */
 	err = -EBUSY;
 	if (path->mnt->mnt_sb == newmnt->mnt_sb &&
 	    path->mnt->mnt_root == path->dentry)
-		goto unlock;
+		goto error;
 
 	err = -EINVAL;
 	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
-		goto unlock;
+		goto error;
 
 	newmnt->mnt_flags = mnt_flags;
 	err = graft_tree(newmnt, path);
+	if (err < 0)
+		goto error;
 
-unlock:
+	if (newmnt->mnt_expiry_mark) {
+		newmnt->mnt_expiry_mark = 0;
+		br_write_lock(vfsmount_lock);
+		list_add_tail(&newmnt->mnt_expire, &mnt_expirable_mounts);
+		br_write_unlock(vfsmount_lock);
+		schedule_delayed_work(&periodic_mount_expiry,
+				      mnt_expiry_period * HZ);
+	}
 	up_write(&namespace_sem);
-	return err;
-}
-
-/**
- * mnt_set_expiry - Put a mount on an expiration list
- * @mnt: The mount to list.
- * @expiry_list: The list to add the mount to.
- */
-void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list)
-{
-	down_write(&namespace_sem);
-	br_write_lock(vfsmount_lock);
-
-	list_add_tail(&mnt->mnt_expire, expiry_list);
+	return 0;
 
-	br_write_unlock(vfsmount_lock);
+error:
 	up_write(&namespace_sem);
+	mntput(newmnt);
+	return err;
 }
-EXPORT_SYMBOL(mnt_set_expiry);
 
 /*
- * process a list of expirable mountpoints with the intent of discarding any
- * mountpoints that aren't in use and haven't been touched since last we came
- * here
+ * Periodically process the list of expirable mountpoints with the intent of
+ * discarding any mountpoints that aren't in use and haven't been touched since
+ * last we came here.
  */
-void mark_mounts_for_expiry(struct list_head *mounts)
+static void do_periodic_mount_expiry(struct work_struct *work)
 {
 	struct vfsmount *mnt, *next;
 	LIST_HEAD(graveyard);
 	LIST_HEAD(umounts);
 
-	if (list_empty(mounts))
+	if (list_empty(&mnt_expirable_mounts))
 		return;
 
 	down_write(&namespace_sem);
@@ -2009,7 +1991,7 @@ void mark_mounts_for_expiry(struct list_head *mounts)
 	 * - still marked for expiry (marked on the last call here; marks are
 	 *   cleared by mntput())
 	 */
-	list_for_each_entry_safe(mnt, next, mounts, mnt_expire) {
+	list_for_each_entry_safe(mnt, next, &mnt_expirable_mounts, mnt_expire) {
 		if (!xchg(&mnt->mnt_expiry_mark, 1) ||
 			propagate_mount_busy(mnt, 1))
 			continue;
@@ -2024,9 +2006,11 @@ void mark_mounts_for_expiry(struct list_head *mounts)
 	up_write(&namespace_sem);
 
 	release_mounts(&umounts);
-}
 
-EXPORT_SYMBOL_GPL(mark_mounts_for_expiry);
+	if (!list_empty(&mnt_expirable_mounts))
+		schedule_delayed_work(&periodic_mount_expiry,
+				      mnt_expiry_period * HZ);
+}
 
 /*
  * Ripoff of 'select_parent()'
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index bd3ca32..5552ff2 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1083,7 +1083,6 @@ void nfs_free_server(struct nfs_server *server)
 	nfs_free_iostats(server->io_stats);
 	bdi_destroy(&server->backing_dev_info);
 	kfree(server);
-	nfs_release_automount_timer();
 	dprintk("<-- nfs_free_server()\n");
 }
 
diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index f32b860..3a4a2fa 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -19,12 +19,6 @@
 
 #define NFSDBG_FACILITY		NFSDBG_VFS
 
-static void nfs_expire_automounts(struct work_struct *work);
-
-static LIST_HEAD(nfs_automount_list);
-static DECLARE_DELAYED_WORK(nfs_automount_task, nfs_expire_automounts);
-int nfs_mountpoint_expiry_timeout = 500 * HZ;
-
 static struct vfsmount *nfs_do_submount(const struct vfsmount *mnt_parent,
 					const struct dentry *dentry,
 					struct nfs_fh *fh,
@@ -149,11 +143,8 @@ struct vfsmount *nfs_d_automount(struct path *path)
 	if (IS_ERR(mnt))
 		goto out;
 
+	mnt->mnt_expiry_mark = 1;
 	dprintk("%s: done, success\n", __func__);
-	mntget(mnt); /* prevent immediate expiration */
-	mnt_set_expiry(mnt, &nfs_automount_list);
-	schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
-
 out:
 	nfs_free_fattr(fattr);
 	nfs_free_fhandle(fh);
@@ -169,21 +160,6 @@ const struct inode_operations nfs_mountpoint_inode_operations = {
 const struct inode_operations nfs_referral_inode_operations = {
 };
 
-static void nfs_expire_automounts(struct work_struct *work)
-{
-	struct list_head *list = &nfs_automount_list;
-
-	mark_mounts_for_expiry(list);
-	if (!list_empty(list))
-		schedule_delayed_work(&nfs_automount_task, nfs_mountpoint_expiry_timeout);
-}
-
-void nfs_release_automount_timer(void)
-{
-	if (list_empty(&nfs_automount_list))
-		cancel_delayed_work(&nfs_automount_task);
-}
-
 /*
  * Clone a mountpoint of the appropriate type
  */
diff --git a/fs/nfs/sysctl.c b/fs/nfs/sysctl.c
index 978aaeb..aa35724 100644
--- a/fs/nfs/sysctl.c
+++ b/fs/nfs/sysctl.c
@@ -43,13 +43,6 @@ static ctl_table nfs_cb_sysctls[] = {
 #endif /* CONFIG_NFS_USE_NEW_IDMAPPER */
 #endif
 	{
-		.procname	= "nfs_mountpoint_timeout",
-		.data		= &nfs_mountpoint_expiry_timeout,
-		.maxlen		= sizeof(nfs_mountpoint_expiry_timeout),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
 		.procname	= "nfs_congestion_kb",
 		.data		= &nfs_congestion_kb,
 		.maxlen		= sizeof(nfs_congestion_kb),
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 604f122..0e46c54 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -108,9 +108,8 @@ extern struct vfsmount *vfs_kern_mount(struct file_system_type *type,
 				      int flags, const char *name,
 				      void *data);
 
-extern void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list);
-extern void mark_mounts_for_expiry(struct list_head *mounts);
-
 extern dev_t name_to_dev_t(char *name);
 
+extern unsigned long mnt_expiry_period;
+
 #endif /* _LINUX_MOUNT_H */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 0f1bd83..f132dbd 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -56,6 +56,7 @@
 #include <linux/kprobes.h>
 #include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
+#include <linux/mount.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -122,6 +123,7 @@ static int one_hundred = 100;
 #ifdef CONFIG_PRINTK
 static int ten_thousand = 10000;
 #endif
+static unsigned long max_timeout_ul = ULONG_MAX / HZ;
 
 /* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
 static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
@@ -1484,6 +1486,15 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &pipe_proc_fn,
 		.extra1		= &pipe_min_size,
 	},
+	{
+		.procname	= "mount-expiry-period",
+		.data		= &mnt_expiry_period,
+		.maxlen		= sizeof(mnt_expiry_period),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= &one_ul,
+		.extra2		= &max_timeout_ul,
+	},
 	{ }
 };
 

