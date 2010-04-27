Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0D0LCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 07:02:39 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:14602 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754370Ab0D0LCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 07:02:12 -0400
Message-ID: <002001cae5f9$159627e0$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Intel OTC" <joel.clark@intel.com>,
       "Andrew" <andrew.chih.howe.khor@intel.com>
Subject: [PATCH] Topcliff DMA: Add the DMA driver [1/4]
MIME-Version: 1.0
Date: Tue, 27 Apr 2010 20:01:44 +0900
Content-Type: message/partial;
	total=4;
	id="01CAE5F9.14BABC00@tsmail03";
	number=1
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "LKML" <linux-kernel@vger.kernel.org>
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>,
	"Wang, Qi" <qi.wang@intel.com>,
	"Intel OTC" <joel.clark@intel.com>,
	"Andrew" <andrew.chih.howe.khor@intel.com>
Subject: [PATCH] Topcliff DMA: Add the DMA driver
Date: Tue, 27 Apr 2010 20:01:44 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983

From: Masayuki Ohtake <masa-korg@dsn.okisemi.com>

This driver implements DMA controls for Topcliff.

Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>

---
 drivers/dma/Kconfig   |
 drivers/dma/Makefile   |
 drivers/dma/pch_dma/Makefile  |
 drivers/dma/pch_dma/pch_common.h |
 drivers/dma/pch_dma/pch_debug.h |
 drivers/dma/pch_dma/pch_dma_hal.c |
 drivers/dma/pch_dma/pch_dma_hal.h |
 drivers/dma/pch_dma/pch_dma_main.c |
 drivers/dma/pch_dma/pch_dma_main.h |
 drivers/dma/pch_dma/pch_dma_pci.c |
 drivers/dma/pch_dma/pch_dma_pci.h |
+++++++++++++++++++++++++++++++ 11 files changed, zz insertions(+)
diff -urN linux-2.6.33.1/drivers/dma/Kconfig
topcliff-2.6.33.1/drivers/dma/Kconfig
--- linux-2.6.33.1/drivers/dma/Kconfig 2010-03-16 01:09:39.000000000 +0900
+++ topcliff-2.6.33.1/drivers/dma/Kconfig 2010-03-23 10:40:05.000000000
+0900
@@ -20,6 +20,14 @@
 config ASYNC_TX_DISABLE_CHANNEL_SWITCH
  bool

+config PCH_UART_DMA
+ tristate "PCH DMA Controller"
+ depends on PCI && SERIAL_8250_PCH_DMA
+ default y
+ help
+   This value must equal to SERIAL_8250_PCH. This config PCH_UART_DMA is
+   referred by PCH UART.
+
 config INTEL_IOATDMA
  tristate "Intel I/OAT DMA support"
  depends on PCI && X86
diff -urN linux-2.6.33.1/drivers/dma/Makefile
topcliff-2.6.33.1/drivers/dma/Makefile
--- linux-2.6.33.1/drivers/dma/Makefile 2010-03-16 01:09:39.000000000 +0900
+++ topcliff-2.6.33.1/drivers/dma/Makefile 2010-03-23 10:40:05.000000000
+0900
@@ -12,3 +12,4 @@
 obj-$(CONFIG_SH_DMAE) += shdma.o
 obj-$(CONFIG_COH901318) += coh901318.o coh901318_lli.o
 obj-$(CONFIG_AMCC_PPC440SPE_ADMA) += ppc4xx/
