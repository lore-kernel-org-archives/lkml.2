Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab2FSKei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:34:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:45792 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135Ab2FSKee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:34:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167444376"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 08/10] dw_dmac: introduce dwc_fast_fls()
Date: Tue, 19 Jun 2012 13:34:08 +0300
Message-Id: <1340102050-12697-9-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were three places where such function is used. We still avoid to use
native fls() because in one case it requires to use 64bit version which is
suboptimal in our case.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |   46 ++++++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 42cffe8..9c47279 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -193,6 +193,21 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
 
 /*----------------------------------------------------------------------*/
 
+static inline unsigned int dwc_fast_fls(unsigned long long v)
+{
+	/*
+	 * We can be a lot more clever here, but this should take care
+	 * of the most common optimization.
+	 */
+	if (!(v & 7))
+		return 3;
+	else if (!(v & 3))
+		return 2;
+	else if (!(v & 1))
+		return 1;
+	return 0;
+}
+
 static void dwc_dump_chan_regs(struct dw_dma_chan *dwc)
 {
 	dev_err(chan2dev(&dwc->chan),
@@ -643,18 +658,7 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		return NULL;
 	}
 
-	/*
-	 * We can be a lot more clever here, but this should take care
-	 * of the most common optimization.
-	 */
-	if (!((src | dest  | len) & 7))
-		src_width = dst_width = 3;
-	else if (!((src | dest  | len) & 3))
-		src_width = dst_width = 2;
-	else if (!((src | dest | len) & 1))
-		src_width = dst_width = 1;
-	else
-		src_width = dst_width = 0;
+	src_width = dst_width = dwc_fast_fls(src | dest | len);
 
 	ctllo = DWC_DEFAULT_CTLLO(chan)
 			| DWC_CTLL_DST_WIDTH(dst_width)
@@ -754,14 +758,7 @@ dwc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
-			if (!((mem | len) & 7))
-				mem_width = 3;
-			else if (!((mem | len) & 3))
-				mem_width = 2;
-			else if (!((mem | len) & 1))
-				mem_width = 1;
-			else
-				mem_width = 0;
+			mem_width = dwc_fast_fls(mem | len);
 
 slave_sg_todev_fill_desc:
 			desc = dwc_desc_get(dwc);
@@ -821,14 +818,7 @@ slave_sg_todev_fill_desc:
 			mem = sg_dma_address(sg);
 			len = sg_dma_len(sg);
 
-			if (!((mem | len) & 7))
-				mem_width = 3;
-			else if (!((mem | len) & 3))
-				mem_width = 2;
-			else if (!((mem | len) & 1))
-				mem_width = 1;
-			else
-				mem_width = 0;
+			mem_width = dwc_fast_fls(mem | len);
 
 slave_sg_fromdev_fill_desc:
 			desc = dwc_desc_get(dwc);
-- 
1.7.10

