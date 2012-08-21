Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab2HUNgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:36:44 -0400
Received: from smtp-out-188.synserver.de ([212.40.185.188]:1329 "EHLO
	smtp-out-188.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2HUNgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:36:40 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3845
From: Lars-Peter Clausen <lars@metafoo.de>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH 2/2] RTC: spear: Fix several error checks
Date: Tue, 21 Aug 2012 15:32:12 +0200
Message-Id: <1345555932-13737-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345555932-13737-1-git-send-email-lars@metafoo.de>
References: <1345555932-13737-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several comparisons of a unsigned int to less than zero int spear RTC
driver. Such a check will always be true. In all these cases a signed int is
assigned to the unsigned variable, which is checked, before. So the right fix is
to make the checked variable signed as well. In one case the check can be
dropped completely, because all it does it returns 'err' if 'err' is less than
zero, otherwise it returns 0. Since in this particular case 'err' is always
either 0 or less this is the same as just returning 'err'.

The issue has been found using the following coccinelle semantic patch:

//<smpl>
@@
type T;
unsigned T i;
@@
(
*i < 0
|
*i >= 0
)
//</smpl>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/rtc/rtc-spear.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index e278547..bb507d2 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -235,7 +235,7 @@ static int spear_rtc_read_time(struct device *dev, struct rtc_time *tm)
 static int spear_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct spear_rtc_config *config = dev_get_drvdata(dev);
-	unsigned int time, date, err = 0;
+	unsigned int time, date;
 
 	if (tm2bcd(tm) < 0)
 		return -EINVAL;
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
@@ -295,7 +292,8 @@ static int spear_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 static int spear_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct spear_rtc_config *config = dev_get_drvdata(dev);
-	unsigned int time, date, err = 0;
+	unsigned int time, date;
+	int err;
 
 	if (tm2bcd(&alm->time) < 0)
 		return -EINVAL;
@@ -357,7 +355,7 @@ static int __devinit spear_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct spear_rtc_config *config;
-	unsigned int status = 0;
+	int status = 0;
 	int irq;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
1.7.10.4

