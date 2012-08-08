Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab2HHXJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:09:34 -0400
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:43939 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758678Ab2HHXID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:08:03 -0400
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <ohad@wizery.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Cc: Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCH 1/3] remoteproc: add rproc_report_crash function to notify rproc crashes
Date: Wed,  8 Aug 2012 18:07:42 -0500
Message-Id: <1344467264-5128-2-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1344467264-5128-1-git-send-email-fernando.lugo@ti.com>
References: <1344467264-5128-1-git-send-email-fernando.lugo@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is exporting the rproc_report_crash function which can be used
to report a rproc crash to the remoteproc core. This function is specially
thought to be called by low-level remoteproc driver code in case of
detecting a crash (remoteproc is not functional anymore). Using this
function from another driver (non rproc driver) should be analyzed very
carefully most of the time that will be considered wrong.

rproc_report_crash function can be called from any context, that means,
it can be called from atomic context without any problem. The reporter
function is creating a new thread (workqueue work) in charge of handling
the crash (if possible).

Creating this new thread is done for two main reasons. First reason is
to be able to call it from atomic context, due to the fact that many
crashes trigger an interrupt, so this function can be called directly
from ISR context. Second reason is avoid any deadlock condition which
could happen if the rproc_report_crash function is called from a
function which is indirectly holding a rproc lock.

The reporter function is scheduling the crash handler task. This task
is thought to have some features like:

-remoteproc register dump
-remoteproc stack dump
-remoteproc core dump
-Saving of the remoteproc traces in order to be visible after the crash
-Reseting the remoteproc in order to make it functional again (hard recovery)

Right now, it is only printing the crash type which was detected. The
types of crashes are represented by an enum. I have only added mmufault
crash type. Remoteproc low-level drivers can add more types when needed.

Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
---
 Documentation/remoteproc.txt         |    7 +++
 drivers/remoteproc/remoteproc_core.c |   80 +++++++++++++++++++++++++++++++---
 include/linux/remoteproc.h           |   18 ++++++++
 3 files changed, 98 insertions(+), 7 deletions(-)

diff --git a/Documentation/remoteproc.txt b/Documentation/remoteproc.txt
index 23a09b8..e6469fd 100644
--- a/Documentation/remoteproc.txt
+++ b/Documentation/remoteproc.txt
@@ -129,6 +129,13 @@ int dummy_rproc_example(struct rproc *my_rproc)
 
       Returns 0 on success and -EINVAL if @rproc isn't valid.
 
+  void rproc_report_crash(struct rproc *rproc, enum rproc_crash_type type)
+    - Report a crash in a remoteproc
+      This function must be called every time a crash is detected by the
+      platform specific rproc implementation. This should not be called from a
+      non-remoteproc driver. This function can be called from atomic/interrupt
+      context.
+
 5. Implementation callbacks
 
 These callbacks should be provided by platform-specific remoteproc
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index d5c2dbf..3a6f1a1 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -50,6 +50,18 @@ typedef int (*rproc_handle_resource_t)(struct rproc *rproc, void *, int avail);
 /* Unique indices for remoteproc devices */
 static DEFINE_IDA(rproc_dev_index);
 
+static const char * const rproc_crash_names[] = {
+	[RPROC_MMUFAULT]	= "mmufault",
+};
+
+/* translate rproc_crash_type to string */
+static const char *rproc_crash_to_string(enum rproc_crash_type type)
+{
+	if (type < ARRAY_SIZE(rproc_crash_names))
+		return rproc_crash_names[type];
+	return "unkown";
+}
+
 /*
  * This is the IOMMU fault handler we register with the IOMMU API
  * (when relevant; not all remote processors access memory through
@@ -57,19 +69,17 @@ static DEFINE_IDA(rproc_dev_index);
  *
  * IOMMU core will invoke this handler whenever the remote processor
  * will try to access an unmapped device address.
- *
- * Currently this is mostly a stub, but it will be later used to trigger
- * the recovery of the remote processor.
  */
 static int rproc_iommu_fault(struct iommu_domain *domain, struct device *dev,
 		unsigned long iova, int flags, void *token)
 {
+	struct rproc *rproc = token;
+
 	dev_err(dev, "iommu fault: da 0x%lx flags 0x%x\n", iova, flags);
 
-	/*
-	 * Let the iommu core know we're not really handling this fault;
-	 * we just plan to use this as a recovery trigger.
-	 */
+	rproc_report_crash(rproc, RPROC_MMUFAULT);
+
+	/* Let the iommu core know we're not really handling this fault; */
 	return -ENOSYS;
 }
 
