Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab2B1Fqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 00:46:45 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:36733 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab2B1Fqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 00:46:43 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-30-4f4c6a4103b6
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        Mike Turquette <mturquette@ti.com>, mark gross <markgross@thegnar.org>,
        myungjoo.ham@gmail.com
Subject: [PATCH v2] PM / devfreq: add PM QoS support
Date: Tue, 28 Feb 2012 14:46:50 +0900
Message-id: <1330408010-25780-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1328858374-22339-1-git-send-email-myungjoo.ham@samsung.com>
References: <1328858374-22339-1-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if the performance of a device is controlled properly with devfreq,
sometimes, we still need to get PM-QoS inputs in order to meet the
required performance.

In our testbed of Exynos4412, which has on-chip various DMA devices, the
memory interface and system bus are controlled according to their
utilization by devfreq. However, in some multimedia applications
including video-playing with MFC (multi-function codec) H/W and
photo/video-capturing with FIMC H/W, we have observed issues due to
insufficient DMA throughput or latency.

In such applications, there are deadlines: less than 16.6ms with 60Hz.
With shorter polling intervals (5 ~ 15ms), the frequencies fluctuate
within a frame and we get missing frames and distorted pictures.
With longer polling intervals (20 ~ 100ms), the response time is not
sufficient and we get distorted or broken images. In other words,
regardless of polling interval, we get poor results with hard-deadline
H/Ws. They, in fact, have a preset requirement on DMA throughput.

