Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0IPWOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:14:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab0IPWOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:14:49 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@infradead.org>,
        Andreas Gruenbacher <agruen@suse.de>, Nick Piggin <npiggin@kernel.dk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 19/34] union-mount: Add clone_union_tree() and put_union_sb()
Date: Thu, 16 Sep 2010 15:12:10 -0700
Message-Id: <1284675145-4391-20-git-send-email-vaurora@redhat.com>
In-Reply-To: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
References: <1284675145-4391-1-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A union mount clones the vfsmount tree of all of the read-only layers
of the union and keeps a reference to it in the vfsmount of the
topmost layer of the union.

clone_union_tree() takes the path of the proposed union mountpoint and
attempts to clones every vfsmount mounted at that same pathname, as
well as their submounts.  All these mounts must be read-only, not
slave, and not shared.

put_union_sb() unwinds everything clone_union_tree() does.  It is
called when the superblock is deactivated.  Thus, you can lazy unmount
a union mount and when the last reference goes away, the union will be
torn down.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c        |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mount.h |    2 +
 2 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 62c2f7a..e966890 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1393,6 +1393,77 @@ static int check_topmost_union_mnt(struct vfsmount *topmost_mnt, int mnt_flags)
 	return 0;
 }
 
+void put_union_sb(struct super_block *sb)
+{
+       struct vfsmount *mnt = sb->s_union_lower_mnts;
+       LIST_HEAD(umount_list);
+
+       if (!mnt)
+               return;
+       spin_lock(&vfsmount_lock);
+       umount_tree(mnt, 0, &umount_list);
+       spin_unlock(&vfsmount_lock);
+       release_mounts(&umount_list);
+       sb->s_union_lower_mnts = 0;
+       sb->s_union_count = 0;
+}
+
+/**
+ * clone_union_tree - Clone all union-able mounts at this mountpoint
+ *
+ * @topmost - vfsmount of topmost layer
+ * @mntpnt - target of union mount
+ *
+ * Given the target mountpoint of a union mount, clone all the mounts
+ * at that mountpoint (well, pathname) that qualify as a union lower
+ * layer.  Increment the hard readonly count of the lower layer
+ * superblocks.
+ *
+ * Returns error if any of the mounts or submounts mounted on or below
+ * this pathname are unsuitable for union mounting.  This means you
+ * can't construct a union mount at the root of an existing mount
+ * without unioning it.
+ *
+ * XXX - Maybe should take # of layers to go down as an argument. But
+ * how to pass this in through mount options?  All solutions look
+ * ugly.  Currently you express your intention through mounting file
+ * systems on the same mountpoint, which is pretty elegant.
+ */
+
+static int clone_union_tree(struct vfsmount *topmost, struct path *mntpnt)
+{
+	struct vfsmount *mnt, *cloned_tree;
+
+	if (!IS_ROOT(mntpnt->dentry)) {
+		printk(KERN_INFO "union mount: mount point must be a root dir\n");
+		return -EINVAL;
+	}
+
+	/* Look for the "lowest" layer to union. */
+	mnt = mntpnt->mnt;
+	while (mnt->mnt_parent->mnt_root == mnt->mnt_mountpoint) {
+		/* Got root (mnt)? */
+		if (mnt->mnt_parent == mnt)
+			break;
+		mnt = mnt->mnt_parent;
+	}
+	/*
+	 * Clone all the read-only mounts and submounts, only if they
+	 * are not shared or slave, and increment the hard read-only
+	 * users count on each one.  If this can't be done for every
+	 * mount and submount below this one, fail.
+	 */
+	cloned_tree = copy_tree(mnt, mnt->mnt_root,
+				CL_COPY_ALL | CL_PRIVATE |
+				CL_NO_SHARED | CL_NO_SLAVE |
+				CL_MAKE_HARD_READONLY);
+	if (IS_ERR(cloned_tree))
+		return PTR_ERR(cloned_tree);
+
+	topmost->mnt_sb->s_union_lower_mnts = cloned_tree;
+	return 0;
+}
+
 /*
  *  @source_mnt : mount tree to be attached
  *  @nd         : place the mount tree @source_mnt is attached
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 4014ff1..5643835 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -138,4 +138,6 @@ extern void mark_mounts_for_expiry(struct list_head *mounts);
 
 extern dev_t name_to_dev_t(char *name);
 
+extern void put_union_sb(struct super_block *sb);
+
 #endif /* _LINUX_MOUNT_H */
-- 
1.6.3.3

