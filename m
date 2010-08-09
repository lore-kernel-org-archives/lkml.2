Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab0HIOdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 10:33:55 -0400
Received: from cobra.newdream.net ([66.33.216.30]:34888 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756285Ab0HIOdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 10:33:53 -0400
Date: Mon, 9 Aug 2010 07:33:57 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] vfs: introduce FS_IOC_SYNCFS to sync a single super
Message-ID: <Pine.LNX.4.64.1008090711040.17515@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the only way to sync a single super_block (and not all of them 
via sync(2)) is via the BLKFLSBUF ioctl on the block device.  That also 
invalidates the bdev mapping, which isn't usually desireable, and it 
doesn't work for non-block file systems.  The ability to sync a single 
mount can be useful for both applications and administrators (e.g., when 
other mounts on the system are hung).

Introduce a simple ioctl to sync the super associated with an open file.
Pass any error returned by sync_filesystem() back to the user.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ioctl.c         |    9 +++++++++
 include/linux/fs.h |    1 +
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 2d140a7..2aabb19 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -593,6 +593,15 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	case FS_IOC_FIEMAP:
 		return ioctl_fiemap(filp, arg);
 
+	case FS_IOC_SYNCFS:
+	{
+		struct super_block *sb = filp->f_dentry->d_sb;
+		down_read(&sb->s_umount);
+		error = sync_filesystem(sb);
+		up_read(&sb->s_umount);
+		break;
+	}
+
 	case FIGETBSZ:
 	{
 		struct inode *inode = filp->f_path.dentry->d_inode;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 68ca1b0..175d77f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -321,6 +321,7 @@ struct inodes_stat_t {
 #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
 #define	FS_IOC_SETVERSION		_IOW('v', 2, long)
 #define FS_IOC_FIEMAP			_IOWR('f', 11, struct fiemap)
+#define FS_IOC_SYNCFS                   _IO('f', 12)
 #define FS_IOC32_GETFLAGS		_IOR('f', 1, int)
 #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
 #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
-- 
1.7.0.4

