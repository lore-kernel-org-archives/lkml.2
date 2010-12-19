Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab0LSRki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 12:40:38 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:39628 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932369Ab0LSRkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 12:40:37 -0500
From: Daniel Drake <dsd@laptop.org>
To: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org
Cc: pgf@laptop.org
Cc: rjw@sisk.pl
Subject: [PATCH v2] rtc-cmos: fix suspend/resume
Message-Id: <20101219174032.3E7579D401C@zog.reactivated.net>
Date: Sun, 19 Dec 2010 17:40:32 +0000 (GMT)
X-Cloudmark-Analysis: v=1.1 cv=X0sWjjQ37bMP4yB/pNNinY3VxVB2n/hmdAjhihaCFGs= c=1 sm=0 a=e_qKP4wONOUA:10 a=Op-mwl0xAAAA:8 a=PtJcH0kQz5UYZKdmrUkA:9 a=qegLS8QIm8LEshBVmNcA:7 a=0EQzuqhV_R1weTpR0jNoaNoScEcA:4 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
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
 drivers/rtc/rtc-cmos.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

v2: incorporate feedback from Rafael J. Wysocki, fix tabs, make a bit more
consistent with typical SIMPLE_DEV_PM_OPS users.

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 5856167..b46c539 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -36,6 +36,7 @@
 #include <linux/platform_device.h>
 #include <linux/mod_devicetable.h>
 #include <linux/log2.h>
+#include <linux/pm.h>
 
 /* this is for "generic access to PC-style RTC" using CMOS_READ/CMOS_WRITE */
 #include <asm-generic/rtc.h>
@@ -850,7 +851,7 @@ static void __exit cmos_do_remove(struct device *dev)
 
 #ifdef	CONFIG_PM
 
-static int cmos_suspend(struct device *dev, pm_message_t mesg)
+static int cmos_suspend(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
 	unsigned char	tmp;
@@ -898,7 +899,7 @@ static int cmos_suspend(struct device *dev, pm_message_t mesg)
  */
 static inline int cmos_poweroff(struct device *dev)
 {
-	return cmos_suspend(dev, PMSG_HIBERNATE);
+	return cmos_suspend(dev);
 }
 
 static int cmos_resume(struct device *dev)
@@ -945,9 +946,9 @@ static int cmos_resume(struct device *dev)
 	return 0;
 }
 
+static const SIMPLE_DEV_PM_OPS(cmos_pm_ops, cmos_suspend, cmos_resume);
+
 #else
-#define	cmos_suspend	NULL
-#define	cmos_resume	NULL
 
 static inline int cmos_poweroff(struct device *dev)
 {
@@ -1077,7 +1078,7 @@ static void __exit cmos_pnp_remove(struct pnp_dev *pnp)
 
 static int cmos_pnp_suspend(struct pnp_dev *pnp, pm_message_t mesg)
 {
-	return cmos_suspend(&pnp->dev, mesg);
+	return cmos_suspend(&pnp->dev);
 }
 
 static int cmos_pnp_resume(struct pnp_dev *pnp)
@@ -1157,8 +1158,9 @@ static struct platform_driver cmos_platform_driver = {
 	.shutdown	= cmos_platform_shutdown,
 	.driver = {
 		.name		= (char *) driver_name,
-		.suspend	= cmos_suspend,
-		.resume		= cmos_resume,
+#ifdef CONFIG_PM
+		.pm		= &cmos_pm_ops,
+#endif
 	}
 };
 
-- 
1.7.3.3

