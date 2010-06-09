Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab0FIMiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:38:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:38231 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266Ab0FIMis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:38:48 -0400
Subject: Re: [PATCH 2/2] pm_qos: make update_request callable from
 interrupt context
From: James Bottomley <James.Bottomley@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Florian Mickler <florian@mickler.org>,
       pm list <linux-pm@lists.linux-foundation.org>, markgross@thegnar.org,
       mgross@linux.intel.com, Frederic Weisbecker <fweisbec@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1006091146010.2933@localhost.localdomain>
References: <1276074915-26879-1-git-send-email-florian@mickler.org>
	 <1276074915-26879-2-git-send-email-florian@mickler.org>
	 <alpine.LFD.2.00.1006091146010.2933@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 08:38:39 -0400
Message-ID: <1276087119.4343.52.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 11:46 +0200, Thomas Gleixner wrote:
> On Wed, 9 Jun 2010, florian@mickler.org wrote:
> 
> > The pm_qos framework has to guarantee atomic notifications so that
> > drivers can request and release constraints at all times while no races
> > occur.
> > 
> > In order to avoid implementing a secondary notification chain in which
> > listeners might sleep, we demand that every listener implements it's
> > notification so that it can run in interrupt context. The listener is in
> > a better position to know if races are harmful or not.
> 
> That breaks existing notifiers.

Right ... and we don't want to do that.  Which is why I think we just
use blocking notifiers as they are but allow for creating atomic ones
which may use atomic update sites.

This is the solution I have in my tree ... it preserves existing
semantics because all the update and add sites are in user context, but
it allows for notifiers with purely atomic semantics and will do a
runtime warn if anyone tries to use them in a blocking fashion (or if
anyone adds an atomic update to an existing blocking notifier).

James

---

>From 7377f3e38b1f64f4149be7e7975f63e745540661 Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@suse.de>
Date: Tue, 8 Jun 2010 14:55:35 -0400
Subject: [PATCH] pm_qos: add atomic notifier


diff --git a/include/linux/pm_qos_params.h b/include/linux/pm_qos_params.h
index d823cc0..dd1b5eb 100644
--- a/include/linux/pm_qos_params.h
+++ b/include/linux/pm_qos_params.h
@@ -28,6 +28,7 @@ void pm_qos_remove_request(struct pm_qos_request_list *pm_qos_req);
 
 int pm_qos_request(int pm_qos_class);
 int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier);
+int pm_qos_add_atomic_notifier(int pm_qos_class, struct notifier_block *notifier);
 int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier);
 
 #endif
diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index c9997f8..5b3ba68 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -55,7 +55,8 @@ enum pm_qos_type {
 
 struct pm_qos_object {
 	struct plist_head requests;
-	struct blocking_notifier_head *notifiers;
+	struct blocking_notifier_head *blocking_notifiers;
+	struct atomic_notifier_head *atomic_notifiers;
 	struct miscdevice pm_qos_power_miscdev;
 	char *name;
 	s32 default_value;
@@ -66,7 +67,7 @@ static struct pm_qos_object null_pm_qos;
 static BLOCKING_NOTIFIER_HEAD(cpu_dma_lat_notifier);
 static struct pm_qos_object cpu_dma_pm_qos = {
 	.requests = {_PLIST_HEAD_INIT(cpu_dma_pm_qos.requests)},
-	.notifiers = &cpu_dma_lat_notifier,
+	.blocking_notifiers = &cpu_dma_lat_notifier,
 	.name = "cpu_dma_latency",
 	.default_value = 2000 * USEC_PER_SEC,
 	.type = PM_QOS_MIN,
@@ -75,7 +76,7 @@ static struct pm_qos_object cpu_dma_pm_qos = {
 static BLOCKING_NOTIFIER_HEAD(network_lat_notifier);
 static struct pm_qos_object network_lat_pm_qos = {
 	.requests = {_PLIST_HEAD_INIT(network_lat_pm_qos.requests)},
-	.notifiers = &network_lat_notifier,
+	.blocking_notifiers = &network_lat_notifier,
 	.name = "network_latency",
 	.default_value = 2000 * USEC_PER_SEC,
 	.type = PM_QOS_MIN
@@ -85,7 +86,7 @@ static struct pm_qos_object network_lat_pm_qos = {
 static BLOCKING_NOTIFIER_HEAD(network_throughput_notifier);
 static struct pm_qos_object network_throughput_pm_qos = {
 	.requests = {_PLIST_HEAD_INIT(network_throughput_pm_qos.requests)},
-	.notifiers = &network_throughput_notifier,
+	.blocking_notifiers = &network_throughput_notifier,
 	.name = "network_throughput",
 	.default_value = 0,
 	.type = PM_QOS_MAX,
@@ -131,6 +132,17 @@ static inline int pm_qos_get_value(struct pm_qos_object *o)
 	}
 }
 
+static void pm_qos_call_notifiers(struct pm_qos_object *o,
+				  unsigned long curr_value)
+{
+	if (o->atomic_notifiers)
+		atomic_notifier_call_chain(o->atomic_notifiers,
+					   curr_value, NULL);
+	else
+		blocking_notifier_call_chain(o->blocking_notifiers,
+					     curr_value, NULL);
+}
+
 static void update_target(struct pm_qos_object *o, struct plist_node *node,
 			  int del)
 {
@@ -147,13 +159,29 @@ static void update_target(struct pm_qos_object *o, struct plist_node *node,
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	if (prev_value != curr_value)
-		blocking_notifier_call_chain(o->notifiers,
-					     (unsigned long)curr_value,
-					     NULL);
+		pm_qos_call_notifiers(o, curr_value);
+}
+
+static int pm_qos_might_sleep(struct notifier_block *nb, unsigned long val,
+			      void *data)
+{
+	might_sleep();
+	return NOTIFY_DONE;
 }
 
-static int register_pm_qos_misc(struct pm_qos_object *qos)
+static struct notifier_block pm_qos_might_sleep_notifier = {
+       .notifier_call = pm_qos_might_sleep,
+};
+
+static int register_pm_qos(struct pm_qos_object *qos)
 {
+	int retval = 0;
+
+	if (qos->blocking_notifiers)
+		retval = blocking_notifier_chain_register(
+			qos->blocking_notifiers, &pm_qos_might_sleep_notifier);
+	if (retval)
+		return retval;
 	qos->pm_qos_power_miscdev.minor = MISC_DYNAMIC_MINOR;
 	qos->pm_qos_power_miscdev.name = qos->name;
 	qos->pm_qos_power_miscdev.fops = &pm_qos_power_fops;
@@ -302,8 +330,12 @@ int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier)
 {
 	int retval;
 
+	/* someone tried to register a blocking notifier to a
+	 * qos object that only supports atomic ones */
+	BUG_ON(!pm_qos_array[pm_qos_class]->blocking_notifiers);
+
 	retval = blocking_notifier_chain_register(
-			pm_qos_array[pm_qos_class]->notifiers, notifier);
+			pm_qos_array[pm_qos_class]->blocking_notifiers, notifier);
 
 	return retval;
 }
@@ -319,15 +351,41 @@ EXPORT_SYMBOL_GPL(pm_qos_add_notifier);
  */
 int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier)
 {
-	int retval;
 
-	retval = blocking_notifier_chain_unregister(
-			pm_qos_array[pm_qos_class]->notifiers, notifier);
-
-	return retval;
+	if (pm_qos_array[pm_qos_class]->atomic_notifiers)
+		return atomic_notifier_chain_unregister(
+			pm_qos_array[pm_qos_class]->atomic_notifiers,
+			notifier);
+	else
+		return blocking_notifier_chain_unregister(
+			pm_qos_array[pm_qos_class]->blocking_notifiers,
+			notifier);
 }
 EXPORT_SYMBOL_GPL(pm_qos_remove_notifier);
 
+/**
+ * pm_qos_add_atomic_notifier - sets notification entry for changes to target value
+ * @pm_qos_class: identifies which qos target changes should be notified.
+ * @notifier: notifier block managed by caller.
+ *
+ * will register the notifier into a notification chain that gets
+ * called upon changes to the pm_qos_class target value.  The notifier
+ * may be called from atomic context.  use @pm_qos_remove_notifier to
+ * unregister.
+ */
+int pm_qos_add_atomic_notifier(int pm_qos_class, struct notifier_block *notifier)
+{
+	if (pm_qos_array[pm_qos_class]->atomic_notifiers)
+		return atomic_notifier_chain_register(
+			pm_qos_array[pm_qos_class]->atomic_notifiers,
+			notifier);
+	else
+		return blocking_notifier_chain_register(
+			pm_qos_array[pm_qos_class]->blocking_notifiers,
+			notifier);
+}
+EXPORT_SYMBOL_GPL(pm_qos_add_atomic_notifier);
+
 static int pm_qos_power_open(struct inode *inode, struct file *filp)
 {
 	long pm_qos_class;
@@ -391,17 +449,17 @@ static int __init pm_qos_power_init(void)
 {
 	int ret = 0;
 
-	ret = register_pm_qos_misc(&cpu_dma_pm_qos);
+	ret = register_pm_qos(&cpu_dma_pm_qos);
 	if (ret < 0) {
 		printk(KERN_ERR "pm_qos_param: cpu_dma_latency setup failed\n");
 		return ret;
 	}
-	ret = register_pm_qos_misc(&network_lat_pm_qos);
+	ret = register_pm_qos(&network_lat_pm_qos);
 	if (ret < 0) {
 		printk(KERN_ERR "pm_qos_param: network_latency setup failed\n");
 		return ret;
 	}
-	ret = register_pm_qos_misc(&network_throughput_pm_qos);
+	ret = register_pm_qos(&network_throughput_pm_qos);
 	if (ret < 0)
 		printk(KERN_ERR
 			"pm_qos_param: network_throughput setup failed\n");


