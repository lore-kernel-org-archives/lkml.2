Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab1DRQCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:02:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40780 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755475Ab1DRQBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PXQX3ycu4BDsS79bDJM+Fa/plMP3uKG3Xs0jRCiky/peMTKaXYxHzezJvNDo1Gd+04
         07/istnzUARdtkTdwefyi5FkjviAqYNROf45dHZ3siEkvuG9IE0m18n8crxvHUii/+B6
         z1n3f6V1frDAYjZpIIFTNVMm9bfWGg+4ocOCo=
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 3/6] vfs: introduce clone_private_mount()
Date: Mon, 18 Apr 2011 18:00:37 +0200
Message-Id: <1303142440-26328-4-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1303142440-26328-1-git-send-email-miklos@szeredi.hu>
References: <1303142440-26328-1-git-send-email-miklos@szeredi.hu>
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
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index d99bcf5..4bcc60e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1494,6 +1494,23 @@ void drop_collected_mounts(struct vfsmount *mnt)
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
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 604f122..44e9bf4 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -100,6 +100,9 @@ extern void mnt_pin(struct vfsmount *mnt);
 extern void mnt_unpin(struct vfsmount *mnt);
 extern int __mnt_is_readonly(struct vfsmount *mnt);
 
+struct path;
+extern struct vfsmount *clone_private_mount(struct path *path);
+
 extern struct vfsmount *do_kern_mount(const char *fstype, int flags,
 				      const char *name, void *data);
 
-- 
1.7.1

