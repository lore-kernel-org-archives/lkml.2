Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab0GWKIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 06:08:22 -0400
Received: from ist.d-labs.de ([213.239.218.44]:39877 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab0GWKIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 06:08:20 -0400
From: florian@mickler.org
To: pm list <linux-pm@lists.linux-foundation.org>
Cc: Florian Mickler <florian@mickler.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>,
        linux-kernel@vger.kernel.org, mark gross <markgross@thegnar.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 1/2] pm_qos: make update_request callable from interrupt context
Date: Fri, 23 Jul 2010 12:06:58 +0200
Message-Id: <1279879619-19996-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow drivers to use pm_qos_update_request from interrupt
context we check for interrupt context via in_interrupt() and call
the notifiers via schedule_work() if need be.

There is the following semantic difference between update_request call
sites that are in interrupt context and process context:
If the notification-work is already scheduled then schedule_work might be a
noop. In order to avoid buffering of all intermediary constraint-values we
query the current value at notification time. This means that for constraints
updated from interrupt-context the listeners might only see the last value.

This also adds some WARN's to check for invalid class-descriptors as
input params of exported functions and substitutes the pointer-array
pm_qos_array with an array of structs (pm_qos_objects).
The latter is needed to get at the array-index of a pm_qos_object-pointer.

Also adding new qos-classes should be easier now, as one needs to only
extend the pm_qos_classes enum in the header and initialize the pm_qos_object
in the implementation file.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 include/linux/pm_qos_params.h |   12 ++-
 kernel/pm_qos_params.c        |  202 ++++++++++++++++++++++++++---------------
 2 files changed, 135 insertions(+), 79 deletions(-)

diff --git a/include/linux/pm_qos_params.h b/include/linux/pm_qos_params.h
index 77cbddb..fdd8a78 100644
--- a/include/linux/pm_qos_params.h
+++ b/include/linux/pm_qos_params.h
@@ -8,12 +8,14 @@
 #include <linux/notifier.h>
 #include <linux/miscdevice.h>
 
-#define PM_QOS_RESERVED 0
-#define PM_QOS_CPU_DMA_LATENCY 1
-#define PM_QOS_NETWORK_LATENCY 2
-#define PM_QOS_NETWORK_THROUGHPUT 3
+enum pm_qos_classes {
+	PM_QOS_RESERVED = 0,
+	PM_QOS_CPU_DMA_LATENCY,
+	PM_QOS_NETWORK_LATENCY,
+	PM_QOS_NETWORK_THROUGHPUT,
+	PM_QOS_NUM_CLASSES
+};
 
