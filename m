Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab0EYNvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:51:41 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50312 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932731Ab0EYNvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:51:36 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: [PATCHv4 12/17] reiserfs: do not manipulate s_dirt directly
Date: Tue, 25 May 2010 16:49:07 +0300
Message-Id: <1274795352-3551-13-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 25 May 2010 13:50:51.0047 (UTC) FILETIME=[49741B70:01CAFC11]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

... use new VFS helpers instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: reiserfs-devel@vger.kernel.org
---
 fs/reiserfs/journal.c |    6 +++---
 fs/reiserfs/resize.c  |    2 +-
 fs/reiserfs/super.c   |   10 +++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 19fbc81..4016d0a 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -3337,7 +3337,7 @@ int journal_mark_dirty(struct reiserfs_transaction_handle *th,
 			       th->t_trans_id, journal->j_trans_id);
 	}
 
-	sb->s_dirt = 1;
+	mark_sb_dirty(sb);
 
 	prepared = test_clear_buffer_journal_prepared(bh);
 	clear_buffer_journal_restore_dirty(bh);
@@ -3632,7 +3632,7 @@ int reiserfs_flush_old_commits(struct super_block *sb)
 			do_journal_end(&th, sb, 1, COMMIT_NOW | WAIT);
 		}
 	}
-	return sb->s_dirt;
+	return is_sb_dirty(sb);
 }
 
 /*
@@ -4062,7 +4062,7 @@ static int do_journal_end(struct reiserfs_transaction_handle *th,
 	 ** it tells us if we should continue with the journal_end, or just return
 	 */
 	if (!check_journal_end(th, sb, nblocks, flags)) {
-		sb->s_dirt = 1;
+		mark_sb_dirty(sb);
 		wake_queued_writers(sb);
 		reiserfs_async_progress_wait(sb);
 		goto out;
diff --git a/fs/reiserfs/resize.c b/fs/reiserfs/resize.c
index b3a94d2..588d55a 100644
--- a/fs/reiserfs/resize.c
+++ b/fs/reiserfs/resize.c
@@ -203,7 +203,7 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 					  (bmap_nr_new - bmap_nr)));
 	PUT_SB_BLOCK_COUNT(s, block_count_new);
 	PUT_SB_BMAP_NR(s, bmap_would_wrap(bmap_nr_new) ? : bmap_nr_new);
-	s->s_dirt = 1;
+	mark_sb_dirty(s);
 
 	journal_mark_dirty(&th, s, SB_BUFFER_WITH_SB(s));
 
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 59125fb..93eb3fc 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -71,8 +71,8 @@ static int reiserfs_sync_fs(struct super_block *s, int wait)
 	if (!journal_begin(&th, s, 1))
 		if (!journal_end_sync(&th, s, 1))
 			reiserfs_flush_old_commits(s);
-	s->s_dirt = 0;	/* Even if it's not true.
-			 * We'll loop forever in sync_supers otherwise */
+	mark_sb_clean(s); /* Even if it's not true.
+			   * We'll loop forever in sync_supers otherwise */
 	reiserfs_write_unlock(s);
 	return 0;
 }
@@ -98,7 +98,7 @@ static int reiserfs_freeze(struct super_block *s)
 			journal_end_sync(&th, s, 1);
 		}
 	}
-	s->s_dirt = 0;
+	mark_sb_clean(s);
 	reiserfs_write_unlock(s);
 	return 0;
 }
@@ -468,7 +468,7 @@ static void reiserfs_put_super(struct super_block *s)
 
 	reiserfs_write_lock(s);
 
-	if (s->s_dirt)
+	if (is_sb_dirty(s))
 		reiserfs_write_super(s);
 
 	/* change file system state to current state if it was mounted with read-write permissions */
@@ -1292,7 +1292,7 @@ static int reiserfs_remount(struct super_block *s, int *mount_flags, char *arg)
 	err = journal_end(&th, s, 10);
 	if (err)
 		goto out_err;
-	s->s_dirt = 0;
+	mark_sb_clean(s);
 
 	if (!(*mount_flags & MS_RDONLY)) {
 		finish_unfinished(s);
-- 
1.6.6.1

