Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab3AGKl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 05:41:28 -0500
Received: from mga14.intel.com ([143.182.124.37]:21873 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab3AGKlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 05:41:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,423,1355126400"; 
   d="scan'208";a="240791103"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        broonie@opensource.wolfsonmicro.com, chao.bi@intel.com,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 01/11] spi/pxa2xx: allow building on a 64-bit kernel
Date: Mon,  7 Jan 2013 12:44:30 +0200
Message-Id: <1357555480-24022-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition fix following warnings seen when compiling 64-bit:

drivers/spi/spi-pxa2xx.c: In function ‘map_dma_buffers’: drivers/spi/spi-pxa2xx.c:384:7: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/spi/spi-pxa2xx.c:384:40: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/spi/spi-pxa2xx.c: In function ‘pxa2xx_spi_probe’:
drivers/spi/spi-pxa2xx.c:1572:34: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/spi/spi-pxa2xx.c:1572:34: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/spi/spi-pxa2xx.c:1572:34: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/spi/spi-pxa2xx.c:1572:27: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/Kconfig      |    4 ++--
 drivers/spi/spi-pxa2xx.c |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 2e188e1..a90393d 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -299,7 +299,7 @@ config SPI_PPC4xx
 
 config SPI_PXA2XX
 	tristate "PXA2xx SSP SPI master"
-	depends on (ARCH_PXA || (X86_32 && PCI)) && EXPERIMENTAL
+	depends on ARCH_PXA || PCI
 	select PXA_SSP if ARCH_PXA
 	help
 	  This enables using a PXA2xx or Sodaville SSP port as a SPI master
@@ -307,7 +307,7 @@ config SPI_PXA2XX
 	  additional documentation can be found a Documentation/spi/pxa2xx.
 
 config SPI_PXA2XX_PCI
-	def_bool SPI_PXA2XX && X86_32 && PCI
+	def_tristate SPI_PXA2XX && PCI
 
 config SPI_RSPI
 	tristate "Renesas RSPI controller"
diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index 5c8c4f5..7fac65d 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -47,7 +47,7 @@ MODULE_ALIAS("platform:pxa2xx-spi");
 
 #define DMA_INT_MASK		(DCSR_ENDINTR | DCSR_STARTINTR | DCSR_BUSERR)
 #define RESET_DMA_CHANNEL	(DCSR_NODESC | DMA_INT_MASK)
-#define IS_DMA_ALIGNED(x)	((((u32)(x)) & 0x07) == 0)
+#define IS_DMA_ALIGNED(x)	IS_ALIGNED((unsigned long)x, DMA_ALIGNMENT)
 #define MAX_DMA_LEN		8191
 #define DMA_ALIGNMENT		8
 
@@ -1569,8 +1569,7 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 	master->transfer = transfer;
 
 	drv_data->ssp_type = ssp->type;
-	drv_data->null_dma_buf = (u32 *)ALIGN((u32)(drv_data +
-						sizeof(struct driver_data)), 8);
+	drv_data->null_dma_buf = (u32 *)PTR_ALIGN(drv_data + 1, 8);
 
 	drv_data->ioaddr = ssp->mmio_base;
 	drv_data->ssdr_physical = ssp->phys_base + SSDR;
-- 
1.7.10.4

