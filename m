Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab1BRWJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:09:42 -0500
Received: from www.tglx.de ([62.245.132.106]:41553 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab1BRWJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:09:40 -0500
Date: Fri, 18 Feb 2011 23:08:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>
Subject: [GIT pull] Final RTC fixes for 2.6.38
Message-ID: <alpine.LFD.2.00.1102182306000.2701@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1440532949-1298066931=:2701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1440532949-1298066931=:2701
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Linus,

Please pull the latest rtc-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rtc-for-linus

I wish it was samller, but it turned out due to recent bug reports
that the UIE emulation is necessary for some of the RTC chips.

Thanks,

	tglx

------------------>
John Stultz (2):
      RTC: Revert UIE emulation removal
      RTC: Re-enable UIE timer/polling emulation

Uwe Kleine-König (1):
      RTC: Release mutex in error path of rtc_alarm_irq_enable


 drivers/rtc/Kconfig     |   12 +++++
 drivers/rtc/interface.c |   23 +++++++++--
 drivers/rtc/rtc-dev.c   |  104 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/rtc.h     |   15 +++++++
 4 files changed, 150 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index cdd9719..4941cad 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -97,6 +97,18 @@ config RTC_INTF_DEV
 
 	  If unsure, say Y.
 
+config RTC_INTF_DEV_UIE_EMUL
+	bool "RTC UIE emulation on dev interface"
+	depends on RTC_INTF_DEV
+	help
+	  Provides an emulation for RTC_UIE if the underlying rtc chip
+	  driver does not expose RTC_UIE ioctls. Those requests generate
+	  once-per-second update interrupts, used for synchronization.
+
+	  The emulation code will read the time from the hardware
+	  clock several times per second, please enable this option
+	  only if you know that you really need it.
+
 config RTC_DRV_TEST
 	tristate "Test driver/device"
 	help
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index a0c0196..cb2f072 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -209,9 +209,8 @@ int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 	}
 
 	if (err)
-		return err;
-
-	if (!rtc->ops)
+		/* nothing */;
+	else if (!rtc->ops)
 		err = -ENODEV;
 	else if (!rtc->ops->alarm_irq_enable)
 		err = -EINVAL;
@@ -229,6 +228,12 @@ int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 	if (err)
 		return err;
 
+#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
+	if (enabled == 0 && rtc->uie_irq_active) {
+		mutex_unlock(&rtc->ops_lock);
+		return rtc_dev_update_irq_enable_emul(rtc, 0);
+	}
+#endif
 	/* make sure we're changing state */
 	if (rtc->uie_rtctimer.enabled == enabled)
 		goto out;
@@ -248,6 +253,16 @@ int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 
 out:
 	mutex_unlock(&rtc->ops_lock);
+#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
+	/*
+	 * Enable emulation if the driver did not provide
+	 * the update_irq_enable function pointer or if returned
+	 * -EINVAL to signal that it has been configured without
+	 * interrupts or that are not available at the moment.
+	 */
+	if (err == -EINVAL)
+		err = rtc_dev_update_irq_enable_emul(rtc, enabled);
+#endif
 	return err;
 
 }
@@ -263,7 +278,7 @@ EXPORT_SYMBOL_GPL(rtc_update_irq_enable);
  *
  * Triggers the registered irq_task function callback.
  */
-static void rtc_handle_legacy_irq(struct rtc_device *rtc, int num, int mode)
+void rtc_handle_legacy_irq(struct rtc_device *rtc, int num, int mode)
 {
 	unsigned long flags;
 
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 37c3cc1..d0e06ed 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -46,6 +46,105 @@ static int rtc_dev_open(struct inode *inode, struct file *file)
 	return err;
 }
 
