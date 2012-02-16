Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab2BPEYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 23:24:13 -0500
Received: from ozlabs.org ([203.10.76.45]:59653 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754268Ab2BPEYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 23:24:11 -0500
From: David Gibson <david@gibson.dropbear.id.au>
To: akpm@linux-foundation.org, abarry@cray.com
Cc: hughd@google.com, mgorman@suse.de, minchan.kim@gmail.com, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Cleanup to hugetlb.h
Date: Thu, 16 Feb 2012 15:23:59 +1100
Message-Id: <1329366240-11663-2-git-send-email-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329366240-11663-1-git-send-email-david@gibson.dropbear.id.au>
References: <1329366240-11663-1-git-send-email-david@gibson.dropbear.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes a couple of small cleanups to linux/include/hugetlb.h.
The set_file_hugepages() function, which was not used anywhere is removed,
and the hugetlbfs_config and hugetlbfs_inode_info structures with its
HUGETLBFS_I helper function are moved into inode.c, the only place they
were used.

These structures are really linked to the hugetlbfs filesystem specifically
not to hugepage mm handling in general, so they belong in the filesystem
code not in a generally available header.  It would be nice to move the
hugetlbfs_sb_info (superblock) structure in there as well, but it's
currently needed in a number of places via the hstate_vma() and
hstate_inode().

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 fs/hugetlbfs/inode.c    |   19 +++++++++++++++++++
 include/linux/hugetlb.h |   25 -------------------------
 2 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 1e85a7a..bb0e366 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -41,6 +41,25 @@ const struct file_operations hugetlbfs_file_operations;
 static const struct inode_operations hugetlbfs_dir_inode_operations;
 static const struct inode_operations hugetlbfs_inode_operations;
 
+struct hugetlbfs_config {
+	uid_t   uid;
+	gid_t   gid;
+	umode_t mode;
+	long	nr_blocks;
+	long	nr_inodes;
+	struct hstate *hstate;
+};
+
+struct hugetlbfs_inode_info {
+	struct shared_policy policy;
+	struct inode vfs_inode;
+};
+
+static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
+{
+	return container_of(inode, struct hugetlbfs_inode_info, vfs_inode);
+}
+
 static struct backing_dev_info hugetlbfs_backing_dev_info = {
 	.name		= "hugetlbfs",
 	.ra_pages	= 0,	/* No readahead */
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index d9d6c86..7adc492 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -128,15 +128,6 @@ enum {
 };
 
 #ifdef CONFIG_HUGETLBFS
-struct hugetlbfs_config {
-	uid_t   uid;
-	gid_t   gid;
-	umode_t mode;
-	long	nr_blocks;
-	long	nr_inodes;
-	struct hstate *hstate;
-};
-
 struct hugetlbfs_sb_info {
 	long	max_blocks;   /* blocks allowed */
 	long	free_blocks;  /* blocks free */
@@ -146,17 +137,6 @@ struct hugetlbfs_sb_info {
 	struct hstate *hstate;
 };
 
-
-struct hugetlbfs_inode_info {
-	struct shared_policy policy;
-	struct inode vfs_inode;
-};
-
-static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
-{
-	return container_of(inode, struct hugetlbfs_inode_info, vfs_inode);
-}
-
 static inline struct hugetlbfs_sb_info *HUGETLBFS_SB(struct super_block *sb)
 {
 	return sb->s_fs_info;
@@ -179,14 +159,9 @@ static inline int is_file_hugepages(struct file *file)
 	return 0;
 }
 
-static inline void set_file_hugepages(struct file *file)
-{
-	file->f_op = &hugetlbfs_file_operations;
-}
 #else /* !CONFIG_HUGETLBFS */
 
 #define is_file_hugepages(file)			0
-#define set_file_hugepages(file)		BUG()
 static inline struct file *hugetlb_file_setup(const char *name, size_t size,
 		vm_flags_t acctflag, struct user_struct **user, int creat_flags)
 {
-- 
1.7.9

