Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762395Ab2DLJko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 05:40:44 -0400
Received: from smtp.nokia.com ([147.243.128.24]:17026 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233Ab2DLJkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 05:40:43 -0400
From: Pasi Savanainen <ext-pasi.m.savanainen@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] mfd: Convert Intel MSIC driver to use devm_* interfaces.
Date: Thu, 12 Apr 2012 12:40:37 +0300
Message-Id: <1334223637-16965-1-git-send-email-ext-pasi.m.savanainen@nokia.com>
X-Mailer: git-send-email 1.7.5.4
Content-Type: text/plain; charset="us-ascii"
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devm_* functions eliminate the need for manual resource releasing
and simplify error handling. Resources allocated by devm_* are freed
automatically on driver detach.

Signed-off-by: Pasi Savanainen <ext-pasi.m.savanainen@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/mfd/intel_msic.c |   31 +++++--------------------------
 1 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/mfd/intel_msic.c b/drivers/mfd/intel_msic.c
index b76657e..59df558 100644
--- a/drivers/mfd/intel_msic.c
+++ b/drivers/mfd/intel_msic.c
@@ -406,7 +406,7 @@ static int __devinit intel_msic_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	msic = kzalloc(sizeof(*msic), GFP_KERNEL);
+	msic = devm_kzalloc(&pdev->dev, sizeof(*msic), GFP_KERNEL);
 	if (!msic)
 		return -ENOMEM;
 
@@ -421,21 +421,13 @@ static int __devinit intel_msic_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "failed to get SRAM iomem resource\n");
-		ret = -ENODEV;
-		goto fail_free_msic;
+		return -ENODEV;
 	}
 
-	res = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (!res) {
-		ret = -EBUSY;
-		goto fail_free_msic;
-	}
-
-	msic->irq_base = ioremap_nocache(res->start, resource_size(res));
+	msic->irq_base = devm_request_and_ioremap(&pdev->dev, res);
 	if (!msic->irq_base) {
 		dev_err(&pdev->dev, "failed to map SRAM memory\n");
-		ret = -ENOMEM;
-		goto fail_release_region;
+		return -ENOMEM;
 	}
 
 	platform_set_drvdata(pdev, msic);
@@ -443,7 +435,7 @@ static int __devinit intel_msic_probe(struct platform_device *pdev)
 	ret = intel_msic_init_devices(msic);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to initialize MSIC devices\n");
-		goto fail_unmap_mem;
+		return ret;
 	}
 
 	dev_info(&pdev->dev, "Intel MSIC version %c%d (vendor %#x)\n",
@@ -451,27 +443,14 @@ static int __devinit intel_msic_probe(struct platform_device *pdev)
 		 msic->vendor);
 
 	return 0;
-
-fail_unmap_mem:
-	iounmap(msic->irq_base);
-fail_release_region:
-	release_mem_region(res->start, resource_size(res));
-fail_free_msic:
-	kfree(msic);
-
-	return ret;
 }
 
 static int __devexit intel_msic_remove(struct platform_device *pdev)
 {
 	struct intel_msic *msic = platform_get_drvdata(pdev);
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	intel_msic_remove_devices(msic);
 	platform_set_drvdata(pdev, NULL);
-	iounmap(msic->irq_base);
-	release_mem_region(res->start, resource_size(res));
-	kfree(msic);
 
 	return 0;
 }
-- 
1.7.5.4

