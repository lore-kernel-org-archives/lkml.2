Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2APSsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:48:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979Ab2APSsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:48:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:16 2012
Message-Id: <20120116184516.202437381@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:44:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Hutchings <ben@decadent.org.uk>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [05/48] drivers/rtc/interface.c: fix alarm rollover when day or month is out-of-range
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit e74a8f2edb92cb690b467cea0ab652c509e9f624 upstream.

Commit f44f7f96a20a ("RTC: Initialize kernel state from RTC") introduced a
potential infinite loop.  If an alarm time contains a wildcard month and
an invalid day (> 31), or a wildcard year and an invalid month (>= 12),
the loop searching for the next matching date will never terminate.  Treat
the invalid values as wildcards.

Fixes <http://bugs.debian.org/646429>, <http://bugs.debian.org/653331>

Reported-by: leo weppelman <leoweppelman@googlemail.com>
Reported-by: "P. van Gaans" <mailme667@yahoo.co.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/interface.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -227,11 +227,11 @@ int __rtc_read_alarm(struct rtc_device *
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


