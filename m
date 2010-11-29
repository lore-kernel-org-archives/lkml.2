Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab0K2JBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:01:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab0K2JBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:01:14 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Xiaotian Feng <dfeng@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block: check for proper length of iov entries earlier in blk_rq_map_user_iov()
Date: Mon, 29 Nov 2010 17:00:55 +0800
Message-Id: <1291021255-2838-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9284bcf checks for proper length of iov entries in
blk_rq_map_user_iov(). But if the map is unaligned, kernel
will break out the loop without checking for the proper length.
So we need to check the proper length before the unalign check.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/blk-map.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 5d5dbe4..e663ac2 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -201,12 +201,13 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 	for (i = 0; i < iov_count; i++) {
 		unsigned long uaddr = (unsigned long)iov[i].iov_base;
 
+		if (!iov[i].iov_len)
+			return -EINVAL;
+
 		if (uaddr & queue_dma_alignment(q)) {
 			unaligned = 1;
 			break;
 		}
-		if (!iov[i].iov_len)
-			return -EINVAL;
 	}
 
 	if (unaligned || (q->dma_pad_mask & len) || map_data)
-- 
1.7.3.2

