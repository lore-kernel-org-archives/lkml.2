Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab1LRO1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 09:27:15 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:53644 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751039Ab1LRO1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 09:27:13 -0500
From: Tao Ma <tm@tao.ma>
To: linux-ext4@vger.kernel.org
Cc: adilger@dilger.ca, tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH V3 01/21] ext4: Move extra inode read to a new function.
Date: Sun, 18 Dec 2011 22:24:18 +0800
Message-Id: <1324218278-2460-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <4EEDF6B1.7050206@tao.ma>
References: <4EEDF6B1.7050206@tao.ma>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 111.193.15.203 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Currently, in ext4_iget we do a simple check to see whether
there does exist some information starting from the end
of i_extra_size. With inline data added, this procedure
is more complicated. So move it to a new function named
ext4_iget_extra_inode.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inode.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fffec40..dc55c1f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3762,6 +3762,16 @@ static blkcnt_t ext4_inode_blocks(struct ext4_inode *raw_inode,
 	}
 }
 
+static inline void ext4_iget_extra_inode(struct inode *inode,
+					 struct ext4_inode *raw_inode,
+					 struct ext4_inode_info *ei)
+{
+	__le32 *magic = (void *)raw_inode +
+			EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize;
+	if (*magic == cpu_to_le32(EXT4_XATTR_MAGIC))
+		ext4_set_inode_state(inode, EXT4_STATE_XATTR);
+}
+
 struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 {
 	struct ext4_iloc iloc;
@@ -3872,13 +3882,8 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 			/* The extra space is currently unused. Use it. */
 			ei->i_extra_isize = sizeof(struct ext4_inode) -
 					    EXT4_GOOD_OLD_INODE_SIZE;
-		} else {
-			__le32 *magic = (void *)raw_inode +
-					EXT4_GOOD_OLD_INODE_SIZE +
-					ei->i_extra_isize;
-			if (*magic == cpu_to_le32(EXT4_XATTR_MAGIC))
-				ext4_set_inode_state(inode, EXT4_STATE_XATTR);
-		}
+		} else
+			ext4_iget_extra_inode(inode, raw_inode, ei);
 	} else
 		ei->i_extra_isize = 0;
 
-- 
1.7.0.4

