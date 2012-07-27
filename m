Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab2G0Xzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 19:55:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51273 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab2G0Xzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 19:55:48 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        padovan@profusion.mobi, marcel@holtmann.org, peterz@infradead.org,
        mingo@redhat.com, davem@davemloft.net, dougthompson@xmission.com,
        ibm-acpi@hmh.eng.br, cbou@mail.ru, rui.zhang@intel.com,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Jiri Kosina <jkosina@suse.cz>, Roland Dreier <roland@kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 15/15] workqueue: deprecate __cancel_delayed_work()
Date: Fri, 27 Jul 2012 16:55:08 -0700
Message-Id: <1343433308-26614-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343433308-26614-1-git-send-email-tj@kernel.org>
References: <1343433308-26614-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cancel_delayed_work() is different from cancel_delayed_work() in
that it uses del_timer() instead of del_timer_sync().  This adds
confusion to already complicated flush / cancel API and given that the
only thing delayed_work->timer does is queueing the work, the
difference between cancel_delayed_work() and __cancel_delayed_work()
isn't anything material.

Furthermore, none of the remaining users are on hot path racing
against high-frequency work item making the chance of actually waiting
for delayed_work_timer_fn() very slim.

Use cancel_delayed_work() instead of __cancel_delayed_work() and mark
the latter deprecated.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Roland Dreier <roland@kernel.org>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
 block/blk-core.c              |    2 +-
 drivers/block/floppy.c        |    2 +-
 drivers/infiniband/core/mad.c |    2 +-
 drivers/video/omap2/dss/dsi.c |    2 +-
 include/linux/workqueue.h     |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 43f6c17..7befb9c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -262,7 +262,7 @@ EXPORT_SYMBOL(blk_start_queue);
  **/
 void blk_stop_queue(struct request_queue *q)
 {
-	__cancel_delayed_work(&q->delay_work);
+	cancel_delayed_work(&q->delay_work);
 	queue_flag_set(QUEUE_FLAG_STOPPED, q);
 }
 EXPORT_SYMBOL(blk_stop_queue);
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index aebd1e8..0e1e364 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -889,7 +889,7 @@ static void unlock_fdc(void)
 
 	raw_cmd = NULL;
 	command_status = FD_COMMAND_NONE;
-	__cancel_delayed_work(&fd_timeout);
+	cancel_delayed_work(&fd_timeout);
 	do_floppy = NULL;
 	cont = NULL;
 	clear_bit(0, &fdc_busy);
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index b593814..dc3fd1e 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2004,7 +2004,7 @@ static void adjust_timeout(struct ib_mad_agent_private *mad_agent_priv)
 	unsigned long delay;
 
 	if (list_empty(&mad_agent_priv->wait_list)) {
-		__cancel_delayed_work(&mad_agent_priv->timed_work);
+		cancel_delayed_work(&mad_agent_priv->timed_work);
 	} else {
 		mad_send_wr = list_entry(mad_agent_priv->wait_list.next,
 					 struct ib_mad_send_wr_private,
diff --git a/drivers/video/omap2/dss/dsi.c b/drivers/video/omap2/dss/dsi.c
index 14ce8cc..7869767 100644
--- a/drivers/video/omap2/dss/dsi.c
+++ b/drivers/video/omap2/dss/dsi.c
@@ -4307,7 +4307,7 @@ static void dsi_framedone_irq_callback(void *data, u32 mask)
 	 * and is sending the data.
 	 */
 
-	__cancel_delayed_work(&dsi->framedone_timeout_work);
+	cancel_delayed_work(&dsi->framedone_timeout_work);
 
 	dsi_handle_framedone(dsidev, 0);
 }
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 2000030..feed2bb 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -445,7 +445,7 @@ static inline bool cancel_delayed_work(struct delayed_work *work)
  * if it returns 0 the timer function may be running and the queueing is in
  * progress.
  */
-static inline bool __cancel_delayed_work(struct delayed_work *work)
+static inline bool __deprecated __cancel_delayed_work(struct delayed_work *work)
 {
 	bool ret;
 
-- 
1.7.7.3

