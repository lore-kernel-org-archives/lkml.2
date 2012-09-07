Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464Ab2IGGId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:08:33 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:40697 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754368Ab2IGGIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:08:32 -0400
From: wzch <wzch@marvell.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Wenzeng Chen <wzch@marvell.com>, Wenzeng Chen <wzch@marvll.com>
Subject: [PATCH] rtc/pxa: fix set wrong data to RTC register issue
Date: Fri,  7 Sep 2012 14:07:57 +0800
Message-Id: <1346998077-29090-1-git-send-email-wzch@marvell.com>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 07 Sep 2012 06:08:11.0125 (UTC) FILETIME=[28972A50:01CD8CBF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wenzeng Chen <wzch@marvell.com>

Pxa rtc Day Count Register(RDCR) have 5 fields: Senconds, Minutes, Hour,
Day-of-week(DOW) and Week-of-month(WOM). If someone wants to set the
register, they can call rtc_writel(pxa_rtc, RDCR, rdxr_calc(tm)). But
currently in function rdxr_calc(), we only get the value of minutes and
hour, so we may set a wrong seconds/DOW/WOM value to RDCR register.
Adding this patch to fix the issue.

Change-Id: Iaf8cfc68c445d742637410e1bfb19e0fd7bc4a02
Signed-off-by: Wenzeng Chen <wzch@marvll.com>
---
 drivers/rtc/rtc-pxa.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index 0075c8f..5397bb5 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -60,6 +60,10 @@
 #define RYxR_MONTH_S	5
 #define RYxR_MONTH_MASK	(0xf << RYxR_MONTH_S)
 #define RYxR_DAY_MASK	0x1f
+#define RDxR_WOM_S     20
+#define RDxR_WOM_MASK  (0x7 << RDxR_WOM_S)
+#define RDxR_DOW_S     17
+#define RDxR_DOW_MASK  (0x7 << RDxR_DOW_S)
 #define RDxR_HOUR_S	12
 #define RDxR_HOUR_MASK	(0x1f << RDxR_HOUR_S)
 #define RDxR_MIN_S	6
@@ -89,6 +93,7 @@ struct pxa_rtc {
 	spinlock_t		lock;		/* Protects this structure */
 };
 
+
 static u32 ryxr_calc(struct rtc_time *tm)
 {
 	return ((tm->tm_year + 1900) << RYxR_YEAR_S)
@@ -98,7 +103,10 @@ static u32 ryxr_calc(struct rtc_time *tm)
 
 static u32 rdxr_calc(struct rtc_time *tm)
 {
-	return (tm->tm_hour << RDxR_HOUR_S) | (tm->tm_min << RDxR_MIN_S)
+	return ((((tm->tm_mday + 6) / 7) << RDxR_WOM_S) & RDxR_WOM_MASK)
+		| (((tm->tm_wday + 1) << RDxR_DOW_S) & RDxR_DOW_MASK)
+		| (tm->tm_hour << RDxR_HOUR_S)
+		| (tm->tm_min << RDxR_MIN_S)
 		| tm->tm_sec;
 }
 
@@ -107,6 +115,7 @@ static void tm_calc(u32 rycr, u32 rdcr, struct rtc_time *tm)
 	tm->tm_year = ((rycr & RYxR_YEAR_MASK) >> RYxR_YEAR_S) - 1900;
 	tm->tm_mon = (((rycr & RYxR_MONTH_MASK) >> RYxR_MONTH_S)) - 1;
 	tm->tm_mday = (rycr & RYxR_DAY_MASK);
+	tm->tm_wday = ((rdcr & RDxR_DOW_MASK) >> RDxR_DOW_S) - 1;
 	tm->tm_hour = (rdcr & RDxR_HOUR_MASK) >> RDxR_HOUR_S;
 	tm->tm_min = (rdcr & RDxR_MIN_MASK) >> RDxR_MIN_S;
 	tm->tm_sec = rdcr & RDxR_SEC_MASK;
-- 
1.7.1

