Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab2ICCMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 22:12:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35878 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab2ICCMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 22:12:34 -0400
From: Robin Dong <robin.k.dong@gmail.com>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>
Subject: [PATCH 1/2] md: add new interface 'mk_rq' in target_type
Date: Mon,  3 Sep 2012 10:12:25 +0800
Message-Id: <1346638346-497-1-git-send-email-robin.k.dong@gmail.com>
X-Mailer: git-send-email 1.7.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Dong <sanbai@taobao.com>

We are now trying to modify flashcache(https://github.com/facebook/flashcache)
to make it request based so that
we can let cfq io-controller control the bandwidth between different
io cgroups.

A search in the dm directory tells me that only multipath is a request
based dm target and its functionality
is very simple and map_rq() is used to map the request to different underlying devices.
We can't work in this way because:

1. the request which processed by map_rq() need to be issued to
	different lower devices (disk device and cache device, in flashcache), therefore the request
	can't be totally remapped by simply changing its queue and returning DM_MAPIO_REMAPPED in map_rq() like multipath_map()
2. to submit bios drectly in map_rq() (by return DM_MAPIO_SUBMITTED) will cause BUG_ON(!irqs_disabled())
	in dm_request_fn() because the submit_bio()->generic_make_request()->blk_queue_bio() will definitly call spin_unlock_irq to enable the irqs


As above,the interface map_rq() provided by devcie-mapper framework
is not enough for an autonomous target, like flashcache.

We propose to add a new
mk_rq interface so that we can make the requests
by ourselves.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 drivers/md/dm.c               |   10 ++++++++++
 include/linux/device-mapper.h |    3 +++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 4e09b6f..3ae67de 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1459,11 +1459,21 @@ static int dm_request_based(struct mapped_device *md)
 static void dm_request(struct request_queue *q, struct bio *bio)
 {
 	struct mapped_device *md = q->queuedata;
+	struct dm_table *map = dm_get_live_table(md);
+	struct dm_target *ti = dm_table_find_target(map, bio->bi_sector);
+
+	if (ti->type->mk_rq) {
+		ti->type->mk_rq(ti, q, bio);
+		goto out;
+	}
 
 	if (dm_request_based(md))
 		blk_queue_bio(q, bio);
 	else
 		_dm_request(q, bio);
+
+out:
+	dm_table_put(map);
 }
 
 void dm_dispatch_request(struct request *rq)
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 38d27a1..2386389 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -50,6 +50,8 @@ typedef int (*dm_map_fn) (struct dm_target *ti, struct bio *bio,
 			  union map_info *map_context);
 typedef int (*dm_map_request_fn) (struct dm_target *ti, struct request *clone,
 				  union map_info *map_context);
+typedef int (*dm_make_request_fn) (struct dm_target *ti,
+				struct request_queue *q, struct bio *bio);
 
 /*
  * Returns:
@@ -136,6 +138,7 @@ struct target_type {
 	dm_dtr_fn dtr;
 	dm_map_fn map;
 	dm_map_request_fn map_rq;
+	dm_make_request_fn mk_rq;
 	dm_endio_fn end_io;
 	dm_request_endio_fn rq_end_io;
 	dm_presuspend_fn presuspend;
-- 
1.7.1

