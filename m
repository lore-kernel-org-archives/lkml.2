Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab2DYU7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:59:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51110 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758697Ab2DYU55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:57:57 -0400
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, bfields@fieldses.org,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>
Subject: [PATCH 6/6] quota: Get rid of nested I_MUTEX_QUOTA locking subclass
Date: Wed, 25 Apr 2012 22:57:47 +0200
Message-Id: <1335387467-4928-7-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1335387467-4928-1-git-send-email-jack@suse.cz>
References: <1335387467-4928-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far i_mutex was ranking above dqonoff_mutex and i_mutex on quota files
was special and ranking below dqonoff_mutex (and several other locks).
However there's no real need for i_mutex on quota files to be special.
IO on quota files is serialized by dqio_mutex anyway so we don't need to
take i_mutex when writing to quota files. Other places where we take i_mutex
on quota file can accomodate standard i_mutex lock ranking, we only need
to change the lock ranking to be dqonoff_mutex > i_mutex which is a matter
of changing documentation because there's no place which would enforce
ordering in the other direction.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/quota/dquot.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 1b7e0fc..d4ff981 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -116,15 +116,15 @@
  * spinlock to internal buffers before writing.
  *
  * Lock ordering (including related VFS locks) is the following:
- *   i_mutex > dqonoff_sem > journal_lock > dqptr_sem > dquot->dq_lock >
+ *   dqonoff_mutex > i_mutex > journal_lock > dqptr_sem > dquot->dq_lock >
  *   dqio_mutex
+ * dqonoff_mutex > i_mutex comes from dquot_quota_sync, dquot_enable, etc.
  * The lock ordering of dqptr_sem imposed by quota code is only dqonoff_sem >
  * dqptr_sem. But filesystem has to count with the fact that functions such as
  * dquot_alloc_space() acquire dqptr_sem and they usually have to be called
  * from inside a transaction to keep filesystem consistency after a crash. Also
  * filesystems usually want to do some IO on dquot from ->mark_dirty which is
  * called with dqptr_sem held.
- * i_mutex on quota files is special (it's below dqio_mutex)
  */
 
 static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dq_list_lock);
@@ -658,8 +658,7 @@ int dquot_quota_sync(struct super_block *sb, int type, int wait)
 			continue;
 		if (!sb_has_quota_active(sb, cnt))
 			continue;
-		mutex_lock_nested(&dqopt->files[cnt]->i_mutex,
-				  I_MUTEX_QUOTA);
+		mutex_lock(&dqopt->files[cnt]->i_mutex);
 		truncate_inode_pages(&dqopt->files[cnt]->i_data, 0);
 		mutex_unlock(&dqopt->files[cnt]->i_mutex);
 	}
@@ -2037,8 +2036,7 @@ int dquot_disable(struct super_block *sb, int type, unsigned int flags)
 			/* If quota was reenabled in the meantime, we have
 			 * nothing to do */
 			if (!sb_has_quota_loaded(sb, cnt)) {
-				mutex_lock_nested(&toputinode[cnt]->i_mutex,
-						  I_MUTEX_QUOTA);
+				mutex_lock(&toputinode[cnt]->i_mutex);
 				toputinode[cnt]->i_flags &= ~(S_IMMUTABLE |
 				  S_NOATIME | S_NOQUOTA);
 				truncate_inode_pages(&toputinode[cnt]->i_data,
@@ -2133,7 +2131,7 @@ static int vfs_load_quota_inode(struct inode *inode, int type, int format_id,
 		/* We don't want quota and atime on quota files (deadlocks
 		 * possible) Also nobody should write to the file - we use
 		 * special IO operations which ignore the immutable bit. */
-		mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
+		mutex_lock(&inode->i_mutex);
 		oldflags = inode->i_flags & (S_NOATIME | S_IMMUTABLE |
 					     S_NOQUOTA);
 		inode->i_flags |= S_NOQUOTA | S_NOATIME | S_IMMUTABLE;
@@ -2180,7 +2178,7 @@ out_file_init:
 	iput(inode);
 out_lock:
 	if (oldflags != -1) {
-		mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
+		mutex_lock(&inode->i_mutex);
 		/* Set the flags back (in the case of accidental quotaon()
 		 * on a wrong file we don't want to mess up the flags) */
 		inode->i_flags &= ~(S_NOATIME | S_NOQUOTA | S_IMMUTABLE);
-- 
1.7.1

