Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab0DGXNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:13:33 -0400
Received: from mail.df.lth.se ([194.47.250.12]:65459 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757185Ab0DGXNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:13:25 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: akpm@linux-foundation.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 05/11] ARM: add generic PrimeCell interface to COH 901 318 v5
Date: Thu,  8 Apr 2010 01:12:53 +0200
Message-Id: <1270681973-5763-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This extends the DMA engine driver for the COH 901 318 used in the
U300 platform with the generic PrimeCell interface.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/coh901318.c     |  146 +++++++++++++++++++++++++++++++++++++++++++
 drivers/dma/coh901318_lli.c |   78 ++++++++++++++++++++++-
 2 files changed, 221 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index 4233440..1d5ed16 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -21,6 +21,7 @@
 #include <linux/uaccess.h>
 #include <linux/debugfs.h>
 #include <mach/coh901318.h>
+#include <linux/amba/dma.h>
 
 #include "coh901318_lli.h"
 
@@ -72,6 +73,9 @@ struct coh901318_chan {
 	unsigned long nbr_active_done;
 	unsigned long busy;
 
+	u32 amba_addr;
+	u32 amba_ctrl;
+
 	struct coh901318_base *base;
 };
 
@@ -190,6 +194,9 @@ static inline struct coh901318_chan *to_coh901318_chan(struct dma_chan *chan)
 static inline dma_addr_t
 cohc_dev_addr(struct coh901318_chan *cohc)
 {
+	/* PrimeCell supplied address will take precedence */
+	if (cohc->amba_addr)
+		return cohc->amba_addr;
 	return cohc->base->platform->chan_conf[cohc->id].dev_addr;
 }
 
@@ -1055,6 +1062,14 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 
 	params = cohc_chan_param(cohc);
 	config = params->config;
+	/*
+	 * Add primecell-specific control on top, make
+	 * sure the bits you set per peripheral channel are
+	 * cleared in the default config from the platform.
+	 */
+	ctrl_chained |= cohc->amba_ctrl;
+	ctrl_last |= cohc->amba_ctrl;
+	ctrl |= cohc->amba_ctrl;
 
 	if (direction == DMA_TO_DEVICE) {
 		u32 tx_flags = COH901318_CX_CTRL_PRDD_SOURCE |
@@ -1113,6 +1128,12 @@ coh901318_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 	if (ret)
 		goto err_lli_fill;
 
+	/*
+	 * Set the default ctrl for the channel to the one from the lli,
+	 * things may have changed due to odd buffer alignment etc.
+	 */
+	coh901318_set_ctrl(cohc, lli->control);
+
 	COH_DBG(coh901318_list_print(cohc, lli));
 
 	/* Pick a descriptor to handle this transfer */
@@ -1239,6 +1260,131 @@ coh901318_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd)
 
 	return 0;
 }
