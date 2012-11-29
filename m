Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab2K2Isx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:48:53 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:48129 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab2K2Isv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:48:51 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "vbyravarasu@nvidia.com" <vbyravarasu@nvidia.com>,
        "sivaramn@nvidia.com" <sivaramn@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] rtc-tps65910: enable RTC power domain on initialization
Thread-Topic: [PATCH 2/2] rtc-tps65910: enable RTC power domain on
 initialization
Thread-Index: Ac3ODj+EBtR5lNOFQkugojWkudbjXg==
Date: Thu, 29 Nov 2012 08:48:06 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6418F1B3@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Enabling RTC HW block depends on the default value of TPS65910 register.
 In some mode, RTC block is disabled by default.(eg. AM3517 Craneboard)
 In this case, RTC_PWDN(RTC power down) bit should be cleared to enable
 the RTC HW block.

 This patch also works in case that RTC block is active by default,
 because there is no side effect even if the bit is updated again.

 Tested on AM3517 Craneboard.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/rtc/rtc-tps65910.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index e8d44bc..b4d9f02 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -247,6 +247,13 @@ static int __devinit tps65910_rtc_probe(struct platform_device *pdev)
 		return ret;
 
 	dev_dbg(&pdev->dev, "Enabling rtc-tps65910.\n");
+
+	/* Enable RTC digital power domain */
+	ret = regmap_update_bits(tps65910->regmap, TPS65910_DEVCTRL,
+		DEVCTRL_RTC_PWDN_MASK, 0 << DEVCTRL_RTC_PWDN_SHIFT);
+	if (ret < 0)
+		return ret;
+
 	rtc_reg = TPS65910_RTC_CTRL_STOP_RTC;
 	ret = regmap_write(tps65910->regmap, TPS65910_RTC_CTRL, rtc_reg);
 	if (ret < 0)
-- 
1.7.9.5


Best Regards,
Milo


