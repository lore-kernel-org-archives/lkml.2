Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab2K2CVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 21:21:36 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:54450 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752199Ab2K2CVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 21:21:34 -0500
From: Chao Xie <chao.xie@marvell.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, haojian.zhuang@gmail.com,
        linux-arm-kernel@lists.infradead.org, xiechao.mail@gmail.com
Subject: [PATCH 2/4] rtc: pxa: fix rtc caculation issue
Date: Wed, 28 Nov 2012 21:21:08 -0500
Message-Id: <1354155670-6267-2-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354155670-6267-1-git-send-email-chao.xie@marvell.com>
References: <1354155670-6267-1-git-send-email-chao.xie@marvell.com>
X-OriginalArrivalTime: 29 Nov 2012 02:21:02.0469 (UTC) FILETIME=[2D908B50:01CDCDD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original calculation does not take care of week-of-month and
day-of-week. It will make rdar/rdcr not matched when set the
alarm.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/rtc/rtc-pxa.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index f771b2e..22ea4f5 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -62,6 +62,10 @@
 #define RYxR_MONTH_S	5
 #define RYxR_MONTH_MASK	(0xf << RYxR_MONTH_S)
 #define RYxR_DAY_MASK	0x1f
+#define RDxR_WOM_S	20
+#define RDxR_WOM_MASK	(0x7 << RDxR_WOM_S)
+#define RDxR_DOW_S	17
+#define RDxR_DOW_MASK	(0x7 << RDxR_DOW_S)
 #define RDxR_HOUR_S	12
 #define RDxR_HOUR_MASK	(0x1f << RDxR_HOUR_S)
 #define RDxR_MIN_S	6
@@ -100,7 +104,10 @@ static u32 ryxr_calc(struct rtc_time *tm)
 
 static u32 rdxr_calc(struct rtc_time *tm)
 {
-	return (tm->tm_hour << RDxR_HOUR_S) | (tm->tm_min << RDxR_MIN_S)
+	return ((((tm->tm_mday + 6) / 7) << RDxR_WOM_S) & RDxR_WOM_MASK)
+		| (((tm->tm_wday + 1) << RDxR_DOW_S) & RDxR_DOW_MASK)
+		| (tm->tm_hour << RDxR_HOUR_S)
+		| (tm->tm_min << RDxR_MIN_S)
 		| tm->tm_sec;
 }
 
@@ -109,6 +116,7 @@ static void tm_calc(u32 rycr, u32 rdcr, struct rtc_time *tm)
 	tm->tm_year = ((rycr & RYxR_YEAR_MASK) >> RYxR_YEAR_S) - 1900;
 	tm->tm_mon = (((rycr & RYxR_MONTH_MASK) >> RYxR_MONTH_S)) - 1;
 	tm->tm_mday = (rycr & RYxR_DAY_MASK);
+	tm->tm_wday = ((rdcr & RDxR_DOW_MASK) >> RDxR_DOW_S) - 1;
 	tm->tm_hour = (rdcr & RDxR_HOUR_MASK) >> RDxR_HOUR_S;
 	tm->tm_min = (rdcr & RDxR_MIN_MASK) >> RDxR_MIN_S;
 	tm->tm_sec = rdcr & RDxR_SEC_MASK;
-- 
1.7.4.1