-#define PM_QOS_NUM_CLASSES 4
 #define PM_QOS_DEFAULT_VALUE -1
 
 struct pm_qos_request_list {
diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index 996a4de..640c367 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -29,19 +29,20 @@
 
 /*#define DEBUG*/
 
+#include <linux/platform_device.h>
 #include <linux/pm_qos_params.h>
-#include <linux/sched.h>
+#include <linux/miscdevice.h>
+#include <linux/workqueue.h>
 #include <linux/spinlock.h>
-#include <linux/slab.h>
-#include <linux/time.h>
-#include <linux/fs.h>
+#include <linux/hardirq.h>
+#include <linux/uaccess.h>
 #include <linux/device.h>
-#include <linux/miscdevice.h>
 #include <linux/string.h>
-#include <linux/platform_device.h>
+#include <linux/sched.h>
 #include <linux/init.h>
-
-#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/time.h>
+#include <linux/fs.h>
 
 /*
  * locking rule: all changes to requests or notifiers lists
@@ -55,50 +56,65 @@ enum pm_qos_type {
 
 struct pm_qos_object {
 	struct plist_head requests;
-	struct blocking_notifier_head *notifiers;
+	struct blocking_notifier_head notifiers;
 	struct miscdevice pm_qos_power_miscdev;
+	struct work_struct notify;
 	char *name;
 	s32 default_value;
 	enum pm_qos_type type;
 };
 
 static DEFINE_SPINLOCK(pm_qos_lock);
-
-static struct pm_qos_object null_pm_qos;
-static BLOCKING_NOTIFIER_HEAD(cpu_dma_lat_notifier);
-static struct pm_qos_object cpu_dma_pm_qos = {
-	.requests = PLIST_HEAD_INIT(cpu_dma_pm_qos.requests, pm_qos_lock),
-	.notifiers = &cpu_dma_lat_notifier,
-	.name = "cpu_dma_latency",
-	.default_value = 2000 * USEC_PER_SEC,
-	.type = PM_QOS_MIN,
-};
-
-static BLOCKING_NOTIFIER_HEAD(network_lat_notifier);
-static struct pm_qos_object network_lat_pm_qos = {
-	.requests = PLIST_HEAD_INIT(network_lat_pm_qos.requests, pm_qos_lock),
-	.notifiers = &network_lat_notifier,
-	.name = "network_latency",
-	.default_value = 2000 * USEC_PER_SEC,
-	.type = PM_QOS_MIN
-};
-
-
-static BLOCKING_NOTIFIER_HEAD(network_throughput_notifier);
-static struct pm_qos_object network_throughput_pm_qos = {
-	.requests = PLIST_HEAD_INIT(network_throughput_pm_qos.requests, pm_qos_lock),
-	.notifiers = &network_throughput_notifier,
-	.name = "network_throughput",
-	.default_value = 0,
-	.type = PM_QOS_MAX,
-};
-
-
-static struct pm_qos_object *pm_qos_array[] = {
-	&null_pm_qos,
-	&cpu_dma_pm_qos,
-	&network_lat_pm_qos,
-	&network_throughput_pm_qos
+static void update_notify(struct work_struct *work);
+
+/* see pm_qos_classes enum in the header */
+static struct pm_qos_object pm_qos_objects[] = {
+	{}, /* PM_QOS_RESERVED */
+	{
+		.requests = PLIST_HEAD_INIT(
+			pm_qos_objects[PM_QOS_CPU_DMA_LATENCY].requests,
+			pm_qos_lock),
+		.notifiers = BLOCKING_NOTIFIER_INIT(
+			pm_qos_objects[PM_QOS_CPU_DMA_LATENCY].notifiers),
+		.notify = __WORK_INITIALIZER(
+			pm_qos_objects[PM_QOS_CPU_DMA_LATENCY].notify,
+			update_notify),
+		.name = "cpu_dma_latency",
+		.default_value = 2000 * USEC_PER_SEC,
+		.type = PM_QOS_MIN,
+	}, /* PM_QOS_CPU_DMA_LATENCY */
+	{
+		.requests = PLIST_HEAD_INIT(
+			pm_qos_objects[PM_QOS_NETWORK_LATENCY].requests,
+			pm_qos_lock
+			),
+		.notifiers = BLOCKING_NOTIFIER_INIT(
+			pm_qos_objects[PM_QOS_NETWORK_LATENCY].notifiers
+			),
+		.notify = __WORK_INITIALIZER(
+			pm_qos_objects[PM_QOS_NETWORK_LATENCY].notify,
+			update_notify
+			),
+		.name = "network_latency",
+		.default_value = 2000 * USEC_PER_SEC,
+		.type = PM_QOS_MIN
+	}, /* PM_QOS_NETWORK_LATENCY */
+	{
+		.requests = PLIST_HEAD_INIT(
+			pm_qos_objects[PM_QOS_NETWORK_THROUGHPUT].requests,
+			pm_qos_lock
+			),
+		.notifiers = BLOCKING_NOTIFIER_INIT(
+			pm_qos_objects[PM_QOS_NETWORK_THROUGHPUT].notifiers
+			),
+		.notify = __WORK_INITIALIZER(
+			pm_qos_objects[PM_QOS_NETWORK_THROUGHPUT].notify,
+			update_notify
+			),
+		.name = "network_throughput",
+		.default_value = 0,
+		.type = PM_QOS_MAX,
+	}, /* PM_QOS_NETWORK_THROUGHPUT */
 };
 
 static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
@@ -131,6 +147,30 @@ static inline int pm_qos_get_value(struct pm_qos_object *o)
 	}
 }
 
