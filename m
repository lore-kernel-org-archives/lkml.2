Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1APPs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 10:48:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64054 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab1APPsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 10:48:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eeZCxIn99pW+ZWsW6ws9LFasSNBrgkjbntd6IAWubgG5QwtxqHiJZB6mGGcW7xGDMQ
         VFhGQz9PaSmGNvy/z0sYaiTphdiJkvLmMFEM3LqwPuOsJB4vr7At0x5ib4xHaSzIglKc
         7wSaUMLk8unMsoTTf0fAPz1D0CW0jGO1escRM=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: cleanup do_vfs_ioctl()
Date: Mon, 17 Jan 2011 00:48:17 +0900
Message-Id: <1295192897-8690-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move declaration of 'inode' to beginning of the function. Since it
is referenced directly or indirectly (in case of FIFREEZE/FITHAW/
FS_IOC_FIEMAP) it's not harmful IMHO. And remove unnecessary casts
using 'argp' instead.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ioctl.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index a59635e295fa..6dc1acf9ed68 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -541,6 +541,7 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 {
 	int error = 0;
 	int __user *argp = (int __user *)arg;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 
 	switch (cmd) {
 	case FIOCLEX:
@@ -560,13 +561,11 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		break;
 
 	case FIOQSIZE:
-		if (S_ISDIR(filp->f_path.dentry->d_inode->i_mode) ||
-		    S_ISREG(filp->f_path.dentry->d_inode->i_mode) ||
-		    S_ISLNK(filp->f_path.dentry->d_inode->i_mode)) {
-			loff_t res =
-				inode_get_bytes(filp->f_path.dentry->d_inode);
-			error = copy_to_user((loff_t __user *)arg, &res,
-					     sizeof(res)) ? -EFAULT : 0;
+		if (S_ISDIR(inode->i_mode) || S_ISREG(inode->i_mode) ||
+		    S_ISLNK(inode->i_mode)) {
+			loff_t res = inode_get_bytes(inode);
+			error = copy_to_user(argp, &res, sizeof(res)) ?
+					-EFAULT : 0;
 		} else
 			error = -ENOTTY;
 		break;
@@ -583,14 +582,10 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		return ioctl_fiemap(filp, arg);
 
 	case FIGETBSZ:
-	{
-		struct inode *inode = filp->f_path.dentry->d_inode;
-		int __user *p = (int __user *)arg;
-		return put_user(inode->i_sb->s_blocksize, p);
-	}
+		return put_user(inode->i_sb->s_blocksize, argp);
 
 	default:
-		if (S_ISREG(filp->f_path.dentry->d_inode->i_mode))
+		if (S_ISREG(inode->i_mode))
 			error = file_ioctl(filp, cmd, arg);
 		else
 			error = vfs_ioctl(filp, cmd, arg);
-- 
1.7.3.4.600.g982838b0

