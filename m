Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab2JAKHM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:07:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:35823 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab2JAKHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:07:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,515,1344236400"; 
   d="scan'208";a="228988470"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: viresh.kumar@linaro.org, Vinod Koul <vinod.koul@intel.com>,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dw_dmac: fix a regression in dwc_prep_dma_memcpy
Date: Mon,  1 Oct 2012 13:06:25 +0300
Message-Id: <1349085985-1128-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes memory-to-memory test is failed, that's why we need to choose minimum
data portion between source and destination limits together.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 9ca9ca4..c4b0eb3 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -716,6 +716,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	size_t			offset;
 	unsigned int		src_width;
 	unsigned int		dst_width;
+	unsigned int		data_width;
 	u32			ctllo;
 
 	dev_vdbg(chan2dev(chan),
@@ -728,11 +729,11 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		return NULL;
 	}
 
-	src_width = min_t(unsigned int, dwc->dw->data_width[dwc_get_sms(dws)],
-			  dwc_fast_fls(src | len));
+	data_width = min_t(unsigned int, dwc->dw->data_width[dwc_get_sms(dws)],
+					 dwc->dw->data_width[dwc_get_dms(dws)]);
 
-	dst_width = min_t(unsigned int, dwc->dw->data_width[dwc_get_dms(dws)],
-			  dwc_fast_fls(dest | len));
+	src_width = dst_width = min_t(unsigned int, data_width,
+				      dwc_fast_fls(src | dest | len));
 
 	ctllo = DWC_DEFAULT_CTLLO(chan)
 			| DWC_CTLL_DST_WIDTH(dst_width)
-- 
1.7.10.4

