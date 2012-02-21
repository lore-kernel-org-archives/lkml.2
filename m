Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2BUUGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 15:06:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570Ab2BUTwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 14:52:53 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 40/73] union-mount: Implement union mount [ver #2]
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        valerie.aurora@gmail.com
Cc: linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com> (Forward port)
Date: Tue, 21 Feb 2012 18:02:31 +0000
Message-ID: <20120221180231.25235.89119.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
References: <20120221175721.25235.8901.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up till this commit, mount with MS_UNION flag succeeded but didn't
actually union the file systems.  Now call the functions to check
the source mounts and create/destroy the per-vfsmount union structures.

Original-author: Valerie Aurora <vaurora@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com> (Forward port)
---

 fs/namespace.c |   43 +++++++++++++++++++++++++++----------------
 fs/super.c     |    1 +
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5e8328e..306565b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1424,9 +1424,9 @@ static int invent_group_ids(struct mount *mnt, bool recurse)
  * fallthrus.  The topmost file system can't be mounted elsewhere
  * because it's Too Hard(tm).
  */
-static int check_topmost_union_mnt(struct vfsmount *topmost_mnt, int mnt_flags)
+static int check_topmost_union_mnt(struct mount *topmost_mnt, int mnt_flags)
 {
-	struct super_block *sb = topmost_mnt->mnt_sb;
+	struct super_block *sb = topmost_mnt->mnt.mnt_sb;
 
 #ifndef CONFIG_UNION_MOUNT
 	printk(KERN_INFO "union mount: not supported by the kernel\n");
@@ -1529,7 +1529,7 @@ static int clone_union_tree(struct mount *topmost, struct path *mntpnt)
  * union "up" from the root of the cloned tree to find the topmost read-only
  * mount, and then traverse back "down" to build the stack.
  */
-static int build_root_union(struct vfsmount *topmost_mnt)
+static int build_root_union(struct mount *topmost_mnt)
 {
 	struct path lower, topmost_path;
 	struct mount *mnt, *topmost_ro_mnt;
@@ -1537,7 +1537,7 @@ static int build_root_union(struct vfsmount *topmost_mnt)
 	int err = 0;
 
 	/* Find the topmost read-only mount */
-	topmost_ro_mnt = real_mount(topmost_mnt->mnt_sb->s_union_lower_mnts);
+	topmost_ro_mnt = real_mount(topmost_mnt->mnt.mnt_sb->s_union_lower_mnts);
 	for (mnt = topmost_ro_mnt; mnt; mnt = next_mnt(mnt, topmost_ro_mnt)) {
 		if (mnt->mnt_parent == topmost_ro_mnt &&
 		    mnt->mnt_mountpoint == topmost_ro_mnt->mnt.mnt_root) {
@@ -1545,13 +1545,13 @@ static int build_root_union(struct vfsmount *topmost_mnt)
 			layers++;
 		}
 	}
-	topmost_mnt->mnt_sb->s_union_count = layers;
+	topmost_mnt->mnt.mnt_sb->s_union_count = layers;
 
 	// SHOULD USE collect_mounts() here rather than merely mntgetting
 
 	/* Build the root dir's union stack from the top down */
-	topmost_path.mnt = topmost_mnt;
-	topmost_path.dentry = topmost_mnt->mnt_root;
+	topmost_path.mnt = &topmost_mnt->mnt;
+	topmost_path.dentry = topmost_mnt->mnt.mnt_root;
 	mnt = topmost_ro_mnt;
 	for (i = 0; i < layers; i++) {
 		lower.mnt = mntget(&mnt->mnt); // !!!!!!!!!! TODO: FIX
@@ -1565,7 +1565,7 @@ static int build_root_union(struct vfsmount *topmost_mnt)
 
 out:
 	d_free_unions(topmost_path.dentry);
-	topmost_mnt->mnt_sb->s_union_count = 0;
+	topmost_mnt->mnt.mnt_sb->s_union_count = 0;
 	return err;
 }
 
@@ -1581,15 +1581,15 @@ out:
  *
  * Caller needs namespace_sem, but can't have vfsmount_lock.
  */
-static int prepare_mnt_union(struct vfsmount *topmost_mnt, struct path *mntpnt)
+static int prepare_mnt_union(struct mount *topmost_mnt, struct path *mntpnt)
 {
 	int err;
 
-	err = check_topmost_union_mnt(topmost_mnt, topmost_mnt->mnt_flags);
+	err = check_topmost_union_mnt(topmost_mnt, topmost_mnt->mnt.mnt_flags);
 	if (err)
 		return err;
 
-	err = clone_union_tree(real_mount(topmost_mnt), mntpnt);
+	err = clone_union_tree(topmost_mnt, mntpnt);
 	if (err)
 		return err;
 
@@ -1599,14 +1599,14 @@ static int prepare_mnt_union(struct vfsmount *topmost_mnt, struct path *mntpnt)
 	return 0;
 
 out:
-	put_union_sb(topmost_mnt->mnt_sb);
+	put_union_sb(topmost_mnt->mnt.mnt_sb);
 	return err;
 }
 
-static void cleanup_mnt_union(struct vfsmount *topmost_mnt)
+static void cleanup_mnt_union(struct mount *topmost_mnt)
 {
-	d_free_unions(topmost_mnt->mnt_root);
-	put_union_sb(topmost_mnt->mnt_sb);
+	d_free_unions(topmost_mnt->mnt.mnt_root);
+	put_union_sb(topmost_mnt->mnt.mnt_sb);
 }
 
 /*
@@ -1686,9 +1686,17 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 		if (err)
 			goto out;
 	}
+
+	/* parent_path means we are moving an existing unioned mount */
+	if (!parent_path && IS_MNT_UNION(&source_mnt->mnt)) {
+		err = prepare_mnt_union(source_mnt, path);
+		if (err)
+			goto out_cleanup_ids;
+	}
+
 	err = propagate_mnt(dest_mnt, dest_dentry, source_mnt, &tree_list);
 	if (err)
-		goto out_cleanup_ids;
+		goto out_cleanup_union;
 
 	br_write_lock(vfsmount_lock);
 
@@ -1713,6 +1721,9 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 
 	return 0;
 
+ out_cleanup_union:
+	if (!parent_path && IS_MNT_UNION(&source_mnt->mnt))
+		cleanup_mnt_union(source_mnt);
  out_cleanup_ids:
 	if (IS_MNT_SHARED(dest_mnt))
 		cleanup_group_ids(source_mnt, NULL);
diff --git a/fs/super.c b/fs/super.c
index 4d24f05..992e2b0 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -266,6 +266,7 @@ void deactivate_locked_super(struct super_block *s)
 		 */
 		rcu_barrier();
 		put_filesystem(fs);
+		put_union_sb(s);
 		put_super(s);
 	} else {
 		up_write(&s->s_umount);

