Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab1FBCxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 22:53:04 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:5466 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759015Ab1FBCxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 22:53:01 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh87h2a8h668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-mmc@vger.kernel.org>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cbouatmailru@gmail.com>, <w.sang@pengutronix.de>, <cjb@laptop.org>,
        <grant.likely@secretlab.ca>, <arnd@arndb.de>, <sfr@canb.auug.org.au>,
        <patches@linaro.org>, Shawn Guo <shawn.guo@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] mmc: sdhci: change sdhci-pltfm into a module
Date: Thu, 2 Jun 2011 10:57:50 +0800
Message-ID: <1306983470-18588-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110601130431.59f4f0d4.sfr@canb.auug.org.au>
References: <20110601130431.59f4f0d4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Guo <shawn.guo@freescale.com>

There are a couple of problems left from the sdhci pltfm and OF
consolidation changes.

* When building more than one sdhci-pltfm based drivers in the same
  image, linker will give multiple definition error on the sdhci-pltfm
  helper functions.  For example right now, building sdhci-of-esdhc
  and sdhci-of-hlwd together is a valid combination from Kconfig view.

* With the current build method, there is error with building the
  drivers as module, but module installation fails with modprobe.

The patch fixes above problems by changing sdhci-pltfm into a module.
To avoid EXPORT_SYMBOL on so many big endian IO accessors, it moves
these accessors into sdhci-pltfm.h as the 'static inline' functions.
As a result, sdhci.h needs to be included in sdhci-pltfm.h, and in
turn can be removed from individual drivers which already include
sdhci-pltfm.h.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/mmc/host/Kconfig           |   37 +++++++++++++----
 drivers/mmc/host/Makefile          |    7 +---
 drivers/mmc/host/sdhci-cns3xxx.c   |    1 -
 drivers/mmc/host/sdhci-dove.c      |    1 -
 drivers/mmc/host/sdhci-esdhc-imx.c |    1 -
 drivers/mmc/host/sdhci-of-esdhc.c  |    1 -
 drivers/mmc/host/sdhci-of-hlwd.c   |    1 -
 drivers/mmc/host/sdhci-pltfm.c     |   82 ++++++++++-------------------------
 drivers/mmc/host/sdhci-pltfm.h     |   67 +++++++++++++++++++++++++----
 drivers/mmc/host/sdhci-tegra.c     |    1 -
 10 files changed, 112 insertions(+), 87 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index ee4ac77..74e77c9 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -81,19 +81,32 @@ config MMC_RICOH_MMC
 
 	  If unsure, say Y.
 
-config MMC_SDHCI_OF_ESDHC
-	bool "SDHCI OF support for the Freescale eSDHC controller"
+config MMC_SDHCI_PLTFM
+	tristate "SDHCI platform and OF driver helper"
 	depends on MMC_SDHCI
+	help
+	  This selects the common helper functions support for Secure Digital
+	  Host Controller Interface based platform and OF drivers.
+
+	  If you have a controller with this interface, say Y or M here.
+
+	  If unsure, say N.
+
+config MMC_SDHCI_OF_ESDHC
+	tristate "SDHCI OF support for the Freescale eSDHC controller"
+	depends on MMC_SDHCI_PLTFM
 	depends on PPC_OF
 	select MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
 	help
 	  This selects the Freescale eSDHC controller support.
 
+	  If you have a controller with this interface, say Y or M here.
+
 	  If unsure, say N.
 
 config MMC_SDHCI_OF_HLWD
-	bool "SDHCI OF support for the Nintendo Wii SDHCI controllers"
-	depends on MMC_SDHCI
+	tristate "SDHCI OF support for the Nintendo Wii SDHCI controllers"
+	depends on MMC_SDHCI_PLTFM
 	depends on PPC_OF
 	select MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
 	help
@@ -101,43 +114,51 @@ config MMC_SDHCI_OF_HLWD
 	  found in the "Hollywood" chipset of the Nintendo Wii video game
 	  console.
 
+	  If you have a controller with this interface, say Y or M here.
+
 	  If unsure, say N.
 
 config MMC_SDHCI_CNS3XXX
 	tristate "SDHCI support on the Cavium Networks CNS3xxx SoC"
 	depends on ARCH_CNS3XXX
-	depends on MMC_SDHCI
+	depends on MMC_SDHCI_PLTFM
 	help
 	  This selects the SDHCI support for CNS3xxx System-on-Chip devices.
 
+	  If you have a controller with this interface, say Y or M here.
+
 	  If unsure, say N.
 
 config MMC_SDHCI_ESDHC_IMX
 	tristate "SDHCI platform support for the Freescale eSDHC i.MX controller"
 	depends on ARCH_MX25 || ARCH_MX35 || ARCH_MX5
