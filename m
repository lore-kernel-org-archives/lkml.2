Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2AXAHd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:07:33 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:49664 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab2AXAH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:07:29 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jim Cromie <jim.cromie@gmail.com>
Subject: [RFC][PATCH 2/3] clocksource: scx200_hrt: Convert scx200 to use clocksource_register_hz
Date: Mon, 23 Jan 2012 16:05:49 -0800
Message-Id: <1327363550-19952-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1327363550-19952-1-git-send-email-john.stultz@linaro.org>
References: <1327363550-19952-1-git-send-email-john.stultz@linaro.org>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12012400-5518-0000-0000-000001BF275F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converts the scx200 clocksource to using clocksource_register_hz.

This wasn't a straight conversion, so would like some extra review
by the maintainers.

CC: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/clocksource/scx200_hrt.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/clocksource/scx200_hrt.c b/drivers/clocksource/scx200_hrt.c
index 27f4d96..24f884c 100644
--- a/drivers/clocksource/scx200_hrt.c
+++ b/drivers/clocksource/scx200_hrt.c
@@ -49,9 +49,6 @@ static cycle_t read_hrt(struct clocksource *cs)
 	return (cycle_t) inl(scx200_cb_base + SCx200_TIMER_OFFSET);
 }
 
-#define HRT_SHIFT_1	22
-#define HRT_SHIFT_27	26
-
 static struct clocksource cs_hrt = {
 	.name		= "scx200_hrt",
 	.rating		= 250,
@@ -63,6 +60,7 @@ static struct clocksource cs_hrt = {
 
 static int __init init_hrt_clocksource(void)
 {
+	u32 freq;
 	/* Make sure scx200 has initialized the configuration block */
 	if (!scx200_cb_present())
 		return -ENODEV;
@@ -79,19 +77,14 @@ static int __init init_hrt_clocksource(void)
 	outb(HR_TMEN | (mhz27 ? HR_TMCLKSEL : 0),
 	     scx200_cb_base + SCx200_TMCNFG_OFFSET);
 
-	if (mhz27) {
-		cs_hrt.shift = HRT_SHIFT_27;
-		cs_hrt.mult = clocksource_hz2mult((HRT_FREQ + ppm) * 27,
-						  cs_hrt.shift);
-	} else {
-		cs_hrt.shift = HRT_SHIFT_1;
-		cs_hrt.mult = clocksource_hz2mult(HRT_FREQ + ppm,
-						  cs_hrt.shift);
-	}
+	freq = (HRT_FREQ + ppm);
+	if (mhz27)
+		freq *= 27;
+
 	printk(KERN_INFO "enabling scx200 high-res timer (%s MHz +%d ppm)\n",
 		mhz27 ? "27":"1", ppm);
 
-	return clocksource_register(&cs_hrt);
+	return clocksource_register_hz(&cs_hrt, freq);
 }
 
 module_init(init_hrt_clocksource);
-- 
1.7.3.2.146.gca209

