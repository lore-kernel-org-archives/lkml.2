Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256Ab1EaUIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:08:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47413 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab1EaUH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:07:58 -0400
Date: Tue, 31 May 2011 21:07:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        chris.mason@oracle.com, josef@redhat.com, agruen@linbit.com,
        "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 1/4] Cache xattr security drop check for write v2
Message-ID: <20110531200750.GO11521@ZenIV.linux.org.uk>
References: <1306596354-18453-1-git-send-email-andi@firstfloor.org>
 <1306849896.2816.22.camel@menhir>
 <20110531180643.GB9261@alboin.amr.corp.intel.com>
 <1306867346.2816.49.camel@menhir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306867346.2816.49.camel@menhir>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 07:42:26PM +0100, Steven Whitehouse wrote:

> Yes, it should test for xattr too,

Frankly, I suspect that the sanest way to handle that is this:
	* new superblock flag - MS_NOSEC
	* S_NOSEC is never set unless we have MS_NOSEC
	* mount_bdev() sets it before calling fill_super callback.
	* ocfs2 and fuse *clear* it in their fill_super
	* btrfs manually sets it in its ->mount()
... and if gfs2 or any other non-trivial fs wants to use that, it'll need
to set MS_NOSEC in its ->mount() and take care of clearing S_NOSEC whenever
we decide it might've gone stale (a-la your patch).

That way we do not have a hole on network filesystems, get rid of duplicate
xattr / SxID checks on local block ones (which is the majority of filesystems
that might care about all that crap) and keep the patch size on saner side...

Something like this:

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 9b2e7e5..d158b67 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -819,7 +819,7 @@ static struct dentry *btrfs_mount(struct file_system_type *fs_type, int flags,
 	} else {
 		char b[BDEVNAME_SIZE];
 
-		s->s_flags = flags;
+		s->s_flags = flags | MS_NOSEC;
 		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
 		error = btrfs_fill_super(s, fs_devices, data,
 					 flags & MS_SILENT ? 1 : 0);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index cc6ec4b..38f84cd 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -921,6 +921,8 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	if (sb->s_flags & MS_MANDLOCK)
 		goto err;
 
+	sb->s_flags &= ~MS_NOSEC;
+
 	if (!parse_fuse_opt((char *) data, &d, is_bdev))
 		goto err;
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index cdbaf5e..56f6102 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1072,7 +1072,7 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_magic = OCFS2_SUPER_MAGIC;
 
-	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
+	sb->s_flags = (sb->s_flags & ~(MS_POSIXACL | MS_NOSEC)) |
 		((osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) ? MS_POSIXACL : 0);
 
 	/* Hard readonly mode only if: bdev_read_only, MS_RDONLY,
diff --git a/fs/super.c b/fs/super.c
index c755939..ab3d672 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -822,7 +822,7 @@ struct dentry *mount_bdev(struct file_system_type *fs_type,
 	} else {
 		char b[BDEVNAME_SIZE];
 
-		s->s_flags = flags;
+		s->s_flags = flags | MS_NOSEC;
 		s->s_mode = mode;
 		strlcpy(s->s_id, bdevname(bdev, b), sizeof(s->s_id));
 		sb_set_blocksize(s, block_size(bdev));
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c55d6b7..646a183 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -208,6 +208,7 @@ struct inodes_stat_t {
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_STRICTATIME	(1<<24) /* Always perform atime updates */
+#define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
@@ -2591,7 +2592,7 @@ static inline int is_sxid(mode_t mode)
 
 static inline void inode_has_no_xattr(struct inode *inode)
 {
-	if (!is_sxid(inode->i_mode))
+	if (!is_sxid(inode->i_mode) && (inode->i_sb->s_flags & MS_NOSEC))
 		inode->i_flags |= S_NOSEC;
 }
 
diff --git a/mm/filemap.c b/mm/filemap.c
index d7b1057..a8251a8 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2000,7 +2000,7 @@ int file_remove_suid(struct file *file)
 		error = security_inode_killpriv(dentry);
 	if (!error && killsuid)
 		error = __remove_suid(dentry, killsuid);
-	if (!error)
+	if (!error && (inode->i_sb->s_flags & MS_NOSEC))
 		inode->i_flags |= S_NOSEC;
 
 	return error;
