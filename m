Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab0LIRZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:25:07 -0500
Received: from mga14.intel.com ([143.182.124.37]:38285 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210Ab0LIRZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:25:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,320,1288594800"; 
   d="scan'208";a="359434971"
From: Mark Allyn <mark.a.allyn@intel.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com, mark.a.allyn@intel.com,
        alan@linux.intel.com, dmitry.kasatkin@nokia.com
Subject: [PATCH 06/11] sep: remove code for Moorestown device
Date: Thu,  9 Dec 2010 09:31:43 -0800
Message-Id: <1291915903-18506-1-git-send-email-mark.a.allyn@intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Moorestown (older device) will be added to driver
later.

Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
---
 drivers/staging/sep/sep_driver.c         |  110 ++++++------------------------
 drivers/staging/sep/sep_driver_hw_defs.h |    1 -
 2 files changed, 20 insertions(+), 91 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index c800824..5a54f98 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -940,9 +940,7 @@ static int sep_send_command_handler(struct sep_device *sep)
 	}
 	sep_set_time(sep);
 
-	/* Only Medfield has caller id */
-	if (sep->mrst == 0)
-		sep_set_current_caller_id(sep);
+	sep_set_current_caller_id(sep);
 
 	sep_dump_message(sep);
 
@@ -3057,8 +3055,6 @@ static long sep_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		error = sep_end_transaction_handler(sep);
 		break;
 	case SEP_IOCREALLOCEXTCACHE:
-		if (sep->mrst)
-			error = -ENODEV;
 		if (sep->pdev->revision == 0) /* Only for old chip */
 			error = sep_realloc_ext_cache_handler(sep, arg);
 		else
