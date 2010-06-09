Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab0FIJPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 05:15:51 -0400
Received: from ist.d-labs.de ([213.239.218.44]:49390 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755615Ab0FIJPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 05:15:50 -0400
From: florian@mickler.org
To: pm list <linux-pm@lists.linux-foundation.org>
Cc: james.bottomley@suse.de, markgross@thegnar.org, mgross@linux.intel.com,
       Florian Mickler <florian@mickler.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] pm_qos: make update_request callable from interrupt context
Date: Wed,  9 Jun 2010 11:15:14 +0200
Message-Id: <1276074915-26879-2-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276074915-26879-1-git-send-email-florian@mickler.org>
References: <1276074915-26879-1-git-send-email-florian@mickler.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pm_qos framework has to guarantee atomic notifications so that
drivers can request and release constraints at all times while no races
occur.

In order to avoid implementing a secondary notification chain in which
listeners might sleep, we demand that every listener implements it's
notification so that it can run in interrupt context. The listener is in
a better position to know if races are harmful or not.

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 kernel/pm_qos_params.c |   50 ++++++++++++++++++++++++------------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index f42d3f7..d918605 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -63,7 +63,7 @@ static s32 min_compare(s32 v1, s32 v2);
 
 struct pm_qos_object {
 	struct pm_qos_request_list requests;
-	struct blocking_notifier_head *notifiers;
+	struct atomic_notifier_head *notifiers;
 	struct miscdevice pm_qos_power_miscdev;
 	char *name;
 	s32 default_value;
@@ -72,7 +72,7 @@ struct pm_qos_object {
 };
 
 static struct pm_qos_object null_pm_qos;
-static BLOCKING_NOTIFIER_HEAD(cpu_dma_lat_notifier);
+static ATOMIC_NOTIFIER_HEAD(cpu_dma_lat_notifier);
 static struct pm_qos_object cpu_dma_pm_qos = {
 	.requests = {LIST_HEAD_INIT(cpu_dma_pm_qos.requests.list)},
 	.notifiers = &cpu_dma_lat_notifier,
@@ -82,7 +82,7 @@ static struct pm_qos_object cpu_dma_pm_qos = {
 	.comparitor = min_compare
 };
 
-static BLOCKING_NOTIFIER_HEAD(network_lat_notifier);
+static ATOMIC_NOTIFIER_HEAD(network_lat_notifier);
 static struct pm_qos_object network_lat_pm_qos = {
 	.requests = {LIST_HEAD_INIT(network_lat_pm_qos.requests.list)},
 	.notifiers = &network_lat_notifier,
@@ -93,7 +93,7 @@ static struct pm_qos_object network_lat_pm_qos = {
 };
 
 
-static BLOCKING_NOTIFIER_HEAD(network_throughput_notifier);
+static ATOMIC_NOTIFIER_HEAD(network_throughput_notifier);
 static struct pm_qos_object network_throughput_pm_qos = {
 	.requests = {LIST_HEAD_INIT(network_throughput_pm_qos.requests.list)},
 	.notifiers = &network_throughput_notifier,
@@ -103,7 +103,6 @@ static struct pm_qos_object network_throughput_pm_qos = {
 	.comparitor = max_compare
 };
 
-
 static struct pm_qos_object *pm_qos_array[] = {
 	&null_pm_qos,
 	&cpu_dma_pm_qos,
@@ -135,35 +134,30 @@ static s32 min_compare(s32 v1, s32 v2)
 	return min(v1, v2);
 }
 
-
 static void update_target(int pm_qos_class)
 {
 	s32 extreme_value;
+	struct pm_qos_object *obj = pm_qos_array[pm_qos_class];
 	struct pm_qos_request_list *node;
 	unsigned long flags;
 	int call_notifier = 0;
 
 	spin_lock_irqsave(&pm_qos_lock, flags);
-	extreme_value = pm_qos_array[pm_qos_class]->default_value;
-	list_for_each_entry(node,
-			&pm_qos_array[pm_qos_class]->requests.list, list) {
-		extreme_value = pm_qos_array[pm_qos_class]->comparitor(
-				extreme_value, node->value);
+	extreme_value = obj->default_value;
+	list_for_each_entry(node, &obj->requests.list, list) {
+		extreme_value = obj->comparitor(extreme_value, node->value);
 	}
-	if (atomic_read(&pm_qos_array[pm_qos_class]->target_value) !=
-			extreme_value) {
+	if (atomic_read(&obj->target_value) != extreme_value) {
 		call_notifier = 1;
-		atomic_set(&pm_qos_array[pm_qos_class]->target_value,
-				extreme_value);
+		atomic_set(&obj->target_value, extreme_value);
 		pr_debug(KERN_ERR "new target for qos %d is %d\n", pm_qos_class,
-			atomic_read(&pm_qos_array[pm_qos_class]->target_value));
+			atomic_read(&obj->target_value));
 	}
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	if (call_notifier)
-		blocking_notifier_call_chain(
-				pm_qos_array[pm_qos_class]->notifiers,
-					(unsigned long) extreme_value, NULL);
+		atomic_notifier_call_chain(obj->notifiers,
+				(unsigned long) extreme_value, NULL);
 }
 
 static int register_pm_qos_misc(struct pm_qos_object *qos)
@@ -272,6 +266,7 @@ EXPORT_SYMBOL_GPL(pm_qos_update_request);
 
 /**
  * pm_qos_remove_request - modifies an existing qos request
+ *
  * @pm_qos_req: handle to request list element
  *
  * Will remove pm qos request from the list of requests and
@@ -298,18 +293,21 @@ EXPORT_SYMBOL_GPL(pm_qos_remove_request);
 
 /**
  * pm_qos_add_notifier - sets notification entry for changes to target value
+ *
+ * Note: The notifier has to be callable from interrupt context.
+ *
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
 
-	retval = blocking_notifier_chain_register(
-			pm_qos_array[pm_qos_class]->notifiers, notifier);
+	retval = atomic_notifier_chain_register(
+		pm_qos_array[pm_qos_class]->notifiers, notifier);
 
 	return retval;
 }
@@ -317,18 +315,19 @@ EXPORT_SYMBOL_GPL(pm_qos_add_notifier);
 
 /**
  * pm_qos_remove_notifier - deletes notification entry from chain.
+ *
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
 
-	retval = blocking_notifier_chain_unregister(
-			pm_qos_array[pm_qos_class]->notifiers, notifier);
+	retval = atomic_notifier_chain_unregister(
+		pm_qos_array[pm_qos_class]->notifiers, notifier);
 
 	return retval;
 }
@@ -381,6 +380,7 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
 	} else
 		return -EINVAL;
 
+
 	pm_qos_req = (struct pm_qos_request_list *)filp->private_data;
 	pm_qos_update_request(pm_qos_req, value);
 
-- 
1.7.1

