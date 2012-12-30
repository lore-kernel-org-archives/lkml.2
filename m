Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab2L3DEq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 22:04:46 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:53754 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab2L3DEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 22:04:45 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        rtc-linux@googlegroups.com, Tony Prisk <linux@prisktech.co.nz>,
        Edgar Toernig <froese@gmx.de>
Subject: [PATCH] rtc: vt8500: Fix handling of data passed in struct rtc_time
Date: Sun, 30 Dec 2012 16:04:46 +1300
Message-Id: <1356836686-26419-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tm_mon is 0..11, whereas vt8500 expects 1..12 for the month field,
causing invalid date errors for January, and causing the day field
to roll over incorrectly.

The century flag is only handled in vt8500_rtc_read_time, but not
set in vt8500_rtc_set_time. This patch corrects the behaviour of the
century flag.

Signed-off-by: Edgar Toernig <froese@gmx.de>
Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---

This patch is based on 3.8rc1 with the previous fix applied:

Previous patch: 77cdf96a0654cb45b4dd530f3393c6a8f2fa1e0b
rtc: vt8500: Correct handling of CR_24H bitfield

 drivers/rtc/rtc-vt8500.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index 387edf6..2448f2a 100644
--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -119,7 +119,7 @@ static int vt8500_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	tm->tm_min = bcd2bin((time & TIME_MIN_MASK) >> TIME_MIN_S);
 	tm->tm_hour = bcd2bin((time & TIME_HOUR_MASK) >> TIME_HOUR_S);
 	tm->tm_mday = bcd2bin(date & DATE_DAY_MASK);
-	tm->tm_mon = bcd2bin((date & DATE_MONTH_MASK) >> DATE_MONTH_S);
+	tm->tm_mon = bcd2bin((date & DATE_MONTH_MASK) >> DATE_MONTH_S) - 1;
 	tm->tm_year = bcd2bin((date & DATE_YEAR_MASK) >> DATE_YEAR_S)
 			+ ((date >> DATE_CENTURY_S) & 1 ? 200 : 100);
 	tm->tm_wday = (time & TIME_DOW_MASK) >> TIME_DOW_S;
@@ -138,8 +138,9 @@ static int vt8500_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	}
 
 	writel((bin2bcd(tm->tm_year - 100) << DATE_YEAR_S)
-		| (bin2bcd(tm->tm_mon) << DATE_MONTH_S)
-		| (bin2bcd(tm->tm_mday)),
+		| (bin2bcd(tm->tm_mon + 1) << DATE_MONTH_S)
+		| (bin2bcd(tm->tm_mday))
+		| ((tm->tm_year >= 200) << DATE_CENTURY_S),
 		vt8500_rtc->regbase + VT8500_RTC_DS);
 	writel((bin2bcd(tm->tm_wday) << TIME_DOW_S)
 		| (bin2bcd(tm->tm_hour) << TIME_HOUR_S)
-- 
1.7.9.5

