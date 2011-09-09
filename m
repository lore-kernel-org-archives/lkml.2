Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933589Ab1IIUeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 16:34:08 -0400
Received: from static-76-160-165-106.dsl.cavtel.net ([76.160.165.106]:33138
	"EHLO static-76-160-165-106.dsl.cavtel.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933377Ab1IIUeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 16:34:07 -0400
Message-ID: <4E6A783D.9040708@metrics.net>
Date: Fri, 09 Sep 2011 16:34:05 -0400
From: Anthony DeRobertis <aderobertis@metrics.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Icedove/3.1.13
MIME-Version: 1.0
To: Linux-kernel mailing list <linux-kernel@vger.kernel.org>
Subject: RFC: [PATCH] Add a sysfs entry queue/ignore_flushes.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an Oracle workload that ran quite fast under 2.6.32 due to mdraid
not supporting barriers. 2.6.33 slowed it down very substantially, and
its remains slow in 3.1. (Oracle is running on raw LVM logical volumes,
not filesystems, so ext4 barrier=0 doesn't help).

This patch adds a sysfs attribute to allow flush/fua to to turned off
(ignored) on a per-block-device basis. I have tested it on both a VM and
real hardware.

I'm not sure that queue_flags is the best place to put the bit, seems
like it may more logically go in flush_flags, but everything else is in
queue_flags.

I'm not subscribed, but will be looking for replies via list archives.
Feel free to CC me.

diff --git a/block/blk-core.c b/block/blk-core.c
index 90e1ffd..fd4f1c1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1515,9 +1515,11 @@ static inline void __generic_make_request(struct bio *bio)
 		/*
 		 * Filter flush bio's early so that make_request based
 		 * drivers without flush support don't have to worry
-		 * about them.
+		 * about them. Also filter if configured to ignore flushes.
 		 */
-		if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) && !q->flush_flags) {
+		if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) &&
+			(!q->flush_flags ||
+			 test_bit(QUEUE_FLAG_IGNORE_FLUSH, &q->queue_flags))) {
 			bio->bi_rw &= ~(REQ_FLUSH | REQ_FUA);
 			if (!nr_sectors) {
 				err = 0;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 0ee17b5..8f19827 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -214,6 +214,7 @@ queue_store_##name(struct request_queue *q, const char *page, size_t count) \
 
 QUEUE_SYSFS_BIT_FNS(nonrot, NONROT, 1);
 QUEUE_SYSFS_BIT_FNS(random, ADD_RANDOM, 0);
+QUEUE_SYSFS_BIT_FNS(ignore_flushes, IGNORE_FLUSH, 0);
 QUEUE_SYSFS_BIT_FNS(iostats, IO_STAT, 0);
 #undef QUEUE_SYSFS_BIT_FNS
 
@@ -385,6 +386,12 @@ static struct queue_sysfs_entry queue_random_entry = {
 	.store = queue_store_random,
 };
 
+static struct queue_sysfs_entry queue_ignore_flushes_entry = {
+	.attr = {.name = "ignore_flushes", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_show_ignore_flushes,
+	.store = queue_store_ignore_flushes,
+};
+
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
@@ -407,6 +414,7 @@ static struct attribute *default_attrs[] = {
 	&queue_rq_affinity_entry.attr,
 	&queue_iostats_entry.attr,
 	&queue_random_entry.attr,
+	&queue_ignore_flushes_entry.attr,
 	NULL,
 };
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 84b15d5..61b39e0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -408,6 +408,7 @@ struct request_queue {
 #define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
+#define QUEUE_FLAG_IGNORE_FLUSH 19	/* ignore REQ_FLUSH and REQ_FUA */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\


