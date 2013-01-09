Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970Ab3AIVA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:00:56 -0500
Received: from mail.kernel.org ([198.145.19.201]:43513 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933883Ab3AIUkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Edgar Toernig <froese@gmx.de>, Tony Prisk <linux@prisktech.co.nz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 77/80] drivers/rtc/rtc-vt8500.c: fix handling of data passed in struct rtc_time
Date: Wed,  9 Jan 2013 12:36:09 -0800
Message-Id: <20130109201510.272622533@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Prisk <linux@prisktech.co.nz>

commit 2f90b68309683f2c5765a1b04ca23d71e51f1494 upstream.

tm_mon is 0..11, whereas vt8500 expects 1..12 for the month field,
causing invalid date errors for January, and causing the day field to
roll over incorrectly.

The century flag is only handled in vt8500_rtc_read_time, but not set in
vt8500_rtc_set_time.  This patch corrects the behaviour of the century
flag.

Signed-off-by: Edgar Toernig <froese@gmx.de>
Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-vt8500.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -118,7 +118,7 @@ static int vt8500_rtc_read_time(struct d
 	tm->tm_min = bcd2bin((time & TIME_MIN_MASK) >> TIME_MIN_S);
 	tm->tm_hour = bcd2bin((time & TIME_HOUR_MASK) >> TIME_HOUR_S);
 	tm->tm_mday = bcd2bin(date & DATE_DAY_MASK);
-	tm->tm_mon = bcd2bin((date & DATE_MONTH_MASK) >> DATE_MONTH_S);
+	tm->tm_mon = bcd2bin((date & DATE_MONTH_MASK) >> DATE_MONTH_S) - 1;
 	tm->tm_year = bcd2bin((date & DATE_YEAR_MASK) >> DATE_YEAR_S)
 			+ ((date >> DATE_CENTURY_S) & 1 ? 200 : 100);
 	tm->tm_wday = (time & TIME_DOW_MASK) >> TIME_DOW_S;
@@ -137,8 +137,9 @@ static int vt8500_rtc_set_time(struct de
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


