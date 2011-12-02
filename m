Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1LBXyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:54:52 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:51238 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab1LBXyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:54:51 -0500
X-Authority-Analysis: v=2.0 cv=BK0xXSsG c=1 sm=0 a=QETZmXXmyubuBiJjAgCHWw==:17 a=y8ZX_BOJfaUA:10 a=BjhBlCK6cPEA:10 a=IkcTkHD0fZMA:10 a=ayC55rCoAAAA:8 a=6TUbAxCOOeJgaDh8670A:9 a=QEXdDO2ut3YA:10 a=QETZmXXmyubuBiJjAgCHWw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 97.103.252.48
Message-ID: <4ED96549.1070703@cfl.rr.com>
Date: Fri, 02 Dec 2011 18:54:49 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] loop: cleanup partitions when detaching loop device
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any partitions added by user space to the loop device were being
left in place after detaching the loop device.  This was because
the detach path issued a BLKRRPART to clean up partitions if
LO_FLAGS_PARTSCAN was set, meaning that the partitions were auto
scanned on attach.  Replace this BLKRRPART with code that
unconditionally cleans up partitions on detach instead.

Signed-off-by: Phillip Susi <psusi@cfl.rr.com>
---
 drivers/block/loop.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 68b205a..49a5eb7 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1016,8 +1016,19 @@ static int loop_clr_fd(struct loop_device *lo)
 	lo->lo_state = Lo_unbound;
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
-	if (lo->lo_flags & LO_FLAGS_PARTSCAN && bdev)
-		ioctl_by_bdev(bdev, BLKRRPART, 0);
+	if (bdev)
+	{
+		struct disk_part_iter piter;
+		struct hd_struct *part;
+
+		mutex_lock(&bdev->bd_mutex);
+		invalidate_partition(bdev->bd_disk, 0);
+		disk_part_iter_init(&piter, bdev->bd_disk, DISK_PITER_INCL_EMPTY);
+		while ((part = disk_part_iter_next(&piter)))
+			delete_partition(bdev->bd_disk, part->partno);
+		disk_part_iter_exit(&piter);
+		mutex_unlock(&bdev->bd_mutex);
+	}
 	lo->lo_flags = 0;
 	if (!part_shift)
 		lo->lo_disk->flags |= GENHD_FL_NO_PART_SCAN;
-- 
1.7.5.4