+obj-$(CONFIG_PCH_UART_DMA) += pch_dma/
diff -urN linux-2.6.33.1/drivers/dma/pch_dma/Makefile
topcliff-2.6.33.1/drivers/dma/pch_dma/Makefile
--- linux-2.6.33.1/drivers/dma/pch_dma/Makefile 1970-01-01
09:00:00.000000000 +0900
+++ topcliff-2.6.33.1/drivers/dma/pch_dma/Makefile 2010-03-23
10:40:05.000000000 +0900
@@ -0,0 +1,5 @@
+#enable for debug;this can be added in Kconfig
+#EXTRA_CFLAGS += -DDEBUG
+
+obj-$(CONFIG_PCH_UART_DMA) += pch_dma.o
+pch_dma-objs := pch_dma_pci.o pch_dma_hal.o pch_dma_main.o
diff -urN linux-2.6.33.1/drivers/dma/pch_dma/pch_common.h
topcliff-2.6.33.1/drivers/dma/pch_dma/pch_common.h
--- linux-2.6.33.1/drivers/dma/pch_dma/pch_common.h 1970-01-01
09:00:00.000000000 +0900
+++ topcliff-2.6.33.1/drivers/dma/pch_dma/pch_common.h 2010-04-27
11:46:20.000000000 +0900
@@ -0,0 +1,144 @@
+/*!
+ * @file pch_common.h
+ * @brief Provides the macro definitions used by all files.
+ * @version 1.0.0.0
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
+#ifndef __PCH_COMMON_H__
+#define __PCH_COMMON_H__
+
+/*! @ingroup Global
+@def      PCH_WRITE8
+@brief   Macro for writing 8 bit data to an io/mem address
+*/
+#define PCH_WRITE8(val, addr)   iowrite8((val), (void __iomem *)(addr))
+/*! @ingroup Global
+@def      PCH_LOG
+@brief   Macro for writing 16 bit data to an io/mem address
+*/
+#define PCH_WRITE16(val, addr)  iowrite16((val), (void __iomem *)(addr))
+/*! @ingroup Global
+@def      PCH_LOG
+@brief   Macro for writing 32 bit data to an io/mem address
+*/
+#define PCH_WRITE32(val, addr)  iowrite32((val), (void __iomem *)(addr))
+
+/*! @ingroup Global
+@def      PCH_READ8
+@brief   Macro for reading 8 bit data from an io/mem address
+*/
+#define PCH_READ8(addr)   ioread8((void __iomem *)(addr))
+/*! @ingroup Global
+@def      PCH_READ16
+@brief   Macro for reading 16 bit data from an io/mem address
+*/
+#define PCH_READ16(addr)  ioread16((void __iomem *)(addr))
+/*! @ingroup Global
+@def      PCH_READ32
+@brief   Macro for reading 32 bit data from an io/mem address
+*/
+#define PCH_READ32(addr)  ioread32((void __iomem *)(addr))
+/*! @ingroup Global
+@def      PCH_WRITE32_F
+@brief   Macro for writing 32 bit data to an io/mem address
+*/
+#define PCH_WRITE32_F(val, addr) do \
+ { PCH_WRITE32((val), (addr)); (void)PCH_READ32((addr)); } while (0);
+
+/*! @ingroup Global
+@def      PCH_WRITE_BYTE
+@brief   Macro for writing 1 byte data to an io/mem address
+*/
+#define PCH_WRITE_BYTE PCH_WRITE8
+/*! @ingroup Global
+@def      PCH_WRITE_WORD
+@brief   Macro for writing 1 word data to an io/mem address
+*/
+#define PCH_WRITE_WORD PCH_WRITE16
+/*! @ingroup Global
+@def      PCH_WRITE_LONG
+@brief   Macro for writing long data to an io/mem address
+*/
+#define PCH_WRITE_LONG PCH_WRITE32
+
+/*! @ingroup Global
+@def      PCH_READ_BYTE
+@brief   Macro for reading 1 byte data from an io/mem address
+*/
+#define PCH_READ_BYTE  PCH_READ8
+/*! @ingroup Global
+@def      PCH_READ_WORD
+@brief   Macro for reading 1 word data from an io/mem address
+*/
+#define PCH_READ_WORD  PCH_READ16
+/*! @ingroup Global
+@def      PCH_READ_LONG
+@brief   Macro for reading long data from an io/mem address
+*/
+#define PCH_READ_LONG  PCH_READ32
+
+/* Bit Manipulation Macros */
+
+/*! @ingroup Global
+@def      PCH_READ_LONG
+@brief   macro to set a specified bit(mask) at the
+   specified address
+*/
+#define PCH_SET_ADDR_BIT(addr, bitmask) PCH_WRITE_LONG((PCH_READ_LONG(addr)
|\
+        (bitmask)), (addr))
+
+/*! @ingroup Global
+@def     PCH_READ_LONG
+@brief  macro to clear a specified bit(mask) at the specified address
+*/
+#define PCH_CLR_ADDR_BIT(addr, bitmask) PCH_WRITE_LONG((PCH_READ_LONG(addr)
&\
+        ~(bitmask)), (addr))
+
+/*! @ingroup Global
+@def      PCH_READ_LONG
+@brief   macro to set a specified bitmask for a variable
+*/
+#define PCH_SET_BITMSK(var, bitmask) ((var) |= (bitmask))
+
+/*! @ingroup Global
+@def      PCH_READ_LONG
+@brief   macro to clear a specified bitmask for a variable
+*/
+#define PCH_CLR_BITMSK(var, bitmask) ((var) &= (~(bitmask)))
+
+/*! @ingroup Global
+@def      PCH_READ_LONG
+@brief   macro to set a specified bit for a variable
+*/
+#define PCH_SET_BIT(var, bit) ((var) |= (1<<(bit)))
+
+/*! @ingroup Global
+@def      PCH_READ_LONG
+@brief   macro to clear a specified bit for a variable
+*/
+#define PCH_CLR_BIT(var, bit) ((var) &= ~(1<<(bit)))
+
+#endif
diff -urN linux-2.6.33.1/drivers/dma/pch_dma/pch_debug.h
topcliff-2.6.33.1/drivers/dma/pch_dma/pch_debug.h
--- linux-2.6.33.1/drivers/dma/pch_dma/pch_debug.h 1970-01-01
09:00:00.000000000 +0900
+++ topcliff-2.6.33.1/drivers/dma/pch_dma/pch_debug.h 2010-04-27
11:46:20.000000000 +0900
@@ -0,0 +1,58 @@
+/*!
+ * @file pch_debug.h
+ * @brief Provides the macro definitions used for debugging.
+ * @version 1.0.0.0
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
+#ifndef __PCH_DEBUG_H__
+#define __PCH_DEBUG_H__
+
+#ifdef MODULE
+#define PCH_LOG(level, fmt, args...) printk(level "%s:" fmt "\n",\
+       THIS_MODULE->name, ##args)
+#else
+#define PCH_LOG(level, fmt, args...) printk(level "%s:" fmt "\n" ,\
+        __FILE__, ##args)
+#endif
+
+
+#ifdef DEBUG
+ #define PCH_DEBUG(fmt, args...) PCH_LOG(KERN_DEBUG, fmt, ##args)
+#else
+ #define PCH_DEBUG(fmt, args...)
+#endif
+
+#ifdef PCH_TRACE_ENABLED
+ #define PCH_TRACE PCH_DEBUG
+#else
+ #define PCH_TRACE(fmt, args...)
+#endif
+
+#define PCH_TRACE_ENTER PCH_TRACE("Enter %s", __func__)
+#define PCH_TRACE_EXIT  PCH_TRACE("Exit %s", __func__)
+
+
+#endif
diff -urN linux-2.6.33.1/drivers/dma/pch_dma/pch_dma_hal.c
topcliff-2.6.33.1/drivers/dma/pch_dma/pch_dma_hal.c
--- linux-2.6.33.1/drivers/dma/pch_dma/pch_dma_hal.c 1970-01-01
09:00:00.000000000 +0900
+++ topcliff-2.6.33.1/drivers/dma/pch_dma/pch_dma_hal.c 2010-04-27
11:46:20.000000000 +0900
@@ -0,0 +1,1201 @@
+/**
+ * @file pch_dma_hal.c
+ *
+ * @brief
+ *  This file defines the PCH_DMA_CONTROLLER HAL API functions.
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
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/string.h>
+#include <linux/module.h>
+
+#include "pch_common.h"
+#include "pch_debug.h"
+#include "pch_dma_hal.h"
+
+/*! @ingroup HALLayer
+ @def  PCH_DMA_BIT_SET
+ @brief  Macro for setting selected bits of a register.
+ @remarks This macro is used to set the selected bits
+    at a given 32 bit location. Normally it is
+    used to set the bits of given register.
+*/
+#define PCH_DMA_BIT_SET(reg, bitmask) \
+   PCH_WRITE_LONG(((PCH_READ_LONG((reg)) | bitmask)), (reg))
+
+/*! @ingroup HALLayer
+ @def  PCH_DMA_BIT_CLEAR
+ @brief  Macro for re-setting selected bits of a register.
+ @remarks This macro is used to reset the selected bits
+    at a given 32 bit location. Normally it is
+    used to reset the bits of given register.
+*/
+#define PCH_DMA_BIT_CLEAR(regAddr, bitMask) \
+  PCH_WRITE_LONG((PCH_READ_LONG((regAddr)) & (~(bitMask))), \
+  (regAddr))
+
+/*! @ingroup HALLayer
+ @def  DEFAULT_CONTROL_REGISTER_VALUE
+ @brief  Macro for setting selected bits of control register.
+ @remarks This macro is used to set the mode and direction
+    bit of the control register of a specific
+    channel without affecting the settings of other
+    channels.
+*/
+#define DEFAULT_CONTROL_REGISTER_VALUE (0x33333333)
+
+/*! @ingroup HALLayer
+ @def  dma_clear_interrupt_status
+ @brief  Macro for clearing the interrupt status of the
+    DMA.
+ @remarks This macro is used to clear the interrupt status
+    bits of the DMA during handling of interrupts.
+*/
+#define dma_clear_interrupt_status(addr, stat0, stat2)  \
+do {        \
+ PCH_WRITE_LONG((stat0), ((addr) + DMA_STS0_OFFSET)); \
+ PCH_WRITE_LONG((stat2), ((addr) + DMA_STS2_OFFSET)); \
+} while (0)
+
+/*! @ingroup HALLayer
+ @def  dma_get_interrupt_status
+ @brief  Macro for getting the interrupt status of a
+    specific channel
+ @remarks This macro is used to get the interrupt status
+    of the DMA during handling of interrupts.
+*/
+#define dma_get_interrupt_status(ch, stat0, stat2)   \
+(         \
+ ((ch) < 8) ?       \
+ (((stat0) & (DMA_INTERRUPT_OCCUR << ch)) != 0)   \
+ :        \
+ (((stat2) & (DMA_INTERRUPT_OCCUR << (ch - 8))) != 0)  \
+)
+
+/*! @ingroup HALLayer
+ @def  dma_get_abort_status
+ @brief  Macro for getting the abort status of a specific
+    channel.
+ @remarks This macro is used to get the abort status
+    of the DMA during handling of interrupts.
+*/
+#define dma_get_abort_status(ch, stat0, stat2)    \
+(         \
+ ((ch) < 8) ?       \
+ (((stat0) & (DMA_ABORT_OCCUR << ch)) != 0)   \
+ :        \
+ (((stat2) & (DMA_ABORT_OCCUR << (ch - 8))) != 0)  \
+)
+
+/* Global Varibles */
+/*! @ingroup Global
+ @var  pch_dma_channel_info
+ @brief  Retains the specific channel information.
+*/
+struct pch_dma_controller_info pch_dma_channel_info[PCH_DMA_CHANNELS_MAX];
+
+/* Channel Allocation Table for DMA */
+/*! @ingroup Global
+ @var  pch_dma_channel_table
+ @brief  Retains the specific channel allocation
+    information.
+*/
+struct pch_dma_channel_alloc_table
pch_dma_channel_table[PCH_DMA_CHANNELS_MAX]
+= {
+ /* 4 channel DMA device0 (Reserved for GE.) */
+ {PCH_DMA_4CH0, PCH_DMA_TX_DATA_REQ0, PCI_DEVICE_ID_PCH_SPI, 0, 0, 0, 0},
+ {PCH_DMA_4CH0, PCH_DMA_RX_DATA_REQ0, PCI_DEVICE_ID_PCH_SPI, 1, 0, 0, 0},
+ {PCH_DMA_4CH0, 0, 0, 2, 0, 0, 0},
+ {PCH_DMA_4CH0, 0, 0, 3, 0, 0, 0},
+
+ /* 4 channel DMA device1 (Not reserved.) */
+ {PCH_DMA_4CH1, 0, 0, 0, 0, 0, 0},
+ {PCH_DMA_4CH1, 0, 0, 1, 0, 0, 0},
+ {PCH_DMA_4CH1, 0, 0, 2, 0, 0, 0},
+ {PCH_DMA_4CH1, 0, 0, 3, 0, 0, 0},
+
+ /* 4 channel DMA device2 (Not reserved.) */
+ {PCH_DMA_4CH2, 0, 0, 0, 0, 0, 0},
+ {PCH_DMA_4CH2, 0, 0, 1, 0, 0, 0},
+ {PCH_DMA_4CH2, 0, 0, 2, 0, 0, 0},
+ {PCH_DMA_4CH2, 0, 0, 3, 0, 0, 0},
+
+ /* 4 channel DMA device3 (Not reserved.) */
+ {PCH_DMA_4CH3, 0, 0, 0, 0, 0, 0},
+ {PCH_DMA_4CH3, 0, 0, 1, 0, 0, 0},
+ {PCH_DMA_4CH3, 0, 0, 2, 0, 0, 0},
+ {PCH_DMA_4CH3, 0, 0, 3, 0, 0, 0},
+
+ /* 4 channel DMA device4 (Not reserved.) */
+ {PCH_DMA_4CH4, 0, 0, 0, 0, 0, 0},
+ {PCH_DMA_4CH4, 0, 0, 1, 0, 0, 0},
+ {PCH_DMA_4CH4, 0, 0, 2, 0, 0, 0},
+ {PCH_DMA_4CH4, 0, 0, 3, 0, 0, 0},
+
+ /* 8 channel DMA device0 (Reserved for GE.) */
+ {PCH_DMA_8CH0, PCH_DMA_TX_DATA_REQ0, PCI_DEVICE_ID_PCH_UART0, 0, 0, 0,
+  0},
+ {PCH_DMA_8CH0, PCH_DMA_RX_DATA_REQ0, PCI_DEVICE_ID_PCH_UART0, 1, 0, 0,
+  0},
+ {PCH_DMA_8CH0, PCH_DMA_TX_DATA_REQ0, PCI_DEVICE_ID_PCH_UART1, 2, 0, 0,
+  0},
+ {PCH_DMA_8CH0, PCH_DMA_RX_DATA_REQ0, PCI_DEVICE_ID_PCH_UART1, 3, 0, 0,
+  0},
+ {PCH_DMA_8CH0, PCH_DMA_TX_DATA_REQ0, PCI_DEVICE_ID_PCH_UART2, 4, 0, 0,
+  0},
+ {PCH_DMA_8CH0, PCH_DMA_RX_DATA_REQ0, PCI_DEVICE_ID_PCH_UART2, 5, 0, 0,
+  0},
+ {PCH_DMA_8CH0, PCH_DMA_TX_DATA_REQ0, PCI_DEVICE_ID_PCH_UART3, 6, 0, 0,
+  0},
+ {PCH_DMA_8CH0, PCH_DMA_RX_DATA_REQ0, PCI_DEVICE_ID_PCH_UART3, 7, 0, 0,
+  0},
+
+ /* 8 channel DMA device1 */
+ {PCH_DMA_8CH1, 0, 0, 0, 0, 0, 0},
+ {PCH_DMA_8CH1, 0, 0, 1, 0, 0, 0},
+ {PCH_DMA_8CH1, 0, 0, 2, 0, 0, 0},
+ {PCH_DMA_8CH1, 0, 0, 3, 0, 0, 0},
+ {PCH_DMA_8CH1, 0, 0, 4, 0, 0, 0},
+ {PCH_DMA_8CH1, 0, 0, 5, 0, 0, 0},
+ {PCH_DMA_8CH1, 0, 0, 6, 0, 0, 0},
+ {PCH_DMA_8CH1, 0, 0, 7, 0, 0, 0},
+
+ /* 8 channel DMA device2 */
+ {PCH_DMA_8CH2, 0, 0, 0, 0, 0, 0},
+ {PCH_DMA_8CH2, 0, 0, 1, 0, 0, 0},
+ {PCH_DMA_8CH2, 0, 0, 2, 0, 0, 0},
+ {PCH_DMA_8CH2, 0, 0, 3, 0, 0, 0},
+ {PCH_DMA_8CH2, 0, 0, 4, 0, 0, 0},
+ {PCH_DMA_8CH2, 0, 0, 5, 0, 0, 0},
+ {PCH_DMA_8CH2, 0, 0, 6, 0, 0, 0},
+ {PCH_DMA_8CH2, 0, 0, 7, 0, 0, 0},
+
+ /* 8 channel DMA device3 (Doubts in allocating.) */
+ {PCH_DMA_8CH3, 0, 0, 0, 0, 0, 0},
+ {PCH_DMA_8CH3, 0, 0, 1, 0, 0, 0},
+ {PCH_DMA_8CH3, 0, 0, 2, 0, 0, 0},
+ {PCH_DMA_8CH3, 0, 0, 3, 0, 0, 0},
+ {PCH_DMA_8CH3, 0, 0, 4, 0, 0, 0},
+ {PCH_DMA_8CH3, 0, 0, 5, 0, 0, 0},
+ {PCH_DMA_8CH3, 0, 0, 6, 0, 0, 0},
+ {PCH_DMA_8CH3, 0, 0, 7, 0, 0, 0},
+
+ /* 12 channel DMA device0 */
+ {PCH_DMA_12CH0, 0, 0, 0, 0, 0, 0},
+ {PCH_DMA_12CH0, 0, 0, 1, 0, 0, 0},
+ {PCH_DMA_12CH0, 0, 0, 2, 0, 0, 0},
+ {PCH_DMA_12CH0, 0, 0, 3, 0, 0, 0},
+ {PCH_DMA_12CH0, 0, 0, 4, 0, 0, 0},
+ {PCH_DMA_12CH0, 0, 0, 5, 0, 0, 0},
+ {PCH_DMA_12CH0, 0, 0, 6, 0, 0, 0},
+ {PCH_DMA_12CH0, 0, 0, 7, 0, 0, 0},
+ {PCH_DMA_12CH0, 0, 0, 8, 0, 0, 0},
+ {PCH_DMA_12CH0, 0, 0, 9, 0, 0, 0},
+ {PCH_DMA_12CH0, 0, 0, 10, 0, 0, 0},
+ {PCH_DMA_12CH0, 0, 0, 11, 0, 0, 0}
+};
+
+/* Function Definitions */
+
+/*! @ingroup HALLayerAPI
+ @fn   void __init dma_init(u32 base, u32 dev_type)
+ @brief  Initializes local data structures for the DMAC device.
+ @remarks This function is called when a DMA device is detected.
+    It initializes the data structures associated
+    with the obtained device. The main tasks
+    performed by this function are:
+    - Waits until the status of a DMA channel
+    becomes idle and then disables it.
+    - Initializes the data structures that can
+    be used further.
+
+ @param  base  [@ref IN] The base address.
+ @param  dev_type [@ref IN] The type of the device.
+
+ @return None.
+
+ @see
+   - pch_dma_probe
+ */
+
+void __init dma_init(u32 base, u32 dev_type)
+{
+ int i;
+ u32 counter;
+ u16 DMAStatus;
+
+ for (i = 0; i < PCH_DMA_CHANNELS_MAX; i++) {
+  if (pch_dma_channel_table[i].dma_dev_id == dev_type) {
+   counter = COUNTER_LIMIT;
+
+   pch_dma_channel_table[i].ch_found = 1;
+   pch_dma_channel_table[i].ch_alloced = 0;
+   pch_dma_channel_table[i].base = base;
+
+   do {
+    get_dma_status(i, &DMAStatus);
+   } while ((counter--) && (DMAStatus != DMA_STATUS_IDLE));
+
+   (void)dma_disable_ch(i);
+   PCH_DEBUG("dma_init -> Channel %d disabled.\n", i);
+
+   (void)dma_enable_disable_interrupt
+       (i, PCH_DMA_INTERRUPT_DISABLE);
+   PCH_DEBUG
+       ("dma_init -> Interrupt disabled for channel %d.\n",
+        i);
+  }
+ }
+
+ PCH_DEBUG("Function dma_init invoked successfully.\n");
+}
+
+/*! @ingroup HALLayerAPI
+ @fn   void dma_exit(u32 dev_type)
+ @brief  De-initializes the DMA device.
+ @remarks The main tasks performed by this function are:
+    - Waits for a small interval for each channel
+    if the channel is not idle so that it can
+    complete its transfer.
+    - Disables the channel.
+    - Disables the concerned interrupt.
+
+ @param  dev_type [@ref IN] The type of the device.
+
+ @return  None
+
+ @see
+  - pch_dma_remove
+  - pch_dma_suspend
+*/
+void dma_exit(u32 dev_type)
+{
+ int i;
+ u32 counter;
+ u16 DMAStatus;
+
+ for (i = 0; i < PCH_DMA_CHANNELS_MAX; i++) {
+  if (pch_dma_channel_table[i].dma_dev_id == dev_type &&
+      pch_dma_channel_table[i].ch_found == 1) {
+   counter = COUNTER_LIMIT;
+   get_dma_status(i, &DMAStatus);
+
+   while ((counter > 0) &&
+          (DMAStatus != DMA_STATUS_IDLE)) {
+    counter--;
+    get_dma_status(i, &DMAStatus);
+   }
+
+   (void)dma_disable_ch(i);
+   PCH_DEBUG("dma_exit -> Channel %d disabled.\n", i);
+
+   (void)dma_enable_disable_interrupt
+       (i, PCH_DMA_INTERRUPT_DISABLE);
+   PCH_DEBUG("dma_exit -> Interrupt disabled for channel "
+      "%d.\n", i);
+  }
+ }
+
+ PCH_DEBUG("Function dma_exit invoked successfully.\n");
+}
+
+/*! @ingroup HALLayerAPI
+ @fn int dma_set_mode(int channel,
+   struct pch_dma_mode_param stModeParam)
+ @brief  Sets the Mode of transfer for DMA.
+ @remarks Does the setting of direction of transfer, access size
+    type and transfer mode. This function does not
+    perform any register write. The main tasks
+    performed by this function are:
+    - Set the DMATransferDirection field of @ref
+    pch_dma_channel_info with the direction of
+    transfer specified.
+    - Set the DMAAccessSize field of @ref
+    pch_dma_channel_info with the Access Size Type
+    specified.
+    - Set the DMATransferMode field of @ref
+    pch_dma_channel_info structure with the DMA mode
+    specified.
+
+ @param channel [@ref IN] The channel for which mode is to be set.
+ @param stModeParam [@ref IN] Structure which contains the
+     parameters for the setting of Mode.
+
+ @return  int
+   - @ref PCH_DMA_SUCCESS --> On success.
+
+ @see
+   - pch_set_dma_mode
+ */
+int dma_set_mode(int channel, struct pch_dma_mode_param stModeParam)
+{
+ pch_dma_channel_info[channel].DMAAccessSize = stModeParam.DMASizeType;
+ pch_dma_channel_info[channel].DMATransferMode =
+     stModeParam.DMATransferMode;
+ pch_dma_channel_info[channel].DMATransferDirection =
+     stModeParam.TransferDirection;
+
+ PCH_DEBUG("Function dma_set_mode returns %d.\n", PCH_DMA_SUCCESS);
+ return PCH_DMA_SUCCESS;
+}
+
+/*! @ingroup HALLayerAPI
+ @fn  int dma_set_addr(int channel, u32 iaddr, u32 oaddr)
+ @brief  Sets the Inside and Outside address in the case
+    of ONE SHOT MODE
+ @remarks This function updates Inside address and outside
+    address to be set in ONE SHOT mode. The main
+    tasks performed by this function are:
+    - Set the field in_addr of the @ref
+    pch_dma_channel_info structure of the
+    corresponding channel to the value of the
+    argument iaddr.
+    - Set the field out_addr of the @ref
+    pch_dma_channle_info structure of the
+    corresponding channel to the value of the
+    argument oaddr.
+
+ @param  channel [@ref IN] Channel for which addresses is
+    to be set.
+ @param  iaddr [@ref IN] Inside address to be set
+ @param  oaddr [@ref IN] Outside address to be set
+
+ @return  int
+   - @ref PCH_DMA_SUCCESS --> On Success.
+
+ @see
+   - pch_set_dma_addr
+
+  */
+int dma_set_addr(int channel, u32 iaddr, u32 oaddr)
+{
+ pch_dma_channel_info[channel].in_addr = iaddr;
+ pch_dma_channel_info[channel].out_addr = oaddr;
+
+ PCH_DEBUG("Function dma_set_addr returns %d.\n", PCH_DMA_SUCCESS);
+ return PCH_DMA_SUCCESS;
+}
+
+/*! @ingroup HALLayerAPI
+ @fn   int dma_enable_ch(int channel)
+ @brief  Enables the DMA channel specified.
+ @remarks This function sets the entire DMA settings such as
+    the transfer direction, transfer mode and
+    enables the channel. The main tasks performed by
+    this function are:
+    - Sets the transfer direction.
+    - Sets the transfer mode.
+    - Enabling the channel.
+
+ @param  channel  [@ref IN] Channel number that
+     is to be enabled.
+
+ @return  int
+   - @ref PCH_DMA_SUCCESS --> On success.
+
+ @see
+   - pch_enable_dma
+ */
+int dma_enable_ch(int channel)
+{
+ u32 base_address;
+ u16 transfer_mode;
+ u32 ctl0;
+ u32 ctrl_val = DEFAULT_CONTROL_REGISTER_VALUE;
+ int ch;
+
+ /* Marking the channel as enabled. */
+ pch_dma_channel_info[channel].bChEnabled = 1;
+
+ ch = pch_dma_channel_table[channel].channel;
+ base_address = pch_dma_channel_table[channel].base;
+
+ ctl0 = 0;
+
+ /* Setting of transfer direction. */
+ if (pch_dma_channel_info[channel].DMATransferDirection ==
+     PCH_DMA_DIR_OUT_TO_IN) {
+  ctl0 |= PCH_DMA_DIR_OUT_TO_IN;
+ }
+
+ /* Setting the transfer mode features. */
+ transfer_mode = pch_dma_channel_info[channel].DMATransferMode;
+
+ /* If scatter gather mode. */
+ if (transfer_mode == DMA_SCATTER_GATHER_MODE) {
+  u32 next_desc;
+
+  next_desc = ((u32) pch_dma_channel_info[channel].pHeadOfList);
+  PCH_WRITE_LONG(next_desc, (base_address + (DMA_NX_AD_OFFSET +
+          (ch * 0x10))));
+
+  ctl0 |= DMA_SCATTER_GATHER_MODE;
+ }
+ /* If one shot mode. */
+ else {
+  u32 in_address = pch_dma_channel_info[channel].in_addr;
+  u32 out_address = pch_dma_channel_info[channel].out_addr;
+  u32 access_size = pch_dma_channel_info[channel].DMAAccessSize;
+  u32 count = pch_dma_channel_info[channel].DMATransferSize;
+
+  ctl0 |= DMA_ONE_SHOT_MODE;
+
+  count |= access_size;
+
+  PCH_WRITE_LONG(in_address,
+          (base_address +
+    (DMA_IN_AD_OFFSET + (ch * 0x10))));
+  PCH_WRITE_LONG(out_address,
+          (base_address +
+    (DMA_OUT_AD_OFFSET + (ch * 0x10))));
+  PCH_WRITE_LONG(count,
+          (base_address + (DMA_SZ_OFFSET + (ch * 0x10))));
+ }
+
+ /* Enabling the interrupts. */
+ (void)dma_enable_disable_interrupt(channel, PCH_DMA_INTERRUPT_ENABLE);
+
+ /* Updating Control register. */
+ if (ch < 8) {
+  /* Clearing the three bits corresponding
+     to the mode and transfer direction of
+     specific channel.
+   */
+  ctrl_val &= ~((MSK_ALL_THREE) << (ch * DMA_SHIFT_MODE_BITS));
+
+  /* Setting the transfer mode and direction. */
+  ctrl_val |= (ctl0 << (ch * DMA_SHIFT_MODE_BITS));
+
+  /* Updating to the register. */
+  PCH_WRITE_LONG(ctrl_val, (base_address + DMA_CTL0_OFFSET));
+
+  PCH_DEBUG("dma_enable -> Control register(0) value: "
+     "%x.\n",
+     PCH_READ_LONG((base_address + DMA_CTL0_OFFSET)));
+ } else {
+  /* Clearing the three bits corresponding
+     to the mode and transfer direction of
+     specific channel.
+   */
+  ctrl_val &=
+      ~((MSK_ALL_THREE) << ((ch - 8) * DMA_SHIFT_MODE_BITS));
+
+  /* Setting the transfer mode and direction. */
+  ctrl_val |= (ctl0 << ((ch - 8) * DMA_SHIFT_MODE_BITS));
+
+  /* Updating to the register. */
+  PCH_WRITE_LONG(ctrl_val, (base_address + DMA_CTL3_OFFSET));
+
+  PCH_DEBUG("dma_enable -> Control register(3) value: "
+     "%x.\n",
+     PCH_READ_LONG((base_address + DMA_CTL3_OFFSET)));
+ }
+
+ PCH_DEBUG("Function dma_enable_ch returns %d.\n", PCH_DMA_SUCCESS);
+ return PCH_DMA_SUCCESS;
+}
+
+/*! @ingroup HALLayerAPI
+ @fn   int dma_disable_ch(int channel)
+ @brief  Disables the DMA channel specified.
+ @remarks This function performs the necessary
+    register updation in-order to disable
+    the DMA channel.
+
+ @param  channel [@ref IN] Channel to be disabled.
+
+ @return  int
+   - @ref PCH_DMA_SUCCESS
+
+ @see
+   - pch_disable_dma
+ */
+int dma_disable_ch(int channel)
+{
+ u32 base_address;
+ u16 ch;
+
+ ch = pch_dma_channel_table[channel].channel;
+ base_address = pch_dma_channel_table[channel].base;
+
+ if (channel < 8) {
+  /* Clearing the mode bits of the channel */
+  PCH_DMA_BIT_CLEAR((base_address + DMA_CTL0_OFFSET),
+      (DMA_MASK_MODE_BITS <<
+       (ch * DMA_SHIFT_MODE_BITS)));
+ } else {
+  /* Clearing the mode bits of the channel */
+  PCH_DMA_BIT_CLEAR((base_address + DMA_CTL3_OFFSET),
+      (DMA_MASK_MODE_BITS <<
+       ((ch - 8) * DMA_SHIFT_MODE_BITS)));
+ }
+
+ /* Updating the enable variable. */
+ pch_dma_channel_info[channel].bChEnabled = (u16) 0;
+
+ PCH_DEBUG("Function dma_disable_ch returns " "%d.\n", PCH_DMA_SUCCESS);
+ return PCH_DMA_SUCCESS;
+}
+
+/*! @ingroup HALLayerAPI
+ @fn   int dma_set_count (int channel, u32 count)
+ @brief  Sets the count value .
+ @remarks Updates the transfer size for ONE_SHOT_MODE
+    of DMA Transfer. The main tasks performed by
+    this function are:
+    - Set the DMATransferSize field of the
+    @ref pch_dma_channel_info structure to the
+    value of the argument count.
+
+ @param  channel  [@ref IN] Channel number for
+     which value is to be set
+ @param  count  [@ref IN] Transfer Size value.
+
+ @return  int
+   - @ref PCH_DMA_SUCCESS
+
+ @see
+   - pch_set_dma_count
+ */
+int dma_set_count(int channel, u32 count)
+{
+ pch_dma_channel_info[channel].DMATransferSize = count;
+
+ PCH_DEBUG("Function dma_set_count returns %d.\n", PCH_DMA_SUCCESS);
+ return PCH_DMA_SUCCESS;
+}
+
+/*! @ingroup HALLayerAPI
+ @fn  int dma_add_desc(int channel,
+    struct pch_dma_desc *start,
+    struct pch_dma_desc *end)
+ @brief  Adds descriptors to the existing list of descriptors.
+ @remarks This function accepts the descriptor list and appends
+    it to the existing list of descriptors. The main
+    tasks performed by this function are:
+    - Obtains the virtual address of the end of the
+    currently set descriptor list. If it is not
+    successful returns with an error.
+    - Appends the value of the argument start to the
+    nextDesc field of the descriptor pointed by the
+    pTailOfList field of the
+    @ref pch_dma_channel_info structure with the
+    value of the argument start after appropriately
+    setting the last two bits to denote
+    Follow_Next_Descriptor_Without_Interrupt.
+    - Updates the value of the argument end to the
+    pTailOfList field of the @ref
+    pch_dma_channel_info structure for the
+    corresponding channel.
+
+ @param  channel  [@ref IN] Channel number.
+ @param  start  [@ref IN] Reference to first
+      descriptor of list.
+ @param  end  [@ref IN] Reference to last
+      descriptor of list.
+
+ @return  int
+   - @ref PCH_DMA_SUCCESS --> If appending of the
+   descriptor is successful.
+
+ @see
+  - pch_add_dma_desc
+*/
+int dma_add_desc(int channel, struct pch_dma_desc *start,
+   struct pch_dma_desc *end)
+{
+ struct pch_dma_desc *desc_addr;
+
+ desc_addr = pch_dma_channel_info[channel].pTailOfList;
+
+ /* Obtaining the virtual address. */
+ desc_addr = (struct pch_dma_desc *) phys_to_virt((u32) desc_addr);
+
+ /* If virtual address calculation successful. */
+ desc_addr->nextDesc = (u32) start;
+ pch_dma_channel_info[channel].pTailOfList = end;
+
+ PCH_DEBUG("Function dma_add_desc returns %d.\n", PCH_DMA_SUCCESS);
+ return PCH_DMA_SUCCESS;
+}
+
+/*! @ingroup HALLayerAPI
+ @fn void  dma_set_callback (int channel,  void (*pch_dma_cbr)
+   ( int value,unsigned long data1),unsigned long data)
+ @brief  To set callback function.
+ @remarks Sets the callback function to be called for a channel.
+    The main task performed by this function is:
+    - Updates the callback pointer for the channel
+    in the structure pch_dma_channel_info with the
+    parameter passed.
+
+ @param  channel  [@ref IN] Channel number.
+ @param  pch_dma_cbr [@ref IN] Function pointer
+      to call back function.
+ @param  data  [@ref IN] The data to be passed to
+      the callback function during
+      invoking.
+
+ @return None.
+
+ @see
+  - pch_dma_set_callback
+  */
+void dma_set_callback(int channel,
+        void (*pch_dma_cbr) (int value, unsigned long data1),
+        unsigned long data)
+{
+ pch_dma_channel_info[channel].call_back_func_ptr = pch_dma_cbr;
+ pch_dma_channel_info[channel].callback_data = data;
+
+ PCH_DEBUG("Function dma_set_callback invoked successfully.\n");
+}
+
+/*! @ingroup HALLayerAPI
+ @fn  irqreturn_t dma_interrupt (int irq, void *dev_id)
+ @brief  Interrupt handler.
+ @remarks Handles the interrupt for the DMA. The main tasks
+    performed by this function are:
+    - Checks each DMA channels whether a DMA
+    transmission end or DMA status interrupt has
+    occurred.
+    - If a transmission end interrupt has occurred,
+    then invoke the callback function with @ref
+    PCH_DMA_END, denoting that the DMA transmission
+    has end.
+    - If a DMA abort interrupt has occurred, then
+    invoke the callback function with @ref
+    PCH_DMA_ABORT, denoting that a DMA abort has
+    occurred.
+
+ @param  irq  [@ref IN] Interrupt Request number
+ @param  dev_id [@ref IN] dev_id of device for which
+     interrupt is raised .
+
+ @return  irqreturn_t
+   - IRQ_HANDLED --> If interrupt has been processed.
+   - IRQ_NONE --> If no interrupt has been processed.
+
+ */
+irqreturn_t dma_interrupt(int irq, void *dev_id)
+{
+ irqreturn_t retval = IRQ_NONE;
+ u32 status_reg0;
+ u32 status_reg2;
+ u32 base_address;
+ u32 dev_type;
+ u32 i;
+ u16 status;
+
+ base_address = ((struct pch_dma_devices *) dev_id)->base_addr;
+ dev_type = ((struct pch_dma_devices *) dev_id)->dev_typ;
+
+ /* Reading the status registers. */
+ status_reg0 = PCH_READ_LONG((base_address + DMA_STS0_OFFSET));
+ status_reg2 = PCH_READ_LONG((base_address + DMA_STS2_OFFSET));
+ PCH_DEBUG("dma_interrupt -> Status register STS0: %x STS2: "
+    "%x.\n", status_reg0, status_reg2);
+
+ /* Clearing the interrupts. */
+ dma_clear_interrupt_status(base_address, status_reg0, status_reg2);
+
+ /* Handling the interrupts. */
+ for (i = 0; i < PCH_DMA_CHANNELS_MAX; i++) {
+  if ((pch_dma_channel_table[i].dma_dev_id == dev_type) &&
+      (pch_dma_channel_table[i].ch_alloced == 1) &&
+      (pch_dma_channel_info[i].bChEnabled == 1)
+      ) {
+   status =
+       dma_get_interrupt_status(pch_dma_channel_table
+           [i].channel, status_reg0,
+           status_reg2);
+   PCH_DEBUG
+       ("dma_interrupt -> Interrupt status for ch: %d is "
+       "%x.\n", i, status);
+
+   if (status == 1) {
+    int value = PCH_DMA_END;
+
+    status =
+        dma_get_abort_status(pch_dma_channel_table
+        [i].channel,
+        status_reg0,
+        status_reg2);
+
+    if (status == 1) {
+     value = PCH_DMA_ABORT;
+
+     PCH_DEBUG
+         ("dma_interrupt -> DMA Abort "
+         "interrupt from channel%d.\n", i);
+    }
+#ifdef DEBUG
+    else {
+     PCH_DEBUG
+         ("dma_interrupt -> DMA Completion "
+         "interrupt "
+          "from channel%d.\n", i);
+    }
+#endif
+    if (pch_dma_channel_info[i].
+        call_back_func_ptr) {
+     u32 data =
+         pch_dma_channel_info
+         [i].callback_data;
+     (pch_dma_channel_info
+      [i].call_back_func_ptr) (value, data);
+    }
+
+    /* Determining whether the channel has been
+    disabled. */
+    {
+     u32 ctrl_val;
+     s32 ch =
+         pch_dma_channel_table[i].channel;
+     u32 base_address =
+         pch_dma_channel_table[i].base;
+
+     if (ch < 8) {
+      ctrl_val =
+          PCH_READ_LONG((base_address
+           + DMA_CTL0_OFFSET));
+
+      ctrl_val &=
+          ((0x3) <<
+          (ch * DMA_SHIFT_MODE_BITS));
+     } else {
+      ctrl_val =
+          PCH_READ_LONG((base_address
+           + DMA_CTL3_OFFSET));
+      ctrl_val &=
+          ((0x3) <<
+           ((ch - 8) *
+            DMA_SHIFT_MODE_BITS));
+     }
+
+     pch_dma_channel_info[i].bChEnabled =
+         (ctrl_val != 0) ? 1 : 0;
+
+    } /* End */
+
+    retval = IRQ_HANDLED;
+   }
+  }
+ }
+
+ PCH_DEBUG("Function dma_interrupt returns %d.\n", retval);
+ return retval;
+}
+
+/*! @ingroup HALLayerAPI
+ @fn  int dma_direct_start (int channel)
+ @brief  To generate the DMA request which each Function-IP
+    transmits.
+ @remarks This function is used to initiate the DMA
+    transfer process. The main task performed by
+    this function is:
+    - Sets the value of DMAn Direct Start bit in the
+    Control register 2 to start DMA transfer on
+    channel n.
+
+ @param  channel [@ref IN] Channel number for which DMA
+      transfer is to be started.
+
+ @return  int
+   - @ref PCH_DMA_SUCCESS --> On Success.
+
+ @see
+   - pch_dma_direct_start
+ */
+int dma_direct_start(int channel)
+{
+ int ch;
+ u32 base_address;
+
+ ch = pch_dma_channel_table[channel].channel;
+ base_address = pch_dma_channel_table[channel].base;
+
+ if (ch < 8) {
+  PCH_DMA_BIT_SET((base_address + DMA_CTL2_OFFSET),
+    (DMA_DIR_START << ch));
+ } else {
+  PCH_DMA_BIT_SET((base_address + DMA_CTL2_OFFSET),
+    (DMA_DIR_START << (ch + 6)));
+ }
+
+ PCH_DEBUG("dma_direct_start -> Direct2 RegValue: "
+    "%x.\n", PCH_READ_LONG((base_address + DMA_CTL2_OFFSET)));
+
+ PCH_DEBUG("Function dma_direct_start returns "
+    "%d.\n", PCH_DMA_SUCCESS);
+ return PCH_DMA_SUCCESS;
+}
+
+/*! @ingroup HALLayerAPI
+ @fn   int dma_set_priority (int channel, int priority)
+ @brief  Set the priority.
+ @remarks Sets the priority for a channel. The main task
+    performed by this function is:
+    - Set the value of DMAn Priority Level bits for
+    the channel in the Control register1.
+
+ @param  channel [@ref IN] DMA channel number.
+ @param  priority [@ref IN] Priority to be set for
+       the DMA channel.
+
+ @return  int
+   - @ref PCH_DMA_SUCCESS --> On Success.
+
+ @see
+   - pch_set_dma_priority
+  */
+int dma_set_priority(int channel, int priority)
+{
+ int ch;
+ u32 base_address;
+ u32 reg_val;
+
+ ch = pch_dma_channel_table[channel].channel;
+ base_address = pch_dma_channel_table[channel].base;
+
+ reg_val = PCH_READ_LONG((base_address + DMA_CTL1_OFFSET));
+
+ if (ch < 8) {
+  reg_val &=
+      ~(DMA_MASK_PRIORITY_BITS << (ch * DMA_SHIFT_PRIORITY_BITS));
+  reg_val |= (((u32) priority) << (ch * DMA_SHIFT_PRIORITY_BITS));
+ } else {
+  reg_val &=
+      ~(DMA_MASK_PRIORITY_BITS <<
+        (((ch - 8) * DMA_SHIFT_PRIORITY_BITS) + 2));
+  reg_val |=
+      (((u32) priority) <<
+       (((ch - 8) * DMA_SHIFT_PRIORITY_BITS) + 2));
+ }
+
+ PCH_WRITE_LONG(reg_val, (base_address + DMA_CTL1_OFFSET));
+
+ PCH_DEBUG("Function dma_set_priority returns "
+    "%d.\n", PCH_DMA_SUCCESS);
+ return PCH_DMA_SUCCESS;
+}
+
+/*! @ingroup HALLayerAPI
+ @fn int dma_enable_disable_interrupt (int channel, int bEnable)
+ @brief  Enables or Disables Interrupts .
+ @remarks Writes the corresponding register to either
+    enable or disable interrupts. The main tasks
+    performed by this function are:
+    - If bEnable is DMA_INTERRUPT_ENABLE (1),
+    sets the DMAn Interrupt Enable bit in control
+    register2.
+    - If bEnable is DMA_INTERRUPT_DISABLE (0),
+    clears the DMAn Interrupt Enable bit in control
+    register2.
+
+ @param channel [@ref IN] Channel number
+ @param bEnable [@ref IN] Flag to indicate whether
+      to enable or disable interrupt.
+
+ @return  int
+   - @ref PCH_DMA_SUCCESS --> On Success.
+
+ @see
+  - dma_init
+  - dma_exit
+  */
+int dma_enable_disable_interrupt(int channel, int bEnable)
+{
+ u32 base_address;
+ u16 ch;
+
+ ch = pch_dma_channel_table[channel].channel;
+ base_address = pch_dma_channel_table[channel].base;
+
+ if (ch < 8) {
+  if (PCH_DMA_INTERRUPT_ENABLE == bEnable) {
+   PCH_DMA_BIT_SET((base_address + DMA_CTL2_OFFSET),
+     (DMA_INTERRUPT_BIT << ch));
+  } else { /* if(bEnable == PCH_DMA_INTERRUPT_DISABLE) */
+
+   PCH_DMA_BIT_CLEAR((base_address + DMA_CTL2_OFFSET),
+       (DMA_INTERRUPT_BIT << ch));
+  }
+
+ } else {
+  if (PCH_DMA_INTERRUPT_ENABLE == bEnable) {
+   PCH_DMA_BIT_SET((base_address + DMA_CTL2_OFFSET),
+     (DMA_INTERRUPT_BIT << (ch + 8)));
+  } else { /* if(bEnable == PCH_DMA_INTERRUPT_DISABLE) */
+
+   PCH_DMA_BIT_CLEAR((base_address + DMA_CTL2_OFFSET),
+       (DMA_INTERRUPT_BIT << (ch + 8)));
+  }
+ }
+
+ PCH_DEBUG("dma_enable_disable_interrupt -> CTL2 Register Value: "
+    "%x.\n", PCH_READ_LONG((base_address + DMA_CTL2_OFFSET)));
+
+ PCH_DEBUG("Function dma_enable_disable_interrupt returns "
+    "%d.\n", PCH_DMA_SUCCESS);
+ return PCH_DMA_SUCCESS;
+}
+
+/*! @ingroup HALLayerAPI
+ @fn  void get_dma_status(int channel, u16 *pDMAStatus)
+ @brief  Gets the Status of DMA.
+ @remarks Gets the status of the specified DMA Channel. The
+    main task performed by this function is:
+    - Reads the data in the DMAn (for channel .n.)
+    Status bit of Status register0 (4ch or 8ch) or
+    Status register2 (12ch) and copy the value into
+    pDMAStatus.
+
+ @param  channel  [@ref IN]  Channel number.
+ @param  pDMAStatus [@ref INOUT] Address of variable to
+      which
+      status information is copied.
+
+ @return None.
+
+ @see
+  - dma_exit
+  - dma_init
+  - pch_set_dma_mode
+  - pch_set_dma_addr
+  - pch_set_dma_count
+  - pch_set_dma_desc
+  - pch_add_dma_desc

