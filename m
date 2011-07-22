Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1GVJMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 05:12:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:46108 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab1GVJMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 05:12:52 -0400
Message-Id: <20110722091045.403648377@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 22 Jul 2011 09:12:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Ben Greear <greearb@candelatech.com>, stable@kernel.org
Subject: [patch 1/3] rtc: Handle errors correctly in rtc_irq_set_state()
References: <20110722091011.717194327@linutronix.de>
Content-Disposition: inline; filename=rtc-deal-with-errors-correctly.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code checks the correctness of the parameters, but unconditionally
arms/disarms the hrtimer.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@kernel.org
---
 drivers/rtc/interface.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/drivers/rtc/interface.c
===================================================================
--- linux-2.6.orig/drivers/rtc/interface.c
+++ linux-2.6/drivers/rtc/interface.c
@@ -656,6 +656,8 @@ int rtc_irq_set_state(struct rtc_device 
 		err = -EBUSY;
 	if (rtc->irq_task != task)
 		err = -EACCES;
+	if (err)
+		goto out;
 
 	if (enabled) {
 		ktime_t period = ktime_set(0, NSEC_PER_SEC/rtc->irq_freq);
@@ -664,6 +666,7 @@ int rtc_irq_set_state(struct rtc_device 
 		hrtimer_cancel(&rtc->pie_timer);
 	}
 	rtc->pie_enabled = enabled;
+out:
 	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 
 	return err;


