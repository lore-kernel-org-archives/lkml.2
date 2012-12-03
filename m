Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab2LCOsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:48:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43774 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932240Ab2LCOgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:22 -0500
Message-Id: <20121203143156.032932304@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:47 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>
Subject: [ 61/89] reiserfs: Fix lock ordering during remount
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

commit 3bb3e1fc47aca554e7e2cc4deeddc24750987ac2 upstream.

When remounting reiserfs dquot_suspend() or dquot_resume() can be called.
These functions take dqonoff_mutex which ranks above write lock so we have
to drop it before calling into quota code.

Signed-off-by: Jan Kara <jack@suse.cz>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/reiserfs/super.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1207,7 +1207,7 @@ static int reiserfs_remount(struct super
 				kfree(qf_names[i]);
 #endif
 		err = -EINVAL;
-		goto out_err;
+		goto out_unlock;
 	}
 #ifdef CONFIG_QUOTA
 	handle_quota_files(s, qf_names, &qfmt);
@@ -1250,7 +1250,7 @@ static int reiserfs_remount(struct super
 	if (blocks) {
 		err = reiserfs_resize(s, blocks);
 		if (err != 0)
-			goto out_err;
+			goto out_unlock;
 	}
 
 	if (*mount_flags & MS_RDONLY) {
@@ -1260,9 +1260,15 @@ static int reiserfs_remount(struct super
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
@@ -1272,7 +1278,7 @@ static int reiserfs_remount(struct super
 
 		err = journal_begin(&th, s, 10);
 		if (err)
-			goto out_err;
+			goto out_unlock;
 
 		/* Mounting a rw partition read-only. */
 		reiserfs_prepare_for_journal(s, SB_BUFFER_WITH_SB(s), 1);
@@ -1287,7 +1293,7 @@ static int reiserfs_remount(struct super
 
 		if (reiserfs_is_journal_aborted(journal)) {
 			err = journal->j_errno;
-			goto out_err;
+			goto out_unlock;
 		}
 
 		handle_data_mode(s, mount_options);
@@ -1296,7 +1302,7 @@ static int reiserfs_remount(struct super
 		s->s_flags &= ~MS_RDONLY;	/* now it is safe to call journal_begin */
 		err = journal_begin(&th, s, 10);
 		if (err)
-			goto out_err;
+			goto out_unlock;
 
 		/* Mount a partition which is read-only, read-write */
 		reiserfs_prepare_for_journal(s, SB_BUFFER_WITH_SB(s), 1);
@@ -1313,11 +1319,17 @@ static int reiserfs_remount(struct super
 	SB_JOURNAL(s)->j_must_wait = 1;
 	err = journal_end(&th, s, 10);
 	if (err)
-		goto out_err;
+		goto out_unlock;
 	s->s_dirt = 0;
 
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
@@ -1327,9 +1339,10 @@ out_ok:
 	reiserfs_write_unlock(s);
 	return 0;
 
+out_unlock:
+	reiserfs_write_unlock(s);
 out_err:
 	kfree(new_opts);
-	reiserfs_write_unlock(s);
 	return err;
 }
 


