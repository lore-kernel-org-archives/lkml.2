Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab1G1IWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 04:22:23 -0400
Received: from mail.neotion.com ([91.121.222.125]:53671 "EHLO mail.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263Ab1G1IWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 04:22:17 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jul 2011 04:22:16 EDT
From: Neil Armstrong <narmstrong@neotion.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Namhyung Kim <namhyung@gmail.com>, Davidlohr Bueso <dave@gnu.org>
Cc: linux-kernel@vger.kernel.org, Neil Armstrong <narmstrong@neotion.com>
Subject: [PATCH 1/1] init: Fix ramdisk identification for padded cramfs
Date: Thu, 28 Jul 2011 10:12:30 +0200
Message-Id: <1311840750-32428-1-git-send-email-narmstrong@neotion.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a cramfs ramdisk padded with 512 bytes is given to the kernel,
the current identify_ramdisk_image function fails to identify it.

Tested with a padded cramfs image on an ARM based board.

Signed-off-by: Neil Armstrong <narmstrong@neotion.com>
---
 init/do_mounts_rd.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/init/do_mounts_rd.c b/init/do_mounts_rd.c
index fe9acb0..887629e 100644
--- a/init/do_mounts_rd.c
+++ b/init/do_mounts_rd.c
@@ -120,6 +120,20 @@ identify_ramdisk_image(int fd, int start_block, decompress_fn *decompressor)
 	}
 
 	/*
+	 * Read 512 bytes further to check if cramfs is padded
+	 */
+	sys_lseek(fd, start_block * BLOCK_SIZE + 0x200, 0);
+	sys_read(fd, buf, size);
+
+	if (cramfsb->magic == CRAMFS_MAGIC) {
+		printk(KERN_NOTICE
+		       "RAMDISK: cramfs filesystem found at block %d\n",
+		       start_block);
+		nblocks = (cramfsb->size + BLOCK_SIZE - 1) >> BLOCK_SIZE_BITS;
+		goto done;
+	}
+
+	/*
 	 * Read block 1 to test for minix and ext2 superblock
 	 */
 	sys_lseek(fd, (start_block+1) * BLOCK_SIZE, 0);
-- 
1.7.0.4

