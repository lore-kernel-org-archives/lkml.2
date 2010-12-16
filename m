Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab0LPSIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:08:35 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:43076 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086Ab0LPSId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:08:33 -0500
From: Daniel Drake <dsd@laptop.org>
To: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org
Cc: pgf@laptop.org
Subject: [PATCH] rtc-cmos: fix suspend/resume
Message-Id: <20101216180829.A8E5A9D401B@zog.reactivated.net>
Date: Thu, 16 Dec 2010 18:08:29 +0000 (GMT)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=N00zUG7RsDsA:10 a=Op-mwl0xAAAA:8 a=aTbJtRG3W_R0jQmJmKUA:9 a=olpSOCNL1VO9LjGkqqIA:7 a=upEVNRLOtsVm0lwHnE6m8d4Hk-cA:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Fox <pgf@laptop.org>

rtc-cmos was setting suspend/resume hooks at the device_driver level.
However, the platform bus code (drivers/base/platform.c) only looks
for resume hooks at the dev_pm_ops level, or within the platform_driver.

Switch rtc_cmos to use dev_pm_ops so that suspend/resume code is
executed again.

Signed-off-by: Paul Fox <pgf@laptop.org>
Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/rtc/rtc-cmos.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 5856167..dfa5547 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -850,7 +850,7 @@ static void __exit cmos_do_remove(struct device *dev)
 
 #ifdef	CONFIG_PM
 
-static int cmos_suspend(struct device *dev, pm_message_t mesg)
+static int cmos_suspend(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned char	tmp;
@@ -898,7 +898,7 @@ static int cmos_suspend(struct device *dev, pm_message_t mesg)
  */
 static inline int cmos_poweroff(struct device *dev)
 {
-	return cmos_suspend(dev, PMSG_HIBERNATE);
+	return cmos_suspend(dev);
 }
 
 static int cmos_resume(struct device *dev)
@@ -1077,7 +1077,7 @@ static void __exit cmos_pnp_remove(struct pnp_dev *pnp)
 
 static int cmos_pnp_suspend(struct pnp_dev *pnp, pm_message_t mesg)
 {
-	return cmos_suspend(&pnp->dev, mesg);
+	return cmos_suspend(&pnp->dev);
 }
 
 static int cmos_pnp_resume(struct pnp_dev *pnp)
@@ -1152,13 +1152,17 @@ static void cmos_platform_shutdown(struct platform_device *pdev)
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:rtc_cmos");
 
+static struct dev_pm_ops cmos_pm_ops = {
+	.suspend = cmos_suspend,
+	.resume = cmos_resume,
+};
+
 static struct platform_driver cmos_platform_driver = {
 	.remove		= __exit_p(cmos_platform_remove),
 	.shutdown	= cmos_platform_shutdown,
 	.driver = {
 		.name		= (char *) driver_name,
-		.suspend	= cmos_suspend,
-		.resume		= cmos_resume,
+		.pm = &cmos_pm_ops,
 	}
 };
 
-- 
1.7.3.3

