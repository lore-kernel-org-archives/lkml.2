Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab2HOO22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:28:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42329 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab2HOO1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:27:05 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v3 3/6] workqueue: change value of lcpu in __queue_delayed_work_on()
Date: Wed, 15 Aug 2012 23:25:38 +0900
Message-Id: <1345040741-5508-4-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345040741-5508-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1345040741-5508-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We assign cpu id into work struct's data field in __queue_delayed_work_on().
In current implementation, when work is come in first time,
current running cpu id is assigned.
If we do __queue_delayed_work_on() with CPU A on CPU B,
__queue_work() invoked in delayed_work_timer_fn() go into
the following sub-optimal path in case of WQ_NON_REENTRANT.

	gcwq = get_gcwq(cpu);
	if (wq->flags & WQ_NON_REENTRANT &&
		(last_gcwq = get_work_gcwq(work)) && last_gcwq != gcwq) {

Change lcpu to @cpu and rechange lcpu to local cpu if lcpu is WORK_CPU_UNBOUND.
It is sufficient to prevent to go into sub-optimal path.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c29f2dc..32c4f79 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1356,9 +1356,16 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 	if (!(wq->flags & WQ_UNBOUND)) {
 		struct global_cwq *gcwq = get_work_gcwq(work);
 
-		if (gcwq && gcwq->cpu != WORK_CPU_UNBOUND)
+		/*
+		 * If we cannot get gcwq from work directly, we should
+		 * deliberately select last cpu not to go into sub-optimal
+		 * path of reentrance detection for delayed work. In this case,
+		 * we assign requested cpu to lcpu except WORK_CPU_UNBOUND
+		 */
+		lcpu = cpu;
+		if (gcwq)
 			lcpu = gcwq->cpu;
-		else
+		if (lcpu == WORK_CPU_UNBOUND)
 			lcpu = raw_smp_processor_id();
 	} else {
 		lcpu = WORK_CPU_UNBOUND;
-- 
1.7.9.5

