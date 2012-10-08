Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab2JHIKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 04:10:38 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36187 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab2JHIKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 04:10:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Huang Ying <ying.huang@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Jean Pihet <j-pihet@ti.com>, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] PM / QoS: Prepare device structure for adding more constraint types
Date: Mon, 08 Oct 2012 10:04:03 +0200
Message-ID: <5823653.QdHL6Lda2x@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.0-2.10-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1413438.1MkXj8vjQK@vostro.rjw.lan>
References: <201209282351.10663.rjw@sisk.pl> <1413438.1MkXj8vjQK@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Currently struct dev_pm_info contains only one PM QoS constraints
pointer reserved for latency requirements.  Since one more device
constraints type (i.e. flags) will be necessary, introduce a new
structure, struct dev_pm_qos, that eventually will contain all of
the available device PM QoS constraints and replace the "constraints"
pointer in struct dev_pm_info with a pointer to the new structure
called "qos".

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Jean Pihet <j-pihet@ti.com>
---
 drivers/base/power/qos.c |   42 ++++++++++++++++++++++--------------------
 include/linux/pm.h       |    2 +-
 include/linux/pm_qos.h   |    4 ++++
 3 files changed, 27 insertions(+), 21 deletions(-)

Index: linux/include/linux/pm.h
===================================================================
--- linux.orig/include/linux/pm.h
+++ linux/include/linux/pm.h
@@ -551,7 +551,7 @@ struct dev_pm_info {
 	struct dev_pm_qos_request *pq_req;
 #endif
 	struct pm_subsys_data	*subsys_data;  /* Owned by the subsystem. */
-	struct pm_qos_constraints *constraints;
+	struct dev_pm_qos	*qos;
 };
 
 extern void update_pm_runtime_accounting(struct device *dev);
Index: linux/include/linux/pm_qos.h
===================================================================
--- linux.orig/include/linux/pm_qos.h
+++ linux/include/linux/pm_qos.h
@@ -57,6 +57,10 @@ struct pm_qos_constraints {
 	struct blocking_notifier_head *notifiers;
 };
 
