Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0D0LCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:02:35 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:14604 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754463Ab0D0LCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:02:13 -0400
Message-ID: <002101cae5f9$15c35260$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Intel OTC" <joel.clark@intel.com>,
       "Andrew" <andrew.chih.howe.khor@intel.com>
Subject: [PATCH] Topcliff DMA: Add the DMA driver [2/4]
MIME-Version: 1.0
Date: Tue, 27 Apr 2010 20:01:44 +0900
Content-Type: message/partial;
	total=4;
	id="01CAE5F9.14BABC00@tsmail03";
	number=2
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


+  - pch_enable_dma
+  - pch_disable_dma
+  - pch_set_dma_priority
+  - pch_dma_direct_start
+
+  */
+
+void get_dma_status(int channel, u16 *pDMAStatus)
+{
+ u32 status_val;
+ u32 base_address;
+ u16 ch;
+
+ ch = pch_dma_channel_table[channel].channel;
+ base_address = pch_dma_channel_table[channel].base;
+
+ if (ch < 8) {
+  status_val = PCH_READ_LONG(base_address + DMA_STS0_OFFSET);
+  *pDMAStatus = (u16) ((status_val >> (DMA_SHIFT_STATUS_BITS +
+           (ch *
+            DMA_SIZE_STATUS_BITS))) &
+         (DMA_MASK_STATUS_BITS));
+ } else {
+  status_val = PCH_READ_LONG(base_address + DMA_STS2_OFFSET);
+  *pDMAStatus = (u16) ((status_val >> (DMA_SHIFT_STATUS_BITS +
+           ((ch -
+             8) *
+            DMA_SIZE_STATUS_BITS))) &
+         (DMA_MASK_STATUS_BITS));
+ }
+
+ PCH_DEBUG("Function get_dma_status invoked successfully.\n");
+}
+
+/*! @ingroup HALLayerAPI
+ @fn  int dma_set_desc(int channel,
+    struct pch_dma_desc *start,
+    struct pch_dma_desc *end)
+ @brief  Sets descriptors .
+ @remarks This functions sets the descriptor settings for
+    SCATTER GATHER mode. It does not perform any
+    register settings, instead retains the data for
+    further use. The main tasks performed by this
+    function are:
+    - Sets the pHeadOfList field of the @ref
+    pch_dma_channel_info structure to the value of
+    the argument start.
+    - Set the pTailOfList field of the @ref
+    pch_dma_channel_info structure to the value of
+    the argument end.
+
+ @param  channel [@ref IN] Channel number.
+ @param  start [@ref IN] Reference to first descriptor
+       of list.
+ @param  end [@ref IN] Reference to last descriptor
+       of list.
+
+ @see
+   - pch_set_dma_desc
+ */
+
+int dma_set_desc(int channel, struct pch_dma_desc *start,
+   struct pch_dma_desc *end)
+{
+ pch_dma_channel_info[channel].pHeadOfList = start;
+ pch_dma_channel_info[channel].pTailOfList = end;
+
+ PCH_DEBUG("Function dma_set_desc returns %d.\n", PCH_DMA_SUCCESS);
+ return PCH_DMA_SUCCESS;
+}
+
+/*! @ingroup InternalFunction
+ @fn   void get_free_ch(int index)
+ @brief  Get a free channel info entry and populate the entry.
+ @remarks Reset all the entries within the array
+    pch_dma_channel_info[index]
+
+ @param  index [@ref IN] Index in the
+     pch_dma_channel_table
+
+ @return None
+
+ @see
+   - dma_request_ch
+ */
+void get_free_ch(int index)
+{
+ memset((void *)&pch_dma_channel_info[index], 0,
+        sizeof(struct pch_dma_controller_info));
+ PCH_DEBUG("Function get_free_ch invoked successfully.\n");
+}
+
+/*! @ingroup HALLayerAPI
+ @fn   int dma_request_ch(u32 req_dev_id, int dreq)
+ @brief  Reserves a channel based on request.
+ @remarks This function is invoked when a kernel module requests
+    to reserve a DMA channel. The main tasks
+    performed by this function are:
+    - Checks the @ref pch_dma_channel_table for a
+    matching entry corresponding to the dev_id of
+    the requesting device and dreq signal.
+    - If there is a matching entry, checks if this
+    channel is already allocated.
+    - If no invoke get_free_ch to reset the entries
+    for the corresponding channel and return the
+    entry index.
+    - If no matching entry is found return -EBUSY.
+
+ @param  req_dev_id [@ref IN] Device id of the device
+       that requests DMA  .
+ @param  dreq [@ref IN] DMA request signal number.
+
+ @return  int
+   - DMA channel number (>=0) --> On Success.
+   - -EBUSY --> DMA channel cannot be allocated..
+
+ @see
+   - pch_request_dma
+ */
+
+int dma_request_ch(u32 req_dev_id, int dreq)
+{
+ int retval;
+ int i;
+
+ for (i = 0; i < PCH_DMA_CHANNELS_MAX; i++) {
+  if ((pch_dma_channel_table[i].req_device_id == req_dev_id) &&
+      (pch_dma_channel_table[i].request_signal == dreq)) {
+   if ((1 == pch_dma_channel_table[i].ch_found) &&
+       (0 == pch_dma_channel_table[i].ch_alloced)) {
+    get_free_ch(i);
+    PCH_DEBUG
+        ("dma_request_ch -> Function get_free_ch "
+         "invoked successfully.\n");
+    pch_dma_channel_table[i].ch_alloced = 1;
+    retval = i;
+
+    break;
+   }
+  }
+ }
+
+ if (PCH_DMA_CHANNELS_MAX == i) {
+  retval = -EBUSY;
+  PCH_LOG(KERN_ERR, "dma_request_ch ->  Not able to allocate "
+   "channel.\n");
+ }
+
+ PCH_DEBUG("Function dma_request_ch returns %d.\n", retval);
+ return retval;
+}
+
+/*! @ingroup HALLayerAPI
+ @fn   int dma_free_ch(int channel)
+ @brief  Frees the requested channel.
+ @remarks This function is invoked when a kernel
+    module requests to free a DMA channel. The main
+    tasks performed by this function are:
+    - If the channel is already free return
+     PCH_DMA_SUCCESS.
+    - Else disable the channel by invoking
+    @ref dma_disable_ch API.
+    - Disable the channel interrupt by invoking
+    @ref dma_enable_disable_interrupt
+    - Mark the channel as free in the structures
+    @ref pch_dma_channel_info and @ref
+    pch_dma_channel_table and return @ref
+    PCH_DMA_SUCCESS.
+
+ @param  channel [@ref IN] DMA channel number to be freed.
+
+ @return int
+   - @ref PCH_DMA_SUCCESS --> On success.
+
+ @see
+   - pch_free_dma
+ */
+
+int dma_free_ch(int channel)
+{
+ int retval;
+
+ if (pch_dma_channel_table[channel].ch_alloced == (u16) 0) {
+  PCH_DEBUG("dma_free_ch -> Channel is already free\n");
+  retval = PCH_DMA_SUCCESS;
+ } else {
+  /* To stop any active transfer on DMA, disable DMA */
+  (void)dma_disable_ch(channel);
+  PCH_DEBUG("dma_free_ch -> Function dma_disable_ch invoked "
+     "successfully.\n");
+
+  (void)dma_enable_disable_interrupt(channel,
+         PCH_DMA_INTERRUPT_DISABLE);
+  PCH_DEBUG
+      ("dma_free_ch -> Function dma_enable_disable_interrupt "
+       "invoked successfully.\n");
+
+  pch_dma_channel_table[channel].ch_alloced = 0;
+
+  retval = PCH_DMA_SUCCESS;
+ }
+
+ PCH_DEBUG("Function dma_free_ch returns %d.\n", PCH_DMA_SUCCESS);
+ return retval;
+}
diff -urN linux-2.6.33.1/drivers/dma/pch_dma/pch_dma_hal.h
topcliff-2.6.33.1/drivers/dma/pch_dma/pch_dma_hal.h
--- linux-2.6.33.1/drivers/dma/pch_dma/pch_dma_hal.h 1970-01-01
09:00:00.000000000 +0900
+++ topcliff-2.6.33.1/drivers/dma/pch_dma/pch_dma_hal.h 2010-04-27
11:46:20.000000000 +0900
@@ -0,0 +1,592 @@
+/**
+ * @file pch_dma_hal.h
+ *
+ * @brief
+ *  This file declares the structures & data types used by the HAL
+ *  functions of PCH_DMA_CONTROLLER driver.
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
+#ifndef __PCH_DMA_HAL_H__
+#define __PCH_DMA_HAL_H__
+
+#include <linux/interrupt.h>
+#include "pch_dma_main.h"
+
+/*!
+ @defgroup DMA
+*/
+
+/*! @defgroup Global
+ @ingroup DMA
+ @brief  This group contains all the global data
+    structures used by the DMA module.
+*/
+
+/*! defgroup InternalFunction
+ @ingroup DMA
+ @brief  This group contains all the function which
+    are used by other APIs for performing some
+    small tasks for facilitating the logic
+    of the driver.
+*/
+
+/*! @defgroup PCILayer
+ @ingroup DMA
+ @brief  This group contains all the utilities
+    used to interface the DMA module with
+    the PCI subsystem of the Kernel.
+*/
+
+/*! @defgroup InterfaceLayer
+ @ingroup DMA
+ @brief  This group contains all the utilities
+    used by the DMA module to interface with
+    the other modules.
+*/
+
+/*! @defgroup HALLayer
+ @ingroup DMA
+ @brief  This group contains all the utilities
+    used to DMA module to interact with the
+    hardware.
+*/
+
+/*! @defgroup PCILayerAPI
+ @ingroup PCILayer
+ @brief  This group contains the APIs used to
+    interface the DMA module with the PCI
+    subsystem of the Kernel.
+*/
+
+/*! @defgroup PCILayerFacilitators
+ @ingroup PCILayer
+ @brief  This group contains the data structures
+    used by the PCILayerAPIs for their
+    functioning.
+*/
+
+/*! @defgroup HALLayerAPI
+ @ingroup HALLayer
+ @brief  This group contains the APIs used to
+    communicate with the hardware.
+*/
+
+/*! @defgroup HALLayerFacilitators
+ @ingroup HALLayer
+ @brief  This group contains the data structures
+    used to communicate with the hardware.
+*/
+
+/*! @defgroup InterfaceLayerAPI
+ @ingroup InterfaceLayer
+ @brief  This group contains the APIs used by the
+    DMA module to interface with other modules.
+*/
+
+/*! @defgroup InterfaceLayerFacilitators
+ @ingroup InterfaceLayer
+ @brief  This group contains the data structures
+    used by the DMA module to interface with
+    other modules.
+*/
+
+/*** Device specific limitations and properties. ***/
+
+/*! @ingroup DMA
+ @def  PCH_DMA_CHANNELS_MAX
+ @brief  The maximum number of channels allowed
+    in any of the PCH device.
+*/
+#define PCH_DMA_CHANNELS_MAX    (64)
+
+/*! @ingroup DMA
+ @def  PCH_DMA_MAX_DEVS
+ @brief  The no. of DMA devices allowable.
+
+ @see
+  - pch_dma_devices
+*/
+#define PCH_DMA_MAX_DEVS     (4)
+
+/*! @ingroup DMA
+ @def  PCH_DMA_8BIT_SIZE_MAX
+ @brief  The maximum number of transfer size in
+    bytes for a channel if access size is set
+    to 8BIT.
+*/
+#define PCH_DMA_8BIT_SIZE_MAX   (2047)
+
+/*! @ingroup DMA
+ @def  PCH_DMA_16BIT_SIZE_MAX
+ @brief  The maximum number of transfer size in
+    bytes for a channel if access size is set
+    to 16BIT.
+*/
+#define PCH_DMA_16BIT_SIZE_MAX   (4094)
+
+/*! @ingroup DMA
+ @def  PCH_DMA_32BIT_SIZE_MAX
+ @brief  The maximum number of transfer size in
+    bytes for a channel if access size is set
+    to 32BIT.
+*/
+#define PCH_DMA_32BIT_SIZE_MAX   (4096)
+
+/********/
+
+/*** Device IDs of DMA requesting devices. ***/
+/*! @ingroup DMA
+ @def  PCI_DEVICE_ID_PCH_UART0
+ @brief  The deviceID of the PCH GE UART
+    device 0 which can use the DMA features.
+*/
+#define PCI_DEVICE_ID_PCH_UART0      (0x8811)
+
+/*! @ingroup DMA
+ @def  PCI_DEVICE_ID_PCH_UART1
+ @brief  The deviceID of the PCH GE UART
+    device 1 which can use the DMA features.
+*/
+#define PCI_DEVICE_ID_PCH_UART1      (0x8812)
+
+/*! @ingroup DMA
+ @def  PCI_DEVICE_ID_PCH_UART2
+ @brief  The deviceID of the PCH GE UART
+    device 2 which can use the DMA features.
+*/
+#define PCI_DEVICE_ID_PCH_UART2      (0x8813)
+
+/*! @ingroup DMA
+ @def  PCI_DEVICE_ID_PCH_UART3
+ @brief  The deviceID of the PCH GE UART
+    device 3 which can use the DMA features.
+*/
+#define PCI_DEVICE_ID_PCH_UART3      (0x8814)
+
+/*! @ingroup DMA
+ @def  PCI_DEVICE_ID_PCH_SPI
+ @brief  The deviceID of the PCH GE SPI
+    device which can use the DMA features.
+*/
+#define PCI_DEVICE_ID_PCH_SPI (0x8816)
+
+/*** Internal device IDs used for identifing the DMAC . ***/
+/*! @ingroup Global
+ @def  PCH_DMA_4CH0
+ @brief  The device ID for the first DMA device
+    with 4 channels.
+*/
+#define PCH_DMA_4CH0      (0x40)
+
+/*! @ingroup Global
+ @def  PCH_DMA_4CH1
+ @brief  The device ID for the second DMA device
+    with 4 channels.
+*/
+#define PCH_DMA_4CH1      (0x41)
+
+/*! @ingroup Global
+ @def  PCH_DMA_4CH2
+ @brief  The device ID for the third DMA device
+    with 4 channels.
+*/
+#define PCH_DMA_4CH2      (0x42)
+
+/*! @ingroup Global
+ @def  PCH_DMA_4CH3
+ @brief  The device ID for the fourth DMA device
+    with 4 channels.
+*/
+#define PCH_DMA_4CH3      (0x43)
+
+/*! @ingroup Global
+ @def  PCH_DMA_4CH4
+ @brief  The device ID for the fifth DMA device
+    with 4 channels.
+*/
+#define PCH_DMA_4CH4      (0x44)
+
+/*! @ingroup Global
+ @def  PCH_DMA_8CH0
+ @brief  The device ID for the first DMA device
+    with 8 channels.
+*/
+#define PCH_DMA_8CH0      (0x80)
+
+/*! @ingroup Global
+ @def  PCH_DMA_8CH1
+ @brief  The device ID for the second DMA device
+    with 8 channels.
+*/
+#define PCH_DMA_8CH1      (0x81)
+
+/*! @ingroup Global
+ @def  PCH_DMA_8CH2
+ @brief  The device ID for the third DMA device
+    with 8 channels.
+*/
+#define PCH_DMA_8CH2      (0x82)
+
+/*! @ingroup Global
+ @def  PCH_DMA_8CH3
+ @brief  The device ID for the fourth DMA device
+    with 8 channels.
+*/
+#define PCH_DMA_8CH3      (0x83)
+
+/*! @ingroup Global
+ @def  PCH_DMA_12CH0
+ @brief  The device ID for the first DMA device
+    with 12 channels.
+*/
+#define PCH_DMA_12CH0      (0xC0)
+
+/******/
+
+/*** DMA Controller Register Offsets. ***/
+
+/*! @ingroup HALLayer
+ @def  DMA_CTL0_OFFSET
+ @brief  DMA Control register 0 offset.
+*/
+#define DMA_CTL0_OFFSET     (0x00UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_CTL1_OFFSET
+ @brief  DMA Control register 1 offset.
+*/
+#define DMA_CTL1_OFFSET      (0x04UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_CTL2_OFFSET
+ @brief  DMA Control register 2 offset.
+*/
+#define DMA_CTL2_OFFSET      (0x08UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_CTL3_OFFSET
+ @brief  DMA Control register 3 offset.
+*/
+#define DMA_CTL3_OFFSET      (0x0CUL)
+
+/*! @ingroup HALLayer
+ @def  DMA_STS0_OFFSET
+ @brief  DMA Status register 0 offset.
+*/
+#define DMA_STS0_OFFSET      (0x10UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_STS1_OFFSET
+ @brief  DMA Status register 1 offset.
+*/
+#define DMA_STS1_OFFSET      (0x14UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_STS2_OFFSET
+ @brief  DMA Status register 2 offset.
+*/
+#define DMA_STS2_OFFSET      (0x18UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_IN_AD_OFFSET
+ @brief  DMA IN Address register offset.
+*/
+#define DMA_IN_AD_OFFSET     (0x20UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_OUT_AD_OFFSET
+ @brief  DMA Out Address register offset.
+*/
+#define DMA_OUT_AD_OFFSET     (0x24UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_SZ_OFFSET
+ @brief  DMA Size register offset.
+*/
+#define DMA_SZ_OFFSET      (0x28UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_NX_AD_OFFSET
+ @brief  DMA Next Address register offset.
+*/
+#define DMA_NX_AD_OFFSET     (0x2CUL)
+
+/**********/
+
+/*** Individual register bits. ***/
+
+/*! @ingroup HALLayer
+ @def  DMA_SIZE_TYPE_BITS
+ @brief  The DMA size bits.
+*/
+#define DMA_SIZE_TYPE_BITS     (0x00003000UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_SET_OR_CLEAR_DIR_BIT
+ @brief  Mask for direction bit.
+*/
+#define DMA_SET_OR_CLEAR_DIR_BIT   (0x00000004UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_MASK_MODE_BITS
+ @brief  Mask for mode bits.
+*/
+#define DMA_MASK_MODE_BITS     (0x00000003UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_SHIFT_MODE_BITS
+ @brief  DMA shift mode bits.
+*/
+#define DMA_SHIFT_MODE_BITS     (4)
+
+/*! @ingroup HALLayer
+ @def  DMA_MASK_PRIORITY_BITS
+ @brief  Mask for priority bits.
+*/
+#define DMA_MASK_PRIORITY_BITS    (0x3UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_SHIFT_PRIORITY_BITS
+ @brief  Shift value for DMA priority bits.
+*/
+#define DMA_SHIFT_PRIORITY_BITS    (4)
+
+/*! @ingroup HALLayer
+ @def  DMA_SHIFT_SIZE_TYPE_BITS
+ @brief  Shift value for the DMA size bit.
+*/
+#define DMA_SHIFT_SIZE_TYPE_BITS   (12)
+
+/*! @ingroup HALLayer
+ @def  DMA_DIR_START
+ @brief  Direct Start Bit Setting values.
+*/
+#define DMA_DIR_START      (0x00000100UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_INTERRUPT_BIT
+ @brief  Interrupt Enable Bit setting values.
+*/
+#define DMA_INTERRUPT_BIT     (0x00000001UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_ABORT_OCCUR
+ @brief  Abort notify Bit Setting Values
+*/
+#define DMA_ABORT_OCCUR      (0x00000100UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_INTERRUPT_OCCUR
+ @brief  Interrupt notify Bit Setting Values
+*/
+#define DMA_INTERRUPT_OCCUR     (0x00000001UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_MASK_STATUS_BITS
+ @brief  Mask for status bits.
+*/
+#define DMA_MASK_STATUS_BITS    (0x3UL)
+
+/*! @ingroup HALLayer
+ @def  DMA_SIZE_STATUS_BITS
+ @brief  The DMA size status bits.
+*/
+#define DMA_SIZE_STATUS_BITS    (2)
+
+/*! @ingroup HALLayer
+ @def  DMA_SHIFT_STATUS_BITS
+ @brief  The shift value for DMA status bits.
+*/
+#define DMA_SHIFT_STATUS_BITS    (16)
+
+/*********/
+
+/*** Status denoting macros. ***/
+
+/*! @ingroup HALLayer
+ @def  DMA_STATUS_IDLE
+ @brief  Constant used to denote the transfer status as IDLE.
+ @note  This constant is used by DMA modules to make the
+    other module aware of the DMA status.
+*/
+#define DMA_STATUS_IDLE      (0)
+
+/*! @ingroup HALLayer
+ @def  DMA_STATUS_DESC_READ
+ @brief  Constant used to denote the transfer status as
+    DESCRIPTOR_READ.
+ @note  This constant is used by DMA modules to make the
+    other module aware of the DMA status.
+*/
+#define DMA_STATUS_DESC_READ    (1)
+
+/*! @ingroup HALLayer
+ @def  DMA_STATUS_WAIT
+ @brief  Constant used to denote the transfer status as WAIT.
+ @note  This constant is used by DMA modules to make the
+    other module aware of the DMA status.
+*/
+#define DMA_STATUS_WAIT      (2)
+
+/*! @ingroup HALLayer
+ @def  DMA_STATUS_ACCESS
+ @brief  Constant used to denote the transfer status as ACCESS
+ @note  This constant is used by DMA modules to make the
+    other module aware of the DMA status.
+*/
+#define DMA_STATUS_ACCESS     (3)
+
+/*! @ingroup HALLayer
+ @def  PCH_DMA_INTERRUPT_DISABLE
+ @brief  Constant used to denote disable interrupt.
+*/
+#define PCH_DMA_INTERRUPT_DISABLE   (0)
+
+/*! @ingroup HALLayer
+ @def  PCH_DMA_INTERRUPT_ENABLE
+ @brief  Constant used to denote enable interrupt.
+*/
+#define PCH_DMA_INTERRUPT_ENABLE   (1)
+
+/************/
+
+/*** Other Macros. ***/
+
+/*! @ingroup HALLayer
+ @def  COUNTER_LIMIT
+ @brief  The counter limit.
+*/
+#define COUNTER_LIMIT      (0xFFFF)
+
+/*! @ingroup HALLayer
+ @def  MSK_ALL_THREE
+ @brief  Value used for masking the 3 LSB bits.
+*/
+#define MSK_ALL_THREE      (0x7)
+
+/*******/
+/*** Data Structures for stroing device specific information. ***/
+
+/*! @ingroup HALLayerFacilitators
+ @struct  __pch_dma_devices
+ @brief  Format for maintaining the device information.
+ @note  This structure is used by the DMA module to retain
+    the information about the device.
+
+ @see
+  - pch_dma_devices
+*/
+
+struct pch_dma_devices {
+ u32 base_addr;  /**< The remapped base address. */
+ u32 dev_typ;  /**< The device type indicating number of DMA
+    channels */
+ void *dev;  /**< The void pointer for storing any references
+    if required */
+};
+
+/*! @ingroup HALLayerFacilitators
+  @struct  __pch_dma_controller_info_t
+  @brief  Format for storing the details of the
+     DMA channels.
+*/
+
+struct pch_dma_controller_info {
+ u16 DMATransferMode;  /**< DMA Transfer Mode  */
+ u16 bChEnabled;   /**< To know if channel is enabled or
+     not */
+ struct pch_dma_desc *pHeadOfList; /**< Pointer to start
+      descriptor */
+ struct pch_dma_desc *pTailOfList; /**< Pointer to last
+      descriptor */
+ void (*call_back_func_ptr) (int, unsigned long);/**< Address of the call
+     back function that is to be called when
+     an interrupt occurs */
+ u32 callback_data;  /**< The data to passed to the callback
+     function during invocation */
+ u16 DMAAccessSize;  /**< To store the access size (8bit,
+     16bit or 32bit) */
+ u16 DMATransferSize;  /**< To store the value of Transfer
+     Size */
+ u16 DMATransferDirection; /**< To store the Direction of Transfer
+     (IN to OUT or OUT to IN) */
+ u32 in_addr;   /**< The in_address */
+ u32 out_addr;   /**< The out_address */
+};
+
+/*! @ingroup HALLayerFacilitators
+  @struct  pch_dma_channel_alloc_table
+  @brief  Format for storing the details of the
+     allocation details of the DMA channels.
+*/
+
+struct pch_dma_channel_alloc_table {
+ u32 dma_dev_id; /**< The DMA device ID. */
+ enum pch_channel_request_id request_signal; /**< The request type.*/
+ u32 req_device_id; /**< The device ID of the requested device */
+ u16 channel;  /**< The channel number. */
+ u16 ch_found:1;  /**< The flag variable for channel in use */
+ u16 ch_alloced:1; /**< The flag variable for channel allocate. */
+ u32 base;  /**< The base address of the DMA device. */
+};
+
+         /*****/
+
+extern struct pch_dma_channel_alloc_table
+ pch_dma_channel_table[PCH_DMA_CHANNELS_MAX];
+extern struct pch_dma_controller_info
+ pch_dma_channel_info[PCH_DMA_CHANNELS_MAX];
+
+void dma_init(u32 base, u32 dev_type);
+int dma_free_ch(int channel);
+int dma_request_ch(u32 req_dev_id, int dreq);
+int dma_set_mode(int channel, struct pch_dma_mode_param stModeParam);
+int dma_set_addr(int channel, u32 iaddr, u32 oaddr);
+int dma_enable_ch(int channel);
+int dma_disable_ch(int channel);
+int dma_set_count(int channel, u32 count);
+int dma_add_desc(int channel, struct pch_dma_desc *start,
+   struct pch_dma_desc *end);
+int dma_set_desc(int channel, struct pch_dma_desc *start,
+   struct pch_dma_desc *end);
+void dma_set_callback(int channel,
+        void (*pch_dma_cbr) (int value, unsigned long data1),
+        unsigned long data);
+irqreturn_t dma_interrupt(int irq, void *dev_id);
+int dma_set_priority(int channel, int priority);
+int dma_direct_start(int channel);
+int dma_enable_disable_interrupt(int channel, int bEnable);
+void dma_get_abort_status(int channel, u16 *pAbortStatus);
+void dma_get_interrupt_status(int channel, u16 *pInterruptStatus);
+void get_dma_status(int channel, u16 *pDMAStatus);
+void get_free_ch(int index);
+void dma_exit(u32 dev_type);
+
+#endif
diff -urN linux-2.6.33.1/drivers/dma/pch_dma/pch_dma_main.c
topcliff-2.6.33.1/drivers/dma/pch_dma/pch_dma_main.c
--- linux-2.6.33.1/drivers/dma/pch_dma/pch_dma_main.c 1970-01-01
09:00:00.000000000 +0900
+++ topcliff-2.6.33.1/drivers/dma/pch_dma/pch_dma_main.c 2010-04-27
11:46:20.000000000 +0900
@@ -0,0 +1,1024 @@
+/**
+ * @file pch_dma_main.c
+ *
+ * @brief
+ * This file defines the methods of PCH_DMA driver.
+ *
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
+#include <linux/spinlock.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+
+#include "pch_debug.h"
+#include "pch_dma_hal.h"
+#include "pch_dma_pci.h"
+
+
+/*! @ingroup InterfaceLayerAPI
+ @fn  int pch_request_dma(struct pci_dev *pdev, int dreq)
+ @brief  Used to request a DMA channel.
+ @remarks Requests to reserve a DMA channel that connects
+    to number 'dreq' (DMA request signal) of PCI
+    device 'pdev' to the appropriate DMA channel
+    allocated for it within the DMA Controller. This
+    function is called by functions from other
+    kernel modules. The tasks performed by this
+    function are:
+    - Verifies whether the obtained parameters are
+    valid,
+    if not suitable error status codes are returned
+    to the called function.
+    - If valid interacts with the HAL API and
+    returns the status code returned by the HAL API.
+
+ @note  This function is accessible by other kernel modules.
+
+ @param  dev [@ref IN] PCI device that requires the DMA
+         channel.
+ @param  dreq [@ref IN] DMA request signal number.
+
+ @return int
+   - @ref PCH_DMA_SUCCESS --> On success.
+   - -EAGAIN --> Device is in suspend mode.
+   - -EINVAL --> pdev does not have a DMA request
+      type or number 'dreq' or 'pdev'
+      is NULL.
+*/
+int pch_request_dma(struct pci_dev *pdev, int dreq)
+{
+ int retval;
+
+ /* Attaining the lock.  */
+ spin_lock(&pch_device_lock);
+
+ /* If device suspended. */
+ if (1 == pch_device_suspended) {
+  PCH_LOG(KERN_ERR,
+   "pch_request_dma -> Device is in suspend mode.\n");
+  retval = -EAGAIN;
+ }
+ /* Invalid device structure. */
+ else if (NULL == pdev) {
+  PCH_LOG(KERN_ERR,
+   "pch_request_dma -> Obtained device structure "
+   "is NULL.\n");
+  retval = -EINVAL;
+ }
+ /* Invalid request signal. */
+ else if ((dreq < PCH_DMA_TX_DATA_REQ0) ||
+   (dreq > PCH_DMA_RX_DATA_REQ5)) {
+  PCH_LOG(KERN_ERR,
+   "pch_request_dma -> Invalid request signal.\n");
+  retval = -EINVAL;
+ } else {
+  /* Requesting for reserving a DMA channel. */
+  retval = dma_request_ch((u32) (pdev->device), dreq);
+  PCH_DEBUG("pch_request_dma -> Function dma_request_ch returned "
+     "%d.\n", retval);
+ }
+
+ /* Releasing the lock. */
+ spin_unlock(&pch_device_lock);
+
+ PCH_DEBUG("Function pch_request_dma returns %d.\n", retval);
+ return retval;
+}
+EXPORT_SYMBOL(pch_request_dma);
+
+/*! @ingroup InterfaceLayerAPI
+ @fn   int pch_free_dma(int channel)
+ @brief  Used to free a DMA channel.
+ @remarks Frees the allocated DMA channel that is provided
+    as the argument to the function. This function
+    is called by the functions from other kernel
+    modules. The main tasks performed by this
+    function are:
+    - Verifies whether the obtained parameters are
+    valid, if not suitable error status codes are
+    returned to the called function.
+    - If valid interacts with the HAL API for
+    freeing the channel and returns the status code
+    returned by the HAL API.
+ @note  This function is accessible by other kernel
+    modules.
+
+ @param  channel [@ref IN] DMA channel number
+
+ @return int
+   - @ref PCH_DMA_SUCCESS --> On success.
+   - -EAGAIN  --> Device is in suspend mode.
+   - -ENODEV  --> Specified DMA channel does
+       not exist.
+*/
+int pch_free_dma(int channel)
+{
+ int retval;
+
+ if (1 == pch_device_suspended) {
+  PCH_LOG(KERN_ERR,
+   "pch_free_dma -> Device is in suspend mode.\n");
+  retval = -EAGAIN;
+ } else if ((channel >= PCH_DMA_CHANNELS_MAX) || (channel < 0)) {
+  PCH_LOG(KERN_ERR, "pch_free_dma -> Invalid Channel number: "
+   "%d.\n", channel);
+  retval = -ENODEV;
+ } else {
+  retval = dma_free_ch(channel);
+  PCH_DEBUG("pch_free_dma -> Function dma_free_ch "
+     "returned %d.\n", retval);
+ }
+
+ PCH_DEBUG("Function pch_free_dma returns %d.\n", retval);
+ return retval;
+}
+EXPORT_SYMBOL(pch_free_dma);
+
+/*! @ingroup InterfaceLayerAPI
+ @fn  int pch_set_dma_mode(int channel,struct
+    pch_dma_mode_param stModeParam)
+ @brief  Used to set the mode of the DMA.
+ @remarks Sets the mode of DMA transfer - One shot mode
+    or Scatter/gather mode. In addition to this,
+    the function also sets the direction of DMA
+    transfer and DMA Size type. This function is
+    called by functions from other kernel modules.
+    The main tasks performed by this function are:
+    - Verifies whether the obtained parameters are
+    valid, if not suitable error status codes are
+    returned to the called function.
+    - If valid interacts with the HAL API to set the
+    required settings and returns the status code
+    returned by the HAL API.
+
+ @note  This function is accessible by other kernel modules.
+
+ @param  channel  [@ref IN] DMA channel number
+ @param  stModeParam [@ref IN] Contains info about
+      direction of DMA transfer, mode
+      and Size type
+
+ @return int
+   - @ref PCH_DMA_SUCCESS --> On success.
+   - -EAGAIN  --> The device is in suspend
+       mode.
+   - -ENODEV  --> Specified DMA channel does
+       not exist.
+   - -EINVAL  --> Parameter passed is invalid.
+   - -EBUSY  --> DMA channel is already
+       enabled.
+*/
+int pch_set_dma_mode(int channel, struct pch_dma_mode_param stModeParam)
+{
+ int retval;
+
+ /* Checking if device suspended.                                */
+ if (1 == pch_device_suspended) {
+  PCH_LOG(KERN_ERR,
+   "pch_set_dma_mode -> Device is in suspend mode.\n");
+  retval = -EAGAIN;
+ }
+ /* Checking for validity of channel number.     */
+ else if ((channel >= PCH_DMA_CHANNELS_MAX) || (channel < 0)) {
+  PCH_LOG(KERN_ERR,
+   "pch_set_dma_mode -> Invalid Channel number : " "%d.\n",
+   channel);
+  retval = -ENODEV;
+ }
+ /* Checking whether channel not allocated.              */
+ else if (pch_dma_channel_table[channel].ch_alloced == (u16) 0) {
+  PCH_LOG(KERN_ERR,
+   "pch_set_dma_mode -> Channel not allocated.\n");
+  retval = -EINVAL;
+ }
+ /* Checking if channel already enabled.                 */
+ else if (pch_dma_channel_info[channel].bChEnabled == 1) {
+  PCH_LOG(KERN_ERR,
+   "pch_set_dma_mode -> Channel already enabled.\n");
+  retval = -EBUSY;
+ }
+ /* Checking for validity of DMA Transfer MODE.  */
+ else if ((stModeParam.DMATransferMode != (u16) DMA_ONE_SHOT_MODE) &&
+   (stModeParam.DMATransferMode !=
+    (u16) DMA_SCATTER_GATHER_MODE)) {
+  PCH_LOG(KERN_ERR,
+   "pch_set_dma_mode -> Invalid DMA Transfer mode.\n");
+  retval = -EINVAL;
+ }
+ /* Checking for validity of Transfer Direction. */
+ else if ((stModeParam.TransferDirection != (u16) PCH_DMA_DIR_OUT_TO_IN)
+   && (stModeParam.TransferDirection !=
+       (u16) PCH_DMA_DIR_IN_TO_OUT)) {
+  PCH_LOG(KERN_ERR,
+   "pch_set_dma_mode -> Invalid DMA Transfer Direction." \
+   "\n");
+  retval = -EINVAL;
+ }
+ /* Checking for validity of Transfer Size Type. */
+ else if ((stModeParam.DMASizeType != (u16) PCH_DMA_SIZE_TYPE_8BIT) &&
+   (stModeParam.DMASizeType != (u16) PCH_DMA_SIZE_TYPE_16BIT) &&
+   (stModeParam.DMASizeType != (u16) PCH_DMA_SIZE_TYPE_32BIT)) {
+  PCH_LOG(KERN_ERR,
+   "pch_set_dma_mode -> Invalid DMA Size Type.\n");
+  retval = -EINVAL;
+ } else {
+  /* Setting the required DMA mode. */
+  retval = dma_set_mode(channel, stModeParam);
+  PCH_DEBUG("pch_set_dma_mode -> Function dma_set_mode "
+     "returned %d.\n", retval);
+ }
+
+ PCH_DEBUG("Function pch_set_dma_mode returns %d.\n", retval);
+ return retval;
+}
+EXPORT_SYMBOL(pch_set_dma_mode);
+
+/*! @ingroup InterfaceLayerAPI
+ @fn  int pch_set_dma_addr(int channel, unsigned int iaddr,
+    unsigned int oaddr)
+ @brief  Used to set the in and out address of the DMA channel.
+ @remarks Sets the address of the inside bridge and the outside
+    bridge for the 'One Shot Mode' of DMA Transfer.
+    This function is invoked by functions from other
+    modules. The main tasks performed by this
+    function are:
+    - Verifies whether the obtained parameters are
+    valid, if not suitable error status codes are
+    returned to the called function.
+    - If valid interacts with the HAL API to set the
+    inside and outside address and returns the
+    status code returned by the HAL API.
+ @note  This function is accessible by other kernel modules. The
+    following points has to be noted while passing
+    the in-address and out-address paramter.
+    - The address passed should be valid physical
+    address within the memory space.
+    - It should not be a configuration space or IO
+    space address.
+    - If the transfer is for large data, the address
+    should point to contagious alligned memory space
+    .
+
+ @param channel  [@ref IN] DMA channel number .
+ @param iaddr  [@ref IN] Address of inside bridge.
+ @param oaddr  [@ref IN] Address of outside bridge.
+
+ @return int
+  - @ref PCH_DMA_SUCCESS --> On success.
+  - -EAGAIN --> The device is in suspend mode.
+  - -ENODEV --> Specified DMA channel does not exist.
+  - -EINVAL --> Parameter passed is invalid.
+  - -EBUSY --> DMA transfer in progress or channel is
+     already enabled.
+
+*/
+int pch_set_dma_addr(int channel, unsigned int iaddr, unsigned int oaddr)
+{
+ int retval;
+
+ /* If the device is in suspend mode. */
+ if (1 == pch_device_suspended) {
+  PCH_LOG(KERN_ERR,
+   "pch_set_dma_addr -> Device is in suspend mode.\n");
+  retval = -EAGAIN;
+ }
+ /* Checking for validity of channel number  */
+ else if ((channel >= PCH_DMA_CHANNELS_MAX) || (channel < 0)) {
+  PCH_LOG(KERN_ERR, "pch_set_dma_addr -> Invalid Channel "
+   "number: %d.\n", channel);
+  retval = -ENODEV;
+ }
+ /* Checking whether channel is not allocated. */
+ else if (pch_dma_channel_table[channel].ch_alloced == (u16) 0) {
+  PCH_LOG(KERN_ERR, "pch_set_dma_addr -> Channel not "
+   "allocated.\n");
+  retval = -EINVAL;
+ }
+ /* Checking whether the channel is already enabled. */
+ else if (pch_dma_channel_info[channel].bChEnabled == 1) {
+  PCH_LOG(KERN_ERR, "pch_set_dma_addr -> Channel already "
+   "enabled.\n");
+  retval = -EBUSY;
+ }
+ /*Checking if addresses specified are NULL or not */
+ else if ((iaddr == 0) || (oaddr == 0)) {
+  PCH_LOG(KERN_ERR, "pch_set_dma_addr -> Invalid address.\n");
+  retval = -EINVAL;
+ }
+ /* Checking if the mode of transfer is  other than ONE_SHOT. */
+ else if (pch_dma_channel_info[channel].DMATransferMode !=
+   (u16) DMA_ONE_SHOT_MODE) {
+  PCH_LOG(KERN_ERR,
+   "pch_set_dma_addr -> Current Mode is "
+   "not DMA_ONE_SHOT_MODE.\n");
+  retval = -EINVAL;
+ } else {
+  /* setting the in and out address. */
+  retval = dma_set_addr(channel, iaddr, oaddr);
+  PCH_DEBUG("pch_set_dma_addr -> Function dma_set_addr invoked "
+     "successfully returned %d.\n", retval);
+ }
+
+ PCH_DEBUG("Function pch_set_dma_addr returns %d.\n", retval);
+ return retval;
+}
+EXPORT_SYMBOL(pch_set_dma_addr);
+
+/*! @ingroup InterfaceLayerAPI
+ @fn  int pch_set_dma_count(int channel, unsigned int count)
+ @brief  Used to set the DMA transfer count for a DMA channel.
+ @remarks Sets the value of DMA transfer count. This function
+    sets the count value only for the 'One Shot
+    Mode' of DMA Transfer. This function is invoked
+    by functions from other modules. The main tasks
+    performed by this function are:
+    - Verifies whether the obtained parameters are
+    valid, if not suitable error status codes are
+    returned to the called function.
+    - If valid interacts with the HAL API to set the
+    access count settings and returns the status
+    code returned by the HAL API.
+ @note  This function is accessible by other kernel modules.
+
+ @param  channel [@ref IN] DMA channel number.
+ @param  count [@ref IN] The number of bytes to transfer.
+
+ @return int
+   - @ref PCH_DMA_SUCCESS --> On success.
+   - -EAGAIN --> The device is in suspend mode.
+   - -ENODEV --> Specified DMA channel does not
+      exist.
+   - -EBUSY --> DMA transfer in progress or channel
+      is already enabled.
+   - -EINVAL --> Parameter passed is invalid.
+
+ */
+int pch_set_dma_count(int channel, unsigned int count)
+{
+ int retval = PCH_DMA_SUCCESS;
+
+ /* Checking if the device is in suspend mode. */
+ if (1 == pch_device_suspended) {
+  PCH_LOG(KERN_ERR, "pch_set_dma_count -> The device is in "
+   "suspend mode.");
+  retval = -EAGAIN;
+ }
+ /* Checking for validity of channel number.  */
+ else if ((channel >= PCH_DMA_CHANNELS_MAX) || (channel < 0)) {
+  PCH_LOG(KERN_ERR, "pch_set_dma_count -> Invalid Channel "
+   "number : %d.\n", channel);
+  retval = -ENODEV;
+ }
+ /* Checking whether channel is not allocated. */
+ else if (pch_dma_channel_table[channel].ch_alloced == (u16) 0) {
+  PCH_LOG(KERN_ERR, "pch_set_dma_count -> Channel is not "
+   "allocated.\n");
+  retval = -EINVAL;
+ }
+ /* Checking whether the channel is enabled. */
+ else if (pch_dma_channel_info[channel].bChEnabled == 1) {
+  PCH_LOG(KERN_ERR, "pch_set_dma_count -> Channel already "
+   "enabled.\n");
+  retval = -EBUSY;
+ }
+ /* Checking if the mode of transfer is other than ONE_SHOT. */
+ else if (pch_dma_channel_info[channel].DMATransferMode !=
+   (u16) DMA_ONE_SHOT_MODE) {
+  PCH_LOG(KERN_ERR,
+   "pch_set_dma_count -> Current Mode is "
+   "not DMA_ONE_SHOT_MODE.\n");
+  retval = -EINVAL;
+ }
+ /* Checking the limits of count value. */
+ else {
+  unsigned int max_count;
+
+  switch (pch_dma_channel_info[channel].DMAAccessSize) {
+  case PCH_DMA_SIZE_TYPE_8BIT:
+   max_count = PCH_DMA_8BIT_COUNT_MAX;
+   break;
+
+  case PCH_DMA_SIZE_TYPE_16BIT:
+   max_count = PCH_DMA_16BIT_COUNT_MAX;
+   break;
+
+  case PCH_DMA_SIZE_TYPE_32BIT:
+   max_count = PCH_DMA_32BIT_COUNT_MAX;
+   break;
+
+  default:
+   PCH_LOG(KERN_ERR, "pch_set_dma_count -> Invalid Access "
+    "Size.\n");
+   max_count = 0;
+   retval = -EINVAL;
+   break;
+  }
+
+  if ((retval == PCH_DMA_SUCCESS) && (count > max_count)) {
+   PCH_LOG(KERN_ERR,
+    "pch_set_dma_count -> Count (%d) exceeds "
+    "limit the maximum expected count (%d).\n",
+    count, max_count);
+   retval = -EINVAL;
+  }
+ }
+
+ if (PCH_DMA_SUCCESS == retval) {
+  /* Setting the count. */
+  retval = dma_set_count(channel, count);
+  PCH_DEBUG
+      ("pch_set_dma_count -> Function dma_set_count returned "
+       "%d.\n", retval);
+ }
+
+ PCH_DEBUG("Function pch_set_dma_count returns %d.\n", retval);
+ return retval;
+}
+EXPORT_SYMBOL(pch_set_dma_count);
+
+/*! @ingroup InterfaceLayerAPI
+ @fn int pch_set_dma_desc(int channel, struct pch_dma_desc *start,
+   struct pch_dma_desc *end)
+ @brief  Used to set the DMA channel descriptors.
+ @remarks Sets the DMA descriptor for the 'Scatter/Gather mode'
+    of DMA transfer. This function is invoked by
+    functions from other kernel modules. The main
+    tasks performed by this function are:
+    - Verifies whether the obtained parameters are
+    valid, if not suitable error status codes are
+    returned to the called function.
+    - If valid interacts with the HAL API to set the
+    descriptor settings and returns the status code
+    returned by the HAL API.
+ @note  This function is accessible by other kernel modules. The
+    following points have to be noted while passing
+    the "start" and "end" pointer of the descriptor.
+    - The address pointed by them should be physical
+    address with valid virtual address.
+    - The space should be alligned and accessible by
+    the DMA hardware.
+    - An easy way to perform this is to allocate the
+    descriptor memory using kmalloc.
+    - The last two bits of the physical address
+    should be suitably set so as to perform suitable
+    action after completion of each descriptor
+    action.
+    - The in-address and out-address within each
+    descriptor should be a valid memory space
+    physical address.
+
+ @param channel [@ref IN] DMA channel number
+ @param start [@ref IN] A pointer to the first descriptor.
+ @param end [@ref IN] A pointer to the last descriptor.
+
+ @return int
+  - @ref PCH_DMA_SUCCESS --> On success.
+  - -EAGAIN  --> The device is in suspend.
+  - -EINVAL  --> For invalid parameters.
+  - -ENODEV  --> Specified DMA channel is not exist.
+  - -EBUSY  --> If DMA transfer is in progress or
+     channel is already enabled.
+*/
+int pch_set_dma_desc(int channel, struct pch_dma_desc *start,

