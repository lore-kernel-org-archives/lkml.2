Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab2IAD6m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 23:58:42 -0400
Received: from bosmailout11.eigbox.net ([66.96.186.11]:47360 "EHLO
	bosmailout11.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab2IAD6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 23:58:40 -0400
X-Authority-Analysis: v=2.0 cv=aPZHX8Bm c=1 sm=1
 a=Z/nPm8Wi6vkzxh11zJE/RA==:17 a=bc2JKO6qiGsA:10 a=tW0haWE2Y5YA:10
 a=cCnm7YsJ2HMA:10 a=8nJEP1OIZ-IA:10 a=jKtTQB-Zx8sA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=D19gQVrFAAAA:8 a=KKAkSRfTAAAA:8
 a=fUsd2VqqzTs3fo_v_LkA:9 a=wPNLvfGTeEIA:10 a=WwgC8nHKvroA:10
 a=yRkwU2vzfO47fUBn:21 a=lW_zb_dH2mA-rEXF:21 a=eBvjjtMVdWwtQGedh7GyLg==:117
X-EN-OrigOutIP: 10.20.18.5
X-EN-IMPSID: tfHv1j00406Zqne01fHvXl
Message-ID: <50417B7E.50508@yahoo.es>
Date: Sat, 01 Sep 2012 11:05:34 +0800
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
Subject: [PATCH v3 2/3] dw_dmac: max_mem_width limits value for SRC/DST_TR_WID
 register
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.63.40
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 drivers/dma/dw_dmac.c   |   10 +++++++---
 include/linux/dw_dmac.h |    3 +++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 7212961..11f8542 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -618,6 +618,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		size_t len, unsigned long flags)
 {
 	struct dw_dma_chan	*dwc = to_dw_dma_chan(chan);
+	struct dw_dma_slave	*dws = chan->private;
 	struct dw_desc		*desc;
 	struct dw_desc		*first;
 	struct dw_desc		*prev;
@@ -639,7 +640,8 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	 * We can be a lot more clever here, but this should take care
 	 * of the most common optimization.
 	 */
-	if (!((src | dest  | len) & 7))
+	if (dws->max_mem_width == DW_MEM_WIDTH_64 &&
+		!((src | dest  | len) & 7))
 		src_width = dst_width = 3;
 	else if (!((src | dest  | len) & 3))
 		src_width = dst_width = 2;
@@ -746,7 +748,8 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
-			if (!((mem | len) & 7))
+			if (dws->max_mem_width == DW_MEM_WIDTH_64 &&
+				!((mem | len) & 7))
 				mem_width = 3;
 			else if (!((mem | len) & 3))
 				mem_width = 2;
@@ -813,7 +816,8 @@ slave_sg_todev_fill_desc:
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
-			if (!((mem | len) & 7))
+			if (dws->max_mem_width == DW_MEM_WIDTH_64 &&
+				!((mem | len) & 7))
 				mem_width = 3;
 			else if (!((mem | len) & 3))
 				mem_width = 2;
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
