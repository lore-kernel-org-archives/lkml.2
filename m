Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab2JSDZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 23:25:08 -0400
Received: from condef003-v.nifty.com ([210.131.4.240]:47057 "EHLO
	condef003-v.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965085Ab2JSDZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 23:25:01 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2012 23:25:01 EDT
X-Nifty-SrcIP: [61.204.25.121]
From: MITSUNARI Shigeo <herumi@nifty.com>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, MITSUNARI Shigeo <herumi@nifty.com>
Subject: [PATCH 1/2] block: fs: bd_invalidated should be cleared in revalidate_disk
Date: Fri, 19 Oct 2012 12:16:41 +0900
Message-Id: <1350616602-6892-2-git-send-email-herumi@nifty.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350616602-6892-1-git-send-email-herumi@nifty.com>
References: <1350616602-6892-1-git-send-email-herumi@nifty.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rescan_partitions() and invalidate_partitions() in block/partition-generic.c
set bdev->bd_invalidated = 0 after calling check_disk_size_change().
But revalidate_disk() in fs/block_dev.c does not clear it.

If bdev->bd_invalidated = 1 then rescan_partitions() is called when
__blkdev_get() is called.
So if revalidate_disk() is once called, all buffer cache pages will be
cleared whenever the device is opened.

This patch fixes the bug.
I add bdev->bd_invalidated = 0; after calling check_disk_size_change().

Signed-off-by: MITSUNARI Shigeo <herumi@nifty.com>
---
 fs/block_dev.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 38e721b..2577cf4 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1047,6 +1047,7 @@ int revalidate_disk(struct gendisk *disk)
 
 	mutex_lock(&bdev->bd_mutex);
 	check_disk_size_change(disk, bdev);
+	bdev->bd_invalidated = 0;
 	mutex_unlock(&bdev->bd_mutex);
 	bdput(bdev);
 	return ret;
-- 
1.7.9.5

