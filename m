Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab1ACN5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 08:57:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60593 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab1ACNuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 08:50:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=d399bJaangpf198GwyY2sH2FCIsng3I1HtL0sVY+PLe5tnFV5M/0VcKQaJYMkXUydD
         hhZKdNBhOdk6tYLzxXwYgkhOIyeyB2vZO7vNsAwN3eqdmXXYomdHaU7GH7fOsGSxeyeC
         BToOrdow4/NBjgjnIuAyIVLS6MpkeUNoGFXWk=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/32] block: make kblockd_workqueue smarter
Date: Mon,  3 Jan 2011 14:49:26 +0100
Message-Id: <1294062595-30097-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294062595-30097-1-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kblockd is used for unplugging and may affect IO latency and
throughput and the max number of concurrent work items are bound by
the number of block devices.  Make it HIGHPRI workqueue w/ default max
concurrency.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
Please feel free to take it into the subsystem tree or simply ack -
I'll route it through the wq tree.

Thanks.

 block/blk-core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4ce953f..909b84a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2606,7 +2606,9 @@ int __init blk_dev_init(void)
 	BUILD_BUG_ON(__REQ_NR_BITS > 8 *
 			sizeof(((struct request *)0)->cmd_flags));
 
-	kblockd_workqueue = create_workqueue("kblockd");
+	/* used for unplugging and affects IO latency/throughput - HIGHPRI */
+	kblockd_workqueue = alloc_workqueue("kblockd",
+					    WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
 	if (!kblockd_workqueue)
 		panic("Failed to create kblockd\n");
 
-- 
1.7.1

