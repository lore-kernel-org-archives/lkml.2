Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021Ab1I2MT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 08:19:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18135 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab1I2MSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 08:18:46 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-83-4e84622420b6
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@suse.de>, Kevin Hilman <khilman@ti.com>,
        Nishanth Menon <nm@ti.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Colin Cross <ccross@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@ti.com>, myungjoo.ham@gmail.com
Subject: [PATCH v13 1/4] PM / OPP: Add OPP availability change notifier.
Date: Thu, 29 Sep 2011 21:18:47 +0900
Message-id: <1317298730-10442-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1317298730-10442-1-git-send-email-myungjoo.ham@samsung.com>
References: <1317298730-10442-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 29 Sep 2011 12:18:42.0790 (UTC)
 FILETIME=[ED980860:01CC7EA1]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch enables to register notifier_block for an OPP-device in order
to get notified for any changes in the availability of OPPs of the
device. For example, if a new OPP is inserted or enable/disable status
of an OPP is changed, the notifier is executed.

This enables the usage of opp_add, opp_enable, and opp_disable to
directly take effect with any connected entities such as cpufreq or
devfreq.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Mike Turquette <mturquette@ti.com>
Reviewed-by: Kevin Hilman <khilman@ti.com>

---
Changes from v12
- Fixed up kerneldoc comments

v12: No changes since v7

Added at devfreq patch set v6 replacing devfreq_update calls at OPP.
---
 drivers/base/power/opp.c |   30 ++++++++++++++++++++++++++++++
 include/linux/opp.h      |   12 ++++++++++++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index b23de18..434a6c0 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -73,6 +73,7 @@ struct opp {
  *		RCU usage: nodes are not modified in the list of device_opp,
  *		however addition is possible and is secured by dev_opp_list_lock
  * @dev:	device pointer
+ * @head:	notifier head to notify the OPP availability changes.
  * @opp_list:	list of opps
  *
  * This is an internal data structure maintaining the link to opps attached to
@@ -83,6 +84,7 @@ struct device_opp {
 	struct list_head node;
 
 	struct device *dev;
+	struct srcu_notifier_head head;
 	struct list_head opp_list;
 };
 
@@ -404,6 +406,7 @@ int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 		}
 
 		dev_opp->dev = dev;
+		srcu_init_notifier_head(&dev_opp->head);
 		INIT_LIST_HEAD(&dev_opp->opp_list);
 
 		/* Secure the device list modification */
@@ -428,6 +431,11 @@ int opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 	list_add_rcu(&new_opp->node, head);
 	mutex_unlock(&dev_opp_list_lock);
 
+	/*
+	 * Notify the changes in the availability of the operable
+	 * frequency/voltage list.
+	 */
+	srcu_notifier_call_chain(&dev_opp->head, OPP_EVENT_ADD, new_opp);
 	return 0;
 }
 
@@ -504,6 +512,14 @@ static int opp_set_availability(struct device *dev, unsigned long freq,
 	mutex_unlock(&dev_opp_list_lock);
 	synchronize_rcu();
 
+	/* Notify the change of the OPP availability */
+	if (availability_req)
+		srcu_notifier_call_chain(&dev_opp->head, OPP_EVENT_ENABLE,
+					 new_opp);
+	else
+		srcu_notifier_call_chain(&dev_opp->head, OPP_EVENT_DISABLE,
+					 new_opp);
+
 	/* clean up old opp */
 	new_opp = opp;
 	goto out;
@@ -643,3 +659,17 @@ void opp_free_cpufreq_table(struct device *dev,
 	*table = NULL;
 }
 #endif		/* CONFIG_CPU_FREQ */
+
+/**
+ * opp_get_notifier() - find notifier_head of the device with opp
+ * @dev:	device pointer used to lookup device OPPs.
+ */
+struct srcu_notifier_head *opp_get_notifier(struct device *dev)
+{
+	struct device_opp *dev_opp = find_device_opp(dev);
+
+	if (IS_ERR(dev_opp))
+		return ERR_PTR(PTR_ERR(dev_opp)); /* matching type */
+
+	return &dev_opp->head;
+}
diff --git a/include/linux/opp.h b/include/linux/opp.h
index 7020e97..87a9208 100644
--- a/include/linux/opp.h
+++ b/include/linux/opp.h
@@ -16,9 +16,14 @@
 
 #include <linux/err.h>
 #include <linux/cpufreq.h>
+#include <linux/notifier.h>
 
 struct opp;
 
+enum opp_event {
+	OPP_EVENT_ADD, OPP_EVENT_ENABLE, OPP_EVENT_DISABLE,
+};
+
 #if defined(CONFIG_PM_OPP)
 
 unsigned long opp_get_voltage(struct opp *opp);
@@ -40,6 +45,8 @@ int opp_enable(struct device *dev, unsigned long freq);
 
 int opp_disable(struct device *dev, unsigned long freq);
 
+struct srcu_notifier_head *opp_get_notifier(struct device *dev);
+
 #else
 static inline unsigned long opp_get_voltage(struct opp *opp)
 {
@@ -89,6 +96,11 @@ static inline int opp_disable(struct device *dev, unsigned long freq)
 {
 	return 0;
 }
+
+struct srcu_notifier_head *opp_get_notifier(struct device *dev)
+{
+	return ERR_PTR(-EINVAL);
+}
 #endif		/* CONFIG_PM */
 
 #if defined(CONFIG_CPU_FREQ) && defined(CONFIG_PM_OPP)
-- 
1.7.4.1

