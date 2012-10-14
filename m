Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab2JNP0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:26:16 -0400
Received: from bosmailout09.eigbox.net ([66.96.189.9]:53441 "EHLO
	bosmailout09.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab2JNP0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:26:14 -0400
X-Greylist: delayed 2523 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Oct 2012 11:26:14 EDT
X-Authority-Analysis: v=2.0 cv=Jc0LWz2V c=1 sm=1
 a=4iwzk5WlZPsH91DJ9+lduA==:17 a=bc2JKO6qiGsA:10 a=jAXA38P_poEA:10
 a=sJzZ5xkLnXkA:10 a=8nJEP1OIZ-IA:10 a=MqEtbqidUwgA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=VwQbUJbxAAAA:8 a=D19gQVrFAAAA:8
 a=Fhfi7x0XTLpfPVzzwuIA:9 a=wPNLvfGTeEIA:10 a=fIc3/5IyPUehxkj7BpkQ7Q==:117
X-EN-OrigOutIP: 10.20.18.6
X-EN-IMPSID: B2k81k00807rX7u012k862
Message-ID: <507A6FA5.1000800@yahoo.es>
Date: Sun, 14 Oct 2012 15:54:13 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        viresh kumar <viresh.kumar@linaro.org>
CC: spear-devel <spear-devel@list.st.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH REGRESSION FIX] dw_dmac: make driver's endianness configurable
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.57.38
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hein Tibosch <hein_tibosch@yahoo.es>

The dw_dmac was originally developed for avr32 to be used with the Synopsys
DesignWare AHB DMA controller. Starting from 2.6.38, access to the device's i/o
memory was done with the little-endian readl/writel functions(1)

This broke the driver for the avr32 platform, because it needs big (native)
endian accessors.
This patch makes the endianness configurable using 'DW_DMAC_BIG_ENDIAN_IO',
which will default be true for AVR32

I submitted this patch before(2) but then waited for Andy to finish other
changes to the same module(3).

(1) https://patchwork.kernel.org/patch/608211
(2) https://lkml.org/lkml/2012/8/26/148
(3) https://lkml.org/lkml/2012/9/21/173

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>

---
 drivers/dma/Kconfig        |   11 +++++++++++
 drivers/dma/dw_dmac_regs.h |   18 +++++++++++++-----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 677cd6e..d4c1218 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -90,6 +90,17 @@ config DW_DMAC
 	  Support the Synopsys DesignWare AHB DMA controller.  This
 	  can be integrated in chips such as the Atmel AT32ap7000.
 
+config DW_DMAC_BIG_ENDIAN_IO
+	bool "Use big endian I/O register access"
+	default y if AVR32
+	depends on DW_DMAC
+	help
+	  Say yes here to use big endian I/O access when reading and writing
+	  to the DMA controller registers. This is needed on some platforms,
+	  like the Atmel AVR32 architecture.
+
+	  If unsure, use the default setting.
+
 config AT_HDMAC
 	tristate "Atmel AHB DMA support"
 	depends on ARCH_AT91
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index ff39fa6..8896559 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -98,9 +98,17 @@ struct dw_dma_regs {
 	u32	DW_PARAMS;
 };
 
+#ifdef CONFIG_DW_DMAC_BIG_ENDIAN_IO
+#define dma_readl_native ioread32be
+#define dma_writel_native iowrite32be
+#else
+#define dma_readl_native readl
+#define dma_writel_native writel
+#endif
+
 /* To access the registers in early stage of probe */
 #define dma_read_byaddr(addr, name) \
-	readl((addr) + offsetof(struct dw_dma_regs, name))
+	dma_readl_native((addr) + offsetof(struct dw_dma_regs, name))
 
 /* Bitfields in DW_PARAMS */
 #define DW_PARAMS_NR_CHAN	8		/* number of channels */
@@ -216,9 +224,9 @@ __dwc_regs(struct dw_dma_chan *dwc)
 }
 
 #define channel_readl(dwc, name) \
-	readl(&(__dwc_regs(dwc)->name))
+	dma_readl_native(&(__dwc_regs(dwc)->name))
 #define channel_writel(dwc, name, val) \
-	writel((val), &(__dwc_regs(dwc)->name))
+	dma_writel_native((val), &(__dwc_regs(dwc)->name))
 
 static inline struct dw_dma_chan *to_dw_dma_chan(struct dma_chan *chan)
 {
@@ -246,9 +254,9 @@ static inline struct dw_dma_regs __iomem *__dw_regs(struct dw_dma *dw)
 }
 
 #define dma_readl(dw, name) \
-	readl(&(__dw_regs(dw)->name))
+	dma_readl_native(&(__dw_regs(dw)->name))
 #define dma_writel(dw, name, val) \
-	writel((val), &(__dw_regs(dw)->name))
+	dma_writel_native((val), &(__dw_regs(dw)->name))
 
 #define channel_set_bit(dw, reg, mask) \
 	dma_writel(dw, reg, ((mask) << 8) | (mask))
-- 
1.7.8.0



