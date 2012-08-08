Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932993Ab2HHVih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:38:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51413 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab2HHVie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:38:34 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org, davem@davemloft.net,
        tomi.valkeinen@ti.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/7] workqueue: use mod_delayed_work() instead of __cancel + queue
Date: Wed,  8 Aug 2012 14:38:00 -0700
Message-Id: <1344461882-10149-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344461882-10149-1-git-send-email-tj@kernel.org>
References: <1344461882-10149-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that mod_delayed_work() is safe to call from IRQ handlers,
__cancel_delayed_work() followed by queue_delayed_work() can be
replaced with mod_delayed_work().

Most conversions are straight-forward except for the following.

* net/core/link_watch.c: linkwatch_schedule_work() was doing a quite
  elaborate dancing around its delayed_work.  Collapse it such that
  linkwatch_work is queued for immediate execution if LW_URGENT and
  existing timer is kept otherwise.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 block/blk-core.c                    |    6 ++----
 block/blk-throttle.c                |    7 +------
 drivers/block/floppy.c              |    3 +--
 drivers/infiniband/core/mad.c       |   14 +++++---------
 drivers/input/keyboard/qt2160.c     |    3 +--
 drivers/input/mouse/synaptics_i2c.c |    7 +------
 net/core/link_watch.c               |   21 ++++++---------------
 7 files changed, 17 insertions(+), 44 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..4b8b606 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -319,10 +319,8 @@ EXPORT_SYMBOL(__blk_run_queue);
  */
 void blk_run_queue_async(struct request_queue *q)
 {
-	if (likely(!blk_queue_stopped(q))) {
-		__cancel_delayed_work(&q->delay_work);
-		queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
-	}
+	if (likely(!blk_queue_stopped(q)))
+		mod_delayed_work(kblockd_workqueue, &q->delay_work, 0);
 }
 EXPORT_SYMBOL(blk_run_queue_async);
 
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index e287c19..3d3dcae 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -930,12 +930,7 @@ throtl_schedule_delayed_work(struct throtl_data *td, unsigned long delay)
 
 	/* schedule work if limits changed even if no bio is queued */
 	if (total_nr_queued(td) || td->limits_changed) {
-		/*
-		 * We might have a work scheduled to be executed in future.
-		 * Cancel that and schedule a new one.
-		 */
-		__cancel_delayed_work(dwork);
-		queue_delayed_work(kthrotld_workqueue, dwork, delay);
+		mod_delayed_work(kthrotld_workqueue, dwork, delay);
 		throtl_log(td, "schedule work. delay=%lu jiffies=%lu",
 				delay, jiffies);
 	}
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index a7d6347..55a5bc0 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -672,7 +672,6 @@ static void __reschedule_timeout(int drive, const char *message)
 
 	if (drive == current_reqD)
 		drive = current_drive;
-	__cancel_delayed_work(&fd_timeout);
 
 	if (drive < 0 || drive >= N_DRIVE) {
 		delay = 20UL * HZ;
@@ -680,7 +679,7 @@ static void __reschedule_timeout(int drive, const char *message)
 	} else
 		delay = UDP->timeout;
 
-	queue_delayed_work(floppy_wq, &fd_timeout, delay);
+	mod_delayed_work(floppy_wq, &fd_timeout, delay);
 	if (UDP->flags & FD_DEBUG)
 		DPRINT("reschedule timeout %s\n", message);
 	timeout_message = message;
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index b0d0bc8..b593814 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2013,13 +2013,11 @@ static void adjust_timeout(struct ib_mad_agent_private *mad_agent_priv)
 		if (time_after(mad_agent_priv->timeout,
 			       mad_send_wr->timeout)) {
 			mad_agent_priv->timeout = mad_send_wr->timeout;
-			__cancel_delayed_work(&mad_agent_priv->timed_work);
 			delay = mad_send_wr->timeout - jiffies;
 			if ((long)delay <= 0)
 				delay = 1;
-			queue_delayed_work(mad_agent_priv->qp_info->
-					   port_priv->wq,
-					   &mad_agent_priv->timed_work, delay);
+			mod_delayed_work(mad_agent_priv->qp_info->port_priv->wq,
+					 &mad_agent_priv->timed_work, delay);
 		}
 	}
 }
