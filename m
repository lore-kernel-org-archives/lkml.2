Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab0IPWOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:14:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819Ab0IPWOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:17 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 04/34] VFS: Add CL_MAKE_HARD_READONLY flag to clone_mnt()/copy_tree()
Date: Thu, 16 Sep 2010 15:11:55 -0700
Message-Id: <1284675145-4391-5-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing the CL_MAKE_HARD_READONLY flag to clone_mnt() causes the clone
to fail if the source superblock is not read-only.  If it is
read-only, it increments the hard read-only users and sets the
MNT_HARD_READONLY flag in the vfsmount.  When the mount is freed via
free_vfsmnt(), automatically decrement the hard read-only users count.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c        |   18 ++++++++++++++++++
 fs/pnode.h            |    1 +
 include/linux/mount.h |    1 +
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 6956062..cbaa3ea 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -400,6 +400,12 @@ EXPORT_SYMBOL(simple_set_mnt);
 void free_vfsmnt(struct vfsmount *mnt)
 {
 	kfree(mnt->mnt_devname);
+	if (mnt->mnt_flags & MNT_HARD_READONLY) {
+		BUG_ON(mnt->mnt_sb->s_hard_readonly_users <= 0);
+		down_write(&mnt->mnt_sb->s_umount);
+		mnt->mnt_sb->s_hard_readonly_users--;
+		up_write(&mnt->mnt_sb->s_umount);
+	}
 	mnt_free_id(mnt);
 #ifdef CONFIG_SMP
 	free_percpu(mnt->mnt_writers);
@@ -568,6 +574,16 @@ static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
 	if ((flag & CL_NO_SLAVE) && (IS_MNT_SLAVE(old)))
 		return ERR_PTR(-EINVAL);
 
+	if (flag & CL_MAKE_HARD_READONLY) {
+		down_write(&sb->s_umount);
+		if (!(sb->s_flags & MS_RDONLY)) {
+			up_write(&sb->s_umount);
+			return ERR_PTR(-EBUSY);
+		}
+		sb->s_hard_readonly_users++;
+		up_write(&sb->s_umount);
+	}
+
 	mnt = alloc_vfsmnt(old->mnt_devname);
 	if (!mnt)
 		return ERR_PTR(-ENOMEM);
@@ -603,6 +619,8 @@ static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
 	}
 	if (flag & CL_MAKE_SHARED)
 		set_mnt_shared(mnt);
+	if (flag & CL_MAKE_HARD_READONLY)
+		mnt->mnt_flags |= MNT_HARD_READONLY;
 
 	/* stick the duplicate mount on the same expiry list
 	 * as the original if that was on one */
diff --git a/fs/pnode.h b/fs/pnode.h
index 8920e47..dc7b468 100644
--- a/fs/pnode.h
+++ b/fs/pnode.h
@@ -24,6 +24,7 @@
 #define CL_PRIVATE 		0x10
 #define CL_NO_SHARED 		0x20
 #define CL_NO_SLAVE 		0x40
+#define CL_MAKE_HARD_READONLY	0x80
 
 static inline void set_mnt_shared(struct vfsmount *mnt)
 {
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 4bd0547..b300cf8 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -46,6 +46,7 @@ struct mnt_namespace;
 
 
 #define MNT_INTERNAL	0x4000
+#define MNT_HARD_READONLY	0x8000	/* has a hard read-only ref on the sb */
 
 struct vfsmount {
 	struct list_head mnt_hash;
-- 
1.6.3.3

