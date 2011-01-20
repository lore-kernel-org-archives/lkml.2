Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab1ATX02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 18:26:28 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48771 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950Ab1ATX01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 18:26:27 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] RTC: Properly handle rtc_read_alarm error propagation and fix bug
Date: Thu, 20 Jan 2011 15:26:13 -0800
Message-Id: <1295565973-14358-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1295565973-14358-1-git-send-email-john.stultz@linaro.org>
References: <1295565973-14358-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In reviewing cases where the virtualized interfaces didn't propagate
errors properly, I noticed rtc_read_alarm needed fixing. In doing
so I noticed my RTC rework dropped a memset and that the behavior
of rtc_read_alarm shouldn't be conditionalized on the alarm.enabled
flag (as the alarm may be set, but the irqs may be disabled). So
those were corrected as well.

CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/interface.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index f1ba2c6..925006d 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -123,12 +123,18 @@ int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	err = mutex_lock_interruptible(&rtc->ops_lock);
 	if (err)
 		return err;
-	alarm->enabled = rtc->aie_timer.enabled;
-	if (alarm->enabled)
+	if (rtc->ops == NULL)
+		err = -ENODEV;
+	else if (!rtc->ops->read_alarm)
+		err = -EINVAL;
+	else {
+		memset(alarm, 0, sizeof(struct rtc_wkalrm));
+		alarm->enabled = rtc->aie_timer.enabled;
 		alarm->time = rtc_ktime_to_tm(rtc->aie_timer.node.expires);
+	}
 	mutex_unlock(&rtc->ops_lock);
 
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(rtc_read_alarm);
 
-- 
1.7.3.2.146.gca209

