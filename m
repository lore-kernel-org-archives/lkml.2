Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760827Ab2ERGnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 02:43:50 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19087 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760229Ab2ERGnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 02:43:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 17 May 2012 23:42:14 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>, <joerg.roedel@amd.com>, <swarren@wwwdotorg.org>
CC: <iommu@lists.linux-foundation.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: [PATCH 1/1] iommu/tegra: smmu: Add DMA window parser
Date: Fri, 18 May 2012 09:43:09 +0300
Message-ID: <1337323393-1035-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20120518085051.4a0fca863c5ab37cf8d42cb1@nvidia.com>
References: <20120518085051.4a0fca863c5ab37cf8d42cb1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code was based on:
    "arch/microblaze/kernel/prom_parse.c"
    "arch/powerpc/kernel/prom_parse.c"

Can be promoted as a global function for general use.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
Based on the discussion:
http://marc.info/?l=linux-tegra&m=133732046606458&w=2
---
 drivers/iommu/tegra-smmu.c |   50 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 192fc4a..7fc444b 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -874,6 +874,56 @@ static struct iommu_ops smmu_iommu_ops = {
 	.pgsize_bitmap	= SMMU_IOMMU_PGSIZES,
 };
 
+static int of_get_dma_window(struct device_node *dn,
+			const char *propname, int index,
+			unsigned long *busno,
+			dma_addr_t *addr, size_t *size)
+{
+	const __be32 *dma_window, *end;
+	int bytes, cur_index = 0;
+
+	if (!dn || !addr || !size)
+		return -EINVAL;
+
+	if (!propname)
+		propname = "dma-window";
+
+	dma_window = of_get_property(dn, propname, &bytes);
+	if (!dma_window)
+		return -ENODEV;
+	end = dma_window + bytes / sizeof(*dma_window);
+
+	while (dma_window < end) {
+		u32 cells;
+		const void *prop;
+
+		/* busno is always one cell */
+		if (busno)
+			*busno = be32_to_cpup(dma_window++);
+
+		prop = of_get_property(dn, "#dma-address-cells", NULL);
+		if (!prop)
+			prop = of_get_property(dn, "#address-cells", NULL);
+
+		cells = prop ? be32_to_cpup(prop) : of_n_addr_cells(dn);
+		if (!cells)
+			return -EINVAL;
+		*addr = of_read_number(dma_window, cells);
+		dma_window += cells;
+
+		prop = of_get_property(dn, "#dma-size-cells", NULL);
+		cells = prop ? be32_to_cpup(prop) : of_n_size_cells(dn);
+		if (!cells)
+			return -EINVAL;
+		*size = of_read_number(dma_window, cells);
+		dma_window += cells;
+
+		if (cur_index++ == index)
+			break;
+	}
+	return 0;
+}
+
 static int tegra_smmu_suspend(struct device *dev)
 {
 	struct smmu_device *smmu = dev_get_drvdata(dev);
-- 
1.7.5.4

