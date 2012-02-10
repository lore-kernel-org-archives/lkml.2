Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321Ab2BJNjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 08:39:31 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42058 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab2BJNj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 08:39:28 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 4/6] sep: update initialisation
To: greg@kroah.com, linux-kernel@vger.kernel.org, mark.a.allyn@intel.com
Date: Fri, 10 Feb 2012 13:53:08 +0000
Message-ID: <20120210135306.12442.41197.stgit@bob.linux.org.uk>
In-Reply-To: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
References: <20120210134929.12442.59041.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark A. Allyn <mark.a.allyn@intel.com>

In particular we want to always do the reconfigure

[This is picked out of the differences between the upstream driver and
 the staging driver. I'm resolving the differences as a series of updates -AC]

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_main.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)


diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 1fcabca..db51895 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -4150,7 +4150,6 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 
 	dev_dbg(&sep->pdev->dev, "sep probe: PCI obtained, "
 		"device being prepared\n");
-	dev_dbg(&sep->pdev->dev, "revision is %d\n", sep->pdev->revision);
 
 	/* Set up our register area */
 	sep->reg_physical_addr = pci_resource_start(sep->pdev, 0);
@@ -4213,38 +4212,39 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 		goto end_function_deallocate_sep_shared_area;
 
 	/* The new chip requires a shared area reconfigure */
-	if (sep->pdev->revision != 0) { /* Only for new chip */
-		error = sep_reconfig_shared_area(sep);
-		if (error)
-			goto end_function_free_irq;
-	}
+	error = sep_reconfig_shared_area(sep);
+	if (error)
+		goto end_function_free_irq;
 
 	sep->in_use = 1;
 
 	/* Finally magic up the device nodes */
 	/* Register driver with the fs */
 	error = sep_register_driver_with_fs(sep);
-	if (error)
+
+	if (error) {
+		dev_err(&sep->pdev->dev, "error registering dev file\n");
 		goto end_function_free_irq;
+	}
 
+	sep->in_use = 0; /* through touching the device */
 #ifdef SEP_ENABLE_RUNTIME_PM
 	pm_runtime_put_noidle(&sep->pdev->dev);
 	pm_runtime_allow(&sep->pdev->dev);
 	pm_runtime_set_autosuspend_delay(&sep->pdev->dev,
 		SUSPEND_DELAY);
 	pm_runtime_use_autosuspend(&sep->pdev->dev);
+	pm_runtime_mark_last_busy(&sep->pdev->dev);
 	sep->power_save_setup = 1;
 #endif
-
-	sep->in_use = 0;
-
 	/* register kernel crypto driver */
+#if defined(CONFIG_CRYPTO)
 	error = sep_crypto_setup();
 	if (error) {
-		dev_dbg(&sep->pdev->dev, "crypto setup fail\n");
+		dev_err(&sep->pdev->dev, "crypto setup failed\n");
 		goto end_function_free_irq;
 	}
-
+#endif
 	goto end_function;
 
 end_function_free_irq:
@@ -4292,7 +4292,7 @@ static void sep_remove(struct pci_dev *pdev)
 
 	/* Free the shared area  */
 	sep_unmap_and_free_shared_area(sep_dev);
-	iounmap((void __iomem *)sep_dev->reg_addr);
+	iounmap(sep_dev->reg_addr);
 
 #ifdef SEP_ENABLE_RUNTIME_PM
 	if (sep->in_use) {