-	depends on MMC_SDHCI
+	depends on MMC_SDHCI_PLTFM
 	select MMC_SDHCI_IO_ACCESSORS
 	help
 	  This selects the Freescale eSDHC controller support on the platform
 	  bus, found on platforms like mx35/51.
 
+	  If you have a controller with this interface, say Y or M here.
+
 	  If unsure, say N.
 
 config MMC_SDHCI_DOVE
 	tristate "SDHCI support on Marvell's Dove SoC"
 	depends on ARCH_DOVE
-	depends on MMC_SDHCI
+	depends on MMC_SDHCI_PLTFM
 	select MMC_SDHCI_IO_ACCESSORS
 	help
 	  This selects the Secure Digital Host Controller Interface in
 	  Marvell's Dove SoC.
 
+	  If you have a controller with this interface, say Y or M here.
+
 	  If unsure, say N.
 
 config MMC_SDHCI_TEGRA
 	tristate "SDHCI platform support for the Tegra SD/MMC Controller"
 	depends on ARCH_TEGRA
-	depends on MMC_SDHCI
+	depends on MMC_SDHCI_PLTFM
 	select MMC_SDHCI_IO_ACCESSORS
 	help
 	  This selects the Tegra SD/MMC controller. If you have a Tegra
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index cbd89c3..bf479ab 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -44,18 +44,13 @@ obj-$(CONFIG_MMC_JZ4740)	+= jz4740_mmc.o
 obj-$(CONFIG_MMC_VUB300)	+= vub300.o
 obj-$(CONFIG_MMC_USHC)		+= ushc.o
 
+obj-$(CONFIG_MMC_SDHCI_PLTFM)		+= sdhci-pltfm.o
 obj-$(CONFIG_MMC_SDHCI_CNS3XXX)		+= sdhci-cns3xxx.o
-sdhci-cns3xxx-objs			:= sdhci-pltfm.o
 obj-$(CONFIG_MMC_SDHCI_ESDHC_IMX)	+= sdhci-esdhc-imx.o
-sdhci-esdhc-imx-objs			:= sdhci-pltfm.o
 obj-$(CONFIG_MMC_SDHCI_DOVE)		+= sdhci-dove.o
-sdhci-dove-objs				:= sdhci-pltfm.o
 obj-$(CONFIG_MMC_SDHCI_TEGRA)		+= sdhci-tegra.o
-sdhci-tegra-objs			:= sdhci-pltfm.o
 obj-$(CONFIG_MMC_SDHCI_OF_ESDHC)	+= sdhci-of-esdhc.o
-sdhci-of-esdhc-objs			:= sdhci-pltfm.o
 obj-$(CONFIG_MMC_SDHCI_OF_HLWD)		+= sdhci-of-hlwd.o
-sdhci-of-hlwd-objs			:= sdhci-pltfm.o
 
 ifeq ($(CONFIG_CB710_DEBUG),y)
 	CFLAGS-cb710-mmc	+= -DDEBUG
diff --git a/drivers/mmc/host/sdhci-cns3xxx.c b/drivers/mmc/host/sdhci-cns3xxx.c
index 025d1a5..4b920b7 100644
--- a/drivers/mmc/host/sdhci-cns3xxx.c
+++ b/drivers/mmc/host/sdhci-cns3xxx.c
@@ -16,7 +16,6 @@
 #include <linux/device.h>
 #include <linux/mmc/host.h>
 #include <mach/cns3xxx.h>
-#include "sdhci.h"
 #include "sdhci-pltfm.h"
 
 static unsigned int sdhci_cns3xxx_get_max_clk(struct sdhci_host *host)
diff --git a/drivers/mmc/host/sdhci-dove.c b/drivers/mmc/host/sdhci-dove.c
index 49aa533..f2d29dc 100644
--- a/drivers/mmc/host/sdhci-dove.c
+++ b/drivers/mmc/host/sdhci-dove.c
@@ -22,7 +22,6 @@
 #include <linux/io.h>
 #include <linux/mmc/host.h>
 
-#include "sdhci.h"
 #include "sdhci-pltfm.h"
 
 static u16 sdhci_dove_readw(struct sdhci_host *host, int reg)
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 3105bcf..248b8e5 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -22,7 +22,6 @@
 #include <linux/mmc/sdio.h>
 #include <mach/hardware.h>
 #include <mach/esdhc.h>
-#include "sdhci.h"
 #include "sdhci-pltfm.h"
 #include "sdhci-esdhc.h"
 
diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index fd7c2f5..b365f4f 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -17,7 +17,6 @@
 #include <linux/delay.h>
 #include <linux/mmc/host.h>
 #include "sdhci-pltfm.h"
-#include "sdhci.h"
 #include "sdhci-esdhc.h"
 
 static u16 esdhc_readw(struct sdhci_host *host, int reg)
