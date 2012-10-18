Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab2JRNaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:30:18 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33242 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab2JRNZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:25:52 -0400
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
Subject: [RFC PATCH v3 05/16] ARM: edma: add AM33XX crossbar event support
Date: Thu, 18 Oct 2012 09:26:44 -0400
Message-Id: <1350566815-409-6-git-send-email-mporter@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350566815-409-1-git-send-email-mporter@ti.com>
References: <1350566815-409-1-git-send-email-mporter@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for the per-EDMA channel event mux. This is required
for any peripherals using DMA crossbar mapped events.

Signed-off-by: Matt Porter <mporter@ti.com>
---
 arch/arm/common/edma.c             |   63 +++++++++++++++++++++++++++++++++++-
 include/linux/platform_data/edma.h |    1 +
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 6d2a590..b761b7a 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -1425,6 +1425,53 @@ static int edma_of_read_u32_to_s16_array(const struct device_node *np,
 	return 0;
 }
 
+static int edma_xbar_event_map(struct device *dev,
+			       struct device_node *node,
+			       struct edma_soc_info *pdata, int len)
+{
+	int ret = 0;
+	int i;
+	struct resource res;
+	void *xbar;
+	s16 (*xbar_chans)[2];
+	u32 shift, offset, mux;
+
+	xbar_chans = devm_kzalloc(dev,
+				  len/sizeof(s16) + 2*sizeof(s16),
+				  GFP_KERNEL);
+	if (!xbar_chans)
+		return -ENOMEM;
+
+	ret = of_address_to_resource(node, 1, &res);
+	if (IS_ERR_VALUE(ret))
+		return -EIO;
+
+	xbar = devm_ioremap(dev, res.start, resource_size(&res));
+	if (!xbar)
+		return -EIO;
+
+	ret = edma_of_read_u32_to_s16_array(node,
+					    "ti,edma-xbar-event-map",
+					    (s16 *)xbar_chans,
+					    len/sizeof(u32));
+	if (IS_ERR_VALUE(ret))
+		return -EIO;
+
+	for (i = 0; xbar_chans[i][0] != -1; i++) {
+		shift = (xbar_chans[i][1] % 4) * 8;
+		offset = xbar_chans[i][1] >> 2;
+		offset <<= 2;
+		mux = __raw_readl((void *)((u32)xbar + offset));
+		mux &= (~(0xff << shift));
+		mux |= (xbar_chans[i][0] << shift);
+		__raw_writel(mux, (void *)((u32)xbar + offset));
+	}
+
+	pdata->xbar_chans = xbar_chans;
+
+	return 0;
+}
+
 static int edma_of_parse_dt(struct device *dev,
 			    struct device_node *node,
 			    struct edma_soc_info *pdata)
@@ -1453,7 +1500,6 @@ static int edma_of_parse_dt(struct device *dev,
 	pdata->n_slot = value;
 
 	pdata->n_cc = 1;
-	/* This is unused */
 	pdata->n_tc = 3;
 
 	rsv_info =
@@ -1538,6 +1584,10 @@ static int edma_of_parse_dt(struct device *dev,
 		return ret;
 	pdata->default_queue = value;
 
+	prop = of_find_property(node, "ti,edma-xbar-event-map", &sz);
+	if (prop)
+		ret = edma_xbar_event_map(dev, node, pdata, sz);
+
 	return ret;
 }
 
@@ -1554,6 +1604,7 @@ static int __init edma_probe(struct platform_device *pdev)
 	int			status = -1;
 	s16			(*rsv_chans)[2];
 	s16			(*rsv_slots)[2];
+	s16			(*xbar_chans)[2];
 	int			irq[EDMA_MAX_CC] = {0, 0};
 	int			err_irq[EDMA_MAX_CC] = {0, 0};
 	struct resource		*r[EDMA_MAX_CC] = {NULL, NULL};
@@ -1678,6 +1729,16 @@ static int __init edma_probe(struct platform_device *pdev)
 			}
 		}
 
+		/* Clear the xbar mapped channels in unused list */
+		xbar_chans = info[j]->xbar_chans;
+		if (xbar_chans) {
+			for (i = 0; xbar_chans[i][1] != -1; i++) {
+				off = xbar_chans[i][1];
+				clear_bits(off, 1,
+					edma_cc[j]->edma_unused);
+			}
+		}
+
 		if (node)
 			irq[j] = irq_of_parse_and_map(node, 0);
 		else {
diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
index b20b586..888a3c6 100644
--- a/include/linux/platform_data/edma.h
+++ b/include/linux/platform_data/edma.h
@@ -191,6 +191,7 @@ struct edma_soc_info {
 	/* Resource reservation for other cores */
 	struct edma_rsv_info	*rsv;
 
+	s16	(*xbar_chans)[2];
 	s8	(*queue_tc_mapping)[2];
 	s8	(*queue_priority_mapping)[2];
 };
-- 
1.7.9.5

