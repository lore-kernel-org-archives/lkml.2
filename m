Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab2JDJce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:32:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45656 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab2JDJca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:32:30 -0400
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: myungjoo.ham@samsung.com, mturquette@linaro.org, kyungmin.park@samsung.com,
        rjw@sisk.pl
Cc: patches@linaro.org, linaro-dev@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>
Subject: [PATCH v4 2/3] devfreq: Add suspend and resume apis
Date: Thu,  4 Oct 2012 14:58:33 +0530
Message-Id: <1349342914-7095-3-git-send-email-rajagopal.venkat@linaro.org>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1349342914-7095-1-git-send-email-rajagopal.venkat@linaro.org>
References: <1349342914-7095-1-git-send-email-rajagopal.venkat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devfreq suspend/resume apis for devfreq users. This patch
supports suspend and resume of devfreq load monitoring, required
for devices which can idle.

Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/devfreq/devfreq.c                 | 28 ++++++++++++++++++++++++++++
 drivers/devfreq/governor.h                |  2 ++
 drivers/devfreq/governor_simpleondemand.c |  9 +++++++++
 include/linux/devfreq.h                   | 12 ++++++++++++
 4 files changed, 51 insertions(+)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 41a4099..63e075e 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -428,6 +428,34 @@ int devfreq_remove_device(struct devfreq *devfreq)
 }
 EXPORT_SYMBOL(devfreq_remove_device);
 
+/**
+ * devfreq_suspend_device() - Suspend devfreq of a device.
+ * @devfreq	the devfreq instance to be suspended
+ */
+int devfreq_suspend_device(struct devfreq *devfreq)
+{
+	if (!devfreq)
+		return -EINVAL;
+
+	return devfreq->governor->event_handler(devfreq,
+				DEVFREQ_GOV_SUSPEND, NULL);
+}
+EXPORT_SYMBOL(devfreq_suspend_device);
+
+/**
+ * devfreq_resume_device() - Resume devfreq of a device.
+ * @devfreq	the devfreq instance to be resumed
+ */
+int devfreq_resume_device(struct devfreq *devfreq)
+{
+	if (!devfreq)
+		return -EINVAL;
+
+	return devfreq->governor->event_handler(devfreq,
+				DEVFREQ_GOV_RESUME, NULL);
+}
+EXPORT_SYMBOL(devfreq_resume_device);
+
 static ssize_t show_governor(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
diff --git a/drivers/devfreq/governor.h b/drivers/devfreq/governor.h
index bb3aff3..26432ac 100644
--- a/drivers/devfreq/governor.h
+++ b/drivers/devfreq/governor.h
@@ -22,6 +22,8 @@
 #define DEVFREQ_GOV_START			0x1
 #define DEVFREQ_GOV_STOP			0x2
 #define DEVFREQ_GOV_INTERVAL			0x3
+#define DEVFREQ_GOV_SUSPEND			0x4
+#define DEVFREQ_GOV_RESUME			0x5
 
 /* Caution: devfreq->lock must be locked before calling update_devfreq */
 extern int update_devfreq(struct devfreq *devfreq);
diff --git a/drivers/devfreq/governor_simpleondemand.c b/drivers/devfreq/governor_simpleondemand.c
index cf94218..a8ba78c 100644
--- a/drivers/devfreq/governor_simpleondemand.c
+++ b/drivers/devfreq/governor_simpleondemand.c
@@ -104,6 +104,15 @@ int devfreq_simple_ondemand_handler(struct devfreq *devfreq,
 	case DEVFREQ_GOV_INTERVAL:
 		devfreq_interval_update(devfreq, (unsigned int *)data);
 		break;
+
+	case DEVFREQ_GOV_SUSPEND:
+		devfreq_monitor_suspend(devfreq);
+		break;
+
+	case DEVFREQ_GOV_RESUME:
+		devfreq_monitor_resume(devfreq);
+		break;
+
 	default:
 		break;
 	}
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index 9cdffde..ee243a3 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -158,6 +158,8 @@ extern struct devfreq *devfreq_add_device(struct device *dev,
 				  const struct devfreq_governor *governor,
 				  void *data);
 extern int devfreq_remove_device(struct devfreq *devfreq);
+extern int devfreq_suspend_device(struct devfreq *devfreq);
+extern int devfreq_resume_device(struct devfreq *devfreq);
 
 /* Helper functions for devfreq user device driver with OPP. */
 extern struct opp *devfreq_recommended_opp(struct device *dev,
@@ -211,6 +213,16 @@ static int devfreq_remove_device(struct devfreq *devfreq)
 	return 0;
 }
 
+static int devfreq_suspend_device(struct devfreq *devfreq)
+{
+	return 0;
+}
+
+static int devfreq_resume_device(struct devfreq *devfreq)
+{
+	return 0;
+}
+
 static struct opp *devfreq_recommended_opp(struct device *dev,
 					   unsigned long *freq, u32 flags)
 {
-- 
1.7.11.3

