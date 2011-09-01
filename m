Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab1IANh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 09:37:26 -0400
Received: from mta0.cl.cam.ac.uk ([128.232.25.20]:40119 "EHLO
	mta0.cl.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491Ab1IANhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 09:37:23 -0400
From: Ripduman Sohan <ripduman.sohan@cl.cam.ac.uk>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
        Ripduman Sohan <ripduman.sohan@cl.cam.ac.uk>
Subject: [PATCH] workqueue: Restore cpus_allowed mask for sleeping workqueue rescue threads
Date: Thu,  1 Sep 2011 14:36:33 +0100
Message-Id: <1314884193-20454-1-git-send-email-ripduman.sohan@cl.cam.ac.uk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rescuer threads may be migrated (and are bound) to particular CPUs when
active.  However, the allowed_cpus mask is not restored when they return
to sleep rendering inconsistent the presented and actual set of CPUs the
process may potentially run on.  This patch fixes this oversight by
recording the allowed_cpus mask for rescuer threads when it enters the
rescuer_thread() main loop and restoring it every time the thread sleeps.

v2: Heeded Peter Zijlstra's comments and don't allocate cpumask_t on
    stack, manipulate task cpus_allowed struct directly instead

Signed-off-by: Ripduman Sohan <ripduman.sohan@cl.cam.ac.uk>
---
 kernel/workqueue.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 25fb1b0..29d2ddf 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2078,6 +2078,12 @@ repeat:
 		spin_unlock_irq(&gcwq->lock);
 	}
 
+        if (is_unbound)
+                cpumask_setall(&current->cpus_allowed);
+        else
+                for_each_cwq_cpu(cpu, wq)
+                        cpu_set(cpu, current->cpus_allowed);
+
 	schedule();
 	goto repeat;
 }
-- 
1.7.1

