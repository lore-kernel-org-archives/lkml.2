Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab1FYImU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 04:42:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:55976 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab1FYImQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 04:42:16 -0400
Date: Sat, 25 Jun 2011 10:42:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timer fixes for 3.0
Message-ID: <alpine.LFD.2.02.1106251035220.11814@ionos>
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

Please pull the latest timer-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timer-fixes-for-linus

Thanks,

	tglx

------------------>
Alexey Charkov (1):
      rtc: vt8500: Fix build error & cleanup rtc_class_ops->update_irq_enable()

John Stultz (2):
      alarmtimers: Handle late rtc module loading
      alarmtimers: Return -ENOTSUPP if no RTC device is present


 drivers/rtc/rtc-vt8500.c |   45 +------------
 kernel/time/alarmtimer.c |  158 +++++++++++++++++++++++++--------------------
 2 files changed, 91 insertions(+), 112 deletions(-)

diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index b8bc862..efd6066 100644
--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -78,7 +78,6 @@ struct vt8500_rtc {
 	void __iomem		*regbase;
 	struct resource		*res;
 	int			irq_alarm;
-	int			irq_hz;
 	struct rtc_device	*rtc;
 	spinlock_t		lock;		/* Protects this structure */
 };
@@ -100,10 +99,6 @@ static irqreturn_t vt8500_rtc_irq(int irq, void *dev_id)
 	if (isr & 1)
 		events |= RTC_AF | RTC_IRQF;
 
-	/* Only second/minute interrupts are supported */
-	if (isr & 2)
-		events |= RTC_UF | RTC_IRQF;
-
 	rtc_update_irq(vt8500_rtc->rtc, 1, events);
 
 	return IRQ_HANDLED;
@@ -199,27 +194,12 @@ static int vt8500_alarm_irq_enable(struct device *dev, unsigned int enabled)
 	return 0;
 }
 
-static int vt8500_update_irq_enable(struct device *dev, unsigned int enabled)
-{
-	struct vt8500_rtc *vt8500_rtc = dev_get_drvdata(dev);
-	unsigned long tmp = readl(vt8500_rtc->regbase + VT8500_RTC_CR);
-
-	if (enabled)
-		tmp |= VT8500_RTC_CR_SM_SEC | VT8500_RTC_CR_SM_ENABLE;
-	else
-		tmp &= ~VT8500_RTC_CR_SM_ENABLE;
-
-	writel(tmp, vt8500_rtc->regbase + VT8500_RTC_CR);
-	return 0;
-}
-
 static const struct rtc_class_ops vt8500_rtc_ops = {
 	.read_time = vt8500_rtc_read_time,
 	.set_time = vt8500_rtc_set_time,
 	.read_alarm = vt8500_rtc_read_alarm,
 	.set_alarm = vt8500_rtc_set_alarm,
 	.alarm_irq_enable = vt8500_alarm_irq_enable,
-	.update_irq_enable = vt8500_update_irq_enable,
 };
 
 static int __devinit vt8500_rtc_probe(struct platform_device *pdev)
@@ -248,13 +228,6 @@ static int __devinit vt8500_rtc_probe(struct platform_device *pdev)
 		goto err_free;
 	}
 
-	vt8500_rtc->irq_hz = platform_get_irq(pdev, 1);
-	if (vt8500_rtc->irq_hz < 0) {
-		dev_err(&pdev->dev, "No 1Hz IRQ resource defined\n");
-		ret = -ENXIO;
-		goto err_free;
-	}
-
 	vt8500_rtc->res = request_mem_region(vt8500_rtc->res->start,
 					     resource_size(vt8500_rtc->res),
 					     "vt8500-rtc");
@@ -272,9 +245,8 @@ static int __devinit vt8500_rtc_probe(struct platform_device *pdev)
 		goto err_release;
 	}
 
-	/* Enable the second/minute interrupt generation and enable RTC */
-	writel(VT8500_RTC_CR_ENABLE | VT8500_RTC_CR_24H
-		| VT8500_RTC_CR_SM_ENABLE | VT8500_RTC_CR_SM_SEC,
+	/* Enable RTC and set it to 24-hour mode */
+	writel(VT8500_RTC_CR_ENABLE | VT8500_RTC_CR_24H,
 	       vt8500_rtc->regbase + VT8500_RTC_CR);
 
 	vt8500_rtc->rtc = rtc_device_register("vt8500-rtc", &pdev->dev,
@@ -286,26 +258,16 @@ static int __devinit vt8500_rtc_probe(struct platform_device *pdev)
 		goto err_unmap;
 	}
 
-	ret = request_irq(vt8500_rtc->irq_hz, vt8500_rtc_irq, 0,
-			  "rtc 1Hz", vt8500_rtc);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "can't get irq %i, err %d\n",
-			vt8500_rtc->irq_hz, ret);
-		goto err_unreg;
-	}
-
 	ret = request_irq(vt8500_rtc->irq_alarm, vt8500_rtc_irq, 0,
 			  "rtc alarm", vt8500_rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can't get irq %i, err %d\n",
 			vt8500_rtc->irq_alarm, ret);
