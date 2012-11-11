Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab2KKN5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 08:57:53 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43187 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab2KKN5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 08:57:51 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH RESEND 1/3] fat: notify when discard is not supported
Date: Sun, 11 Nov 2012 22:57:22 +0900
Message-Id: <1352642242-2694-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FAT also notify warning message about discard support
as ext4(http://patchwork.ozlabs.org/patch/192668/)

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/inode.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 5bafaad..7b186a5 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -26,6 +26,7 @@
 #include <linux/writeback.h>
 #include <linux/log2.h>
 #include <linux/hash.h>
+#include <linux/blkdev.h>
 #include <asm/unaligned.h>
 #include "fat.h"
 
@@ -1431,6 +1432,14 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
 		goto out_fail;
 	}
 
+	if (sbi->options.discard) {
+		struct request_queue *q = bdev_get_queue(sb->s_bdev);
+		if (!blk_queue_discard(q))
+			fat_msg(sb, KERN_WARNING,
+					"mounting with \"discard\" option, but "
+					"the device does not support discard");
+	}
+
 	return 0;
 
 out_invalid:
-- 
1.7.9.5

