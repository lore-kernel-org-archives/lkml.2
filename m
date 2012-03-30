Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965487Ab2C3VQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:16:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935884Ab2C3VQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:16:29 -0400
Message-Id: <20120330194904.203077218@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:51:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Richard Weinberger <richard@nod.at>,
        John Stultz <john.stultz@linaro.org>
Subject: [ 147/149] rtc: Provide flag for rtc devices that dont support UIE
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit 4a649903f91232d02284d53724b0a45728111767 upstream.

Richard Weinberger noticed that on some RTC hardware that
doesn't support UIE mode, due to coarse granular alarms
(like 1minute resolution), the current virtualized RTC
support doesn't properly error out when UIE is enabled.

Instead the current code queues an alarm for the next second,
but it won't fire until up to a miniute later.

This patch provides a generic way to flag this sort of hardware
and fixes the issue on the mpc5121 where Richard noticed the
problem.

Reported-by: Richard Weinberger <richard@nod.at>
Tested-by: Richard Weinberger <richard@nod.at>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/interface.c   |    5 +++++
 drivers/rtc/rtc-mpc5121.c |    2 ++
 include/linux/rtc.h       |    3 ++-
 3 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -445,6 +445,11 @@ int rtc_update_irq_enable(struct rtc_dev
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
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -360,6 +360,8 @@ static int __devinit mpc5121_rtc_probe(s
 						&mpc5200_rtc_ops, THIS_MODULE);
 	}
 
+	rtc->rtc->uie_unsupported = 1;
+
 	if (IS_ERR(rtc->rtc)) {
 		err = PTR_ERR(rtc->rtc);
 		goto out_free_irq;
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


