Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2IBSxV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 14:53:21 -0400
Received: from bosmailout18.eigbox.net ([66.96.185.18]:35186 "EHLO
	bosmailout18.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304Ab2IBSxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 14:53:20 -0400
X-Authority-Analysis: v=2.0 cv=KtT6LxqN c=1 sm=1
 a=buXPRa+6dbOeiNUh9yipmw==:17 a=bc2JKO6qiGsA:10 a=tW0haWE2Y5YA:10
 a=CrU_mlaunIgA:10 a=8nJEP1OIZ-IA:10 a=AZwxLD1B5BoA:10 a=7b0C3uyv_hYA:10
 a=jY72NVWb8CsA:10 a=7E8NXZI3oggA:10 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19
 a=D19gQVrFAAAA:8 a=KKAkSRfTAAAA:8 a=6xAmGB8rGQhRBdtQBnsA:9 a=wPNLvfGTeEIA:10
 a=WwgC8nHKvroA:10 a=Zhjq3JYBYQFIPKZ0:21 a=dfonVcJxJqnFr2e2:21
 a=+tcVrJynzLVJ9yqDAOBWjQ==:117
X-EN-OrigOutIP: 10.20.18.9
X-EN-IMPSID: uJ9K1j0010BkY8i01J9Ko1
Message-ID: <50439D44.3080100@yahoo.es>
Date: Mon, 03 Sep 2012 01:54:12 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        viresh kumar <viresh.kumar@linaro.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
CC: spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v4 2/3] dw_dmac: max_mem_width limits value for SRC/DST_TR_WID
 register
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

The dw_dmac driver was earlier adapted to do 64-bit transfers on the memory
side (see https://lkml.org/lkml/2012/1/18/52)
This works on ARM platforms but for AVR32 (AP700x) the maximum allowed transfer
size is 32-bits.
This patch allows the arch code to set a new slave property max_mem_width to
limit the size.

Allowable values are:

#define	DW_MEM_WIDTH_64		0	/* default */
#define	DW_MEM_WIDTH_32		1	/* e.g. for avr32 */

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c   |   13 +++++++------
 include/linux/dw_dmac.h |    3 +++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index d3c5a5a..311953c 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -190,14 +190,14 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
 }
 
 /*----------------------------------------------------------------------*/
-
-static inline unsigned int dwc_fast_fls(unsigned long long v)
+static inline unsigned int dwc_fast_fls(unsigned long long v,
+	struct dw_dma_slave *dws)
 {
 	/*
 	 * We can be a lot more clever here, but this should take care
 	 * of the most common optimization.
 	 */
-	if (!(v & 7))
+	if (dws->max_mem_width == DW_MEM_WIDTH_64 && !(v & 7))
 		return 3;
 	else if (!(v & 3))
 		return 2;
@@ -636,6 +636,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		size_t len, unsigned long flags)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_dma_slave	*dws = chan->private;
 	struct dw_desc		*desc;
 	struct dw_desc		*first;
 	struct dw_desc		*prev;
@@ -655,7 +656,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		return NULL;
 	}
 
-	src_width = dst_width = dwc_fast_fls(src | dest | len);
+	src_width = dst_width = dwc_fast_fls(src | dest | len, dws);
 
 	ctllo = DWC_DEFAULT_CTLLO(chan)
 			| DWC_CTLL_DST_WIDTH(dst_width)
@@ -755,7 +756,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
-			mem_width = dwc_fast_fls(mem | len);
+			mem_width = dwc_fast_fls(mem | len, dws);
 
 slave_sg_todev_fill_desc:
 			desc = dwc_desc_get(dwc);
@@ -815,7 +816,7 @@ slave_sg_todev_fill_desc:
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
-			mem_width = dwc_fast_fls(mem | len);
+			mem_width = dwc_fast_fls(mem | len, dws);
 
 slave_sg_fromdev_fill_desc:
 			desc = dwc_desc_get(dwc);
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index 2412e02..330afb2 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -58,6 +58,9 @@ struct dw_dma_slave {
 	u32			cfg_lo;
 	u8			src_master;
 	u8			dst_master;
+#define	DW_MEM_WIDTH_64		0
+#define	DW_MEM_WIDTH_32		1	/* e.g. for avr32 */
+	u8			max_mem_width;
 };
 
 /* Platform-configurable bits in CFG_HI */
-- 
1.7.8.0
