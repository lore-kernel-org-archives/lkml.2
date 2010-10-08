Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab0JHAIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 20:08:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:15652 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157Ab0JHAIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 20:08:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,299,1283756400"; 
   d="scan'208";a="665257427"
Subject: [PATCH] async_tx: make async_tx channel switching opt-in
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: Anatolij Gustschin <agust@denx.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Saeed Bishara <saeed@marvell.com>, Ira Snyder <iws@ovro.caltech.edu>
Date: Thu, 07 Oct 2010 17:10:14 -0700
Message-ID: <20101008001014.7641.9824.stgit@localhost.localdomain>
User-Agent: StGit/0.15-6-g0854
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The majority of drivers in drivers/dma/ will never establish cross
channel operation chains and do not need the extra overhead in struct
dma_async_tx_descriptor.  Make channel switching opt-in by default.

Cc: Anatolij Gustschin <agust@denx.de>
Cc: Ira Snyder <iws@ovro.caltech.edu>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Saeed Bishara <saeed@marvell.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/Kconfig       |    7 +++++--
 drivers/dma/dmaengine.c   |    4 ++--
 include/linux/dmaengine.h |    8 ++++----
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index ab28f60..79d1542 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -46,7 +46,7 @@ config INTEL_MID_DMAC
 
 	  If unsure, say N.
 
-config ASYNC_TX_DISABLE_CHANNEL_SWITCH
+config ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	bool
 
 config AMBA_PL08X
@@ -62,7 +62,6 @@ config INTEL_IOATDMA
 	depends on PCI && X86
 	select DMA_ENGINE
 	select DCA
-	select ASYNC_TX_DISABLE_CHANNEL_SWITCH
 	select ASYNC_TX_DISABLE_PQ_VAL_DMA
 	select ASYNC_TX_DISABLE_XOR_VAL_DMA
 	help
@@ -77,6 +76,7 @@ config INTEL_IOP_ADMA
 	tristate "Intel IOP ADMA support"
 	depends on ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
 	select DMA_ENGINE
+	select ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	help
 	  Enable support for the Intel(R) IOP Series RAID engines.
 
@@ -101,6 +101,7 @@ config FSL_DMA
 	tristate "Freescale Elo and Elo Plus DMA support"
 	depends on FSL_SOC
 	select DMA_ENGINE
+	select ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	---help---
 	  Enable support for the Freescale Elo and Elo Plus DMA controllers.
 	  The Elo is the DMA controller on some 82xx and 83xx parts, and the
@@ -117,6 +118,7 @@ config MV_XOR
 	bool "Marvell XOR engine support"
 	depends on PLAT_ORION
 	select DMA_ENGINE
+	select ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	---help---
 	  Enable support for the Marvell XOR engine.
 
@@ -174,6 +176,7 @@ config AMCC_PPC440SPE_ADMA
 	depends on 440SPe || 440SP
 	select DMA_ENGINE
 	select ARCH_HAS_ASYNC_TX_FIND_CHANNEL
+	select ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	help
 	  Enable support for the AMCC PPC440SPe RAID engines.
 
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 235153c..8bcb15f 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -706,7 +706,7 @@ int dma_async_device_register(struct dma_device *device)
 	BUG_ON(!device->dev);
 
 	/* note: this only matters in the
-	 * CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y case
+	 * CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH=n case
 	 */
 	if (device_has_all_tx_types(device))
 		dma_cap_set(DMA_ASYNC_TX, device->cap_mask);
@@ -980,7 +980,7 @@ void dma_async_tx_descriptor_init(struct dma_async_tx_descriptor *tx,
 	struct dma_chan *chan)
 {
 	tx->chan = chan;
-	#ifndef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH
+	#ifdef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	spin_lock_init(&tx->lock);
 	#endif
 }
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 3934ebd..9d8688b 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -321,14 +321,14 @@ struct dma_async_tx_descriptor {
 	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
 	dma_async_tx_callback callback;
 	void *callback_param;
-#ifndef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH
+#ifdef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
 	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;
 	spinlock_t lock;
 #endif
 };
 
-#ifdef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH
+#ifndef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
 static inline void txd_lock(struct dma_async_tx_descriptor *txd)
 {
 }
@@ -656,11 +656,11 @@ static inline void net_dmaengine_put(void)
 #ifdef CONFIG_ASYNC_TX_DMA
 #define async_dmaengine_get()	dmaengine_get()
 #define async_dmaengine_put()	dmaengine_put()
-#ifdef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH
+#ifndef CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH
 #define async_dma_find_channel(type) dma_find_channel(DMA_ASYNC_TX)
 #else
 #define async_dma_find_channel(type) dma_find_channel(type)
-#endif /* CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH */
+#endif /* CONFIG_ASYNC_TX_ENABLE_CHANNEL_SWITCH */
 #else
 static inline void async_dmaengine_get(void)
 {

