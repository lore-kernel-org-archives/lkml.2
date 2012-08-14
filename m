Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab2HNSLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:11:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61359 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab2HNSLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:11:40 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 2/6] workqueue: correct req_cpu in trace_workqueue_queue_work()
Date: Wed, 15 Aug 2012 03:10:12 +0900
Message-Id: <1344967816-1136-3-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344967816-1136-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1344967816-1136-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we do tracing workqueue_queue_work(), it records requested cpu.
But, if !(@wq->flag & WQ_UNBOUND) and @cpu is WORK_CPU_UNBOUND,
requested cpu is changed as local cpu.
In case of @wq->flag & WQ_UNBOUND, above change is not occured,
therefore it is reasonable to correct it.

Use temporary local variable for storing local cpu.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 49d8f4a..6a17ab0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1198,6 +1198,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	struct cpu_workqueue_struct *cwq;
 	struct list_head *worklist;
 	unsigned int work_flags;
+	unsigned int lcpu;
 
 	/*
 	 * While a work item is PENDING && off queue, a task trying to
@@ -1219,7 +1220,9 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 		struct global_cwq *last_gcwq;
 
 		if (cpu == WORK_CPU_UNBOUND)
-			cpu = raw_smp_processor_id();
+			lcpu = raw_smp_processor_id();
+		else
+			lcpu = cpu;
 
 		/*
 		 * It's multi cpu.  If @wq is non-reentrant and @work
@@ -1227,7 +1230,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 		 * be running there, in which case the work needs to
 		 * be queued on that cpu to guarantee non-reentrance.
 		 */
-		gcwq = get_gcwq(cpu);
+		gcwq = get_gcwq(lcpu);
 		if (wq->flags & WQ_NON_REENTRANT &&
 		    (last_gcwq = get_work_gcwq(work)) && last_gcwq != gcwq) {
 			struct worker *worker;
-- 
1.7.9.5

