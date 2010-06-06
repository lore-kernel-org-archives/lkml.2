Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934067Ab0FFOxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 10:53:55 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40166 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980Ab0FFOxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 10:53:49 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [PATCHv5 14/16] HFS: kill hfs_buffer_sync
Date: Sun,  6 Jun 2010 17:50:27 +0300
Message-Id: <1275835829-1478-15-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
References: <1275835829-1478-1-git-send-email-dedekind1@gmail.com>
X-OriginalArrivalTime: 06 Jun 2010 14:53:36.0684 (UTC) FILETIME=[0AE7B6C0:01CB0588]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

and use 'sync_dirty_buffer()' instead, which is the right way
of doing synchronization.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/hfs/hfs_fs.h |   11 -----------
 fs/hfs/mdb.c    |    4 ++--
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 99b5866..3514e7a 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -254,17 +254,6 @@ static inline void hfs_bitmap_dirty(struct super_block *sb)
 	sb_mark_dirty(sb);
 }
 
-static inline void hfs_buffer_sync(struct buffer_head *bh)
-{
-	while (buffer_locked(bh)) {
-		wait_on_buffer(bh);
-	}
-	if (buffer_dirty(bh)) {
-		ll_rw_block(WRITE, 1, &bh);
-		wait_on_buffer(bh);
-	}
-}
-
 #define sb_bread512(sb, sec, data) ({			\
 	struct buffer_head *__bh;			\
 	sector_t __block;				\
diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index 957945e..159ab88 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -220,7 +220,7 @@ int hfs_mdb_get(struct super_block *sb)
 		mdb->drLsMod = hfs_mtime();
 
 		mark_buffer_dirty(HFS_SB(sb)->mdb_bh);
-		hfs_buffer_sync(HFS_SB(sb)->mdb_bh);
+		sync_dirty_buffer(HFS_SB(sb)->mdb_bh);
 	}
 
 	return 0;
@@ -288,7 +288,7 @@ void hfs_mdb_commit(struct super_block *sb)
 		HFS_SB(sb)->alt_mdb->drAtrb |= cpu_to_be16(HFS_SB_ATTRIB_UNMNT);
 		HFS_SB(sb)->alt_mdb->drAtrb &= cpu_to_be16(~HFS_SB_ATTRIB_INCNSTNT);
 		mark_buffer_dirty(HFS_SB(sb)->alt_mdb_bh);
-		hfs_buffer_sync(HFS_SB(sb)->alt_mdb_bh);
+		sync_dirty_buffer(HFS_SB(sb)->alt_mdb_bh);
 	}
 
 	if (test_and_clear_bit(HFS_FLG_BITMAP_DIRTY, &HFS_SB(sb)->flags)) {
-- 
1.7.0.1

