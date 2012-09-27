Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab2I0Mwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:52:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41412 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab2I0Mw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:52:26 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] fs/namespace.c: check permission early in sys_[u]mount
Date: Thu, 27 Sep 2012 20:51:52 +0800
Message-Id: <1348750316-4138-4-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348750316-4138-1-git-send-email-clouds.yan@gmail.com>
References: <no>
 <1348750316-4138-1-git-send-email-clouds.yan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have several branches in sys_mount, each of them will check
CAP_SYS_ADMIN capability seperately. Do this check at the beginning
of sys_mount.

Also check permission as early as possible in sys_umount.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/namespace.c |   26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index bbe9014..ca2b6e9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1256,6 +1256,9 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
 	if (flags & ~(MNT_FORCE | MNT_DETACH | MNT_EXPIRE | UMOUNT_NOFOLLOW))
 		return -EINVAL;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (!(flags & UMOUNT_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
 
@@ -1269,10 +1272,6 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
 	if (!check_mnt(mnt))
 		goto dput_and_out;
 
-	retval = -EPERM;
-	if (!capable(CAP_SYS_ADMIN))
-		goto dput_and_out;
-
 	retval = do_umount(mnt, flags);
 dput_and_out:
 	/* we mustn't call path_put() as that would clear mnt_expiry_mark */
@@ -1296,9 +1295,7 @@ SYSCALL_DEFINE1(oldumount, char __user *, name)
 
 static int mount_is_safe(struct path *path)
 {
-	if (capable(CAP_SYS_ADMIN))
-		return 0;
-	return -EPERM;
+	return 0;
 #ifdef notyet
 	if (S_ISLNK(path->dentry->d_inode->i_mode))
 		return -EPERM;
@@ -1614,9 +1611,6 @@ static int do_change_type(struct path *path, int flag)
 	int type;
 	int err = 0;
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	if (path_unmounted(path))
 		return -EINVAL;
 
@@ -1725,9 +1719,6 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	struct super_block *sb = path->mnt->mnt_sb;
 	struct mount *mnt = real_mount(path->mnt);
 
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	if (!check_mnt(mnt))
 		return -EINVAL;
 
@@ -1774,8 +1765,6 @@ static int do_move_mount(struct path *path, char *old_name)
 	struct mount *p;
 	struct mount *old;
 	int err = 0;
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
 	if (!old_name || !*old_name)
 		return -EINVAL;
 	err = kern_path(old_name, LOOKUP_FOLLOW, &old_path);
@@ -1924,10 +1913,6 @@ static int do_new_mount(struct path *path, char *type, int flags,
 	if (!type)
 		return -EINVAL;
 
-	/* we need capabilities... */
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
 	mnt = do_kern_mount(type, flags, name, data);
 	if (IS_ERR(mnt))
 		return PTR_ERR(mnt);
@@ -2410,6 +2395,9 @@ SYSCALL_DEFINE5(mount, char __user *, dev_name, char __user *, dir_name,
 	char *kernel_dev;
 	unsigned long data_page;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	ret = copy_mount_string(type, &kernel_type);
 	if (ret < 0)
 		goto out_type;
-- 
1.7.9.5

