Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2HZW34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 18:29:56 -0400
Received: from bosmailout05.eigbox.net ([66.96.186.5]:37903 "EHLO
	bosmailout05.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab2HZW3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 18:29:54 -0400
X-Greylist: delayed 2596 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Aug 2012 18:29:54 EDT
X-Authority-Analysis: v=2.0 cv=aPZHX8Bm c=1 sm=1
 a=OWwsRfqG41DA94+gJvZMBg==:17 a=bc2JKO6qiGsA:10 a=kfTud4QeKxsA:10
 a=hXkxg5Rd_AAA:10 a=8nJEP1OIZ-IA:10 a=2eTuGy9p-XUA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=rvrEcjyvZElRX2EkMWcA:9 a=wPNLvfGTeEIA:10
 a=9MP9vxlQrmnoeofDS6o88g==:117
X-EN-OrigOutIP: 10.20.18.2
X-EN-IMPSID: rZmd1j00302gpmq01ZmdeJ
Message-ID: <503A8CAE.6050606@yahoo.es>
Date: Mon, 27 Aug 2012 04:53:02 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: viresh kumar <viresh.kumar@linaro.org>
CC: spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, egtvedt@samfundet.no,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: [PATCH 1/2] dw_dmac: make driver endianness configurable
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.63.241
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dw_dmac was originally developed for avr32 to be used with the
Synopsys DesignWare AHB DMA controller. After 2.6.38, device access was done
with the little-endian readl/writel functions. This didn't work on the
avr32 platform, because it needs native-endian (i.e. big-endian) accessors.
This patch makes the endianness configurable using 'DW_DMAC_BE',
which will default be true for AVR32


Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
---
 drivers/dma/Kconfig        |    8 ++++++++
 drivers/dma/dw_dmac_regs.h |   23 +++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index aadeb5b..3635daf 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -89,6 +89,14 @@ config DW_DMAC
 	  Support the Synopsys DesignWare AHB DMA controller.  This
 	  can be integrated in chips such as the Atmel AT32ap7000.
 
+config DW_DMAC_BE
+	bool "Synopsys DesignWare AHB DMA needs big endian access"
+	default y if AVR32
+	depends on DW_DMAC
+	help
+	  Say yes if access to the Synopsys DesignWare AHB DMA controller
+	  should be big endian, such as for Atmel AT32ap7000
+
 config AT_HDMAC
 	tristate "Atmel AHB DMA support"
 	depends on ARCH_AT91
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index f298f69..cf048c3 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -175,11 +175,22 @@ __dwc_regs(struct dw_dma_chan *dwc)
 	return dwc->ch_regs;
 }
 
+#ifdef CONFIG_DW_DMAC_BE
+
+#define channel_readl(dwc, name) \
+	ioread32be(&(__dwc_regs(dwc)->name))
+#define channel_writel(dwc, name, val) \
+	iowrite32be((val), &(__dwc_regs(dwc)->name))
+
+#else
+
 #define channel_readl(dwc, name) \
 	readl(&(__dwc_regs(dwc)->name))
 #define channel_writel(dwc, name, val) \
 	writel((val), &(__dwc_regs(dwc)->name))
 
+#endif
+
 static inline struct dw_dma_chan *to_dw_dma_chan(struct dma_chan *chan)
 {
 	return container_of(chan, struct dw_dma_chan, chan);
@@ -201,11 +212,23 @@ static inline struct dw_dma_regs __iomem *__dw_regs(struct dw_dma *dw)
 	return dw->regs;
 }
 
+#ifdef CONFIG_DW_DMAC_BE
+
+#define dma_readl(dwc, name) \
+	ioread32be(&(__dw_regs(dw)->name))
+#define dma_writel(dwc, name, val) \
+	iowrite32be((val), &(__dw_regs(dw)->name))
+
+#else
+
 #define dma_readl(dw, name) \
 	readl(&(__dw_regs(dw)->name))
 #define dma_writel(dw, name, val) \
 	writel((val), &(__dw_regs(dw)->name))
 
+#endif
+
 #define channel_set_bit(dw, reg, mask) \
 	dma_writel(dw, reg, ((mask) << 8) | (mask))
 #define channel_clear_bit(dw, reg, mask) \
-- 
1.7.8.0

