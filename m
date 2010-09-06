Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab0IFMqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:46:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:50751 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab0IFMqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:46:37 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, hch@lst.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] backing-dev: update trace points
Date: Mon,  6 Sep 2010 14:46:21 +0200
Message-Id: <1283777182-11426-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283777182-11426-1-git-send-email-tj@kernel.org>
References: <1283777182-11426-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Sep 2010 12:46:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* writeback_nothread is replaced with writeback_rescuer, which is
  triggered when a writeback work is called from the bdi_wq rescuer.

* writeback_wake[_forker]_thread are replaced with writeback_timer.

* writeback_thread_start/stop are replaced with writeback_start/stop
  which are triggered when a writeback work starts and finishes
  execution.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/trace/events/writeback.h |    9 ++++-----
 mm/backing-dev.c                 |    6 ++++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index f345f66..58e1f01 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -46,7 +46,7 @@ DECLARE_EVENT_CLASS(writeback_work_class,
 DEFINE_EVENT(writeback_work_class, name, \
 	TP_PROTO(struct backing_dev_info *bdi, struct wb_writeback_work *work), \
 	TP_ARGS(bdi, work))
-DEFINE_WRITEBACK_WORK_EVENT(writeback_nothread);
+DEFINE_WRITEBACK_WORK_EVENT(writeback_rescuer);
 DEFINE_WRITEBACK_WORK_EVENT(writeback_queue);
 DEFINE_WRITEBACK_WORK_EVENT(writeback_exec);
 
@@ -81,12 +81,11 @@ DEFINE_EVENT(writeback_class, name, \
 	TP_ARGS(bdi))
 
 DEFINE_WRITEBACK_EVENT(writeback_nowork);
-DEFINE_WRITEBACK_EVENT(writeback_wake_thread);
-DEFINE_WRITEBACK_EVENT(writeback_wake_forker_thread);
+DEFINE_WRITEBACK_EVENT(writeback_timer);
 DEFINE_WRITEBACK_EVENT(writeback_bdi_register);
 DEFINE_WRITEBACK_EVENT(writeback_bdi_unregister);
-DEFINE_WRITEBACK_EVENT(writeback_thread_start);
-DEFINE_WRITEBACK_EVENT(writeback_thread_stop);
+DEFINE_WRITEBACK_EVENT(writeback_start);
+DEFINE_WRITEBACK_EVENT(writeback_stop);
 
 DECLARE_EVENT_CLASS(wbc_class,
 	TP_PROTO(struct writeback_control *wbc, struct backing_dev_info *bdi),
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index e874916..3b2a657 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -314,6 +314,7 @@ static void bdi_timer_fn(unsigned long data)
 {
 	struct backing_dev_info *bdi = (struct backing_dev_info *)data;
 
+	trace_writeback_timer(bdi);
 	queue_work(bdi_wq, &bdi->wb.work);
 }
 
@@ -347,6 +348,8 @@ static void bdi_work_fn(struct work_struct *work)
 	struct backing_dev_info *bdi = wb->bdi;
 	long pages_written;
 
+	trace_writeback_start(bdi);
+
 	WARN(!test_bit(BDI_registered, &bdi->state),
 	     "bdi %p/%s is not registered!\n", bdi, bdi->name);
 
@@ -369,6 +372,7 @@ static void bdi_work_fn(struct work_struct *work)
 			trace_writeback_pages_written(pages_written);
 		} while (!list_empty(&bdi->work_list));
 	} else {
+		trace_writeback_rescuer(bdi, work);
 		bdi_flush_io(bdi);
 		if (!list_empty(&bdi->work_list))
 			queue_work(bdi_wq, work);
@@ -378,6 +382,8 @@ static void bdi_work_fn(struct work_struct *work)
 		bdi_delayed_writeback(bdi);
 
 	current->flags &= ~(PF_FLUSHER | PF_SWAPWRITE);
+
+	trace_writeback_stop(bdi);
 }
 
 /*
-- 
1.7.1

