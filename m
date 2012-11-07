Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2KGSvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:51:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab2KGSvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:51:40 -0500
Date: Wed, 7 Nov 2012 19:51:37 +0100
From: Jan Kara <jack@suse.cz>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: enabling psacct breaks fsfreeze
Message-ID: <20121107185137.GC23654@quack.suse.cz>
References: <20121023094351.GC27919@pcnci.linuxbox.cz>
 <20121031121517.GD18424@quack.suse.cz>
 <20121031124600.GM20752@pcnci.linuxbox.cz>
 <20121101093723.GC6584@quack.suse.cz>
 <20121101111957.GD6584@quack.suse.cz>
 <20121101142325.GD20752@pcnci.linuxbox.cz>
 <20121101225053.GB31937@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20121101225053.GB31937@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 01-11-12 23:50:53, Jan Kara wrote:
> On Thu 01-11-12 15:23:25, Nikola Ciprich wrote:
> > Nov  1 14:23:25 vmnci22 [ 1075.178123] SysRq : Show Blocked State
> > Nov  1 14:23:25 vmnci22 [ 1075.180555]   task                        PC stack   pid father
> > Nov  1 14:23:25 vmnci22 [ 1075.180592] fsfreeze      D 0000000000000000     0  4215   4195 0x00000000
> > Nov  1 14:23:25 vmnci22 [ 1075.180599]  ffff8800090b9b28 0000000000000046 0000000000000000 ffffffff00000000
> > Nov  1 14:23:25 vmnci22 [ 1075.180606]  0000000000013780 ffff8800090b9fd8 ffff88000f716170 ffff88000f715e80
> > Nov  1 14:23:25 vmnci22 [ 1075.180612]  ffff88000f715dc0 ffffffff81566080 ffff88000f716170 000000010002f405
> > Nov  1 14:23:25 vmnci22 [ 1075.180619] Call Trace:
> > Nov  1 14:23:25 vmnci22 [ 1075.180693]  [<ffffffff810e2dbb>] __generic_file_aio_write+0xbb/0x420
> > Nov  1 14:23:25 vmnci22 [ 1075.180729]  [<ffffffff81079290>] ? autoremove_wake_function+0x0/0x40
> > Nov  1 14:23:25 vmnci22 [ 1075.180736]  [<ffffffff810e317f>] generic_file_aio_write+0x5f/0xc0
>   Thanks. So the system isn't really deadlocked. It's just that fsfreeze
> command hangs, isn't it? OK, I understand that it's kind of incovenient
> situation because every command will hang like this when the filesystem is
> frozen.
> 
> Now I only have to come up with a way to improve this... It isn't quite
> simple - to properly protect against freezing be have to communicate down
> into generic_file_aio_write() that we want to bail out if filesystem is
> frozen instead of waiting.
  OK, can you test attached patch?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--PNTmBPCT7hxwcZjr
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-fs-Fix-hang-with-BSD-accounting-on-frozen-filesystem.patch"

>From 1cc937c5a850b2f9f0c2a83fdf757911602db198 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 7 Nov 2012 19:26:45 +0100
Subject: [PATCH] fs: Fix hang with BSD accounting on frozen filesystem

When BSD process accounting is enabled and logs information to a filesystem
which gets frozen, system easily becomes unusable because each attempt to
account process information blocks. Thus e.g. every task gets blocked in exit.

