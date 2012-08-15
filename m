Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2HOO1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:27:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42329 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781Ab2HOO1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:27:03 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v3 2/6] workqueue: correct req_cpu in trace_workqueue_queue_work()
Date: Wed, 15 Aug 2012 23:25:37 +0900
Message-Id: <1345040741-5508-3-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345040741-5508-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1345040741-5508-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we do tracing workqueue_queue_work(), it records requested cpu.
But, if !(@wq->flag & WQ_UNBOUND) and @cpu is WORK_CPU_UNBOUND,
requested cpu is changed as local cpu.
In case of @wq->flag & WQ_UNBOUND, above change is not occured,
therefore it is reasonable to correct it.

Use temporary local variable for storing requested cpu.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 49d8f4a..c29f2dc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1198,6 +1198,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	struct cpu_workqueue_struct *cwq;
 	struct list_head *worklist;
 	unsigned int work_flags;
+	unsigned int req_cpu = cpu;
 
 	/*
 	 * While a work item is PENDING && off queue, a task trying to
@@ -1253,7 +1254,7 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 
 	/* gcwq determined, get cwq and queue */
 	cwq = get_cwq(gcwq->cpu, wq);
-	trace_workqueue_queue_work(cpu, cwq, work);
+	trace_workqueue_queue_work(req_cpu, cwq, work);
 
 	if (WARN_ON(!list_empty(&work->entry))) {
 		spin_unlock(&gcwq->lock);
-- 
1.7.9.5