-		goto err_free_hz;
+		goto err_unreg;
 	}
 
 	return 0;
 
-err_free_hz:
-	free_irq(vt8500_rtc->irq_hz, vt8500_rtc);
 err_unreg:
 	rtc_device_unregister(vt8500_rtc->rtc);
 err_unmap:
@@ -323,7 +285,6 @@ static int __devexit vt8500_rtc_remove(struct platform_device *pdev)
 	struct vt8500_rtc *vt8500_rtc = platform_get_drvdata(pdev);
 
 	free_irq(vt8500_rtc->irq_alarm, vt8500_rtc);
-	free_irq(vt8500_rtc->irq_hz, vt8500_rtc);
 
 	rtc_device_unregister(vt8500_rtc->rtc);
 
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 2d96624..59f369f 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -42,15 +42,75 @@ static struct alarm_base {
 	clockid_t		base_clockid;
 } alarm_bases[ALARM_NUMTYPE];
 
+/* freezer delta & lock used to handle clock_nanosleep triggered wakeups */
+static ktime_t freezer_delta;
+static DEFINE_SPINLOCK(freezer_delta_lock);
+
 #ifdef CONFIG_RTC_CLASS
 /* rtc timer and device for setting alarm wakeups at suspend */
 static struct rtc_timer		rtctimer;
 static struct rtc_device	*rtcdev;
-#endif
+static DEFINE_SPINLOCK(rtcdev_lock);
 
-/* freezer delta & lock used to handle clock_nanosleep triggered wakeups */
-static ktime_t freezer_delta;
-static DEFINE_SPINLOCK(freezer_delta_lock);
+/**
+ * has_wakealarm - check rtc device has wakealarm ability
+ * @dev: current device
+ * @name_ptr: name to be returned
+ *
+ * This helper function checks to see if the rtc device can wake
+ * from suspend.
+ */
+static int has_wakealarm(struct device *dev, void *name_ptr)
+{
+	struct rtc_device *candidate = to_rtc_device(dev);
+
+	if (!candidate->ops->set_alarm)
+		return 0;
+	if (!device_may_wakeup(candidate->dev.parent))
+		return 0;
+
+	*(const char **)name_ptr = dev_name(dev);
+	return 1;
+}
+
+/**
+ * alarmtimer_get_rtcdev - Return selected rtcdevice
+ *
+ * This function returns the rtc device to use for wakealarms.
+ * If one has not already been chosen, it checks to see if a
+ * functional rtc device is available.
+ */
+static struct rtc_device *alarmtimer_get_rtcdev(void)
+{
+	struct device *dev;
+	char *str;
+	unsigned long flags;
+	struct rtc_device *ret;
+
+	spin_lock_irqsave(&rtcdev_lock, flags);
+	if (!rtcdev) {
+		/* Find an rtc device and init the rtc_timer */
+		dev = class_find_device(rtc_class, NULL, &str, has_wakealarm);
+		/* If we have a device then str is valid. See has_wakealarm() */
+		if (dev) {
+			rtcdev = rtc_class_open(str);
+			/*
+			 * Drop the reference we got in class_find_device,
+			 * rtc_open takes its own.
+			 */
+			put_device(dev);
+			rtc_timer_init(&rtctimer, NULL, NULL);
+		}
+	}
+	ret = rtcdev;
+	spin_unlock_irqrestore(&rtcdev_lock, flags);
+
+	return ret;
+}
+#else
+#define alarmtimer_get_rtcdev() (0)
+#define rtcdev (0)
+#endif
 
 
 /**
@@ -166,6 +226,7 @@ static int alarmtimer_suspend(struct device *dev)
 	struct rtc_time tm;
 	ktime_t min, now;
 	unsigned long flags;
+	struct rtc_device *rtc;
 	int i;
 
 	spin_lock_irqsave(&freezer_delta_lock, flags);
@@ -173,8 +234,9 @@ static int alarmtimer_suspend(struct device *dev)
 	freezer_delta = ktime_set(0, 0);
 	spin_unlock_irqrestore(&freezer_delta_lock, flags);
 
+	rtc = rtcdev;
 	/* If we have no rtcdev, just return */
-	if (!rtcdev)
+	if (!rtc)
 		return 0;
 
 	/* Find the soonest timer to expire*/
@@ -199,12 +261,12 @@ static int alarmtimer_suspend(struct device *dev)
 	WARN_ON(min.tv64 < NSEC_PER_SEC);
 
 	/* Setup an rtc timer to fire that far in the future */
