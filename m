Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab1GVU7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 16:59:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:41026 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218Ab1GVU7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 16:59:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,249,1309762800"; 
   d="scan'208";a="31325717"
Subject: [RFC PATCH 2/2] block: adaptive rq_affinity
To: jaxboe@fusionio.com
From: Dan Williams <dan.j.williams@intel.com>
Cc: Roland Dreier <roland@purestorage.com>, Dave Jiang <dave.jiang@intel.com>,
        linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Date: Fri, 22 Jul 2011 13:59:44 -0700
Message-ID: <20110722205944.17420.78978.stgit@localhost6.localdomain6>
In-Reply-To: <20110722205736.17420.41366.stgit@localhost6.localdomain6>
References: <20110722205736.17420.41366.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15-7-g9bfb-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some storage configurations the coarse grained cpu grouping (socket)
does not supply enough cpu to keep up with the demands of high iops.
Bypass the grouping and complete on the direct requester cpu when the
local cpu is under softirq pressure (as measured by ksoftirqd being in
the running state).

Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Roland Dreier <roland@purestorage.com>
Tested-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/blk-softirq.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 475fab8..f0cda19 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -101,16 +101,20 @@ static struct notifier_block __cpuinitdata blk_cpu_notifier = {
 	.notifier_call	= blk_cpu_notify,
 };
 
+DECLARE_PER_CPU(struct task_struct *, ksoftirqd);
+
 void __blk_complete_request(struct request *req)
 {
 	int ccpu, cpu, group_cpu = NR_CPUS;
 	struct request_queue *q = req->q;
+	struct task_struct *tsk;
 	unsigned long flags;
 
 	BUG_ON(!q->softirq_done_fn);
 
 	local_irq_save(flags);
 	cpu = smp_processor_id();
+	tsk = per_cpu(ksoftirqd, cpu);
 
 	/*
 	 * Select completion CPU
@@ -124,7 +128,13 @@ void __blk_complete_request(struct request *req)
 	} else
 		ccpu = cpu;
 
-	if (ccpu == cpu || ccpu == group_cpu) {
+	/*
+	 * try to skip a remote softirq-trigger if the completion is
+	 * within the same group, but not if local softirqs have already
+	 * spilled to ksoftirqd
+	 */
+	if (ccpu == cpu ||
+	    (ccpu == group_cpu && tsk->state != TASK_RUNNING)) {
 		struct list_head *list;
 do_local:
 		list = &__get_cpu_var(blk_cpu_done);

