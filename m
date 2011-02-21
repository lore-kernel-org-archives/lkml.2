Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1BUX5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:57:43 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49179 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab1BUXzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:55:55 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 08/10] RTC: Fix the cross interrupt issue on rtc-test.
Date: Mon, 21 Feb 2011 15:55:36 -0800
Message-Id: <1298332538-31216-9-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>

The rtc-test driver is meant to provide a test/debug code for the RTC
subsystem.

The rtc-test driver simulates specific interrupts by echoing to the
sys interface. Those were the update, alarm and periodic interrupts.

As a side effect of the new implementation, any interrupt generated in
the rtc-test driver would trigger the same code path in the generic
code, and thus the distinction among interrupts gets lost.

This patch preserves the previous behaviour of the rtc-test driver,
where e.g. an update interrupt would not trigger an alarm or periodic
interrupt, and vice-versa. In real world RTC drivers, this is not an
issue, but in the rtc-test driver it may be interesting to distinguish
these interrupts for testing purposes.

CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
CC: rtc-linux@googlegroups.com
Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-test.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index 61ad5ab..34d5631 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -71,11 +71,16 @@ static ssize_t test_irq_store(struct device *dev,
 	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
 
 	retval = count;
-	if (strncmp(buf, "tick", 4) == 0)
+	if (strncmp(buf, "tick", 4) == 0 && rtc->pie_enabled)
 		rtc_update_irq(rtc, 1, RTC_PF | RTC_IRQF);
-	else if (strncmp(buf, "alarm", 5) == 0)
-		rtc_update_irq(rtc, 1, RTC_AF | RTC_IRQF);
-	else if (strncmp(buf, "update", 6) == 0)
+	else if (strncmp(buf, "alarm", 5) == 0) {
+		struct rtc_wkalrm alrm;
+		int err = rtc_read_alarm(rtc, &alrm);
+
+		if (!err && alrm.enabled)
+			rtc_update_irq(rtc, 1, RTC_AF | RTC_IRQF);
+
+	} else if (strncmp(buf, "update", 6) == 0 && rtc->uie_rtctimer.enabled)
 		rtc_update_irq(rtc, 1, RTC_UF | RTC_IRQF);
 	else
 		retval = -EINVAL;
-- 
1.7.3.2.146.gca209

