Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1ABIKz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:10:55 -0500
Received: from mail.windriver.com ([147.11.1.11]:34285 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab1ABHVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:52 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Sandeen <sandeen@sandeen.net>,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 028/260] ext4: fix freeze deadlock under IO
Date: Sun,  2 Jan 2011 02:15:24 -0500
Message-Id: <1293952756-15010-29-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:36.0741 (UTC) FILETIME=[8D250B50:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@sandeen.net>

commit 437f88cc031ffe7f37f3e705367f4fe1f4be8b0f upstream.
[The 6b0310fb below references the mainline version of what
has also been cherry picked into this 34-stable branch]

Commit 6b0310fbf087ad6 caused a regression resulting in deadlocks
when freezing a filesystem which had active IO; the vfs_check_frozen
level (SB_FREEZE_WRITE) did not let the freeze-related IO syncing
through.  Duh.

Changing the test to FREEZE_TRANS should let the normal freeze
syncing get through the fs, but still block any transactions from
starting once the fs is completely frozen.

I tested this by running fsstress in the background while periodically
snapshotting the fs and running fsck on the result.  I ran into
occasional deadlocks, but different ones.  I think this is a
fine fix for the problem at hand, and the other deadlocky things
will need more investigation.

Reported-by: Phillip Susi <psusi@cfl.rr.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2aa9314..cd35e34 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -241,7 +241,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 	if (sb->s_flags & MS_RDONLY)
 		return ERR_PTR(-EROFS);
 
-	vfs_check_frozen(sb, SB_FREEZE_WRITE);
+	vfs_check_frozen(sb, SB_FREEZE_TRANS);
 	/* Special case here: if the journal has aborted behind our
 	 * backs (eg. EIO in the commit thread), then we still need to
 	 * take the FS itself readonly cleanly. */
@@ -3485,7 +3485,7 @@ int ext4_force_commit(struct super_block *sb)
 
 	journal = EXT4_SB(sb)->s_journal;
 	if (journal) {
-		vfs_check_frozen(sb, SB_FREEZE_WRITE);
+		vfs_check_frozen(sb, SB_FREEZE_TRANS);
 		ret = ext4_journal_force_commit(journal);
 	}
 
-- 
1.7.3.3

