Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab1LHSF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 13:05:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48210 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1LHSFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 13:05:21 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Matthew Wilcox <matthew@wil.cx>, Randy Dunlap <rdunlap@xenotime.net>,
        Theodore Tso <tytso@mit.edu>
Cc: linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Surbhi Palande <csurbhi@gmail.com>,
        Valerie Aurora <val@vaaconsulting.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Christopher Chaltain <christopher.chaltain@canonical.com>,
        "Peter M. Petrakis" <peter.petrakis@canonical.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Surbhi Palande <surbhi.palande@canonical.com>
Subject: [PATCH v2 2/7] Freeze and thaw the journal on ext4 freeze
Date: Thu,  8 Dec 2011 10:04:32 -0800
Message-Id: <1323367477-21685-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323367477-21685-1-git-send-email-kamal@canonical.com>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Surbhi Palande <surbhi.palande@canonical.com>

Freeze and thaw the journal when you freeze and thaw the filesystem.

BugLink: https://bugs.launchpad.net/bugs/897421
Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
Cc: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/super.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3858767..751908b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4330,14 +4330,11 @@ static int ext4_freeze(struct super_block *sb)
 
 	journal = EXT4_SB(sb)->s_journal;
 
-	/* Now we set up the journal barrier. */
-	jbd2_journal_lock_updates(journal);
-
+	error = jbd2_journal_freeze(journal);
 	/*
-	 * Don't clear the needs_recovery flag if we failed to flush
+	 * Don't clear the needs_recovery flag if we failed to freeze
 	 * the journal.
 	 */
-	error = jbd2_journal_flush(journal);
 	if (error < 0)
 		goto out;
 
@@ -4345,8 +4342,6 @@ static int ext4_freeze(struct super_block *sb)
 	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 	error = ext4_commit_super(sb, 1);
 out:
-	/* we rely on s_frozen to stop further updates */
-	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
 	return error;
 }
 
@@ -4356,10 +4351,14 @@ out:
  */
 static int ext4_unfreeze(struct super_block *sb)
 {
+	journal_t *journal;
 	if (sb->s_flags & MS_RDONLY)
 		return 0;
 
 	lock_super(sb);
+	journal = EXT4_SB(sb)->s_journal;
+
+	jbd2_journal_thaw(journal);
 	/* Reset the needs_recovery flag before the fs is unlocked. */
 	EXT4_SET_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 	ext4_commit_super(sb, 1);
-- 
1.7.5.4

