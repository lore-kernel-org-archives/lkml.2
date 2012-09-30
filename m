Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab2I3Xb5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 19:31:57 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:48368 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab2I3Xb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 19:31:56 -0400
Date: Sun, 30 Sep 2012 17:31:56 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH] TPM: Provide a tpm_tis OF driver
Message-ID: <20120930233156.GI30637@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
 drivers/char/tpm/tpm_tis.c |   56 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 54 insertions(+), 4 deletions(-)

This is a rebase, retest, resend of a patch I sent two years ago...

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
index c4be351..0a890ed 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -27,6 +27,9 @@
 #include <linux/wait.h>
 #include <linux/acpi.h>
 #include <linux/freezer.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
 #include "tpm.h"
 
 enum tis_access {
@@ -506,8 +509,10 @@ static bool interrupts = 1;
 module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
+/* irq == 0 -> autoprobe, -1 ->forced no interrupt,
+   others -> irq line to use */
 static int tpm_tis_init(struct device *dev, resource_size_t start,
-			resource_size_t len, unsigned int irq)
+			resource_size_t len, int irq)
 {
 	u32 vendor, intfcaps, intmask;
 	int rc, i, irq_s, irq_e, probe;
@@ -605,9 +610,11 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	iowrite32(intmask,
 		  chip->vendor.iobase +
 		  TPM_INT_ENABLE(chip->vendor.locality));
-	if (interrupts)
+	if (!interrupts)
+		irq = -1;
+	if (irq != -1)
 		chip->vendor.irq = irq;
-	if (interrupts && !chip->vendor.irq) {
+	if (irq == 0) {
 		irq_s =
 		    ioread8(chip->vendor.iobase +
 			    TPM_INT_VECTOR(chip->vendor.locality));
@@ -821,12 +828,53 @@ static int tpm_tis_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(tpm_tis_pm, tpm_pm_suspend, tpm_tis_resume);
 
+#ifdef CONFIG_OF
+static struct of_device_id tis_of_platform_match[] = {
+	{.compatible = "tcg,tpm_tis"},
+	{},
+};
+static int __devinit tis_of_init_one(struct platform_device *pdev)
+{
+	struct resource res;
+	int ret;
+	int irq;
+
+	if (!pdev->dev.of_node)
+		return -ENODEV;
+
+	ret = of_address_to_resource(pdev->dev.of_node, 0, &res);
+	if (ret)
+		return ret;
+
+	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
+	if (irq == NO_IRQ)
+		irq = -1;
+	return tpm_tis_init(&pdev->dev, res.start, res.end - res.start + 1,
+			    irq);
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
 static struct platform_driver tis_drv = {
 	.driver = {
 		.name = "tpm_tis",
 		.owner		= THIS_MODULE,
 		.pm		= &tpm_tis_pm,
+#ifdef CONFIG_OF
+		.of_match_table = tis_of_platform_match,
+#endif
 	},
+#ifdef CONFIG_OF
+	.probe = tis_of_init_one,
+	.remove = __devexit_p(tis_of_remove_one)
+#endif
 };
 
 static struct platform_device *pdev;
@@ -849,7 +897,9 @@ static int __init init_tis(void)
 		return PTR_ERR(pdev);
 	if((rc=tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0)) != 0) {
 		platform_device_unregister(pdev);
+#ifndef CONFIG_OF
 		platform_driver_unregister(&tis_drv);
+#endif
 	}
 	return rc;
 }
-- 
1.7.4.1

