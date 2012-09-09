Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab2IIXQa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:16:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51263 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755619Ab2IIXQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:27 -0400
Message-Id: <20120909224200.792535794@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:43:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        James Nute <newten82@gmail.com>
Subject: [ 74/95] drivers/rtc/rtc-rs5c348.c: fix hour decoding in 12-hour mode
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

commit 7dbfb315b2aaef0a115765946bf3026d074c33a7 upstream.

Correct the offset by subtracting 20 from tm_hour before taking the
modulo 12.

[ "Why 20?" I hear you ask. Or at least I did.

  Here's the reason why: RS5C348_BIT_PM is 32, and is - stupidly -
  included in the RS5C348_HOURS_MASK define.  So it's really subtracting
  out that bit to get "hour+12".  But then because it does things modulo
  12, it needs to add the 12 in again afterwards anyway.

  This code is confused.  It would be much clearer if RS5C348_HOURS_MASK
  just didn't include the RS5C348_BIT_PM bit at all, then it wouldn't
  need to do the silly subtract either.

  Whatever. It's all just math, the end result is the same.   - Linus ]

Reported-by: James Nute <newten82@gmail.com>
Tested-by: James Nute <newten82@gmail.com>
Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/rtc/rtc-rs5c348.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

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


