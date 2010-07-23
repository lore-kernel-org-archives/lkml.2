Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab0GWKI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 06:08:27 -0400
Received: from ist.d-labs.de ([213.239.218.44]:39885 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab0GWKIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 06:08:25 -0400
From: florian@mickler.org
To: pm list <linux-pm@lists.linux-foundation.org>
Cc: Florian Mickler <florian@mickler.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>,
        linux-kernel@vger.kernel.org, mark gross <markgross@thegnar.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 2/2] [RFC] pm_qos: add atomic notifier chain
Date: Fri, 23 Jul 2010 12:06:59 +0200
Message-Id: <1279879619-19996-2-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279879619-19996-1-git-send-email-florian@mickler.org>
References: <1279879619-19996-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows for atomic notifications.

This is unecessary at the moment, but I had it flying around and it may be
necessary to have in some future scenarios.

The atomic listeners get called for _every_ change
of the target value, whereas the blocking notifiers, when called from
interrupt context, may be "folded" to notify just once.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 include/linux/pm_qos_params.h |    2 +
 kernel/pm_qos_params.c        |   61 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/include/linux/pm_qos_params.h b/include/linux/pm_qos_params.h
index fdd8a78..4c0d209 100644
--- a/include/linux/pm_qos_params.h
+++ b/include/linux/pm_qos_params.h
@@ -30,6 +30,8 @@ void pm_qos_remove_request(struct pm_qos_request_list *pm_qos_req);
 
 int pm_qos_request(int pm_qos_class);
 int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier);
+int pm_qos_add_atomic_notifier(int pm_qos_class,
+		struct notifier_block *notifier);
 int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier);
 int pm_qos_request_active(struct pm_qos_request_list *req);
 
diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index 640c367..fbd0a6d 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -57,6 +57,7 @@ enum pm_qos_type {
 struct pm_qos_object {
 	struct plist_head requests;
 	struct blocking_notifier_head notifiers;
+	struct atomic_notifier_head atomic_notifiers;
 	struct miscdevice pm_qos_power_miscdev;
 	struct work_struct notify;
 	char *name;
@@ -73,9 +74,14 @@ static struct pm_qos_object pm_qos_objects[] = {
 	{
 		.requests = PLIST_HEAD_INIT(
 			pm_qos_objects[PM_QOS_CPU_DMA_LATENCY].requests,
-			pm_qos_lock),
+			pm_qos_lock
+			),
 		.notifiers = BLOCKING_NOTIFIER_INIT(
-			pm_qos_objects[PM_QOS_CPU_DMA_LATENCY].notifiers),
+			pm_qos_objects[PM_QOS_CPU_DMA_LATENCY].notifiers
+			),
+		.atomic_notifiers = ATOMIC_NOTIFIER_INIT(
+			pm_qos_objects[PM_QOS_CPU_DMA_LATENCY].atomic_notifiers
+			),
 		.notify = __WORK_INITIALIZER(
 			pm_qos_objects[PM_QOS_CPU_DMA_LATENCY].notify,
 			update_notify),
@@ -91,6 +97,9 @@ static struct pm_qos_object pm_qos_objects[] = {
 		.notifiers = BLOCKING_NOTIFIER_INIT(
 			pm_qos_objects[PM_QOS_NETWORK_LATENCY].notifiers
 			),
+		.atomic_notifiers = ATOMIC_NOTIFIER_INIT(
+			pm_qos_objects[PM_QOS_NETWORK_LATENCY].atomic_notifiers
+			),
 		.notify = __WORK_INITIALIZER(
 			pm_qos_objects[PM_QOS_NETWORK_LATENCY].notify,
 			update_notify
@@ -107,6 +116,9 @@ static struct pm_qos_object pm_qos_objects[] = {
 		.notifiers = BLOCKING_NOTIFIER_INIT(
 			pm_qos_objects[PM_QOS_NETWORK_THROUGHPUT].notifiers
 			),
+		.atomic_notifiers = ATOMIC_NOTIFIER_INIT(
+			pm_qos_objects[PM_QOS_NETWORK_THROUGHPUT].atomic_notifiers
+			),
 		.notify = __WORK_INITIALIZER(
 			pm_qos_objects[PM_QOS_NETWORK_THROUGHPUT].notify,
 			update_notify
@@ -147,14 +159,15 @@ static inline int pm_qos_get_value(struct pm_qos_object *o)
 	}
 }
 
-static void call_notifiers(struct pm_qos_object *o, unsigned long val)
+static void call_notifiers(struct pm_qos_object *o, unsigned long curr_value)
 {
 
+	atomic_notifier_call_chain(&o->atomic_notifiers, curr_value, NULL);
+
 	if (in_interrupt())
 		schedule_work(&o->notify);
 	else
-		blocking_notifier_call_chain(&o->notifiers, val,
-				NULL);
+		blocking_notifier_call_chain(&o->notifiers, curr_value, NULL);
 
 
 }
@@ -361,13 +374,14 @@ EXPORT_SYMBOL_GPL(pm_qos_remove_request);
 
 /**
  * pm_qos_add_notifier - sets notification entry for changes to target value
- * @pm_qos_class: identifies which qos target changes should be notified.
+ * @pm_qos_class: identifies which qos target changes should trigger
+ *     notifications.
  * @notifier: notifier block managed by caller.
  *
  * Will register the notifier into a notification chain that gets called
  * upon changes to the pm_qos_class target value.
  */
-int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
+int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *nb)
 {
 	int retval;
 	if (!pm_qos_valid_class(pm_qos_class)) {
@@ -375,13 +389,37 @@ int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
 		return -EINVAL;
 	}
 	retval = blocking_notifier_chain_register(
-			&pm_qos_objects[pm_qos_class].notifiers, notifier);
+			&pm_qos_objects[pm_qos_class].notifiers, nb);
 
 	return retval;
 }
 EXPORT_SYMBOL_GPL(pm_qos_add_notifier);
 
 /**
+ * pm_qos_add_atomic_notifier - sets notification entry for changes to target value
+ * @pm_qos_class: identifies which qos target changes should trigger
+ *	notifications.
+ * @notifier: notifier block managed by caller.
+ *
+ * Will register the notifier into a notification chain that gets
+ * called upon changes to the pm_qos_class target value.  The notifier
+ * may be called from atomic context.  use @pm_qos_remove_notifier to
+ * unregister.
+ */
+int pm_qos_add_atomic_notifier(int pm_qos_class, struct notifier_block *nb)
+{
+	int ret = 0;
+	if (!pm_qos_valid_class(pm_qos_class)) {
+		WARN(1, KERN_ERR "pm_qos_add_atmoic_notifier called for unknown qos class\n");
+		ret = -EINVAL;
+	} else
+		ret = atomic_notifier_chain_register(
+			&pm_qos_objects[pm_qos_class].atomic_notifiers, nb);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pm_qos_add_atomic_notifier);
+
+/**
  * pm_qos_remove_notifier - deletes notification entry from chain.
  * @pm_qos_class: identifies which qos target changes are notified.
  * @notifier: notifier block to be removed.
@@ -389,7 +427,7 @@ EXPORT_SYMBOL_GPL(pm_qos_add_notifier);
  * Will remove the notifier from the notification chain that gets called
  * upon changes to the pm_qos_class target value.
  */
-int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier)
+int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *nb)
 {
 	int retval;
 	if (!pm_qos_valid_class(pm_qos_class)) {
@@ -398,7 +436,10 @@ int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier)
 	}
 
 	retval = blocking_notifier_chain_unregister(
-			&pm_qos_objects[pm_qos_class].notifiers, notifier);
+			&pm_qos_objects[pm_qos_class].notifiers, nb);
+	if (retval)
+		retval = atomic_notifier_chain_unregister(
+			&pm_qos_objects[pm_qos_class].atomic_notifiers, nb);
 
 	return retval;
 }
-- 
1.7.1.1

