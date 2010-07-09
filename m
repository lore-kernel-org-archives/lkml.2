Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab0GIFp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 01:45:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:59012 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab0GIFpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 01:45:25 -0400
Date: Thu, 8 Jul 2010 22:48:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pm: Add runtime PM statistics to sysfs
Message-ID: <20100708224837.6a18995b@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: pm: Add runtime PM statistics to sysfs

In order for PowerTOP to be able to report how well the new runtime PM is working
for the various drivers, the kernel needs to export some basic statistics in sysfs.

This patch adds two sysfs files in the runtime PM domain that expose the
total time a device has been active, and the time a device has been suspended.

With this PowerTOP can compute the activity percentage

Active %age = 100 * (delta active) / (delta active + delta suspended)

and present the information to the user.

I've written the PowerTOP code (slated for version 1.12) already, and the output looks
like this:

Runtime Device Power Management statistics
Active  Device name
 10.0%	06:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E




Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

--
 3 files changed, 58 insertions(+)

diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index b0ec0e9..4493775 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -123,6 +123,27 @@ int pm_runtime_idle(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(pm_runtime_idle);
 
+void update_pm_runtime_accounting(struct device *dev)
+{
+	unsigned long now = jiffies;
+	int delta;
+
+	delta = now - dev->power.accounting_timestamp;
+
+	if (delta < 0)
+		delta = 0;
+
+	dev->power.accounting_timestamp = now;
+
+	if (dev->power.disable_depth > 0)
+		return;
+
+	if (dev->power.runtime_status == RPM_SUSPENDED)
+		dev->power.suspended_jiffies += delta;
+	else
+		dev->power.active_jiffies += delta;
+}
+
 /**
  * __pm_runtime_suspend - Carry out run-time suspend of given device.
  * @dev: Device to suspend.
@@ -237,6 +258,7 @@ int __pm_runtime_suspend(struct device *dev, bool from_wq)
 			pm_runtime_cancel_pending(dev);
 		}
 	} else {
+		update_pm_runtime_accounting(dev);
 		dev->power.runtime_status = RPM_SUSPENDED;
 		pm_runtime_deactivate_timer(dev);
 
@@ -411,6 +433,7 @@ int __pm_runtime_resume(struct device *dev, bool from_wq)
 	}
 
 	if (retval) {
+		update_pm_runtime_accounting(dev);
 		dev->power.runtime_status = RPM_SUSPENDED;
 		pm_runtime_cancel_pending(dev);
 	} else {
@@ -1077,6 +1100,7 @@ void pm_runtime_init(struct device *dev)
 	dev->power.request_pending = false;
 	dev->power.request = RPM_REQ_NONE;
 	dev->power.deferred_resume = false;
+	dev->power.accounting_timestamp = jiffies;
 	INIT_WORK(&dev->power.work, pm_runtime_work);
 
 	dev->power.timer_expires = 0;
diff --git a/drivers/base/power/sysfs.c b/drivers/base/power/sysfs.c
index a4c33bc..f45c316 100644
--- a/drivers/base/power/sysfs.c
+++ b/drivers/base/power/sysfs.c
@@ -6,6 +6,7 @@
 #include <linux/string.h>
 #include <linux/pm_runtime.h>
 #include <asm/atomic.h>
+#include <linux/jiffies.h>
 #include "power.h"
 
 /*
@@ -190,9 +191,34 @@ static ssize_t rtpm_status_show(struct device *dev,
 	return -EIO;
 }
 
+static ssize_t rtpm_active_time_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int ret;
+	spin_lock_irq(&dev->power.lock);
+	update_pm_runtime_accounting(dev);
+	ret = sprintf(buf, "%i\n", jiffies_to_msecs(dev->power.active_jiffies));
+	spin_unlock_irq(&dev->power.lock);
+	return ret;
+}
+
+static ssize_t rtpm_suspended_time_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int ret;
+	spin_lock_irq(&dev->power.lock);
+	update_pm_runtime_accounting(dev);
+	ret = sprintf(buf, "%i\n",
+		jiffies_to_msecs(dev->power.suspended_jiffies));
+	spin_unlock_irq(&dev->power.lock);
+	return ret;
+}
+
 static DEVICE_ATTR(runtime_usage, 0444, rtpm_usagecount_show, NULL);
 static DEVICE_ATTR(runtime_active_kids, 0444, rtpm_children_show, NULL);
 static DEVICE_ATTR(runtime_status, 0444, rtpm_status_show, NULL);
+static DEVICE_ATTR(runtime_active_time, 0444, rtpm_active_time_show, NULL);
+static DEVICE_ATTR(runtime_suspended_time, 0444, rtpm_suspended_time_show, NULL);
 static DEVICE_ATTR(runtime_enabled, 0444, rtpm_enabled_show, NULL);
 
 #endif
@@ -234,6 +260,8 @@ static struct attribute * power_attrs[] = {
 	&dev_attr_async.attr,
 #ifdef CONFIG_PM_RUNTIME
 	&dev_attr_runtime_usage.attr,
+	&dev_attr_runtime_suspended_time.attr,
+	&dev_attr_runtime_active_time.attr,
 	&dev_attr_runtime_active_kids.attr,
 	&dev_attr_runtime_status.attr,
 	&dev_attr_runtime_enabled.attr,
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 8e258c7..dca597f 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -476,9 +476,15 @@ struct dev_pm_info {
 	enum rpm_request	request;
 	enum rpm_status		runtime_status;
 	int			runtime_error;
+	unsigned long		active_jiffies;
+	unsigned long		suspended_jiffies;
+	unsigned long		accounting_timestamp;
 #endif
 };
 
+extern void update_pm_runtime_accounting(struct device *dev);
+
+
 /*
  * The PM_EVENT_ messages are also used by drivers implementing the legacy
  * suspend framework, based on the ->suspend() and ->resume() callbacks common


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
