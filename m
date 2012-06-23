Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2FWVlE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:41:04 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:37119 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab2FWVlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:41:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] sonypi: Use struct dev_pm_ops for power management
Date: Sat, 23 Jun 2012 23:46:26 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Mattia Dongili <malattia@linux.it>,
        platform-driver-x86@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206232346.26432.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the sonypi driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Hi,

If there are no objections, I'd like to push this patch for 3.6 through
the linux-pm tree.

Unfortunately, I don't have the hardware to test it, but I hope it is simple
enough for code inspection to suffice.

Thanks,
Rafael

---
 drivers/char/sonypi.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux/drivers/char/sonypi.c
===================================================================
--- linux.orig/drivers/char/sonypi.c
+++ linux/drivers/char/sonypi.c
@@ -1459,7 +1459,7 @@ static int __devexit sonypi_remove(struc
 #ifdef CONFIG_PM
 static int old_camera_power;
 
-static int sonypi_suspend(struct platform_device *dev, pm_message_t state)
+static int sonypi_suspend(struct device *dev)
 {
 	old_camera_power = sonypi_device.camera_power;
 	sonypi_disable();
@@ -1467,14 +1467,16 @@ static int sonypi_suspend(struct platfor
 	return 0;
 }
 
-static int sonypi_resume(struct platform_device *dev)
+static int sonypi_resume(struct device *dev)
 {
 	sonypi_enable(old_camera_power);
 	return 0;
 }
+
+static SIMPLE_DEV_PM_OPS(sonypi_pm, sonypi_suspend, sonypi_resume);
+#define SONYPI_PM	(&sonypi_pm)
 #else
-#define sonypi_suspend	NULL
-#define sonypi_resume	NULL
+#define SONYPI_PM	NULL
 #endif
 
 static void sonypi_shutdown(struct platform_device *dev)
@@ -1486,12 +1488,11 @@ static struct platform_driver sonypi_dri
 	.driver		= {
 		.name	= "sonypi",
 		.owner	= THIS_MODULE,
+		.pm	= SONYPI_PM,
 	},
 	.probe		= sonypi_probe,
 	.remove		= __devexit_p(sonypi_remove),
 	.shutdown	= sonypi_shutdown,
-	.suspend	= sonypi_suspend,
-	.resume		= sonypi_resume,
 };
 
 static struct platform_device *sonypi_platform_device;
