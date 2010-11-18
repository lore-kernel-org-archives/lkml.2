Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759714Ab0KRQNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:13:31 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:36035 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382Ab0KRQMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:12:36 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCHv4 08/17] pps: add async PPS event handler
Date: Thu, 18 Nov 2010 19:01:01 +0300
Message-Id: <65eae4de46680aa8d644619f6dc61ba17f1fdc77.1290087479.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This handler should be called from an IRQ handler. It uses per-device
workqueue internally.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/clients/pps-ktimer.c |    2 +-
 drivers/pps/clients/pps-ldisc.c  |    2 +-
 drivers/pps/kapi.c               |   95 ++++++++++++++++++++++++++++++++++++--
 drivers/pps/pps.c                |   14 +++++-
 include/linux/pps_kernel.h       |   12 +++++
 5 files changed, 117 insertions(+), 8 deletions(-)

diff --git a/drivers/pps/clients/pps-ktimer.c b/drivers/pps/clients/pps-ktimer.c
index 2728469..26ed7a2 100644
--- a/drivers/pps/clients/pps-ktimer.c
+++ b/drivers/pps/clients/pps-ktimer.c
@@ -48,7 +48,7 @@ static void pps_ktimer_event(unsigned long ptr)
 
 	dev_info(pps->dev, "PPS event at %lu\n", jiffies);
 
-	pps_event(pps, &ts, PPS_CAPTUREASSERT, NULL);
+	pps_event_irq(pps, &ts, PPS_CAPTUREASSERT, NULL);
 
 	mod_timer(&ktimer, jiffies + HZ);
 }
diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
index 30789fa..7006f85 100644
--- a/drivers/pps/clients/pps-ldisc.c
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -50,7 +50,7 @@ static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
 	/* Now do the PPS event report */
 	pps = (struct pps_device *)tty->disc_data;
 	if (pps != NULL) {
-		pps_event(pps, ts, status ? PPS_CAPTUREASSERT :
+		pps_event_irq(pps, ts, status ? PPS_CAPTUREASSERT :
 				PPS_CAPTURECLEAR, NULL);
 		spin_unlock_irqrestore(&pps_ldisc_lock, flags);
 		dev_dbg(pps->dev, "PPS %s at %lu\n",
diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index f5b2b78..ca3b4f8 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -32,9 +32,19 @@
 #include <linux/slab.h>
 
 /*
+ * Global variables
+ */
+
+/* PPS event workqueue */
+struct workqueue_struct *pps_event_workqueue;
+
+/*
  * Local functions
  */
 
+static void assert_work_func(struct work_struct *work);
+static void clear_work_func(struct work_struct *work);
+
 static void pps_add_offset(struct pps_ktime *ts, struct pps_ktime *offset)
 {
 	ts->nsec += offset->nsec;
@@ -108,6 +118,9 @@ struct pps_device *pps_register_source(struct pps_source_info *info,
 	init_waitqueue_head(&pps->queue);
 	spin_lock_init(&pps->lock);
 
+	INIT_WORK(&pps->assert_work, assert_work_func);
+	INIT_WORK(&pps->clear_work, clear_work_func);
+
 	/* Create the char device */
 	err = pps_register_cdev(pps);
 	if (err < 0) {
@@ -152,11 +165,12 @@ EXPORT_SYMBOL(pps_unregister_source);
  * @event: the event type
  * @data: userdef pointer
  *
- * This function is used by each PPS client in order to register a new
- * PPS event into the system (it's usually called inside an IRQ handler).
+ * This function is used by PPS clients in order to register a new
+ * PPS event into the system. It should not be called from an IRQ
+ * handler. Use pps_event_irq instead.
  *
- * If an echo function is associated with the PPS device it will be called
- * as:
+ * If an echo function is associated with the PPS device it will be
+ * called as:
  *	pps->info.echo(pps, event, data);
  */
 void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
@@ -226,3 +240,76 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 	spin_unlock_irqrestore(&pps->lock, flags);
 }
 EXPORT_SYMBOL(pps_event);
+
+/* Async event handlers */
+
+static void assert_work_func(struct work_struct *work)
+{
+	struct pps_device *pps = container_of(work,
+			struct pps_device, assert_work);
+
+	pps_event(pps, &pps->assert_work_ts, PPS_CAPTUREASSERT,
+			pps->assert_work_data);
+}
+
+static void clear_work_func(struct work_struct *work)
+{
+	struct pps_device *pps = container_of(work,
+			struct pps_device, clear_work);
+
+	pps_event(pps, &pps->clear_work_ts, PPS_CAPTURECLEAR,
+			pps->clear_work_data);
+}
+
+/* pps_event_irq - register a PPS event for deffered handling using
+ * workqueue
+ *
+ * @pps: the PPS device
+ * @ts: the event timestamp
+ * @event: the event type
+ * @data: userdef pointer
+ *
+ * This function is used by PPS clients in order to register a new
+ * PPS event into the system. It should be called from an IRQ handler
+ * only.
+ *
+ * If an echo function is associated with the PPS device it will be
+ * called as:
+ *	pps->info.echo(pps, event, data);
+ */
+void pps_event_irq(struct pps_device *pps, struct pps_event_time *ts,
+		int event, void *data)
+{
+	/* check event type */
+	BUG_ON((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0);
+
+	if (event & PPS_CAPTUREASSERT) {
+		if (work_pending(&pps->assert_work)) {
+			dev_err(pps->dev, "deferred assert edge work haven't"
+					" been handled within a second\n");
+			/* FIXME: do something more intelligent
+			 * then just exit */
+		} else {
+			/* now we can copy data safely */
+			pps->assert_work_ts = *ts;
+			pps->assert_work_data = data;
+
+			queue_work(pps_event_workqueue, &pps->assert_work);
+		}
+	}
+	if (event & PPS_CAPTURECLEAR) {
+		if (work_pending(&pps->clear_work)) {
+			dev_err(pps->dev, "deferred clear edge work haven't"
+					" been handled within a second\n");
+			/* FIXME: do something more intelligent
+			 * then just exit */
+		} else {
+			/* now we can copy data safely */
+			pps->clear_work_ts = *ts;
+			pps->clear_work_data = data;
+
+			queue_work(pps_event_workqueue, &pps->clear_work);
+		}
+	}
+}
+EXPORT_SYMBOL(pps_event_irq);
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 79b4455..f642558 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -321,18 +321,26 @@ void pps_unregister_cdev(struct pps_device *pps)
 
 static void __exit pps_exit(void)
 {
-	class_destroy(pps_class);
 	unregister_chrdev_region(pps_devt, PPS_MAX_SOURCES);
+	class_destroy(pps_class);
+	destroy_workqueue(pps_event_workqueue);
 }
 
 static int __init pps_init(void)
 {
 	int err;
 
+	pps_event_workqueue = create_workqueue("pps");
+	if (!pps_event_workqueue) {
+		pr_err("failed to create workqueue\n");
+		return -ENOMEM;
+	}
+
 	pps_class = class_create(THIS_MODULE, "pps");
 	if (!pps_class) {
 		pr_err("failed to allocate class\n");
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto destroy_workqueue;
 	}
 	pps_class->dev_attrs = pps_attrs;
 
@@ -350,6 +358,8 @@ static int __init pps_init(void)
 
 remove_class:
 	class_destroy(pps_class);
+destroy_workqueue:
+	destroy_workqueue(pps_event_workqueue);
 
 	return err;
 }
diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
index 1aedf50..5af0498 100644
--- a/include/linux/pps_kernel.h
+++ b/include/linux/pps_kernel.h
@@ -26,6 +26,7 @@
 #include <linux/cdev.h>
 #include <linux/device.h>
 #include <linux/time.h>
+#include <linux/workqueue.h>
 
 /*
  * Global defines
@@ -70,6 +71,13 @@ struct pps_device {
 	struct device *dev;
 	struct fasync_struct *async_queue;	/* fasync method */
 	spinlock_t lock;
+
+	struct work_struct assert_work;
+	struct work_struct clear_work;
+	struct pps_event_time assert_work_ts;
+	struct pps_event_time clear_work_ts;
+	void *assert_work_data;
+	void *clear_work_data;
 };
 
 /*
@@ -78,6 +86,8 @@ struct pps_device {
 
 extern struct device_attribute pps_attrs[];
 
+extern struct workqueue_struct *pps_event_workqueue;
+
 /*
  * Exported functions
  */
@@ -89,6 +99,8 @@ extern int pps_register_cdev(struct pps_device *pps);
 extern void pps_unregister_cdev(struct pps_device *pps);
 extern void pps_event(struct pps_device *pps,
 		struct pps_event_time *ts, int event, void *data);
+extern void pps_event_irq(struct pps_device *pps,
+		struct pps_event_time *ts, int event, void *data);
 
 static inline void timespec_to_pps_ktime(struct pps_ktime *kt,
 		struct timespec ts)
-- 
1.7.2.3