+#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
+/*
+ * Routine to poll RTC seconds field for change as often as possible,
+ * after first RTC_UIE use timer to reduce polling
+ */
+static void rtc_uie_task(struct work_struct *work)
+{
+	struct rtc_device *rtc =
+		container_of(work, struct rtc_device, uie_task);
+	struct rtc_time tm;
+	int num = 0;
+	int err;
+
+	err = rtc_read_time(rtc, &tm);
+
+	spin_lock_irq(&rtc->irq_lock);
+	if (rtc->stop_uie_polling || err) {
+		rtc->uie_task_active = 0;
+	} else if (rtc->oldsecs != tm.tm_sec) {
+		num = (tm.tm_sec + 60 - rtc->oldsecs) % 60;
+		rtc->oldsecs = tm.tm_sec;
+		rtc->uie_timer.expires = jiffies + HZ - (HZ/10);
+		rtc->uie_timer_active = 1;
+		rtc->uie_task_active = 0;
+		add_timer(&rtc->uie_timer);
+	} else if (schedule_work(&rtc->uie_task) == 0) {
+		rtc->uie_task_active = 0;
+	}
+	spin_unlock_irq(&rtc->irq_lock);
+	if (num)
+		rtc_handle_legacy_irq(rtc, num, RTC_UF);
+}
+static void rtc_uie_timer(unsigned long data)
+{
+	struct rtc_device *rtc = (struct rtc_device *)data;
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtc->irq_lock, flags);
+	rtc->uie_timer_active = 0;
+	rtc->uie_task_active = 1;
+	if ((schedule_work(&rtc->uie_task) == 0))
+		rtc->uie_task_active = 0;
+	spin_unlock_irqrestore(&rtc->irq_lock, flags);
+}
+
+static int clear_uie(struct rtc_device *rtc)
+{
+	spin_lock_irq(&rtc->irq_lock);
+	if (rtc->uie_irq_active) {
+		rtc->stop_uie_polling = 1;
+		if (rtc->uie_timer_active) {
+			spin_unlock_irq(&rtc->irq_lock);
+			del_timer_sync(&rtc->uie_timer);
+			spin_lock_irq(&rtc->irq_lock);
+			rtc->uie_timer_active = 0;
+		}
+		if (rtc->uie_task_active) {
+			spin_unlock_irq(&rtc->irq_lock);
+			flush_scheduled_work();
+			spin_lock_irq(&rtc->irq_lock);
+		}
+		rtc->uie_irq_active = 0;
+	}
+	spin_unlock_irq(&rtc->irq_lock);
+	return 0;
+}
+
+static int set_uie(struct rtc_device *rtc)
+{
+	struct rtc_time tm;
+	int err;
+
+	err = rtc_read_time(rtc, &tm);
+	if (err)
+		return err;
+	spin_lock_irq(&rtc->irq_lock);
+	if (!rtc->uie_irq_active) {
+		rtc->uie_irq_active = 1;
+		rtc->stop_uie_polling = 0;
+		rtc->oldsecs = tm.tm_sec;
+		rtc->uie_task_active = 1;
+		if (schedule_work(&rtc->uie_task) == 0)
+			rtc->uie_task_active = 0;
+	}
+	rtc->irq_data = 0;
+	spin_unlock_irq(&rtc->irq_lock);
+	return 0;
+}
+
+int rtc_dev_update_irq_enable_emul(struct rtc_device *rtc, unsigned int enabled)
+{
+	if (enabled)
+		return set_uie(rtc);
+	else
+		return clear_uie(rtc);
+}
+EXPORT_SYMBOL(rtc_dev_update_irq_enable_emul);
+
+#endif /* CONFIG_RTC_INTF_DEV_UIE_EMUL */
 
 static ssize_t
 rtc_dev_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
@@ -387,6 +486,11 @@ void rtc_dev_prepare(struct rtc_device *rtc)
 
 	rtc->dev.devt = MKDEV(MAJOR(rtc_devt), rtc->id);
 
+#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
+	INIT_WORK(&rtc->uie_task, rtc_uie_task);
+	setup_timer(&rtc->uie_timer, rtc_uie_timer, (unsigned long)rtc);
+#endif
+
 	cdev_init(&rtc->char_dev, &rtc_dev_fops);
 	rtc->char_dev.owner = rtc->owner;
 }
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index a0b639f..89c3e51 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -203,6 +203,18 @@ struct rtc_device
 	struct hrtimer pie_timer; /* sub second exp, so needs hrtimer */
 	int pie_enabled;
 	struct work_struct irqwork;
+
+
+#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
+	struct work_struct uie_task;
+	struct timer_list uie_timer;
+	/* Those fields are protected by rtc->irq_lock */
+	unsigned int oldsecs;
+	unsigned int uie_irq_active:1;
+	unsigned int stop_uie_polling:1;
+	unsigned int uie_task_active:1;
+	unsigned int uie_timer_active:1;
+#endif
 };
 #define to_rtc_device(d) container_of(d, struct rtc_device, dev)
 
@@ -235,7 +247,10 @@ extern int rtc_irq_set_freq(struct rtc_device *rtc,
 				struct rtc_task *task, int freq);
 extern int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled);
 extern int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled);
+extern int rtc_dev_update_irq_enable_emul(struct rtc_device *rtc,
+						unsigned int enabled);
 
+void rtc_handle_legacy_irq(struct rtc_device *rtc, int num, int mode);
 void rtc_aie_update_irq(void *private);
 void rtc_uie_update_irq(void *private);
 enum hrtimer_restart rtc_pie_update_irq(struct hrtimer *timer);
---1463795968-1440532949-1298066931=:2701--
