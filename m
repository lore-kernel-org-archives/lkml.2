Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab2ENSM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:12:27 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14111 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444Ab2ENSMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:12:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 14 May 2012 11:12:22 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bharat Nihalani <bnihalani@nvidia.com>,
        Vandana Salve <vsalve@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] iommu/tegra: gart: Reserve iomem resource
Date: Mon, 14 May 2012 21:12:03 +0300
Message-ID: <1337019127-6863-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337019127-6863-1-git-send-email-hdoyu@nvidia.com>
References: <1337019127-6863-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GART Register/Aperture range should be reserved.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 drivers/iommu/tegra-gart.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index 33a23b6..a431006 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -366,12 +366,18 @@ static int tegra_gart_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	gart_regs = devm_ioremap(dev, res->start, resource_size(res));
+	gart_regs = devm_request_and_ioremap(dev, res);
 	if (!gart_regs) {
 		dev_err(dev, "failed to remap GART registers\n");
 		return -ENXIO;
 	}
 
+	if (!devm_request_mem_region(dev, res_remap->start,
+				     resource_size(res_remap), dev_name(dev))) {
+		dev_err(dev, "failed to reserve GART aperture\n");
+		return -EBUSY;
+	}
+
 	gart->dev = &pdev->dev;
 	spin_lock_init(&gart->pte_lock);
 	spin_lock_init(&gart->client_lock);
-- 
1.7.5.4

