Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab2ICOcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 10:32:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63688 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276Ab2ICOcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 10:32:10 -0400
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: mturquette@linaro.org, myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        rjw@sisk.pl
Cc: patches@linaro.org, linaro-dev@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>
Subject: [PATCH 3/3] devfreq: Add current freq callback in device profile
Date: Mon,  3 Sep 2012 19:59:38 +0530
Message-Id: <1346682578-24312-4-git-send-email-rajagopal.venkat@linaro.org>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1346682578-24312-1-git-send-email-rajagopal.venkat@linaro.org>
References: <1346682578-24312-1-git-send-email-rajagopal.venkat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devfreq returns governor predicted frequency as current
frequency via sysfs interface. But device may not support
all frequencies that governor predicts. Its driver
responsibility to maintain current frequency at which device
is operating. Add a callback in device profile to fix this.
Also add a new sysfs node to expose governor predicted next
target frequency.

Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
---
 Documentation/ABI/testing/sysfs-class-devfreq |  7 +++++++
 drivers/devfreq/devfreq.c                     | 14 ++++++++++++++
 include/linux/devfreq.h                       |  3 +++
 3 files changed, 24 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
index 23d78b5..9df5205 100644
--- a/Documentation/ABI/testing/sysfs-class-devfreq
+++ b/Documentation/ABI/testing/sysfs-class-devfreq
@@ -21,6 +21,13 @@ Description:
 		The /sys/class/devfreq/.../cur_freq shows the current
 		frequency of the corresponding devfreq object.
 
+What:		/sys/class/devfreq/.../target_freq
+Date:		September 2012
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/class/devfreq/.../target_freq shows the next governor
+		predicted target frequency of the corresponding devfreq object.
+
 What:		/sys/class/devfreq/.../central_polling
 Date:		September 2011
 Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 3a5f126..55e9046 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -400,6 +400,19 @@ static ssize_t show_governor(struct device *dev,
 static ssize_t show_freq(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
+	unsigned long freq;
+	struct devfreq *devfreq = to_devfreq(dev);
+
+	if (devfreq->profile->get_cur_freq)
+		if (!devfreq->profile->get_cur_freq(devfreq->dev.parent, &freq))
+			return sprintf(buf, "%lu\n", freq);
+
+	return sprintf(buf, "<unknown>");
+}
+
+static ssize_t show_target_freq(struct device *dev,
+			struct device_attribute *attr, char *buf)
+{
 	return sprintf(buf, "%lu\n", to_devfreq(dev)->previous_freq);
 }
 
@@ -503,6 +516,7 @@ static ssize_t show_max_freq(struct device *dev, struct device_attribute *attr,
 static struct device_attribute devfreq_attrs[] = {
 	__ATTR(governor, S_IRUGO, show_governor, NULL),
 	__ATTR(cur_freq, S_IRUGO, show_freq, NULL),
+	__ATTR(target_freq, S_IRUGO, show_target_freq, NULL),
 	__ATTR(polling_interval, S_IRUGO | S_IWUSR, show_polling_interval,
 	       store_polling_interval),
 	__ATTR(min_freq, S_IRUGO | S_IWUSR, show_min_freq, store_min_freq),
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index 7c7e179..d12ed41 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -66,6 +66,8 @@ struct devfreq_dev_status {
  *			explained above with "DEVFREQ_FLAG_*" macros.
  * @get_dev_status	The device should provide the current performance
  *			status to devfreq, which is used by governors.
+ * @get_cur_freq	The device should provide the current frequency
+ *			at which it is operating.
  * @exit		An optional callback that is called when devfreq
  *			is removing the devfreq object due to error or
  *			from devfreq_remove_device() call. If the user
@@ -79,6 +81,7 @@ struct devfreq_dev_profile {
 	int (*target)(struct device *dev, unsigned long *freq, u32 flags);
 	int (*get_dev_status)(struct device *dev,
 			      struct devfreq_dev_status *stat);
+	int (*get_cur_freq)(struct device *dev, unsigned long *freq);
 	void (*exit)(struct device *dev);
 };
 
-- 
1.7.11.3

