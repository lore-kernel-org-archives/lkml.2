Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab1BKAtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 19:49:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:50971 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756906Ab1BKAts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 19:49:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,452,1291622400"; 
   d="scan'208";a="601533470"
Subject: Re: [Patch] idle governor: Avoid lock acquisition to read pm_qos
 before entering idle
From: Tim Chen <tim.c.chen@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: mark gross <markgross@thegnar.org>,
        James Bottomley <James.Bottomley@suse.de>,
        David Alan Gilbert <linux@treblig.org>, linux-kernel@vger.kernel.org,
        Len <len.brown@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <201102110017.16066.rjw@sisk.pl>
References: <1297300864.2645.128.camel@schen9-DESK>
	 <201102110017.16066.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 16:50:16 -0800
Message-ID: <1297385416.2645.262.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 00:17 +0100, Rafael J. Wysocki wrote:

> > +static inline int pm_qos_set_value(struct pm_qos_object *o, s32 value)
> > +{
> > +	o->value = value;
> > +}
> 
> This requires a fixup, the above function is supposed to return an int.
> 
> Also, please add a comment about the requisite 32-bitness as suggested by James.
> 
> Thanks,
> Rafael

I've fixed the above function, and also included a comment warning
people not to change target value to 64 bit.  

Thanks.

Tim

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
diff --git a/include/linux/pm_qos_params.h b/include/linux/pm_qos_params.h
index 77cbddb..a7d87f9 100644
--- a/include/linux/pm_qos_params.h
+++ b/include/linux/pm_qos_params.h
@@ -16,6 +16,10 @@
 #define PM_QOS_NUM_CLASSES 4
 #define PM_QOS_DEFAULT_VALUE -1
 
+#define PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
+#define PM_QOS_NETWORK_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
+#define PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE	0
+
 struct pm_qos_request_list {
 	struct plist_node list;
 	int pm_qos_class;
diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index aeaa7f8..7b6333b 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -58,6 +58,7 @@ struct pm_qos_object {
 	struct blocking_notifier_head *notifiers;
 	struct miscdevice pm_qos_power_miscdev;
 	char *name;
+	s32 target_value;	/* Do not change this to 64 bit */
 	s32 default_value;
 	enum pm_qos_type type;
 };
@@ -70,7 +71,8 @@ static struct pm_qos_object cpu_dma_pm_qos = {
 	.requests = PLIST_HEAD_INIT(cpu_dma_pm_qos.requests, pm_qos_lock),
 	.notifiers = &cpu_dma_lat_notifier,
 	.name = "cpu_dma_latency",
-	.default_value = 2000 * USEC_PER_SEC,
+	.target_value = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE,
+	.default_value = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE,
 	.type = PM_QOS_MIN,
 };
 
@@ -79,7 +81,8 @@ static struct pm_qos_object network_lat_pm_qos = {
 	.requests = PLIST_HEAD_INIT(network_lat_pm_qos.requests, pm_qos_lock),
 	.notifiers = &network_lat_notifier,
 	.name = "network_latency",
-	.default_value = 2000 * USEC_PER_SEC,
+	.target_value = PM_QOS_NETWORK_LAT_DEFAULT_VALUE,
+	.default_value = PM_QOS_NETWORK_LAT_DEFAULT_VALUE,
 	.type = PM_QOS_MIN
 };
 
@@ -89,7 +92,8 @@ static struct pm_qos_object network_throughput_pm_qos = {
 	.requests = PLIST_HEAD_INIT(network_throughput_pm_qos.requests, pm_qos_lock),
 	.notifiers = &network_throughput_notifier,
 	.name = "network_throughput",
-	.default_value = 0,
+	.target_value = PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE,
+	.default_value = PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE,
 	.type = PM_QOS_MAX,
 };
 
@@ -132,6 +136,16 @@ static inline int pm_qos_get_value(struct pm_qos_object *o)
 	}
 }
 
+static inline s32 pm_qos_read_value(struct pm_qos_object *o)
+{
+	return o->target_value;
+}
+
+static inline void pm_qos_set_value(struct pm_qos_object *o, s32 value)
+{
+	o->value = target_value;
+}
+
 static void update_target(struct pm_qos_object *o, struct plist_node *node,
 			  int del, int value)
 {
@@ -156,6 +170,7 @@ static void update_target(struct pm_qos_object *o, struct plist_node *node,
 		plist_add(node, &o->requests);
 	}
 	curr_value = pm_qos_get_value(o);
+	pm_qos_set_value(o, curr_value);
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
 	if (prev_value != curr_value)
@@ -190,18 +205,11 @@ static int find_pm_qos_object_by_minor(int minor)
  * pm_qos_request - returns current system wide qos expectation
  * @pm_qos_class: identification of which qos value is requested
  *
- * This function returns the current target value in an atomic manner.
+ * This function returns the current target value.
  */
 int pm_qos_request(int pm_qos_class)
 {
-	unsigned long flags;
-	int value;
-
-	spin_lock_irqsave(&pm_qos_lock, flags);
-	value = pm_qos_get_value(pm_qos_array[pm_qos_class]);
-	spin_unlock_irqrestore(&pm_qos_lock, flags);
-
-	return value;
+	return pm_qos_read_value(pm_qos_array[pm_qos_class]);
 }
 EXPORT_SYMBOL_GPL(pm_qos_request);
 