It seems better to drop accounting information (which can already happen when
filesystem is running out of space) instead of locking system up. This is
implemented using a special flag FMODE_NO_FREEZE_WAIT in file->f_mode of a
file to which accounting information is written.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/btrfs/file.c    |    3 ++-
 fs/cifs/file.c     |    3 ++-
 fs/fuse/file.c     |    3 ++-
 fs/ntfs/file.c     |    3 ++-
 fs/ocfs2/file.c    |    3 ++-
 fs/open.c          |    2 +-
 fs/xfs/xfs_file.c  |    3 ++-
 include/linux/fs.h |   14 ++++++++++++++
 kernel/acct.c      |    1 +
 mm/filemap.c       |    3 ++-
 10 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 9ab1bed..6eb2e30 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1411,7 +1411,8 @@ static ssize_t btrfs_file_aio_write(struct kiocb *iocb,
 	ssize_t err = 0;
 	size_t count, ocount;
 
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(file))
+		return -EAGAIN;
 
 	mutex_lock(&inode->i_mutex);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index edb25b4..1629e47 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2448,7 +2448,8 @@ cifs_writev(struct kiocb *iocb, const struct iovec *iov,
 
 	BUG_ON(iocb->ki_pos != pos);
 
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(file))
+		return -EAGAIN;
 
 	/*
 	 * We need to hold the sem to be sure nobody modifies lock list
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 78d2837..641df9e 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -947,7 +947,8 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		return err;
 
 	count = ocount;
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(file))
+		return -EAGAIN;
 	mutex_lock(&inode->i_mutex);
 
 	/* We can write back this queue in page reclaim */
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 1ecf464..028b349 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2118,7 +2118,8 @@ static ssize_t ntfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	BUG_ON(iocb->ki_pos != pos);
 
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(file))
+		return -EAGAIN;
 	mutex_lock(&inode->i_mutex);
 	ret = ntfs_file_aio_write_nolock(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 5a4ee77..93ef34d 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2265,7 +2265,8 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 	if (iocb->ki_left == 0)
 		return 0;
 
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(file))
+		return -EAGAIN;
 
 	appending = file->f_flags & O_APPEND ? 1 : 0;
 	direct_io = file->f_flags & O_DIRECT ? 1 : 0;
diff --git a/fs/open.c b/fs/open.c
index 59071f5..42bd875 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -808,7 +808,7 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		op->mode = 0;
 
 	/* Must never be set by userspace */
-	flags &= ~FMODE_NONOTIFY & ~O_CLOEXEC;
+	flags &= ~FMODE_NONOTIFY & ~O_CLOEXEC & ~FMODE_NO_FREEZE_WAIT;
 
 	/*
 	 * O_SYNC is implemented as __O_SYNC|O_DSYNC.  As many places only
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index aa473fa..7d8af61 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -771,7 +771,8 @@ xfs_file_aio_write(
 	if (ocount == 0)
 		return 0;
 
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(file))
+		return -EAGAIN;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		ret = -EIO;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b33cfc9..c040a6c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -123,6 +123,9 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
 
+/* Write to file should fail on frozen fs rather than block */
+#define FMODE_NO_FREEZE_WAIT	((__force fmode_t)0x2000000)
+
 /*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
  * that indicates that they should check the contents of the iovec are
@@ -1401,6 +1404,17 @@ static inline int sb_start_write_trylock(struct super_block *sb)
 	return __sb_start_write(sb, SB_FREEZE_WRITE, false);
 }
 
+/*
+ * We use trylock semantics if write originates in kernel and normal lock
+ * semantics otherwise. This is a hack but solves problems with deadlocking
+ * of e.g. psacct when filesystem is frozen.
+ */
+static inline int sb_start_file_write(struct file *file)
+{
+	return __sb_start_write(file->f_mapping->host->i_sb, SB_FREEZE_WRITE,
+				!(file->f_mode & FMODE_NO_FREEZE_WAIT));
+}
+
 /**
  * sb_start_pagefault - get write access to a superblock from a page fault
  * @sb: the super we write to
diff --git a/kernel/acct.c b/kernel/acct.c
index 051e071..0b5f231 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -183,6 +183,7 @@ static void acct_file_reopen(struct bsd_acct_struct *acct, struct file *file,
 		acct->needcheck = jiffies + ACCT_TIMEOUT*HZ;
 		acct->active = 1;
 		list_add(&acct->list, &acct_list);
+		file->f_mode |= FMODE_NO_FREEZE_WAIT;
 	}
 	if (old_acct) {
 		mnt_unpin(old_acct->f_path.mnt);
diff --git a/mm/filemap.c b/mm/filemap.c
index 83efee7..3b2812b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2527,7 +2527,8 @@ ssize_t generic_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 	BUG_ON(iocb->ki_pos != pos);
 
-	sb_start_write(inode->i_sb);
+	if (!sb_start_file_write(file))
+		return -EAGAIN;
 	mutex_lock(&inode->i_mutex);
 	ret = __generic_file_aio_write(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
-- 
1.7.1


--PNTmBPCT7hxwcZjr--
