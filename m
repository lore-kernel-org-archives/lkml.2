Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab1BAQao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:30:44 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42858 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab1BAQan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:30:43 -0500
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: mroberto@cpti.cetuc.puc-rio.br, a.zummo@towertech.it,
        john.stultz@linaro.org
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] RTC: Fix for issues in the kernel RTC API.
Date: Tue,  1 Feb 2011 14:30:20 -0200
Message-Id: <1296577820-27456-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following issues with the RTC API:

1 - The alarm_irq_enable() and the update_irq_enable() callbacks were
not beeing called anywhere in the code. They are necessary if you want
to write a driver that does not use the kernel pre-existent timer
implemented alarm and update interrupts.

2 - In the current configuration, an update interrupt, for example,
would be a trigger for an alarm interrupt as well, even though the mode
variable stated it was an update interrupt. To avoid that, mode is
beeing checked inside rtc_handle_legacy_irq(). That used to be the
previous user space behaviour.

3 - The irq_set_freq() and rtc_irq_set_state() functions are entry
points to the RTC API, and were not calling the irq_set_state() and
irq_set_freq() callbacks. These are also necessary overrides to provide
a proper independent RTC implementation.

4 - The rtc-test kernel RTC driver has been updated to work properly
with the new kernel RTC timer infrastructure. This driver has been used
together with the rtctest.c source code present in the file
Documentation/rtc.txt to test the user space behaviour of all the
modifications in this patch.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 drivers/rtc/interface.c |   63 +++++++++++++++++++++++++++++---------
 drivers/rtc/rtc-dev.c   |   12 ++++----
 drivers/rtc/rtc-test.c  |   77 ++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 121 insertions(+), 31 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 90384b9..6cb4b65 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -194,6 +194,11 @@ int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 	if (err)
 		return err;
 
