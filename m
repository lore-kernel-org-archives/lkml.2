Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab1CVPav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:30:51 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47016 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab1CVPah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:30:37 -0400
Message-Id: <20110322153017.290391787@szeredi.hu>
References: <20110322152602.053930811@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 22 Mar 2011 16:26:05 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de
Subject: [PATCH 3/6 v7] vfs: introduce clone_private_mount()
Content-Disposition: inline; filename=vfs-export-clone_mnt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Overlayfs needs a private clone of the mount, so create a function for
this and export to modules.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c        |   17 +++++++++++++++++
 include/linux/mount.h |    3 +++
 2 files changed, 20 insertions(+)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2011-03-22 15:11:27.000000000 +0100
+++ linux-2.6/fs/namespace.c	2011-03-22 15:11:34.000000000 +0100
@@ -1510,6 +1510,23 @@ void drop_collected_mounts(struct vfsmou
 	release_mounts(&umount_list);
 }
 
+struct vfsmount *clone_private_mount(struct path *path)
+{
+	struct vfsmount *mnt;
+
+	if (IS_MNT_UNBINDABLE(path->mnt))
+		return ERR_PTR(-EINVAL);
+
+	down_read(&namespace_sem);
+	mnt = clone_mnt(path->mnt, path->dentry, CL_PRIVATE);
+	up_read(&namespace_sem);
+	if (!mnt)
+		return ERR_PTR(-ENOMEM);
+
+	return mnt;
+}
+EXPORT_SYMBOL_GPL(clone_private_mount);
+
 int iterate_mounts(int (*f)(struct vfsmount *, void *), void *arg,
 		   struct vfsmount *root)
 {
Index: linux-2.6/include/linux/mount.h
===================================================================
--- linux-2.6.orig/include/linux/mount.h	2011-03-22 15:11:27.000000000 +0100
+++ linux-2.6/include/linux/mount.h	2011-03-22 15:11:34.000000000 +0100
@@ -100,6 +100,9 @@ extern void mnt_pin(struct vfsmount *mnt
 extern void mnt_unpin(struct vfsmount *mnt);
 extern int __mnt_is_readonly(struct vfsmount *mnt);
 
+struct path;
+extern struct vfsmount *clone_private_mount(struct path *path);
+
 extern struct vfsmount *do_kern_mount(const char *fstype, int flags,
 				      const char *name, void *data);
 

-- 
