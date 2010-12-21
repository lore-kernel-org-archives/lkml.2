Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab0LUWyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 17:54:16 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50738 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab0LUWyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 17:54:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org,
        Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [PATCH 0/7] BKL removal follow-up
Date: Tue, 21 Dec 2010 23:54:06 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6-next-20101220+; KDE/4.5.1; x86_64; ; )
References: <1290007619-5787-1-git-send-email-arnd@arndb.de> <AANLkTi=qvOHwgsbaCO6_Eu2Uik7MP5=C64+WW8R-RR8B@mail.gmail.com> <20101122151723.GA8732@elliptictech.com>
In-Reply-To: <20101122151723.GA8732@elliptictech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012212354.06895.arnd@arndb.de>
X-Provags-ID: V02:K0:BCB6Yj5L6E2cpaO7tVKTWfuin/Ms7X/ApL/4BOdUWEF
 v9T109pduF0AmTjzCCDR7xSyueBGJqq+ZTKY5zOPq90MDgGG6S
 MigYHJTCvCrXklMowxpC9e4qtws5fesuqN4UOQNEc+cnz8GmP9
 FLukztLeDXXvTrkvdC3dKF7Y3+OXkLeiw0vk3NHFpSng3cQ8yQ
 +tbGzhCE343yqmOUHRfuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 November 2010 16:17:23 Nick Bowler wrote:
> On 2010-11-21 09:45 -0800, Linus Torvalds wrote:
> > Yes, I'd be ok with UDF doing a "select BKL" along with a "default n"
> > for BKL itself.
> > 
> > I think UDF currently is the only sane reason to have BKL enabled any
> > more, and yes, it would probably make it easier to configure things.
> 
> UFS (which I use) also relies on BKL.

Would you mind running a kernel with this patch and lockdep enabled then?

It's quite likely that this doesn't work, but the easiest way to find
out is to just try it if you don't understand the code. I can't see anything
in the code that relies on the release-on-sleep semantics and there
are no obvious recursive lock_kernel() calls.

Anything I've missed should get caught by lockdep. It's unlikely that
this patch introduces suble bugs, since the locking only gets stricter.
If it breaks, you should get a proper backtrace or a hang that you
can debug by looking at the stack.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/fs/ufs/Kconfig b/fs/ufs/Kconfig
index 30c8f22..e4f10a4 100644
--- a/fs/ufs/Kconfig
+++ b/fs/ufs/Kconfig
@@ -1,7 +1,6 @@
 config UFS_FS
 	tristate "UFS file system support (read only)"
 	depends on BLOCK
-	depends on BKL # probably fixable
 	help
 	  BSD and derivate versions of Unix (such as SunOS, FreeBSD, NetBSD,
 	  OpenBSD and NeXTstep) use a file system called UFS. Some System V
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 2b251f2..3e247f6 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -107,7 +107,7 @@ static u64 ufs_frag_map(struct inode *inode, sector_t frag)
 
 	p = offsets;
 
-	lock_kernel();
+	lock_ufs();
 	if ((flags & UFS_TYPE_MASK) == UFS_TYPE_UFS2)
 		goto ufs2;
 
@@ -152,7 +152,7 @@ ufs2:
 	ret = temp + (u64) (frag & uspi->s_fpbmask);
 
 out:
-	unlock_kernel();
+	unlock_ufs();
 	return ret;
 }
 
