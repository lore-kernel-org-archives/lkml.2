Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab1LUScy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:32:54 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43012 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab1LUSav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:30:51 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, mszeredi@suse.cz
Subject: [PATCH 4/9] vfs: introduce clone_private_mount()
Date: Wed, 21 Dec 2011 19:29:43 +0100
Message-Id: <1324492188-3481-5-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1324492188-3481-1-git-send-email-miklos@szeredi.hu>
References: <1324492188-3481-1-git-send-email-miklos@szeredi.hu>
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
index 7e6f2c9..e93321e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1327,6 +1327,24 @@ void drop_collected_mounts(struct vfsmount *mnt)
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

