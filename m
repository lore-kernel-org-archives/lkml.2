Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab0GNFnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 01:43:06 -0400
Received: from coyote.quickmin.net ([217.14.112.24]:49922 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab0GNFnE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 01:43:04 -0400
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=HJKb73ft4XKeNrVzk1giXvFvm9djPZeEohHc2L9wTyNNHplhTAWC8iY8AiXkChWsPQ0Rss+cI4oD+tMlo2Fc4E494kRXn7jOXStM++49CCC1eUMXVU5Rcm8xD9uAZp71P61fjvMvaNi/8OtE0LEhsvnUPnk7h65BJ2JZI432Cfk=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: Wan ZongShun <mcuos.com@gmail.com>
Subject: [PATCH] rtc-isl12022: properly handle military hour format
User-Agent: KMail/1.13.5 (Linux/2.6.31.12-0.2-default; KDE/4.4.5; x86_64; ; )
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <201006171123.31484.roman.fietze@telemotive.de> <AANLkTikvYWFRthn5gyppxYExKs8C-5FC-7ybnqO_sWTk@mail.gmail.com> <201006180727.06274.roman.fietze@telemotive.de>
In-Reply-To: <201006180727.06274.roman.fietze@telemotive.de>
MIME-Version: 1.0
Message-ID: <201007140742.58766.roman.fietze@telemotive.de>
Date: Wed, 14 Jul 2010 07:42:58 +0200
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 14.07.2010 07:42:58,
	Serialize by Router on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 14.07.2010 07:42:59,
	Serialize complete at 14.07.2010 07:42:59
Content-Transfer-Encoding: 8BIT
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wan, hello list members,

I found a bug in my rtc-isl12022. Seems I missed to test that driver
thoroughly in the afternoons.

>From 151b7d5413e189ec8f6dd578c253500d8814128e Mon Sep 17 00:00:00 2001
From: Roman Fietze <roman.fietze@telemotive.de>
Date: Wed, 14 Jul 2010 07:32:49 +0200
Subject: [PATCH] rtc-isl12022: properly handle military hour format

Mask out PM flag when reading the hour, always set MIL bit when
writing the hour.

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
---
 drivers/rtc/rtc-isl12022.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-isl12022.c b/drivers/rtc/rtc-isl12022.c
index 293d2c1..0f300b4 100644
--- a/drivers/rtc/rtc-isl12022.c
+++ b/drivers/rtc/rtc-isl12022.c
@@ -126,7 +126,7 @@ static int isl12022_get_datetime(struct i2c_client 
*client, struct rtc_time *tm)
 
 	tm->tm_sec = bcd2bin(buf[ISL12022_REG_SC] & 0x7F);
 	tm->tm_min = bcd2bin(buf[ISL12022_REG_MN] & 0x7F);
-	tm->tm_hour = bcd2bin(buf[ISL12022_REG_HR] & 0x3F);
+	tm->tm_hour = bcd2bin(buf[ISL12022_REG_HR] & 0x1F);
 	tm->tm_mday = bcd2bin(buf[ISL12022_REG_DT] & 0x3F);
 	tm->tm_wday = buf[ISL12022_REG_DW] & 0x07;
 	tm->tm_mon = bcd2bin(buf[ISL12022_REG_MO] & 0x1F) - 1;
@@ -192,7 +192,7 @@ static int isl12022_set_datetime(struct i2c_client 
*client, struct rtc_time *tm)
 	/* hours, minutes and seconds */
 	buf[ISL12022_REG_SC] = bin2bcd(tm->tm_sec);
 	buf[ISL12022_REG_MN] = bin2bcd(tm->tm_min);
-	buf[ISL12022_REG_HR] = bin2bcd(tm->tm_hour);
+	buf[ISL12022_REG_HR] = bin2bcd(tm->tm_hour) | ISL12022_HR_MIL;
 
 	buf[ISL12022_REG_DT] = bin2bcd(tm->tm_mday);
 
-- 
1.7.1


-- 
Roman Fietze              Telemotive AG Buero Muehlhausen
Breitwiesen                             73347 Muehlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de
