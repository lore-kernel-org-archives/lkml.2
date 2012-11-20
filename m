Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2KTBHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:07:11 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54478 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab2KTBGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:06:11 -0500
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Joerg Roedel <joro@8bytes.org>
Cc: Russell King <linux@arm.linux.org.uk>, Ohad Ben-Cohen <ohad@wizery.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>, Ido Yariv <ido@wizery.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Walmsley <paul@pwsan.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH v5 2/5] iommu/omap: keep mmu enabled when requested
Date: Mon, 19 Nov 2012 19:05:49 -0600
Message-Id: <1353373552-16039-3-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353373552-16039-1-git-send-email-omar.luna@linaro.org>
References: <1353373552-16039-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of the mmu is to handle the memory accesses requested by
its users. Typically, the mmu is bundled with the processing unit in
a single IP block, which makes them to share the same clock to be
functional.

Currently, iommu code assumes that its user will be indirectly
clocking it, but being a separate mmu driver, it should handle
its own clocks, so as long as the mmu is requested it will be
powered ON and once detached it will be powered OFF.

The remaining clock handling out of iommu_enable and iommu_disable
corresponds to paths that can be accessed through debugfs, some of
them doesn't work if the module is not enabled first, but in future
if the mmu is idled withouth freeing, these are needed to debug.

Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 drivers/iommu/omap-iommu.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 6b1288c..f8082da 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -154,7 +154,6 @@ static int iommu_enable(struct omap_iommu *obj)
 
 	err = arch_iommu->enable(obj);
 
-	clk_disable(obj->clk);
 	return err;
 }
 
@@ -163,8 +162,6 @@ static void iommu_disable(struct omap_iommu *obj)
 	if (!obj)
 		return;
 
-	clk_enable(obj->clk);
-
 	arch_iommu->disable(obj);
 
 	clk_disable(obj->clk);
-- 
1.7.4.1

