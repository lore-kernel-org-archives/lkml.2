Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570Ab2J2UEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:04:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57462 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695Ab2J2UB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:01:58 -0400
From: Nishanth Menon <nm@ti.com>
To: linux-pm <linux-pm@vger.kernel.org>
CC: Nishanth Menon <nm@ti.com>, Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [linux-next PATCH 2/7] PM / devfreq: provide hooks for governors to be registered
Date: Mon, 29 Oct 2012 15:01:43 -0500
Message-ID: <1351540908-12195-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351540908-12195-1-git-send-email-nm@ti.com>
References: <1351540908-12195-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devfreq_add_governor and devfreq_remove_governor which
can be invoked by governors to register with devfreq.

This sets up the stage to dynamically switch governors and
allow governors to be dynamically loaded as well.

Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/devfreq/devfreq.c  |   91 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/devfreq/governor.h |    4 ++
 include/linux/devfreq.h    |    3 ++
 3 files changed, 98 insertions(+)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 6d3070d..9c079d2 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -36,6 +36,8 @@ static struct class *devfreq_class;
  */
 static struct workqueue_struct *devfreq_wq;
 
+/* The list of all device-devfreq governors */
+static LIST_HEAD(devfreq_governor_list);
 /* The list of all device-devfreq */
 static LIST_HEAD(devfreq_list);
 static DEFINE_MUTEX(devfreq_list_lock);
@@ -66,6 +68,32 @@ static struct devfreq *find_device_devfreq(struct device *dev)
 	return ERR_PTR(-ENODEV);
 }
 
+/**
+ * find_devfreq_governor() - find devfreq governor from name
+ * @name:	name of the governor
+ *
+ * Search the list of devfreq governors and return the matched
+ * governor's pointer. devfreq_list_lock should be held by the caller.
+ */
+static struct devfreq_governor *find_devfreq_governor(const char *name)
+{
+	struct devfreq_governor *tmp_governor;
+
+	if (unlikely(IS_ERR_OR_NULL(name))) {
+		pr_err("DEVFREQ: %s: Invalid parameters\n", __func__);
+		return ERR_PTR(-EINVAL);
+	}
+	WARN(!mutex_is_locked(&devfreq_list_lock),
+	     "devfreq_list_lock must be locked.");
+
+	list_for_each_entry(tmp_governor, &devfreq_governor_list, node) {
+		if (!strncmp(tmp_governor->name, name, DEVFREQ_NAME_LEN))
+			return tmp_governor;
+	}
+
+	return ERR_PTR(-ENODEV);
+}
+
 /* Load monitoring helper functions for governors use */
 
 /**
@@ -456,6 +484,69 @@ int devfreq_resume_device(struct devfreq *devfreq)
 }
 EXPORT_SYMBOL(devfreq_resume_device);
 
+/**
+ * devfreq_add_governor() - Add devfreq governor
+ * @governor:	the devfreq governor to be added
+ */
+int devfreq_add_governor(struct devfreq_governor *governor)
+{
+	struct devfreq_governor *g;
+	int err = 0;
+
+	if (!governor) {
+		pr_err("%s: Invalid parameters.\n", __func__);
+		return -EINVAL;
+	}
+
+	mutex_lock(&devfreq_list_lock);
+	g = find_devfreq_governor(governor->name);
+	if (!IS_ERR(g)) {
+		pr_err("%s: governor %s already registered\n", __func__,
+		       g->name);
+		err = -EINVAL;
+		goto err_out;
+	}
+
+	list_add(&governor->node, &devfreq_governor_list);
+
+err_out:
+	mutex_unlock(&devfreq_list_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(devfreq_add_governor);
+
+/**
+ * devfreq_remove_device() - Remove devfreq feature from a device.
+ * @governor:	the devfreq governor to be removed
+ */
+int devfreq_remove_governor(struct devfreq_governor *governor)
+{
+	struct devfreq_governor *g;
+	int err = 0;
+
+	if (!governor) {
+		pr_err("%s: Invalid parameters.\n", __func__);
+		return -EINVAL;
+	}
+
+	mutex_lock(&devfreq_list_lock);
+	g = find_devfreq_governor(governor->name);
+	if (IS_ERR(g)) {
+		pr_err("%s: governor %s not registered\n", __func__,
+		       g->name);
+		err = -EINVAL;
+		goto err_out;
+	}
+
+	list_del(&governor->node);
+err_out:
+	mutex_unlock(&devfreq_list_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(devfreq_remove_governor);
+
 static ssize_t show_governor(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/devfreq/governor.h b/drivers/devfreq/governor.h
index 26432ac..fad7d63 100644
--- a/drivers/devfreq/governor.h
+++ b/drivers/devfreq/governor.h
@@ -34,4 +34,8 @@ extern void devfreq_monitor_suspend(struct devfreq *devfreq);
 extern void devfreq_monitor_resume(struct devfreq *devfreq);
 extern void devfreq_interval_update(struct devfreq *devfreq,
 					unsigned int *delay);
+
+extern int devfreq_add_governor(struct devfreq_governor *governor);
+extern int devfreq_remove_governor(struct devfreq_governor *governor);
+
 #endif /* _GOVERNOR_H */
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index 1461fb2..a28d935 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -87,6 +87,7 @@ struct devfreq_dev_profile {
 
 /**
  * struct devfreq_governor - Devfreq policy governor
+ * @node:		list node - contains registered devfreq governors
  * @name:		Governor's name
  * @get_target_freq:	Returns desired operating frequency for the device.
  *			Basically, get_target_freq will run
@@ -102,6 +103,8 @@ struct devfreq_dev_profile {
  * Note that the callbacks are called with devfreq->lock locked by devfreq.
  */
 struct devfreq_governor {
+	struct list_head node;
+
 	const char name[DEVFREQ_NAME_LEN];
 	int (*get_target_freq)(struct devfreq *this, unsigned long *freq);
 	int (*event_handler)(struct devfreq *devfreq,
-- 
1.7.9.5

