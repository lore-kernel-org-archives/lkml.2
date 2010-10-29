Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254Ab0J2J6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:58:37 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:42992 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933703Ab0J2J6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:58:33 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V22 07/14] fs: Remove i_nlink check from file system link callback
Date: Fri, 29 Oct 2010 15:27:16 +0530
Message-Id: <1288346243-12211-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288346243-12211-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1288346243-12211-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that VFS check for inode->i_nlink == 0 and returns proper
error, remove similar check from file system

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/btrfs/inode.c    |    3 ---
 fs/ext3/namei.c     |    7 -------
 fs/ext4/namei.c     |    7 -------
 fs/gfs2/ops_inode.c |    3 ---
 fs/jfs/namei.c      |    3 ---
 fs/reiserfs/namei.c |    4 ----
 fs/ubifs/dir.c      |   18 ------------------
 7 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 64f99cf..fdeaa14 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4734,9 +4734,6 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	int err;
 	int drop_inode = 0;
 
-	if (inode->i_nlink == 0)
-		return -ENOENT;
-
 	/* do not allow sys_link's with other subvols of the same device */
 	if (root->objectid != BTRFS_I(inode)->root->objectid)
 		return -EPERM;
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index bce9dce..3edda98 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2242,13 +2242,6 @@ static int ext3_link (struct dentry * old_dentry,
 
 	dquot_initialize(dir);
 
-	/*
-	 * Return -ENOENT if we've raced with unlink and i_nlink is 0.  Doing
-	 * otherwise has the potential to corrupt the orphan inode list.
-	 */
-	if (inode->i_nlink == 0)
-		return -ENOENT;
-
 retry:
 	handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT3_INDEX_EXTRA_TRANS_BLOCKS);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 92203b8..38c03bf 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2285,13 +2285,6 @@ static int ext4_link(struct dentry *old_dentry,
 
 	dquot_initialize(dir);
 
-	/*
-	 * Return -ENOENT if we've raced with unlink and i_nlink is 0.  Doing
-	 * otherwise has the potential to corrupt the orphan inode list.
-	 */
-	if (inode->i_nlink == 0)
-		return -ENOENT;
-
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS);
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 12cbea7..ff96efc 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -189,9 +189,6 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	error = -EPERM;
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		goto out_gunlock;
-	error = -EINVAL;
-	if (!ip->i_inode.i_nlink)
-		goto out_gunlock;
 	error = -EMLINK;
 	if (ip->i_inode.i_nlink == (u32)-1)
 		goto out_gunlock;
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 231ca4a..2619157 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -808,9 +808,6 @@ static int jfs_link(struct dentry *old_dentry,
 	if (ip->i_nlink == JFS_LINK_MAX)
 		return -EMLINK;
 
-	if (ip->i_nlink == 0)
-		return -ENOENT;
-
 	dquot_initialize(dir);
 
 	tid = txBegin(ip->i_sb, 0);
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index ba5f51e..ae303ca 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -1122,10 +1122,6 @@ static int reiserfs_link(struct dentry *old_dentry, struct inode *dir,
 		reiserfs_write_unlock(dir->i_sb);
 		return -EMLINK;
 	}
-	if (inode->i_nlink == 0) {
-		reiserfs_write_unlock(dir->i_sb);
-		return -ENOENT;
-	}
 
 	/* inc before scheduling so reiserfs_unlink knows we are here */
 	inc_nlink(inode);
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 14f64b6..7217d67 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -522,24 +522,6 @@ static int ubifs_link(struct dentry *old_dentry, struct inode *dir,
 	ubifs_assert(mutex_is_locked(&dir->i_mutex));
 	ubifs_assert(mutex_is_locked(&inode->i_mutex));
 
-	/*
-	 * Return -ENOENT if we've raced with unlink and i_nlink is 0.  Doing
-	 * otherwise has the potential to corrupt the orphan inode list.
-	 *
-	 * Indeed, consider a scenario when 'vfs_link(dirA/fileA)' and
-	 * 'vfs_unlink(dirA/fileA, dirB/fileB)' race. 'vfs_link()' does not
-	 * lock 'dirA->i_mutex', so this is possible. Both of the functions
-	 * lock 'fileA->i_mutex' though. Suppose 'vfs_unlink()' wins, and takes
-	 * 'fileA->i_mutex' mutex first. Suppose 'fileA->i_nlink' is 1. In this
-	 * case 'ubifs_unlink()' will drop the last reference, and put 'inodeA'
-	 * to the list of orphans. After this, 'vfs_link()' will link
-	 * 'dirB/fileB' to 'inodeA'. This is a problem because, for example,
-	 * the subsequent 'vfs_unlink(dirB/fileB)' will add the same inode
-	 * to the list of orphans.
-	 */
-	 if (inode->i_nlink == 0)
-		 return -ENOENT;
-
 	err = dbg_check_synced_i_size(inode);
 	if (err)
 		return err;
-- 
1.7.1

