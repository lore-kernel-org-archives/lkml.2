Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428Ab1HEEje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 00:39:34 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:39914 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750751Ab1HEEjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 00:39:32 -0400
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
        Roland Dreier <roland@purestorage.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH] block: Make rq_affinity = 1 work as expected.
Date: Fri,  5 Aug 2011 12:39:10 +0800
Message-Id: <1312519150-3261-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.4.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

Commit 5757a6d76c introduced a new rq_affinity = 2 so as to make
the request completed in the __make_request cpu. But it makes the
old rq_affinity = 1 not work any more. The root cause is that
if the 'cpu' and 'req->cpu' is in the same group and cpu != req->cpu,
ccpu will be the same as group_cpu, so the completion will be
excuted in the 'cpu' not 'group_cpu'.

This patch fix problem by simpling removing group_cpu and the codes
are more explicit now. If ccpu == cpu, we complete in cpu, otherwise
we raise_blk_irq to ccpu.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 block/blk-softirq.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 475fab8..487addc 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -103,7 +103,7 @@ static struct notifier_block __cpuinitdata blk_cpu_notifier = {
 
 void __blk_complete_request(struct request *req)
 {
-	int ccpu, cpu, group_cpu = NR_CPUS;
+	int ccpu, cpu;
 	struct request_queue *q = req->q;
 	unsigned long flags;
 
@@ -117,14 +117,12 @@ void __blk_complete_request(struct request *req)
 	 */
 	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) && req->cpu != -1) {
 		ccpu = req->cpu;
-		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags)) {
+		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags))
 			ccpu = blk_cpu_to_group(ccpu);
-			group_cpu = blk_cpu_to_group(cpu);
-		}
 	} else
 		ccpu = cpu;
 
-	if (ccpu == cpu || ccpu == group_cpu) {
+	if (ccpu == cpu) {
 		struct list_head *list;
 do_local:
 		list = &__get_cpu_var(blk_cpu_done);
-- 
1.6.3.3.334.g916e1.dirty

