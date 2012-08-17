Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab2HQOHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 10:07:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37179 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116Ab2HQOHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 10:07:38 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v1 2/3] PM / Sleep: introduce dpm_for_each_dev
Date: Fri, 17 Aug 2012 22:06:59 +0800
Message-Id: <1345212420-1707-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345212420-1707-1-git-send-email-ming.lei@canonical.com>
References: <1345212420-1707-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dpm_list and its pm lock provide a good way to iterate all
devices in system. Except this way, there is no other easy
way to iterate devices in system.

firmware loader need to cache firmware images for devices
before system sleep, so introduce the function to meet its
demand.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/base/power/main.c |   22 ++++++++++++++++++++++
 include/linux/pm.h        |    5 +++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 57f5814..23b417f 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1349,3 +1349,25 @@ int device_pm_wait_for_dev(struct device *subordinate, struct device *dev)
 	return async_error;
 }
 EXPORT_SYMBOL_GPL(device_pm_wait_for_dev);
+
+/**
+ * dpm_for_each_dev - device iterator.
+ * @data: data for the callback.
+ * @fn: function to be called for each device.
+ *
+ * Iterate over devices in dpm_list, and call @fn for each device,
+ * passing it @data.
+ */
+void dpm_for_each_dev(void *data, void (*fn)(struct device *, void *))
+{
+	struct device *dev;
+
+	if (!fn)
+		return;
+
+	device_pm_lock();
+	list_for_each_entry(dev, &dpm_list, power.entry)
+		fn(dev, data);
+	device_pm_unlock();
+}
+EXPORT_SYMBOL_GPL(dpm_for_each_dev);
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 44d1f23..007e687 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -640,6 +640,7 @@ extern void __suspend_report_result(const char *function, void *fn, int ret);
 	} while (0)
 
 extern int device_pm_wait_for_dev(struct device *sub, struct device *dev);
+extern void dpm_for_each_dev(void *data, void (*fn)(struct device *, void *));
 
 extern int pm_generic_prepare(struct device *dev);
 extern int pm_generic_suspend_late(struct device *dev);
@@ -679,6 +680,10 @@ static inline int device_pm_wait_for_dev(struct device *a, struct device *b)
 	return 0;
 }
 
+static inline void dpm_for_each_dev(void *data, void (*fn)(struct device *, void *))
+{
+}
+
 #define pm_generic_prepare	NULL
 #define pm_generic_suspend	NULL
 #define pm_generic_resume	NULL
-- 
1.7.9.5

