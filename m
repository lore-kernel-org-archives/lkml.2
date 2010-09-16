Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab0IPLY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 07:24:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:40132 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab0IPLYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 07:24:25 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, oleg@redhat.com
Cc: dmitry.torokhov@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] workqueue: implement flush[_delayed]_work_sync()
Date: Thu, 16 Sep 2010 13:24:07 +0200
Message-Id: <1284636247-4734-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284636247-4734-1-git-send-email-tj@kernel.org>
References: <1284636247-4734-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Sep 2010 11:24:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement flush[_delayed]_work_sync().  These are flush functions
which also make sure no CPU is still executing the target work from
earlier queueing instances.  These are similar to
cancel[_delayed]_work_sync() except that the target work item is
flushed instead of cancelled.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    2 +
 kernel/workqueue.c        |   56 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index bb9b683..e33ff4a 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -355,9 +355,11 @@ extern int keventd_up(void);
 int execute_in_process_context(work_func_t fn, struct execute_work *);
 
 extern bool flush_work(struct work_struct *work);
+extern bool flush_work_sync(struct work_struct *work);
 extern bool cancel_work_sync(struct work_struct *work);
 
 extern bool flush_delayed_work(struct delayed_work *dwork);
+extern bool flush_delayed_work_sync(struct delayed_work *work);
 extern bool cancel_delayed_work_sync(struct delayed_work *dwork);
 
 extern void workqueue_set_max_active(struct workqueue_struct *wq,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 33d31d7..19e4bc1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2435,6 +2435,41 @@ static bool wait_on_work(struct work_struct *work)
 	return ret;
 }
 
+/**
+ * flush_work_sync - wait until a work has finished execution
+ * @work: the work to flush
+ *
+ * Wait until @work has finished execution.  On return, it's
+ * guaranteed that all queueing instances of @work which happened
+ * before this function is called are finished.  In other words, if
+ * @work hasn't been requeued since this function was called, @work is
+ * guaranteed to be idle on return.
+ *
+ * RETURNS:
+ * %true if flush_work_sync() waited for the work to finish execution,
+ * %false if it was already idle.
+ */
+bool flush_work_sync(struct work_struct *work)
+{
+	struct wq_barrier barr;
+	bool pending, waited;
+
+	/* we'll wait for executions separately, queue barr only if pending */
+	pending = start_flush_work(work, &barr, false);
+
+	/* wait for executions to finish */
+	waited = wait_on_work(work);
+
+	/* wait for the pending one */
+	if (pending) {
+		wait_for_completion(&barr.done);
+		destroy_work_on_stack(&barr.work);
+	}
+
+	return pending || waited;
+}
+EXPORT_SYMBOL_GPL(flush_work_sync);
+
 /*
  * Upon a successful return (>= 0), the caller "owns" WORK_STRUCT_PENDING bit,
  * so this work can't be re-armed in any way.
@@ -2539,6 +2574,27 @@ bool flush_delayed_work(struct delayed_work *dwork)
 EXPORT_SYMBOL(flush_delayed_work);
 
 /**
+ * flush_delayed_work_sync - wait for a dwork to finish
+ * @dwork: the delayed work to flush
+ *
+ * Delayed timer is cancelled and the pending work is queued for
+ * execution immediately.  Other than timer handling, its behavior
+ * is identical to flush_work_sync().
+ *
+ * RETURNS:
+ * %true if flush_work_sync() waited for the work to finish execution,
+ * %false if it was already idle.
+ */
+bool flush_delayed_work_sync(struct delayed_work *dwork)
+{
+	if (del_timer_sync(&dwork->timer))
+		__queue_work(raw_smp_processor_id(),
+			     get_work_cwq(&dwork->work)->wq, &dwork->work);
+	return flush_work_sync(&dwork->work);
+}
+EXPORT_SYMBOL(flush_delayed_work_sync);
+
+/**
  * cancel_delayed_work_sync - cancel a delayed work and wait for it to finish
  * @dwork: the delayed work cancel
  *
-- 
1.7.1

