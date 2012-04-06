Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab2DFR1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 13:27:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49964 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2DFR1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 13:27:02 -0400
Message-ID: <4F7F2765.3090003@kernel.org>
Date: Fri, 06 Apr 2012 11:27:01 -0600
From: Shaohua Li <shli@kernel.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "axboe@kernel.dk" <axboe@kernel.dk>
Subject: [PATCH]block: make auto block plug flush threshold per-disk based
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: block: make auto block plug flush threshold per-disk based

We do auto block plug flush to reduce latency, the threshold is 16
requests. This works well if the task is accessing one or two drives.
The problem is if the task is accessing a raid 0 device and the raid
disk number is big, say 8 or 16, 16/8 = 2 or 16/16=1, we will have
heavy lock contention.

This patch makes the threshold per-disk based. The latency should be
still ok accessing one or two drives. The setup with application
accessing a lot of drives in the meantime uaually is big machine,
avoiding lock contention is more important, because any contention
will actually increase latency.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
  block/blk-core.c |    3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c	2012-04-06 10:51:29.766932123 -0600
+++ linux/block/blk-core.c	2012-04-06 10:56:46.386929357 -0600
@@ -1277,7 +1277,8 @@
  	list_for_each_entry_reverse(rq, &plug->list, queuelist) {
  		int el_ret;

-		(*request_count)++;
+		if (rq->q == q)
+			(*request_count)++;

  		if (rq->q != q || !blk_rq_merge_ok(rq, bio))
  			continue;
