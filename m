Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab0LIRYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:24:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:31247 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299Ab0LIRYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:24:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="634782787"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com, dmitry.kasatkin@nokia.com
Subject: [PATCH 04/11] sep: clean up error checking in probe function
Date: Thu,  9 Dec 2010 09:31:18 -0800
Message-Id: <1291915878-18430-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pci_disable

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_driver.c |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 241b1b1..821d3b7 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -3437,7 +3437,8 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	if (sep_dev == NULL) {
 		dev_warn(&pdev->dev,
 			"can't kmalloc the sep_device structure\n");
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto end_function_disable_device;
 	}
 
 	/*
@@ -3448,7 +3449,7 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	 */
 	sep = sep_dev;
 
-	sep->pdev = pdev;
+	sep->pdev = pci_dev_get(pdev);
 
 	init_waitqueue_head(&sep->event);
 	init_waitqueue_head(&sep->event_request_daemon);
@@ -3466,23 +3467,23 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	sep->reg_physical_addr = pci_resource_start(sep->pdev, 0);
 	if (!sep->reg_physical_addr) {
 		dev_warn(&sep->pdev->dev, "Error getting register start\n");
-		pci_dev_put(sep->pdev);
-		return -ENODEV;
+		error = -ENODEV;
+		goto end_function_free_sep_dev;
 	}
 
 	sep->reg_physical_end = pci_resource_end(sep->pdev, 0);
 	if (!sep->reg_physical_end) {
 		dev_warn(&sep->pdev->dev, "Error getting register end\n");
-		pci_dev_put(sep->pdev);
-		return -ENODEV;
+		error = -ENODEV;
+		goto end_function_free_sep_dev;
 	}
 
 	sep->reg_addr = ioremap_nocache(sep->reg_physical_addr,
 		(size_t)(sep->reg_physical_end - sep->reg_physical_addr + 1));
 	if (!sep->reg_addr) {
 		dev_warn(&sep->pdev->dev, "Error getting register virtual\n");
-		pci_dev_put(sep->pdev);
-		return -ENODEV;
+		error = -ENODEV;
+		goto end_function_free_sep_dev;
 	}
 
 	dev_dbg(&sep->pdev->dev,
@@ -3573,9 +3574,15 @@ end_function_deallocate_sep_shared_area:
 
 end_function_error:
 	iounmap(sep->reg_addr);
+
+end_function_free_sep_dev:
+	pci_dev_put(sep_dev->pdev);
 	kfree(sep_dev);
 	sep_dev = NULL;
 
+end_function_disable_device:
+	pci_disable_device(pdev);
+
 end_function:
 	return error;
 }
-- 
1.6.3.3

