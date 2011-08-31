Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab1HaNZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 09:25:36 -0400
Received: from mta0.cl.cam.ac.uk ([128.232.25.20]:43090 "EHLO
	mta0.cl.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab1HaNZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 09:25:34 -0400
X-Greylist: delayed 467 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Aug 2011 09:25:34 EDT
From: Ripduman Sohan <ripduman.sohan@cl.cam.ac.uk>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, Ripduman Sohan <ripduman.sohan@cl.cam.ac.uk>
Subject: [PATCH] workqueue: Restore cpus_allowed mask for sleeping workqueue rescue threads
Date: Wed, 31 Aug 2011 14:17:43 +0100
Message-Id: <1314796663-4215-1-git-send-email-ripduman.sohan@cl.cam.ac.uk>
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

Signed-off-by: Ripduman Sohan <ripduman.sohan@cl.cam.ac.uk>
---
 kernel/workqueue.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 25fb1b0..0a4e785 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2031,6 +2031,7 @@ static int rescuer_thread(void *__wq)
 	struct list_head *scheduled = &rescuer->scheduled;
 	bool is_unbound = wq->flags & WQ_UNBOUND;
 	unsigned int cpu;
+        cpumask_t allowed_cpus = current->cpus_allowed;
 
 	set_user_nice(current, RESCUER_NICE_LEVEL);
 repeat:
@@ -2078,6 +2079,8 @@ repeat:
 		spin_unlock_irq(&gcwq->lock);
 	}
 
+        set_cpus_allowed_ptr(current, &allowed_cpus);
+
 	schedule();
 	goto repeat;
 }
-- 
1.7.1

