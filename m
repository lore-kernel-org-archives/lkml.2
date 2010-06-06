Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab0FFOxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:53:43 -0400
Received: from smtp.nokia.com ([192.100.122.233]:50206 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934007Ab0FFOxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:36 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCHv5 07/16] AFFS: fix race condition in marking SB dirty
Date: Sun,  6 Jun 2010 17:50:20 +0300
Message-Id: <1275835829-1478-8-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 06 Jun 2010 14:53:22.0590 (UTC) FILETIME=[028123E0:01CB0588]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

When synchronizing the superblock, AFFS first initiates the SB write
(a) and then marks the superblock as clean (b). However, meanwhile
(between (a) and (b)) someone else can modify the superblock and
mark it as dirty. This would be a race condition, and the result
would be that we'd end up with a modified superblock which would
nevertheless be marked as clean (because of (b)). This means that
'sync_supers()' would never call our '->write_super()', at least
not until yet another SB change happens.

This patch fixes this race condition by marking the superblock as
clean before initiating the write operation.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/affs/super.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index a1e0f10..e93a1e3 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -32,6 +32,7 @@ affs_commit_super(struct super_block *sb, int wait, int clean)
 	struct buffer_head *bh = sbi->s_root_bh;
 	struct affs_root_tail *tail = AFFS_ROOT_TAIL(sb, bh);
 
+	sb_mark_clean(sb);
 	tail->bm_flag = cpu_to_be32(clean);
 	secs_to_datestamp(get_seconds(), &tail->disk_change);
 	affs_fix_checksum(sb, bh);
@@ -66,7 +67,6 @@ affs_write_super(struct super_block *sb)
 	lock_super(sb);
 	if (!(sb->s_flags & MS_RDONLY))
 		affs_commit_super(sb, 1, 2);
-	sb_mark_clean(sb);
 	unlock_super(sb);
 
 	pr_debug("AFFS: write_super() at %lu, clean=2\n", get_seconds());
@@ -77,7 +77,6 @@ affs_sync_fs(struct super_block *sb, int wait)
 {
 	lock_super(sb);
 	affs_commit_super(sb, wait, 2);
-	sb_mark_clean(sb);
 	unlock_super(sb);
 	return 0;
 }
-- 
1.7.0.1

