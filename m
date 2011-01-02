Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab1ABHVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:21:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:34037 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab1ABHVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:32 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Sandeen <sandeen@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 010/260] ext4: don't return to userspace after freezing the fs with a mutex held
Date: Sun,  2 Jan 2011 02:15:06 -0500
Message-Id: <1293952756-15010-11-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:17.0397 (UTC) FILETIME=[819D6250:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit 6b0310fbf087ad6e9e3b8392adca97cd77184084 upstream.

ext4_freeze() used jbd2_journal_lock_updates() which takes
the j_barrier mutex, and then returns to userspace.  The
kernel does not like this:

================================================
[ BUG: lock held when returning to user space! ]
------------------------------------------------
lvcreate/1075 is leaving the kernel with locks still held!
1 lock held by lvcreate/1075:
 #0:  (&journal->j_barrier){+.+...}, at: [<ffffffff811c6214>]
jbd2_journal_lock_updates+0xe1/0xf0

Use vfs_check_frozen() added to ext4_journal_start_sb() and
ext4_force_commit() instead.

Addresses-Red-Hat-Bugzilla: #568503

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/super.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e14d22c..00d09f5 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -241,6 +241,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 	if (sb->s_flags & MS_RDONLY)
 		return ERR_PTR(-EROFS);
 
+	vfs_check_frozen(sb, SB_FREEZE_WRITE);
 	/* Special case here: if the journal has aborted behind our
 	 * backs (eg. EIO in the commit thread), then we still need to
 	 * take the FS itself readonly cleanly. */
@@ -3485,8 +3486,10 @@ int ext4_force_commit(struct super_block *sb)
 		return 0;
 
 	journal = EXT4_SB(sb)->s_journal;
-	if (journal)
+	if (journal) {
+		vfs_check_frozen(sb, SB_FREEZE_WRITE);
 		ret = ext4_journal_force_commit(journal);
+	}
 
 	return ret;
 }
@@ -3535,18 +3538,16 @@ static int ext4_freeze(struct super_block *sb)
 	 * the journal.
 	 */
 	error = jbd2_journal_flush(journal);
-	if (error < 0) {
-	out:
-		jbd2_journal_unlock_updates(journal);
-		return error;
-	}
+	if (error < 0)
+		goto out;
 
 	/* Journal blocked and flushed, clear needs_recovery flag. */
 	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 	error = ext4_commit_super(sb, 1);
-	if (error)
-		goto out;
-	return 0;
+out:
+	/* we rely on s_frozen to stop further updates */
+	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+	return error;
 }
 
 /*
@@ -3563,7 +3564,6 @@ static int ext4_unfreeze(struct super_block *sb)
 	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 	ext4_commit_super(sb, 1);
 	unlock_super(sb);
-	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
 	return 0;
 }
 
-- 
1.7.3.3

