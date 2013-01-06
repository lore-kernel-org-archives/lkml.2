Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab3AFWoM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 17:44:12 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:44039 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753265Ab3AFWoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 17:44:10 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6/8] dma: coh901318: push definitions into driver
Date: Sun, 6 Jan 2013 23:43:52 +0100
Message-ID: <1357512232-5778-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Move everything in the header file that is not used in both
the main driver and the LLI portions into the driver, including
register definitions and such.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/coh901318.c     | 208 +++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/coh901318.h     | 212 --------------------------------------------
 drivers/dma/coh901318_lli.c |   1 +
 3 files changed, 209 insertions(+), 212 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 1be69b8..f7100dc 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -27,6 +27,214 @@
 #include "coh901318_lli.h"
 #include "dmaengine.h"
 
+#define COH901318_MOD32_MASK					(0x1F)
+#define COH901318_WORD_MASK					(0xFFFFFFFF)
+/* INT_STATUS - Interrupt Status Registers 32bit (R/-) */
+#define COH901318_INT_STATUS1					(0x0000)
+#define COH901318_INT_STATUS2					(0x0004)
+/* TC_INT_STATUS - Terminal Count Interrupt Status Registers 32bit (R/-) */
+#define COH901318_TC_INT_STATUS1				(0x0008)
+#define COH901318_TC_INT_STATUS2				(0x000C)
+/* TC_INT_CLEAR - Terminal Count Interrupt Clear Registers 32bit (-/W) */
+#define COH901318_TC_INT_CLEAR1					(0x0010)
+#define COH901318_TC_INT_CLEAR2					(0x0014)
+/* RAW_TC_INT_STATUS - Raw Term Count Interrupt Status Registers 32bit (R/-) */
+#define COH901318_RAW_TC_INT_STATUS1				(0x0018)
+#define COH901318_RAW_TC_INT_STATUS2				(0x001C)
+/* BE_INT_STATUS - Bus Error Interrupt Status Registers 32bit (R/-) */
+#define COH901318_BE_INT_STATUS1				(0x0020)
+#define COH901318_BE_INT_STATUS2				(0x0024)
+/* BE_INT_CLEAR - Bus Error Interrupt Clear Registers 32bit (-/W) */
+#define COH901318_BE_INT_CLEAR1					(0x0028)
+#define COH901318_BE_INT_CLEAR2					(0x002C)
+/* RAW_BE_INT_STATUS - Raw Term Count Interrupt Status Registers 32bit (R/-) */
+#define COH901318_RAW_BE_INT_STATUS1				(0x0030)
+#define COH901318_RAW_BE_INT_STATUS2				(0x0034)
+
+/*
+ * CX_CFG - Channel Configuration Registers 32bit (R/W)
+ */
+#define COH901318_CX_CFG					(0x0100)
+#define COH901318_CX_CFG_SPACING				(0x04)
+/* Channel enable activates tha dma job */
+#define COH901318_CX_CFG_CH_ENABLE				(0x00000001)
+#define COH901318_CX_CFG_CH_DISABLE				(0x00000000)
+/* Request Mode */
+#define COH901318_CX_CFG_RM_MASK				(0x00000006)
+#define COH901318_CX_CFG_RM_MEMORY_TO_MEMORY			(0x0 << 1)
+#define COH901318_CX_CFG_RM_PRIMARY_TO_MEMORY			(0x1 << 1)
+#define COH901318_CX_CFG_RM_MEMORY_TO_PRIMARY			(0x1 << 1)
+#define COH901318_CX_CFG_RM_PRIMARY_TO_SECONDARY		(0x3 << 1)
+#define COH901318_CX_CFG_RM_SECONDARY_TO_PRIMARY		(0x3 << 1)
+/* Linked channel request field. RM must == 11 */
+#define COH901318_CX_CFG_LCRF_SHIFT				3
+#define COH901318_CX_CFG_LCRF_MASK				(0x000001F8)
+#define COH901318_CX_CFG_LCR_DISABLE				(0x00000000)
+/* Terminal Counter Interrupt Request Mask */
+#define COH901318_CX_CFG_TC_IRQ_ENABLE				(0x00000200)
+#define COH901318_CX_CFG_TC_IRQ_DISABLE				(0x00000000)
+/* Bus Error interrupt Mask */
+#define COH901318_CX_CFG_BE_IRQ_ENABLE				(0x00000400)
+#define COH901318_CX_CFG_BE_IRQ_DISABLE				(0x00000000)
+
+/*
+ * CX_STAT - Channel Status Registers 32bit (R/-)
+ */
+#define COH901318_CX_STAT					(0x0200)
+#define COH901318_CX_STAT_SPACING				(0x04)
+#define COH901318_CX_STAT_RBE_IRQ_IND				(0x00000008)
+#define COH901318_CX_STAT_RTC_IRQ_IND				(0x00000004)
+#define COH901318_CX_STAT_ACTIVE				(0x00000002)
+#define COH901318_CX_STAT_ENABLED				(0x00000001)
+
+/*
+ * CX_CTRL - Channel Control Registers 32bit (R/W)
+ */
+#define COH901318_CX_CTRL					(0x0400)
+#define COH901318_CX_CTRL_SPACING				(0x10)
+/* Transfer Count Enable */
+#define COH901318_CX_CTRL_TC_ENABLE				(0x00001000)
+#define COH901318_CX_CTRL_TC_DISABLE				(0x00000000)
+/* Transfer Count Value 0 - 4095 */
+#define COH901318_CX_CTRL_TC_VALUE_MASK				(0x00000FFF)
+/* Burst count */
+#define COH901318_CX_CTRL_BURST_COUNT_MASK			(0x0000E000)
+#define COH901318_CX_CTRL_BURST_COUNT_64_BYTES			(0x7 << 13)
+#define COH901318_CX_CTRL_BURST_COUNT_48_BYTES			(0x6 << 13)
+#define COH901318_CX_CTRL_BURST_COUNT_32_BYTES			(0x5 << 13)
+#define COH901318_CX_CTRL_BURST_COUNT_16_BYTES			(0x4 << 13)
+#define COH901318_CX_CTRL_BURST_COUNT_8_BYTES			(0x3 << 13)
+#define COH901318_CX_CTRL_BURST_COUNT_4_BYTES			(0x2 << 13)
+#define COH901318_CX_CTRL_BURST_COUNT_2_BYTES			(0x1 << 13)
+#define COH901318_CX_CTRL_BURST_COUNT_1_BYTE			(0x0 << 13)
+/* Source bus size  */
+#define COH901318_CX_CTRL_SRC_BUS_SIZE_MASK			(0x00030000)
+#define COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS			(0x2 << 16)
+#define COH901318_CX_CTRL_SRC_BUS_SIZE_16_BITS			(0x1 << 16)
+#define COH901318_CX_CTRL_SRC_BUS_SIZE_8_BITS			(0x0 << 16)
+/* Source address increment */
+#define COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE			(0x00040000)
+#define COH901318_CX_CTRL_SRC_ADDR_INC_DISABLE			(0x00000000)
+/* Destination Bus Size */
+#define COH901318_CX_CTRL_DST_BUS_SIZE_MASK			(0x00180000)
+#define COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS			(0x2 << 19)
+#define COH901318_CX_CTRL_DST_BUS_SIZE_16_BITS			(0x1 << 19)
+#define COH901318_CX_CTRL_DST_BUS_SIZE_8_BITS			(0x0 << 19)
+/* Destination address increment */
+#define COH901318_CX_CTRL_DST_ADDR_INC_ENABLE			(0x00200000)
+#define COH901318_CX_CTRL_DST_ADDR_INC_DISABLE			(0x00000000)
+/* Master Mode (Master2 is only connected to MSL) */
+#define COH901318_CX_CTRL_MASTER_MODE_MASK			(0x00C00000)
+#define COH901318_CX_CTRL_MASTER_MODE_M2R_M1W			(0x3 << 22)
+#define COH901318_CX_CTRL_MASTER_MODE_M1R_M2W			(0x2 << 22)
+#define COH901318_CX_CTRL_MASTER_MODE_M2RW			(0x1 << 22)
+#define COH901318_CX_CTRL_MASTER_MODE_M1RW			(0x0 << 22)
+/* Terminal Count flag to PER enable */
+#define COH901318_CX_CTRL_TCP_ENABLE				(0x01000000)
+#define COH901318_CX_CTRL_TCP_DISABLE				(0x00000000)
+/* Terminal Count flags to CPU enable */
+#define COH901318_CX_CTRL_TC_IRQ_ENABLE				(0x02000000)
+#define COH901318_CX_CTRL_TC_IRQ_DISABLE			(0x00000000)
+/* Hand shake to peripheral */
+#define COH901318_CX_CTRL_HSP_ENABLE				(0x04000000)
+#define COH901318_CX_CTRL_HSP_DISABLE				(0x00000000)
+#define COH901318_CX_CTRL_HSS_ENABLE				(0x08000000)
+#define COH901318_CX_CTRL_HSS_DISABLE				(0x00000000)
+/* DMA mode */
+#define COH901318_CX_CTRL_DDMA_MASK				(0x30000000)
+#define COH901318_CX_CTRL_DDMA_LEGACY				(0x0 << 28)
+#define COH901318_CX_CTRL_DDMA_DEMAND_DMA1			(0x1 << 28)
+#define COH901318_CX_CTRL_DDMA_DEMAND_DMA2			(0x2 << 28)
+/* Primary Request Data Destination */
+#define COH901318_CX_CTRL_PRDD_MASK				(0x40000000)
+#define COH901318_CX_CTRL_PRDD_DEST				(0x1 << 30)
+#define COH901318_CX_CTRL_PRDD_SOURCE				(0x0 << 30)
+
+/*
+ * CX_SRC_ADDR - Channel Source Address Registers 32bit (R/W)
+ */
+#define COH901318_CX_SRC_ADDR					(0x0404)
+#define COH901318_CX_SRC_ADDR_SPACING				(0x10)
+
+/*
+ * CX_DST_ADDR - Channel Destination Address Registers 32bit R/W
+ */
+#define COH901318_CX_DST_ADDR					(0x0408)
+#define COH901318_CX_DST_ADDR_SPACING				(0x10)
+
+/*
+ * CX_LNK_ADDR - Channel Link Address Registers 32bit (R/W)
+ */
+#define COH901318_CX_LNK_ADDR					(0x040C)
+#define COH901318_CX_LNK_ADDR_SPACING				(0x10)
+#define COH901318_CX_LNK_LINK_IMMEDIATE				(0x00000001)
+
+/**
+ * struct coh901318_params - parameters for DMAC configuration
+ * @config: DMA config register
+ * @ctrl_lli_last: DMA control register for the last lli in the list
+ * @ctrl_lli: DMA control register for an lli
+ * @ctrl_lli_chained: DMA control register for a chained lli
+ */
+struct coh901318_params {
+	u32 config;
+	u32 ctrl_lli_last;
+	u32 ctrl_lli;
+	u32 ctrl_lli_chained;
+};
+
+/**
+ * struct coh_dma_channel - dma channel base
+ * @name: ascii name of dma channel
+ * @number: channel id number
+ * @desc_nbr_max: number of preallocated descriptors
+ * @priority_high: prio of channel, 0 low otherwise high.
+ * @param: configuration parameters
+ */
+struct coh_dma_channel {
+	const char name[32];
+	const int number;
+	const int desc_nbr_max;
+	const int priority_high;
+	const struct coh901318_params param;
+};
+
+/**
+ * dma_access_memory_state_t - register dma for memory access
+ *
+ * @dev: The dma device
+ * @active:  1 means dma intends to access memory
+ *           0 means dma wont access memory
+ */
+typedef void (*dma_access_memory_state_t)(struct device *dev,
+					  bool active);
+
+/**
+ * struct powersave - DMA power save structure
+ * @lock: lock protecting data in this struct
+ * @started_channels: bit mask indicating active dma channels
+ */
+struct powersave {
+	spinlock_t lock;
+	u64 started_channels;
+};
+
+/**
+ * struct coh901318_platform - platform arch structure
+ * @chans_slave: specifying dma slave channels
+ * @chans_memcpy: specifying dma memcpy channels
+ * @access_memory_state: requesting DMA memory access (on / off)
+ * @chan_conf: dma channel configurations
+ * @max_channels: max number of dma chanenls
+ */
+struct coh901318_platform {
+	const int *chans_slave;
+	const int *chans_memcpy;
+	const dma_access_memory_state_t access_memory_state;
+	const struct coh_dma_channel *chan_conf;
+	const int max_channels;
+};
+
 /* points out all dma slave channels.
  * Syntax is [A1, B1, A2, B2, .... ,-1,-1]
  * Select all channels from A to B, end of list is marked with -1,-1
diff --git a/drivers/dma/coh901318.h b/drivers/dma/coh901318.h
index 9353c40..275a36e 100644
--- a/drivers/dma/coh901318.h
+++ b/drivers/dma/coh901318.h
@@ -8,9 +8,6 @@
 #ifndef COH901318_H
 #define COH901318_H
 
-#include <linux/device.h>
-#include <linux/dmaengine.h>
-
 #define MAX_DMA_PACKET_SIZE_SHIFT 11
 #define MAX_DMA_PACKET_SIZE (1 << MAX_DMA_PACKET_SIZE_SHIFT)
 
@@ -32,214 +29,5 @@ struct coh901318_lli {
 	void *virt_link_addr;
 	dma_addr_t phy_this;
 };
-/**
- * struct coh901318_params - parameters for DMAC configuration
- * @config: DMA config register
- * @ctrl_lli_last: DMA control register for the last lli in the list
- * @ctrl_lli: DMA control register for an lli
- * @ctrl_lli_chained: DMA control register for a chained lli
- */
-struct coh901318_params {
-	u32 config;
-	u32 ctrl_lli_last;
-	u32 ctrl_lli;
-	u32 ctrl_lli_chained;
-};
-/**
- * struct coh_dma_channel - dma channel base
- * @name: ascii name of dma channel
- * @number: channel id number
- * @desc_nbr_max: number of preallocated descriptors
- * @priority_high: prio of channel, 0 low otherwise high.
- * @param: configuration parameters
- */
-struct coh_dma_channel {
-	const char name[32];
-	const int number;
-	const int desc_nbr_max;
-	const int priority_high;
-	const struct coh901318_params param;
-};
-
-/**
- * dma_access_memory_state_t - register dma for memory access
- *
- * @dev: The dma device
- * @active:  1 means dma intends to access memory
- *           0 means dma wont access memory
- */
-typedef void (*dma_access_memory_state_t)(struct device *dev,
-					  bool active);
-
-/**
- * struct powersave - DMA power save structure
- * @lock: lock protecting data in this struct
- * @started_channels: bit mask indicating active dma channels
- */
-struct powersave {
-	spinlock_t lock;
-	u64 started_channels;
-};
-/**
- * struct coh901318_platform - platform arch structure
- * @chans_slave: specifying dma slave channels
- * @chans_memcpy: specifying dma memcpy channels
- * @access_memory_state: requesting DMA memory access (on / off)
- * @chan_conf: dma channel configurations
- * @max_channels: max number of dma chanenls
- */
-struct coh901318_platform {
-	const int *chans_slave;
-	const int *chans_memcpy;
-	const dma_access_memory_state_t access_memory_state;
-	const struct coh_dma_channel *chan_conf;
-	const int max_channels;
-};
-
-/*
- * DMA Controller - this access the static mappings of the coh901318 dma.
- *
- */
-
-#define COH901318_MOD32_MASK					(0x1F)
-#define COH901318_WORD_MASK					(0xFFFFFFFF)
-/* INT_STATUS - Interrupt Status Registers 32bit (R/-) */
-#define COH901318_INT_STATUS1					(0x0000)
-#define COH901318_INT_STATUS2					(0x0004)
-/* TC_INT_STATUS - Terminal Count Interrupt Status Registers 32bit (R/-) */
-#define COH901318_TC_INT_STATUS1				(0x0008)
-#define COH901318_TC_INT_STATUS2				(0x000C)
-/* TC_INT_CLEAR - Terminal Count Interrupt Clear Registers 32bit (-/W) */
-#define COH901318_TC_INT_CLEAR1					(0x0010)
-#define COH901318_TC_INT_CLEAR2					(0x0014)
-/* RAW_TC_INT_STATUS - Raw Term Count Interrupt Status Registers 32bit (R/-) */
-#define COH901318_RAW_TC_INT_STATUS1				(0x0018)
-#define COH901318_RAW_TC_INT_STATUS2				(0x001C)
-/* BE_INT_STATUS - Bus Error Interrupt Status Registers 32bit (R/-) */
-#define COH901318_BE_INT_STATUS1				(0x0020)
-#define COH901318_BE_INT_STATUS2				(0x0024)
-/* BE_INT_CLEAR - Bus Error Interrupt Clear Registers 32bit (-/W) */
-#define COH901318_BE_INT_CLEAR1					(0x0028)
-#define COH901318_BE_INT_CLEAR2					(0x002C)
-/* RAW_BE_INT_STATUS - Raw Term Count Interrupt Status Registers 32bit (R/-) */
-#define COH901318_RAW_BE_INT_STATUS1				(0x0030)
-#define COH901318_RAW_BE_INT_STATUS2				(0x0034)
-
-/*
- * CX_CFG - Channel Configuration Registers 32bit (R/W)
- */
-#define COH901318_CX_CFG					(0x0100)
-#define COH901318_CX_CFG_SPACING				(0x04)
-/* Channel enable activates tha dma job */
-#define COH901318_CX_CFG_CH_ENABLE				(0x00000001)
-#define COH901318_CX_CFG_CH_DISABLE				(0x00000000)
-/* Request Mode */
-#define COH901318_CX_CFG_RM_MASK				(0x00000006)
-#define COH901318_CX_CFG_RM_MEMORY_TO_MEMORY			(0x0 << 1)
-#define COH901318_CX_CFG_RM_PRIMARY_TO_MEMORY			(0x1 << 1)
-#define COH901318_CX_CFG_RM_MEMORY_TO_PRIMARY			(0x1 << 1)
-#define COH901318_CX_CFG_RM_PRIMARY_TO_SECONDARY		(0x3 << 1)
-#define COH901318_CX_CFG_RM_SECONDARY_TO_PRIMARY		(0x3 << 1)
-/* Linked channel request field. RM must == 11 */
-#define COH901318_CX_CFG_LCRF_SHIFT				3
-#define COH901318_CX_CFG_LCRF_MASK				(0x000001F8)
-#define COH901318_CX_CFG_LCR_DISABLE				(0x00000000)
-/* Terminal Counter Interrupt Request Mask */
-#define COH901318_CX_CFG_TC_IRQ_ENABLE				(0x00000200)
-#define COH901318_CX_CFG_TC_IRQ_DISABLE				(0x00000000)
-/* Bus Error interrupt Mask */
-#define COH901318_CX_CFG_BE_IRQ_ENABLE				(0x00000400)
-#define COH901318_CX_CFG_BE_IRQ_DISABLE				(0x00000000)
 
