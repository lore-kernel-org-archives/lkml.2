Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab2E0A7m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 20:59:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56104 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab2E0A7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 20:59:36 -0400
Message-Id: <20120527002618.728395264@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:45 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [ 32/55] drivers/rtc/rtc-pl031.c: configure correct wday for 2000-01-01
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>

commit c0a5f4a05af588a0f9951f8d24e2564b09501918 upstream.

The reset date of the ST Micro version of PL031 is 2000-01-01.  The
correct weekday for 2000-01-01 is saturday, but pl031 is initialized to
sunday.  This may lead to alarm malfunction, so configure the correct
wday if RTC_DR indicates reset.

Signed-off-by: Rajkumar Kasirajan <rajkumar.kasirajan@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/rtc-pl031.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -312,6 +312,7 @@ static int pl031_probe(struct amba_devic
 	int ret;
 	struct pl031_local *ldata;
 	struct rtc_class_ops *ops = id->data;
+	unsigned long time;
 
 	ret = amba_request_regions(adev, NULL);
 	if (ret)
@@ -343,6 +344,23 @@ static int pl031_probe(struct amba_devic
 		writel(readl(ldata->base + RTC_CR) | RTC_CR_CWEN,
 		       ldata->base + RTC_CR);
 
+	/*
+	 * On ST PL031 variants, the RTC reset value does not provide correct
+	 * weekday for 2000-01-01. Correct the erroneous sunday to saturday.
+	 */
+	if (ldata->hw_designer == AMBA_VENDOR_ST) {
+		if (readl(ldata->base + RTC_YDR) == 0x2000) {
+			time = readl(ldata->base + RTC_DR);
+			if ((time &
+			     (RTC_MON_MASK | RTC_MDAY_MASK | RTC_WDAY_MASK))
+			    == 0x02120000) {
+				time = time | (0x7 << RTC_WDAY_SHIFT);
+				writel(0x2000, ldata->base + RTC_YLR);
+				writel(time, ldata->base + RTC_LR);
+			}
+		}
+	}
+
 	ldata->rtc = rtc_device_register("pl031", &adev->dev, ops,
 					THIS_MODULE);
 	if (IS_ERR(ldata->rtc)) {


