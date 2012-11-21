Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab2KUHC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:02:59 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:38836 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754Ab2KUHC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:02:58 -0500
Date: Wed, 21 Nov 2012 00:02:51 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: [PATCH v3] TPM: Provide a tpm_tis OF driver
Message-ID: <20121121070251.GC19837@obsidianresearch.com>
References: <20121002210453.GA12231@obsidianresearch.com>
 <20121010162428.GA5013@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010162428.GA5013@ennui.austin.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides an open firwmare driver binding for tpm_tis. OF
is useful on arches where PNP is not used.

Allow the tpm_tis driver to be selected if PNP or OF are compiled in.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/Kconfig   |    2 +-
 drivers/char/tpm/tpm_tis.c |   76 ++++++++++++++++++++++++++++++++++++-------
 2 files changed, 64 insertions(+), 14 deletions(-)

v3 changes
 - Rebase and retest on PPC against 3.7-rc6
 - Compile test on x86-64
 - Include of.h so that of_match_ptr works when CONFIG_OF=n
 - Drop the errant consts

Sorry for the long delay getting these fixes turned around.

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 915875e..31faef6 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -26,7 +26,7 @@ if TCG_TPM
 
 config TCG_TIS
 	tristate "TPM Interface Specification 1.2 Interface"
-	depends on X86
+	depends on X86 || OF
 	---help---
 	  If you have a TPM security chip that is compliant with the
 	  TCG TIS 1.2 TPM specification say Yes and it will be accessible
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 6bdf267..1ebba01 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -27,6 +27,8 @@
 #include <linux/wait.h>
 #include <linux/acpi.h>
 #include <linux/freezer.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 #include "tpm.h"
 
 enum tis_access {
@@ -507,7 +509,7 @@ module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
 static int tpm_tis_init(struct device *dev, resource_size_t start,
-			resource_size_t len, unsigned int irq)
+			resource_size_t len, int irq, int irq_autoprobe)
 {
 	u32 vendor, intfcaps, intmask;
 	int rc, i, irq_s, irq_e, probe;
@@ -605,9 +607,12 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	iowrite32(intmask,
 		  chip->vendor.iobase +
 		  TPM_INT_ENABLE(chip->vendor.locality));
-	if (interrupts)
-		chip->vendor.irq = irq;
-	if (interrupts && !chip->vendor.irq) {
+	if (!interrupts) {
+		irq = 0;
+		irq_autoprobe = 0;
+	}
+	chip->vendor.irq = irq;
+	if (irq == 0 && irq_autoprobe) {
 		irq_s =
 		    ioread8(chip->vendor.iobase +
 			    TPM_INT_VECTOR(chip->vendor.locality));
@@ -740,13 +745,11 @@ static int __devinit tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 
 	if (pnp_irq_valid(pnp_dev, 0))
 		irq = pnp_irq(pnp_dev, 0);
-	else
-		interrupts = 0;
 
 	if (is_itpm(pnp_dev))
 		itpm = 1;
 
-	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
+	return tpm_tis_init(&pnp_dev->dev, start, len, irq, 0);
 }
 
 static int tpm_tis_pnp_suspend(struct pnp_dev *dev, pm_message_t msg)
@@ -822,12 +825,52 @@ static int tpm_tis_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
 
-static struct platform_driver tis_drv = {
+#ifdef CONFIG_OF
+static const struct of_device_id tis_of_platform_match[] __devinitdata = {
+	{.compatible = "tcg,tpm_tis"},
+	{},
+};
+MODULE_DEVICE_TABLE(of, tis_of_platform_match);
+
+static int __devinit tis_of_probe_one(struct platform_device *pdev)
+{
+	const struct resource *res;
+	int irq;
+
+	if (!pdev->dev.of_node)
+		return -ENODEV;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENODEV;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		irq = 0;
+	return tpm_tis_init(&pdev->dev, res->start, res->end - res->start + 1,
+			    irq, 0);
+}
+
+static int __devexit tis_of_remove_one(struct platform_device *odev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(&odev->dev);
+	tpm_dev_vendor_release(chip);
+	kfree(chip);
+	return 0;
+}
+#endif
+
+static struct platform_driver tis_driver = {
 	.driver = {
 		.name = "tpm_tis",
 		.owner		= THIS_MODULE,
 		.pm		= &tpm_tis_pm,
+		.of_match_table = of_match_ptr(tis_of_platform_match),
 	},
+#ifdef CONFIG_OF
+	.probe = tis_of_probe_one,
+	.remove = __devexit_p(tis_of_remove_one)
+#endif
 };
 
 static struct platform_device *pdev;
@@ -843,15 +886,22 @@ static int __init init_tis(void)
 		return pnp_register_driver(&tis_pnp_driver);
 #endif
 
-	rc = platform_driver_register(&tis_drv);
+	rc = platform_driver_register(&tis_driver);
 	if (rc < 0)
 		return rc;
-	if (IS_ERR(pdev=platform_device_register_simple("tpm_tis", -1, NULL, 0)))
+	/* TIS_MEM_BASE is only going to work on x86.. */
+#ifndef CONFIG_OF
+	pdev = platform_device_register_simple("tpm_tis", -1, NULL, 0);
+	if (IS_ERR(pdev)) {
+		platform_driver_unregister(&tis_driver);
 		return PTR_ERR(pdev);
-	if((rc=tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0)) != 0) {
+	}
+	rc = tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0, 1);
+	if (rc != 0) {
 		platform_device_unregister(pdev);
-		platform_driver_unregister(&tis_drv);
+		platform_driver_unregister(&tis_driver);
 	}
+#endif
 	return rc;
 }
 
@@ -883,7 +933,7 @@ static void __exit cleanup_tis(void)
 	}
 #endif
 	platform_device_unregister(pdev);
-	platform_driver_unregister(&tis_drv);
+	platform_driver_unregister(&tis_driver);
 }
 
 module_init(init_tis);
-- 
1.7.4.1

