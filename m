Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab2ITSyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:54:22 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58505 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab2ITSyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:54:17 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: [PATCH 03/13] vfs: introduce clone_private_mount()
Date: Thu, 20 Sep 2012 20:55:20 +0200
Message-Id: <1348167330-30288-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348167330-30288-1-git-send-email-miklos@szeredi.hu>
References: <1348167330-30288-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Overlayfs needs a private clone of the mount, so create a function for
this and export to modules.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c        |   18 ++++++++++++++++++
 include/linux/mount.h |    3 +++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 4d31f73..b4712ea 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1387,6 +1387,24 @@ void drop_collected_mounts(struct vfsmount *mnt)
 	release_mounts(&umount_list);
 }
 
+struct vfsmount *clone_private_mount(struct path *path)
+{
+	struct mount *old_mnt = real_mount(path->mnt);
+	struct mount *new_mnt;
+
+	if (IS_MNT_UNBINDABLE(old_mnt))
+		return ERR_PTR(-EINVAL);
+
+	down_read(&namespace_sem);
+	new_mnt = clone_mnt(old_mnt, path->dentry, CL_PRIVATE);
+	up_read(&namespace_sem);
+	if (!new_mnt)
+		return ERR_PTR(-ENOMEM);
+
+	return &new_mnt->mnt;
+}
+EXPORT_SYMBOL_GPL(clone_private_mount);
+
 int iterate_mounts(int (*f)(struct vfsmount *, void *), void *arg,
 		   struct vfsmount *root)
 {
diff --git a/include/linux/mount.h b/include/linux/mount.h
index d7029f4..344a262 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -66,6 +66,9 @@ extern void mnt_pin(struct vfsmount *mnt);
 extern void mnt_unpin(struct vfsmount *mnt);
 extern int __mnt_is_readonly(struct vfsmount *mnt);
 
+struct path;
+extern struct vfsmount *clone_private_mount(struct path *path);
+
 struct file_system_type;
 extern struct vfsmount *vfs_kern_mount(struct file_system_type *type,
 				      int flags, const char *name,
-- 
1.7.7

