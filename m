Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1HKHLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 03:11:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:5960 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab1HKHLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 03:11:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,355,1309762800"; 
   d="scan'208";a="37347528"
Subject: [patch]block: revert a patch
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: boyu.mt@taobao.com, Christoph Hellwig <hch@infradead.org>,
        dan.j.williams@intel.com, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 15:11:50 +0800
Message-ID: <1313046710.27321.7.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reverts commit 35ae66e0a09ab70ed(block: Make rq_affinity = 1
work as expected). The purpose is to avoid an unnecessary IPI.
Let's take an example. My test box has cpu 0-7, one socket. Say request is
added from CPU 1, blk_complete_request() occurs at CPU 7. Without the reverted
patch, softirq will be done at CPU 7. With it, an IPI will be directed to CPU
0, and softirq will be done at CPU 0. In this case, doing softirq at CPU 0 and
CPU 7 have no difference from cache sharing point view and we can avoid an
ipi if doing it in CPU 7.
An immediate concern is this is just like QUEUE_FLAG_SAME_FORCE, but actually
not. blk_complete_request() is running in interrupt handler, and currently
I/O controller doesn't support multiple interrupts (I checked several LSI
cards and AHCI), so only one CPU can run blk_complete_request(). This is
still quite different as QUEUE_FLAG_SAME_FORCE.
Since only one CPU runs softirq, the only difference with below patch is
softirq not always runs at the first CPU of a group.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 487addc..58340d0 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -103,7 +103,7 @@ static struct notifier_block __cpuinitdata blk_cpu_notifier = {
 
 void __blk_complete_request(struct request *req)
 {
-	int ccpu, cpu;
+	int ccpu, cpu, group_cpu = NR_CPUS;
 	struct request_queue *q = req->q;
 	unsigned long flags;
 
@@ -117,12 +117,22 @@ void __blk_complete_request(struct request *req)
 	 */
 	if (test_bit(QUEUE_FLAG_SAME_COMP, &q->queue_flags) && req->cpu != -1) {
 		ccpu = req->cpu;
-		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags))
+		if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags)) {
 			ccpu = blk_cpu_to_group(ccpu);
+			group_cpu = blk_cpu_to_group(cpu);
+		}
 	} else
 		ccpu = cpu;
 
-	if (ccpu == cpu) {
+	/*
+	 * If current CPU and requested CPU are in the same group, running
+	 * softirq in current CPU. One might concern this is just like
+	 * QUEUE_FLAG_SAME_FORCE, but actually not. blk_complete_request() is
+	 * running in interrupt handler, and currently I/O controller doesn't
+	 * support multiple interrupts, so current CPU is unique actually. This
+	 * avoids IPI sending from current CPU to the first CPU of a group.
+	 */
+	if (ccpu == cpu || ccpu == group_cpu) {
 		struct list_head *list;
 do_local:
 		list = &__get_cpu_var(blk_cpu_done);