+static void call_notifiers(struct pm_qos_object *o, unsigned long val)
+{
+
+	if (in_interrupt())
+		schedule_work(&o->notify);
+	else
+		blocking_notifier_call_chain(&o->notifiers, val,
+				NULL);
+
+
+}
+
+/* This is the work function that gets scheduled
+ * in call_notifiers if necessary. */
+static void update_notify(struct work_struct *work)
+{
+	struct pm_qos_object *obj =
+		container_of(work, struct pm_qos_object, notify);
+
+	int extreme_value = pm_qos_request(obj - pm_qos_objects);
+	blocking_notifier_call_chain(&obj->notifiers,
+			(unsigned long) extreme_value, NULL);
+}
+
 static void update_target(struct pm_qos_object *o, struct plist_node *node,
 			  int del, int value)
 {
@@ -158,9 +198,7 @@ static void update_target(struct pm_qos_object *o, struct plist_node *node,
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	if (prev_value != curr_value)
-		blocking_notifier_call_chain(o->notifiers,
-					     (unsigned long)curr_value,
-					     NULL);
+		call_notifiers(o, (unsigned long) curr_value);
 }
 
 static int register_pm_qos_misc(struct pm_qos_object *qos)
@@ -179,12 +217,17 @@ static int find_pm_qos_object_by_minor(int minor)
 	for (pm_qos_class = 0;
 		pm_qos_class < PM_QOS_NUM_CLASSES; pm_qos_class++) {
 		if (minor ==
-			pm_qos_array[pm_qos_class]->pm_qos_power_miscdev.minor)
+			pm_qos_objects[pm_qos_class].pm_qos_power_miscdev.minor)
 			return pm_qos_class;
 	}
 	return -1;
 }
 
+int pm_qos_valid_class(int pm_qos_class)
+{
+	return pm_qos_class > 0 && pm_qos_class < PM_QOS_NUM_CLASSES;
+}
+
 /**
  * pm_qos_request - returns current system wide qos expectation
  * @pm_qos_class: identification of which qos value is requested
@@ -196,8 +239,13 @@ int pm_qos_request(int pm_qos_class)
 	unsigned long flags;
 	int value;
 
+	if (!pm_qos_valid_class(pm_qos_class)) {
+		WARN(1, KERN_ERR "pm_qos_request() called for unknown qos class\n");
+		return -EINVAL;
+	}
+
 	spin_lock_irqsave(&pm_qos_lock, flags);
-	value = pm_qos_get_value(pm_qos_array[pm_qos_class]);
+	value = pm_qos_get_value(&pm_qos_objects[pm_qos_class]);
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	return value;
@@ -206,7 +254,7 @@ EXPORT_SYMBOL_GPL(pm_qos_request);
 
 int pm_qos_request_active(struct pm_qos_request_list *req)
 {
-	return req->pm_qos_class != 0;
+	return  req && pm_qos_valid_class(req->pm_qos_class);
 }
 EXPORT_SYMBOL_GPL(pm_qos_request_active);
 
@@ -224,9 +272,16 @@ EXPORT_SYMBOL_GPL(pm_qos_request_active);
 void pm_qos_add_request(struct pm_qos_request_list *dep,
 			int pm_qos_class, s32 value)
 {
-	struct pm_qos_object *o =  pm_qos_array[pm_qos_class];
+	struct pm_qos_object *o;
 	int new_value;
 
+	if (!pm_qos_valid_class(pm_qos_class)) {
+		WARN(1, KERN_ERR "pm_qos_add_request() called for unknown qos class\n");
+		return;
+	}
+
+	o =  &pm_qos_objects[pm_qos_class];
+
 	if (pm_qos_request_active(dep)) {
 		WARN(1, KERN_ERR "pm_qos_add_request() called for already added request\n");
 		return;
@@ -261,11 +316,11 @@ void pm_qos_update_request(struct pm_qos_request_list *pm_qos_req,
 		return;
 
 	if (!pm_qos_request_active(pm_qos_req)) {
-		WARN(1, KERN_ERR "pm_qos_update_request() called for unknown object\n");
+		WARN(1, KERN_ERR "pm_qos_update_request() called for unknown request object\n");
 		return;
 	}
 
-	o = pm_qos_array[pm_qos_req->pm_qos_class];
+	o = &pm_qos_objects[pm_qos_req->pm_qos_class];
 
 	if (new_value == PM_QOS_DEFAULT_VALUE)
 		temp = o->default_value;
@@ -298,7 +353,7 @@ void pm_qos_remove_request(struct pm_qos_request_list *pm_qos_req)
 		return;
 	}
 
-	o = pm_qos_array[pm_qos_req->pm_qos_class];
+	o = &pm_qos_objects[pm_qos_req->pm_qos_class];
 	update_target(o, &pm_qos_req->list, 1, PM_QOS_DEFAULT_VALUE);
 	memset(pm_qos_req, 0, sizeof(*pm_qos_req));
 }
@@ -309,15 +364,18 @@ EXPORT_SYMBOL_GPL(pm_qos_remove_request);
  * @pm_qos_class: identifies which qos target changes should be notified.
  * @notifier: notifier block managed by caller.
  *
- * will register the notifier into a notification chain that gets called
+ * Will register the notifier into a notification chain that gets called
  * upon changes to the pm_qos_class target value.
  */
 int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
 {
 	int retval;
-
+	if (!pm_qos_valid_class(pm_qos_class)) {
+		WARN(1, KERN_ERR "pm_qos_add_notifier called for unknown qos class\n");
+		return -EINVAL;
+	}
 	retval = blocking_notifier_chain_register(
-			pm_qos_array[pm_qos_class]->notifiers, notifier);
+			&pm_qos_objects[pm_qos_class].notifiers, notifier);
 
 	return retval;
 }
