Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab2FQU0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 16:26:36 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46781 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282Ab2FQUZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 16:25:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: platform-driver-x86@vger.kernel.org
Subject: [PATCH 4/5] intel_mid_thermal: Use struct dev_pm_ops for power management
Date: Sun, 17 Jun 2012 22:29:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Joey Lee <jlee@novell.com>
References: <201206172226.42729.rjw@sisk.pl>
In-Reply-To: <201206172226.42729.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201206172229.41550.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the intel_mid_thermal driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/platform/x86/intel_mid_thermal.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: linux/drivers/platform/x86/intel_mid_thermal.c
===================================================================
--- linux.orig/drivers/platform/x86/intel_mid_thermal.c
+++ linux/drivers/platform/x86/intel_mid_thermal.c
@@ -418,23 +418,23 @@ static struct thermal_device_info *initi
 
 /**
  * mid_thermal_resume - resume routine
- * @pdev: platform device structure
+ * @dev: device structure
  *
  * mid thermal resume: re-initializes the adc. Can sleep.
  */
-static int mid_thermal_resume(struct platform_device *pdev)
+static int mid_thermal_resume(struct device *dev)
 {
-	return mid_initialize_adc(&pdev->dev);
+	return mid_initialize_adc(dev);
 }
 
 /**
  * mid_thermal_suspend - suspend routine
- * @pdev: platform device structure
+ * @dev: device structure
  *
  * mid thermal suspend implements the suspend functionality
  * by stopping the ADC. Can sleep.
  */
-static int mid_thermal_suspend(struct platform_device *pdev, pm_message_t mesg)
+static int mid_thermal_suspend(struct device *dev)
 {
 	/*
 	 * This just stops the ADC and does not disable it.
@@ -444,6 +444,9 @@ static int mid_thermal_suspend(struct pl
 	return configure_adc(0);
 }
 
+static SIMPLE_DEV_PM_OPS(mid_thermal_pm,
+			 mid_thermal_suspend, mid_thermal_resume);
+
 /**
  * read_curr_temp - reads the current temperature and stores in temp
  * @temp: holds the current temperature value after reading
@@ -557,10 +560,9 @@ static struct platform_driver mid_therma
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
+		.pm = &mid_thermal_pm,
 	},
 	.probe = mid_thermal_probe,
-	.suspend = mid_thermal_suspend,
-	.resume = mid_thermal_resume,
 	.remove = __devexit_p(mid_thermal_remove),
 	.id_table = therm_id_table,
 };

