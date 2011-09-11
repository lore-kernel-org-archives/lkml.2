Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764Ab1IKD12 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 23:27:28 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5000 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab1IKD11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 23:27:27 -0400
Date: Sat, 10 Sep 2011 23:26:41 -0400
From: Thomas Tuttle <ttuttle@chromium.org>
To: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] workqueue: lock cwq access in drain_workqueue
Message-ID: <20110911032641.GA22325@google.com>
References: <20110909152222.GA14705@google.com>
 <20110909230053.GA28394@google.com>
 <20110911013549.GI29319@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110911013549.GI29319@htj.dyndns.org>
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
Renamed "cwq_flushed" to "drained" as requested and rebased against
current HEAD (d0a77454c70d0449a5f87087deb8f0cb15145e90).

 kernel/workqueue.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 25fb1b0..1783aab 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2412,8 +2412,13 @@ reflush:
 
 	for_each_cwq_cpu(cpu, wq) {
 		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		bool drained;
 
-		if (!cwq->nr_active && list_empty(&cwq->delayed_works))
+		spin_lock_irq(&cwq->gcwq->lock);
+		drained = !cwq->nr_active && list_empty(&cwq->delayed_works);
+		spin_unlock_irq(&cwq->gcwq->lock);
+
+		if (drained)
 			continue;
 
 		if (++flush_cnt == 10 ||
-- 
1.7.3.1

