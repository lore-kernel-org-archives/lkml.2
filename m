Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671Ab1HTPlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 11:41:19 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:48176 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752507Ab1HTPlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 11:41:17 -0400
From: Tao Ma <tm@tao.ma>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fs: Add device information for error output in __find_get_block_slow.
Date: Sat, 20 Aug 2011 23:38:59 +0800
Message-Id: <1313854739-3133-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 111.193.5.152 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In ext4 mailist[1], we got some report about errors in
__find_get_block_slow, but the information is very limited.
If the device information is given, we can know the name of
the sick volume. Futhermore, we can get the corresponding
status of that block(group, inode block etc) by analyzing
the disk layout.

[1] http://marc.info/?l=linux-ext4&m=131379831421147&w=2

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/buffer.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 1a80b04..6fe4ece 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -213,13 +213,16 @@ __find_get_block_slow(struct block_device *bdev, sector_t block)
 	 * elsewhere, don't buffer_error if we had some unmapped buffers
 	 */
 	if (all_mapped) {
+		char b[BDEVNAME_SIZE];
+
 		printk("__find_get_block_slow() failed. "
 			"block=%llu, b_blocknr=%llu\n",
 			(unsigned long long)block,
 			(unsigned long long)bh->b_blocknr);
 		printk("b_state=0x%08lx, b_size=%zu\n",
 			bh->b_state, bh->b_size);
-		printk("device blocksize: %d\n", 1 << bd_inode->i_blkbits);
+		printk("device %s blocksize: %d\n", bdevname(bdev, b),
+			1 << bd_inode->i_blkbits);
 	}
 out_unlock:
 	spin_unlock(&bd_mapping->private_lock);
-- 
1.7.0.4

