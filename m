Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab0EUIq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 04:46:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57297 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753906Ab0EUIqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 04:46:55 -0400
Message-ID: <4BF6480D.4080902@cn.fujitsu.com>
Date: Fri, 21 May 2010 16:45:01 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] io-controller: a new interface to keep track of io rate
 when group is backlogged
References: <4BF64712.1070500@cn.fujitsu.com>
In-Reply-To: <4BF64712.1070500@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new interface to keep track of io rate of a group when it's backlogged.
If the group is dequeued, io rate isn't calculated.

Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 block/blk-cgroup.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 block/blk-cgroup.h |    5 +++++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 5b47655..01a8c4e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -611,6 +611,49 @@ static uint64_t blkio_get_stat(struct blkio_group *blkg,
 				       delta, cb, dev);
 	}
 
+	if (type == BLKIO_STAT_ACTIVE_RATE) {
+		uint64_t bytes;
+		uint64_t delta;
+
+		delta = get_jiffies_64() -
+			blkg->stats.active_start_time;
+
+		list_for_each_entry(blkiop, &blkio_list, list) {
+			ret = blkiop->ops.blkio_is_blkg_active_fn(blkg);
+			if (!ret) {
+				delta = 0;
+				break;
+			}
+		}
+
+		if (delta == 0)
+			return 0;
+
+		delta = jiffies_to_msecs(delta);
+
+		for (sub_type = BLKIO_STAT_READ; sub_type < BLKIO_STAT_TOTAL;
+		     sub_type++) {
+			blkio_get_key_name(sub_type, dev, key_str,
+					   MAX_KEY_LEN, false);
+
+			bytes = blkg->stats.stat_arr
+				[BLKIO_STAT_ACTIVE_BYTES][sub_type];
+			do_div(bytes, delta);
+			cb->fill(cb, key_str, bytes);
+		}
+
+		disk_total = blkg->stats.stat_arr[BLKIO_STAT_ACTIVE_BYTES]
+						 [BLKIO_STAT_READ] +
+			     blkg->stats.stat_arr[BLKIO_STAT_ACTIVE_BYTES]
+						 [BLKIO_STAT_WRITE];
+
+		do_div(disk_total, delta);
+		blkio_get_key_name(BLKIO_STAT_TOTAL, dev,
+				   key_str, MAX_KEY_LEN, false);
+		cb->fill(cb, key_str, disk_total);
+		return 0;
+	}
+
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	if (type == BLKIO_STAT_AVG_QUEUE_SIZE) {
 		uint64_t sum = blkg->stats.avg_queue_size_sum;
@@ -681,6 +724,7 @@ SHOW_FUNCTION_PER_GROUP(sectors, BLKIO_STAT_SECTORS, 0);
 SHOW_FUNCTION_PER_GROUP(io_service_bytes, BLKIO_STAT_SERVICE_BYTES, 1);
 SHOW_FUNCTION_PER_GROUP(io_active_bytes, BLKIO_STAT_ACTIVE_BYTES, 1);
 SHOW_FUNCTION_PER_GROUP(io_active_time, BLKIO_STAT_ACTIVE_TIME, 0);
+SHOW_FUNCTION_PER_GROUP(io_active_rate, BLKIO_STAT_ACTIVE_RATE, 0);
 SHOW_FUNCTION_PER_GROUP(io_serviced, BLKIO_STAT_SERVICED, 1);
 SHOW_FUNCTION_PER_GROUP(io_service_time, BLKIO_STAT_SERVICE_TIME, 1);
 SHOW_FUNCTION_PER_GROUP(io_wait_time, BLKIO_STAT_WAIT_TIME, 1);
@@ -915,6 +959,10 @@ struct cftype blkio_files[] = {
 		.read_map = blkiocg_io_active_time_read,
 	},
 	{
+		.name = "io_active_rate",
+		.read_map = blkiocg_io_active_rate_read,
+	},
+	{
 		.name = "io_serviced",
 		.read_map = blkiocg_io_serviced_read,
 	},
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index 2ae7976..cd72e7f 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -40,6 +40,11 @@ enum stat_type {
 	 * reset when group enqueued.
 	 */
 	BLKIO_STAT_ACTIVE_TIME,
+	/*
+	 * io rate (in bytes/ms) of the group since group became backlogged,
+	 * if group is dequeued, show zero.
+	 */
+	BLKIO_STAT_ACTIVE_RATE,
 	/* Total IOs serviced, post merge */
 	BLKIO_STAT_SERVICED,
 	/* Total time spent waiting in scheduler queue in ns */
-- 1.5.4.rc3 