Thus, we need PM-QoS capabilities in devfreq. (Note that for general
user applications, devfreq for bus/memory works fine. They are not so
sensitive to tens of ms in performance increasing responses in general.

In order to express how to handle QoS requests in devfreq devices,
the devfreq device drivers only need to express the mappings of
QoS value and frequency pairs with QoS class along with
devfreq_add_device() call.

As a side effect of the implementation, which happens to be positive,
min/max freq is now enforced regardless of governor implementation.

Tested on Exynos4412 machines with memory/bus frequencies and multimedia
H/W blocks. (camera, video decoding, and video encoding)

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

---
Changes from V1
- (style update) Error handling at devfreq_add_device()
- (style update) Handling pm_qos_max information

---
 drivers/devfreq/devfreq.c |  166 +++++++++++++++++++++++++++++++++++++++++++-
 include/linux/devfreq.h   |   37 ++++++++++
 2 files changed, 199 insertions(+), 4 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index a129a7b..0b49f59 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -25,6 +25,7 @@
 #include <linux/list.h>
 #include <linux/printk.h>
 #include <linux/hrtimer.h>
+#include <linux/pm_qos.h>
 #include "governor.h"
 
 struct class *devfreq_class;
@@ -94,6 +95,26 @@ int update_devfreq(struct devfreq *devfreq)
 	if (err)
 		return err;
 
+	/*
+	 * Adjust the freuqency with user freq and QoS.
+	 *
+	 * List from the highest proiority
+	 * min_freq
+	 * max_freq
+	 * qos_min_freq
+	 */
+
+	if (devfreq->qos_min_freq && freq < devfreq->qos_min_freq)
+		freq = devfreq->qos_min_freq;
+	if (devfreq->max_freq && freq > devfreq->max_freq)
+		freq = devfreq->max_freq;
+	if (devfreq->min_freq && freq < devfreq->min_freq)
+		freq = devfreq->min_freq;
+
+	/*
+	 * TODO in the devfreq-next:
+	 * add relation or use rance (freq_min, freq_max)
+	 */
 	err = devfreq->profile->target(devfreq->dev.parent, &freq);
 	if (err)
 		return err;
@@ -106,12 +127,12 @@ int update_devfreq(struct devfreq *devfreq)
  * devfreq_notifier_call() - Notify that the device frequency requirements
  *			   has been changed out of devfreq framework.
  * @nb		the notifier_block (supposed to be devfreq->nb)
- * @type	not used
+ * @val		not used.
  * @devp	not used
  *
  * Called by a notifier that uses devfreq->nb.
  */
-static int devfreq_notifier_call(struct notifier_block *nb, unsigned long type,
+static int devfreq_notifier_call(struct notifier_block *nb, unsigned long val,
 				 void *devp)
 {
 	struct devfreq *devfreq = container_of(nb, struct devfreq, nb);
@@ -125,6 +146,49 @@ static int devfreq_notifier_call(struct notifier_block *nb, unsigned long type,
 }
 
 /**
+ * devfreq_qos_notifier_call() -
+ */
+static int devfreq_qos_notifier_call(struct notifier_block *nb,
+				     unsigned long value, void *devp)
+{
+	struct devfreq *devfreq = container_of(nb, struct devfreq, qos_nb);
+	int ret;
+	int i;
+	s32 default_value = PM_QOS_DEFAULT_VALUE;
+	struct devfreq_pm_qos_table *qos_list = devfreq->profile->qos_list;
+	bool qos_use_max = devfreq->qos_use_max;
+
+	if (!qos_list)
+		return NOTIFY_DONE;
+
+	mutex_lock(&devfreq->lock);
+
+	if (value == default_value) {
+		devfreq->qos_min_freq = 0;
+		goto update;
+	}
+
+	for (i = 0; qos_list[i].freq; i++) {
+		/* QoS Met */
+		if ((qos_use_max && qos_list[i].qos_value >= value) ||
+		    (!qos_use_max && qos_list[i].qos_value <= value)) {
+			devfreq->qos_min_freq = qos_list[i].freq;
+			goto update;
+		}
+	}
+
+	/* Use the highest QoS freq */
+	if (i > 0)
+		devfreq->qos_min_freq = qos_list[i - 1].freq;
+
+update:
+	ret = update_devfreq(devfreq);
+	mutex_unlock(&devfreq->lock);
+
+	return ret;
+}
+
+/**
  * _remove_devfreq() - Remove devfreq from the device.
  * @devfreq:	the devfreq struct
  * @skip:	skip calling device_unregister().
@@ -332,7 +396,7 @@ struct devfreq *devfreq_add_device(struct device *dev,
 				   void *data)
 {
 	struct devfreq *devfreq;
-	int err = 0;
+	int err = 0, i;
 
 	if (!dev || !profile || !governor) {
 		dev_err(dev, "%s: Invalid parameters.\n", __func__);
@@ -371,12 +435,80 @@ struct devfreq *devfreq_add_device(struct device *dev,
 	devfreq->next_polling = devfreq->polling_jiffies
 			      = msecs_to_jiffies(devfreq->profile->polling_ms);
 	devfreq->nb.notifier_call = devfreq_notifier_call;
+	devfreq->qos_nb.notifier_call = devfreq_qos_notifier_call;
+
+	/* Check the sanity of qos_list/qos_type */
+	if (profile->qos_type || profile->qos_list) {
+		switch (profile->qos_type) {
+		case PM_QOS_CPU_DMA_LATENCY:
+		case PM_QOS_NETWORK_LATENCY:
+			devfreq->qos_use_max = false;
+			break;
+		case PM_QOS_NETWORK_THROUGHPUT:
+			devfreq->qos_use_max = true;
+			break;
+		default:
+			WARN(true, "Unknown PM-QoS Class (%d).\n", profile->qos_type);
+			err = -EINVAL;
+			goto err_dev;
+		}
+
+		if (WARN(!profile->qos_type || !profile->qos_list,
+			 "QoS requirement partially omitted for %s.\n",
+			 dev_name(dev))) {
+
+			err = -EINVAL;
+			goto err_dev;
+		}
+
+		if (WARN(!profile->qos_list[0].freq,
+			 "The first QoS requirement is the end of list for %s.\n",
+			 dev_name(dev))) {
+
+			err = -EINVAL;
+			goto err_dev;
+		}
+
+		for (i = 1; profile->qos_list[i].freq; i++) {
+			if (WARN(profile->qos_list[i].freq <=
+				 profile->qos_list[i - 1].freq,
+				 "%s's qos_list[].freq not sorted in the ascending order. ([%d]=%lu, [%d]=%lu)\n",
+				 dev_name(dev), i - 1,
+				 profile->qos_list[i - 1].freq, i,
+				 profile->qos_list[i].freq)) {
+
+				err = -EINVAL;
+				goto err_dev;
+			}
+
+			/*
+			 * If QoS type is throughput(PM_QOS_MAX), qos_value
+			 * should be sorted in the ascending order.
+			 * If QoS type is latency(PM_QOS_MIN), qos_value
+			 * should be sorted in the descending order.
+			 */
+			if (WARN((devfreq->qos_use_max &&
+				  profile->qos_list[i - 1].qos_value >
+				  profile->qos_list[i].qos_value) ||
+				 (!devfreq->qos_use_max &&
+				  profile->qos_list[i - 1].qos_value <
+				  profile->qos_list[i].qos_value),
+				 "%s's qos_list[].qos_value is not sorted according to its QoS class.\n",
+				 dev_name(dev))) {
+
+				err = -EINVAL;
+				goto err_dev;
+			}
+		}
+
+		pm_qos_add_notifier(profile->qos_type, &devfreq->qos_nb);
+	}
 
 	dev_set_name(&devfreq->dev, dev_name(dev));
 	err = device_register(&devfreq->dev);
 	if (err) {
 		put_device(&devfreq->dev);
-		goto err_dev;
+		goto err_qos_add;
 	}
 
 	if (governor->init)
@@ -404,6 +536,9 @@ out:
 
 err_init:
 	device_unregister(&devfreq->dev);
+err_qos_add:
+	if (profile->qos_type || profile->qos_list)
+		pm_qos_remove_notifier(profile->qos_type, &devfreq->qos_nb);
 err_dev:
 	mutex_unlock(&devfreq->lock);
 	kfree(devfreq);
@@ -434,6 +569,11 @@ int devfreq_remove_device(struct devfreq *devfreq)
 	}
 
 	mutex_lock(&devfreq->lock);
+
+	if (devfreq->profile->qos_type)
+		pm_qos_remove_notifier(devfreq->profile->qos_type,
+				       &devfreq->qos_nb);
+
 	_remove_devfreq(devfreq, false); /* it unlocks devfreq->lock */
 
 	if (central_polling)
@@ -501,6 +641,13 @@ static ssize_t show_central_polling(struct device *dev,
 		       !to_devfreq(dev)->governor->no_central_polling);
 }
 
+static ssize_t show_qos_min_freq(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	return sprintf(buf, "%lu\n", to_devfreq(dev)->qos_min_freq);
+}
+
 static ssize_t store_min_freq(struct device *dev, struct device_attribute *attr,
 			      const char *buf, size_t count)
 {
@@ -577,6 +724,7 @@ static struct device_attribute devfreq_attrs[] = {
 	       store_polling_interval),
 	__ATTR(min_freq, S_IRUGO | S_IWUSR, show_min_freq, store_min_freq),
 	__ATTR(max_freq, S_IRUGO | S_IWUSR, show_max_freq, store_max_freq),
+	__ATTR(qos_min_freq, S_IRUGO, show_qos_min_freq, NULL),
 	{ },
 };
 
@@ -671,6 +819,16 @@ int devfreq_unregister_opp_notifier(struct device *dev, struct devfreq *devfreq)
 	return srcu_notifier_chain_unregister(nh, &devfreq->nb);
 }
 