@@ -2052,11 +2050,9 @@ static void wait_for_response(struct ib_mad_send_wr_private *mad_send_wr)
 	list_add(&mad_send_wr->agent_list, list_item);
 
 	/* Reschedule a work item if we have a shorter timeout */
-	if (mad_agent_priv->wait_list.next == &mad_send_wr->agent_list) {
-		__cancel_delayed_work(&mad_agent_priv->timed_work);
-		queue_delayed_work(mad_agent_priv->qp_info->port_priv->wq,
-				   &mad_agent_priv->timed_work, delay);
-	}
+	if (mad_agent_priv->wait_list.next == &mad_send_wr->agent_list)
+		mod_delayed_work(mad_agent_priv->qp_info->port_priv->wq,
+				 &mad_agent_priv->timed_work, delay);
 }
 
 void ib_reset_mad_timeout(struct ib_mad_send_wr_private *mad_send_wr,
diff --git a/drivers/input/keyboard/qt2160.c b/drivers/input/keyboard/qt2160.c
index e7a5e36..76b7d43 100644
--- a/drivers/input/keyboard/qt2160.c
+++ b/drivers/input/keyboard/qt2160.c
@@ -156,8 +156,7 @@ static irqreturn_t qt2160_irq(int irq, void *_qt2160)
 
 	spin_lock_irqsave(&qt2160->lock, flags);
 
-	__cancel_delayed_work(&qt2160->dwork);
-	schedule_delayed_work(&qt2160->dwork, 0);
+	mod_delayed_work(system_wq, &qt2160->dwork, 0);
 
 	spin_unlock_irqrestore(&qt2160->lock, flags);
 
diff --git a/drivers/input/mouse/synaptics_i2c.c b/drivers/input/mouse/synaptics_i2c.c
index f1467570..063a174 100644
--- a/drivers/input/mouse/synaptics_i2c.c
+++ b/drivers/input/mouse/synaptics_i2c.c
@@ -376,12 +376,7 @@ static void synaptics_i2c_reschedule_work(struct synaptics_i2c *touch,
 
 	spin_lock_irqsave(&touch->lock, flags);
 
-	/*
-	 * If work is already scheduled then subsequent schedules will not
-	 * change the scheduled time that's why we have to cancel it first.
-	 */
-	__cancel_delayed_work(&touch->dwork);
-	schedule_delayed_work(&touch->dwork, delay);
+	mod_delayed_work(system_wq, &touch->dwork, delay);
 
 	spin_unlock_irqrestore(&touch->lock, flags);
 }
diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index c3519c6..8e397a6 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -120,22 +120,13 @@ static void linkwatch_schedule_work(int urgent)
 		delay = 0;
 
 	/*
-	 * This is true if we've scheduled it immeditately or if we don't
-	 * need an immediate execution and it's already pending.
+	 * If urgent, schedule immediate execution; otherwise, don't
+	 * override the existing timer.
 	 */
-	if (schedule_delayed_work(&linkwatch_work, delay) == !delay)
-		return;
-
-	/* Don't bother if there is nothing urgent. */
-	if (!test_bit(LW_URGENT, &linkwatch_flags))
-		return;
-
-	/* It's already running which is good enough. */
-	if (!__cancel_delayed_work(&linkwatch_work))
-		return;
-
-	/* Otherwise we reschedule it again for immediate execution. */
-	schedule_delayed_work(&linkwatch_work, 0);
+	if (test_bit(LW_URGENT, &linkwatch_flags))
+		mod_delayed_work(system_wq, &linkwatch_work, 0);
+	else
+		schedule_delayed_work(&linkwatch_work, delay);
 }
 
 
-- 
1.7.7.3

