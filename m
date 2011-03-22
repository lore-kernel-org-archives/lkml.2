Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab1CVURy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:17:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55533 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799Ab1CVURn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:17:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=tVo+a0ejEHF7jyHs8VWmPOB+/SpkvX5DTo2izFye2cMRtuXwR3zOb/JLFVNGdc60p
	EEH5ED3/Hu32iZ834NZIw==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com, jaxboe@fusionio.com
Cc: linux-kernel@vger.kernel.org, Justin TerAvest <teravest@google.com>
Subject: [PATCH 2/2] blk-cgroup: Only give unaccounted_time under debug
Date: Tue, 22 Mar 2011 13:17:30 -0700
Message-Id: <1300825050-11371-3-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1300825050-11371-1-git-send-email-teravest@google.com>
References: <1300825050-11371-1-git-send-email-teravest@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change moves unaccounted_time to only be reported when
CONFIG_DEBUG_BLK_CGROUP is true.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/blk-cgroup.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 77ee3c1..2bef570 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -605,10 +605,10 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 	if (type == BLKIO_STAT_SECTORS)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
 					blkg->stats.sectors, cb, dev);
+#ifdef CONFIG_DEBUG_BLK_CGROUP
 	if (type == BLKIO_STAT_UNACCOUNTED_TIME)
 		return blkio_fill_stat(key_str, MAX_KEY_LEN - 1,
 					blkg->stats.unaccounted_time, cb, dev);
-#ifdef CONFIG_DEBUG_BLK_CGROUP
 	if (type == BLKIO_STAT_AVG_QUEUE_SIZE) {
 		uint64_t sum = blkg->stats.avg_queue_size_sum;
 		uint64_t samples = blkg->stats.avg_queue_size_samples;
@@ -1111,9 +1111,6 @@ static int blkiocg_file_read_map(struct cgroup *cgrp, struct cftype *cft,
 		case BLKIO_PROP_sectors:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
 						BLKIO_STAT_SECTORS, 0);
-		case BLKIO_PROP_unaccounted_time:
-			return blkio_read_blkg_stats(blkcg, cft, cb,
-						BLKIO_STAT_UNACCOUNTED_TIME, 0);
 		case BLKIO_PROP_io_service_bytes:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
 						BLKIO_STAT_SERVICE_BYTES, 1);
@@ -1133,6 +1130,9 @@ static int blkiocg_file_read_map(struct cgroup *cgrp, struct cftype *cft,
 			return blkio_read_blkg_stats(blkcg, cft, cb,
 						BLKIO_STAT_QUEUED, 1);
 #ifdef CONFIG_DEBUG_BLK_CGROUP
+		case BLKIO_PROP_unaccounted_time:
+			return blkio_read_blkg_stats(blkcg, cft, cb,
+						BLKIO_STAT_UNACCOUNTED_TIME, 0);
 		case BLKIO_PROP_dequeue:
 			return blkio_read_blkg_stats(blkcg, cft, cb,
 						BLKIO_STAT_DEQUEUE, 0);
@@ -1270,12 +1270,6 @@ struct cftype blkio_files[] = {
 		.read_map = blkiocg_file_read_map,
 	},
 	{
-		.name = "unaccounted_time",
-		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
-				BLKIO_PROP_unaccounted_time),
-		.read_map = blkiocg_file_read_map,
-	},
-	{
 		.name = "io_service_bytes",
 		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
 				BLKIO_PROP_io_service_bytes),
@@ -1396,6 +1390,12 @@ struct cftype blkio_files[] = {
 				BLKIO_PROP_dequeue),
 		.read_map = blkiocg_file_read_map,
 	},
+	{
+		.name = "unaccounted_time",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
+				BLKIO_PROP_unaccounted_time),
+		.read_map = blkiocg_file_read_map,
+	},
 #endif
 };
 
-- 
1.7.3.1

