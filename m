Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019Ab2HHVik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 17:38:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38439 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916Ab2HHVih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 17:38:37 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@redhat.com, akpm@linux-foundation.org,
        tglx@linutronix.de, peterz@infradead.org, davem@davemloft.net,
        tomi.valkeinen@ti.com, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>,
        Roland Dreier <roland@kernel.org>
Subject: [PATCH 7/7] workqueue: deprecate __cancel_delayed_work()
Date: Wed,  8 Aug 2012 14:38:02 -0700
Message-Id: <1344461882-10149-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1344461882-10149-1-git-send-email-tj@kernel.org>
References: <1344461882-10149-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that cancel_delayed_work() can be safely called from IRQ handlers,
there's no reason to use __cancel_delayed_work().  Use
cancel_delayed_work() instead of __cancel_delayed_work() and mark the
latter deprecated.

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
index 4b8b606..dc04a90 100644
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
index 55a5bc0..17c675c 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -890,7 +890,7 @@ static void unlock_fdc(void)
 
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
index fd40f26..05ee046 100644
--- a/drivers/video/omap2/dss/dsi.c
+++ b/drivers/video/omap2/dss/dsi.c
@@ -4306,7 +4306,7 @@ static void dsi_framedone_irq_callback(void *data, u32 mask)
 	 * and is sending the data.
 	 */
 
-	__cancel_delayed_work(&dsi->framedone_timeout_work);
+	cancel_delayed_work(&dsi->framedone_timeout_work);
 
 	dsi_handle_framedone(dsidev, 0);
 }
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 6306157..6cd8f91 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -431,7 +431,7 @@ extern unsigned int work_busy(struct work_struct *work);
  * if it returns 0 the timer function may be running and the queueing is in
  * progress.
  */
-static inline bool __cancel_delayed_work(struct delayed_work *work)
+static inline bool __deprecated __cancel_delayed_work(struct delayed_work *work)
 {
 	bool ret;
 
-- 
1.7.7.3

