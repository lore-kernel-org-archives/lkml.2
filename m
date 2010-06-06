Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103Ab0FFOym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:54:42 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40165 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757972Ab0FFOxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:48 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCHv5 13/16] HFS: fix race condition in marking SB dirty
Date: Sun,  6 Jun 2010 17:50:26 +0300
Message-Id: <1275835829-1478-14-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 06 Jun 2010 14:53:34.0809 (UTC) FILETIME=[09C99C90:01CB0588]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

When synchronizing the file-system, hfs first initiates the SB write
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
 fs/hfs/mdb.c   |    1 +
 fs/hfs/super.c |    3 ---
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index 86428f5..957945e 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -260,6 +260,7 @@ void hfs_mdb_commit(struct super_block *sb)
 {
 	struct hfs_mdb *mdb = HFS_SB(sb)->mdb;
 
+	sb_mark_clean(sb);
 	if (test_and_clear_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags)) {
 		/* These parameters may have been modified, so write them back */
 		mdb->drLsMod = hfs_mtime();
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index bf71f6f..2f062ea 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -52,8 +52,6 @@ MODULE_LICENSE("GPL");
 static void hfs_write_super(struct super_block *sb)
 {
 	lock_super(sb);
-	sb_mark_clean(sb);
-
 	/* sync everything to the buffers */
 	if (!(sb->s_flags & MS_RDONLY))
 		hfs_mdb_commit(sb);
@@ -64,7 +62,6 @@ static int hfs_sync_fs(struct super_block *sb, int wait)
 {
 	lock_super(sb);
 	hfs_mdb_commit(sb);
-	sb_mark_clean(sb);
 	unlock_super(sb);
 
 	return 0;
-- 
1.7.0.1