+struct dev_pm_qos {
+	struct pm_qos_constraints latency;
+};
+
 /* Action requested to pm_qos_update_target */
 enum pm_qos_req_action {
 	PM_QOS_ADD_REQ,		/* Add a new request */
Index: linux/drivers/base/power/qos.c
===================================================================
--- linux.orig/drivers/base/power/qos.c
+++ linux/drivers/base/power/qos.c
@@ -55,9 +55,7 @@ static BLOCKING_NOTIFIER_HEAD(dev_pm_not
  */
 s32 __dev_pm_qos_read_value(struct device *dev)
 {
-	struct pm_qos_constraints *c = dev->power.constraints;
-
-	return c ? pm_qos_read_value(c) : 0;
+	return dev->power.qos ? pm_qos_read_value(&dev->power.qos->latency) : 0;
 }
 
 /**
@@ -91,12 +89,12 @@ static int apply_constraint(struct dev_p
 {
 	int ret, curr_value;
 
-	ret = pm_qos_update_target(req->dev->power.constraints,
+	ret = pm_qos_update_target(&req->dev->power.qos->latency,
 				   &req->node, action, value);
 
 	if (ret) {
 		/* Call the global callbacks if needed */
-		curr_value = pm_qos_read_value(req->dev->power.constraints);
+		curr_value = pm_qos_read_value(&req->dev->power.qos->latency);
 		blocking_notifier_call_chain(&dev_pm_notifiers,
 					     (unsigned long)curr_value,
 					     req);
@@ -114,20 +112,22 @@ static int apply_constraint(struct dev_p
  */
 static int dev_pm_qos_constraints_allocate(struct device *dev)
 {
+	struct dev_pm_qos *qos;
 	struct pm_qos_constraints *c;
 	struct blocking_notifier_head *n;
 
-	c = kzalloc(sizeof(*c), GFP_KERNEL);
-	if (!c)
+	qos = kzalloc(sizeof(*qos), GFP_KERNEL);
+	if (!qos)
 		return -ENOMEM;
 
 	n = kzalloc(sizeof(*n), GFP_KERNEL);
 	if (!n) {
-		kfree(c);
+		kfree(qos);
 		return -ENOMEM;
 	}
 	BLOCKING_INIT_NOTIFIER_HEAD(n);
 
+	c = &qos->latency;
 	plist_head_init(&c->list);
 	c->target_value = PM_QOS_DEV_LAT_DEFAULT_VALUE;
 	c->default_value = PM_QOS_DEV_LAT_DEFAULT_VALUE;
@@ -135,7 +135,7 @@ static int dev_pm_qos_constraints_alloca
 	c->notifiers = n;
 
 	spin_lock_irq(&dev->power.lock);
-	dev->power.constraints = c;
+	dev->power.qos = qos;
 	spin_unlock_irq(&dev->power.lock);
 
 	return 0;
@@ -151,7 +151,7 @@ static int dev_pm_qos_constraints_alloca
 void dev_pm_qos_constraints_init(struct device *dev)
 {
 	mutex_lock(&dev_pm_qos_mtx);
-	dev->power.constraints = NULL;
+	dev->power.qos = NULL;
 	dev->power.power_state = PMSG_ON;
 	mutex_unlock(&dev_pm_qos_mtx);
 }
@@ -164,6 +164,7 @@ void dev_pm_qos_constraints_init(struct
  */
 void dev_pm_qos_constraints_destroy(struct device *dev)
 {
+	struct dev_pm_qos *qos;
 	struct dev_pm_qos_request *req, *tmp;
 	struct pm_qos_constraints *c;
 
@@ -176,10 +177,11 @@ void dev_pm_qos_constraints_destroy(stru
 	mutex_lock(&dev_pm_qos_mtx);
 
 	dev->power.power_state = PMSG_INVALID;
-	c = dev->power.constraints;
-	if (!c)
+	qos = dev->power.qos;
+	if (!qos)
 		goto out;
 
+	c = &qos->latency;
 	/* Flush the constraints list for the device */
 	plist_for_each_entry_safe(req, tmp, &c->list, node) {
 		/*
@@ -191,7 +193,7 @@ void dev_pm_qos_constraints_destroy(stru
 	}
 
 	spin_lock_irq(&dev->power.lock);
-	dev->power.constraints = NULL;
+	dev->power.qos = NULL;
 	spin_unlock_irq(&dev->power.lock);
 
 	kfree(c->notifiers);
@@ -235,7 +237,7 @@ int dev_pm_qos_add_request(struct device
 
 	mutex_lock(&dev_pm_qos_mtx);
 
-	if (!dev->power.constraints) {
+	if (!dev->power.qos) {
 		if (dev->power.power_state.event == PM_EVENT_INVALID) {
 			/* The device has been removed from the system. */
 			req->dev = NULL;
@@ -290,7 +292,7 @@ int dev_pm_qos_update_request(struct dev
 
 	mutex_lock(&dev_pm_qos_mtx);
 
-	if (req->dev->power.constraints) {
+	if (req->dev->power.qos) {
 		if (new_value != req->node.prio)
 			ret = apply_constraint(req, PM_QOS_UPDATE_REQ,
 					       new_value);
@@ -329,7 +331,7 @@ int dev_pm_qos_remove_request(struct dev
 
 	mutex_lock(&dev_pm_qos_mtx);
 
-	if (req->dev->power.constraints) {
+	if (req->dev->power.qos) {
 		ret = apply_constraint(req, PM_QOS_REMOVE_REQ,
 				       PM_QOS_DEFAULT_VALUE);
 		memset(req, 0, sizeof(*req));
@@ -362,13 +364,13 @@ int dev_pm_qos_add_notifier(struct devic
 
 	mutex_lock(&dev_pm_qos_mtx);
 
-	if (!dev->power.constraints)
+	if (!dev->power.qos)
 		ret = dev->power.power_state.event != PM_EVENT_INVALID ?
 			dev_pm_qos_constraints_allocate(dev) : -ENODEV;
 
 	if (!ret)
 		ret = blocking_notifier_chain_register(
-				dev->power.constraints->notifiers, notifier);
+				dev->power.qos->latency.notifiers, notifier);
 
 	mutex_unlock(&dev_pm_qos_mtx);
 	return ret;
@@ -393,9 +395,9 @@ int dev_pm_qos_remove_notifier(struct de
 	mutex_lock(&dev_pm_qos_mtx);
 
 	/* Silently return if the constraints object is not present. */
-	if (dev->power.constraints)
+	if (dev->power.qos)
 		retval = blocking_notifier_chain_unregister(
-				dev->power.constraints->notifiers,
+				dev->power.qos->latency.notifiers,
 				notifier);
 
 	mutex_unlock(&dev_pm_qos_mtx);