+/**
+ * In progress (prototyping)
+ */
+int devfreq_simple_ondemand_flexrate_do(struct devfreq *devfreq,
+					unsigned long interval,
+					unsigned long number)
+{
+	return 0;
+}
+
 MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
 MODULE_DESCRIPTION("devfreq class support");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index 5862475..f27d511 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -45,10 +45,30 @@ struct devfreq_dev_status {
 };
 
 /**
+ * struct devfreq_pm_qos_table - An PM QoS requiement entry for devfreq dev.
+ * @freq		Lowest frequency to meet the QoS requirement
+ *			represented by qos_value. If freq=0, it means that
+ *			this element is the last in the array.
+ * @qos_value		The qos value defined in pm_qos_params.h
+ *
+ * Note that the array of devfreq_pm_qos_table should be sorted by freq
+ * in the ascending order except for the last element, which should be 0.
+ */
+struct devfreq_pm_qos_table {
+	unsigned long freq; /* 0 if this is the last element */
+	s32 qos_value;
+};
+
+/**
  * struct devfreq_dev_profile - Devfreq's user device profile
  * @initial_freq	The operating frequency when devfreq_add_device() is
  *			called.
  * @polling_ms		The polling interval in ms. 0 disables polling.
+ * @qos_type		QoS Type (defined in pm_qos_params.h)
+ *			0 (PM_QOS_RESERVED) if not used.
+ * @qos_list		Array of QoS requirements ending with .freq = 0
+ *			NULL if not used. It should be either NULL or
+ *			have a length > 1 with a first element effective.
  * @target		The device should set its operating frequency at
  *			freq or lowest-upper-than-freq value. If freq is
  *			higher than any operable frequency, set maximum.
@@ -61,11 +81,17 @@ struct devfreq_dev_status {
  *			from devfreq_remove_device() call. If the user
  *			has registered devfreq->nb at a notifier-head,
  *			this is the time to unregister it.
+ *
+ * Note that the array of qos_list should be sorted by freq
+ * in the ascending order.
  */
 struct devfreq_dev_profile {
 	unsigned long initial_freq;
 	unsigned int polling_ms;
 
+	int qos_type;
+	struct devfreq_pm_qos_table *qos_list;
+
 	int (*target)(struct device *dev, unsigned long *freq);
 	int (*get_dev_status)(struct device *dev,
 			      struct devfreq_dev_status *stat);
@@ -126,6 +152,10 @@ struct devfreq_governor {
  *			order to prevent trying to remove the object multiple times.
  * @min_freq	Limit minimum frequency requested by user (0: none)
  * @max_freq	Limit maximum frequency requested by user (0: none)
+ * @qos_nb	notifier block used to notify pm qos requests
+ * @qos_min_freq	Limit minimum frequency requested by QoS
+ * @qos_use_max		true: throughput (larger is faster)
+ *			false: latency (smaller is faster)
  *
  * This structure stores the devfreq information for a give device.
  *
@@ -154,6 +184,9 @@ struct devfreq {
 
 	unsigned long min_freq;
 	unsigned long max_freq;
+	struct notifier_block qos_nb;
+	unsigned long qos_min_freq;
+	bool qos_use_max;
 };
 
 #if defined(CONFIG_PM_DEVFREQ)
@@ -199,6 +232,10 @@ struct devfreq_simple_ondemand_data {
 	unsigned int upthreshold;
 	unsigned int downdifferential;
 };
+
+int devfreq_simple_ondemand_flexrate_do(struct devfreq *devfreq,
+					unsigned long interval,
+					unsigned long number);
 #endif
 
 #else /* !CONFIG_PM_DEVFREQ */
-- 
1.7.4.1

