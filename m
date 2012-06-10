Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2FJJXf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 05:23:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44841 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955Ab2FJJXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 05:23:32 -0400
Message-ID: <4FD4660F.2000908@gmail.com>
Date: Sun, 10 Jun 2012 11:17:03 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/17] pramfs: ioctl operations
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marco Stornelli <marco.stornelli@gmail.com>

Ioctl operations.

Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
---
diff -Nurp linux-3.5-rc2-orig/fs/pramfs/ioctl.c linux-3.5-rc2/fs/pramfs/ioctl.c
--- linux-3.5-rc2-orig/fs/pramfs/ioctl.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-3.5-rc2/fs/pramfs/ioctl.c	2012-06-10 10:08:28.000000000 +0200
@@ -0,0 +1,127 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Ioctl operations.
+ *
+ * Copyright 2010-2011 Marco Stornelli <marco.stornelli@gmail.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/capability.h>
+#include <linux/time.h>
+#include <linux/sched.h>
+#include <linux/compat.h>
+#include <linux/mount.h>
+#include "pram.h"
+
+long pram_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct inode *inode = filp->f_dentry->d_inode;
+	struct pram_inode *pi;
+	unsigned int flags;
+	int ret;
+
+	pi = pram_get_inode(inode->i_sb, inode->i_ino);
+	if (!pi)
+		return -EACCES;
+
+	switch (cmd) {
+	case FS_IOC_GETFLAGS:
+		flags = be32_to_cpu(pi->i_flags) & PRAM_FL_USER_VISIBLE;
+		return put_user(flags, (int __user *) arg);
+	case FS_IOC_SETFLAGS: {
+		unsigned int oldflags;
+
+		ret = mnt_want_write_file(filp);
+		if (ret)
+			return ret;
+
+		if (!inode_owner_or_capable(inode)) {
+			ret = -EPERM;
+			goto flags_out;
+		}
+
+		if (get_user(flags, (int __user *) arg)) {
+			ret = -EFAULT;
+			goto flags_out;
+		}
+
+		mutex_lock(&inode->i_mutex);
+		oldflags = be32_to_cpu(pi->i_flags);
+
+		if ((flags ^ oldflags) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
+			if (!capable(CAP_LINUX_IMMUTABLE)) {
+				mutex_unlock(&inode->i_mutex);
+				ret = -EPERM;
+				goto flags_out;
+			}
+		}
+
+		if (!S_ISDIR(inode->i_mode))
+			flags &= ~FS_DIRSYNC_FL;
+
+		flags = flags & FS_FL_USER_MODIFIABLE;
+		flags |= oldflags & ~FS_FL_USER_MODIFIABLE;
+		pram_memunlock_inode(inode->i_sb, pi);
+		pi->i_flags = cpu_to_be32(flags);
+		inode->i_ctime = CURRENT_TIME_SEC;
+		pi->i_ctime = cpu_to_be32(inode->i_ctime.tv_sec);
+		pram_set_inode_flags(inode, pi);
+		pram_memlock_inode(inode->i_sb, pi);
+		mutex_unlock(&inode->i_mutex);
+flags_out:
+		mnt_drop_write_file(filp);
+		return ret;
+	}
+	case FS_IOC_GETVERSION:
+		return put_user(inode->i_generation, (int __user *) arg);
+	case FS_IOC_SETVERSION: {
+		__u32 generation;
+		if (!inode_owner_or_capable(inode))
+			return -EPERM;
+		ret = mnt_want_write_file(filp);
+		if (ret)
+			return ret;
+		if (get_user(generation, (int __user *) arg)) {
+			ret = -EFAULT;
+			goto setversion_out;
+		}
+		mutex_lock(&inode->i_mutex);
+		inode->i_ctime = CURRENT_TIME_SEC;
+		inode->i_generation = generation;
+		pram_update_inode(inode);
+		mutex_unlock(&inode->i_mutex);
+setversion_out:
+		mnt_drop_write_file(filp);
+		return ret;
+	}
+	default:
+		return -ENOTTY;
+	}
+}
+
+#ifdef CONFIG_COMPAT
+long pram_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case FS_IOC32_GETFLAGS:
+		cmd = FS_IOC_GETFLAGS;
+		break;
+	case FS_IOC32_SETFLAGS:
+		cmd = FS_IOC_SETFLAGS;
+		break;
+	case FS_IOC32_GETVERSION:
+		cmd = FS_IOC_GETVERSION;
+		break;
+	case FS_IOC32_SETVERSION:
+		cmd = FS_IOC_SETVERSION;
+		break;
+	default:
+		return -ENOIOCTLCMD;
+	}
+	return pram_ioctl(file, cmd, (unsigned long) compat_ptr(arg));
+}
+#endif