@@ -328,15 +386,19 @@ EXPORT_SYMBOL_GPL(pm_qos_add_notifier);
  * @pm_qos_class: identifies which qos target changes are notified.
  * @notifier: notifier block to be removed.
  *
- * will remove the notifier from the notification chain that gets called
+ * Will remove the notifier from the notification chain that gets called
  * upon changes to the pm_qos_class target value.
  */
 int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier)
 {
 	int retval;
+	if (!pm_qos_valid_class(pm_qos_class)) {
+		WARN(1, KERN_ERR "pm_qos_remove_notifier called for unknown qos class\n");
+		return -EINVAL;
+	}
 
 	retval = blocking_notifier_chain_unregister(
-			pm_qos_array[pm_qos_class]->notifiers, notifier);
+			&pm_qos_objects[pm_qos_class].notifiers, notifier);
 
 	return retval;
 }
@@ -404,21 +466,13 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
 static int __init pm_qos_power_init(void)
 {
 	int ret = 0;
+	int qos_class;
 
-	ret = register_pm_qos_misc(&cpu_dma_pm_qos);
-	if (ret < 0) {
-		printk(KERN_ERR "pm_qos_param: cpu_dma_latency setup failed\n");
-		return ret;
-	}
-	ret = register_pm_qos_misc(&network_lat_pm_qos);
-	if (ret < 0) {
-		printk(KERN_ERR "pm_qos_param: network_latency setup failed\n");
-		return ret;
-	}
-	ret = register_pm_qos_misc(&network_throughput_pm_qos);
-	if (ret < 0)
-		printk(KERN_ERR
-			"pm_qos_param: network_throughput setup failed\n");
+	for (qos_class = 1; qos_class < PM_QOS_NUM_CLASSES; qos_class++)
+		if (register_pm_qos_misc(&pm_qos_objects[qos_class])) {
+			printk(KERN_ERR "pm_qos_param: setup failed for %s\n", pm_qos_objects[qos_class].name);
+			ret |= 1;
+		}
 
 	return ret;
 }
-- 
1.7.1.1