diff --git a/drivers/mmc/host/sdhci-of-hlwd.c b/drivers/mmc/host/sdhci-of-hlwd.c
index faedfce..735be13 100644
--- a/drivers/mmc/host/sdhci-of-hlwd.c
+++ b/drivers/mmc/host/sdhci-of-hlwd.c
@@ -22,7 +22,6 @@
 #include <linux/delay.h>
 #include <linux/mmc/host.h>
 #include "sdhci-pltfm.h"
-#include "sdhci.h"
 
 /*
  * Ops and quirks for the Nintendo Wii SDHCI controllers.
diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index 041b0e2..71c0ce1 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -33,69 +33,11 @@
 #ifdef CONFIG_PPC
 #include <asm/machdep.h>
 #endif
-#include "sdhci.h"
 #include "sdhci-pltfm.h"
 
 static struct sdhci_ops sdhci_pltfm_ops = {
 };
 
-#ifdef CONFIG_MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
-/*
- * These accessors are designed for big endian hosts doing I/O to
- * little endian controllers incorporating a 32-bit hardware byte swapper.
- */
-u32 sdhci_be32bs_readl(struct sdhci_host *host, int reg)
-{
-	return in_be32(host->ioaddr + reg);
-}
-
-u16 sdhci_be32bs_readw(struct sdhci_host *host, int reg)
-{
-	return in_be16(host->ioaddr + (reg ^ 0x2));
-}
-
-u8 sdhci_be32bs_readb(struct sdhci_host *host, int reg)
-{
-	return in_8(host->ioaddr + (reg ^ 0x3));
-}
-
-void sdhci_be32bs_writel(struct sdhci_host *host, u32 val, int reg)
-{
-	out_be32(host->ioaddr + reg, val);
-}
-
-void sdhci_be32bs_writew(struct sdhci_host *host, u16 val, int reg)
-{
-	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
-	int base = reg & ~0x3;
-	int shift = (reg & 0x2) * 8;
-
-	switch (reg) {
-	case SDHCI_TRANSFER_MODE:
-		/*
-		 * Postpone this write, we must do it together with a
-		 * command write that is down below.
-		 */
-		pltfm_host->xfer_mode_shadow = val;
-		return;
-	case SDHCI_COMMAND:
-		sdhci_be32bs_writel(host,
-				    val << 16 | pltfm_host->xfer_mode_shadow,
-				    SDHCI_TRANSFER_MODE);
-		return;
-	}
-	clrsetbits_be32(host->ioaddr + base, 0xffff << shift, val << shift);
-}
-
-void sdhci_be32bs_writeb(struct sdhci_host *host, u8 val, int reg)
-{
-	int base = reg & ~0x3;
-	int shift = (reg & 0x3) * 8;
-
-	clrsetbits_be32(host->ioaddr + base , 0xff << shift, val << shift);
-}
-#endif /* CONFIG_MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER */
-
 #ifdef CONFIG_OF
 static bool sdhci_of_wp_inverted(struct device_node *np)
 {
@@ -136,6 +78,7 @@ void sdhci_get_of_property(struct platform_device *pdev)
 #else
 void sdhci_get_of_property(struct platform_device *pdev) {}
 #endif /* CONFIG_OF */
+EXPORT_SYMBOL_GPL(sdhci_get_of_property);
 
 struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
 				    struct sdhci_pltfm_data *pdata)
@@ -202,6 +145,7 @@ err:
 	dev_err(&pdev->dev, "%s failed %d\n", __func__, ret);
 	return ERR_PTR(ret);
 }
+EXPORT_SYMBOL_GPL(sdhci_pltfm_init);
 
 void sdhci_pltfm_free(struct platform_device *pdev)
 {
@@ -213,6 +157,7 @@ void sdhci_pltfm_free(struct platform_device *pdev)
 	sdhci_free_host(host);
 	platform_set_drvdata(pdev, NULL);
 }
+EXPORT_SYMBOL_GPL(sdhci_pltfm_free);
 
 int sdhci_pltfm_register(struct platform_device *pdev,
 			 struct sdhci_pltfm_data *pdata)
