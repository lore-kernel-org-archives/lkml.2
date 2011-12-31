Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1LaAgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 19:36:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60738 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab1LaAgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 19:36:00 -0500
Date: Fri, 30 Dec 2011 18:35:52 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: "P." <mailme667@yahoo.co.uk>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH resend] rtc: Fix alarm rollover when day or month is
 out-of-range
Message-ID: <20111231003552.GB22266@elie.Belkin>
References: <1325289236.85273.YahooMailClassic@web27003.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325289236.85273.YahooMailClassic@web27003.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.21+51 (9e756d1adb76) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Thu, 29 Dec 2011 16:41:56 +0100

Commit f44f7f96a20a ('RTC: Initialize kernel state from RTC')
introduced a potential infinite loop.  If an alarm time contains a
wildcard month and an invalid day (> 31), or a wildcard year and an
invalid month (>= 12), the loop searching for the next matching date
will never terminate.  Treat the invalid values as wildcards.

Fixes <http://bugs.debian.org/646429>, <http://bugs.debian.org/653331>

Reported-by: leo weppelman <leoweppelman@googlemail.com>
Reported-by: "P. van Gaans" <mailme667@yahoo.co.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
P. wrote:

> Following the advice from Jonathan Nieder I am sending this mail.

Old advice. :)

Here's a patch that was sent to the rtc-linux list, but I can't
seem to find it with search.gmane.org.

 drivers/rtc/interface.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 3bcc7cfcaba7..67b68c4543d0 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -232,11 +232,11 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 		alarm->time.tm_hour = now.tm_hour;
 
 	/* For simplicity, only support date rollover for now */
-	if (alarm->time.tm_mday == -1) {
+	if (alarm->time.tm_mday < 1 || alarm->time.tm_mday > 31) {
 		alarm->time.tm_mday = now.tm_mday;
 		missing = day;
 	}
-	if (alarm->time.tm_mon == -1) {
+	if ((unsigned)alarm->time.tm_mon >= 12) {
 		alarm->time.tm_mon = now.tm_mon;
 		if (missing == none)
 			missing = month;
-- 
1.7.8.2+next.20111228

