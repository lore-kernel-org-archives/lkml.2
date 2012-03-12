Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab2CLDOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 23:14:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61279 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab2CLDNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 23:13:15 -0400
Message-Id: <20120312031306.030156009@fusionio.com>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 11:04:19 +0800
From: Shaohua Li <shli@fusionio.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
Subject: [patch 7/7] blk: use correct sectors limitation for discard request
References: <20120312030412.375458948@fusionio.com>
Content-Disposition: inline; filename=blk-discard-merge-maxsector-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

max_discard_sectors doesn't equal to max_sectors/max_hw_sectors. Without this,
discard request merge might be ignored.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 block/blk-merge.c      |    9 +++++++--
 include/linux/blkdev.h |    5 +++++
 2 files changed, 12 insertions(+), 2 deletions(-)

Index: linux/block/blk-merge.c
===================================================================
--- linux.orig/block/blk-merge.c	2012-03-09 14:05:35.562062857 +0800
+++ linux/block/blk-merge.c	2012-03-09 14:07:55.432062246 +0800
@@ -228,13 +228,16 @@ no_merge:
 int ll_back_merge_fn(struct request_queue *q, struct request *req,
 		     struct bio *bio)
 {
-	unsigned short max_sectors;
+	unsigned int max_sectors;
 
 	if (unlikely(req->cmd_type == REQ_TYPE_BLOCK_PC))
 		max_sectors = queue_max_hw_sectors(q);
 	else
 		max_sectors = queue_max_sectors(q);
 
+	if (unlikely(req->cmd_flags & REQ_DISCARD))
+		max_sectors = queue_max_discard_sectors(q);
+
 	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
@@ -252,13 +255,15 @@ int ll_back_merge_fn(struct request_queu
 int ll_front_merge_fn(struct request_queue *q, struct request *req,
 		      struct bio *bio)
 {
-	unsigned short max_sectors;
+	unsigned int max_sectors;
 
 	if (unlikely(req->cmd_type == REQ_TYPE_BLOCK_PC))
 		max_sectors = queue_max_hw_sectors(q);
 	else
 		max_sectors = queue_max_sectors(q);
 
+	if (unlikely(req->cmd_flags & REQ_DISCARD))
+		max_sectors = queue_max_discard_sectors(q);
 
 	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h	2012-03-09 14:05:35.562062857 +0800
+++ linux/include/linux/blkdev.h	2012-03-09 14:07:55.432062246 +0800
@@ -1006,6 +1006,11 @@ static inline unsigned int queue_max_hw_
 	return q->limits.max_hw_sectors;
 }
 
+static inline unsigned int queue_max_discard_sectors(struct request_queue *q)
+{
+	return q->limits.max_discard_sectors;
+}
+
 static inline unsigned short queue_max_segments(struct request_queue *q)
 {
 	return q->limits.max_segments;

