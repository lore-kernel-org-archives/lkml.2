Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab2HNSMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:12:34 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51602 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab2HNSLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:11:42 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 3/6] workqueue: change value of lcpu in __queue_delayed_work_on()
Date: Wed, 15 Aug 2012 03:10:13 +0900
Message-Id: <1344967816-1136-4-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344967816-1136-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1344967816-1136-1-git-send-email-js1304@gmail.com>
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
index 6a17ab0..f55ac26 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1358,9 +1358,10 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 	if (!(wq->flags & WQ_UNBOUND)) {
 		struct global_cwq *gcwq = get_work_gcwq(work);
 
-		if (gcwq && gcwq->cpu != WORK_CPU_UNBOUND)
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

