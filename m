Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab1HMPcn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 11:32:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46229 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab1HMPcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 11:32:42 -0400
Date: Sat, 13 Aug 2011 17:32:37 +0200
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: add GENHD_FL_UNPARTITIONABLE
Message-ID: <20110813153237.GD4254@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are cases where suppressing partition scan is useful - e.g. for
lo devices and pseudo SATA devices which advertise to be a disk but
get upset on partition scan (some port multiplier control devices show
such behavior).

This patch adds GENHD_FL_UNPARTITIONABLE which suppresses partition
scan regardless of the number of possible partitions.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 include/linux/genhd.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 02fa469..a6f9329 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -128,6 +128,7 @@ struct hd_struct {
 #define GENHD_FL_EXT_DEVT			64 /* allow extended devt */
 #define GENHD_FL_NATIVE_CAPACITY		128
 #define GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE	256
+#define GENHD_FL_UNPARTITIONABLE		512
 
 enum {
 	DISK_EVENT_MEDIA_CHANGE			= 1 << 0, /* media changed */
@@ -236,7 +237,8 @@ static inline int disk_max_parts(struct gendisk *disk)
 
 static inline bool disk_partitionable(struct gendisk *disk)
 {
-	return disk_max_parts(disk) > 1;
+	return disk_max_parts(disk) > 1 &&
+		!(disk->flags & GENHD_FL_UNPARTITIONABLE);
 }
 
 static inline dev_t disk_devt(struct gendisk *disk)