-/*
- * CX_STAT - Channel Status Registers 32bit (R/-)
- */
-#define COH901318_CX_STAT					(0x0200)
-#define COH901318_CX_STAT_SPACING				(0x04)
-#define COH901318_CX_STAT_RBE_IRQ_IND				(0x00000008)
-#define COH901318_CX_STAT_RTC_IRQ_IND				(0x00000004)
-#define COH901318_CX_STAT_ACTIVE				(0x00000002)
-#define COH901318_CX_STAT_ENABLED				(0x00000001)
-
-/*
- * CX_CTRL - Channel Control Registers 32bit (R/W)
- */
-#define COH901318_CX_CTRL					(0x0400)
-#define COH901318_CX_CTRL_SPACING				(0x10)
-/* Transfer Count Enable */
-#define COH901318_CX_CTRL_TC_ENABLE				(0x00001000)
-#define COH901318_CX_CTRL_TC_DISABLE				(0x00000000)
-/* Transfer Count Value 0 - 4095 */
-#define COH901318_CX_CTRL_TC_VALUE_MASK				(0x00000FFF)
-/* Burst count */
-#define COH901318_CX_CTRL_BURST_COUNT_MASK			(0x0000E000)
-#define COH901318_CX_CTRL_BURST_COUNT_64_BYTES			(0x7 << 13)
-#define COH901318_CX_CTRL_BURST_COUNT_48_BYTES			(0x6 << 13)
-#define COH901318_CX_CTRL_BURST_COUNT_32_BYTES			(0x5 << 13)
-#define COH901318_CX_CTRL_BURST_COUNT_16_BYTES			(0x4 << 13)
-#define COH901318_CX_CTRL_BURST_COUNT_8_BYTES			(0x3 << 13)
-#define COH901318_CX_CTRL_BURST_COUNT_4_BYTES			(0x2 << 13)
-#define COH901318_CX_CTRL_BURST_COUNT_2_BYTES			(0x1 << 13)
-#define COH901318_CX_CTRL_BURST_COUNT_1_BYTE			(0x0 << 13)
-/* Source bus size  */
-#define COH901318_CX_CTRL_SRC_BUS_SIZE_MASK			(0x00030000)
-#define COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS			(0x2 << 16)
-#define COH901318_CX_CTRL_SRC_BUS_SIZE_16_BITS			(0x1 << 16)
-#define COH901318_CX_CTRL_SRC_BUS_SIZE_8_BITS			(0x0 << 16)
-/* Source address increment */
-#define COH901318_CX_CTRL_SRC_ADDR_INC_ENABLE			(0x00040000)
-#define COH901318_CX_CTRL_SRC_ADDR_INC_DISABLE			(0x00000000)
-/* Destination Bus Size */
-#define COH901318_CX_CTRL_DST_BUS_SIZE_MASK			(0x00180000)
-#define COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS			(0x2 << 19)
-#define COH901318_CX_CTRL_DST_BUS_SIZE_16_BITS			(0x1 << 19)
-#define COH901318_CX_CTRL_DST_BUS_SIZE_8_BITS			(0x0 << 19)
-/* Destination address increment */
-#define COH901318_CX_CTRL_DST_ADDR_INC_ENABLE			(0x00200000)
-#define COH901318_CX_CTRL_DST_ADDR_INC_DISABLE			(0x00000000)
-/* Master Mode (Master2 is only connected to MSL) */
-#define COH901318_CX_CTRL_MASTER_MODE_MASK			(0x00C00000)
-#define COH901318_CX_CTRL_MASTER_MODE_M2R_M1W			(0x3 << 22)
-#define COH901318_CX_CTRL_MASTER_MODE_M1R_M2W			(0x2 << 22)
-#define COH901318_CX_CTRL_MASTER_MODE_M2RW			(0x1 << 22)
-#define COH901318_CX_CTRL_MASTER_MODE_M1RW			(0x0 << 22)
-/* Terminal Count flag to PER enable */
-#define COH901318_CX_CTRL_TCP_ENABLE				(0x01000000)
-#define COH901318_CX_CTRL_TCP_DISABLE				(0x00000000)
-/* Terminal Count flags to CPU enable */
-#define COH901318_CX_CTRL_TC_IRQ_ENABLE				(0x02000000)
-#define COH901318_CX_CTRL_TC_IRQ_DISABLE			(0x00000000)
-/* Hand shake to peripheral */
-#define COH901318_CX_CTRL_HSP_ENABLE				(0x04000000)
-#define COH901318_CX_CTRL_HSP_DISABLE				(0x00000000)
-#define COH901318_CX_CTRL_HSS_ENABLE				(0x08000000)
-#define COH901318_CX_CTRL_HSS_DISABLE				(0x00000000)
-/* DMA mode */
-#define COH901318_CX_CTRL_DDMA_MASK				(0x30000000)
-#define COH901318_CX_CTRL_DDMA_LEGACY				(0x0 << 28)
-#define COH901318_CX_CTRL_DDMA_DEMAND_DMA1			(0x1 << 28)
-#define COH901318_CX_CTRL_DDMA_DEMAND_DMA2			(0x2 << 28)
-/* Primary Request Data Destination */
-#define COH901318_CX_CTRL_PRDD_MASK				(0x40000000)
-#define COH901318_CX_CTRL_PRDD_DEST				(0x1 << 30)
-#define COH901318_CX_CTRL_PRDD_SOURCE				(0x0 << 30)
-
-/*
- * CX_SRC_ADDR - Channel Source Address Registers 32bit (R/W)
- */
-#define COH901318_CX_SRC_ADDR					(0x0404)
-#define COH901318_CX_SRC_ADDR_SPACING				(0x10)
-
-/*
- * CX_DST_ADDR - Channel Destination Address Registers 32bit R/W
- */
-#define COH901318_CX_DST_ADDR					(0x0408)
-#define COH901318_CX_DST_ADDR_SPACING				(0x10)
-
-/*
- * CX_LNK_ADDR - Channel Link Address Registers 32bit (R/W)
- */
-#define COH901318_CX_LNK_ADDR					(0x040C)
-#define COH901318_CX_LNK_ADDR_SPACING				(0x10)
-#define COH901318_CX_LNK_LINK_IMMEDIATE				(0x00000001)
 #endif /* COH901318_H */
diff --git a/drivers/dma/coh901318_lli.c b/drivers/dma/coh901318_lli.c
index e25cac0..b2e284f 100644
--- a/drivers/dma/coh901318_lli.c
+++ b/drivers/dma/coh901318_lli.c
@@ -11,6 +11,7 @@
 #include <linux/memory.h>
 #include <linux/gfp.h>
 #include <linux/dmapool.h>
+#include <linux/dmaengine.h>
 
 #include "coh901318.h"
 #include "coh901318_lli.h"
-- 
1.7.11.3

