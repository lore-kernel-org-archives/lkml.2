Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1AUQlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:41:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:50526 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab1AUQlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:41:19 -0500
Date: Fri, 21 Jan 2011 16:41:04 GMT
From: tip-bot for John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1295565973-14358-2-git-send-email-john.stultz@linaro.org>
References: <1295565973-14358-2-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] RTC: Properly handle rtc_read_alarm error propagation and fix bug
Message-ID: <tip-d5553a556165535337ece8592f066407c62eec2e@git.kernel.org>
Git-Commit-ID: d5553a556165535337ece8592f066407c62eec2e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 21 Jan 2011 16:41:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d5553a556165535337ece8592f066407c62eec2e
Gitweb:     http://git.kernel.org/tip/d5553a556165535337ece8592f066407c62eec2e
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Thu, 20 Jan 2011 15:26:13 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Jan 2011 17:38:19 +0100

RTC: Properly handle rtc_read_alarm error propagation and fix bug

In reviewing cases where the virtualized interfaces didn't propagate
errors properly, I noticed rtc_read_alarm needed fixing. In doing
so I noticed my RTC rework dropped a memset and that the behavior
of rtc_read_alarm shouldn't be conditionalized on the alarm.enabled
flag (as the alarm may be set, but the irqs may be disabled). So
those were corrected as well.

CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
LKML-Reference: <1295565973-14358-2-git-send-email-john.stultz@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
 
