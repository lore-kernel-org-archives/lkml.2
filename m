Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1IFTCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 15:02:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:52850 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab1IFTCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 15:02:03 -0400
Date: Tue, 6 Sep 2011 21:02:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, mingo@tglx.de,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer fixes for 3.1
Message-ID: <alpine.LFD.2.02.1109062100420.2723@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://tesla.tglx.de/git/linux-2.6-tip.git timers-fixes-for-linus

Top commit sha1 on my devel machine is: 486257130873a2

Thanks,

	tglx

------------------>
Axel Lin (1):
      rtc: ep93xx: Fix 'rtc' may be used uninitialized warning

Ilkka Koskinen (1):
      rtc: rtc-twl: Switch to using threaded irq

John Stultz (4):
      alarmtimers: Avoid possible null pointer traversal
      alarmtimers: Memset itimerspec passed into alarm_timer_get
      alarmtimers: Avoid possible denial of service with high freq periodic timers
      rtc: Fix RTC PIE frequency limit

Mike Waychison (1):
      rtc: Initialized rtc_time->tm_isdst

Sebastian Reichel (1):
      rtc: rtc-twl: Remove lockdep related local_irq_enable()

Todd Poynor (1):
      rtc: twl: Fix registration vs. init order


 drivers/rtc/interface.c  |    2 +-
 drivers/rtc/rtc-ep93xx.c |   16 ++++++------
 drivers/rtc/rtc-lib.c    |    2 +
 drivers/rtc/rtc-twl.c    |   60 ++++++++++++++++++---------------------------
 include/linux/rtc.h      |    3 ++
 kernel/time/alarmtimer.c |   18 ++++++++++----
 6 files changed, 51 insertions(+), 50 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 3195dbd..eb4c883 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -708,7 +708,7 @@ int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
 	int err = 0;
 	unsigned long flags;
 
-	if (freq <= 0 || freq > 5000)
+	if (freq <= 0 || freq > RTC_MAX_FREQ)
 		return -EINVAL;
 retry:
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 335551d..14a42a1 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -36,6 +36,7 @@
  */
 struct ep93xx_rtc {
 	void __iomem	*mmio_base;
+	struct rtc_device *rtc;
 };
 
 static int ep93xx_rtc_get_swcomp(struct device *dev, unsigned short *preload,
@@ -130,7 +131,6 @@ static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 {
 	struct ep93xx_rtc *ep93xx_rtc;
 	struct resource *res;
-	struct rtc_device *rtc;
 	int err;
 
 	ep93xx_rtc = devm_kzalloc(&pdev->dev, sizeof(*ep93xx_rtc), GFP_KERNEL);
@@ -151,12 +151,12 @@ static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 		return -ENXIO;
 
 	pdev->dev.platform_data = ep93xx_rtc;
-	platform_set_drvdata(pdev, rtc);
+	platform_set_drvdata(pdev, ep93xx_rtc);
 
-	rtc = rtc_device_register(pdev->name,
+	ep93xx_rtc->rtc = rtc_device_register(pdev->name,
 				&pdev->dev, &ep93xx_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		err = PTR_ERR(rtc);
+	if (IS_ERR(ep93xx_rtc->rtc)) {
+		err = PTR_ERR(ep93xx_rtc->rtc);
 		goto exit;
 	}
 
@@ -167,7 +167,7 @@ static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 fail:
-	rtc_device_unregister(rtc);
+	rtc_device_unregister(ep93xx_rtc->rtc);
 exit:
 	platform_set_drvdata(pdev, NULL);
 	pdev->dev.platform_data = NULL;
@@ -176,11 +176,11 @@ exit:
 
 static int __exit ep93xx_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
+	struct ep93xx_rtc *ep93xx_rtc = platform_get_drvdata(pdev);
 
 	sysfs_remove_group(&pdev->dev.kobj, &ep93xx_rtc_sysfs_files);
 	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(rtc);
+	rtc_device_unregister(ep93xx_rtc->rtc);
 	pdev->dev.platform_data = NULL;
 
 	return 0;
diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
index 075f170..c4cf057 100644
--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -85,6 +85,8 @@ void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
 	time -= tm->tm_hour * 3600;
 	tm->tm_min = time / 60;
 	tm->tm_sec = time - tm->tm_min * 60;
+
+	tm->tm_isdst = 0;
 }
 EXPORT_SYMBOL(rtc_time_to_tm);
 
diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 9a81f77..20687d5 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -362,14 +362,6 @@ static irqreturn_t twl_rtc_interrupt(int irq, void *rtc)
 	int res;
 	u8 rd_reg;
 
-#ifdef CONFIG_LOCKDEP
-	/* WORKAROUND for lockdep forcing IRQF_DISABLED on us, which
-	 * we don't want and can't tolerate.  Although it might be
-	 * friendlier not to borrow this thread context...
-	 */
-	local_irq_enable();
-#endif
-
 	res = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
 	if (res)
 		goto out;
@@ -428,24 +420,12 @@ static struct rtc_class_ops twl_rtc_ops = {
 static int __devinit twl_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
-	int ret = 0;
+	int ret = -EINVAL;
 	int irq = platform_get_irq(pdev, 0);
 	u8 rd_reg;
 
 	if (irq <= 0)
-		return -EINVAL;
-
-	rtc = rtc_device_register(pdev->name,
-				  &pdev->dev, &twl_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
-		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
-			PTR_ERR(rtc));
-		goto out0;
-
-	}
-
-	platform_set_drvdata(pdev, rtc);
+		goto out1;
 
 	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_STATUS_REG);
 	if (ret < 0)
@@ -462,14 +442,6 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto out1;
 
-	ret = request_irq(irq, twl_rtc_interrupt,
-				IRQF_TRIGGER_RISING,
-				dev_name(&rtc->dev), rtc);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "IRQ is not free.\n");
-		goto out1;
-	}
-
 	if (twl_class_is_6030()) {
 		twl6030_interrupt_unmask(TWL6030_RTC_INT_MASK,
 			REG_INT_MSK_LINE_A);
@@ -480,28 +452,44 @@ static int __devinit twl_rtc_probe(struct platform_device *pdev)
 	/* Check RTC module status, Enable if it is off */
 	ret = twl_rtc_read_u8(&rd_reg, REG_RTC_CTRL_REG);
 	if (ret < 0)
-		goto out2;
+		goto out1;
 
 	if (!(rd_reg & BIT_RTC_CTRL_REG_STOP_RTC_M)) {
 		dev_info(&pdev->dev, "Enabling TWL-RTC.\n");
 		rd_reg = BIT_RTC_CTRL_REG_STOP_RTC_M;
 		ret = twl_rtc_write_u8(rd_reg, REG_RTC_CTRL_REG);
 		if (ret < 0)
-			goto out2;
+			goto out1;
 	}
 
 	/* init cached IRQ enable bits */
 	ret = twl_rtc_read_u8(&rtc_irq_bits, REG_RTC_INTERRUPTS_REG);
 	if (ret < 0)
+		goto out1;
+
+	rtc = rtc_device_register(pdev->name,
+				  &pdev->dev, &twl_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		ret = PTR_ERR(rtc);
+		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
+			PTR_ERR(rtc));
+		goto out1;
+	}
+
+	ret = request_threaded_irq(irq, NULL, twl_rtc_interrupt,
+				   IRQF_TRIGGER_RISING,
+				   dev_name(&rtc->dev), rtc);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "IRQ is not free.\n");
 		goto out2;
