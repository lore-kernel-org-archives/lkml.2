Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab2LCOtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:49:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43752 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932185Ab2LCOgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:19 -0500
Message-Id: <20121203143156.480273061@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:50 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>
Subject: [ 64/89] reiserfs: Move quota calls out of write lock
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 7af11686933726e99af22901d622f9e161404e6b upstream.

Calls into highlevel quota code cannot happen under the write lock. These
calls take dqio_mutex which ranks above write lock. So drop write lock
before calling back into quota code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/reiserfs/inode.c |   10 +++++++---
 fs/reiserfs/stree.c |    4 ++++
 fs/reiserfs/super.c |   18 ++++++++++++++----
 3 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index f27f01a..d83736f 100644
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
index c101704..418bdc3 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -298,7 +298,9 @@ static int finish_unfinished(struct super_block *s)
 			retval = remove_save_link_only(s, &save_link_key, 0);
 			continue;
 		}
+		reiserfs_write_unlock(s);
 		dquot_initialize(inode);
+		reiserfs_write_lock(s);
 
 		if (truncate && S_ISDIR(inode->i_mode)) {
 			/* We got a truncate request for a dir which is impossible.
@@ -2108,13 +2110,15 @@ static int reiserfs_write_dquot(struct dquot *dquot)
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
@@ -2130,13 +2134,15 @@ static int reiserfs_acquire_dquot(struct dquot *dquot)
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
@@ -2150,19 +2156,21 @@ static int reiserfs_release_dquot(struct dquot *dquot)
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
 
@@ -2187,11 +2195,13 @@ static int reiserfs_write_info(struct super_block *sb, int type)
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


