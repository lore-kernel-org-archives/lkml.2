Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab1BCCO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 21:14:59 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:34072 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab1BCCO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 21:14:56 -0500
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 1/4] RTC: Prevents a division by zero in kernel code.
Date: Wed,  2 Feb 2011 18:14:40 -0800
Message-Id: <1296699283-6784-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1296699283-6784-1-git-send-email-john.stultz@linaro.org>
References: <1296699283-6784-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>

This patch prevents a user space program from calling the RTC_IRQP_SET
ioctl with a negative value of frequency. Also, if this call is make
with a zero value of frequency, there would be a division by zero in the
kernel code.

[jstultz: Also initialize irq_freq to 1 to catch other divbyzero issues]

CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/class.c     |    1 +
 drivers/rtc/interface.c |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 9583cbc..c404b61 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -143,6 +143,7 @@ struct rtc_device *rtc_device_register(const char *name, struct device *dev,
 	rtc->id = id;
 	rtc->ops = ops;
 	rtc->owner = owner;
+	rtc->irq_freq = 1;
 	rtc->max_user_freq = 64;
 	rtc->dev.parent = dev;
 	rtc->dev.class = rtc_class;
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 925006d..a0c0196 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -464,6 +464,9 @@ int rtc_irq_set_freq(struct rtc_device *rtc, struct rtc_task *task, int freq)
 	int err = 0;
 	unsigned long flags;
 
+	if (freq <= 0)
+		return -EINVAL;
+
 	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task != NULL && task == NULL)
 		err = -EBUSY;
-- 
1.7.3.2.146.gca209

