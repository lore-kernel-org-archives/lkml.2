Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab0JSNKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:10:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53114 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758554Ab0JSNKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:10:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=nLLCUTUnGCW9ZkoZ3+YZN9Pdg0nGeqwtgvRplqE7pZ0vZRlOosIwVSRjEPpiru+f2t
         S6g6YUefaVy97n5YN/5/o6khnDyVxpLWPIXvDxucc+VBjbc6n6d2szCtYsbgpch4odqN
         8cQrKDdDuS+4CQ5GyoNfiCmZgOLuHurr5l7UM=
From: Namhyung Kim <namhyung@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext2: Check return value of sb_getblk()
Date: Tue, 19 Oct 2010 22:10:19 +0900
Message-Id: <1287493819-2592-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File block allocation if sb_getblk() returns NULL. unlikely() is added
because it is called in a loop and we've been OK without the check
until now.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext2/inode.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 940c961..4acdc17 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -497,6 +497,11 @@ static int ext2_alloc_branch(struct inode *inode,
 		 * parent to disk.
 		 */
 		bh = sb_getblk(inode->i_sb, new_blocks[n-1]);
+		if (unlikely(!bh)) {
+			err = -EIO;
+			goto failed;
+		}
+
 		branch[n].bh = bh;
 		lock_buffer(bh);
 		memset(bh->b_data, 0, blocksize);
@@ -525,6 +530,14 @@ static int ext2_alloc_branch(struct inode *inode,
 	}
 	*blks = num;
 	return err;
+failed:
+	/* Allocation failed, free what we already allocated */
+	for (i = 0; i < indirect_blks; i++)
+		ext2_free_blocks(inode, new_blocks[i], 1);
+
+	ext2_free_blocks(inode, new_blocks[i], num);
+
+	return err;
 }
 
 /**
-- 
1.7.0.4