@@ -3238,55 +3234,6 @@ static irqreturn_t sep_inthandler(int irq, void *dev_id)
 }
 
 /**
- *	sep_callback - RAR callback
- *	@sep_context_pointer: pointer to struct sep_device
- *
- *	Function that is called by rar_register when it is ready with
- *	a region (only for Moorestown)
- */
-static int sep_callback(unsigned long sep_context_pointer)
-{
-	int error;
-	struct sep_device *sep = (struct sep_device *)sep_context_pointer;
-	dma_addr_t rar_end_address;
-
-	dev_dbg(&sep->pdev->dev, "callback start\n");
-
-	error = rar_get_address(RAR_TYPE_IMAGE, &sep->rar_bus,
-							&rar_end_address);
-
-	if (error) {
-		dev_warn(&sep->pdev->dev, "mrst can't get rar region\n");
-		goto end_function;
-	}
-
-	sep->rar_size = (size_t)(rar_end_address - sep->rar_bus + 1);
-
-	if (!request_mem_region(sep->rar_bus, sep->rar_size,
-							"sep_sec_driver")) {
-		dev_warn(&sep->pdev->dev,
-				"request mem region for mrst failed\n");
-		error = -1;
-		goto end_function;
-	}
-
-	sep->rar_addr = ioremap_nocache(sep->rar_bus, sep->rar_size);
-	if (!sep->rar_addr) {
-		dev_warn(&sep->pdev->dev,
-				"ioremap nocache for mrst rar failed\n");
-		error = -ENOMEM;
-		goto end_function;
-	}
-	dev_dbg(&sep->pdev->dev, "rar start is %p, phy is %llx, size is %zx\n",
-			sep->rar_addr, (unsigned long long)sep->rar_bus,
-			sep->rar_size);
-
-end_function:
-	dev_dbg(&sep->pdev->dev, "callback end\n");
-	return error;
-}
-
-/**
  *	sep_reconfig_shared_area - reconfigure shared area
  *	@sep: pointer to struct sep_device
  *
@@ -3390,16 +3337,14 @@ static int sep_register_driver_with_fs(struct sep_device *sep)
 		return ret_val;
 	}
 
-	if (!sep->mrst) {
-		ret_val = misc_register(&sep->miscdev_daemon);
-		if (ret_val) {
-			dev_warn(&sep->pdev->dev, "misc reg fails for dmn %x\n",
-				ret_val);
-			misc_deregister(&sep->miscdev_sep);
-			misc_deregister(&sep->miscdev_singleton);
+	ret_val = misc_register(&sep->miscdev_daemon);
+	if (ret_val) {
+		dev_warn(&sep->pdev->dev, "misc reg fails for dmn %x\n",
+			ret_val);
+		misc_deregister(&sep->miscdev_sep);
+		misc_deregister(&sep->miscdev_singleton);
 
-			return ret_val;
-		}
+		return ret_val;
 	}
 	return ret_val;
 }
@@ -3457,9 +3402,6 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	mutex_init(&sep->sep_mutex);
 	mutex_init(&sep->ioctl_mutex);
 
-	if (pdev->device == MRST_PCI_DEVICE_ID)
-		sep->mrst = 1;
-
 	dev_dbg(&sep->pdev->dev, "PCI obtained, device being prepared\n");
 	dev_dbg(&sep->pdev->dev, "revision is %d\n", sep->pdev->revision);
 
@@ -3505,31 +3447,20 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 		goto end_function_error;
 	}
 
-	/* The next section depends on type of unit */
-	if (sep->mrst) {
-		error = register_rar(RAR_TYPE_IMAGE, &sep_callback,
-			(unsigned long)sep);
-		if (error) {
-			dev_dbg(&sep->pdev->dev,
-				"error register_rar\n");
-			goto end_function_deallocate_sep_shared_area;
-		}
-	} else {
-		sep->rar_size = FAKE_RAR_SIZE;
-		sep->rar_addr = dma_alloc_coherent(NULL,
-			sep->rar_size, &sep->rar_bus, GFP_KERNEL);
-		if (sep->rar_addr == NULL) {
-			dev_warn(&sep->pdev->dev, "can't allocate mfld rar\n");
-			error = -ENOMEM;
-			goto end_function_deallocate_sep_shared_area;
-		}
-
-		dev_dbg(&sep->pdev->dev, "rar start is %p, phy is %llx,"
-			" size is %zx\n", sep->rar_addr,
-			(unsigned long long)sep->rar_bus,
-			sep->rar_size);
+	sep->rar_size = FAKE_RAR_SIZE;
+	sep->rar_addr = dma_alloc_coherent(NULL,
+		sep->rar_size, &sep->rar_bus, GFP_KERNEL);
+	if (sep->rar_addr == NULL) {
+		dev_warn(&sep->pdev->dev, "can't allocate mfld rar\n");
+		error = -ENOMEM;
+		goto end_function_deallocate_sep_shared_area;
 	}
 
+	dev_dbg(&sep->pdev->dev, "rar start is %p, phy is %llx,"
+		" size is %zx\n", sep->rar_addr,
+		(unsigned long long)sep->rar_bus,
+		sep->rar_size);
+
 	dev_dbg(&sep->pdev->dev, "about to write IMR and ICR REG_ADDR\n");
 
 	/* Clear ICR register */
@@ -3610,7 +3541,6 @@ static void sep_remove(struct pci_dev *pdev)
 }
 
 static DEFINE_PCI_DEVICE_TABLE(sep_pci_id_tbl) = {
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MRST_PCI_DEVICE_ID)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MFLD_PCI_DEVICE_ID)},
 	{0}
 };
diff --git a/drivers/staging/sep/sep_driver_hw_defs.h b/drivers/staging/sep/sep_driver_hw_defs.h
index 29addd7..300f909 100644
--- a/drivers/staging/sep/sep_driver_hw_defs.h
+++ b/drivers/staging/sep/sep_driver_hw_defs.h
@@ -33,7 +33,6 @@
 #define SEP_DRIVER_HW_DEFS__H
 
 /* PCI ID's */
-#define MRST_PCI_DEVICE_ID 0x080c
 #define MFLD_PCI_DEVICE_ID 0x0826
 
 /*----------------------- */
-- 
1.6.3.3

