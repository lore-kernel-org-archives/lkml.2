Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1KFQrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 11:47:18 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63028 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1KFQq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 11:46:58 -0500
From: Yauhen Kharuzhy <jekhor@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Daniel Mack <daniel@caiaq.de>, Yauhen Kharuzhy <jekhor@gmail.com>
Subject: [PATCH 1/2] RTC MXC: Fix setting time for MX1 SoC
Date: Sun,  6 Nov 2011 19:46:45 +0300
Message-Id: <1320598006-17678-2-git-send-email-jekhor@gmail.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1320598006-17678-1-git-send-email-jekhor@gmail.com>
References: <1320598006-17678-1-git-send-email-jekhor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no way to track year in the i.MX1 RTC: Days Counter register is
9-bit wide only. Attempt to save date after 1970-01-01 plus 512 days
causes endless loop in mxc_rtc_set_mmss(). Fix this by resetting year to
1970.

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
---
 drivers/rtc/rtc-mxc.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 39e41fb..1cf6a0b 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -290,6 +290,17 @@ static int mxc_rtc_read_time(struct device *dev, struct rtc_time *tm)
  */
 static int mxc_rtc_set_mmss(struct device *dev, unsigned long time)
 {
+	/* RTC_DAYR register is 9-bit in MX1 SoC,
+	 * save time and day of year only
+	 */
+	if (cpu_is_mx1()) {
+		struct rtc_time tm;
+
+		rtc_time_to_tm(time, &tm);
+		tm.tm_year = 70;
+		rtc_tm_to_time(&tm, &time);
+	}
+
 	/* Avoid roll-over from reading the different registers */
 	do {
 		set_alarm_or_time(dev, MXC_RTC_TIME, time);
-- 
1.7.7.1

