Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449Ab2IAD6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 23:58:01 -0400
Received: from bosmailout05.eigbox.net ([66.96.187.5]:41232 "EHLO
	bosmailout05.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab2IAD5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 23:57:39 -0400
X-Greylist: delayed 2399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Aug 2012 23:57:39 EDT
X-Authority-Analysis: v=2.0 cv=aPZHX8Bm c=1 sm=1
 a=Z/nPm8Wi6vkzxh11zJE/RA==:17 a=bc2JKO6qiGsA:10 a=tW0haWE2Y5YA:10
 a=pwQJmwAge4AA:10 a=8nJEP1OIZ-IA:10 a=iIzMtcZSCJUA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8
 a=sXByejFr6yngx_-pCvAA:9 a=wPNLvfGTeEIA:10 a=WwgC8nHKvroA:10
 a=6thTdk0GfRoQwv0zj4iWMg==:117
X-EN-OrigOutIP: 10.20.18.15
X-EN-IMPSID: tfHe1j0010KWaAJ01fHeWe
Message-ID: <50417B2E.1030806@yahoo.es>
Date: Sat, 01 Sep 2012 11:04:14 +0800
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
Subject: [PATCH v3 1/3] dw_dmac: make driver endianness configurable
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.63.40
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index aadeb5b..a9f6781 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -89,6 +89,17 @@ config DW_DMAC
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
index f298f69..9758651 100644
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
