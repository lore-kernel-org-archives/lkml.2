Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab1FXW1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 18:27:40 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:45888 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab1FXW1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 18:27:35 -0400
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, padovan@profusion.mobi, marcel@holtmann.org,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org
Subject: [RFC 1/1] workqueue: Add mod_delayed_work()
Date: Fri, 24 Jun 2011 19:27:37 -0300
Message-Id: <1308954457-21487-2-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <1308954457-21487-1-git-send-email-padovan@profusion.mobi>
References: <1308954457-21487-1-git-send-email-padovan@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mod_delayed_work() updates a timer if the work is pending otherwise calls
queue_delayed_work_on() to queue the work with the specified delay.

Call cancel_delayed_work_sync() and then queue_delayed_work() again to
change a timer's delays is too expensive (and requires process context).
Istead we call mod_delayed_work() to only modify the timer's timeout.

LKML-Reference: <20110203161906.GG2570@htj.dyndns.org>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
---
 include/linux/workqueue.h |    2 ++
 kernel/workqueue.c        |   26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 2be2887..44f24a4 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -349,6 +349,8 @@ extern void destroy_workqueue(struct workqueue_struct *wq);
 extern int queue_work(struct workqueue_struct *wq, struct work_struct *work);
 extern int queue_work_on(int cpu, struct workqueue_struct *wq,
 			struct work_struct *work);
+extern int mod_delayed_work(struct workqueue_struct *wq,
+			struct delayed_work *work, unsigned long delay);
 extern int queue_delayed_work(struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 25fb1b0..f8b59ea 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1108,6 +1108,32 @@ static void delayed_work_timer_fn(unsigned long __data)
 }
 
 /**
+ * mod_delayed_work - queue work on a workqueue after delay
+ * @wq: workqueue to use
+ * @dwork: delayable work to queue
+ * @delay: number of jiffies to wait before queueing
+ *
+ * Returns 0 if @work was already on a queue, non-zero otherwise.
+ *
+ */
+int mod_delayed_work(struct workqueue_struct *wq,
+			struct delayed_work *dwork, unsigned long delay)
+{
+	struct timer_list *timer = &dwork->timer;
+	struct work_struct *work = &dwork->work;
+
+	if (!test_bit(WORK_STRUCT_PENDING_BIT, work_data_bits(work)))
+		return queue_delayed_work_on(-1, wq, dwork, delay);
+
+	BUG_ON(!timer_pending(timer));
+
+	mod_timer(timer, jiffies + delay);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mod_delayed_work);
+
+/**
  * queue_delayed_work - queue work on a workqueue after delay
  * @wq: workqueue to use
  * @dwork: delayable work to queue
-- 
1.7.5.1