@@ -872,6 +882,34 @@ out:
 }
 
 /**
+ * rproc_crash_handler_work() - handle a crash
+ *
+ * This function needs to handle everything related to a crash, like cpu
+ * registers and stack dump, information to help to debug the fatal error, etc.
+ */
+static void rproc_crash_handler_work(struct work_struct *work)
+{
+	struct rproc *rproc = container_of(work, struct rproc, crash_handler);
+	struct device *dev = &rproc->dev;
+
+	dev_dbg(dev, "enter %s\n", __func__);
+
+	mutex_lock(&rproc->lock);
+	if (rproc->state == RPROC_CRASHED || rproc->state == RPROC_OFFLINE) {
+		/* handle only the first crash detected */
+		mutex_unlock(&rproc->lock);
+		return;
+	}
+
+	rproc->state = RPROC_CRASHED;
+	dev_err(&rproc->dev, "handling crash #%u in %s\n",
+		++rproc->crash_cnt, rproc->name);
+	mutex_unlock(&rproc->lock);
+
+	/* TODO: handle crash */
+}
+
+/**
  * rproc_boot() - boot a remote processor
  * @rproc: handle of a remote processor
  *
@@ -1165,6 +1203,8 @@ struct rproc *rproc_alloc(struct device *dev, const char *name,
 	INIT_LIST_HEAD(&rproc->traces);
 	INIT_LIST_HEAD(&rproc->rvdevs);
 
+	INIT_WORK(&rproc->crash_handler, rproc_crash_handler_work);
+
 	rproc->state = RPROC_OFFLINE;
 
 	return rproc;
@@ -1221,6 +1261,32 @@ int rproc_del(struct rproc *rproc)
 }
 EXPORT_SYMBOL(rproc_del);
 
+/**
+ * rproc_report_crash() - rproc crash reporter function
+ * @rproc: remote processor
+ * @type: crash type
+ *
+ * This function must be called every time a crash is detected by the low-level
+ * drivers implementing a specific remoteproc. This should not be called from a
+ * non-remoteproc driver.
+ *
+ * This function can be called from atomic/interrupt context.
+ */
+void rproc_report_crash(struct rproc *rproc, enum rproc_crash_type type)
+{
+	if (!rproc) {
+		pr_err("NULL rproc pointer\n");
+		return;
+	}
+
+	dev_err(&rproc->dev, "crash detected in %s: type %s\n",
+		rproc->name, rproc_crash_to_string(type));
+
+	/* create a new task to handle the error */
+	schedule_work(&rproc->crash_handler);
+}
+EXPORT_SYMBOL(rproc_report_crash);
+
 static int __init remoteproc_init(void)
 {
 	rproc_init_debugfs();
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 131b539..a46ed27 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -361,6 +361,19 @@ enum rproc_state {
 };
 
 /**
+ * enum rproc_crash_type - remote processor crash types
+ * @RPROC_MMUFAULT:	iommu fault
+ *
+ * Each element of the enum is used as an array index. So that, the value of
+ * the elements should be always something sane.
+ *
+ * Feel free to add more types when needed.
+ */
+enum rproc_crash_type {
+	RPROC_MMUFAULT,
+};
+
+/**
  * struct rproc - represents a physical remote processor device
  * @node: klist node of this rproc object
  * @domain: iommu domain
@@ -383,6 +396,8 @@ enum rproc_state {
  * @rvdevs: list of remote virtio devices
  * @notifyids: idr for dynamically assigning rproc-wide unique notify ids
  * @index: index of this rproc device
+ * @crash_handler: workqueue for handling a crash
+ * @crash_cnt: crash counter
  */
 struct rproc {
 	struct klist_node node;
@@ -406,6 +421,8 @@ struct rproc {
 	struct list_head rvdevs;
 	struct idr notifyids;
 	int index;
+	struct work_struct crash_handler;
+	unsigned crash_cnt;
 };
 
 /* we currently support only two vrings per rvdev */
@@ -460,6 +477,7 @@ int rproc_del(struct rproc *rproc);
 
 int rproc_boot(struct rproc *rproc);
 void rproc_shutdown(struct rproc *rproc);
+void rproc_report_crash(struct rproc *rproc, enum rproc_crash_type type);
 
 static inline struct rproc_vdev *vdev_to_rvdev(struct virtio_device *vdev)
 {
-- 
1.7.1

