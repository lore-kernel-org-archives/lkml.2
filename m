Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab1LMAQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:16:43 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:29330 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab1LMAQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:16:26 -0500
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=QETZmXXmyubuBiJjAgCHWw==:17 a=YU8HmM6wsVwA:10 a=ayC55rCoAAAA:8 a=ersyLoyZyrwa3_OOiu8A:9 a=XxWkru6UDOmNnCge:21 a=lrMdyHpm8OyyNkx9:21 a=QETZmXXmyubuBiJjAgCHWw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 97.103.252.48
From: Phillip Susi <psusi@cfl.rr.com>
To: vgoyal@redhat.com
Cc: joe@perches.com, kzak@redhat.com, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com, psusi@cfl.rr.com
Subject: [PATCH 2/2] Add BLKPG_GET_PARTITION operation
Date: Mon, 12 Dec 2011 19:16:22 -0500
Message-Id: <1323735382-5972-2-git-send-email-psusi@cfl.rr.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323735382-5972-1-git-send-email-psusi@cfl.rr.com>
References: <4EE6990A.9010202@cfl.rr.com>
 <1323735382-5972-1-git-send-email-psusi@cfl.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new operation to the BLKPG ioctl to read the partition.
This allows user space to find the current start and length
of a partition without having to open the partition and use
the long depreciated HDIO_GETGEO ioctl.

Signed-off-by: Phillip Susi <psusi@cfl.rr.com>
---
 block/ioctl.c         |   15 +++++++++++++++
 include/linux/blkpg.h |    1 +
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index e4e9198..c84a949 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -139,6 +139,21 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 			disk_put_part(part);
 			mutex_unlock(&bdev->bd_mutex);
 			return 0;
+		case BLKPG_GET_PARTITION:
+			mutex_lock(&bdev->bd_mutex);
+			part = disk_get_part(disk, partno);
+			if (!part)
+			{
+				mutex_unlock(&bdev->bd_mutex);
+				return -ENXIO;
+			}
+			p.start = part->start_sect << 9;
+			p.length = part->nr_sects << 9;
+			disk_put_part(part);
+			mutex_unlock(&bdev->bd_mutex);
+			if (copy_to_user(a.data, &p, sizeof(struct blkpg_partition)))
+				return -EFAULT;
+			return 0;
 		default:
 			return -EINVAL;
 	}
diff --git a/include/linux/blkpg.h b/include/linux/blkpg.h
index a851944..72bf5e2 100644
--- a/include/linux/blkpg.h
+++ b/include/linux/blkpg.h
@@ -41,6 +41,7 @@ struct blkpg_ioctl_arg {
 #define BLKPG_ADD_PARTITION	1
 #define BLKPG_DEL_PARTITION	2
 #define BLKPG_RESIZE_PARTITION	3
+#define BLKPG_GET_PARTITION	4
 
 /* Sizes of name fields. Unused at present. */
 #define BLKPG_DEVNAMELTH	64
-- 
1.7.5.4

