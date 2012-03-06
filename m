Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab2CFXgL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 18:36:11 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47211 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346Ab2CFXgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 18:36:09 -0500
Message-ID: <1331076961.2191.165.camel@work-vm>
Subject: Re: RTC regression
From: John Stultz <john.stultz@linaro.org>
To: Richard Weinberger <richard@nod.at>
Cc: Thomas Gleixner <tglx@linutronix.de>, a.zummo@towertech.it,
        rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 06 Mar 2012 15:36:01 -0800
In-Reply-To: <4F4E9B71.2010407@nod.at>
References: <4F4E9B71.2010407@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030623-7182-0000-0000-000000FAF845
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 22:41 +0100, Richard Weinberger wrote:
> Hi!
> 
> hwclock calls the RTC_UIE_ON ioctl to wait for a timer tick.
> If RTC_UIE_ON was successful it opens /dev/rtcX and waits up to 5 seconds using select()
> for a tick.
> Some RTC drivers have no support for RTC_UIE_ON and ioctl just returns -EINVAL.
> Drivers indicated this by setting rtc_class_ops->update_irq_enable to NULL.
> In this case hwclock waits in a busy loop for the next timer tick.
> 
> These two commits changed this behavior:
> 6610e08 (RTC: Rework RTC code to use timerqueue for events)
> 51ba60c (RTC: Cleanup rtc_class_ops->update_irq_enable())
> 
> rtc_class_ops->update_irq_enable was removed and rtc_update_irq_enable()
> is now using rtc_class_ops->set_alarm instead of rtc_class_ops->update_irq_enable.
> 
> Some RTC devices (like mpc515x) don't support intervals smaller than one
> minute.
> rtc-mpc5121.c deals with this by rounding up to one minute.
> But now after commit 6610e08 RTC_UIE_ON will no longer return -EINVAL and
> the next tick comes somewhen within the next 60 seconds, because the driver rounded up...
> hwclock's select() is not happy about this and timeouts in most cases.

Thanks for diagnosing and pointing out this issue! I hadn't been aware
of such hardware.

Would something like the following be a better generic interface?
Basically allow the RTC drivers to flag that UIE is unsupported (much as
setting the update_irq_enable to null did prior).

Let me know if this works for you, and I'll look to see what other
drivers might be affected here.

thanks
-john

Add generic infrastructure to handle rtc devices that don't support UIE
mode.

Signed-off-by: John Stultz <john.stultz@linaro.org>

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index dc87eda..eb415bd 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -458,6 +458,11 @@ int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled)
 	if (rtc->uie_rtctimer.enabled == enabled)
 		goto out;
 
+	if (rtc->uie_unsupported) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	if (enabled) {
 		struct rtc_time tm;
 		ktime_t now, onesec;
diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index 9d3cacc..be6d4f4 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -360,6 +360,8 @@ static int __devinit mpc5121_rtc_probe(struct platform_device *op)
 						&mpc5200_rtc_ops, THIS_MODULE);
 	}
 
+	rtc->rtc.uie_unsupported = 1;
+
 	if (IS_ERR(rtc->rtc)) {
 		err = PTR_ERR(rtc->rtc);
 		goto out_free_irq;
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 93f4d03..fcabfb4 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -202,7 +202,8 @@ struct rtc_device
 	struct hrtimer pie_timer; /* sub second exp, so needs hrtimer */
 	int pie_enabled;
 	struct work_struct irqwork;
-
+	/* Some hardware can't support UIE mode */
+	int uie_unsupported;
 
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	struct work_struct uie_task;


