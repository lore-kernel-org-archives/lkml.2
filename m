Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab2KVWgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:36:23 -0500
Received: from mail.kernel.org ([198.145.19.201]:49024 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab2KVSdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:33:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>
Subject: [ 75/83] reiserfs: Fix lock ordering during remount
Date: Wed, 21 Nov 2012 16:42:37 -0800
Message-Id: <20121122004220.713975341@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121122004212.371862690@linuxfoundation.org>
References: <20121122004212.371862690@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 3bb3e1fc47aca554e7e2cc4deeddc24750987ac2 upstream.

When remounting reiserfs dquot_suspend() or dquot_resume() can be called.
These functions take dqonoff_mutex which ranks above write lock so we have
to drop it before calling into quota code.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/reiserfs/super.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1330,7 +1330,7 @@ static int reiserfs_remount(struct super
 				kfree(qf_names[i]);
 #endif
 		err = -EINVAL;
-		goto out_err;
+		goto out_unlock;
 	}
 #ifdef CONFIG_QUOTA
 	handle_quota_files(s, qf_names, &qfmt);
@@ -1374,7 +1374,7 @@ static int reiserfs_remount(struct super
 	if (blocks) {
 		err = reiserfs_resize(s, blocks);
 		if (err != 0)
-			goto out_err;
+			goto out_unlock;
 	}
 
 	if (*mount_flags & MS_RDONLY) {
@@ -1384,9 +1384,15 @@ static int reiserfs_remount(struct super
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
@@ -1396,7 +1402,7 @@ static int reiserfs_remount(struct super
 
 		err = journal_begin(&th, s, 10);
 		if (err)
-			goto out_err;
+			goto out_unlock;
 
 		/* Mounting a rw partition read-only. */
 		reiserfs_prepare_for_journal(s, SB_BUFFER_WITH_SB(s), 1);
@@ -1411,7 +1417,7 @@ static int reiserfs_remount(struct super
 
 		if (reiserfs_is_journal_aborted(journal)) {
 			err = journal->j_errno;
-			goto out_err;
+			goto out_unlock;
 		}
 
 		handle_data_mode(s, mount_options);
@@ -1420,7 +1426,7 @@ static int reiserfs_remount(struct super
 		s->s_flags &= ~MS_RDONLY;	/* now it is safe to call journal_begin */
 		err = journal_begin(&th, s, 10);
 		if (err)
-			goto out_err;
+			goto out_unlock;
 
 		/* Mount a partition which is read-only, read-write */
 		reiserfs_prepare_for_journal(s, SB_BUFFER_WITH_SB(s), 1);
@@ -1437,10 +1443,16 @@ static int reiserfs_remount(struct super
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
@@ -1450,9 +1462,10 @@ out_ok:
 	reiserfs_write_unlock(s);
 	return 0;
 
+out_unlock:
+	reiserfs_write_unlock(s);
 out_err:
 	kfree(new_opts);
-	reiserfs_write_unlock(s);
 	return err;
 }
 


