Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab2I0MwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:52:14 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61278 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2I0MwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:52:13 -0400
From: Yan Hong <clouds.yan@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] fs/namespace.c: introduce helper function path_unmounted()
Date: Thu, 27 Sep 2012 20:51:49 +0800
Message-Id: <1348750316-4138-1-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <no>
References: <no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fs/namespace.c, we verify whether a path is a mountpoint by
comparing path->dentry and path->mnt->mnt_root. Introduce
path_unmounted() to make code more readable.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/namespace.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 4d31f73..3fdc239 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1234,6 +1234,11 @@ static int do_umount(struct mount *mnt, int flags)
 	return retval;
 }
 
+static inline bool path_unmounted(struct path *path)
+{
+	return path->dentry != path->mnt->mnt_root;
+}
+
 /*
  * Now umount can handle mount points as well as block devices.
  * This is important for filesystems which use unnamed block devices.
@@ -1260,7 +1265,7 @@ SYSCALL_DEFINE2(umount, char __user *, name, int, flags)
 		goto out;
 	mnt = real_mount(path.mnt);
 	retval = -EINVAL;
-	if (path.dentry != path.mnt->mnt_root)
+	if (path_unmounted(&path))
 		goto dput_and_out;
 	if (!check_mnt(mnt))
 		goto dput_and_out;
@@ -1613,7 +1618,7 @@ static int do_change_type(struct path *path, int flag)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (path->dentry != path->mnt->mnt_root)
+	if (path_unmounted(path))
 		return -EINVAL;
 
 	type = flags_to_propagation_type(flag);
@@ -1727,7 +1732,7 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	if (!check_mnt(mnt))
 		return -EINVAL;
 
-	if (path->dentry != path->mnt->mnt_root)
+	if (path_unmounted(path))
 		return -EINVAL;
 
 	err = security_sb_remount(sb, data);
@@ -1793,7 +1798,7 @@ static int do_move_mount(struct path *path, char *old_name)
 		goto out1;
 
 	err = -EINVAL;
-	if (old_path.dentry != old_path.mnt->mnt_root)
+	if (path_unmounted(&old_path))
 		goto out1;
 
 	if (!mnt_has_parent(old))
@@ -1892,7 +1897,7 @@ static int do_add_mount(struct mount *newmnt, struct path *path, int mnt_flags)
 	/* Refuse the same filesystem on the same mount point */
 	err = -EBUSY;
 	if (path->mnt->mnt_sb == newmnt->mnt.mnt_sb &&
-	    path->mnt->mnt_root == path->dentry)
+	    !path_unmounted(path))
 		goto unlock;
 
 	err = -EINVAL;
@@ -2534,11 +2539,11 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
 	    old.mnt == root.mnt)
 		goto out4; /* loop, on the same file system  */
 	error = -EINVAL;
-	if (root.mnt->mnt_root != root.dentry)
+	if (path_unmounted(&root))
 		goto out4; /* not a mountpoint */
 	if (!mnt_has_parent(root_mnt))
 		goto out4; /* not attached */
-	if (new.mnt->mnt_root != new.dentry)
+	if (path_unmounted(&new))
 		goto out4; /* not a mountpoint */
 	if (!mnt_has_parent(new_mnt))
 		goto out4; /* not attached */
-- 
1.7.9.5

