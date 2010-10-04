Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab0JDUQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:16:34 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49435 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab0JDUQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:16:33 -0400
To: Andy Whitcroft <apw@canonical.com>
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-reply-to: <20101004173343.GA19733@agent57> (message from Andy Whitcroft on
	Mon, 4 Oct 2010 18:33:43 +0100)
Subject: Re: overlayfs: BUG in ovl_whiteout
References: <20101001180702.GD2832@shadowen.org>
 <E1P2hGO-0001kL-Gw@pomaz-ex.szeredi.hu> <20101004173343.GA19733@agent57>
Message-Id: <E1P2rSX-0002hz-Lj@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 04 Oct 2010 22:16:29 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010, Andy Whitcroft wrote:
> On Mon, Oct 04, 2010 at 11:23:16AM +0200, Miklos Szeredi wrote:
> > On Fri, 1 Oct 2010, Andy Whitcroft wrote:
> > > I have been playing with overlayfs for a bit now and there seems to
> > > be something a little dodgy when unmounting and remounting an overlay.
> > > I modified some files in the overlay, immediatly unmounted the overlay and
> > > again immediatly remounted it.  On touching the same files in the overlay
> > > I triggered the following BUG (dmesg fragment at the bottom of this email).
> > > When trying to reproduce this I also triggered a hard hang.
> > 
> > Thanks for the bug report, Andy.
> > 
> > Please change that BUG_ON to a WARN_ON.  This will make this a
> > harmless error message in the log instead of a hang.
> 
> Applied your patch to move these to WARN_ON.  Now I get a WARN_ON after
> the remount.  Now that we don't explode I get the following error from
> the triggering command.  I assume that this is the rename which has
> triggered the issue:
> 
> W: Failed to fetch http://192.168.0.60:3142/archive.ubuntu.com/ubuntu/dists/maverick/Release rename failed, File exists (/var/lib/apt/lists/192.168.0.60:3142_archive.ubuntu.com_ubuntu_dists_maverick_Release -> /var/lib/apt/lists/192.168.0.60:3142_archive.ubuntu.com_ubuntu_dists_maverick_Release).
> 
> I note that the file does indeed exist as a real file in both layers.  I
> have not as yet managed to generate a naive test that also triggers
> this.

OK, my guess is that it's a 'rename to self' which was not properly
implemented.

Does the following patch make a difference?

Thanks,
Miklos

---
 fs/namei.c               |   19 ++++++++++++++-----
 fs/overlayfs/overlayfs.c |   19 ++++++++++++++++++-
 include/linux/fs.h       |    3 ++-
 3 files changed, 34 insertions(+), 7 deletions(-)

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2010-10-04 19:40:20.000000000 +0200
+++ linux-2.6/fs/namei.c	2010-10-04 21:46:13.000000000 +0200
@@ -2620,6 +2620,17 @@ static int vfs_rename_other(struct inode
 	return error;
 }
 
+bool vfs_is_same_inode(struct dentry *d1, struct dentry *d2)
+{
+	BUG_ON(d1->d_sb != d2->d_sb);
+
+	if (d1->d_sb->s_op->is_same_inode)
+		return d1->d_sb->s_op->is_same_inode(d1, d2);
+	else
+		return d1->d_inode == d2->d_inode;
+}
+EXPORT_SYMBOL(vfs_is_same_inode);
+
 int vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	       struct inode *new_dir, struct dentry *new_dentry)
 {
@@ -2627,11 +2638,9 @@ int vfs_rename(struct inode *old_dir, st
 	int is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
 	const unsigned char *old_name;
 
-	if (old_dentry->d_inode == new_dentry->d_inode &&
-	    !(old_dir->i_sb->s_type->fs_flags & FS_RENAME_SELF_ALLOW)) {
- 		return 0;
-	}
- 
+	if (vfs_is_same_inode(old_dentry, new_dentry))
+		return 0;
+
 	error = may_delete(old_dir, old_dentry, is_dir);
 	if (error)
 		return error;
Index: linux-2.6/fs/overlayfs/overlayfs.c
===================================================================
--- linux-2.6.orig/fs/overlayfs/overlayfs.c	2010-10-04 19:40:20.000000000 +0200
+++ linux-2.6/fs/overlayfs/overlayfs.c	2010-10-04 21:00:05.000000000 +0200
@@ -1962,10 +1962,28 @@ static int ovl_statfs(struct dentry *den
 	return path.dentry->d_sb->s_op->statfs(path.dentry, buf);
 }
 
+static bool ovl_is_same_inode(struct dentry *d1, struct dentry *d2)
+{
+	struct dentry *upperd1;
+	struct dentry *upperd2;
+
+	upperd1 = ovl_dentry_upper(d1);
+	upperd2 = ovl_dentry_upper(d2);
+
+	if (upperd1 && upperd2)
+		return vfs_is_same_inode(upperd1, upperd2);
+
+	if (upperd1 || upperd2)
+		return false;
+
+	return vfs_is_same_inode(ovl_dentry_lower(d1), ovl_dentry_lower(d2));
+}
+
 static const struct super_operations ovl_super_operations = {
 	.put_super	= ovl_put_super,
 	.remount_fs	= ovl_remount_fs,
 	.statfs		= ovl_statfs,
+	.is_same_inode	= ovl_is_same_inode,
 };
 
 struct ovl_config {
@@ -2155,7 +2173,6 @@ static int ovl_get_sb(struct file_system
 static struct file_system_type ovl_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "overlayfs",
-	.fs_flags	= FS_RENAME_SELF_ALLOW,
 	.get_sb		= ovl_get_sb,
 	.kill_sb	= kill_anon_super,
 };
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-10-04 19:40:20.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2010-10-04 21:47:40.000000000 +0200
@@ -179,7 +179,6 @@ struct inodes_stat_t {
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
 					 * during rename() internally.
 					 */
-#define FS_RENAME_SELF_ALLOW	65536	/* Allow rename to same inode */
 
 /*
  * These are the fs-independent mount-flags: up to 32 flags are supported
@@ -1579,6 +1578,7 @@ struct super_operations {
 	ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
 #endif
 	int (*bdev_try_to_free_page)(struct super_block*, struct page*, gfp_t);
+	bool (*is_same_inode)(struct dentry *, struct dentry *);
 };
 
 /*
@@ -1816,6 +1816,7 @@ extern int vfs_statfs(struct path *, str
 extern int statfs_by_dentry(struct dentry *, struct kstatfs *);
 extern int freeze_super(struct super_block *super);
 extern int thaw_super(struct super_block *super);
+extern bool vfs_is_same_inode(struct dentry *d1, struct dentry *d2);
 
 extern int current_umask(void);
 
