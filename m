Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab0EMP5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:57:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:33048 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003Ab0EMP5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:57:17 -0400
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, James.Bottomley@suse.de,
       linux-kernel@vger.kernel.org
Cc: ben@decadent.org.uk, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] block: restart partition scan after resizing a device
Date: Thu, 13 May 2010 17:56:43 +0200
Message-Id: <1273766206-17402-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273766206-17402-1-git-send-email-tj@kernel.org>
References: <1273766206-17402-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 15:56:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device resize via ->set_capacity() can reveal new partitions (e.g. in
chained partition table formats such as dos extended parts).  Restart
partition scan from the beginning after resizing a device.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/partitions/check.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index e238ab2..f80a58d 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -550,7 +550,7 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 	res = invalidate_partition(disk, 0);
 	if (res)
 		return res;
-
+rescan:
 	disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
 	while ((part = disk_part_iter_next(&piter)))
 		delete_partition(disk, part->partno);
@@ -581,7 +581,7 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 	/* add partitions */
 	for (p = 1; p < state->limit; p++) {
 		sector_t size, from;
-try_scan:
+
 		size = state->parts[p].size;
 		if (!size)
 			continue;
@@ -612,7 +612,8 @@ try_scan:
 					check_disk_size_change(disk, bdev);
 					bdev->bd_invalidated = 0;
 				}
-				goto try_scan;
+				kfree(state);
+				goto rescan;
 			} else {
 				/*
 				 * we can not ignore partitions of broken tables
-- 
1.6.4.2

