Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab0EMUiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:38:10 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:35533 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab0EMUiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:38:04 -0400
Subject: Re: [PATCH] TPM: ACPI/PNP dependency removal
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, zohar@linux.vnet.ibm.com
In-Reply-To: <4BEC6141.2010201@oracle.com>
References: <1273782204.8536.4.camel@blackbox.ibm.com>
	 <4BEC6141.2010201@oracle.com>
Content-Type: text/plain
Organization: IBM
Date: Thu, 13 May 2010 17:37:54 -0300
Message-Id: <1273783074.8536.6.camel@blackbox.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch pushes the ACPI dependency into the device driver code
itself. Now, even without ACPI/PNP enabled, the device can be registered
using the TIS specified memory space. This will however result in the
lack of access to the BIOS event log, being the only implication of such
ACPI removal.

Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
---
 drivers/char/tpm/Kconfig   |    6 ++++--
 drivers/char/tpm/tpm_tis.c |   42 ++++++++++++++++++++++--------------------
 2 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index f5fc64f..fffc994 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -17,14 +17,16 @@ menuconfig TCG_TPM
 	  obtained at: <http://sourceforge.net/projects/trousers>.  To 
 	  compile this driver as a module, choose M here; the module 
 	  will be called tpm. If unsure, say N.
-	  Note: For more TPM drivers enable CONFIG_PNP, CONFIG_ACPI
+	  Notes: 
+	  1) For more TPM drivers enable CONFIG_PNP, CONFIG_ACPI
 	  and CONFIG_PNPACPI.
+	  2) Without ACPI enabled, the BIOS event log won't be accessible,
+	  which is required to validate the PCR 0-7 values.
 
 if TCG_TPM
 
 config TCG_TIS
 	tristate "TPM Interface Specification 1.2 Interface"
-	depends on PNP
 	---help---
 	  If you have a TPM security chip that is compliant with the
 	  TCG TIS 1.2 TPM specification say Yes and it will be accessible
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 27e8de4..2423d66 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -597,7 +597,7 @@ out_err:
 	tpm_remove_hardware(chip->dev);
 	return rc;
 }
-
+#ifdef CONFIG_PNP
 static int __devinit tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 				      const struct pnp_device_id *pnp_id)
 {
@@ -661,7 +661,7 @@ static struct pnp_driver tis_pnp_driver = {
 module_param_string(hid, tpm_pnp_tbl[TIS_HID_USR_IDX].id,
 		    sizeof(tpm_pnp_tbl[TIS_HID_USR_IDX].id), 0444);
 MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
-
+#endif
 static int tpm_tis_suspend(struct platform_device *dev, pm_message_t msg)
 {
 	return tpm_pm_suspend(&dev->dev, msg);
@@ -688,21 +688,21 @@ MODULE_PARM_DESC(force, "Force device probe rather than using ACPI entry");
 static int __init init_tis(void)
 {
 	int rc;
-
-	if (force) {
-		rc = platform_driver_register(&tis_drv);
-		if (rc < 0)
-			return rc;
-		if (IS_ERR(pdev=platform_device_register_simple("tpm_tis", -1, NULL, 0)))
-			return PTR_ERR(pdev);
-		if((rc=tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0)) != 0) {
-			platform_device_unregister(pdev);
-			platform_driver_unregister(&tis_drv);
-		}
+#ifdef CONFIG_PNP
+	if (!force)
+		return pnp_register_driver(&tis_pnp_driver);
+#endif
+		
+	rc = platform_driver_register(&tis_drv);
+	if (rc < 0)
 		return rc;
+	if (IS_ERR(pdev=platform_device_register_simple("tpm_tis", -1, NULL, 0)))
+		return PTR_ERR(pdev);
+	if((rc=tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0)) != 0) {
+		platform_device_unregister(pdev);
+		platform_driver_unregister(&tis_drv);
 	}
-
-	return pnp_register_driver(&tis_pnp_driver);
+	return rc;
 }
 
 static void __exit cleanup_tis(void)
@@ -726,12 +726,14 @@ static void __exit cleanup_tis(void)
 		list_del(&i->list);
 	}
 	spin_unlock(&tis_lock);
-
-	if (force) {
-		platform_device_unregister(pdev);
-		platform_driver_unregister(&tis_drv);
-	} else
+#ifdef CONFIG_PNP
+	if (!force) {
 		pnp_unregister_driver(&tis_pnp_driver);
+		return;
+	}
+#endif
+	platform_device_unregister(pdev);
+	platform_driver_unregister(&tis_drv);
 }
 
 module_init(init_tis);
-- 
1.6.6.1



