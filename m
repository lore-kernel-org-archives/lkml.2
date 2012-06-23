Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab2FWLoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 07:44:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46533 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2FWLoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 07:44:18 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
        Viresh Kumar <viresh.linux@gmail.com>, spear-devel@list.st.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] rtc/rtc-spear: remove unnecessary check against rtc_valid_tm and tm2bcd
Date: Sat, 23 Jun 2012 17:13:59 +0530
Message-Id: <1340451839-30623-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc_valid_tm is always return
-EINVAL if the time doesn't represent a valid date and time and 0 if its.

so we can simply do rtc_valid_tm(tm) rather doing rtc_valid_tm(tm) != 0 checking.
and also tm2bcd() does return -EINVAL if the time doesn't represent a valid date and time
and 0 if its.

and also removing err because is_write_complete will return -EIO if our write to the
RTC registers didn't happen and 0 if its.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---

This is only tested by compiling the code with arm-linux-gcc

/bin/arm-linux-gnueabihf-gcc --version

arm-linux-gnueabihf-gcc (crosstool-NG linaro-1.13.1-2012.05-20120523 - Linaro GCC 2012.05) 4.7.1 20120514 (prerelease)

 drivers/rtc/rtc-spear.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index e278547..eb7d399 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -172,7 +172,7 @@ static irqreturn_t spear_rtc_irq(int irq, void *dev_id)
 
 static int tm2bcd(struct rtc_time *tm)
 {
-	if (rtc_valid_tm(tm) != 0)
+	if (rtc_valid_tm(tm))
 		return -EINVAL;
 	tm->tm_sec = bin2bcd(tm->tm_sec);
 	tm->tm_min = bin2bcd(tm->tm_min);
@@ -235,9 +235,9 @@ static int spear_rtc_read_time(struct device *dev, struct rtc_time *tm)
 static int spear_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct spear_rtc_config *config = dev_get_drvdata(dev);
-	unsigned int time, date, err = 0;
+	unsigned int time, date;
 
-	if (tm2bcd(tm) < 0)
+	if (tm2bcd(tm))
 		return -EINVAL;
 
 	rtc_wait_not_busy(config);
@@ -247,11 +247,8 @@ static int spear_rtc_set_time(struct device *dev, struct rtc_time *tm)
 		(tm->tm_year << YEAR_SHIFT);
 	writel(time, config->ioaddr + TIME_REG);
 	writel(date, config->ioaddr + DATE_REG);
-	err = is_write_complete(config);
-	if (err < 0)
-		return err;
 
-	return 0;
+	return is_write_complete(config);
 }
 
 /*
@@ -297,7 +294,7 @@ static int spear_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 	struct spear_rtc_config *config = dev_get_drvdata(dev);
 	unsigned int time, date, err = 0;
 
-	if (tm2bcd(&alm->time) < 0)
+	if (tm2bcd(&alm->time))
 		return -EINVAL;
 
 	rtc_wait_not_busy(config);
-- 
1.7.9.5

