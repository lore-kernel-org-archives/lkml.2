Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab2HNQGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 12:06:22 -0400
Received: from defer-dn02.ocn.ad.jp ([125.170.100.157]:35221 "EHLO
	defer-dn02.ocn.ad.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab2HNQGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 12:06:21 -0400
X-Greylist: delayed 2585 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2012 12:06:21 EDT
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: James Nute <newten82@gmail.com>, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rtc: rs5c348: Fix hour decoding in 12-hour mode
Date: Wed, 15 Aug 2012 00:21:44 +0900
Message-Id: <1344957704-2981-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the offset by subtracting 20 from tm_hour before taking
the modulo 12.

Reported-and-tested-by: James Nute <newten82@gmail.com>
Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/rtc/rtc-rs5c348.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-rs5c348.c b/drivers/rtc/rtc-rs5c348.c
index 77074cc..fd5c7af 100644
--- a/drivers/rtc/rtc-rs5c348.c
+++ b/drivers/rtc/rtc-rs5c348.c
@@ -122,9 +122,12 @@ rs5c348_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	tm->tm_min = bcd2bin(rxbuf[RS5C348_REG_MINS] & RS5C348_MINS_MASK);
 	tm->tm_hour = bcd2bin(rxbuf[RS5C348_REG_HOURS] & RS5C348_HOURS_MASK);
 	if (!pdata->rtc_24h) {
-		tm->tm_hour %= 12;
-		if (rxbuf[RS5C348_REG_HOURS] & RS5C348_BIT_PM)
+		if (rxbuf[RS5C348_REG_HOURS] & RS5C348_BIT_PM) {
+			tm->tm_hour -= 20;
+			tm->tm_hour %= 12;
 			tm->tm_hour += 12;
+		} else
+			tm->tm_hour %= 12;
 	}
 	tm->tm_wday = bcd2bin(rxbuf[RS5C348_REG_WDAY] & RS5C348_WDAY_MASK);
 	tm->tm_mday = bcd2bin(rxbuf[RS5C348_REG_DAY] & RS5C348_DAY_MASK);
-- 
1.7.0.4