@@ -436,7 +436,7 @@ int ufs_getfrag_block(struct inode *inode, sector_t fragment, struct buffer_head
 	ret = 0;
 	bh = NULL;
 
-	lock_kernel();
+	lock_ufs();
 
 	UFSD("ENTER, ino %lu, fragment %llu\n", inode->i_ino, (unsigned long long)fragment);
 	if (fragment >
@@ -498,7 +498,7 @@ out:
 		set_buffer_new(bh_result);
 	map_bh(bh_result, sb, phys);
 abort:
-	unlock_kernel();
+	unlock_ufs();
 	return err;
 
 abort_too_big:
@@ -900,9 +900,9 @@ static int ufs_update_inode(struct inode * inode, int do_sync)
 int ufs_write_inode(struct inode *inode, struct writeback_control *wbc)
 {
 	int ret;
-	lock_kernel();
+	lock_ufs();
 	ret = ufs_update_inode(inode, wbc->sync_mode == WB_SYNC_ALL);
-	unlock_kernel();
+	unlock_ufs();
 	return ret;
 }
 
@@ -922,22 +922,22 @@ void ufs_evict_inode(struct inode * inode)
 	if (want_delete) {
 		loff_t old_i_size;
 		/*UFS_I(inode)->i_dtime = CURRENT_TIME;*/
-		lock_kernel();
+		lock_ufs();
 		mark_inode_dirty(inode);
 		ufs_update_inode(inode, IS_SYNC(inode));
 		old_i_size = inode->i_size;
 		inode->i_size = 0;
 		if (inode->i_blocks && ufs_truncate(inode, old_i_size))
 			ufs_warning(inode->i_sb, __func__, "ufs_truncate failed\n");
-		unlock_kernel();
+		unlock_ufs();
 	}
 
 	invalidate_inode_buffers(inode);
 	end_writeback(inode);
 
 	if (want_delete) {
-		lock_kernel();
+		lock_ufs();
 		ufs_free_inode (inode);
-		unlock_kernel();
+		unlock_ufs();
 	}
 }
diff --git a/fs/ufs/namei.c b/fs/ufs/namei.c
index 12f39b9..f8fc07b 100644
--- a/fs/ufs/namei.c
+++ b/fs/ufs/namei.c
@@ -55,16 +55,16 @@ static struct dentry *ufs_lookup(struct inode * dir, struct dentry *dentry, stru
 	if (dentry->d_name.len > UFS_MAXNAMLEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	lock_kernel();
+	lock_ufs();
 	ino = ufs_inode_by_name(dir, &dentry->d_name);
 	if (ino) {
 		inode = ufs_iget(dir->i_sb, ino);
 		if (IS_ERR(inode)) {
-			unlock_kernel();
+			unlock_ufs();
 			return ERR_CAST(inode);
 		}
 	}
-	unlock_kernel();
+	unlock_ufs();
 	d_add(dentry, inode);
 	return NULL;
 }
@@ -93,9 +93,9 @@ static int ufs_create (struct inode * dir, struct dentry * dentry, int mode,
 		inode->i_fop = &ufs_file_operations;
 		inode->i_mapping->a_ops = &ufs_aops;
 		mark_inode_dirty(inode);
-		lock_kernel();
+		lock_ufs();
 		err = ufs_add_nondir(dentry, inode);
-		unlock_kernel();
+		unlock_ufs();
 	}
 	UFSD("END: err=%d\n", err);
 	return err;
@@ -115,9 +115,9 @@ static int ufs_mknod (struct inode * dir, struct dentry *dentry, int mode, dev_t
 		init_special_inode(inode, mode, rdev);
 		ufs_set_inode_dev(inode->i_sb, UFS_I(inode), rdev);
 		mark_inode_dirty(inode);
-		lock_kernel();
+		lock_ufs();
 		err = ufs_add_nondir(dentry, inode);
-		unlock_kernel();
+		unlock_ufs();
 	}
 	return err;
 }
@@ -133,7 +133,7 @@ static int ufs_symlink (struct inode * dir, struct dentry * dentry,
 	if (l > sb->s_blocksize)
 		goto out_notlocked;
 
-	lock_kernel();
+	lock_ufs();
 	inode = ufs_new_inode(dir, S_IFLNK | S_IRWXUGO);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
@@ -156,7 +156,7 @@ static int ufs_symlink (struct inode * dir, struct dentry * dentry,
 
 	err = ufs_add_nondir(dentry, inode);
 out:
-	unlock_kernel();
+	unlock_ufs();
 out_notlocked:
 	return err;
 
@@ -172,9 +172,9 @@ static int ufs_link (struct dentry * old_dentry, struct inode * dir,
 	struct inode *inode = old_dentry->d_inode;
 	int error;
 
-	lock_kernel();
+	lock_ufs();
 	if (inode->i_nlink >= UFS_LINK_MAX) {
-		unlock_kernel();
+		unlock_ufs();
 		return -EMLINK;
 	}
 
@@ -183,7 +183,7 @@ static int ufs_link (struct dentry * old_dentry, struct inode * dir,
 	ihold(inode);
 
 	error = ufs_add_nondir(dentry, inode);
-	unlock_kernel();
+	unlock_ufs();
 	return error;
 }
 
@@ -195,7 +195,7 @@ static int ufs_mkdir(struct inode * dir, struct dentry * dentry, int mode)
 	if (dir->i_nlink >= UFS_LINK_MAX)
 		goto out;
 
-	lock_kernel();
+	lock_ufs();
 	inode_inc_link_count(dir);
 
 	inode = ufs_new_inode(dir, S_IFDIR|mode);
@@ -216,7 +216,7 @@ static int ufs_mkdir(struct inode * dir, struct dentry * dentry, int mode)
 	err = ufs_add_link(dentry, inode);
 	if (err)
 		goto out_fail;
-	unlock_kernel();
+	unlock_ufs();
 
 	d_instantiate(dentry, inode);
 out:
@@ -228,7 +228,7 @@ out_fail:
 	iput (inode);
 out_dir:
 	inode_dec_link_count(dir);
-	unlock_kernel();
+	unlock_ufs();
 	goto out;
 }
 
@@ -259,7 +259,7 @@ static int ufs_rmdir (struct inode * dir, struct dentry *dentry)
 	struct inode * inode = dentry->d_inode;
 	int err= -ENOTEMPTY;
 
-	lock_kernel();
+	lock_ufs();
 	if (ufs_empty_dir (inode)) {
 		err = ufs_unlink(dir, dentry);
 		if (!err) {
@@ -268,7 +268,7 @@ static int ufs_rmdir (struct inode * dir, struct dentry *dentry)
 			inode_dec_link_count(dir);
 		}
 	}
-	unlock_kernel();
+	unlock_ufs();
 	return err;
 }
 
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 2c61ac5..46fb466 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -96,6 +96,18 @@
 #include "swab.h"
 #include "util.h"
 
+static DEFINE_MUTEX(ufs_mutex);
+
+void lock_ufs(void)
+{
+	mutex_lock(&ufs_mutex);
+}
+
+void unlock_ufs(void)
+{
+	mutex_unlock(&ufs_mutex);
+}
+
 static struct inode *ufs_nfs_get_inode(struct super_block *sb, u64 ino, u32 generation)
 {
 	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
@@ -313,7 +325,7 @@ void ufs_panic (struct super_block * sb, const char * function,
 	struct ufs_super_block_first * usb1;
 	va_list args;
 	
-	lock_kernel();
+	lock_ufs();
 	uspi = UFS_SB(sb)->s_uspi;
 	usb1 = ubh_get_usb_first(uspi);
 	
@@ -646,7 +658,7 @@ static void ufs_put_super_internal(struct super_block *sb)
 	
 	UFSD("ENTER\n");
 
-	lock_kernel();
+	lock_ufs();
 
 	ufs_put_cstotal(sb);
 	size = uspi->s_cssize;
@@ -676,7 +688,7 @@ static void ufs_put_super_internal(struct super_block *sb)
 	kfree (sbi->s_ucg);
 	kfree (base);
 
-	unlock_kernel();
+	unlock_ufs();
 
 	UFSD("EXIT\n");
 }
@@ -696,7 +708,7 @@ static int ufs_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned maxsymlen;
 	int ret = -EINVAL;
 
-	lock_kernel();
+	lock_ufs();
 
 	uspi = NULL;
 	ubh = NULL;
@@ -1165,7 +1177,7 @@ magic_found:
 			goto failed;
 
 	UFSD("EXIT\n");
-	unlock_kernel();
+	unlock_ufs();
 	return 0;
 
 dalloc_failed:
@@ -1177,12 +1189,12 @@ failed:
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 	UFSD("EXIT (FAILED)\n");
-	unlock_kernel();
+	unlock_ufs();
 	return ret;
 
 failed_nomem:
 	UFSD("EXIT (NOMEM)\n");
-	unlock_kernel();
+	unlock_ufs();
 	return -ENOMEM;
 }
 
@@ -1193,8 +1205,8 @@ static int ufs_sync_fs(struct super_block *sb, int wait)
 	struct ufs_super_block_third * usb3;
 	unsigned flags;
 
+	lock_ufs();
 	lock_super(sb);
-	lock_kernel();
 
 	UFSD("ENTER\n");
 
@@ -1213,8 +1225,8 @@ static int ufs_sync_fs(struct super_block *sb, int wait)
 	sb->s_dirt = 0;
 
 	UFSD("EXIT\n");
-	unlock_kernel();
 	unlock_super(sb);
+	unlock_ufs();
 
 	return 0;
 }
@@ -1256,7 +1268,7 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 	unsigned new_mount_opt, ufstype;
 	unsigned flags;
 
-	lock_kernel();
+	lock_ufs();
 	lock_super(sb);
 	uspi = UFS_SB(sb)->s_uspi;
 	flags = UFS_SB(sb)->s_flags;
@@ -1272,7 +1284,7 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 	ufs_set_opt (new_mount_opt, ONERROR_LOCK);
 	if (!ufs_parse_options (data, &new_mount_opt)) {
 		unlock_super(sb);
-		unlock_kernel();
+		unlock_ufs();
 		return -EINVAL;
 	}
 	if (!(new_mount_opt & UFS_MOUNT_UFSTYPE)) {
@@ -1280,14 +1292,14 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 	} else if ((new_mount_opt & UFS_MOUNT_UFSTYPE) != ufstype) {
 		printk("ufstype can't be changed during remount\n");
 		unlock_super(sb);
-		unlock_kernel();
+		unlock_ufs();
 		return -EINVAL;
 	}
 
 	if ((*mount_flags & MS_RDONLY) == (sb->s_flags & MS_RDONLY)) {
 		UFS_SB(sb)->s_mount_opt = new_mount_opt;
 		unlock_super(sb);
-		unlock_kernel();
+		unlock_ufs();
 		return 0;
 	}
 	
@@ -1313,7 +1325,7 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 		printk("ufs was compiled with read-only support, "
 		"can't be mounted as read-write\n");
 		unlock_super(sb);
-		unlock_kernel();
+		unlock_ufs();
 		return -EINVAL;
 #else
 		if (ufstype != UFS_MOUNT_UFSTYPE_SUN && 
@@ -1323,13 +1335,13 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 		    ufstype != UFS_MOUNT_UFSTYPE_UFS2) {
 			printk("this ufstype is read-only supported\n");
 			unlock_super(sb);
-			unlock_kernel();
+			unlock_ufs();
 			return -EINVAL;
 		}
 		if (!ufs_read_cylinder_structures(sb)) {
 			printk("failed during remounting\n");
 			unlock_super(sb);
-			unlock_kernel();
+			unlock_ufs();
 			return -EPERM;
 		}
 		sb->s_flags &= ~MS_RDONLY;
@@ -1337,7 +1349,7 @@ static int ufs_remount (struct super_block *sb, int *mount_flags, char *data)
 	}
 	UFS_SB(sb)->s_mount_opt = new_mount_opt;
 	unlock_super(sb);
