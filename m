Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1AFMJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 07:09:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52905 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab1AFMJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 07:09:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=nbsGdtSaaPG98XkBWzkGTRUr3u5epzuQMoEaXq3bcK5D6pf0cPigGL22UFTCzyJFqy
         BxzhXOI9HX44eDKBj1ldsNE9f3QtlBEGeqxuxbxNug8YkC33WMNHukmWjg+kQGbsPfRE
         Bzp4QD8/Tcjm+23L+m5/FdSKU6ReHWZdLuixE=
Message-ID: <4D25AFDE.5040107@gmail.com>
Date: Thu, 06 Jan 2011 13:04:46 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>
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
diff --git a/fs/pramfs/ioctl.c b/fs/pramfs/ioctl.c
new file mode 100644
index 0000000..092cbe6
--- /dev/null
+++ b/fs/pramfs/ioctl.c
@@ -0,0 +1,121 @@
+/*
+ * BRIEF DESCRIPTION
+ *
+ * Ioctl operations.
+ *
+ * Copyright 2010 Marco Stornelli <marco.stornelli@gmail.com>
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
+		flags = be32_to_cpu(pi->i_flags) & FS_FL_USER_VISIBLE;
+		return put_user(flags, (int __user *) arg);
+	case FS_IOC_SETFLAGS: {
+		unsigned int oldflags;
+
+		ret = mnt_want_write(filp->f_path.mnt);
+		if (ret)
+			return ret;
+
+		if (!is_owner_or_cap(inode)) {
+			ret = -EACCES;
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
+		mnt_drop_write(filp->f_path.mnt);
+		return ret;
+	}
+	case FS_IOC_GETVERSION:
+		return put_user(inode->i_generation, (int __user *) arg);
+	case FS_IOC_SETVERSION:
+		if (!is_owner_or_cap(inode))
+			return -EPERM;
+		ret = mnt_want_write(filp->f_path.mnt);
+		if (ret)
+			return ret;
+		if (get_user(inode->i_generation, (int __user *) arg)) {
+			ret = -EFAULT;
+		} else {
+			inode->i_ctime = CURRENT_TIME_SEC;
+			pram_update_inode(inode);
+		}
+		mnt_drop_write(filp->f_path.mnt);
+		return ret;
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
