Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab1IPT1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 15:27:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47303 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab1IPT1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 15:27:35 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, tytso@mit.edu,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/3] ext4: fix quota accounting during inode migration
Date: Fri, 16 Sep 2011 23:27:28 +0400
Message-Id: <1316201249-16819-2-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1316201249-16819-1-git-send-email-dmonakhov@openvz.org>
References: <1316201249-16819-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tmp_inode should have same uid/gid as  original inode.
Otherwise new metadata blocks will be accounted in to wrong quota-id.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h    |    3 ++-
 fs/ext4/ialloc.c  |    9 ++++++---
 fs/ext4/migrate.c |    7 +++++--
 fs/ext4/namei.c   |    8 ++++----
 4 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1921392..a262161 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1767,7 +1767,8 @@ extern int ext4fs_dirhash(const char *name, int len, struct
 
 /* ialloc.c */
 extern struct inode *ext4_new_inode(handle_t *, struct inode *, int,
-				    const struct qstr *qstr, __u32 goal);
+				const struct qstr *qstr, __u32 goal,
+				uid_t *owner);
 extern void ext4_free_inode(handle_t *, struct inode *);
 extern struct inode * ext4_orphan_get(struct super_block *, unsigned long);
 extern unsigned long ext4_count_free_inodes(struct super_block *);
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 21bb2f6..61a9991 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -802,7 +802,7 @@ err_ret:
  * group to find a free inode.
  */
 struct inode *ext4_new_inode(handle_t *handle, struct inode *dir, int mode,
-			     const struct qstr *qstr, __u32 goal)
+			const struct qstr *qstr, __u32 goal, uid_t *owner)
 {
 	struct super_block *sb;
 	struct buffer_head *inode_bitmap_bh = NULL;
@@ -987,8 +987,11 @@ got:
 		flex_group = ext4_flex_group(sbi, group);
 		atomic_dec(&sbi->s_flex_groups[flex_group].free_inodes);
 	}
-
-	if (test_opt(sb, GRPID)) {
+	if (owner) {
+		inode->i_mode = mode;
+		inode->i_uid = owner[0];
+		inode->i_gid = owner[1];
+	} else if (test_opt(sb, GRPID)) {
 		inode->i_mode = mode;
 		inode->i_uid = current_fsuid();
 		inode->i_gid = dir->i_gid;
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index e263d78..74f2900 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -438,6 +438,7 @@ int ext4_ext_migrate(struct inode *inode)
 	struct migrate_struct lb;
 	unsigned long max_entries;
 	__u32 goal;
+	uid_t owner[2];
 
 	/*
 	 * If the filesystem does not support extents, or the inode
@@ -465,10 +466,12 @@ int ext4_ext_migrate(struct inode *inode)
 	}
 	goal = (((inode->i_ino - 1) / EXT4_INODES_PER_GROUP(inode->i_sb)) *
 		EXT4_INODES_PER_GROUP(inode->i_sb)) + 1;
+	owner[0] = inode->i_uid;
+	owner[1] = inode->i_gid;
 	tmp_inode = ext4_new_inode(handle, inode->i_sb->s_root->d_inode,
-				   S_IFREG, NULL, goal);
+				S_IFREG, NULL, goal, owner);
 	if (IS_ERR(tmp_inode)) {
-		retval = -ENOMEM;
+		retval = PTR_ERR(inode);
 		ext4_journal_stop(handle);
 		return retval;
 	}
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b754b77..0a23dfd 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1759,7 +1759,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
 
-	inode = ext4_new_inode(handle, dir, mode, &dentry->d_name, 0);
+	inode = ext4_new_inode(handle, dir, mode, &dentry->d_name, 0, NULL);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		inode->i_op = &ext4_file_inode_operations;
@@ -1795,7 +1795,7 @@ retry:
 	if (IS_DIRSYNC(dir))
 		ext4_handle_sync(handle);
 
-	inode = ext4_new_inode(handle, dir, mode, &dentry->d_name, 0);
+	inode = ext4_new_inode(handle, dir, mode, &dentry->d_name, 0, NULL);
 	err = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
 		init_special_inode(inode, inode->i_mode, rdev);
@@ -1835,7 +1835,7 @@ retry:
 		ext4_handle_sync(handle);
 
 	inode = ext4_new_inode(handle, dir, S_IFDIR | mode,
-			       &dentry->d_name, 0);
+				&dentry->d_name, 0, NULL);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_stop;
@@ -2287,7 +2287,7 @@ retry:
 		ext4_handle_sync(handle);
 
 	inode = ext4_new_inode(handle, dir, S_IFLNK|S_IRWXUGO,
-			       &dentry->d_name, 0);
+				&dentry->d_name, 0, NULL);
 	err = PTR_ERR(inode);
 	if (IS_ERR(inode))
 		goto out_stop;
-- 
1.7.2.3