@@ -232,6 +177,7 @@ int sdhci_pltfm_register(struct platform_device *pdev,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(sdhci_pltfm_register);
 
 int sdhci_pltfm_unregister(struct platform_device *pdev)
 {
@@ -243,6 +189,7 @@ int sdhci_pltfm_unregister(struct platform_device *pdev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(sdhci_pltfm_unregister);
 
 #ifdef CONFIG_PM
 int sdhci_pltfm_suspend(struct platform_device *dev, pm_message_t state)
@@ -251,6 +198,7 @@ int sdhci_pltfm_suspend(struct platform_device *dev, pm_message_t state)
 
 	return sdhci_suspend_host(host, state);
 }
+EXPORT_SYMBOL_GPL(sdhci_pltfm_suspend);
 
 int sdhci_pltfm_resume(struct platform_device *dev)
 {
@@ -258,4 +206,22 @@ int sdhci_pltfm_resume(struct platform_device *dev)
 
 	return sdhci_resume_host(host);
 }
+EXPORT_SYMBOL_GPL(sdhci_pltfm_resume);
 #endif	/* CONFIG_PM */
+
+static int __init sdhci_pltfm_drv_init(void)
+{
+	pr_info("sdhci-pltfm: SDHCI platform and OF driver helper\n");
+
+	return 0;
+}
+module_init(sdhci_pltfm_drv_init);
+
+static void __exit sdhci_pltfm_drv_exit(void)
+{
+}
+module_exit(sdhci_pltfm_drv_exit);
+
+MODULE_DESCRIPTION("SDHCI platform and OF driver helper");
+MODULE_AUTHOR("Intel Corporation");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/host/sdhci-pltfm.h b/drivers/mmc/host/sdhci-pltfm.h
index fd72694..3a9fc3f 100644
--- a/drivers/mmc/host/sdhci-pltfm.h
+++ b/drivers/mmc/host/sdhci-pltfm.h
@@ -12,9 +12,8 @@
 #define _DRIVERS_MMC_SDHCI_PLTFM_H
 
 #include <linux/clk.h>
-#include <linux/types.h>
 #include <linux/platform_device.h>
-#include <linux/mmc/sdhci.h>
+#include "sdhci.h"
 
 struct sdhci_pltfm_data {
 	struct sdhci_ops *ops;
@@ -31,13 +30,63 @@ struct sdhci_pltfm_host {
 };
 
 #ifdef CONFIG_MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER
-extern u32 sdhci_be32bs_readl(struct sdhci_host *host, int reg);
-extern u16 sdhci_be32bs_readw(struct sdhci_host *host, int reg);
-extern u8 sdhci_be32bs_readb(struct sdhci_host *host, int reg);
-extern void sdhci_be32bs_writel(struct sdhci_host *host, u32 val, int reg);
-extern void sdhci_be32bs_writew(struct sdhci_host *host, u16 val, int reg);
-extern void sdhci_be32bs_writeb(struct sdhci_host *host, u8 val, int reg);
-#endif
+/*
+ * These accessors are designed for big endian hosts doing I/O to
+ * little endian controllers incorporating a 32-bit hardware byte swapper.
+ */
+static inline u32 sdhci_be32bs_readl(struct sdhci_host *host, int reg)
+{
+	return in_be32(host->ioaddr + reg);
+}
+
+static inline u16 sdhci_be32bs_readw(struct sdhci_host *host, int reg)
+{
+	return in_be16(host->ioaddr + (reg ^ 0x2));
+}
+
+static inline u8 sdhci_be32bs_readb(struct sdhci_host *host, int reg)
+{
+	return in_8(host->ioaddr + (reg ^ 0x3));
+}
+
+static inline void sdhci_be32bs_writel(struct sdhci_host *host,
+				       u32 val, int reg)
+{
+	out_be32(host->ioaddr + reg, val);
+}
+
+static inline void sdhci_be32bs_writew(struct sdhci_host *host,
+				       u16 val, int reg)
+{
+	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
+	int base = reg & ~0x3;
+	int shift = (reg & 0x2) * 8;
+
+	switch (reg) {
+	case SDHCI_TRANSFER_MODE:
+		/*
+		 * Postpone this write, we must do it together with a
+		 * command write that is down below.
+		 */
+		pltfm_host->xfer_mode_shadow = val;
+		return;
+	case SDHCI_COMMAND:
+		sdhci_be32bs_writel(host,
+				    val << 16 | pltfm_host->xfer_mode_shadow,
+				    SDHCI_TRANSFER_MODE);
+		return;
+	}
+	clrsetbits_be32(host->ioaddr + base, 0xffff << shift, val << shift);
+}
+
+static inline void sdhci_be32bs_writeb(struct sdhci_host *host, u8 val, int reg)
+{
+	int base = reg & ~0x3;
+	int shift = (reg & 0x3) * 8;
+
+	clrsetbits_be32(host->ioaddr + base , 0xff << shift, val << shift);
+}
+#endif /* CONFIG_MMC_SDHCI_BIG_ENDIAN_32BIT_BYTE_SWAPPER */
 
 extern void sdhci_get_of_property(struct platform_device *pdev);
 
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 1f66aca..18b0bd3 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -24,7 +24,6 @@
 #include <mach/gpio.h>
 #include <mach/sdhci.h>
 
-#include "sdhci.h"
 #include "sdhci-pltfm.h"
 
 static u32 tegra_sdhci_readl(struct sdhci_host *host, int reg)
-- 
1.7.4.1


