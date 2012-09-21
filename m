Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab2IUMHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 08:07:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:55548 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab2IUMF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 08:05:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,462,1344236400"; 
   d="scan'208";a="224857177"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 2/6] dw_dmac: fill optional encoded parameters in register structure
Date: Fri, 21 Sep 2012 15:05:45 +0300
Message-Id: <1348229149-29040-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1348229149-29040-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a block of the registers that are optional. However, if enabled they
contain useful information about the controller hardware configuration. We will
use this piece of data to autoconfigure the driver.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac_regs.h |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index f6d92d7..8a3a81a 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -82,9 +82,39 @@ struct dw_dma_regs {
 	DW_REG(ID);
 	DW_REG(TEST);
 
+	/* reserved */
+	DW_REG(__reserved0);
+	DW_REG(__reserved1);
+
 	/* optional encoded params, 0x3c8..0x3f7 */
+	u32	__reserved;
+
+	/* per-channel configuration registers */
+	u32	DWC_PARAMS[DW_DMA_MAX_NR_CHANNELS];
+	u32	MULTI_BLK_TYPE;
+	u32	MAX_BLK_SIZE;
+
+	/* top-level parameters */
+	u32	DW_PARAMS;
 };
 
+/* To access the registers in early stage of probe */
+#define dma_read_byaddr(addr, name) \
+	readl((addr) + offsetof(struct dw_dma_regs, name))
+
+/* Bitfields in DW_PARAMS */
+#define DW_PARAMS_NR_CHAN	8		/* number of channels */
+#define DW_PARAMS_NR_MASTER	11		/* number of AHB masters */
+#define DW_PARAMS_DATA_WIDTH(n)	(15 + 2 * (n))
+#define DW_PARAMS_DATA_WIDTH1	15		/* master 1 data width */
+#define DW_PARAMS_DATA_WIDTH2	17		/* master 2 data width */
+#define DW_PARAMS_DATA_WIDTH3	19		/* master 3 data width */
+#define DW_PARAMS_DATA_WIDTH4	21		/* master 4 data width */
+#define DW_PARAMS_EN		28		/* encoded parameters */
+
+/* Bitfields in DWC_PARAMS */
+#define DWC_PARAMS_MBLK_EN	11		/* multi block transfer */
+
 /* Bitfields in CTL_LO */
 #define DWC_CTLL_INT_EN		(1 << 0)	/* irqs enabled? */
 #define DWC_CTLL_DST_WIDTH(n)	((n)<<1)	/* bytes per element */
-- 
1.7.10.4

