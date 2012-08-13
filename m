Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2HMQTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:19:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40143 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2HMQTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:19:38 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 2/5] workqueue: change value of lcpu in queue_delayed_work_on()
Date: Tue, 14 Aug 2012 01:17:49 +0900
Message-Id: <1344874672-6257-2-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344874672-6257-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1344874672-6257-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We assign cpu id into work struct in queue_delayed_work_on().
In current implementation, when work is come in first time,
current running cpu id is assigned.
If we do queue_delayed_work_on() with CPU A on CPU B,
__queue_work() invoked in delayed_work_timer_fn() go into sub-optimal path
in case of WQ_NON_REENTRANT.
Change it to cpu argument is prevent to go into sub-optimal path.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 188eef8..bc5c5e1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1158,6 +1158,8 @@ int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 
 			if (gcwq && gcwq->cpu != WORK_CPU_UNBOUND)
 				lcpu = gcwq->cpu;
+			else if (cpu >= 0)
+				lcpu = cpu;
 			else
 				lcpu = raw_smp_processor_id();
 		} else
-- 
1.7.9.5

