Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab1DPKJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 06:09:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46762 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab1DPKJW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 06:09:22 -0400
Date: Sat, 16 Apr 2011 12:09:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20110416100910.GA10543@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timer-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timer-fixes-for-linus

 Thanks,

	Ingo

------------------>
Feng Tang (1):
      RTC: rtc-mrst: follow on to the change of rtc_device_register()

John Stultz (1):
      RTC: Fix early irqs caused by calling rtc_set_alarm too early

Mike Frysinger (1):
      RTC: add missing "return 0" in new alarm func for rtc-bfin.c

Vasily Khoruzhick (1):
      RTC: Fix s3c compile error due to missing s3c_rtc_setpie


 drivers/rtc/class.c     |    2 +-
 drivers/rtc/interface.c |   26 ++++++++++++++++++++++++++
 drivers/rtc/rtc-bfin.c  |    2 ++
 drivers/rtc/rtc-s3c.c   |    2 --
 include/linux/rtc.h     |    2 ++
 5 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 09b4437..3901386 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -171,7 +171,7 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 	err = __rtc_read_alarm(rtc, &alrm);
 
 	if (!err && !rtc_valid_tm(&alrm.time))
-		rtc_set_alarm(rtc, &alrm);
+		rtc_initialize_alarm(rtc, &alrm);
 
 	strlcpy(rtc->name, name, RTC_DEVICE_NAME_SIZE);
 	dev_set_name(&rtc->dev, "rtc%d", id);
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 23719f0..ef6316a 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -375,6 +375,32 @@ int rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 }
 EXPORT_SYMBOL_GPL(rtc_set_alarm);
 
+/* Called once per device from rtc_device_register */
+int rtc_initialize_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
+{
+	int err;
+
+	err = rtc_valid_tm(&alarm->time);
+	if (err != 0)
+		return err;
+
+	err = mutex_lock_interruptible(&rtc->ops_lock);
+	if (err)
+		return err;
+
+	rtc->aie_timer.node.expires = rtc_tm_to_ktime(alarm->time);
+	rtc->aie_timer.period = ktime_set(0, 0);
+	if (alarm->enabled) {
+		rtc->aie_timer.enabled = 1;
+		timerqueue_add(&rtc->timerqueue, &rtc->aie_timer.node);
+	}
+	mutex_unlock(&rtc->ops_lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(rtc_initialize_alarm);
+
+
+
 int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 {
 	int err = mutex_lock_interruptible(&rtc->ops_lock);
diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index a0fc4cf..90d8662 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -250,6 +250,8 @@ static int bfin_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 		bfin_rtc_int_set_alarm(rtc);
 	else
 		bfin_rtc_int_clear(~(RTC_ISTAT_ALARM | RTC_ISTAT_ALARM_DAY));
+
+	return 0;
 }
 
 static int bfin_rtc_read_time(struct device *dev, struct rtc_time *tm)
diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 7149649..b3466c4 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -336,7 +336,6 @@ static void s3c_rtc_release(struct device *dev)
 
 	/* do not clear AIE here, it may be needed for wake */
 
-	s3c_rtc_setpie(dev, 0);
 	free_irq(s3c_rtc_alarmno, rtc_dev);
 	free_irq(s3c_rtc_tickno, rtc_dev);
 }
@@ -408,7 +407,6 @@ static int __devexit s3c_rtc_remove(struct platform_device *dev)
 	platform_set_drvdata(dev, NULL);
 	rtc_device_unregister(rtc);
 
-	s3c_rtc_setpie(&dev->dev, 0);
 	s3c_rtc_setaie(&dev->dev, 0);
 
 	clk_disable(rtc_clk);
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 2ca7e8a..877ece4 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -228,6 +228,8 @@ extern int rtc_read_alarm(struct rtc_device *rtc,
 			struct rtc_wkalrm *alrm);
 extern int rtc_set_alarm(struct rtc_device *rtc,
 				struct rtc_wkalrm *alrm);
+extern int rtc_initialize_alarm(struct rtc_device *rtc,
+				struct rtc_wkalrm *alrm);
 extern void rtc_update_irq(struct rtc_device *rtc,
 			unsigned long num, unsigned long events);
 
