Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2IBStQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 14:49:16 -0400
Received: from bosmailout03.eigbox.net ([66.96.188.3]:34815 "EHLO
	bosmailout03.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab2IBStP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 14:49:15 -0400
X-Greylist: delayed 2413 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Sep 2012 14:49:15 EDT
X-Authority-Analysis: v=2.0 cv=KtT6LxqN c=1 sm=1
 a=buXPRa+6dbOeiNUh9yipmw==:17 a=bc2JKO6qiGsA:10 a=tW0haWE2Y5YA:10
 a=wiqFcb-U0z0A:10 a=8nJEP1OIZ-IA:10 a=TRVAkUY58fEA:10 a=-PglWoO-6DwA:10
 a=fuChT9weV9EA:10 a=7E8NXZI3oggA:10 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19
 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=h1MlHQw6QUTkkVGnWAMA:9 a=wPNLvfGTeEIA:10
 a=WwgC8nHKvroA:10 a=eBvjjtMVdWwtQGedh7GyLg==:117
X-EN-OrigOutIP: 10.20.18.5
X-EN-IMPSID: uJ911j00906Zqne01J91jg
Message-ID: <50439CF8.3090406@yahoo.es>
Date: Mon, 03 Sep 2012 01:52:56 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        viresh kumar <viresh.kumar@linaro.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: Arnd Bergmann <arnd.bergmann@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        spear-devel <spear-devel@list.st.com>
Subject: [PATCH v4 1/3] dw_dmac: make driver endianness configurable
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.57.6
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hein Tibosch <hein_tibosch@yahoo.es>

v4: now based and tested on 3.6-rc4

The dw_dmac was originally developed for avr32 to be used with the Synopsys
DesignWare AHB DMA controller. After 2.6.38, access to the device's i/o
memory was done with the little-endian readl/writel functions
(https://patchwork.kernel.org/patch/608211)

This didn't work on the avr32 platform, because it needs native-endian
(i.e. big-endian) accessors.
This patch makes the endianness configurable using 'DW_DMAC_BIG_ENDIAN_IO',
which will default be true for AVR32

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Arnd Bergmann <arnd.bergmann@linaro.org>
Reviewed-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

---
 drivers/dma/Kconfig        |   11 +++++++++++
 drivers/dma/dw_dmac_regs.h |   14 ++++++++++++++
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index d06ea29..5a26d46 100644
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
index 50830be..8aad868 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -175,10 +175,17 @@ __dwc_regs(struct dw_dma_chan *dwc)
 	return dwc->ch_regs;
 }
 
+#ifdef CONFIG_DW_DMAC_BIG_ENDIAN_IO
+#define channel_readl(dwc, name) \
+	ioread32be(&(__dwc_regs(dwc)->name))
+#define channel_writel(dwc, name, val) \
+	iowrite32be((val), &(__dwc_regs(dwc)->name))
+#else
 #define channel_readl(dwc, name) \
 	readl(&(__dwc_regs(dwc)->name))
 #define channel_writel(dwc, name, val) \
 	writel((val), &(__dwc_regs(dwc)->name))
+#endif
 
 static inline struct dw_dma_chan *to_dw_dma_chan(struct dma_chan *chan)
 {
@@ -201,10 +208,17 @@ static inline struct dw_dma_regs __iomem *__dw_regs(struct dw_dma *dw)
 	return dw->regs;
 }
 
+#ifdef CONFIG_DW_DMAC_BIG_ENDIAN_IO
+#define dma_readl(dwc, name) \
+	ioread32be(&(__dw_regs(dw)->name))
+#define dma_writel(dwc, name, val) \
+	iowrite32be((val), &(__dw_regs(dw)->name))
+#else
 #define dma_readl(dw, name) \
 	readl(&(__dw_regs(dw)->name))
 #define dma_writel(dw, name, val) \
 	writel((val), &(__dw_regs(dw)->name))
+#endif
 
 #define channel_set_bit(dw, reg, mask) \
 	dma_writel(dw, reg, ((mask) << 8) | (mask))
-- 
1.7.8.0

