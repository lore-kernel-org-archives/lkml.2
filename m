Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab1G0V5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 17:57:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:53542 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab1G0VtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:49:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900996"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: florian@openwrt.org, wim@iguana.be, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [75/99] watchdog: mtx1-wdt: request gpio before using it
Message-Id: <20110727214914.A2F0F2403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:49:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Florian Fainelli <florian@openwrt.org>

commit 9b19d40aa3ebaf1078779da10555da2ab8512422 upstream.

Otherwise, the gpiolib autorequest feature will produce a WARN_ON():

WARNING: at drivers/gpio/gpiolib.c:101 0x8020ec6c()
autorequest GPIO-215
[...]

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/watchdog/mtx-1_wdt.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6.35.y/drivers/watchdog/mtx-1_wdt.c
===================================================================
--- linux-2.6.35.y.orig/drivers/watchdog/mtx-1_wdt.c
+++ linux-2.6.35.y/drivers/watchdog/mtx-1_wdt.c
@@ -211,6 +211,12 @@ static int __devinit mtx1_wdt_probe(stru
 	int ret;
 
 	mtx1_wdt_device.gpio = pdev->resource[0].start;
+	ret = gpio_request_one(mtx1_wdt_device.gpio,
+				GPIOF_OUT_INIT_HIGH, "mtx1-wdt");
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to request gpio");
+		return ret;
+	}
 
 	spin_lock_init(&mtx1_wdt_device.lock);
 	init_completion(&mtx1_wdt_device.stop);
@@ -236,6 +242,8 @@ static int __devexit mtx1_wdt_remove(str
 		mtx1_wdt_device.queue = 0;
 		wait_for_completion(&mtx1_wdt_device.stop);
 	}
+
+	gpio_free(mtx1_wdt_device.gpio);
 	misc_deregister(&mtx1_wdt_misc);
 	return 0;
 }