-	rtc_timer_cancel(rtcdev, &rtctimer);
-	rtc_read_time(rtcdev, &tm);
+	rtc_timer_cancel(rtc, &rtctimer);
+	rtc_read_time(rtc, &tm);
 	now = rtc_tm_to_ktime(tm);
 	now = ktime_add(now, min);
 
-	rtc_timer_start(rtcdev, &rtctimer, now, ktime_set(0, 0));
+	rtc_timer_start(rtc, &rtctimer, now, ktime_set(0, 0));
 
 	return 0;
 }
@@ -322,6 +384,9 @@ static int alarm_clock_getres(const clockid_t which_clock, struct timespec *tp)
 {
 	clockid_t baseid = alarm_bases[clock2alarm(which_clock)].base_clockid;
 
+	if (!alarmtimer_get_rtcdev())
+		return -ENOTSUPP;
+
 	return hrtimer_get_res(baseid, tp);
 }
 
@@ -336,6 +401,9 @@ static int alarm_clock_get(clockid_t which_clock, struct timespec *tp)
 {
 	struct alarm_base *base = &alarm_bases[clock2alarm(which_clock)];
 
+	if (!alarmtimer_get_rtcdev())
+		return -ENOTSUPP;
+
 	*tp = ktime_to_timespec(base->gettime());
 	return 0;
 }
@@ -351,6 +419,9 @@ static int alarm_timer_create(struct k_itimer *new_timer)
 	enum  alarmtimer_type type;
 	struct alarm_base *base;
 
+	if (!alarmtimer_get_rtcdev())
+		return -ENOTSUPP;
+
 	if (!capable(CAP_WAKE_ALARM))
 		return -EPERM;
 
@@ -385,6 +456,9 @@ static void alarm_timer_get(struct k_itimer *timr,
  */
 static int alarm_timer_del(struct k_itimer *timr)
 {
+	if (!rtcdev)
+		return -ENOTSUPP;
+
 	alarm_cancel(&timr->it.alarmtimer);
 	return 0;
 }
@@ -402,6 +476,9 @@ static int alarm_timer_set(struct k_itimer *timr, int flags,
 				struct itimerspec *new_setting,
 				struct itimerspec *old_setting)
 {
+	if (!rtcdev)
+		return -ENOTSUPP;
+
 	/* Save old values */
 	old_setting->it_interval =
 			ktime_to_timespec(timr->it.alarmtimer.period);
@@ -541,6 +618,9 @@ static int alarm_timer_nsleep(const clockid_t which_clock, int flags,
 	int ret = 0;
 	struct restart_block *restart;
 
+	if (!alarmtimer_get_rtcdev())
+		return -ENOTSUPP;
+
 	if (!capable(CAP_WAKE_ALARM))
 		return -EPERM;
 
@@ -638,65 +718,3 @@ static int __init alarmtimer_init(void)
 }
 device_initcall(alarmtimer_init);
 
-#ifdef CONFIG_RTC_CLASS
-/**
- * has_wakealarm - check rtc device has wakealarm ability
- * @dev: current device
- * @name_ptr: name to be returned
- *
- * This helper function checks to see if the rtc device can wake
- * from suspend.
- */
-static int __init has_wakealarm(struct device *dev, void *name_ptr)
-{
-	struct rtc_device *candidate = to_rtc_device(dev);
-
-	if (!candidate->ops->set_alarm)
-		return 0;
-	if (!device_may_wakeup(candidate->dev.parent))
-		return 0;
-
-	*(const char **)name_ptr = dev_name(dev);
-	return 1;
-}
-
-/**
- * alarmtimer_init_late - Late initializing of alarmtimer code
- *
- * This function locates a rtc device to use for wakealarms.
- * Run as late_initcall to make sure rtc devices have been
- * registered.
- */
-static int __init alarmtimer_init_late(void)
-{
-	struct device *dev;
-	char *str;
-
-	/* Find an rtc device and init the rtc_timer */
-	dev = class_find_device(rtc_class, NULL, &str, has_wakealarm);
-	/* If we have a device then str is valid. See has_wakealarm() */
-	if (dev) {
-		rtcdev = rtc_class_open(str);
-		/*
-		 * Drop the reference we got in class_find_device,
-		 * rtc_open takes its own.
-		 */
-		put_device(dev);
-	}
-	if (!rtcdev) {
-		printk(KERN_WARNING "No RTC device found, ALARM timers will"
-			" not wake from suspend");
-	}
-	rtc_timer_init(&rtctimer, NULL, NULL);
-
-	return 0;
-}
-#else
-static int __init alarmtimer_init_late(void)
-{
-	printk(KERN_WARNING "Kernel not built with RTC support, ALARM timers"
-		" will not wake from suspend");
-	return 0;
-}
-#endif
-late_initcall(alarmtimer_init_late);
