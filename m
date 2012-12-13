Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab2LMOIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:08:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44546 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab2LMOIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:08:09 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 120/241] reiserfs: Move quota calls out of write lock
Date: Thu, 13 Dec 2012 11:58:05 -0200
Message-Id: <1355407206-17100-121-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 7af11686933726e99af22901d622f9e161404e6b upstream.

Calls into highlevel quota code cannot happen under the write lock. These
calls take dqio_mutex which ranks above write lock. So drop write lock
before calling back into quota code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/reiserfs/inode.c |   10 +++++++---
 fs/reiserfs/stree.c |    4 ++++
 fs/reiserfs/super.c |   18 ++++++++++++++----
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 0192f86..210f70e 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1782,8 +1782,9 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
 
 	BUG_ON(!th->t_trans_id);
 
-	dquot_initialize(inode);
+	reiserfs_write_unlock(inode->i_sb);
 	err = dquot_alloc_inode(inode);
+	reiserfs_write_lock(inode->i_sb);
 	if (err)
 		goto out_end_trans;
 	if (!dir->i_nlink) {
@@ -1979,8 +1980,10 @@ int reiserfs_new_inode(struct reiserfs_transaction_handle *th,
 
       out_end_trans:
 	journal_end(th, th->t_super, th->t_blocks_allocated);
+	reiserfs_write_unlock(inode->i_sb);
 	/* Drop can be outside and it needs more credits so it's better to have it outside */
 	dquot_drop(inode);
+	reiserfs_write_lock(inode->i_sb);
 	inode->i_flags |= S_NOQUOTA;
 	make_bad_inode(inode);
 
@@ -3103,10 +3106,9 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
 	/* must be turned off for recursive notify_change calls */
 	ia_valid = attr->ia_valid &= ~(ATTR_KILL_SUID|ATTR_KILL_SGID);
 
-	depth = reiserfs_write_lock_once(inode->i_sb);
 	if (is_quota_modification(inode, attr))
 		dquot_initialize(inode);
-
+	depth = reiserfs_write_lock_once(inode->i_sb);
 	if (attr->ia_valid & ATTR_SIZE) {
 		/* version 2 items will be caught by the s_maxbytes check
 		 ** done for us in vmtruncate
@@ -3170,7 +3172,9 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
 		error = journal_begin(&th, inode->i_sb, jbegin_count);
 		if (error)
 			goto out;
+		reiserfs_write_unlock_once(inode->i_sb, depth);
 		error = dquot_transfer(inode, attr);
+		depth = reiserfs_write_lock_once(inode->i_sb);
 		if (error) {
 			journal_end(&th, inode->i_sb, jbegin_count);
 			goto out;
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index f8afa4b..2f40a4c 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -1968,7 +1968,9 @@ int reiserfs_paste_into_item(struct reiserfs_transaction_handle *th, struct tree
 		       key2type(&(key->on_disk_key)));
 #endif
 
+	reiserfs_write_unlock(inode->i_sb);
 	retval = dquot_alloc_space_nodirty(inode, pasted_size);
+	reiserfs_write_lock(inode->i_sb);
 	if (retval) {
 		pathrelse(search_path);
 		return retval;
@@ -2061,9 +2063,11 @@ int reiserfs_insert_item(struct reiserfs_transaction_handle *th,
 			       "reiserquota insert_item(): allocating %u id=%u type=%c",
 			       quota_bytes, inode->i_uid, head2type(ih));
 #endif
+		reiserfs_write_unlock(inode->i_sb);
 		/* We can't dirty inode here. It would be immediately written but
 		 * appropriate stat item isn't inserted yet... */
 		retval = dquot_alloc_space_nodirty(inode, quota_bytes);
+		reiserfs_write_lock(inode->i_sb);
 		if (retval) {
 			pathrelse(path);
 			return retval;
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 295caeb8..99b1dd5 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -293,7 +293,9 @@ static int finish_unfinished(struct super_block *s)
 			retval = remove_save_link_only(s, &save_link_key, 0);
 			continue;
 		}
+		reiserfs_write_unlock(s);
 		dquot_initialize(inode);
+		reiserfs_write_lock(s);
 
 		if (truncate && S_ISDIR(inode->i_mode)) {
 			/* We got a truncate request for a dir which is impossible.
@@ -2098,13 +2100,15 @@ static int reiserfs_write_dquot(struct dquot *dquot)
 			  REISERFS_QUOTA_TRANS_BLOCKS(dquot->dq_sb));
 	if (ret)
 		goto out;
+	reiserfs_write_unlock(dquot->dq_sb);
 	ret = dquot_commit(dquot);
+	reiserfs_write_lock(dquot->dq_sb);
 	err =
 	    journal_end(&th, dquot->dq_sb,
 			REISERFS_QUOTA_TRANS_BLOCKS(dquot->dq_sb));
 	if (!ret && err)
 		ret = err;
-      out:
+out:
 	reiserfs_write_unlock(dquot->dq_sb);
 	return ret;
 }
@@ -2120,13 +2124,15 @@ static int reiserfs_acquire_dquot(struct dquot *dquot)
 			  REISERFS_QUOTA_INIT_BLOCKS(dquot->dq_sb));
 	if (ret)
 		goto out;
+	reiserfs_write_unlock(dquot->dq_sb);
 	ret = dquot_acquire(dquot);
+	reiserfs_write_lock(dquot->dq_sb);
 	err =
 	    journal_end(&th, dquot->dq_sb,
 			REISERFS_QUOTA_INIT_BLOCKS(dquot->dq_sb));
 	if (!ret && err)
 		ret = err;
-      out:
+out:
 	reiserfs_write_unlock(dquot->dq_sb);
 	return ret;
 }
@@ -2140,19 +2146,21 @@ static int reiserfs_release_dquot(struct dquot *dquot)
 	ret =
 	    journal_begin(&th, dquot->dq_sb,
 			  REISERFS_QUOTA_DEL_BLOCKS(dquot->dq_sb));
+	reiserfs_write_unlock(dquot->dq_sb);
 	if (ret) {
 		/* Release dquot anyway to avoid endless cycle in dqput() */
 		dquot_release(dquot);
 		goto out;
 	}
 	ret = dquot_release(dquot);
+	reiserfs_write_lock(dquot->dq_sb);
 	err =
 	    journal_end(&th, dquot->dq_sb,
 			REISERFS_QUOTA_DEL_BLOCKS(dquot->dq_sb));
 	if (!ret && err)
 		ret = err;
-      out:
 	reiserfs_write_unlock(dquot->dq_sb);
+out:
 	return ret;
 }
 
@@ -2177,11 +2185,13 @@ static int reiserfs_write_info(struct super_block *sb, int type)
 	ret = journal_begin(&th, sb, 2);
 	if (ret)
 		goto out;
+	reiserfs_write_unlock(sb);
 	ret = dquot_commit_info(sb, type);
+	reiserfs_write_lock(sb);
 	err = journal_end(&th, sb, 2);
 	if (!ret && err)
 		ret = err;
-      out:
+out:
 	reiserfs_write_unlock(sb);
 	return ret;
 }
-- 
1.7.9.5

