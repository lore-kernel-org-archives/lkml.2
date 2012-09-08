Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab2IHP4N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 11:56:13 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:52254 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953Ab2IHP4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 11:56:11 -0400
From: Dave Reisner <dreisner@archlinux.org>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Dave Reisner <dreisner@archlinux.org>, alan@lxorguk.ukuu.org.uk
Subject: [PATCH] block: reject invalid queue attribute values
Date: Sat,  8 Sep 2012 11:55:45 -0400
Message-Id: <1347119745-7044-1-git-send-email-dreisner@archlinux.org>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using simple_strtoul which "converts" invalid numbers to 0,
use strict_strtoul and perform error checking to ensure that userspace
passes us a valid unsigned long. This addresses problems with functions
such as writev, which might want to write a trailing newline -- the
newline should rightfully be rejected, but the value preceeding it
should be preserved.

Fixes BZ#46981.

Signed-off-by: Dave Reisner <dreisner@archlinux.org>
---
 block/blk-sysfs.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 9628b29..ea51d82 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -26,9 +26,15 @@ queue_var_show(unsigned long var, char *page)
 static ssize_t
 queue_var_store(unsigned long *var, const char *page, size_t count)
 {
-	char *p = (char *) page;
+	int err;
+	unsigned long v;
+
+	err = strict_strtoul(page, 10, &v);
+	if (err || v > UINT_MAX)
+		return -EINVAL;
+
+	*var = v;
 
-	*var = simple_strtoul(p, &p, 10);
 	return count;
 }
 
@@ -48,6 +54,9 @@ queue_requests_store(struct request_queue *q, const char *page, size_t count)
 		return -EINVAL;
 
 	ret = queue_var_store(&nr, page, count);
+	if (ret < 0)
+		return ret;
+
 	if (nr < BLKDEV_MIN_RQ)
 		nr = BLKDEV_MIN_RQ;
 
@@ -102,6 +111,9 @@ queue_ra_store(struct request_queue *q, const char *page, size_t count)
 	unsigned long ra_kb;
 	ssize_t ret = queue_var_store(&ra_kb, page, count);
 
+	if (ret < 0)
+		return ret;
+
 	q->backing_dev_info.ra_pages = ra_kb >> (PAGE_CACHE_SHIFT - 10);
 
 	return ret;
@@ -176,6 +188,9 @@ queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 			page_kb = 1 << (PAGE_CACHE_SHIFT - 10);
 	ssize_t ret = queue_var_store(&max_sectors_kb, page, count);
 
+	if (ret < 0)
+		return ret;
+
 	if (max_sectors_kb > max_hw_sectors_kb || max_sectors_kb < page_kb)
 		return -EINVAL;
 
@@ -236,6 +251,9 @@ static ssize_t queue_nomerges_store(struct request_queue *q, const char *page,
 	unsigned long nm;
 	ssize_t ret = queue_var_store(&nm, page, count);
 
+	if (ret < 0)
+		return ret;
+
 	spin_lock_irq(q->queue_lock);
 	queue_flag_clear(QUEUE_FLAG_NOMERGES, q);
 	queue_flag_clear(QUEUE_FLAG_NOXMERGES, q);
@@ -264,6 +282,9 @@ queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 	unsigned long val;
 
 	ret = queue_var_store(&val, page, count);
+	if (ret < 0)
+		return ret;
+
 	spin_lock_irq(q->queue_lock);
 	if (val == 2) {
 		queue_flag_set(QUEUE_FLAG_SAME_COMP, q);
-- 
1.7.12

