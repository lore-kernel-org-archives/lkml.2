Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab1EQMbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:31:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57108 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab1EQMa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:30:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=szeredi.hu; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IobmuRhABPayyMTvDxp0tE/6NoC1oBqT78bUNfGGZSOq0TnawGpUsvnlILu2r+Rjez
         0lisf+Au0P35RMlWyRKeasqwt2YT8jo8B8xs5XLAPzdd6hLMcyGwjVR0waNWVrk3LnXT
         T29BF9e8G7LmQPj0JqnZ1CldXbcBEnM0VzMRk=
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, jordipujolp@gmail.com,
        mszeredi@suse.cz
Subject: [PATCH 4/7] vfs: introduce clone_private_mount()
Date: Tue, 17 May 2011 14:30:49 +0200
Message-Id: <1305635452-14835-5-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
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
index d99bcf5..4bcc60e9 100644
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
1.7.3.4