-	unlock_kernel();
+	unlock_ufs();
 	return 0;
 }
 
@@ -1371,7 +1383,7 @@ static int ufs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct ufs_super_block_third *usb3;
 	u64 id = huge_encode_dev(sb->s_bdev->bd_dev);
 
-	lock_kernel();
+	lock_ufs();
 
 	usb1 = ubh_get_usb_first(uspi);
 	usb2 = ubh_get_usb_second(uspi);
@@ -1395,7 +1407,7 @@ static int ufs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_fsid.val[0] = (u32)id;
 	buf->f_fsid.val[1] = (u32)(id >> 32);
 
-	unlock_kernel();
+	unlock_ufs();
 
 	return 0;
 }
diff --git a/fs/ufs/truncate.c b/fs/ufs/truncate.c
index a58f915..9f22d00 100644
--- a/fs/ufs/truncate.c
+++ b/fs/ufs/truncate.c
@@ -467,7 +467,7 @@ int ufs_truncate(struct inode *inode, loff_t old_i_size)
 
 	block_truncate_page(inode->i_mapping, inode->i_size, ufs_getfrag_block);
 
-	lock_kernel();
+	lock_ufs();
 	while (1) {
 		retry = ufs_trunc_direct(inode);
 		retry |= ufs_trunc_indirect(inode, UFS_IND_BLOCK,
@@ -487,7 +487,7 @@ int ufs_truncate(struct inode *inode, loff_t old_i_size)
 
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
 	ufsi->i_lastfrag = DIRECT_FRAGMENT;
-	unlock_kernel();
+	unlock_ufs();
 	mark_inode_dirty(inode);
 out:
 	UFSD("EXIT: err %d\n", err);
diff --git a/fs/ufs/ufs.h b/fs/ufs/ufs.h
index c08782e..de3f179 100644
--- a/fs/ufs/ufs.h
+++ b/fs/ufs/ufs.h
@@ -154,4 +154,7 @@ static inline u32 ufs_dtogd(struct ufs_sb_private_info * uspi, u64 b)
 	return do_div(b, uspi->s_fpg);
 }
 
+extern void lock_ufs(void);
+extern void unlock_ufs(void);
+
 #endif /* _UFS_UFS_H */
