Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab0FXImH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 04:42:07 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47823 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab0FXImF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 04:42:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=rPlBY6QhkJYIX1V65lsfTksDk4ubn51aDMI3hwvjMcUdMl1u29s5fylOpVbbpTinj6
         agdNlkKDRaAlhPiUS+GY4wDn9cBGMlT1imNQk4smB6DH02vFDXqdrU/aVlY6OPqBcUC8
         Qma75evBK5gmRrgQmHju/TPxB7x7sP72RF8Dk=
Message-ID: <4C231A40.20401@gmail.com>
Date: Thu, 24 Jun 2010 16:41:36 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       rtc-linux <rtc-linux@googlegroups.com>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 1/3] RTC/nuc900: make returning time checking function valid
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is to make returning time checking function valid.
In spite of using the 'rtc_valid_tm', nevertheless, the read time function
omits its returning value, that means the 'rtc_valid_tm' is useless here.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 drivers/rtc/rtc-nuc900.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index 20bc70b..84336d1 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -102,7 +102,7 @@ static int *check_rtc_access_enable(struct nuc900_rtc *nuc900_rtc)
 	return 0;
 }

-static void nuc900_rtc_bcd2bin(unsigned int timereg,
+static int nuc900_rtc_bcd2bin(unsigned int timereg,
 				unsigned int calreg, struct rtc_time *tm)
 {
 	tm->tm_mday	= bcd2bin(calreg >> 0);
@@ -113,7 +113,7 @@ static void nuc900_rtc_bcd2bin(unsigned int timereg,
 	tm->tm_min	= bcd2bin(timereg >> 8);
 	tm->tm_hour	= bcd2bin(timereg >> 16);

-	rtc_valid_tm(tm);
+	return rtc_valid_tm(tm);
 }

 static void nuc900_rtc_bin2bcd(struct device *dev, struct rtc_time *settm,
@@ -170,9 +170,7 @@ static int nuc900_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	timeval = __raw_readl(rtc->rtc_reg + REG_RTC_TLR);
 	clrval	= __raw_readl(rtc->rtc_reg + REG_RTC_CLR);

-	nuc900_rtc_bcd2bin(timeval, clrval, tm);
-
-	return 0;
+	return nuc900_rtc_bcd2bin(timeval, clrval, tm);
 }

 static int nuc900_rtc_set_time(struct device *dev, struct rtc_time *tm)
@@ -205,9 +203,7 @@ static int nuc900_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	timeval = __raw_readl(rtc->rtc_reg + REG_RTC_TAR);
 	carval	= __raw_readl(rtc->rtc_reg + REG_RTC_CAR);

-	nuc900_rtc_bcd2bin(timeval, carval, &alrm->time);
-
-	return 0;
+	return nuc900_rtc_bcd2bin(timeval, carval, &alrm->time);
 }

 static int nuc900_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
-- 
1.6.3.3