+
+/*
+ * Here we wrap in the PrimeCell dma interface
+ */
+struct burst_table {
+	int burst_8bit;
+	int burst_16bit;
+	int burst_32bit;
+	u32 reg;
+};
+
+static const struct burst_table burst_sizes[] = {
+	{
+		.burst_8bit = 64,
+		.burst_16bit = 32,
+		.burst_32bit = 16,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_64_BYTES,
+	},
+	{
+		.burst_8bit = 48,
+		.burst_16bit = 24,
+		.burst_32bit = 12,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_48_BYTES,
+	},
+	{
+		.burst_8bit = 32,
+		.burst_16bit = 16,
+		.burst_32bit = 8,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_32_BYTES,
+	},
+	{
+		.burst_8bit = 16,
+		.burst_16bit = 8,
+		.burst_32bit = 4,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_16_BYTES,
+	},
+	{
+		.burst_8bit = 8,
+		.burst_16bit = 4,
+		.burst_32bit = 2,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_8_BYTES,
+	},
+	{
+		.burst_8bit = 4,
+		.burst_16bit = 2,
+		.burst_32bit = 1,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_4_BYTES,
+	},
+	{
+		.burst_8bit = 2,
+		.burst_16bit = 1,
+		.burst_32bit = 0,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_2_BYTES,
+	},
+	{
+		.burst_8bit = 1,
+		.burst_16bit = 0,
+		.burst_32bit = 0,
+		.reg = COH901318_CX_CTRL_BURST_COUNT_1_BYTE,
+	},
+};
+
+void dma_set_ambaconfig(struct dma_chan *chan,
+			struct amba_dma_channel_config *config)
+{
+	struct coh901318_chan *cohc = to_coh901318_chan(chan);
+	int maxburst = config->maxburst;
+	u32 amba_ctrl = 0;
+	int i = 0;
+
+	dev_dbg(COHC_2_DEV(cohc), "configure channel for %d byte transfers\n",
+		config->addr_width);
+	switch (config->addr_width)  {
+	case 1:
+		amba_ctrl |=
+			COH901318_CX_CTRL_SRC_BUS_SIZE_8_BITS |
+			COH901318_CX_CTRL_DST_BUS_SIZE_8_BITS;
+
+		while (i < ARRAY_SIZE(burst_sizes)) {
+			if (burst_sizes[i].burst_8bit <= maxburst)
+				break;
+			i++;
+		}
+
+		break;
+	case 2:
+		amba_ctrl |=
+			COH901318_CX_CTRL_SRC_BUS_SIZE_16_BITS |
+			COH901318_CX_CTRL_DST_BUS_SIZE_16_BITS;
+
+		while (i < ARRAY_SIZE(burst_sizes)) {
+			if (burst_sizes[i].burst_16bit <= maxburst)
+				break;
+			i++;
+		}
+
+		break;
+	case 4:
+		/* Direction doesn't matter here, it's 32/32 bits */
+		amba_ctrl |=
+			COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS |
+			COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS;
+
+		while (i < ARRAY_SIZE(burst_sizes)) {
+			if (burst_sizes[i].burst_32bit <= maxburst)
+				break;
+			i++;
+		}
+
+		break;
+	default:
+		dev_err(COHC_2_DEV(cohc),
+			"bad ambaconfig: alien address width\n");
+		return;
+	}
+
+	amba_ctrl |= burst_sizes[i].reg;
+	dev_dbg(COHC_2_DEV(cohc),
+		"selected burst size %d bytes for address width %d bytes, maxburst %d\n",
+		burst_sizes[i].burst_8bit, config->addr_width, maxburst);
+
+	cohc->amba_addr = config->addr;
+	cohc->amba_ctrl = amba_ctrl;
+}
+
 void coh901318_base_init(struct dma_device *dma, const int *pick_chans,
 			 struct coh901318_base *base)
 {
diff --git a/drivers/dma/coh901318_lli.c b/drivers/dma/coh901318_lli.c
index 9f7e0e6..f37db49 100644
--- a/drivers/dma/coh901318_lli.c
+++ b/drivers/dma/coh901318_lli.c
@@ -153,6 +153,39 @@ coh901318_lli_fill_memcpy(struct coh901318_pool *pool,
 	lli->src_addr = src;
 	lli->dst_addr = dst;
 
+	/*
+	 * The DMA hardware will increase its pointer by 1,
+	 * 2 or 4 bytes at a time depending on configuration.
+	 * If using som oddly-aligned buffer this will cause
+	 * performance problems.
+	 */
+#if 0
+	ctrl_chained &= ~COH901318_CX_CTRL_SRC_BUS_SIZE_MASK;
+	ctrl_eom &= ~COH901318_CX_CTRL_SRC_BUS_SIZE_MASK;
+	ctrl_chained &= ~COH901318_CX_CTRL_DST_BUS_SIZE_MASK;
+	ctrl_eom &= ~COH901318_CX_CTRL_DST_BUS_SIZE_MASK;
+	if (src & 0x01) {
+		ctrl_chained |= COH901318_CX_CTRL_SRC_BUS_SIZE_8_BITS;
+		ctrl_eom |= COH901318_CX_CTRL_SRC_BUS_SIZE_8_BITS;
+	} else if (src & 0x02) {
+		ctrl_chained |= COH901318_CX_CTRL_SRC_BUS_SIZE_16_BITS;
+		ctrl_eom |= COH901318_CX_CTRL_SRC_BUS_SIZE_16_BITS;
+	} else {
+		ctrl_chained |= COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS;
+		ctrl_eom |= COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS;
+	}
+	if (dst & 0x01) {
+		ctrl_chained |= COH901318_CX_CTRL_DST_BUS_SIZE_8_BITS;
+		ctrl_eom |= COH901318_CX_CTRL_SRC_DST_SIZE_8_BITS;
+	} else if (dst & 0x02) {
+		ctrl_chained |= COH901318_CX_CTRL_DST_BUS_SIZE_16_BITS;
+		ctrl_eom |= COH901318_CX_CTRL_DST_BUS_SIZE_16_BITS;
+	} else {
+		ctrl_chained |= COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS;
+		ctrl_eom |= COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS;
+	}
+#endif
+
 	while (lli->link_addr) {
 		lli->control = ctrl_chained | MAX_DMA_PACKET_SIZE;
 		lli->src_addr = src;
@@ -268,13 +301,52 @@ coh901318_lli_fill_sg(struct coh901318_pool *pool,
 		else
 			ctrl_sg = ctrl ? ctrl : ctrl_last;
 
-
-		if (dir == DMA_TO_DEVICE)
+		/*
+		 * If the physical address is only divisible by 1 or
+		 * two, we have to lower the destination bus size to
+		 * the least common denominator
+		 */
+		if (dir == DMA_TO_DEVICE) {
 			/* increment source address */
 			src = sg_phys(sg);
-		else
+#if 0
+			ctrl_sg &= ~COH901318_CX_CTRL_SRC_BUS_SIZE_MASK;
+			ctrl_chained &= ~COH901318_CX_CTRL_SRC_BUS_SIZE_MASK;
+			if (src & 0x01) {
+				pr_err("Aligned src buffer to 8bit access\n");
+				ctrl_sg |= COH901318_CX_CTRL_SRC_BUS_SIZE_8_BITS;
+				ctrl_chained |= COH901318_CX_CTRL_SRC_BUS_SIZE_8_BITS;
+			} else if (src & 0x02) {
+				pr_err("Aligned src buffer to 16bit access\n");
+				ctrl_sg |= COH901318_CX_CTRL_SRC_BUS_SIZE_16_BITS;
+				ctrl_chained |= COH901318_CX_CTRL_SRC_BUS_SIZE_16_BITS;
+			} else {
+				pr_err("Aligned src buffer to 32bit access\n");
+				ctrl_sg |= COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS;
+				ctrl_chained |= COH901318_CX_CTRL_SRC_BUS_SIZE_32_BITS;
+			}
+#endif
+		} else {
 			/* increment destination address */
 			dst =  sg_phys(sg);
+#if 0
+			ctrl_sg &= ~COH901318_CX_CTRL_DST_BUS_SIZE_MASK;
+			ctrl_chained &= ~COH901318_CX_CTRL_DST_BUS_SIZE_MASK;
+			if (dst & 0x01) {
+				pr_err("Aligned dst buffer to 8bit access\n");
+				ctrl_sg |= COH901318_CX_CTRL_DST_BUS_SIZE_8_BITS;
+				ctrl_chained |= COH901318_CX_CTRL_DST_BUS_SIZE_8_BITS;
+			} else if (dst & 0x02) {
+				pr_err("Aligned dst buffer to 16bit access\n");
+				ctrl_sg |= COH901318_CX_CTRL_DST_BUS_SIZE_16_BITS;
+				ctrl_chained |= COH901318_CX_CTRL_DST_BUS_SIZE_16_BITS;
+			} else {
+				pr_err("Aligned dst buffer to 32bit access\n");
+				ctrl_sg |= COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS;
+				ctrl_chained |= COH901318_CX_CTRL_DST_BUS_SIZE_32_BITS;
+			}
+#endif
+		}
 
 		bytes_to_transfer = sg_dma_len(sg);
 
-- 
1.6.3.3

