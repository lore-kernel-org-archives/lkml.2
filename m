Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933410Ab2BBTnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:43:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933382Ab2BBTnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:43:04 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/2] hfsplus: Add an ioctl to bless files
Date: Thu,  2 Feb 2012 14:42:38 -0500
Message-Id: <1328211758-2827-2-git-send-email-mjg@redhat.com>
In-Reply-To: <1328211758-2827-1-git-send-email-mjg@redhat.com>
References: <1328211758-2827-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making an hfsplus partition bootable requires the ability to "bless" a
file by putting its inode number in the volume header. Doing this from
userspace on a mounted filesystem is impractical since the kernel will
write back the original values on unmount. Add an ioctl to allow userspace
to update the volume header information based on the target file.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 Documentation/ioctl/ioctl-number.txt |    1 +
 fs/hfsplus/hfsplus_fs.h              |    1 +
 fs/hfsplus/ioctl.c                   |   20 ++++++++++++++++++++
 3 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 4840334..6965c1b 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -213,6 +213,7 @@ Code  Seq#(hex)	Include File		Comments
 'f'	00-0F	fs/ext4/ext4.h		conflict!
 'f'	00-0F	linux/fs.h		conflict!
 'f'	00-0F	fs/ocfs2/ocfs2_fs.h	conflict!
+'f'	20-2F	fs/hfsplus/hfsplus_fs.h
 'g'	00-0F	linux/usb/gadgetfs.h
 'g'	20-2F	linux/usb/g_printer.h
 'h'	00-7F				conflict! Charon filesystem
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 21a5b7f..1036936 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -315,6 +315,7 @@ static inline unsigned short hfsplus_min_io_size(struct super_block *sb)
 #define HFSPLUS_IOC_EXT2_GETFLAGS	FS_IOC_GETFLAGS
 #define HFSPLUS_IOC_EXT2_SETFLAGS	FS_IOC_SETFLAGS
 
+#define HFSPLUS_IOC_BLESS		_IO('f', 0x20)
 
 /*
  * Functions in any *.c used in other files
diff --git a/fs/hfsplus/ioctl.c b/fs/hfsplus/ioctl.c
index f66c765..cbd4c48 100644
--- a/fs/hfsplus/ioctl.c
+++ b/fs/hfsplus/ioctl.c
@@ -20,6 +20,24 @@
 #include <asm/uaccess.h>
 #include "hfsplus_fs.h"
 
+static int hfsplus_ioctl_bless(struct file *file, int __user *user_flags)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
+	struct hfsplus_vh *vh = sbi->s_vhdr;
+	struct hfsplus_vh *bvh = sbi->s_backup_vhdr;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	mutex_lock(&sbi->vh_mutex);
+	vh->finder_info[0] = bvh->finder_info[0] = parent_ino(file->f_dentry);
+	vh->finder_info[1] = bvh->finder_info[1] = inode->i_ino;
+	vh->finder_info[5] = bvh->finder_info[5] = parent_ino(file->f_dentry);
+	mutex_unlock(&sbi->vh_mutex);
+	return 0;
+}
+
 static int hfsplus_ioctl_getflags(struct file *file, int __user *user_flags)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -108,6 +126,8 @@ long hfsplus_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return hfsplus_ioctl_getflags(file, argp);
 	case HFSPLUS_IOC_EXT2_SETFLAGS:
 		return hfsplus_ioctl_setflags(file, argp);
+	case HFSPLUS_IOC_BLESS:
+		return hfsplus_ioctl_bless(file, argp);
 	default:
 		return -ENOTTY;
 	}
-- 
1.7.7.1

