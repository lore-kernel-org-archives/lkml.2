Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab2FLIOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:14:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:34622 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab2FLIMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:12:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164501673"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] hfs: get rid of lock_super
Date: Tue, 12 Jun 2012 11:13:34 +0300
Message-Id: <1339488818-14461-3-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1339488818-14461-1-git-send-email-dedekind1@gmail.com>
References: <1339488818-14461-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Stop using lock_super for serializing the MDB changes - use the buffer-head own
lock instead. Tested with fsstress.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/hfs/mdb.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index 3f558d58..7a32240 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -260,7 +260,7 @@ void hfs_mdb_commit(struct super_block *sb)
 {
 	struct hfs_mdb *mdb = HFS_SB(sb)->mdb;
 
-	lock_super(sb);
+	lock_buffer(HFS_SB(sb)->mdb_bh);
 	if (test_and_clear_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags)) {
 		/* These parameters may have been modified, so write them back */
 		mdb->drLsMod = hfs_mtime();
@@ -284,9 +284,13 @@ void hfs_mdb_commit(struct super_block *sb)
 				     &mdb->drXTFlSize, NULL);
 		hfs_inode_write_fork(HFS_SB(sb)->cat_tree->inode, mdb->drCTExtRec,
 				     &mdb->drCTFlSize, NULL);
+
+		lock_buffer(HFS_SB(sb)->alt_mdb_bh);
 		memcpy(HFS_SB(sb)->alt_mdb, HFS_SB(sb)->mdb, HFS_SECTOR_SIZE);
 		HFS_SB(sb)->alt_mdb->drAtrb |= cpu_to_be16(HFS_SB_ATTRIB_UNMNT);
 		HFS_SB(sb)->alt_mdb->drAtrb &= cpu_to_be16(~HFS_SB_ATTRIB_INCNSTNT);
+		unlock_buffer(HFS_SB(sb)->alt_mdb_bh);
+
 		mark_buffer_dirty(HFS_SB(sb)->alt_mdb_bh);
 		sync_dirty_buffer(HFS_SB(sb)->alt_mdb_bh);
 	}
@@ -309,7 +313,11 @@ void hfs_mdb_commit(struct super_block *sb)
 				break;
 			}
 			len = min((int)sb->s_blocksize - off, size);
+
+			lock_buffer(bh);
 			memcpy(bh->b_data + off, ptr, len);
+			unlock_buffer(bh);
+
 			mark_buffer_dirty(bh);
 			brelse(bh);
 			block++;
@@ -318,7 +326,7 @@ void hfs_mdb_commit(struct super_block *sb)
 			size -= len;
 		}
 	}
-	unlock_super(sb);
+	unlock_buffer(HFS_SB(sb)->mdb_bh);
 }
 
 void hfs_mdb_close(struct super_block *sb)
-- 
1.7.7.6

