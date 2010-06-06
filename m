Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090Ab0FFOzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:55:10 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50218 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962Ab0FFOxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:45 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-ext4@vger.kernel.org
Subject: [PATCHv5 12/16] ext4: fix race condition in marking SB dirty
Date: Sun,  6 Jun 2010 17:50:25 +0300
Message-Id: <1275835829-1478-13-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 06 Jun 2010 14:53:32.0724 (UTC) FILETIME=[088B7740:01CB0588]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

When synchronizing the superblock, ext4 first starts changing the
SB (a) and then marks the superblock as clean (b). However, meanwhile
(between (a) and (b)) someone else can modify the superblock and
mark it as dirty. This would be a race condition, and the result
would be that we'd end up with a modified superblock which would
nevertheless be marked as clean (because of (b)). This means that
'sync_supers()' would never call our '->write_super()', at least
not until yet another SB change happens.

This patch fixes this race condition by marking the superblock as
clean before starting SB changes.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-ext4@vger.kernel.org

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d1707a0..7b19932 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3372,6 +3372,7 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 		clear_buffer_write_io_error(sbh);
 		set_buffer_uptodate(sbh);
 	}
+	sb_mark_clean(sb);
 	/*
 	 * If the file system is mounted read-only, don't update the
 	 * superblock write time.  This avoids updating the superblock
@@ -3392,7 +3393,6 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 					&EXT4_SB(sb)->s_freeblocks_counter));
 	es->s_free_inodes_count = cpu_to_le32(percpu_counter_sum_positive(
 					&EXT4_SB(sb)->s_freeinodes_counter));
-	sb_mark_clean(sb);
 	BUFFER_TRACE(sbh, "marking dirty");
 	mark_buffer_dirty(sbh);
 	if (sync) {
-- 
1.7.0.1

