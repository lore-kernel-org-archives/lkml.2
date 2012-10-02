Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab2JBVFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 17:05:03 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:49767 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab2JBVE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 17:04:59 -0400
Date: Tue, 2 Oct 2012 15:04:53 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v2] TPM: Provide a tpm_tis OF driver
Message-ID: <20121002210453.GA12231@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides an open firwmare driver binding for tpm_tis. OF
is useful on arches where PNP is not used.

Allow the tpm_tis driver to be selected if OF is compiled in.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/Kconfig   |    2 +-
 drivers/char/tpm/tpm_tis.c |   79 +++++++++++++++++++++++++++++++++++--------
 2 files changed, 65 insertions(+), 16 deletions(-)

v2 changes:
 - Add irq_autoprobe to tpm_tis_init to simplify the logic around
   the autoprobe function
 - Use platform functions in tis_of_probe_one
 - Rename tis_drv to tis_driver to silence MODPOST warnings
 - checkpatch cleanups
 - Do not attempt to auto-probe the TPM on OF configurations

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index a048199..a346714 100644
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
index c4be351..23c6562 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -27,6 +27,7 @@
 #include <linux/wait.h>
 #include <linux/acpi.h>
 #include <linux/freezer.h>
+#include <linux/of_device.h>
 #include "tpm.h"
 
 enum tis_access {
@@ -507,7 +508,7 @@ module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
 static int tpm_tis_init(struct device *dev, resource_size_t start,
-			resource_size_t len, unsigned int irq)
+			resource_size_t len, int irq, int irq_autoprobe)
 {
 	u32 vendor, intfcaps, intmask;
 	int rc, i, irq_s, irq_e, probe;
@@ -605,9 +606,12 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
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
@@ -739,13 +743,11 @@ static int __devinit tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 
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
@@ -768,7 +770,7 @@ static int tpm_tis_pnp_resume(struct pnp_dev *dev)
 	return ret;
 }
 
-static struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
+static const struct pnp_device_id tpm_pnp_tbl[] __devinitdata = {
 	{"PNP0C31", 0},		/* TPM */
 	{"ATM1200", 0},		/* Atmel */
 	{"IFX0102", 0},		/* Infineon */
@@ -792,7 +794,7 @@ static __devexit void tpm_tis_pnp_remove(struct pnp_dev *dev)
 }
 
 
-static struct pnp_driver tis_pnp_driver = {
+static const struct pnp_driver tis_pnp_driver = {
 	.name = "tpm_tis",
 	.id_table = tpm_pnp_tbl,
 	.probe = tpm_tis_pnp_init,
@@ -821,12 +823,52 @@ static int tpm_tis_resume(struct device *dev)
 
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
@@ -842,15 +884,22 @@ static int __init init_tis(void)
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
 
@@ -882,7 +931,7 @@ static void __exit cleanup_tis(void)
 	}
 #endif
 	platform_device_unregister(pdev);
-	platform_driver_unregister(&tis_drv);
+	platform_driver_unregister(&tis_driver);
 }
 
 module_init(init_tis);
-- 
1.7.5.4

