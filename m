Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab2HZW1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 18:27:11 -0400
Received: from bosmailout14.eigbox.net ([66.96.185.14]:45041 "EHLO
	bosmailout14.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2HZW1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 18:27:09 -0400
X-Authority-Analysis: v=2.0 cv=aPZHX8Bm c=1 sm=1
 a=OWwsRfqG41DA94+gJvZMBg==:17 a=bc2JKO6qiGsA:10 a=kfTud4QeKxsA:10
 a=PnNOxYUqSyIA:10 a=8nJEP1OIZ-IA:10 a=EqYlCx_eqd0A:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=D19gQVrFAAAA:8 a=XEr1Jo0RWYtCeQoAj2QA:9
 a=wPNLvfGTeEIA:10 a=6uKCkKhFq2wXOH2GoQX8aA==:117
X-EN-OrigOutIP: 10.20.18.3
X-EN-IMPSID: rZm21j01z03yW7601Zm3Z2
Message-ID: <503A89E0.40602@yahoo.es>
Date: Mon, 27 Aug 2012 04:41:04 +0800
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
Subject: [PATCH 2/2] dw_dmac: max_mem_width limits value for SRC/DST_TR_WID
 register
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.63.241
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dw_dmac driver was earlier adapted to do 64-bit transfers
on the memory side (https://lkml.org/lkml/2012/1/18/52)
This works on ARM platforms but for AVR32 (AP700x) the maximum
allowed transfer size is 32-bits.
This patch allows the arch to set a new slave property
max_mem_width to limit the size.
Allowable values for dw_dma_slave::max_mem_width are:

0 : leave it up to dw_dmac (64 bits)
1 : 16-bits
2 : 32-bits

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>

---
 drivers/dma/dw_dmac.c   |    8 ++++++++
 include/linux/dw_dmac.h |    3 +++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 7212961..a4bdf1d 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -754,6 +754,10 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 				mem_width = 1;
 			else
 				mem_width = 0;
+			/* Some controllers don't support 64-bits mem access */
+			if (dws->max_mem_width &&
+				mem_width > dws->max_mem_width)
+				mem_width = dws->max_mem_width;
 
 slave_sg_todev_fill_desc:
 			desc = dwc_desc_get(dwc);
@@ -821,6 +825,10 @@ slave_sg_todev_fill_desc:
 				mem_width = 1;
 			else
 				mem_width = 0;
+			/* Some controllers don't support 64-bits mem access */
+			if (dws->max_mem_width &&
+				mem_width > dws->max_mem_width)
+				mem_width = dws->max_mem_width;
 
 slave_sg_fromdev_fill_desc:
 			desc = dwc_desc_get(dwc);
diff --git a/include/linux/dw_dmac.h b/include/linux/dw_dmac.h
index 2412e02..60b01c3 100644
--- a/include/linux/dw_dmac.h
+++ b/include/linux/dw_dmac.h
@@ -51,6 +51,8 @@ enum dw_dma_msize {
  * @cfg_lo: Platform-specific initializer for the CFG_LO register
  * @src_master: src master for transfers on allocated channel.
  * @dst_master: dest master for transfers on allocated channel.
+ * @max_mem_width: max value for SRC/DST_TR_WIDTH register
+ *	default 0 means: leave it up to driver
  */
 struct dw_dma_slave {
 	struct device		*dma_dev;
@@ -58,6 +60,7 @@ struct dw_dma_slave {
 	u32			cfg_lo;
 	u8			src_master;
 	u8			dst_master;
+	u8			max_mem_width;
 };
 
 /* Platform-configurable bits in CFG_HI */
-- 
1.7.8.0

