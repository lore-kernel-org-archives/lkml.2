Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859Ab0JSIWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:22:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58379 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758003Ab0JSIWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:22:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OJTkKZbBLsao5y6jH9nxVrWcODf90b6nUl47UuRU+SoIZmV8z8kOGYh0U8gj2cX1Zp
         sN4NDuyTPAnnJZztWBP44U5MC2+w+0q+si98xJTjIkGTUGB+N7lX/V2P4M9JW6dqUs/w
         ieBZwp8t/UlU6K712aP49GE9MGCUQ8H+jvxqM=
From: Namhyung Kim <namhyung@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: Check return value of sb_getblk() and friends
Date: Tue, 19 Oct 2010 17:22:09 +0900
Message-Id: <1287476529-5314-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fail block allocation if sb_getblk() returns NULL. In that case,
sb_find_get_block() also likely to fail so that it should skip
calling ext4_forget().

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/ext4/inode.c   |    5 +++++
 fs/ext4/mballoc.c |    2 ++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4b8debe..12c0310 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -755,6 +755,11 @@ static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
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
 		BUFFER_TRACE(bh, "call get_create_access");
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4b4ad4b..48f5d10 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4531,6 +4531,8 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 			if (!bh)
 				tbh = sb_find_get_block(inode->i_sb,
 							block + i);
+			if (unlikely(!tbh))
+				continue;
 			ext4_forget(handle, flags & EXT4_FREE_BLOCKS_METADATA,
 				    inode, tbh, block + i);
 		}
-- 
1.7.0.4

