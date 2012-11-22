Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab2KVV10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:27:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:49636 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212Ab2KVSkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:40:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>
Subject: [ 053/171] reiserfs: Move quota calls out of write lock
Date: Wed, 21 Nov 2012 16:39:59 -0800
Message-Id: <20121122004038.693878961@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004033.298367941@linuxfoundation.org>
References: <20121122004033.298367941@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 7af11686933726e99af22901d622f9e161404e6b upstream.

Calls into highlevel quota code cannot happen under the write lock. These
calls take dqio_mutex which ranks above write lock. So drop write lock
before calling back into quota code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/reiserfs/inode.c |   10 +++++++---
 fs/reiserfs/stree.c |    4 ++++
 fs/reiserfs/super.c |   18 ++++++++++++++----
 3 files changed, 25 insertions(+), 7 deletions(-)

--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1788,8 +1788,9 @@ int reiserfs_new_inode(struct reiserfs_t
 
 	BUG_ON(!th->t_trans_id);
 
-	dquot_initialize(inode);
+	reiserfs_write_unlock(inode->i_sb);
 	err = dquot_alloc_inode(inode);
+	reiserfs_write_lock(inode->i_sb);
 	if (err)
 		goto out_end_trans;
 	if (!dir->i_nlink) {
@@ -1985,8 +1986,10 @@ int reiserfs_new_inode(struct reiserfs_t
 
       out_end_trans:
 	journal_end(th, th->t_super, th->t_blocks_allocated);
+	reiserfs_write_unlock(inode->i_sb);
 	/* Drop can be outside and it needs more credits so it's better to have it outside */
 	dquot_drop(inode);
+	reiserfs_write_lock(inode->i_sb);
 	inode->i_flags |= S_NOQUOTA;
 	make_bad_inode(inode);
 
@@ -3109,10 +3112,9 @@ int reiserfs_setattr(struct dentry *dent
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
@@ -3176,7 +3178,9 @@ int reiserfs_setattr(struct dentry *dent
 		error = journal_begin(&th, inode->i_sb, jbegin_count);
 		if (error)
 			goto out;
+		reiserfs_write_unlock_once(inode->i_sb, depth);
 		error = dquot_transfer(inode, attr);
+		depth = reiserfs_write_lock_once(inode->i_sb);
 		if (error) {
 			journal_end(&th, inode->i_sb, jbegin_count);
 			goto out;
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -1968,7 +1968,9 @@ int reiserfs_paste_into_item(struct reis
 		       key2type(&(key->on_disk_key)));
 #endif
 
+	reiserfs_write_unlock(inode->i_sb);
 	retval = dquot_alloc_space_nodirty(inode, pasted_size);
+	reiserfs_write_lock(inode->i_sb);
 	if (retval) {
 		pathrelse(search_path);
 		return retval;
@@ -2061,9 +2063,11 @@ int reiserfs_insert_item(struct reiserfs
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
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -256,7 +256,9 @@ static int finish_unfinished(struct supe
 			retval = remove_save_link_only(s, &save_link_key, 0);
 			continue;
 		}
+		reiserfs_write_unlock(s);
 		dquot_initialize(inode);
+		reiserfs_write_lock(s);
 
 		if (truncate && S_ISDIR(inode->i_mode)) {
 			/* We got a truncate request for a dir which is impossible.
@@ -2062,13 +2064,15 @@ static int reiserfs_write_dquot(struct d
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
@@ -2084,13 +2088,15 @@ static int reiserfs_acquire_dquot(struct
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
@@ -2104,19 +2110,21 @@ static int reiserfs_release_dquot(struct
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
 
@@ -2141,11 +2149,13 @@ static int reiserfs_write_info(struct su
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


