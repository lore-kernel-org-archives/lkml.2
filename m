Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab0FFMm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 08:42:59 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:37122 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab0FFMm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 08:42:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=k8h9b1rcE/8R6Kkwjiylqo4nyFb5WD1ZJ1z8F1N6TP5COp16utZ97zqe/OYoL7a6z5
         R2fTe0lzRV7AFjcES7Wu/9uhPdqtqBVXxMVZKvdB7P8jQ0sL+Z2MuJOXNpzZ7DoXh9S/
         mSfLee+qI5m1FkatCf0eeqMghh9YKtrMXrdEI=
Message-ID: <4C0B97C0.4010504@gmail.com>
Date: Sun, 06 Jun 2010 20:42:40 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       rtc-linux <rtc-linux@googlegroups.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtc/nuc900: patch for tm_year to add 'if' condition.
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

When user application wants to set rtc time, RTC subsystem takes advantage of
'rtc_valid_tm(tm)' to check 'rtc_time *tm' value validity, it make sure the 'tm->tm_year'
is larger than 70,so if '70< tm_year < 100', the '(settm->tm_year - 100)' will be negative.
'
Setting the negative value to hardware register will be invalid, so I add the 'if' condition
to make sure set a valid value to register.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 drivers/rtc/rtc-nuc900.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index 21d1330..20bc70b 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -116,12 +116,18 @@ static void nuc900_rtc_bcd2bin(unsigned int timereg,
 	rtc_valid_tm(tm);
 }

-static void nuc900_rtc_bin2bcd(struct rtc_time *settm,
+static void nuc900_rtc_bin2bcd(struct device *dev, struct rtc_time *settm,
 						struct nuc900_bcd_time *gettm)
 {
 	gettm->bcd_mday = bin2bcd(settm->tm_mday) << 0;
 	gettm->bcd_mon  = bin2bcd(settm->tm_mon) << 8;
-	gettm->bcd_year = bin2bcd(settm->tm_year - 100) << 16;
+
+	if (settm->tm_year < 100) {
+		dev_warn(dev, "The year will be between 1970-1999, right?\n");
+		gettm->bcd_year = bin2bcd(settm->tm_year) << 16;
+	} else {
+		gettm->bcd_year = bin2bcd(settm->tm_year - 100) << 16;
+	}

 	gettm->bcd_sec  = bin2bcd(settm->tm_sec) << 0;
 	gettm->bcd_min  = bin2bcd(settm->tm_min) << 8;
@@ -176,7 +182,7 @@ static int nuc900_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	unsigned long val;
 	int *err;

-	nuc900_rtc_bin2bcd(tm, &gettm);
+	nuc900_rtc_bin2bcd(dev, tm, &gettm);

 	err = check_rtc_access_enable(rtc);
 	if (IS_ERR(err))
@@ -211,7 +217,7 @@ static int nuc900_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	unsigned long val;
 	int *err;

-	nuc900_rtc_bin2bcd(&alrm->time, &tm);
+	nuc900_rtc_bin2bcd(dev, &alrm->time, &tm);

 	err = check_rtc_access_enable(rtc);
 	if (IS_ERR(err))
-- 
1.6.3.3
