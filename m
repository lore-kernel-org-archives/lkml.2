Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab2DMTHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 15:07:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:16649 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab2DMTHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 15:07:07 -0400
Date: Fri, 13 Apr 2012 22:06:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [patch v2] workqueue: change BUG_ON() to WARN_ON()
Message-ID: <20120413190658.GA18505@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YOSy-acB7Oara9ay1Zeznx0vCSB0Z23F+6KtEKZ56nXmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4F887959.005F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This BUG_ON() can be triggered if you call schedule_work() before
calling INIT_WORK().  It is a bug definitely, but it's nicer to just
print a stack trace and return.

Reported-by: Matt Renzelmann <mjr@cs.wisc.edu>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: the first version added a second check before the BUG_ON()

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5abf42f..66ec08d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1032,7 +1032,10 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 	cwq = get_cwq(gcwq->cpu, wq);
 	trace_workqueue_queue_work(cpu, cwq, work);
 
-	BUG_ON(!list_empty(&work->entry));
+	if (WARN_ON(!list_empty(&work->entry))) {
+		spin_unlock_irqrestore(&gcwq->lock, flags);
+		return;
+	}
 
 	cwq->nr_in_flight[cwq->work_color]++;
 	work_flags = work_color_to_flags(cwq->work_color);
