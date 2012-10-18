Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2JRN1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:27:51 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50961 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab2JRN0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:26:05 -0400
From: Matt Porter <mporter@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>
Cc: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [RFC PATCH v3 11/16] mmc: omap_hsmmc: limit max_segs with the EDMA DMAC
Date: Thu, 18 Oct 2012 09:26:50 -0400
Message-Id: <1350566815-409-12-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350566815-409-1-git-send-email-mporter@ti.com>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EDMA DMAC has a hardware limitation that prevents supporting
scatter gather lists with any number of segments. Since the EDMA
DMA Engine driver sets the maximum segments to 16, we do the
same.

TODO: this will be replaced once the DMA Engine API supports an
API to query the DMAC's segment size limit.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 drivers/mmc/host/omap_hsmmc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index b327cd0..52bab01 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1828,6 +1828,16 @@ static int __devinit omap_hsmmc_probe(struct platform_device *pdev)
 	 * as we want. */
 	mmc->max_segs = 1024;
 
+	/* Eventually we should get our max_segs limitation for EDMA by
+	 * querying the dmaengine API */
+	if (pdev->dev.of_node) {
+		struct device_node *parent = pdev->dev.of_node->parent;
+		struct device_node *node;
+		node = of_find_node_by_name(parent, "edma");
+		if (node)
+			mmc->max_segs = 16;
+	}
+
 	mmc->max_blk_size = 512;       /* Block Length at max can be 1024 */
 	mmc->max_blk_count = 0xFFFF;    /* No. of Blocks is 16 bits */
 	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
-- 
1.7.9.5

