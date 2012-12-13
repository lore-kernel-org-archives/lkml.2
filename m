Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab2LMOIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:08:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44532 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab2LMOH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:07:57 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 117/241] reiserfs: Fix lock ordering during remount
Date: Thu, 13 Dec 2012 11:58:02 -0200
Message-Id: <1355407206-17100-118-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 3bb3e1fc47aca554e7e2cc4deeddc24750987ac2 upstream.

When remounting reiserfs dquot_suspend() or dquot_resume() can be called.
These functions take dqonoff_mutex which ranks above write lock so we have
to drop it before calling into quota code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/reiserfs/super.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 651ce76..2ad0789 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1325,7 +1325,7 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 				kfree(qf_names[i]);
 #endif
 		err = -EINVAL;
-		goto out_err;
+		goto out_unlock;
 	}
 #ifdef CONFIG_QUOTA
 	handle_quota_files(s, qf_names, &qfmt);
@@ -1369,7 +1369,7 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	if (blocks) {
 		err = reiserfs_resize(s, blocks);
 		if (err != 0)
-			goto out_err;
+			goto out_unlock;
 	}
 
 	if (*mount_flags & MS_RDONLY) {
@@ -1379,9 +1379,15 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 			/* it is read-only already */
 			goto out_ok;
 
+		/*
+		 * Drop write lock. Quota will retake it when needed and lock
+		 * ordering requires calling dquot_suspend() without it.
+		 */
+		reiserfs_write_unlock(s);
 		err = dquot_suspend(s, -1);
 		if (err < 0)
 			goto out_err;
+		reiserfs_write_lock(s);
 
 		/* try to remount file system with read-only permissions */
 		if (sb_umount_state(rs) == REISERFS_VALID_FS
@@ -1391,7 +1397,7 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 
 		err = journal_begin(&th, s, 10);
 		if (err)
-			goto out_err;
+			goto out_unlock;
 
 		/* Mounting a rw partition read-only. */
 		reiserfs_prepare_for_journal(s, SB_BUFFER_WITH_SB(s), 1);
@@ -1406,7 +1412,7 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 
 		if (reiserfs_is_journal_aborted(journal)) {
 			err = journal->j_errno;
-			goto out_err;
+			goto out_unlock;
 		}
 
 		handle_data_mode(s, mount_options);
@@ -1415,7 +1421,7 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 		s->s_flags &= ~MS_RDONLY;	/* now it is safe to call journal_begin */
 		err = journal_begin(&th, s, 10);
 		if (err)
-			goto out_err;
+			goto out_unlock;
 
 		/* Mount a partition which is read-only, read-write */
 		reiserfs_prepare_for_journal(s, SB_BUFFER_WITH_SB(s), 1);
@@ -1432,10 +1438,16 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	SB_JOURNAL(s)->j_must_wait = 1;
 	err = journal_end(&th, s, 10);
 	if (err)
-		goto out_err;
+		goto out_unlock;
 
 	if (!(*mount_flags & MS_RDONLY)) {
+		/*
+		 * Drop write lock. Quota will retake it when needed and lock
+		 * ordering requires calling dquot_resume() without it.
+		 */
+		reiserfs_write_unlock(s);
 		dquot_resume(s, -1);
+		reiserfs_write_lock(s);
 		finish_unfinished(s);
 		reiserfs_xattr_init(s, *mount_flags);
 	}
@@ -1445,9 +1457,10 @@ out_ok:
 	reiserfs_write_unlock(s);
 	return 0;
 
+out_unlock:
+	reiserfs_write_unlock(s);
 out_err:
 	kfree(new_opts);
-	reiserfs_write_unlock(s);
 	return err;
 }
 
-- 
1.7.9.5