+	}
 
-	return ret;
+	platform_set_drvdata(pdev, rtc);
+	return 0;
 
 out2:
-	free_irq(irq, rtc);
-out1:
 	rtc_device_unregister(rtc);
-out0:
+out1:
 	return ret;
 }
 
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index b27ebea..93f4d03 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -97,6 +97,9 @@ struct rtc_pll_info {
 #define RTC_AF 0x20	/* Alarm interrupt */
 #define RTC_UF 0x10	/* Update interrupt for 1Hz RTC */
 
+
+#define RTC_MAX_FREQ	8192
+
 #ifdef __KERNEL__
 
 #include <linux/types.h>
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 59f369f..ea5e1a9 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -441,6 +441,8 @@ static int alarm_timer_create(struct k_itimer *new_timer)
 static void alarm_timer_get(struct k_itimer *timr,
 				struct itimerspec *cur_setting)
 {
+	memset(cur_setting, 0, sizeof(struct itimerspec));
+
 	cur_setting->it_interval =
 			ktime_to_timespec(timr->it.alarmtimer.period);
 	cur_setting->it_value =
@@ -479,11 +481,17 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
 	if (!rtcdev)
 		return -ENOTSUPP;
 
-	/* Save old values */
-	old_setting->it_interval =
-			ktime_to_timespec(timr->it.alarmtimer.period);
-	old_setting->it_value =
-			ktime_to_timespec(timr->it.alarmtimer.node.expires);
+	/*
+	 * XXX HACK! Currently we can DOS a system if the interval
+	 * period on alarmtimers is too small. Cap the interval here
+	 * to 100us and solve this properly in a future patch! -jstultz
+	 */
+	if ((new_setting->it_interval.tv_sec == 0) &&
+			(new_setting->it_interval.tv_nsec < 100000))
+		new_setting->it_interval.tv_nsec = 100000;
+
+	if (old_setting)
+		alarm_timer_get(timr, old_setting);
 
 	/* If the timer was already set, cancel it */
 	alarm_cancel(&timr->it.alarmtimer);
