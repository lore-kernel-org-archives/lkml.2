Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab2BFUS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:18:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab2BFUS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:18:28 -0500
From: Matthew Garrett <mjg@redhat.com>
To: hch@infradead.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V2] hfsplus: Add an ioctl to bless files
Date: Mon,  6 Feb 2012 15:14:40 -0500
Message-Id: <1328559280-29111-1-git-send-email-mjg@redhat.com>
In-Reply-To: <20120206174943.GA14225@infradead.org>
References: <20120206174943.GA14225@infradead.org>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.202
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
Kept the ioctl in the hfs code, but moved it to a different range to reduce
reduce the chances of someone stepping on it with another filesystem.

 Documentation/ioctl/ioctl-number.txt |    1 +
 fs/hfsplus/hfsplus_fs.h              |    5 +++++
 fs/hfsplus/ioctl.c                   |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 4840334..37a4248 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -218,6 +218,7 @@ Code  Seq#(hex)	Include File		Comments
 'h'	00-7F				conflict! Charon filesystem
 					<mailto:zapman@interlan.net>
 'h'	00-1F	linux/hpet.h		conflict!
+'h'	80-8F	fs/hfsplus/ioctl.c
 'i'	00-3F	linux/i2o-dev.h		conflict!
 'i'	0B-1F	linux/ipmi.h		conflict!
 'i'	80-8F	linux/i8k.h
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 21a5b7f..4e75ac6 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -317,6 +317,11 @@ static inline unsigned short hfsplus_min_io_size(struct super_block *sb)
 
 
 /*
+ * hfs+-specific ioctl for making the filesystem bootable
+ */
+#define HFSPLUS_IOC_BLESS _IO('h', 0x80)
+
+/*
  * Functions in any *.c used in other files
  */
 
diff --git a/fs/hfsplus/ioctl.c b/fs/hfsplus/ioctl.c
index f66c765..c640ba5 100644
--- a/fs/hfsplus/ioctl.c
+++ b/fs/hfsplus/ioctl.c
@@ -20,6 +20,38 @@
 #include <asm/uaccess.h>
 #include "hfsplus_fs.h"
 
+/*
+ * "Blessing" an HFS+ filesystem writes metadata to the superblock informing
+ * the platform firmware which file to boot from
+ */
+static int hfsplus_ioctl_bless(struct file *file, int __user *user_flags)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct inode *inode = dentry->d_inode;
+	struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
+	struct hfsplus_vh *vh = sbi->s_vhdr;
+	struct hfsplus_vh *bvh = sbi->s_backup_vhdr;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	mutex_lock(&sbi->vh_mutex);
+
+	/* Directory containing the bootable system */
+	vh->finder_info[0] = bvh->finder_info[0] =
+		cpu_to_be32(parent_ino(dentry));
+
+	/* Bootloader */
+	vh->finder_info[1] = bvh->finder_info[1] = cpu_to_be32(inode->i_ino);
+
+	/* Per spec, the OS X system folder - same as finder_info[0] here */
+	vh->finder_info[5] = bvh->finder_info[5] =
+		cpu_to_be32(parent_ino(dentry));
+
+	mutex_unlock(&sbi->vh_mutex);
+	return 0;
+}
+
 static int hfsplus_ioctl_getflags(struct file *file, int __user *user_flags)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -108,6 +140,8 @@ long hfsplus_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		return hfsplus_ioctl_getflags(file, argp);
 	case HFSPLUS_IOC_EXT2_SETFLAGS:
 		return hfsplus_ioctl_setflags(file, argp);
+	case HFSPLUS_IOC_BLESS:
+		return hfsplus_ioctl_bless(file, argp);
 	default:
 		return -ENOTTY;
 	}
-- 
1.7.7.6

