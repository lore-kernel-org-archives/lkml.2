Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab2FLINa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:13:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:27666 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab2FLIMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:12:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="164501698"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] hfs: simplify a bit checking for R/O
Date: Tue, 12 Jun 2012 11:13:36 +0300
Message-Id: <1339488818-14461-5-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1339488818-14461-1-git-send-email-dedekind1@gmail.com>
References: <1339488818-14461-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

We have the following pattern in 2 places in HFS

if (!RDONLY)
	hfs_mdb_commit();

This patch pushes the RDONLY check down to 'hfs_mdb_commit()'. This will
make the following patches a bit simpler.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 fs/hfs/inode.c |    3 +--
 fs/hfs/mdb.c   |    3 +++
 fs/hfs/super.c |    3 +--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index daf3d63..629eba4 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -646,8 +646,7 @@ static int hfs_file_fsync(struct file *filp, loff_t start, loff_t end,
 	sb = inode->i_sb;
 	if (sb->s_dirt) {
 		sb->s_dirt = 0;
-		if (!(sb->s_flags & MS_RDONLY))
-			hfs_mdb_commit(sb);
+		hfs_mdb_commit(sb);
 	}
 	/* .. finally sync the buffers to disk */
 	err = sync_blockdev(sb->s_bdev);
diff --git a/fs/hfs/mdb.c b/fs/hfs/mdb.c
index 7a32240..5fd51a5 100644
--- a/fs/hfs/mdb.c
+++ b/fs/hfs/mdb.c
@@ -260,6 +260,9 @@ void hfs_mdb_commit(struct super_block *sb)
 {
 	struct hfs_mdb *mdb = HFS_SB(sb)->mdb;
 
+	if (sb->s_flags & MS_RDONLY)
+		return;
+
 	lock_buffer(HFS_SB(sb)->mdb_bh);
 	if (test_and_clear_bit(HFS_FLG_MDB_DIRTY, &HFS_SB(sb)->flags)) {
 		/* These parameters may have been modified, so write them back */
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 47e4119..0730135 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -53,8 +53,7 @@ static void hfs_write_super(struct super_block *sb)
 	sb->s_dirt = 0;
 
 	/* sync everything to the buffers */
-	if (!(sb->s_flags & MS_RDONLY))
-		hfs_mdb_commit(sb);
+	hfs_mdb_commit(sb);
 }
 
 static int hfs_sync_fs(struct super_block *sb, int wait)
-- 
1.7.7.6

