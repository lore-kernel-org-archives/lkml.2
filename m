Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab2FSKec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:34:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:45792 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989Ab2FSKea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:34:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167444355"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 02/10] dw_dmac: use proper casting to print dma_addr_t values
Date: Tue, 19 Jun 2012 13:34:02 +0300
Message-Id: <1340102050-12697-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1339743913-6236-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1340102050-12697-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_addr_t is sometimes 32 bit and sometimes 64. We normally cast them to
unsigned long long for printk().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index adbc616..45861b6 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -339,7 +339,8 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 		return;
 	}
 
-	dev_vdbg(chan2dev(&dwc->chan), "scan_descriptors: llp=0x%x\n", llp);
+	dev_vdbg(chan2dev(&dwc->chan), "scan_descriptors: llp=0x%llx\n",
+			(unsigned long long)llp);
 
 	list_for_each_entry_safe(desc, _desc, &dwc->active_list, desc_node) {
 		/* check first descriptors addr */
@@ -389,8 +390,10 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
 static void dwc_dump_lli(struct dw_dma_chan *dwc, struct dw_lli *lli)
 {
 	dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
-			"  desc: s0x%x d0x%x l0x%x c0x%x:%x\n",
-			lli->sar, lli->dar, lli->llp,
+			"  desc: s0x%llx d0x%llx l0x%llx c0x%x:%x\n",
+			(unsigned long long)lli->sar,
+			(unsigned long long)lli->dar,
+			(unsigned long long)lli->llp,
 			lli->ctlhi, lli->ctllo);
 }
 
@@ -629,8 +632,10 @@ dwc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	unsigned int		dst_width;
 	u32			ctllo;
 
-	dev_vdbg(chan2dev(chan), "prep_dma_memcpy d0x%x s0x%x l0x%zx f0x%lx\n",
-			dest, src, len, flags);
+	dev_vdbg(chan2dev(chan),
+			"prep_dma_memcpy d0x%llx s0x%llx l0x%zx f0x%lx\n",
+			(unsigned long long)dest, (unsigned long long)src,
+			len, flags);
 
 	if (unlikely(!len)) {
 		dev_dbg(chan2dev(chan), "prep_dma_memcpy: length is zero!\n");
@@ -1310,9 +1315,9 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 	dma_sync_single_for_device(chan2parent(chan), last->txd.phys,
 			sizeof(last->lli), DMA_TO_DEVICE);
 
-	dev_dbg(chan2dev(&dwc->chan), "cyclic prepared buf 0x%08x len %zu "
-			"period %zu periods %d\n", buf_addr, buf_len,
-			period_len, periods);
+	dev_dbg(chan2dev(&dwc->chan), "cyclic prepared buf 0x%llx len %zu "
+			"period %zu periods %d\n", (unsigned long long)buf_addr,
+			buf_len, period_len, periods);
 
 	cdesc->periods = periods;
 	dwc->cdesc = cdesc;
-- 
1.7.10

