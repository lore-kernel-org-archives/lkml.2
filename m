Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab1BGVRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:17:19 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54639 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab1BGVRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:17:15 -0500
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        linux@arm.linux.org.uk
Cc: john.stultz@linaro.org, tglx@linutronix.de, a.zummo@towertech.it,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: [PATCH 4/4] RTC: sa1100: Update the sa1100 RTC driver.
Date: Mon,  7 Feb 2011 19:16:08 -0200
Message-Id: <1297113368-27174-5-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1297113368-27174-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
References: <1297113368-27174-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since PIE interrupts are now emulated, this patch removes the previous
code that used the hardware counters.

The removal of read_callback() also fixes a wrong user space behaviour
of this driver, which was not returning the right value to read().

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
---
 drivers/rtc/rtc-sa1100.c |  111 +--------------------------------------------
 1 files changed, 3 insertions(+), 108 deletions(-)

diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 6c8c74a..1ff0fac 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -43,7 +43,6 @@
 #define RTC_DEF_TRIM		0
 
 static const unsigned long RTC_FREQ = 1024;
-static unsigned long timer_freq;
 static struct rtc_time rtc_alarm;
 static DEFINE_SPINLOCK(sa1100_rtc_lock);
 
@@ -156,97 +155,11 @@ static irqreturn_t sa1100_rtc_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int sa1100_irq_set_freq(struct device *dev, int freq)
-{
-	if (freq < 1 || freq > timer_freq) {
-		return -EINVAL;
-	} else {
-		struct rtc_device *rtc = (struct rtc_device *)dev;
-
-		rtc->irq_freq = freq;
-
-		return 0;
-	}
-}
-
-static int rtc_timer1_count;
-
-static inline int sa1100_timer1_retrigger(struct rtc_device *rtc)
-{
-	unsigned long diff;
-	unsigned long period = timer_freq / rtc->irq_freq;
-
-	spin_lock_irq(&sa1100_rtc_lock);
-
-	do {
-		OSMR1 += period;
-		diff = OSMR1 - OSCR;
-		/* If OSCR > OSMR1, diff is a very large number (unsigned
-		 * math). This means we have a lost interrupt. */
-	} while (diff > period);
-	OIER |= OIER_E1;
-
-	spin_unlock_irq(&sa1100_rtc_lock);
-
-	return 0;
-}
-
-static irqreturn_t timer1_interrupt(int irq, void *dev_id)
-{
-	struct platform_device *pdev = to_platform_device(dev_id);
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
-
-	/*
-	 * If we match for the first time, rtc_timer1_count will be 1.
-	 * Otherwise, we wrapped around (very unlikely but
-	 * still possible) so compute the amount of missed periods.
-	 * The match reg is updated only when the data is actually retrieved
-	 * to avoid unnecessary interrupts.
-	 */
-	OSSR = OSSR_M1;	/* clear match on timer1 */
-
-	rtc_update_irq(rtc, rtc_timer1_count, RTC_PF | RTC_IRQF);
-
-	if (rtc_timer1_count == 1)
-		rtc_timer1_count =
-			(rtc->irq_freq * ((1 << 30) / (timer_freq >> 2)));
-
-	/* retrigger. */
-	sa1100_timer1_retrigger(rtc);
-
-	return IRQ_HANDLED;
-}
-
-static int sa1100_rtc_read_callback(struct device *dev, int data)
-{
-	if (data & RTC_PF) {
-		struct rtc_device *rtc = (struct rtc_device *)dev;
-
-		/* interpolate missed periods and set match for the next */
-		unsigned long period = timer_freq / rtc->irq_freq;
-		unsigned long oscr = OSCR;
-		unsigned long osmr1 = OSMR1;
-		unsigned long missed = (oscr - osmr1)/period;
-		data += missed << 8;
-		OSSR = OSSR_M1;	/* clear match on timer 1 */
-		OSMR1 = osmr1 + (missed + 1)*period;
-		/* Ensure we didn't miss another match in the mean time.
-		 * Here we compare (match - OSCR) 8 instead of 0 --
-		 * see comment in pxa_timer_interrupt() for explanation.
-		 */
-		while ((signed long)((osmr1 = OSMR1) - OSCR) <= 8) {
-			data += 0x100;
-			OSSR = OSSR_M1;	/* clear match on timer 1 */
-			OSMR1 = osmr1 + period;
-		}
-	}
-	return data;
-}
-
 static int sa1100_rtc_open(struct device *dev)
 {
 	int ret;
-	struct rtc_device *rtc = (struct rtc_device *)dev;
+	struct platform_device *plat_dev = to_platform_device(dev);
+	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
 
 	ret = request_irq(IRQ_RTC1Hz, sa1100_rtc_interrupt, IRQF_DISABLED,
 		"rtc 1Hz", dev);
@@ -260,19 +173,11 @@ static int sa1100_rtc_open(struct device *dev)
 		dev_err(dev, "IRQ %d already in use.\n", IRQ_RTCAlrm);
 		goto fail_ai;
 	}
-	ret = request_irq(IRQ_OST1, timer1_interrupt, IRQF_DISABLED,
-		"rtc timer", dev);
-	if (ret) {
-		dev_err(dev, "IRQ %d already in use.\n", IRQ_OST1);
-		goto fail_pi;
-	}
 	rtc->max_user_freq = RTC_FREQ;
-	sa1100_irq_set_freq(dev, RTC_FREQ);
+	rtc_irq_set_freq(rtc, NULL, RTC_FREQ);
 
 	return 0;
 
- fail_pi:
-	free_irq(IRQ_RTCAlrm, dev);
  fail_ai:
 	free_irq(IRQ_RTC1Hz, dev);
  fail_ui:
@@ -287,12 +192,10 @@ static void sa1100_rtc_release(struct device *dev)
 	OSSR = OSSR_M1;
 	spin_unlock_irq(&sa1100_rtc_lock);
 
-	free_irq(IRQ_OST1, dev);
 	free_irq(IRQ_RTCAlrm, dev);
 	free_irq(IRQ_RTC1Hz, dev);
 }
 
-
 static int sa1100_rtc_ioctl(struct device *dev, unsigned int cmd,
 		unsigned long arg)
 {
@@ -366,7 +269,6 @@ static int sa1100_rtc_proc(struct device *dev, struct seq_file *seq)
 
 static const struct rtc_class_ops sa1100_rtc_ops = {
 	.open = sa1100_rtc_open,
-	.read_callback = sa1100_rtc_read_callback,
 	.release = sa1100_rtc_release,
 	.ioctl = sa1100_rtc_ioctl,
 	.read_time = sa1100_rtc_read_time,
@@ -380,8 +282,6 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 
-	timer_freq = get_clock_tick_rate();
-
 	/*
 	 * According to the manual we should be able to let RTTR be zero
 	 * and then a default diviser for a 32.768KHz clock is used.
@@ -407,11 +307,6 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rtc);
 
-	/* Set the irq_freq */
-	/*TODO: Find out who is messing with this value after we initialize
-	 * it here.*/
-	rtc->irq_freq = RTC_FREQ;
-
 	/* Fix for a nasty initialization problem the in SA11xx RTSR register.
 	 * See also the comments in sa1100_rtc_interrupt().
 	 *
-- 
1.7.3.4