+	if (rtc->ops->alarm_irq_enable) {
+		err = rtc->ops->alarm_irq_enable(rtc->dev.parent, enabled);
+		goto out;
+	}
+
 	if (rtc->aie_timer.enabled != enabled) {
 		if (enabled) {
 			rtc->aie_timer.enabled = 1;
@@ -211,6 +216,7 @@ int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 	else
 		err = rtc->ops->alarm_irq_enable(rtc->dev.parent, enabled);
 
+out:
 	mutex_unlock(&rtc->ops_lock);
 	return err;
 }
@@ -222,6 +228,11 @@ int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 	if (err)
 		return err;
 
+	if (rtc->ops->update_irq_enable) {
+		err = rtc->ops->update_irq_enable(rtc->dev.parent, enabled);
+		goto out;
+	}
+
 	/* make sure we're changing state */
 	if (rtc->uie_rtctimer.enabled == enabled)
 		goto out;
@@ -263,19 +274,23 @@ static void rtc_handle_legacy_irq(struct rtc_device *rtc, int num, int mode)
 {
 	unsigned long flags;
 
-	/* mark one irq of the appropriate mode */
-	spin_lock_irqsave(&rtc->irq_lock, flags);
-	rtc->irq_data = (rtc->irq_data + (num << 8)) | (RTC_IRQF|mode);
-	spin_unlock_irqrestore(&rtc->irq_lock, flags);
-
-	/* call the task func */
-	spin_lock_irqsave(&rtc->irq_task_lock, flags);
-	if (rtc->irq_task)
-		rtc->irq_task->func(rtc->irq_task->private_data);
-	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
-
-	wake_up_interruptible(&rtc->irq_queue);
-	kill_fasync(&rtc->async_queue, SIGIO, POLL_IN);
+	if (((mode & RTC_UF) && rtc->uie_rtctimer.enabled) ||
+	    ((mode & RTC_AF) && rtc->aie_timer.enabled) ||
+	    ((mode & RTC_PF) && rtc->pie_enabled)) {
+		/* mark one irq of the appropriate mode */
+		spin_lock_irqsave(&rtc->irq_lock, flags);
+		rtc->irq_data = (rtc->irq_data + (num << 8)) | (RTC_IRQF|mode);
+		spin_unlock_irqrestore(&rtc->irq_lock, flags);
+
+		/* call the task func */
+		spin_lock_irqsave(&rtc->irq_task_lock, flags);
+		if (rtc->irq_task)
+			rtc->irq_task->func(rtc->irq_task->private_data);
+		spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
+
+		wake_up_interruptible(&rtc->irq_queue);
+		kill_fasync(&rtc->async_queue, SIGIO, POLL_IN);
+	}
 }
 
 
@@ -423,9 +438,18 @@ EXPORT_SYMBOL_GPL(rtc_irq_unregister);
  */
 int rtc_irq_set_state(struct rtc_device *rtc, struct rtc_task *task, int enabled)
 {
-	int err = 0;
 	unsigned long flags;
 
+	int err = mutex_lock_interruptible(&rtc->ops_lock);
+	if (err)
+		return err;
+	if (rtc->ops->irq_set_state) {
+		err = rtc->ops->irq_set_state(rtc->dev.parent, enabled);
+		mutex_unlock(&rtc->ops_lock);
+		return err;
+	}
+	mutex_unlock(&rtc->ops_lock);
+
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
@@ -457,9 +481,18 @@ EXPORT_SYMBOL_GPL(rtc_irq_set_state);
  */
 int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
 {
-	int err = 0;
 	unsigned long flags;
 
+	int err = mutex_lock_interruptible(&rtc->ops_lock);
+	if (err)
+		return err;
+	if (rtc->ops->irq_set_freq) {
+		err = rtc->ops->irq_set_freq(rtc->dev.parent, freq);
+		mutex_unlock(&rtc->ops_lock);
+		return err;
+	}
+	mutex_unlock(&rtc->ops_lock);
+
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 212b16e..d901160 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -261,12 +261,12 @@ static long rtc_dev_ioctl(struct file *file,
 		return rtc_set_time(rtc, &tm);
 
 	case RTC_PIE_ON:
-		err = rtc_irq_set_state(rtc, NULL, 1);
-		break;
+		mutex_unlock(&rtc->ops_lock);
+		return rtc_irq_set_state(rtc, NULL, 1);
 
 	case RTC_PIE_OFF:
-		err = rtc_irq_set_state(rtc, NULL, 0);
-		break;
+		mutex_unlock(&rtc->ops_lock);
+		return rtc_irq_set_state(rtc, NULL, 0);
 
 	case RTC_AIE_ON:
 		mutex_unlock(&rtc->ops_lock);
@@ -285,8 +285,8 @@ static long rtc_dev_ioctl(struct file *file,
 		return rtc_update_irq_enable(rtc, 0);
 
 	case RTC_IRQP_SET:
-		err = rtc_irq_set_freq(rtc, NULL, arg);
-		break;
+		mutex_unlock(&rtc->ops_lock);
+		return rtc_irq_set_freq(rtc, NULL, arg);
 
 	case RTC_IRQP_READ:
 		err = put_user(rtc->irq_freq, (unsigned long __user *)uarg);
diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index 51725f7..7cbe3e3 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -13,6 +13,8 @@
 #include <linux/rtc.h>
 #include <linux/platform_device.h>
 
+static const unsigned long RTC_DEFAULT_PERIODIC_FREQ = 1024;
+
 static struct platform_device *test0 = NULL, *test1 = NULL;
 
 static int test_rtc_read_alarm(struct device *dev,
@@ -31,12 +33,54 @@ static int test_rtc_read_time(struct device *dev,
 	struct rtc_time *tm)
 {
 	rtc_time_to_tm(get_seconds(), tm);
+
 	return 0;
 }
 
 static int test_rtc_set_mmss(struct device *dev, unsigned long secs)
 {
 	dev_info(dev, "%s, secs = %lu\n", __func__, secs);
+
+	return 0;
+}
+
+static int test_rtc_irq_set_state(struct device *dev, int enabled)
+{
+	struct platform_device *plat_dev = to_platform_device(dev);
+	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
+
+	rtc->pie_enabled = enabled;
+
+	return 0;
+}
+
+static int test_rtc_irq_set_freq(struct device *dev, int freq)
+{
+	struct platform_device *plat_dev = to_platform_device(dev);
+	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
+
+	rtc->irq_freq = freq;
+
+	return 0;
+}
+
+static int test_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct platform_device *plat_dev = to_platform_device(dev);
+	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
+
+	rtc->aie_timer.enabled = enabled;
+
+	return 0;
+}
+
+static int test_rtc_update_irq_enable(struct device *dev, unsigned int enabled)
+{
+	struct platform_device *plat_dev = to_platform_device(dev);
+	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
+
+	rtc->uie_rtctimer.enabled = enabled;
+
 	return 0;
 }
 
@@ -50,12 +94,11 @@ static int test_rtc_proc(struct device *dev, struct seq_file *seq)
 	return 0;
 }
 
+/* As this is a test device, I am leaving the ioctl() code here to make it
+ * simpler for those want to test. The code currently does nothing. */
 static int test_rtc_ioctl(struct device *dev, unsigned int cmd,
 	unsigned long arg)
 {
-	/* We do support interrupts, they're generated
-	 * using the sysfs interface.
-	 */
 	switch (cmd) {
 	case RTC_PIE_ON:
 	case RTC_PIE_OFF:
@@ -63,7 +106,9 @@ static int test_rtc_ioctl(struct device *dev, unsigned int cmd,
 	case RTC_UIE_OFF:
 	case RTC_AIE_ON:
 	case RTC_AIE_OFF:
-		return 0;
+		/* Return zero in case you want to process the ioctl() */
+		/*return 0;*/
+		return -ENOIOCTLCMD;
 
 	default:
 		return -ENOIOCTLCMD;
@@ -77,16 +122,22 @@ static const struct rtc_class_ops test_rtc_ops = {
 	.set_alarm = test_rtc_set_alarm,
 	.set_mmss = test_rtc_set_mmss,
 	.ioctl = test_rtc_ioctl,
+	.irq_set_state = test_rtc_irq_set_state,
+	.irq_set_freq = test_rtc_irq_set_freq,
+	.alarm_irq_enable = test_rtc_alarm_irq_enable,
+	.update_irq_enable = test_rtc_update_irq_enable,
 };
 
 static ssize_t test_irq_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
+	struct device_attribute *attr, char *buf)
 {
 	return sprintf(buf, "%d\n", 42);
 }
+
+/* We support interrupts generated using the sysfs interface. */
 static ssize_t test_irq_store(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t count)
+	struct device_attribute *attr,
+	const char *buf, size_t count)
 {
 	int retval;
 	struct platform_device *plat_dev = to_platform_device(dev);
@@ -94,11 +145,11 @@ static ssize_t test_irq_store(struct device *dev,
 
 	retval = count;
 	if (strncmp(buf, "tick", 4) == 0)
-		rtc_update_irq(rtc, 1, RTC_PF | RTC_IRQF);
+		rtc_pie_update_irq(&rtc->pie_timer);
 	else if (strncmp(buf, "alarm", 5) == 0)
-		rtc_update_irq(rtc, 1, RTC_AF | RTC_IRQF);
+		rtc_aie_update_irq(rtc);
 	else if (strncmp(buf, "update", 6) == 0)
-		rtc_update_irq(rtc, 1, RTC_UF | RTC_IRQF);
+		rtc_uie_update_irq(rtc);
 	else
 		retval = -EINVAL;
 
@@ -120,6 +171,12 @@ static int test_probe(struct platform_device *plat_dev)
 	if (err)
 		goto err;
 
+	/* If we don't set rtc->irq_freq here, a spurious periodic interrup
+	 * can cause a division by zero in the kernel. And with this driver
+	 * we certainly can generate spurious interrupts through the sys
+	 * interface. */
+	rtc->irq_freq = RTC_DEFAULT_PERIODIC_FREQ;
+
 	platform_set_drvdata(plat_dev, rtc);
 
 	return 0;
-- 
1.7.3.4

