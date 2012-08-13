Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab2HMUUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:20:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49138 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab2HMUUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Subject: [ 11/82] nilfs2: fix deadlock issue between chcp and thaw ioctls
Date: Mon, 13 Aug 2012 13:18:47 -0700
Message-Id: <20120813201747.417677768@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

commit 572d8b3945a31bee7c40d21556803e4807fd9141 upstream.

An fs-thaw ioctl causes deadlock with a chcp or mkcp -s command:

 chcp            D ffff88013870f3d0     0  1325   1324 0x00000004
 ...
 Call Trace:
   nilfs_transaction_begin+0x11c/0x1a0 [nilfs2]
   wake_up_bit+0x20/0x20
   copy_from_user+0x18/0x30 [nilfs2]
   nilfs_ioctl_change_cpmode+0x7d/0xcf [nilfs2]
   nilfs_ioctl+0x252/0x61a [nilfs2]
   do_page_fault+0x311/0x34c
   get_unmapped_area+0x132/0x14e
   do_vfs_ioctl+0x44b/0x490
   __set_task_blocked+0x5a/0x61
   vm_mmap_pgoff+0x76/0x87
   __set_current_blocked+0x30/0x4a
   sys_ioctl+0x4b/0x6f
   system_call_fastpath+0x16/0x1b
 thaw            D ffff88013870d890     0  1352   1351 0x00000004
 ...
 Call Trace:
   rwsem_down_failed_common+0xdb/0x10f
   call_rwsem_down_write_failed+0x13/0x20
   down_write+0x25/0x27
   thaw_super+0x13/0x9e
   do_vfs_ioctl+0x1f5/0x490
   vm_mmap_pgoff+0x76/0x87
   sys_ioctl+0x4b/0x6f
   filp_close+0x64/0x6c
   system_call_fastpath+0x16/0x1b

where the thaw ioctl deadlocked at thaw_super() when called while chcp was
waiting at nilfs_transaction_begin() called from
nilfs_ioctl_change_cpmode().  This deadlock is 100% reproducible.

This is because nilfs_ioctl_change_cpmode() first locks sb->s_umount in
read mode and then waits for unfreezing in nilfs_transaction_begin(),
whereas thaw_super() locks sb->s_umount in write mode.  The locking of
sb->s_umount here was intended to make snapshot mounts and the downgrade
of snapshots to checkpoints exclusive.

This fixes the deadlock issue by replacing the sb->s_umount usage in
nilfs_ioctl_change_cpmode() with a dedicated mutex which protects snapshot
mounts.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nilfs2/ioctl.c     |    4 ++--
 fs/nilfs2/super.c     |    3 +++
 fs/nilfs2/the_nilfs.c |    1 +
 fs/nilfs2/the_nilfs.h |    2 ++
 4 files changed, 8 insertions(+), 2 deletions(-)

--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -182,7 +182,7 @@ static int nilfs_ioctl_change_cpmode(str
 	if (copy_from_user(&cpmode, argp, sizeof(cpmode)))
 		goto out;
 
-	down_read(&inode->i_sb->s_umount);
+	mutex_lock(&nilfs->ns_snapshot_mount_mutex);
 
 	nilfs_transaction_begin(inode->i_sb, &ti, 0);
 	ret = nilfs_cpfile_change_cpmode(
@@ -192,7 +192,7 @@ static int nilfs_ioctl_change_cpmode(str
 	else
 		nilfs_transaction_commit(inode->i_sb); /* never fails */
 
-	up_read(&inode->i_sb->s_umount);
+	mutex_unlock(&nilfs->ns_snapshot_mount_mutex);
 out:
 	mnt_drop_write_file(filp);
 	return ret;
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -948,6 +948,8 @@ static int nilfs_attach_snapshot(struct
 	struct nilfs_root *root;
 	int ret;
 
+	mutex_lock(&nilfs->ns_snapshot_mount_mutex);
+
 	down_read(&nilfs->ns_segctor_sem);
 	ret = nilfs_cpfile_is_snapshot(nilfs->ns_cpfile, cno);
 	up_read(&nilfs->ns_segctor_sem);
@@ -972,6 +974,7 @@ static int nilfs_attach_snapshot(struct
 	ret = nilfs_get_root_dentry(s, root, root_dentry);
 	nilfs_put_root(root);
  out:
+	mutex_unlock(&nilfs->ns_snapshot_mount_mutex);
 	return ret;
 }
 
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -76,6 +76,7 @@ struct the_nilfs *alloc_nilfs(struct blo
 	nilfs->ns_bdev = bdev;
 	atomic_set(&nilfs->ns_ndirtyblks, 0);
 	init_rwsem(&nilfs->ns_sem);
+	mutex_init(&nilfs->ns_snapshot_mount_mutex);
 	INIT_LIST_HEAD(&nilfs->ns_dirty_files);
 	INIT_LIST_HEAD(&nilfs->ns_gc_inodes);
 	spin_lock_init(&nilfs->ns_inode_lock);
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -47,6 +47,7 @@ enum {
  * @ns_flags: flags
  * @ns_bdev: block device
  * @ns_sem: semaphore for shared states
+ * @ns_snapshot_mount_mutex: mutex to protect snapshot mounts
  * @ns_sbh: buffer heads of on-disk super blocks
  * @ns_sbp: pointers to super block data
  * @ns_sbwtime: previous write time of super block
@@ -99,6 +100,7 @@ struct the_nilfs {
 
 	struct block_device    *ns_bdev;
 	struct rw_semaphore	ns_sem;
+	struct mutex		ns_snapshot_mount_mutex;
 
 	/*
 	 * used for


