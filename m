Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492Ab2GDWIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 18:08:16 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53271 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab2GDWHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 18:07:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 3/4] tpm_tis: Use struct dev_pm_ops for power management
Date: Thu, 5 Jul 2012 00:11:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, tpmdd-devel@lists.sourceforge.net,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>
References: <201207050008.02097.rjw@sisk.pl>
In-Reply-To: <201207050008.02097.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207050011.16406.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make the tpm_tis driver define its PM callbacks through
a struct dev_pm_ops object rather than by using legacy PM hooks
in struct platform_driver.

This allows the driver to use tpm_pm_suspend() as its suspend
callback directly, without defining its own suspend callback
routine.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/char/tpm/tpm_tis.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

Index: linux/drivers/char/tpm/tpm_tis.c
===================================================================
--- linux.orig/drivers/char/tpm/tpm_tis.c
+++ linux/drivers/char/tpm/tpm_tis.c
@@ -806,27 +806,25 @@ module_param_string(hid, tpm_pnp_tbl[TIS
 		    sizeof(tpm_pnp_tbl[TIS_HID_USR_IDX].id), 0444);
 MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
 #endif
-static int tpm_tis_suspend(struct platform_device *dev, pm_message_t msg)
-{
-	return tpm_pm_suspend(&dev->dev);
-}
 
-static int tpm_tis_resume(struct platform_device *dev)
+static int tpm_tis_resume(struct device *dev)
 {
-	struct tpm_chip *chip = dev_get_drvdata(&dev->dev);
+	struct tpm_chip *chip = dev_get_drvdata(dev);
 
 	if (chip->vendor.irq)
 		tpm_tis_reenable_interrupts(chip);
 
-	return tpm_pm_resume(&dev->dev);
+	return tpm_pm_resume(dev);
 }
+
+static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
+
 static struct platform_driver tis_drv = {
 	.driver = {
 		.name = "tpm_tis",
 		.owner		= THIS_MODULE,
+		.pm		= &tpm_tis_pm,
 	},
-	.suspend = tpm_tis_suspend,
-	.resume = tpm_tis_resume,
 };
 
 static struct platform_device *pdev;

