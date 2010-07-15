Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379Ab0GOD1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 23:27:40 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:4384 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab0GOD10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 23:27:26 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 4/4] omfs: sanity check cluster size
Date: Wed, 14 Jul 2010 23:26:21 -0400
Message-Id: <1279164381-9247-5-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279164381-9247-1-git-send-email-me@bobcopeland.com>
References: <1279164381-9247-1-git-send-email-me@bobcopeland.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A corrupt filesystem could have a bad cluster size; this could result in
the filesystem allocating too much space for files if too large, or
getting stuck in omfs_allocate_block if too small.  The proper range is
1-8 blocks.

Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 fs/omfs/inode.c   |    6 ++++++
 fs/omfs/omfs_fs.h |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index 0af5d0a..579d33f 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -517,6 +517,12 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 			(unsigned long long) sbi->s_num_blocks);
 		goto out_brelse_bh2;
 	}
+	if (sbi->s_clustersize < 1 ||
+	    sbi->s_clustersize > OMFS_MAX_CLUSTER_SIZE) {
+		printk(KERN_ERR "omfs: cluster size out of range (%d)",
+			sbi->s_clustersize);
+		goto out_brelse_bh2;
+	}
 
 	ret = omfs_get_imap(sb);
 	if (ret)
diff --git a/fs/omfs/omfs_fs.h b/fs/omfs/omfs_fs.h
index 12cca24..ee5e432 100644
--- a/fs/omfs/omfs_fs.h
+++ b/fs/omfs/omfs_fs.h
@@ -17,6 +17,7 @@
 #define OMFS_EXTENT_CONT 0x40
 #define OMFS_XOR_COUNT 19
 #define OMFS_MAX_BLOCK_SIZE 8192
+#define OMFS_MAX_CLUSTER_SIZE 8
 
 struct omfs_super_block {
 	char s_fill1[256];
-- 
1.5.6.5


