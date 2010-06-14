Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab0FNOPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:15:17 -0400
Received: from thunk.org ([69.25.196.29]:40206 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753931Ab0FNOPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:15:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Johannes Stezenbach <js@sig21.net>
Subject: [PATCH -v2] Only honor the FIGETBSZ ioctl for regular files and directories
Date: Mon, 14 Jun 2010 10:15:11 -0400
Message-Id: <1276524911-26177-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100614141256.GB22163@thunk.org><20100614141256.GB22163@thunk.org>
References: <20100614141256.GB22163@thunk.org><20100614141256.GB22163@thunk.org>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIGETBSZ has an ioctl number of _IO(0x00,2) == 2, which can conflict
with device driver ioctls.  Let's avoid the potential for problems by
only honoring the ioctl number for files where this ioctl is likely
going to be useful: regular files, directories, and symlinks.

Thanks to Johannes Stezenbach for pointing this consequence of commit
19ba0559.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Johannes Stezenbach <js@sig21.net>
---
 fs/compat_ioctl.c |    6 +++++-
 fs/ioctl.c        |    5 ++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 641640d..b8607fe 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -1715,8 +1715,12 @@ asmlinkage long compat_sys_ioctl(unsigned int fd, unsigned int cmd,
 		goto out_fput;
 #endif
 
-	case FIBMAP:
 	case FIGETBSZ:
+		if (S_ISDIR(filp->f_path.dentry->d_inode->i_mode))
+			break;
+		/*FALL THROUGH */
+
+	case FIBMAP:
 	case FIONREAD:
 		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
 			break;
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 2d140a7..e578dab 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -597,7 +597,10 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	{
 		struct inode *inode = filp->f_path.dentry->d_inode;
 		int __user *p = (int __user *)arg;
-		return put_user(inode->i_sb->s_blocksize, p);
+
+		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))
+			return put_user(inode->i_sb->s_blocksize, p);
+		/* FALL THROUGH */
 	}
 
 	default:
-- 
1.7.0.4

