Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab2BAVTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:19:48 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48353 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757494Ab2BAVT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:27 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, vgoyal@redhat.com
Cc: ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/11] block: relocate elevator initialized test from blk_cleanup_queue() to blk_drain_queue()
Date: Wed,  1 Feb 2012 13:19:07 -0800
Message-Id: <1328131156-13290-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328131156-13290-1-git-send-email-tj@kernel.org>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_cleanup_queue() may be called for a queue which doesn't have
elevator initialized to skip invoking blk_drain_queue().
blk_drain_queue() will be used for other purposes too and may be
called for such half-initialized queues from other paths.  Move
q->elevator test into blk_drain_queue().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-core.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1b73d06..ddda1cc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -359,6 +359,13 @@ EXPORT_SYMBOL(blk_put_queue);
  */
 void blk_drain_queue(struct request_queue *q, bool drain_all)
 {
+	/*
+	 * The caller might be trying to tear down @q before its elevator
+	 * is initialized, in which case we don't want to call into it.
+	 */
+	if (!q->elevator)
+		return;
+
 	while (true) {
 		bool drain = false;
 		int i;
@@ -468,13 +475,8 @@ void blk_cleanup_queue(struct request_queue *q)
 	spin_unlock_irq(lock);
 	mutex_unlock(&q->sysfs_lock);
 
-	/*
-	 * Drain all requests queued before DEAD marking.  The caller might
-	 * be trying to tear down @q before its elevator is initialized, in
-	 * which case we don't want to call into draining.
-	 */
-	if (q->elevator)
-		blk_drain_queue(q, true);
+	/* drain all requests queued before DEAD marking */
+	blk_drain_queue(q, true);
 
 	/* @q won't process any more request, flush async actions */
 	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
-- 
1.7.7.3

