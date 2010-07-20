Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab0GTXqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 19:46:16 -0400
Received: from cobra.newdream.net ([66.33.216.30]:54815 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853Ab0GTXqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 19:46:15 -0400
Date: Tue, 20 Jul 2010 16:48:26 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] FS_IOC_SYNCFS
Message-ID: <Pine.LNX.4.64.1007201004380.6477@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I can see, currently the only way to sync a single file system 
(and not _all_ mounted file systems) is via the BLKFLSBUF ioctl, which 
will sync_filesystem() and then invalidate_bdev().  If you _just_ want to 
sync, though, the invalidate_bdev() is unnecessary and potentially 
counter-productive.

Would it be reasonable to add a simple call like so?  Then you could

	fd = open("/path/for/some/mount", O_RDONLY);
	ioctl(fd, FS_IOC_SYNCFS);
	close(fd);

or something along those lines.
sage


diff --git a/fs/ioctl.c b/fs/ioctl.c
index 2d140a7..0bc9f7a 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -593,6 +593,9 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	case FS_IOC_FIEMAP:
 		return ioctl_fiemap(filp, arg);
 
+	case FS_IOC_SYNCFS:
+		return sync_filesystem(filp->f_dentry->d_sb);
+
 	case FIGETBSZ:
 	{
 		struct inode *inode = filp->f_path.dentry->d_inode;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 471e1ff..4a84d78 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -321,6 +321,7 @@ struct inodes_stat_t {
 #define	FS_IOC_GETVERSION		_IOR('v', 1, long)
 #define	FS_IOC_SETVERSION		_IOW('v', 2, long)
 #define FS_IOC_FIEMAP			_IOWR('f', 11, struct fiemap)
+#define FS_IOC_SYNCFS                   _IO('S', 12)
 #define FS_IOC32_GETFLAGS		_IOR('f', 1, int)
 #define FS_IOC32_SETFLAGS		_IOW('f', 2, int)
 #define FS_IOC32_GETVERSION		_IOR('v', 1, int)
