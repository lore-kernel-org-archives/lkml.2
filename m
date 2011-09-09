Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021Ab1IIXBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 19:01:42 -0400
Received: from smtp-out.google.com ([74.125.121.67]:56931 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759931Ab1IIXBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 19:01:39 -0400
Date: Fri, 9 Sep 2011 19:00:53 -0400
From: Thomas Tuttle <ttuttle@chromium.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH v2] workqueue: lock cwq access in drain_workqueue
Message-ID: <20110909230053.GA28394@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909152222.GA14705@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take cwq->gcwq->lock to avoid racing between drain_workqueue checking
to make sure the workqueues are empty and cwq_dec_nr_in_flight
decrementing and then incrementing nr_active when it activates a
delayed work.

We discovered this when a corner case in one of our drivers resulted in
us trying to destroy a workqueue in which the remaining work would
always requeue itself again in the same workqueue.  We would hit this
race condition and trip the BUG_ON on workqueue.c:3080.

Signed-off-by: Thomas Tuttle <ttuttle@chromium.org>
---
Updated to use bool instead of int (d'oh), and CCed maintainer.

 kernel/workqueue.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 25fb1b0..0c2e585 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2412,8 +2412,14 @@ reflush:
 
 	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		bool cwq_flushed;
 
-		if (!cwq->nr_active && list_empty(&cwq->delayed_works))
+		spin_lock_irq(&cwq->gcwq->lock);
+		cwq_flushed = !cwq->nr_active
+			      && list_empty(&cwq->delayed_works);
+		spin_unlock_irq(&cwq->gcwq->lock);
+
+		if (cwq_flushed)
 			continue;
 
 		if (++flush_cnt == 10 ||
-- 
1.7.3.1
