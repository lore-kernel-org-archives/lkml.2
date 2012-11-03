Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2KCG2v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 02:28:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35981 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2KCG2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 02:28:49 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH v2 2/3] fat: notify when discard is not supported
Date: Sat,  3 Nov 2012 15:28:39 +0900
Message-Id: <1351924119-14284-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FAT also notify warning message about discard support
as ext4(http://patchwork.ozlabs.org/patch/192668/)

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/fat/inode.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 8d79657..3b48bab 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -26,6 +26,7 @@
 #include <linux/writeback.h>
 #include <linux/log2.h>
 #include <linux/hash.h>
+#include <linux/blkdev.h>
 #include <asm/unaligned.h>
 #include "fat.h"
 
@@ -1446,6 +1447,14 @@ int fat_fill_super(struct super_block *sb, void *data, int silent, int isvfat,
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

