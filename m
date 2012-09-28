Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965236Ab2I1V1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:27:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422726Ab2I1U3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:29:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        James Nute <newten82@gmail.com>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 141/218] drivers/rtc/rtc-rs5c348.c: fix hour decoding in 12-hour mode
Date: Fri, 28 Sep 2012 13:15:58 -0700
Message-Id: <20120928201517.658803117@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-rs5c348.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-rs5c348.c
+++ b/drivers/rtc/rtc-rs5c348.c
@@ -122,9 +122,12 @@ rs5c348_rtc_read_time(struct device *dev
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


