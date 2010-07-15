Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab0GOD1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 23:27:33 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:4368 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab0GOD1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 23:27:21 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/4] omfs: refuse to mount if bitmap pointer is obviously wrong
Date: Wed, 14 Jul 2010 23:26:20 -0400
Message-Id: <1279164381-9247-4-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279164381-9247-1-git-send-email-me@bobcopeland.com>
References: <1279164381-9247-1-git-send-email-me@bobcopeland.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the free space bitmap pointer is corrupted such that it lies outside
of the number of blocks in the filesystem, print a message and fail the
mount so the user can fix it offline.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 fs/omfs/inode.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index bd4bf75..0af5d0a 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -509,6 +509,15 @@ static int omfs_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_brelse_bh2;
 	}
 
+	if (sbi->s_bitmap_ino != ~0ULL &&
+	    sbi->s_bitmap_ino > sbi->s_num_blocks) {
+		printk(KERN_ERR "omfs: free space bitmap location is corrupt "
+			"(%llx, total blocks %llx)\n",
+			(unsigned long long) sbi->s_bitmap_ino,
+			(unsigned long long) sbi->s_num_blocks);
+		goto out_brelse_bh2;
+	}
+
 	ret = omfs_get_imap(sb);
 	if (ret)
 		goto out_brelse_bh2;
-- 
1.5.6.5


