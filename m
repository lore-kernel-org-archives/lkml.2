Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2HOPu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:50:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39288 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755446Ab2HOPrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:47:15 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com, dhowells@redhat.com,
        hpj@urpla.net, sedat.dilek@googlemail.com, penberg@kernel.org,
        goran.cetusic@gmail.com, romain@orebokech.com, mszeredi@suse.cz
Subject: [PATCH 03/13] vfs: introduce clone_private_mount()
Date: Wed, 15 Aug 2012 17:48:10 +0200
Message-Id: <1345045700-9062-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
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

