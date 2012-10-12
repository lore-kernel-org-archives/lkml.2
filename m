Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945949Ab2JLPxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:53:10 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:20457 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945918Ab2JLPxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:53:07 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: Philippe De Muyter <phdm@macqel.be>
Subject: [PATCH v2] powerpc,dma: move bestcomm driver from arch/powerpc/sysdev to drivers/dma
Date: Fri, 12 Oct 2012 17:52:45 +0200
Message-Id: <1350057165-9495-1-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bestcomm dma hardware, and some of its users like the FEC ethernet
component, is used in different FreeScale parts, including non-powerpc
parts like the ColdFire MCF547x & MCF548x families.  Don't keep the
driver hidden in arch/powerpc where it is inaccessible for other arches.
.c files are moved to arch/drivers/dma/bestcomm, while
.h files are moved to include/linux/fsl/bestcomm.  Makefiles, Kconfigs
and #include directives are updated for the new file locations.

Tested by recompiling for MPC5200 with all bestcomm users enabled.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
---
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |    6 +++---
 arch/powerpc/platforms/Kconfig                     |    2 --
 arch/powerpc/sysdev/Makefile                       |    1 -
 drivers/Makefile                                   |    2 +-
 drivers/ata/pata_mpc52xx.c                         |    6 +++---
 drivers/dma/Kconfig                                |    2 ++
 drivers/dma/Makefile                               |    1 +
 .../sysdev => drivers/dma}/bestcomm/Kconfig        |    0
 .../sysdev => drivers/dma}/bestcomm/Makefile       |    0
 .../powerpc/sysdev => drivers/dma}/bestcomm/ata.c  |    6 +++---
 .../dma}/bestcomm/bcom_ata_task.c                  |    0
 .../dma}/bestcomm/bcom_fec_rx_task.c               |    0
 .../dma}/bestcomm/bcom_fec_tx_task.c               |    0
 .../dma}/bestcomm/bcom_gen_bd_rx_task.c            |    0
 .../dma}/bestcomm/bcom_gen_bd_tx_task.c            |    0
 .../sysdev => drivers/dma}/bestcomm/bestcomm.c     |    6 +++---
 .../powerpc/sysdev => drivers/dma}/bestcomm/fec.c  |    6 +++---
 .../sysdev => drivers/dma}/bestcomm/gen_bd.c       |    6 +++---
 .../powerpc/sysdev => drivers/dma}/bestcomm/sram.c |    2 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |    4 ++--
 .../sysdev => include/linux/fsl}/bestcomm/ata.h    |    0
 .../linux/fsl}/bestcomm/bestcomm.h                 |    0
 .../linux/fsl}/bestcomm/bestcomm_priv.h            |    0
 .../sysdev => include/linux/fsl}/bestcomm/fec.h    |    0
 .../sysdev => include/linux/fsl}/bestcomm/gen_bd.h |    0
 .../sysdev => include/linux/fsl}/bestcomm/sram.h   |    0
 sound/soc/fsl/mpc5200_dma.c                        |    4 ++--
 27 files changed, 27 insertions(+), 27 deletions(-)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/Kconfig (100%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/Makefile (100%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/ata.c (97%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/bcom_ata_task.c (100%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/bcom_fec_rx_task.c (100%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/bcom_fec_tx_task.c (100%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/bcom_gen_bd_rx_task.c (100%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/bcom_gen_bd_tx_task.c (100%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/bestcomm.c (99%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/fec.c (98%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/gen_bd.c (98%)
 rename {arch/powerpc/sysdev => drivers/dma}/bestcomm/sram.c (99%)
 rename {arch/powerpc/sysdev => include/linux/fsl}/bestcomm/ata.h (100%)
 rename {arch/powerpc/sysdev => include/linux/fsl}/bestcomm/bestcomm.h (100%)
 rename {arch/powerpc/sysdev => include/linux/fsl}/bestcomm/bestcomm_priv.h (100%)
 rename {arch/powerpc/sysdev => include/linux/fsl}/bestcomm/fec.h (100%)
 rename {arch/powerpc/sysdev => include/linux/fsl}/bestcomm/gen_bd.h (100%)
 rename {arch/powerpc/sysdev => include/linux/fsl}/bestcomm/sram.h (100%)

diff --git a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
index 2351f9e..089e665 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
@@ -20,9 +20,9 @@
 #include <asm/mpc52xx.h>
 #include <asm/time.h>
 
-#include <sysdev/bestcomm/bestcomm.h>
-#include <sysdev/bestcomm/bestcomm_priv.h>
-#include <sysdev/bestcomm/gen_bd.h>
+#include <linux/fsl/bestcomm/bestcomm.h>
+#include <linux/fsl/bestcomm/bestcomm_priv.h>
+#include <linux/fsl/bestcomm/gen_bd.h>
 
 MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
 MODULE_DESCRIPTION("MPC5200 LocalPlus FIFO device driver");
diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
index e7a896a..405f763 100644
--- a/arch/powerpc/platforms/Kconfig
+++ b/arch/powerpc/platforms/Kconfig
@@ -351,8 +351,6 @@ config OF_RTC
 	  Uses information from the OF or flattened device tree to instantiate
 	  platform devices for direct mapped RTC chips like the DS1742 or DS1743.
 
-source "arch/powerpc/sysdev/bestcomm/Kconfig"
-
 config SIMPLE_GPIO
 	bool "Support for simple, memory-mapped GPIO controllers"
 	depends on PPC
diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
index a57600b..3884776 100644
--- a/arch/powerpc/sysdev/Makefile
+++ b/arch/powerpc/sysdev/Makefile
@@ -26,7 +26,6 @@ obj-$(CONFIG_SIMPLE_GPIO)	+= simple_gpio.o
 obj-$(CONFIG_FSL_RIO)		+= fsl_rio.o fsl_rmu.o
 obj-$(CONFIG_TSI108_BRIDGE)	+= tsi108_pci.o tsi108_dev.o
 obj-$(CONFIG_QUICC_ENGINE)	+= qe_lib/
-obj-$(CONFIG_PPC_BESTCOMM)	+= bestcomm/
 mv64x60-$(CONFIG_PCI)		+= mv64x60_pci.o
 obj-$(CONFIG_MV64X60)		+= $(mv64x60-y) mv64x60_pic.o mv64x60_dev.o \
 				   mv64x60_udbg.o
diff --git a/drivers/Makefile b/drivers/Makefile
index 03da5b6..b69189e 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -25,7 +25,7 @@ obj-$(CONFIG_PNP)		+= pnp/
 obj-y				+= amba/
 # Many drivers will want to use DMA so this has to be made available
 # really early.
-obj-$(CONFIG_DMA_ENGINE)	+= dma/
+obj-$(CONFIG_DMADEVICES)	+= dma/
 
 obj-$(CONFIG_VIRTIO)		+= virtio/
 obj-$(CONFIG_XEN)		+= xen/
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index d2c102f..3d0d4d2 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -26,9 +26,9 @@
 #include <asm/prom.h>
 #include <asm/mpc52xx.h>
 
-#include <sysdev/bestcomm/bestcomm.h>
-#include <sysdev/bestcomm/bestcomm_priv.h>
-#include <sysdev/bestcomm/ata.h>
+#include <linux/fsl/bestcomm/bestcomm.h>
+#include <linux/fsl/bestcomm/bestcomm_priv.h>
+#include <linux/fsl/bestcomm/ata.h>
 
 #define DRV_NAME	"mpc52xx_ata"
 
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 677cd6e..464050b 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -114,6 +114,8 @@ config MPC512X_DMA
 	---help---
 	  Enable support for the Freescale MPC512x built-in DMA engine.
 
+source "drivers/dma/bestcomm/Kconfig"
+
 config MV_XOR
 	bool "Marvell XOR engine support"
 	depends on PLAT_ORION
diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
index 7428fea..642d967 100644
--- a/drivers/dma/Makefile
+++ b/drivers/dma/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_INTEL_IOATDMA) += ioat/
 obj-$(CONFIG_INTEL_IOP_ADMA) += iop-adma.o
 obj-$(CONFIG_FSL_DMA) += fsldma.o
 obj-$(CONFIG_MPC512X_DMA) += mpc512x_dma.o
+obj-$(CONFIG_PPC_BESTCOMM) += bestcomm/
 obj-$(CONFIG_MV_XOR) += mv_xor.o
 obj-$(CONFIG_DW_DMAC) += dw_dmac.o
 obj-$(CONFIG_AT_HDMAC) += at_hdmac.o
diff --git a/arch/powerpc/sysdev/bestcomm/Kconfig b/drivers/dma/bestcomm/Kconfig
similarity index 100%
rename from arch/powerpc/sysdev/bestcomm/Kconfig
rename to drivers/dma/bestcomm/Kconfig
diff --git a/arch/powerpc/sysdev/bestcomm/Makefile b/drivers/dma/bestcomm/Makefile
similarity index 100%
rename from arch/powerpc/sysdev/bestcomm/Makefile
rename to drivers/dma/bestcomm/Makefile
diff --git a/arch/powerpc/sysdev/bestcomm/ata.c b/drivers/dma/bestcomm/ata.c
similarity index 97%
rename from arch/powerpc/sysdev/bestcomm/ata.c
rename to drivers/dma/bestcomm/ata.c
index 901c9f9..2fd87f8 100644
--- a/arch/powerpc/sysdev/bestcomm/ata.c
+++ b/drivers/dma/bestcomm/ata.c
@@ -18,9 +18,9 @@
 #include <linux/types.h>
 #include <asm/io.h>
 
-#include "bestcomm.h"
-#include "bestcomm_priv.h"
-#include "ata.h"
+#include <linux/fsl/bestcomm/bestcomm.h>
+#include <linux/fsl/bestcomm/bestcomm_priv.h>
+#include <linux/fsl/bestcomm/ata.h>
 
 
 /* ======================================================================== */
diff --git a/arch/powerpc/sysdev/bestcomm/bcom_ata_task.c b/drivers/dma/bestcomm/bcom_ata_task.c
similarity index 100%
rename from arch/powerpc/sysdev/bestcomm/bcom_ata_task.c
rename to drivers/dma/bestcomm/bcom_ata_task.c
diff --git a/arch/powerpc/sysdev/bestcomm/bcom_fec_rx_task.c b/drivers/dma/bestcomm/bcom_fec_rx_task.c
similarity index 100%
rename from arch/powerpc/sysdev/bestcomm/bcom_fec_rx_task.c
rename to drivers/dma/bestcomm/bcom_fec_rx_task.c
diff --git a/arch/powerpc/sysdev/bestcomm/bcom_fec_tx_task.c b/drivers/dma/bestcomm/bcom_fec_tx_task.c
similarity index 100%
rename from arch/powerpc/sysdev/bestcomm/bcom_fec_tx_task.c
rename to drivers/dma/bestcomm/bcom_fec_tx_task.c
diff --git a/arch/powerpc/sysdev/bestcomm/bcom_gen_bd_rx_task.c b/drivers/dma/bestcomm/bcom_gen_bd_rx_task.c
similarity index 100%
rename from arch/powerpc/sysdev/bestcomm/bcom_gen_bd_rx_task.c
rename to drivers/dma/bestcomm/bcom_gen_bd_rx_task.c
diff --git a/arch/powerpc/sysdev/bestcomm/bcom_gen_bd_tx_task.c b/drivers/dma/bestcomm/bcom_gen_bd_tx_task.c
similarity index 100%
rename from arch/powerpc/sysdev/bestcomm/bcom_gen_bd_tx_task.c
rename to drivers/dma/bestcomm/bcom_gen_bd_tx_task.c
diff --git a/arch/powerpc/sysdev/bestcomm/bestcomm.c b/drivers/dma/bestcomm/bestcomm.c
similarity index 99%
rename from arch/powerpc/sysdev/bestcomm/bestcomm.c
rename to drivers/dma/bestcomm/bestcomm.c
index b3fbb27..67371fb 100644
--- a/arch/powerpc/sysdev/bestcomm/bestcomm.c
+++ b/drivers/dma/bestcomm/bestcomm.c
@@ -23,9 +23,9 @@
 #include <asm/irq.h>
 #include <asm/mpc52xx.h>
 
-#include "sram.h"
-#include "bestcomm_priv.h"
-#include "bestcomm.h"
+#include <linux/fsl/bestcomm/sram.h>
+#include <linux/fsl/bestcomm/bestcomm_priv.h>
+#include "linux/fsl/bestcomm/bestcomm.h"
 
 #define DRIVER_NAME "bestcomm-core"
 
diff --git a/arch/powerpc/sysdev/bestcomm/fec.c b/drivers/dma/bestcomm/fec.c
similarity index 98%
rename from arch/powerpc/sysdev/bestcomm/fec.c
rename to drivers/dma/bestcomm/fec.c
index 957a988..7f1fb1c 100644
--- a/arch/powerpc/sysdev/bestcomm/fec.c
+++ b/drivers/dma/bestcomm/fec.c
@@ -16,9 +16,9 @@
 #include <linux/types.h>
 #include <asm/io.h>
 
-#include "bestcomm.h"
-#include "bestcomm_priv.h"
-#include "fec.h"
+#include <linux/fsl/bestcomm/bestcomm.h>
+#include <linux/fsl/bestcomm/bestcomm_priv.h>
+#include <linux/fsl/bestcomm/fec.h>
 
 
 /* ======================================================================== */
diff --git a/arch/powerpc/sysdev/bestcomm/gen_bd.c b/drivers/dma/bestcomm/gen_bd.c
similarity index 98%
rename from arch/powerpc/sysdev/bestcomm/gen_bd.c
rename to drivers/dma/bestcomm/gen_bd.c
index e0a53e3..1a5b22d 100644
--- a/arch/powerpc/sysdev/bestcomm/gen_bd.c
+++ b/drivers/dma/bestcomm/gen_bd.c
@@ -21,9 +21,9 @@
 #include <asm/mpc52xx.h>
 #include <asm/mpc52xx_psc.h>
 
-#include "bestcomm.h"
-#include "bestcomm_priv.h"
-#include "gen_bd.h"
+#include <linux/fsl/bestcomm/bestcomm.h>
+#include <linux/fsl/bestcomm/bestcomm_priv.h>
+#include <linux/fsl/bestcomm/gen_bd.h>
 
 
 /* ======================================================================== */
diff --git a/arch/powerpc/sysdev/bestcomm/sram.c b/drivers/dma/bestcomm/sram.c
similarity index 99%
rename from arch/powerpc/sysdev/bestcomm/sram.c
rename to drivers/dma/bestcomm/sram.c
index b6db23e..5e2ed30 100644
--- a/arch/powerpc/sysdev/bestcomm/sram.c
+++ b/drivers/dma/bestcomm/sram.c
@@ -23,7 +23,7 @@
 #include <asm/io.h>
 #include <asm/mmu.h>
 
-#include "sram.h"
+#include <linux/fsl/bestcomm/sram.h>
 
 
 /* Struct keeping our 'state' */
diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx.c b/drivers/net/ethernet/freescale/fec_mpc52xx.c
index 2933d08..c077be0 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx.c
@@ -40,8 +40,8 @@
 #include <asm/delay.h>
 #include <asm/mpc52xx.h>
 
-#include <sysdev/bestcomm/bestcomm.h>
-#include <sysdev/bestcomm/fec.h>
+#include <linux/fsl/bestcomm/bestcomm.h>
+#include <linux/fsl/bestcomm/fec.h>
 
 #include "fec_mpc52xx.h"
 
diff --git a/arch/powerpc/sysdev/bestcomm/ata.h b/include/linux/fsl/bestcomm/ata.h
similarity index 100%
rename from arch/powerpc/sysdev/bestcomm/ata.h
rename to include/linux/fsl/bestcomm/ata.h
diff --git a/arch/powerpc/sysdev/bestcomm/bestcomm.h b/include/linux/fsl/bestcomm/bestcomm.h
similarity index 100%
rename from arch/powerpc/sysdev/bestcomm/bestcomm.h
rename to include/linux/fsl/bestcomm/bestcomm.h
diff --git a/arch/powerpc/sysdev/bestcomm/bestcomm_priv.h b/include/linux/fsl/bestcomm/bestcomm_priv.h
similarity index 100%
rename from arch/powerpc/sysdev/bestcomm/bestcomm_priv.h
rename to include/linux/fsl/bestcomm/bestcomm_priv.h
diff --git a/arch/powerpc/sysdev/bestcomm/fec.h b/include/linux/fsl/bestcomm/fec.h
similarity index 100%
rename from arch/powerpc/sysdev/bestcomm/fec.h
rename to include/linux/fsl/bestcomm/fec.h
diff --git a/arch/powerpc/sysdev/bestcomm/gen_bd.h b/include/linux/fsl/bestcomm/gen_bd.h
similarity index 100%
rename from arch/powerpc/sysdev/bestcomm/gen_bd.h
rename to include/linux/fsl/bestcomm/gen_bd.h
diff --git a/arch/powerpc/sysdev/bestcomm/sram.h b/include/linux/fsl/bestcomm/sram.h
similarity index 100%
rename from arch/powerpc/sysdev/bestcomm/sram.h
rename to include/linux/fsl/bestcomm/sram.h
diff --git a/sound/soc/fsl/mpc5200_dma.c b/sound/soc/fsl/mpc5200_dma.c
index 9997c03..2a847ca 100644
--- a/sound/soc/fsl/mpc5200_dma.c
+++ b/sound/soc/fsl/mpc5200_dma.c
@@ -14,8 +14,8 @@
 
 #include <sound/soc.h>
 
-#include <sysdev/bestcomm/bestcomm.h>
-#include <sysdev/bestcomm/gen_bd.h>
+#include <linux/fsl/bestcomm/bestcomm.h>
+#include <linux/fsl/bestcomm/gen_bd.h>
 #include <asm/mpc52xx_psc.h>
 
 #include "mpc5200_dma.h"
-- 
1.7.1

