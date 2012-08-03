Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab2HCTqx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 15:46:53 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56386 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab2HCTqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 15:46:24 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH v2 1/6] drivers/misc/ti-st: remove gpio handling
Date: Fri, 3 Aug 2012 14:46:12 -0500
Message-ID: <1344023177-21167-2-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1344023177-21167-1-git-send-email-pavan_savoy@ti.com>
References: <1344023177-21167-1-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

A platform hook to enable/disable the chip was introduced to perform specific
activities to power-up and power-down the WL chip.
Moving the power-up/down sequence also there makes more sense, since different
platforms have begun to have their own ways to power-up/down the chip.
This patch removes all of the gpio handling done by the driver in
st_kim_start/st_kim_stop & any of the gpio request done in the probe function.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_kim.c |   37 +------------------------------------
 1 files changed, 1 insertions(+), 36 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 7c14f8f..5c99995 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -454,11 +454,6 @@ long st_kim_start(void *kim_data)
 		if (pdata->chip_enable)
 			pdata->chip_enable(kim_gdata);
 
-		/* Configure BT nShutdown to HIGH state */
-		gpio_set_value(kim_gdata->nshutdown, GPIO_LOW);
-		mdelay(5);	/* FIXME: a proper toggle */
-		gpio_set_value(kim_gdata->nshutdown, GPIO_HIGH);
-		mdelay(100);
 		/* re-initialize the completion */
 		INIT_COMPLETION(kim_gdata->ldisc_installed);
 		/* send notification to UIM */
@@ -500,8 +495,7 @@ long st_kim_start(void *kim_data)
  *	(b) upon failure to either install ldisc or download firmware.
  *	The function is responsible to (a) notify UIM about un-installation,
  *	(b) flush UART if the ldisc was installed.
- *	(c) reset BT_EN - pull down nshutdown at the end.
- *	(d) invoke platform's chip disabling routine.
+ *	(c) invoke platform's chip disabling routine.
  */
 long st_kim_stop(void *kim_data)
 {
@@ -533,13 +527,6 @@ long st_kim_stop(void *kim_data)
 		return -ETIMEDOUT;
 	}
 
-	/* By default configure BT nShutdown to LOW state */
-	gpio_set_value(kim_gdata->nshutdown, GPIO_LOW);
-	mdelay(1);
-	gpio_set_value(kim_gdata->nshutdown, GPIO_HIGH);
-	mdelay(1);
-	gpio_set_value(kim_gdata->nshutdown, GPIO_LOW);
-
 	/* platform specific disable */
 	if (pdata->chip_disable)
 		pdata->chip_disable(kim_gdata);
@@ -731,20 +718,6 @@ static int kim_probe(struct platform_device *pdev)
 	/* refer to itself */
 	kim_gdata->core_data->kim_data = kim_gdata;
 
-	/* Claim the chip enable nShutdown gpio from the system */
-	kim_gdata->nshutdown = pdata->nshutdown_gpio;
-	status = gpio_request(kim_gdata->nshutdown, "kim");
-	if (unlikely(status)) {
-		pr_err(" gpio %ld request failed ", kim_gdata->nshutdown);
-		return status;
-	}
-
-	/* Configure nShutdown GPIO as output=0 */
-	status = gpio_direction_output(kim_gdata->nshutdown, 0);
-	if (unlikely(status)) {
-		pr_err(" unable to configure gpio %ld", kim_gdata->nshutdown);
-		return status;
-	}
 	/* get reference of pdev for request_firmware
 	 */
 	kim_gdata->kim_pdev = pdev;
@@ -780,18 +753,10 @@ static int kim_probe(struct platform_device *pdev)
 
 static int kim_remove(struct platform_device *pdev)
 {
-	/* free the GPIOs requested */
-	struct ti_st_plat_data	*pdata = pdev->dev.platform_data;
 	struct kim_data_s	*kim_gdata;
 
 	kim_gdata = dev_get_drvdata(&pdev->dev);
 
-	/* Free the Bluetooth/FM/GPIO
-	 * nShutdown gpio from the system
-	 */
-	gpio_free(pdata->nshutdown_gpio);
-	pr_info("nshutdown GPIO Freed");
-
 	debugfs_remove_recursive(kim_debugfs_dir);
 	sysfs_remove_group(&pdev->dev.kobj, &uim_attr_grp);
 	pr_info("sysfs entries removed");
-- 
1.7.4.1

