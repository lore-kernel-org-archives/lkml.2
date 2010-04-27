Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0D0LCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:02:20 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:14608 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754586Ab0D0LCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:02:14 -0400
Message-ID: <002301cae5f9$1622b070$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Intel OTC" <joel.clark@intel.com>,
       "Andrew" <andrew.chih.howe.khor@intel.com>
Subject: [PATCH] Topcliff DMA: Add the DMA driver [4/4]
MIME-Version: 1.0
Date: Tue, 27 Apr 2010 20:01:44 +0900
Content-Type: message/partial;
	total=4;
	id="01CAE5F9.14BABC00@tsmail03";
	number=4
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


+ pci_iounmap(pdev, (void *)dev->base_addr);
+ dev->base_addr = 0;
+ PCH_DEBUG("pch_dma_remove -> Function pci_iounmap invoked "
+    "successfully.\n");
+
+ /* Releasing the requested regions. */
+ pci_release_regions(pdev);
+ PCH_DEBUG("pch_dma_remove -> Function pci_release_regions "
+    "invoked successfully.\n");
+
+ /* Disabling the device. */
+ pci_disable_device(pdev);
+ PCH_DEBUG("pch_dma_remove -> Function pci_disable_device "
+    "invoked successfully.\n");
+
+ PCH_DEBUG("Function pch_dma_remove invoked  "
+    "successfully for device %x.\n", pdev->device);
+}
+
+#ifdef CONFIG_PM
+/*! @ingroup PCILayerAPI
+ @fn  static int pch_dma_suspend(struct pci_dev* pdev,
+    pm_message_t state)
+ @brief  Implements the suspend function for the pci_driver.
+ @remarks This function is used as the suspend function of the PCI
+    Driver.
+    The PCI core will be invoking this function once
+    it receives a suspend event from the PM layer.
+    The main tasks performed by this functions are:
+    - Prepares the device so that it can enter the
+    suspend state by saving the current state.
+    - Disables all the DMA channels and the
+    associated interrupts.
+    - Changes the power state of the device to low
+    power state.
+
+ @param pdev [@ref INOUT] Reference to the pci_device structure.
+ @param state [@ref IN] The state of the device.
+
+ @return int
+   - @ref PCH_DMA_SUCCESS --> On success.
+   - -ENOMEM --> pci_save_state error status code.
+
+ @see
+   - pch_dma_controller_driver
+  */
+static int pch_dma_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+ int retval;
+ struct pch_dma_devices *dev;
+
+ /* Setting flag for denoting Suspension. */
+ pch_device_suspended = 1;
+
+ /* Getting the driver data. */
+ dev = pci_get_drvdata(pdev);
+
+ /* Saving the current state of the device. */
+ retval = pci_save_state(pdev);
+ if (retval == 0) {
+  PCH_DEBUG("pch_dma_suspend -> Function pci_save_state invoked "
+     "successfully (returned %d).\n", retval);
+
+  /* De-initializing the device for suspension. */
+  dma_exit(dev->dev_typ);
+  PCH_DEBUG("pch_dma_suspend -> Function dma_exit invoked "
+     "successfully.\n");
+
+  /* Disabling the wake-up feature. */
+  pci_enable_wake(pdev, PCI_D3hot, 0);
+  PCH_DEBUG("pch_dma_suspend -> Function pci_enable_wake "
+     "invoked successfully.\n");
+
+  /* Setting the device to new state. */
+  pci_set_power_state(pdev, pci_choose_state(pdev, state));
+  PCH_DEBUG("pch_dma_suspend -> Function pci_set_power_state "
+     "invoked successfully.\n");
+
+  /* Disabling the device. */
+  pci_disable_device(pdev);
+  PCH_DEBUG("pch_dma_suspend -> Function pci_disable_device "
+     "invoked successfully.\n");
+
+  retval = PCH_DMA_SUCCESS;
+  PCH_DEBUG("pch_dma_suspend -> Suspension successful for "
+     "the device %x.\n", pdev->device);
+ } else {
+  PCH_LOG(KERN_ERR,
+   "pch_dma_suspend -> Function pci_save_state failed"
+   "returned %d.\n", retval);
+
+  /* De-setting the flag on Suspend failure. */
+  pch_device_suspended = 0;
+
+  PCH_DEBUG("pch_dma_suspend -> Suspension un-successful for "
+     "the device %x.\n", pdev->device);
+ }
+
+ PCH_DEBUG("Function pch_dma_suspend returns %d.\n", retval);
+ return retval;
+}
+
+/*! @ingroup PCILayerAPI
+ @fn   static int pch_dma_resume(struct pci_dev* pdev)
+ @brief  Implements the resume function for the pci_driver.
+ @remarks This function is used as the resume function of the
+    PCI driver. The PCI core will be invoking this
+    function once it receives a resume event from
+    the PM layer. The main tasks performed by this
+    function are:
+    - Restores the power state of the device to
+    normal state.
+    - Enables the device so that it returns to its
+    normal state.
+
+ @param  pdev [@ref INOUT] Pointer to the pci_device
+    structure.
+
+ @return int
+   - @ref PCH_DMA_SUCCESS --> On success.
+   - -EIO  --> pci_enable_device error status code.
+   - -EINVAL --> pci_enable_device .
+
+ @see
+   - pch_dma_controller_driver
+
+  */
+static int pch_dma_resume(struct pci_dev *pdev)
+{
+ int retval;
+
+ /* Setting the device to normal power state. */
+ (void)pci_set_power_state(pdev, PCI_D0);
+ PCH_DEBUG("pch_dma_resume -> Function pci_set_power_state invoked "
+    "successfully.\n");
+
+ /* Restoring the device state. */
+ (void)pci_restore_state(pdev);
+ PCH_DEBUG("pch_dma_resume -> Function pci_restore_state invoked "
+    "successfully.\n");
+
+ /* Enabling the device. */
+ retval = pci_enable_device(pdev);
+
+ if (0 == retval) {
+  PCH_DEBUG("pch_dma_resume -> Function pci_enable_device "
+     "invoked successfully returned %d.\n", retval);
+
+  pci_set_master(pdev);
+  PCH_DEBUG("pch_dma_resume -> Function pci_set_master invoked "
+     "successfully.\n");
+
+  (void)pci_enable_wake(pdev, PCI_D3hot, 0);
+  PCH_DEBUG("pch_dma_resume -> Function pci_enable_wake invoked "
+     "successfully.\n");
+
+  retval = PCH_DMA_SUCCESS;
+
+  /* De-setting the suspend flag to denote resumption
+  successful. */
+  pch_device_suspended = 0;
+
+  PCH_DEBUG("pch_dma_resume -> Resume successful for the "
+     "device %x.\n", pdev->device);
+ } else {
+  PCH_LOG(KERN_ERR,
+   "pch_dma_resume -> Function pci_enable_device failed "
+   "returned %d.\n", retval);
+
+  PCH_DEBUG("pch_dma_resume -> Resume failed for the device "
+     "%x.\n", pdev->device);
+ }
+
+ PCH_DEBUG("Function pch_dma_resume returns %d.\n", retval);
+ return retval;
+}
+#endif
+
+/*! @ingroup PCILayerFacilitators
+ @struct  pch_dma_controller_driver
+ @brief  Used for registering the PCI driver functionalities.
+ @remarks This is an instance of the structure pci_driver which
+    stores references to the PCI Driver
+    functionalities.
+    It is used during PCI driver registration for
+    interfacing the DMA module functionalities with
+    that of the Kernel subsystem.
+
+ @see
+   - pch_dma_pci_init
+   - pch_dma_pci_exit
+*/
+
+static struct pci_driver pch_dma_controller_driver = {
+ .name = "pch_dma",  /**< Name of the module. */
+ .id_table = pch_dma_pcidev_id, /**< The list of supported devices. */
+ .probe = pch_dma_probe,  /**< The probe function. */
+ .remove = __devexit_p(pch_dma_remove), /**< The remove function. */
+#ifdef CONFIG_PM
+ .suspend = pch_dma_suspend, /**< The suspend function. */
+ .resume = pch_dma_resume /**< The resume function. */
+#endif
+};
+
+/*! @ingroup PCILayerAPI
+ @fn   static __init int pch_dma_pci_init(void)
+ @brief  Module initialization routine.
+ @remarks This function is invoked when the module is
+    loaded. The main tasks performed by this
+    function are:
+    - Initializes the module.
+    - Initializes the local structures
+    and registers the module as PCI Driver
+    with the kernel subsystem.
+
+ @return int
+   - @ref PCH_DMA_SUCCESS --> On success.
+   - -EEXIST --> pci_register_driver error status
+      code.
+   - -EINVAL --> pci_register_driver error status
+      code.
+   - -ENOMEM --> pci_register_driver error status
+      code.
+
+  */
+static __init int pch_dma_pci_init(void)
+{
+ int retval;
+
+ /* Registering the module as PCI Driver. */
+ retval = pci_register_driver(&pch_dma_controller_driver);
+
+ if (0 == retval) {
+  PCH_DEBUG
+      ("pch_dma_pci_init -> Function pci_register_driver invoked "
+       "successfully returned %d.\n", retval);
+
+  retval = PCH_DMA_SUCCESS;
+ } else {
+  PCH_LOG(KERN_ERR,
+   "pch_dma_pci_init -> Function pci_register_driver "
+   "failed returned %d.\n", retval);
+ }
+
+ PCH_DEBUG("Function pch_dma_pci_init returns %d.\n", retval);
+ return retval;
+}
+
+/*! @ingroup PCILayerAPI
+ @fn   static __exit void pch_dma_pci_exit(void)
+ @brief  Module exit handler.
+ @remarks Kernel subsystem will be invoking this routine
+    once the module gets unloaded. The main tasks
+    performed by this function are:
+    - Un-registers the PCI driver.
+    - Unloads the module.
+
+ @return  None.
+  */
+static __exit void pch_dma_pci_exit(void)
+{
+ /* Un-registering the module as PCI Driver. */
+ pci_unregister_driver(&pch_dma_controller_driver);
+ PCH_DEBUG("pch_dma_pci_exit -> Function pci_unregister_driver "
+    "invoked successfully.\n");
+
+ PCH_DEBUG("Function pch_dma_pci_exit invoked successfully.\n");
+}
+
+MODULE_DEVICE_TABLE(pci, pch_dma_pcidev_id);
+module_init(pch_dma_pci_init);
+module_exit(pch_dma_pci_exit);
diff -urN linux-2.6.33.1/drivers/dma/pch_dma/pch_dma_pci.h
topcliff-2.6.33.1/drivers/dma/pch_dma/pch_dma_pci.h
--- linux-2.6.33.1/drivers/dma/pch_dma/pch_dma_pci.h 1970-01-01
09:00:00.000000000 +0900
+++ topcliff-2.6.33.1/drivers/dma/pch_dma/pch_dma_pci.h 2010-04-27
11:46:20.000000000 +0900
@@ -0,0 +1,72 @@
+/**
+ * @file pch_dma_pci.h
+ *
+ * @brief
+ * This file declares the constants & functions used by the
+ *  PCH_DMA_CONTROLLER driver.
+ *
+ * @version 0.90
+ * @section
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307,
USA.
+ *
+ * <hr>
+ */
+
+/*
+ * History:
+ * Copyright (C) 2008 OKI SEMICONDUCTOR Co., LTD.
+ *
+ *
+ * created:
+ * OKISEMI 04/14/2010
+ *
+ */
+
+#ifndef __PCH_DMA_PCI_H__
+#define __PCH_DMA_PCI_H__
+
+/*! @ingroup PCILayer
+ @def  PCI_DEVICE_ID_INTEL_PCH1_DMA4_0
+ @brief  The Device ID of one of the DMA device
+    with 4 channels used for the GE devices.
+ @note  This is used for registering the DMA module
+    with the PCI subsystem of the Kernel, so that
+    the module is loaded when the required device
+    is detected.
+
+ @see
+  - pch_dma_pcidev_id
+  - get_dev_type
+*/
+#define PCI_DEVICE_ID_INTEL_PCH1_DMA4_0  (0x8815UL)
+
+/*! @ingroup PCILayer
+ @def  PCI_DEVICE_ID_DMA8_0_CONTROLLER
+ @brief  The Device ID of one of the DMA device
+    with 8 channels used for the GE devcies.
+ @note  This is used for registering the DMA module
+    with the PCI subsystem of the Kernel, so that
+    the module is loaded when the required device
+    is detected.
+
+ @see
+  - pch_dma_pcidev_id
+  - get_dev_type
+*/
+#define PCI_DEVICE_ID_INTEL_PCH1_DMA8_0  (0x8810UL)
+
+extern unsigned char pch_device_suspended; /* The device suspend flag.  */
+extern spinlock_t pch_device_lock; /* The device lock variable. */
+
+#endif

