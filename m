Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab2K2CGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 21:06:51 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46319 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab2K2CGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 21:06:49 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "vbyravarasu@nvidia.com" <vbyravarasu@nvidia.com>,
        "sivaramn@nvidia.com" <sivaramn@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtc-tps65910: fix invalid pointer access on _remove()
Thread-Topic: [PATCH] rtc-tps65910: fix invalid pointer access on _remove()
Thread-Index: Ac3N1h+hbmHcRBfbTaOdOF2knV6cjg==
Date: Thu, 29 Nov 2012 02:06:21 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6418F0D4@DQHE02.ent.ti.com>
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

 The tps65910_rtc data is registered as the platform driver data in _probe().
 Therefore the tps65910_rtc should be used on unregistering the rtc device.
 And device pointer should be retrieved from the platform_device structure.

 This patch fixes the error as below.

 Unable to handle kernel NULL pointer dereference at virtual address 00000008
 Modules linked in: rtc_tps65910(-)
 CPU: 0    Not tainted  (3.7.0-rc7-next-20121128-g6b1f974-dirty #7)
 PC is at tps65910_rtc_alarm_irq_enable+0x20/0x2c [rtc_tps65910]
 LR is at tps65910_rtc_alarm_irq_enable+0x10/0x2c [rtc_tps65910]
 [<bf000044>] (tps65910_rtc_alarm_irq_enable+0x20/0x2c [rtc_tps65910]) from
   [<bf0004d4>] (tps65910_rtc_remove+0x18/0x28 [rtc_)
 [<bf0004d4>] (tps65910_rtc_remove+0x18/0x28 [rtc_tps65910]) from
   [<c034e700>] (platform_drv_remove+0x18/0x1c)
 [<c034e700>] (platform_drv_remove+0x18/0x1c) from
   [<c034ceec>] (__device_release_driver+0x70/0xcc)
 [<c034ceec>] (__device_release_driver+0x70/0xcc) from
   [<c034d608>] (driver_detach+0xb4/0xb8)
 [<c034d608>] (driver_detach+0xb4/0xb8) from
   [<c034cc24>] (bus_remove_driver+0x7c/0xc0)
 [<c034cc24>] (bus_remove_driver+0x7c/0xc0) from
   [<c00a045c>] (sys_delete_module+0x148/0x21c)
 [<c00a045c>] (sys_delete_module+0x148/0x21c) from
   [<c0013c60>] (ret_fast_syscall+0x0/0x3c)

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/rtc/rtc-tps65910.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index e8d44bc..687006f 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -288,11 +288,11 @@ static int __devinit tps65910_rtc_probe(struct platform_device *pdev)
 static int __devexit tps65910_rtc_remove(struct platform_device *pdev)
 {
 	/* leave rtc running, but disable irqs */
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
+	struct tps65910_rtc *tps_rtc = platform_get_drvdata(pdev);
 
-	tps65910_rtc_alarm_irq_enable(&rtc->dev, 0);
+	tps65910_rtc_alarm_irq_enable(&pdev->dev, 0);
 
-	rtc_device_unregister(rtc);
+	rtc_device_unregister(tps_rtc->rtc);
 	return 0;
 }
 
-- 
1.7.9.5


Best Regards,
Milo

