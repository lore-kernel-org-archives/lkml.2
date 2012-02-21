Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab2BUTyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 14:54:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab2BUTx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:53:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 32/73] union-mount: Add clone_union_tree() and put_union_sb()
 [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 21 Feb 2012 18:01:32 +0000
Message-ID: <20120221180132.25235.71617.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora <vaurora@redhat.com>

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

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/namespace.c        |   67 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mount.h |    2 +
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index bed9ccd..5fbe3b0 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1450,6 +1450,73 @@ static int check_topmost_union_mnt(struct vfsmount *topmost_mnt, int mnt_flags)
 #endif
 }
 
+void put_union_sb(struct super_block *sb)
+{
+	if (unlikely(sb->s_union_lower_mnts)) {
+		struct mount *mnt = real_mount(sb->s_union_lower_mnts);
+		LIST_HEAD(umount_list);
+
+		br_write_lock(vfsmount_lock);
+		umount_tree(mnt, 0, &umount_list);
+		br_write_unlock(vfsmount_lock);
+		release_mounts(&umount_list);
+		sb->s_union_lower_mnts = NULL;
+		sb->s_union_count = 0;
+	}
+}
+
+/**
+ * clone_union_tree - Clone all union-able mounts at this mountpoint
+ * @topmost: vfsmount of topmost layer
+ * @mntpnt: target of union mount
+ *
+ * Given the target mountpoint of a union mount, clone all the mounts at that
+ * mountpoint (well, pathname) that qualify as a union lower layer.  Increment
+ * the hard readonly count of the lower layer superblocks.
+ *
+ * Returns error if any of the mounts or submounts mounted on or below this
+ * pathname are unsuitable for union mounting.  This means you can't construct
+ * a union mount at the root of an existing mount without unioning it.
+ *
+ * XXX - Maybe should take # of layers to go down as an argument. But how to
+ * pass this in through mount options?  All solutions look ugly.  Currently you
+ * express your intention through mounting file systems on the same mountpoint,
+ * which is pretty elegant.
+ */
+static int clone_union_tree(struct mount *topmost, struct path *mntpnt)
+{
+	struct mount *mnt, *cloned_tree;
+
+	if (!IS_ROOT(mntpnt->dentry)) {
+		printk(KERN_INFO "union mount: mount point must be a root dir\n");
+		return -EINVAL;
+	}
+
+	/* Look for the "lowest" layer to union. */
+	mnt = real_mount(mntpnt->mnt);
+	while (mnt->mnt_parent->mnt.mnt_root == mnt->mnt_mountpoint) {
+		/* Got root (mnt)? */
+		if (mnt->mnt_parent == mnt)
+			break;
+		mnt = mnt->mnt_parent;
+	}
+
+	/* Clone all the read-only mounts and submounts, only if they
+	 * are not shared or slave, and increment the hard read-only
+	 * users count on each one.  If this can't be done for every
+	 * mount and submount below this one, fail.
+	 */
+	cloned_tree = copy_tree(mnt, mnt->mnt.mnt_root,
+				CL_COPY_ALL | CL_PRIVATE |
+				CL_NO_SHARED | CL_NO_SLAVE |
+				CL_MAKE_HARD_READONLY);
+	if (IS_ERR(cloned_tree))
+		return PTR_ERR(cloned_tree);
+
+	topmost->mnt.mnt_sb->s_union_lower_mnts = &cloned_tree->mnt;
+	return 0;
+}
+
 /*
  *  @source_mnt : mount tree to be attached
  *  @nd         : place the mount tree @source_mnt is attached
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 0ba1def..67f46fa 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -78,4 +78,6 @@ extern void mark_mounts_for_expiry(struct list_head *mounts);
 
 extern dev_t name_to_dev_t(char *name);
 
+extern void put_union_sb(struct super_block *sb);
+
 #endif /* _LINUX_MOUNT_H */

