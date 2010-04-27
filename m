Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab0D0LCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:02:37 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:14605 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754467Ab0D0LCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:02:12 -0400
Message-ID: <002201cae5f9$15f314f0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Intel OTC" <joel.clark@intel.com>,
       "Andrew" <andrew.chih.howe.khor@intel.com>
Subject: [PATCH] Topcliff DMA: Add the DMA driver [3/4]
MIME-Version: 1.0
Date: Tue, 27 Apr 2010 20:01:44 +0900
Content-Type: message/partial;
	total=4;
	id="01CAE5F9.14BABC00@tsmail03";
	number=3
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


+       struct pch_dma_desc *end)
+{
+ int retval;
+
+ /* Checking if the device is in suspend mode. */
+ if (1 == pch_device_suspended) {
+  PCH_LOG(KERN_ERR, "pch_set_dma_desc -> The device is in "
+   "suspend mode.\n");
+  retval = -EAGAIN;
+ }
+ /* Checking for validity of channel number  */
+ else if ((channel >= PCH_DMA_CHANNELS_MAX) || (channel < 0)) {
+  PCH_LOG(KERN_ERR, "pch_set_dma_desc -> Invalid Channel number "
+   ": %d.\n", channel);
+  retval = -ENODEV;
+ }
+ /* Checking whether channel is not allocated. */
+ else if (pch_dma_channel_table[channel].ch_alloced == (u16) 0) {
+  PCH_LOG(KERN_ERR,
+   "pch_set_dma_desc -> Channel not allocated.\n");
+  retval = -EINVAL;
+ }
+ /* Checking whether the channel is enabled. */
+ else if (pch_dma_channel_info[channel].bChEnabled == 1) {
+  PCH_LOG(KERN_ERR,
+   "pch_set_dma_desc -> Channel already enabled.\n");
+  retval = -EBUSY;
+ }
+ /* Checking if the mode is other than SCATTER_GATHER. */
+ else if (pch_dma_channel_info[channel].DMATransferMode !=
+   (u16) DMA_SCATTER_GATHER_MODE) {
+  PCH_LOG(KERN_ERR,
+   "pch_set_dma_desc -> Current mode id is not "
+   "SCATTER GATHER.\n");
+  retval = -EINVAL;
+ }
+ /* Checking whether start and end pointers are NULL or not */
+ else if ((start == NULL) || (end == NULL)) {
+  PCH_LOG(KERN_ERR,
+   "pch_set_dma_desc -> NULL pointer parameter.\n");
+  retval = -EINVAL;
+ } else {
+  /* Setting the descriptors. */
+  retval = dma_set_desc(channel, start, end);
+  PCH_DEBUG("pch_set_dma_desc -> Function dma_set_desc "
+     "returned %d.\n", retval);
+ }
+
+ PCH_DEBUG("Function pch_set_dma_desc returns %d.\n", retval);
+ return retval;
+}
+EXPORT_SYMBOL(pch_set_dma_desc);
+
+/*! @ingroup InterfaceLayerAPI
+ @fn int pch_add_dma_desc(int channel, struct pch_dma_desc *start,
+   struct pch_dma_desc *end)
+ @brief  Used to append the DMA descriptors for a channel.
+ @remarks Used when a new chain of descriptors is to be appended
+    to the existing chain of descriptors. This
+    function is invoked by functions from other
+    modules. The main tasks performed by this
+    function are:
+    - Verifies whether the obtained parameters are
+    valid, if not suitable error status codes are
+    returned to the called function.
+    - If valid interacts with the HAL API to append
+    the descriptor settings and returns the status
+    code returned by the HAL API.
+ @note  This function is accessible by other kernel modules.
+    The following points have to be noted while
+    passing the "start" and "end" pointer of the
+    descriptor.
+    - The address pointer by them should be physical
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
+   - @ref PCH_DMA_SUCCESS --> On success.
+   - -EAGAIN --> The device is in suspend mode.
+   - -ENODEV --> Specified DMA channel does not
+      exist.
+   - -EINVAL --> Invalid parameters passed.
+   - -EBUSY --> If DMA Transfer in progress or
+      channel is already enabled.
+ */
+int pch_add_dma_desc(int channel, struct pch_dma_desc *start,
+       struct pch_dma_desc *end)
+{
+ int retval;
+
+ /* Checking whether the device is in suspend mode. */
+ if (1 == pch_device_suspended) {
+  PCH_LOG(KERN_ERR,
+   "pch_add_dma_desc -> The device is in suspend "
+   "mode.\n");
+  retval = -EAGAIN;
+ }
+ /* Checking for validity of channel number  */
+ else if ((channel >= PCH_DMA_CHANNELS_MAX) || (channel < 0)) {
+  PCH_LOG(KERN_ERR, "pch_add_dma_desc -> Invalid Channel "
+   "number : %d", channel);
+  retval = -ENODEV;
+ }
+ /* Checking whether channel is not allocated. */
+ else if (pch_dma_channel_table[channel].ch_alloced == (u16) 0) {
+  PCH_LOG(KERN_ERR,
+   "pch_add_dma_desc -> Channel not alloctaed.\n");
+  retval = -EINVAL;
+ }
+ /* Checking whether the channel is enabled. */
+ else if (pch_dma_channel_info[channel].bChEnabled == 1) {
+  PCH_LOG(KERN_ERR,
+   "pch_add_dma_desc -> Channel already enabled.\n");
+  retval = -EBUSY;
+ }
+ /* Checking whether the mode is other than SCATTER_GATHER. */
+ else if (pch_dma_channel_info[channel].DMATransferMode !=
+   (u16) DMA_SCATTER_GATHER_MODE) {
+  PCH_LOG(KERN_ERR,
+   "pch_add_dma_desc -> Current mode id is not "
+   "SCATTER_GATHER.\n");
+  retval = -EINVAL;
+ }
+ /* Checking if descriptor field of the channel is set earlier. */
+ else if ((pch_dma_channel_info[channel].pHeadOfList == NULL) ||
+   (pch_dma_channel_info[channel].pTailOfList == NULL)) {
+  PCH_LOG(KERN_ERR, "pch_add_dma_desc -> Descriptor list not "
+   "set earlier.\n");
+  retval = -EINVAL;
+ }
+ /* Checking whether start and end pointers are NULL or not */
+ else if ((start == NULL) || (end == NULL)) {
+  PCH_LOG(KERN_ERR,
+   "pch_add_dma_desc -> NULL pointer parameter.\n");
+  retval = -EINVAL;
+ } else {
+  /* Appending the descriptors to the available list. */
+  retval = dma_add_desc(channel, start, end);
+  PCH_DEBUG
+      ("pch_add_dma_desc -> Function dma_add_desc returned %d.\n",
+       retval);
+ }
+
+ PCH_DEBUG("Function pch_add_dma_desc returns %d.\n", retval);
+ return retval;
+}
+EXPORT_SYMBOL(pch_add_dma_desc);
+
+/*! @ingroup InterfaceLayerAPI
+ @fn   int pch_enable_dma(int channel)
+ @brief  Used to enable a DMA channel.
+ @remarks Used when a DMA channel has to be enabled. This
+    function is invoked by functions from other
+    kernel modules. The main tasks performed by this
+    function are:
+    - Verifies whether the obtained parameters are
+    valid, if not suitable error status codes are
+    returned to the called function.
+    - If valid interacts with the HAL API to enable
+    the channel and returns the status code returned
+    by the HAL API.
+ @note  This function is accessible by other kernel modules.
+
+ @param  channel  [@ref IN] DMA channel number .
+
+ @return int
+   - @ref PCH_DMA_SUCCESS --> On success.
+   - -EAGAIN  --> Device is in suspend mode.
+   - -ENODEV  --> Specified DMA channel does
+       not exist.
+   - -EINVAL  --> Specified channel is not
+       allocated.
+   - -EBUSY  --> DMA Transfer already in
+       progress or channel is
+       already enabled.
+ */
+int pch_enable_dma(int channel)
+{
+ int retval;
+
+ /* Checking whether the device is in suspend mode. */
+ if (pch_device_suspended == 1) {
+  PCH_LOG(KERN_ERR, "pch_enable_dma -> Device is in suspend "
+   "mode.\n");
+  retval = -EAGAIN;
+ }
+ /* Checking for validity of channel number  */
+ else if ((channel >= PCH_DMA_CHANNELS_MAX) || (channel < 0)) {
+  PCH_LOG(KERN_ERR, "pch_enable_dma ->Invalid Channel number "
+   ": %d.\n", channel);
+  retval = -ENODEV;
+ }
+ /* Checking whether channel is allocated. */
+ else if (pch_dma_channel_table[channel].ch_alloced == (u16) 0) {
+  PCH_LOG(KERN_ERR, "pch_enable_dma -> Channel not allocated.\n");
+  retval = -EINVAL;
+ }
+ /* Checking whether the channel is already enabled. */
+ else if (pch_dma_channel_info[channel].bChEnabled == 1) {
+  PCH_LOG(KERN_ERR,
+   "pch_enable_dma -> Channel already enabled.\n");
+  retval = -EBUSY;
+ } else {
+  /* Enabling the channel. */
+  retval = dma_enable_ch(channel);
+  PCH_DEBUG("pch_enable_dma -> Function dma_enable_ch returned "
+     "%d.\n", retval);
+ }
+
+ PCH_DEBUG("Function pch_enable_dma returns %d.\n", retval);
+ return retval;
+}
+EXPORT_SYMBOL(pch_enable_dma);
+
+/*! @ingroup InterfaceLayerAPI
+ @fn   int pch_disable_dma(int channel)
+ @brief  Used to disable a DMA channel.
+ @remarks Used when a DMA channel has to be disabled. This
+    function is invoked by functions from other
+    kernel modules. The main tasks performed by this
+    function are:
+    - Verifies whether the obtained parameters are
+    valid, if not suitable error status codes are
+    returned to the called function.
+    - If valid interacts with the HAL API to disable
+    the channel and returns the status code returned
+    by the HAL API.
+ @note  This function is accessible by other kernel modules.
+
+ @param  channel [@ref IN] DMA channel number .
+
+ @return int
+   - @ref PCH_DMA_SUCCESS --> On success.
+   - -ENODEV --> Specified DMA channel does not
+      exist.
+   - -EINVAL --> Specified channel is not allocated.
+
+ */
+int pch_disable_dma(int channel)
+{
+ int retval;
+ u16 statusInfo;
+
+ /* Checking whether the device is in suspend mode. */
+ if (pch_device_suspended == 1) {
+  PCH_LOG(KERN_ERR, "pch_disable_dma -> Device is in "
+   "suspend mode.\n");
+  retval = -EAGAIN;
+ }
+ /* Checking for validity of channel number.  */
+ else if ((channel >= PCH_DMA_CHANNELS_MAX) || (channel < 0)) {
+  PCH_LOG(KERN_ERR, "pch_disable_dma -> Invalid Channel "
+   "number : %d", channel);
+  retval = -ENODEV;
+ }
+ /* Checking whether channel is allocated. */
+ else if (pch_dma_channel_table[channel].ch_alloced == (u16) 0) {
+  PCH_LOG(KERN_ERR, "pch_disable_dma -> Channel not "
+   "allocated.\n");
+  retval = -EINVAL;
+ }
+ /* Check whether channel is already disabled. */
+ else if (pch_dma_channel_info[channel].bChEnabled == (u16) 0) {
+  retval = PCH_DMA_SUCCESS;
+ } else {
+  u32 counter = COUNTER_LIMIT;
+
+  /* Wait for any DMA for certain interval transfer to end
+     before disabling the channel */
+  do {
+   get_dma_status(channel, &statusInfo);
+  } while ((counter--) && (statusInfo != (u16) DMA_STATUS_IDLE));
+
+  /* Disabling the channel. */
+  retval = dma_disable_ch(channel);
+  PCH_DEBUG("pch_disable_dma -> Function dma_disable_ch "
+     "returned %d.\n", retval);
+
+ }
+
+ PCH_DEBUG("Function pch_disable_dma returns " "%d.\n", retval);
+ return retval;
+}
+EXPORT_SYMBOL(pch_disable_dma);
+
+/*! @ingroup InterfaceLayerAPI
+ @fn int pch_dma_set_callback(int channel,
+   void (*pch_dma_cbr)( int value,unsigned long data1),
+   unsigned long data)
+ @brief Used to set the callback function for particular DMA channel.
+ @remarks Sets the callback function to be called when an
+    interrupt occurs. This function is invoked by
+    functions from other kernel modules. The main
+    tasks performed by this function are:
+    - Verifies whether the obtained parameters are
+    valid, if not suitable error status codes are
+    returned to the called function.
+    - If valid interacts with the HAL API to set the
+    callback function settings and returns the
+    status code returned by the HAL API.
+ @note  This function is accessible by other kernel modules.
+
+ @param  channel  [@ref IN] DMA channel number .
+ @param pch_dma_cbr [@ref IN] Pointer to the call-back
+       function.
+
+ @return int
+   - @ref PCH_DMA_SUCCESS --> On success.
+   - -EAGAIN  --> Device is in suspend mode.
+   - -EINVAL  --> Parameter passed is invalid.
+   - -ENODEV  --> Specified DMA channel does
+       not exist.
+   - -EBUSY  --> If the channel is already
+       enabled.
+ */
+int pch_dma_set_callback(int channel,
+    void (*pch_dma_cbr) (int value, unsigned long data1),
+    unsigned long data)
+{
+ int retval;
+
+ /* Checking whether the device is in suspend mode. */
+ if (pch_device_suspended == 1) {
+  PCH_LOG(KERN_ERR, "pch_dma_set_callback -> The device is "
+   "in suspend mode.\n");
+  retval = -EAGAIN;
+ }
+ /* Checking for validity of channel number  */
+ else if ((channel >= PCH_DMA_CHANNELS_MAX) || (channel < 0)) {
+  PCH_LOG(KERN_ERR, "pch_dma_set_callback -> Invalid Channel "
+   "number : %d.\n", channel);
+  retval = -ENODEV;
+ }
+ /* Checking whether channel is not allocated. */
+ else if (pch_dma_channel_table[channel].ch_alloced == (u16) 0) {
+  PCH_LOG(KERN_ERR,
+   "pch_dma_set_callback -> Channel not allocated.\n");
+  retval = -EINVAL;
+ }
+ /* Checking whether the channel is already enabled. */
+ else if (pch_dma_channel_info[channel].bChEnabled == 1) {
+  PCH_LOG(KERN_ERR,
+   "pch_dma_set_callback -> Channel already enabled.\n");
+  retval = -EBUSY;
+ }
+ /* Checking whether function pointer is NULL or not */
+ else if (pch_dma_cbr == NULL) {
+  PCH_LOG(KERN_ERR,
+   "pch_dma_set_callback -> NULL pointer parameter.\n");
+  retval = -EINVAL;
+ } else {
+  /* Setting the callback. */
+  dma_set_callback(channel, pch_dma_cbr, data);
+  PCH_DEBUG
+      ("pch_dma_set_callback -> Function dma_set_callback invoked"
+       " successfully.\n");
+
+  retval = PCH_DMA_SUCCESS;
+ }
+
+ PCH_DEBUG("Function pch_dma_set_callback " "returns %d.\n", retval);
+ return retval;
+}
+EXPORT_SYMBOL(pch_dma_set_callback);
+
+/*! @ingroup InterfaceLayer
+ @fn  int pch_set_dma_priority (int channel, int priority)
+ @brief  Sets the priority of the DMA channel.
+ @remarks Sets the priority that has to be assigned for a
+    particular channel. This function is invoked by
+    functions from other kernel modules. The main
+    tasks performed by this function are:
+    - Verifies whether the obtained parameters are
+    valid, if not, suitable error status codes are
+    returned to the called function.
+    - If valid, interacts with the HAL API to set
+    the DMA channel priority settings and returns
+    the status code returned by the HAL API.
+ @note  This function is accessible by other kernel modules.
+
+ @param channel  [@ref IN] DMA channel number.
+ @param priority [@ref IN] Priority to be set for the
+       DMA channel.
+
+ @return int
+   - @ref PCH_DMA_SUCCESS --> On success.
+   - -EAGAIN --> Device is in suspend mode.
+   - -EINVAL --> Parameter passed is invalid.
+   - -EBUSY --> If channel is in use.
+   - -ENODEV --> Specified DMA channel does not
+      exist.
+
+ */
+int pch_set_dma_priority(int channel, int priority)
+{
+ int retval;
+
+ /* Checking whether the device is in suspend mode. */
+ if (pch_device_suspended == 1) {
+  PCH_LOG(KERN_ERR, "pch_set_dma_priority -> The device is "
+   "in suspend mode.\n");
+  retval = -EAGAIN;
+ }
+ /* Checking for validity of channel number  */
+ else if ((channel >= PCH_DMA_CHANNELS_MAX) || (channel < 0)) {
+  PCH_LOG(KERN_ERR, "pch_set_dma_priority -> Invalid Channel "
+   "number : %d", channel);
+  retval = -ENODEV;
+ }
+ /* Checking whether channel is not allocated. */
+ else if (pch_dma_channel_table[channel].ch_alloced == (u16) 0) {
+  PCH_LOG(KERN_ERR, "pch_set_dma_priority -> Channel not "
+   "allocated.\n");
+  retval = -EINVAL;
+ }
+ /* Checking whether the device is enabled. */
+ else if (pch_dma_channel_info[channel].bChEnabled == 1) {
+  PCH_LOG(KERN_ERR, "pch_set_dma_priority -> Channel already "
+   "enabled.\n");
+  retval = -EBUSY;
+ }
+ /* Check for validity of priority value */
+ else if ((priority > 3) || (priority < 0)) {
+  PCH_LOG(KERN_ERR, "pch_set_dma_priority -> Invalid value "
+   "priority (%d)", priority);
+  retval = -EINVAL;
+ } else {
+  retval = dma_set_priority(channel, priority);
+  PCH_DEBUG("pch_set_dma_priority -> Function dma_set_priority "
+     "returns %d.\n", retval);
+ }
+
+ PCH_DEBUG("Function pch_set_dma_priority returns " "%d.\n", retval);
+ return retval;
+}
+EXPORT_SYMBOL(pch_set_dma_priority);
+
+/*! @ingroup InterfaceLayerAPI
+ @fn   int pch_dma_direct_start (int channel)
+ @brief  Used to initiate a DMA transfer.
+ @remarks Generates the DMA request to begin DMA transfer
+    on a particular channel. This function is
+    invoked by functions from other kernel modules.
+    The main tasks performed by this function are:
+    - Verifies whether the obtained parameters are
+    valid, if not suitable error status codes are
+    returned to the called function.
+    - If valid interacts with the HAL API to
+    initiate the DMA process and returns the status
+    code returned by the HAL API.
+ @note  This function is accessible by other kernel modules.
+
+ @param  channel  DMA channel number.
+
+ @return int
+   - @ref PCH_DMA_SUCCESS --> On success.
+   - -EAGAIN --> Device is in suspend mode.
+   - -EBUSY --> Specified DMA channel is not idle.
+   - -ENODEV --> Specified DMA channel does not
+      exist.
+   - -EINVAL --> Specified channel is not allocated.
+
+ */
+int pch_dma_direct_start(int channel)
+{
+ int retval = 0;
+
+ /* Checking whether the device is in suspend mode. */
+ if (pch_device_suspended == 1) {
+  PCH_LOG(KERN_ERR, "pch_dma_direct_start -> The device is in "
+   "suspend mode.\n");
+  retval = -EAGAIN;
+ }
+ /* Checking for validity of channel number  */
+ else if ((channel >= PCH_DMA_CHANNELS_MAX) || (channel < 0)) {
+  PCH_LOG(KERN_ERR, "pch_dma_direct_start -> Invalid Channel "
+   "number : %d.\n", channel);
+  retval = -ENODEV;
+ }
+ /* Checking whether channel is reserved or not */
+ else if (pch_dma_channel_table[channel].ch_alloced == (u16) 0) {
+  PCH_LOG(KERN_ERR, "pch_dma_direct_start -> Channel not "
+   "allocated.\n");
+  retval = -EINVAL;
+ }
+ /* Checking whether the device is not enabled. */
+ else if (pch_dma_channel_info[channel].bChEnabled == 0) {
+  PCH_LOG(KERN_ERR, "pch_dma_direct_start -> Channel not "
+   "enabled.\n");
+  retval = -EBUSY;
+ } else {
+  /* Initiating the DMA transfer */
+  retval = dma_direct_start(channel);
+  PCH_DEBUG("pch_dma_direct_start -> Function dma_direct_start "
+     "returned %d.\n", retval);
+ }
+
+ PCH_DEBUG("Function pch_dma_direct_start returns " "%d.\n", retval);
+ return retval;
+}
+EXPORT_SYMBOL(pch_dma_direct_start);
diff -urN linux-2.6.33.1/drivers/dma/pch_dma/pch_dma_main.h
topcliff-2.6.33.1/drivers/dma/pch_dma/pch_dma_main.h
--- linux-2.6.33.1/drivers/dma/pch_dma/pch_dma_main.h 1970-01-01
09:00:00.000000000 +0900
+++ topcliff-2.6.33.1/drivers/dma/pch_dma/pch_dma_main.h 2010-04-27
11:46:20.000000000 +0900
@@ -0,0 +1,262 @@
+/**
+ * @file pch_dma_main.h
+ *
+ * @brief
+ *  This file declares the structures & data types used by the
+ *  PCH_DMA driver.
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
+#ifndef __PCH_DMA_H__
+#define __PCH_DMA_H__
+
+/*! @ingroup InterfaceLayer
+ @def  DMA_ONE_SHOT_MODE
+ @brief  Constant used to denote the mode as ONE_SHOT.
+ @note  This constant is used by other modules to make the
+    DMA module aware of the mode it requires.
+*/
+#define DMA_ONE_SHOT_MODE   (0x2U)
+
+/*! @ingroup InterfaceLayer
+ @def  DMA_SCATTER_GATHER_MODE
+ @brief  Constant used to denote the mode as SCATTER_GATHER.
+ @note  This constant is used by other modules to make the
+    DMA module aware of the mode it requires.
+*/
+#define DMA_SCATTER_GATHER_MODE  (0x1U)
+
+/*! @ingroup InterfaceLayer
+ @def  PCH_DMA_SIZE_TYPE_8BIT
+ @brief  Constant used to denote the access size as 8BIT.
+ @note  This constant is used by other modules to make the
+    DMA module aware of the access size it requires.
+*/
+#define PCH_DMA_SIZE_TYPE_8BIT   ((0x3U << 12))
+
+/*! @ingroup InterfaceLayer
+ @def  PCH_DMA_SIZE_TYPE_16BIT
+ @brief  Constant used to denote the access size as 16BIT.
+ @note  This constant is used by other modules to make the
+    DMA module aware of the access size it requires.
+*/
+#define PCH_DMA_SIZE_TYPE_16BIT   ((0x2U << 12))
+
+/*! @ingroup InterfaceLayer
+ @def  PCH_DMA_SIZE_TYPE_32BIT
+ @brief  Constant used to denote the access size as 32BIT.
+ @note  This constant is used by other modules to make the
+    DMA module aware of the access size it requires.
+*/
+#define PCH_DMA_SIZE_TYPE_32BIT   (0x0U)
+
+/*! @ingroup InterfaceLayer
+ @def  PCH_DMA_DIR_OUT_TO_IN
+ @brief  Constant used to denote the transfer direction as
+    OUT_TO_IN.
+ @note  This constant is used by other modules to make the
+    DMA module aware of the transfer direction it
+    requires.
+*/
+#define PCH_DMA_DIR_OUT_TO_IN    (0x4)
+
+/*! @ingroup InterfaceLayer
+ @def  PCH_DMA_DIR_IN_TO_OUT
+ @brief  Constant used to denote the transfer direction as
+    IN_TO_OUT.
+ @note  This constant is used by other modules to make the
+    DMA module aware of the transfer direction it
+    requires.
+*/
+#define PCH_DMA_DIR_IN_TO_OUT    (0x0)
+
+/*! @ingroup InterfaceLayer
+ @def  PCH_DMA_END
+ @brief  Constant used to denote the transfer status as ACCESS
+ @note  This constant is used by DMA modules to make the
+    other module aware that the DMA operation ended
+    normally.
+*/
+#define PCH_DMA_END       (0)
+
+/*! @ingroup InterfaceLayer
+ @def  PCH_DMA_ABORT
+ @brief  Constant used to denote the transfer status as ACCESS
+ @note  This constant is used by DMA modules to make the
+    other module aware that the DMA abort has
+    occurred.
+*/
+#define PCH_DMA_ABORT      (-1)
+
+/* Bits to be sit as LSB2 bits of descriptor address. */
+/*! @ingroup InterfaceLayer
+ @def  DMA_DESC_END_WITH_INTERRUPT
+ @brief  Mask value for modifying the next descriptor
+    address, so that the descriptor end with
+    interrupt.
+*/
+#define DMA_DESC_END_WITH_INTERRUPT (0x00000001UL)
+
+/*! @ingroup InterfaceLayer
+ @def  DMA_DESC_FOLLOW_WITH_INTERRUPT
+ @brief  Mask value for modifying the next descriptor
+    address, so that the descriptor follow with
+    interrupt.
+
+*/
+#define DMA_DESC_FOLLOW_WITH_INTERRUPT (0x00000003UL)
+
+/*! @ingroup InterfaceLayer
+ @def  DMA_DESC_END_WITHOUT_INTERRUPT
+ @brief  Mask value for modifying the next descriptor
+    address, so that the descriptor end without
+    interrupt.
+*/
+#define DMA_DESC_END_WITHOUT_INTERRUPT (0x00000000UL)
+
+/*! @ingroup InterfaceLayer
+ @def  DMA_DESC_FOLLOW_WITHOUT_INTERRUPT
+ @brief  Mask value for modifying the next descriptor
+    address, so that the descriptor follow without
+    interrupt.
+
+*/
+#define DMA_DESC_FOLLOW_WITHOUT_INTERRUPT (0x00000002UL)
+
+/*! @ingroup InterfaceLayer
+ @def  PCH_DMA_8BIT_COUNT_MAX
+ @brief  The maximun transfer count that can be set for
+    a 8Bit Access.
+
+*/
+#define PCH_DMA_8BIT_COUNT_MAX (0x3FF)
+
+/*! @ingroup InterfaceLayer
+ @def  PCH_DMA_16BIT_COUNT_MAX
+ @brief  The maximun transfer count that can be set for
+    a 16Bit Access.
+
+*/
+#define PCH_DMA_16BIT_COUNT_MAX (0x3FF)
+
+/*! @ingroup InterfaceLayer
+ @def  PCH_DMA_32BIT_COUNT_MAX
+ @brief  The maximun transfer count that can be set for
+    a 32Bit Access.
+
+*/
+#define PCH_DMA_32BIT_COUNT_MAX (0x7FF)
+
+/*! @ingroup DMA
+ @def  PCH_DMA_SUCCESS
+ @brief  The value indicating a success.
+*/
+#define PCH_DMA_SUCCESS    (0)
+
+/*! @ingroup DMA
+ @def  PCH_DMA_FAILURE
+ @brief  The value indicating a failure.
+*/
+#define PCH_DMA_FAILURE    (-1)
+
+/*! @ingroup InterfaceLayerFacilitators
+ @enum  pch_channel_request_id
+ @brief  Constant used to denote the channel request type.
+ @note  These constants are used by other modules to make the
+    DMA module aware of the channel type it
+    requires.
+*/
+enum pch_channel_request_id {
+ PCH_DMA_TX_DATA_REQ0 = 1, /**< Transmission channel 0. */
+ PCH_DMA_RX_DATA_REQ0,  /**< Reception channel 0. */
+ PCH_DMA_TX_DATA_REQ1,  /**< Transmission channel 1. */
+ PCH_DMA_RX_DATA_REQ1,  /**< Reception channel 1. */
+ PCH_DMA_TX_DATA_REQ2,  /**< Transmission channel 2. */
+ PCH_DMA_RX_DATA_REQ2,  /**< Reception channel 2. */
+ PCH_DMA_TX_DATA_REQ3,  /**< Transmission channel 3. */
+ PCH_DMA_RX_DATA_REQ3,  /**< Reception channel 3. */
+ PCH_DMA_TX_DATA_REQ4,  /**< Transmission channel 4. */
+ PCH_DMA_RX_DATA_REQ4,  /**< Reception channel 4. */
+ PCH_DMA_TX_DATA_REQ5,  /**< Transmission channel 5. */
+ PCH_DMA_RX_DATA_REQ5  /**< Reception channel 5. */
+};
+
+/*! @ingroup InterfaceLayerFacilitators
+ @struct  __pch_dma_mode_param
+ @brief  Format for specifying the mode characteristics of
+    a channel.
+ @note  This structure is used by other modules to make the
+    DMA module aware of the channel mode
+    characteristics.
+*/
+
+struct pch_dma_mode_param {
+ u16 TransferDirection; /**< Direction of Transfer(IN to OUT or OUT to
+    IN). */
+ u16 DMASizeType; /**< Type of DMA Transfer size (8bit, 16bit or
+    32bit). */
+ u16 DMATransferMode; /**< Mode of Transfer (ONE_SHOT_MODE or
+    SCATTER_GATHER_MODE). */
+};
+
+/*! @ingroup InterfaceLayerFacilitators
+ @struct  __pch_dma_desc
+ @brief  Format for specifying the descriptors.
+ @note  This structure is used by other modules to make the
+    DMA module aware of the channel descriptors in
+    SCATTER_GATHER_MODE.
+*/
+
+struct pch_dma_desc {
+ u32 insideAddress;     /**< Inside address.  */
+ u32 outsideAddress;    /**< Outside address.  */
+ u32 size;        /**< Size.   */
+ u32 nextDesc;        /**< Next Descriptor address.*/
+};
+
+extern int pch_request_dma(struct pci_dev *dev, int dreq);
+extern int pch_free_dma(int channel);
+extern int pch_set_dma_mode(int channel, struct pch_dma_mode_param
stModeParam);
+extern int pch_set_dma_addr(int channel, unsigned int iaddr,
+       unsigned int oaddr);
+extern int pch_set_dma_count(int channel, unsigned int count);
+extern int pch_set_dma_desc(int channel, struct pch_dma_desc *start,
+       struct pch_dma_desc *end);
+extern int pch_add_dma_desc(int channel, struct pch_dma_desc *start,
+       struct pch_dma_desc *end);
+extern int pch_enable_dma(int channel);
+extern int pch_disable_dma(int channel);
+extern int pch_dma_set_callback(int channel,
+    void (*pch_dma_cbr) (int value,
+           unsigned long data1),
+    unsigned long data);
+extern int pch_set_dma_priority(int channel, int priority);
+extern int pch_dma_direct_start(int channel);
+
+#endif
diff -urN linux-2.6.33.1/drivers/dma/pch_dma/pch_dma_pci.c
topcliff-2.6.33.1/drivers/dma/pch_dma/pch_dma_pci.c
--- linux-2.6.33.1/drivers/dma/pch_dma/pch_dma_pci.c 1970-01-01
09:00:00.000000000 +0900
+++ topcliff-2.6.33.1/drivers/dma/pch_dma/pch_dma_pci.c 2010-04-27
11:46:20.000000000 +0900
@@ -0,0 +1,692 @@
+/**
+ * @file pch_dma_pci.c
+ *
+ * @brief
+ *  This file defines the methods of PCH_DMA_CONTROLLER driver.
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
+/* inclusion of system specific header files. */
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+
+/* inclusion of module specific header files. */
+#include "pch_debug.h"
+#include "pch_dma_pci.h"
+#include "pch_dma_hal.h"
+
+MODULE_LICENSE("GPL");
+
+/* Global variables */
+
+/*! @ingroup Global
+ @var  MODULE_NAME
+ @brief  The module name variable.
+ @remarks This variable is used as the module name.
+*/
+#define MODULE_NAME "pch_dma"
+/*! @ingroup Global
+ @var  pch_device_suspended
+ @brief  Device suspend flag.
+ @remarks This variable is used as a flag variable
+    for denoting the device suspend state.
+ @see
+  - pch_dma_suspend
+  - pch_dma_resume
+*/
+unsigned char pch_device_suspended;
+
+/*! @ingroup Global
+ @var  pch_device_lock
+ @brief  Device lock variable.
+ @remarks This variable is used as a lock variable
+    for accessing the DMA channel.
+ @see
+  - pch_request_dma
+*/
+spinlock_t pch_device_lock;
+
+/*! @ingroup Global
+ @var  pch_dma_devices
+ @brief  Stores the details of the DMA devices.
+ @remarks This variable is the instance of the structure
+    struct pch_dma_devices, which includes fields
+    for storing the details of the detected DMA
+    devices. This variable facilitates easy transfer
+    of information among the different functions of
+    the DMA module.
+*/
+struct pch_dma_devices pch_dma_devices[PCH_DMA_MAX_DEVS];
+
+/*! @ingroup PCILayerFacilitators
+ @struct  pch_dma_pcidev_id
+ @brief  The structure for specifying the supported
+    device IDs to the PCI Kernel subsystem.
+ @remarks This structure is the instance of the
+    kernel provided structure pci_device_id,
+    which is used to store the PCI devices
+    Vendor and Device ID. This structure is
+    used during the registration of the DMA module
+    as PCI Driver. This structure makes the Kernel
+    aware of the PCI devices supported by this
+    module.
+
+ @see
+  - pch_dma_controller_driver
+*/
+
+static const struct pci_device_id pch_dma_pcidev_id[] __devinitdata = {
+ /* 4 Channel DMA device IDs */
+ {PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PCH1_DMA4_0)},
+
+ /* 8 Channel DMA device IDs */
+ {PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PCH1_DMA8_0)},
+
+ /* 12 Channel DMA device IDs */
+ {}
+};
+
+/* Function prototypes */
+static int __devinit pch_dma_probe(struct pci_dev *pdev,
+       const struct pci_device_id *id);
+static void __devexit pch_dma_remove(struct pci_dev *pdev);
+static int pch_dma_suspend(struct pci_dev *pdev, pm_message_t state);
+static int pch_dma_resume(struct pci_dev *pdev);
+static __init int pch_dma_pci_init(void);
+static __exit void pch_dma_pci_exit(void);
+static inline u32 get_dev_type(u32 devid);
+
+/*! @ingroup PCILayer
+ @def  PCH_INVALID_DEVICE
+ @brief  The return value of @ref get_dev_type for invalid
+    device type.
+
+ @see
+  - get_dev_type
+*/
+#define PCH_INVALID_DEVICE   (0xFFFF)
+
+/*! @ingroup InternalFunction
+ @fn   static inline u32 get_dev_type (u32 devid)
+ @brief  Returns the PCH device type for given PCI device id.
+ @remarks This function returns the type of the detected DMA
+    device. The type specifies the number of DMA
+    channels contained within the detected device.
+    The tasks performed by this function include:
+    - Matches the PCI device ID passed to it with a
+    set of known device IDs.
+    - If a match is found it returns a constant
+    which indicates the device type (number of DMA
+    channels) within the device.
+    - If no match is found it returns @ref
+    PCH_INVALID_DEVICE.
+
+ @param  devid [@ref IN] The device ID to be verified.
+
+ @return  u32
+   - Values other than @ref PCH_INVALID_DEVICE
+     --> Detected device is valid and
+     supported.
+   - @ref PCH_INVALID_DEVICE --> Invalid device
+     detected.
+
+ @see
+   - pch_dma_probe
+
+*/
+static inline u32 get_dev_type(u32 devid)
+{
+ u32 dev_type;
+
+ switch (devid) {
+ case PCI_DEVICE_ID_INTEL_PCH1_DMA4_0:
+  dev_type = PCH_DMA_4CH0;
+  break;
+
+ case PCI_DEVICE_ID_INTEL_PCH1_DMA8_0:
+  dev_type = PCH_DMA_8CH0;
+  break;
+
+ default:
+  PCH_LOG(KERN_ERR, "get_dev_type -> Unknown PCI "
+   "device 0x%x\n", devid);
+  dev_type = PCH_INVALID_DEVICE;
+  break;
+
+ }
+
+ PCH_DEBUG("Function get_dev_type returns %x.\n", dev_type);
+ return dev_type;
+}
+
+/*! @ingroup PCILayerAPI
+ @fn  static int __devinit pch_dma_probe(struct pci_dev* pdev,
+    const struct pci_device_id* id)
+ @brief  Implements the probe function for the PCI driver.
+ @remarks This function acts as the probe function for
+    the PCI driver. The PCI core will be invoking
+    this function once it determines that this
+    driver is suitable for handling a particular
+    hardware. The main tasks performed by this
+    function are:
+    - Confirms whether the detected device is
+    supported by the driver.
+    - Enables the PCi device.
+    - Attains the device specific resources and
+    store it for further use.
+    - Enables the device and registers the handler
+    for handling the device interrupts.
+    - Initializes the device specific data
+    structures.
+
+ @param  pdev [@ref INOUT] Reference to the pci_device
+    structure.
+ @param  id [@ref IN] Reference to the pci_device_id
+    for which this device matches.
+
+ @return int
+   - @ref PCH_DMA_SUCCESS --> On success.
+   - -EIO  --> pci_enable_device error status code.
+   - -EBUSY: --> pci_request_regions/request_irq
+    error status code.
+   - -EINVAL --> pci_enable_device/request_irq error
+    status code/invalid device ID.
+   - -ENOMEM --> request_irq/pci_iomap error status
+    code.
+   - -ENOSYS --> request_irq error status code.
+
+ @see
+   - pch_dma_controller_driver
+  */
+static int __devinit pch_dma_probe(struct pci_dev *pdev,
+       const struct pci_device_id *id)
+{
+ static unsigned int pch_dma_dcount;
+ int retval;
+ u32 dev_type;
+ u32 base_addr = 0;
+ u8 device_enabled = 0;
+ u8 regions_requested = 0;
+ u8 irq_registered = 0;
+
+ do {
+  /* Getting the internally used device ID of the detected
+  device. */
+  dev_type = get_dev_type(id->device);
+  /* If invalid device. */
+  if ((PCH_INVALID_DEVICE == dev_type)) {
+   PCH_LOG(KERN_ERR, "pch_dma_probe -> Invalid device ID "
+    "%x.\n", id->device);
+   retval = -EINVAL;
+   break;
+  }
+  PCH_DEBUG("pch_dma_probe -> Valid device ID detected %x.\n",
+     id->device);
+
+  /* Enabling the detected device */
+  retval = pci_enable_device(pdev);
+  if (0 != retval) {
+   PCH_LOG(KERN_ERR,
+    "pch_dma_probe -> Function pci_enable_device "
+    "failed, returned %d.\n", retval);
+   break;
+  }
+  device_enabled = 1;
+  PCH_DEBUG
+      ("pch_dma_probe -> Function pci_enable_device invoked "
+      "successfully returned %d.\n", retval);
+
+  pci_set_master(pdev);
+  PCH_DEBUG("pch_dma_probe -> Function pci_set_master invoked "
+     "successfully.\n");
+
+  /* Requesting the PCI device regions. */
+  retval = pci_request_regions(pdev, MODULE_NAME);
+  if (0 != retval) {
+   PCH_LOG(KERN_ERR,
+    "pch_dma_probe -> Function pci_request_regions "
+    "failed, returned %d.\n", retval);
+   break;
+  }
+  regions_requested = 1;
+  PCH_DEBUG
+      ("pch_dma_probe -> Function pci_request_regions invoked "
+      "successfully returned %d.\n", retval);
+
+  /* Remapping the device space to kernel space. */
+  /* Wipro 1/13/2010 Use Mem BAR */
+  base_addr = (u32) pci_iomap(pdev, 1, 0);
+  if (0 == base_addr) {
+   PCH_LOG(KERN_ERR,
+    "pch_dma_probe -> Function pci_iomap failed "
+    "returned %x.\n", base_addr);
+   retval = -ENOMEM;
+   break;
+  }
+  PCH_DEBUG
+      ("pch_dma_probe -> Function pci_iomap invoked successfully."
+       "\n");
+
+  /* Filling in the details within the device structure. */
+  pch_dma_devices[pch_dma_dcount].dev_typ = dev_type;
+  pch_dma_devices[pch_dma_dcount].base_addr = base_addr;
+  pch_dma_devices[pch_dma_dcount].dev = (void *)pdev;
+
+  /* Registering the interrupt handler. */
+  retval =
+      request_irq(pdev->irq, dma_interrupt, IRQF_SHARED,
+    MODULE_NAME, &pch_dma_devices[pch_dma_dcount]);
+  if (0 != retval) {
+   PCH_LOG(KERN_ERR,
+    "pch_dma_probe -> Function request_irq failed, "
+    "returned %d.\n", retval);
+
+   break;
+  }
+  irq_registered = 1;
+  PCH_DEBUG
+      ("pch_dma_probe -> Function request_irq invoked "
+       "successfully returned %d.\n", retval);
+
+  /* Initializing the DMA device. */
+  dma_init(base_addr, dev_type);
+  PCH_DEBUG
+      ("pch_dma_probe -> Function dma_init invoked successfully."
+       "\n");
+
+  /* Stroing the device structure reference for further use. */
+  pci_set_drvdata(pdev, &pch_dma_devices[pch_dma_dcount]);
+
+  /* Initializing the suspend flag and lock variable. */
+  if (0 == pch_dma_dcount) { /* Initialize only once. */
+   pch_device_suspended = 0;
+   spin_lock_init(&pch_device_lock);
+  }
+
+  /* Incrementing the device structure index. */
+  pch_dma_dcount++;
+
+  /* Probe successful. */
+  retval = PCH_DMA_SUCCESS;
+  PCH_DEBUG("pch_dma_probe -> Probe successful.\n");
+
+ } while (0);
+
+ if (PCH_DMA_SUCCESS != retval) {
+  /* Un-registering the interrupt handler. */
+  if (1 == irq_registered) {
+   free_irq(pdev->irq, &pch_dma_devices[pch_dma_dcount]);
+   PCH_DEBUG("pch_dma_probe -> Function free_irq invoked "
+      "successfully.\n");
+  }
+  /* Unmapping the remapped region. */
+  if (0 != base_addr) {
+   pci_iounmap(pdev, (void *)base_addr);
+   PCH_DEBUG
+       ("pch_dma_probe -> Function pci_iounmap invoked "
+        "successfully.\n");
+  }
+  /* Releasing the requested regions. */
+  if (1 == regions_requested) {
+   pci_release_regions(pdev);
+   PCH_DEBUG
+       ("pch_dma_probe -> Function pci_release_regions "
+       "invoked successfully.\n");
+  }
+  /* Disabling the device. */
+  if (1 == device_enabled) {
+   pci_disable_device(pdev);
+   PCH_DEBUG
+       ("pch_dma_probe -> Function pci_disable_device "
+       "invoked successfully.\n");
+  }
+
+  PCH_DEBUG("pch_dma_probe -> Probe failed.\n");
+ }
+
+ PCH_DEBUG("Function pch_dma_probe returns %d.\n", retval);
+ return retval;
+}
+
+/*! @ingroup PCILayerAPI
+ @fn static void __devexit pch_dma_remove(struct pci_dev* pdev)
+ @brief  Implements the remove function for the PCi driver.
+ @remarks This function is invoked by the PCI subsystem of the
+    Kernel when the DMA device is removed or the
+    module is unloaded.
+    It de-initializes and releases all the resources
+    attained during device detection. The main tasks
+    performed by this function are:
+    - De-initializes the DMA device.
+    - De-initializes the device specific data
+    structures.
+    - Releases all the resources attained during the
+    device detection phase.
+
+ @param pdev [@ref INOUT] Reference to the pci_device structure.
+
+ @return  None.
+
+ @see
+   - pch_dma_controller_driver
+  */
+static void __devexit pch_dma_remove(struct pci_dev *pdev)
+{
+ struct pch_dma_devices *dev;
+
+ /* Getting the driver data. */
+ dev = pci_get_drvdata(pdev);
+ /* Re-setting the driver data. */
+ pci_set_drvdata(pdev, NULL);
+
+ /* De-initializing the device. */
+ dma_exit(dev->dev_typ);
+ PCH_DEBUG("pch_dma_remove -> Function dma_exit invoked "
+    "successfully.\n");
+
+ /* Un-registering the interrupt handler. */
+ free_irq(pdev->irq, dev);
+ PCH_DEBUG("pch_dma_remove -> Function free_irq invoked "
+    "successfully.\n");
+
+ /* Un-mapping the remapped memory address. */

