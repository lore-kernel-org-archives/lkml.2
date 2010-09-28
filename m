Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab0I1RLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 13:11:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757196Ab0I1RLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 13:11:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com
Subject: [PATCH 1/4] blkio: Do not export throttle files if CONFIG_BLK_DEV_THROTTLING=n
Date: Tue, 28 Sep 2010 13:10:56 -0400
Message-Id: <1285693859-13591-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1285693859-13591-1-git-send-email-vgoyal@redhat.com>
References: <1285693859-13591-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently throttling related files were visible even if user had disabled
throttling using config options. It was switching off background throttling
of bio but not the cgroup files. This patch fixes it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-cgroup.c |   97 +++++++++++++++++++++++++++-------------------------
 1 files changed, 50 insertions(+), 47 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 31a0d4d..1916bc0 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1242,41 +1242,6 @@ struct cftype blkio_files[] = {
 		.write_u64 = blkiocg_file_write_u64,
 	},
 	{
-		.name = "throttle.read_bps_device",
-		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
-				BLKIO_THROTL_read_bps_device),
-		.read_seq_string = blkiocg_file_read,
-		.write_string = blkiocg_file_write,
-		.max_write_len = 256,
-	},
-
-	{
-		.name = "throttle.write_bps_device",
-		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
-				BLKIO_THROTL_write_bps_device),
-		.read_seq_string = blkiocg_file_read,
-		.write_string = blkiocg_file_write,
-		.max_write_len = 256,
-	},
-
-	{
-		.name = "throttle.read_iops_device",
-		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
-				BLKIO_THROTL_read_iops_device),
-		.read_seq_string = blkiocg_file_read,
-		.write_string = blkiocg_file_write,
-		.max_write_len = 256,
-	},
-
-	{
-		.name = "throttle.write_iops_device",
-		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
-				BLKIO_THROTL_write_iops_device),
-		.read_seq_string = blkiocg_file_read,
-		.write_string = blkiocg_file_write,
-		.max_write_len = 256,
-	},
-	{
 		.name = "time",
 		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
 				BLKIO_PROP_time),
@@ -1295,24 +1260,12 @@ struct cftype blkio_files[] = {
 		.read_map = blkiocg_file_read_map,
 	},
 	{
-		.name = "throttle.io_service_bytes",
-		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
-				BLKIO_THROTL_io_service_bytes),
-		.read_map = blkiocg_file_read_map,
-	},
-	{
 		.name = "io_serviced",
 		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
 				BLKIO_PROP_io_serviced),
 		.read_map = blkiocg_file_read_map,
 	},
 	{
-		.name = "throttle.io_serviced",
-		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
-				BLKIO_THROTL_io_serviced),
-		.read_map = blkiocg_file_read_map,
-	},
-	{
 		.name = "io_service_time",
 		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_PROP,
 				BLKIO_PROP_io_service_time),
@@ -1340,6 +1293,56 @@ struct cftype blkio_files[] = {
 		.name = "reset_stats",
 		.write_u64 = blkiocg_reset_stats,
 	},
+#ifdef CONFIG_BLK_DEV_THROTTLING
+	{
+		.name = "throttle.read_bps_device",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_read_bps_device),
+		.read_seq_string = blkiocg_file_read,
+		.write_string = blkiocg_file_write,
+		.max_write_len = 256,
+	},
+
+	{
+		.name = "throttle.write_bps_device",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_write_bps_device),
+		.read_seq_string = blkiocg_file_read,
+		.write_string = blkiocg_file_write,
+		.max_write_len = 256,
+	},
+
+	{
+		.name = "throttle.read_iops_device",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_read_iops_device),
+		.read_seq_string = blkiocg_file_read,
+		.write_string = blkiocg_file_write,
+		.max_write_len = 256,
+	},
+
+	{
+		.name = "throttle.write_iops_device",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_write_iops_device),
+		.read_seq_string = blkiocg_file_read,
+		.write_string = blkiocg_file_write,
+		.max_write_len = 256,
+	},
+	{
+		.name = "throttle.io_service_bytes",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_io_service_bytes),
+		.read_map = blkiocg_file_read_map,
+	},
+	{
+		.name = "throttle.io_serviced",
+		.private = BLKIOFILE_PRIVATE(BLKIO_POLICY_THROTL,
+				BLKIO_THROTL_io_serviced),
+		.read_map = blkiocg_file_read_map,
+	},
+#endif /* CONFIG_BLK_DEV_THROTTLING */
+
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	{
 		.name = "avg_queue_size",
-- 
1.7.2.3

