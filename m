Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161535Ab2CPHkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 03:40:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47340 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032575Ab2CPHkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 03:40:14 -0400
Message-ID: <4F62EE56.6000702@kernel.org>
Date: Fri, 16 Mar 2012 15:40:06 +0800
From: Shaohua Li <shli@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "axboe@kernel.dk" <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>
Subject: [patch]blk: use correct sectors limitation for discard request
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: blk: use correct sectors limitation for discard request

max_discard_sectors doesn't equal to max_sectors/max_hw_sectors. Without 
this,
discard request merge might be ignored.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
  block/blk-merge.c      |   13 ++++++++-----
  include/linux/blkdev.h |    5 +++++
  2 files changed, 13 insertions(+), 5 deletions(-)

Index: linux/block/blk-merge.c
===================================================================
--- linux.orig/block/blk-merge.c	2012-03-14 09:53:15.574255985 +0800
+++ linux/block/blk-merge.c	2012-03-14 11:06:01.504462095 +0800
@@ -228,9 +228,11 @@ no_merge:
  int ll_back_merge_fn(struct request_queue *q, struct request *req,
  		     struct bio *bio)
  {
-	unsigned short max_sectors;
+	unsigned int max_sectors;

-	if (unlikely(req->cmd_type == REQ_TYPE_BLOCK_PC))
+	if (unlikely(req->cmd_flags & REQ_DISCARD))
+		max_sectors = queue_max_discard_sectors(q);
+	else if (unlikely(req->cmd_type == REQ_TYPE_BLOCK_PC))
  		max_sectors = queue_max_hw_sectors(q);
  	else
  		max_sectors = queue_max_sectors(q);
@@ -252,14 +254,15 @@ int ll_back_merge_fn(struct request_queu
  int ll_front_merge_fn(struct request_queue *q, struct request *req,
  		      struct bio *bio)
  {
-	unsigned short max_sectors;
+	unsigned int max_sectors;

-	if (unlikely(req->cmd_type == REQ_TYPE_BLOCK_PC))
+	if (unlikely(req->cmd_flags & REQ_DISCARD))
+		max_sectors = queue_max_discard_sectors(q);
+	else if (unlikely(req->cmd_type == REQ_TYPE_BLOCK_PC))
  		max_sectors = queue_max_hw_sectors(q);
  	else
  		max_sectors = queue_max_sectors(q);

-
  	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
  		req->cmd_flags |= REQ_NOMERGE;
  		if (req == q->last_merge)
Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h	2012-03-14 10:17:19.523960440 +0800
+++ linux/include/linux/blkdev.h	2012-03-14 10:57:22.324465357 +0800
@@ -1006,6 +1006,11 @@ static inline unsigned int queue_max_hw_
  	return q->limits.max_hw_sectors;
  }

+static inline unsigned int queue_max_discard_sectors(struct 
request_queue *q)
+{
+	return q->limits.max_discard_sectors;
+}
+
  static inline unsigned short queue_max_segments(struct request_queue *q)
  {
  	return q->limits.max_segments;
