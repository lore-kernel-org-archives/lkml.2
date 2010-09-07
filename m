Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab0IGHqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 03:46:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:16925 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab0IGHqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 03:46:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,327,1280732400"; 
   d="scan'208";a="552214229"
Date: Tue, 7 Sep 2010 15:27:27 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Feng Tang <feng.tang@intel.com>, George Shore <george@georgeshore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] dw_spi: Allow interrupt sharing
Message-ID: <20100907072727.GA2152@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow interrupt sharing since exclusive interrupt line for
DW SPI controller is not provided on every platform.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
---
 drivers/spi/dw_spi.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/dw_spi.c b/drivers/spi/dw_spi.c
index d256cb0..11fbbf6 100644
--- a/drivers/spi/dw_spi.c
+++ b/drivers/spi/dw_spi.c
@@ -396,6 +396,11 @@ static irqreturn_t interrupt_transfer(struct dw_spi *dws)
 static irqreturn_t dw_spi_irq(int irq, void *dev_id)
 {
 	struct dw_spi *dws = dev_id;
+	u16 irq_status, irq_mask = 0x3f;
+
+	irq_status = dw_readw(dws, isr) & irq_mask;
+	if (!irq_status)
+		return IRQ_NONE;
 
 	if (!dws->cur_msg) {
 		spi_mask_intr(dws, SPI_INT_TXEI);
@@ -883,7 +888,7 @@ int __devinit dw_spi_add_host(struct dw_spi *dws)
 	dws->dma_inited = 0;
 	dws->dma_addr = (dma_addr_t)(dws->paddr + 0x60);
 
-	ret = request_irq(dws->irq, dw_spi_irq, 0,
+	ret = request_irq(dws->irq, dw_spi_irq, IRQF_SHARED,
 			"dw_spi", dws);
 	if (ret < 0) {
 		dev_err(&master->dev, "can not get IRQ\n");
-- 
1.5.5.1

