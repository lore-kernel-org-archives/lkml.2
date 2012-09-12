Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab2ILTrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 15:47:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58001 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab2ILTqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:46:13 -0400
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Joerg Roedel <joerg.roedel@amd.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Subject: [PATCH v2 6/9] ARM: OMAP: iommu: pm runtime save and restore context
Date: Wed, 12 Sep 2012 14:45:49 -0500
Message-Id: <1347479152-588-7-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
References: <1347479152-588-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save and restore context during pm runtime transitions.

For now, the previous API for this purpose will trigger
pm runtime functions, and will be left as exported symbol
for compatibility with it's only user.

Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 drivers/iommu/omap-iommu.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 20ae946..c4de9a9 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -97,7 +97,7 @@ void omap_iommu_save_ctx(struct device *dev)
 {
 	struct omap_iommu *obj = dev_to_omap_iommu(dev);
 
-	arch_iommu->save_ctx(obj);
+	pm_runtime_put_sync(obj->dev);
 }
 EXPORT_SYMBOL_GPL(omap_iommu_save_ctx);
 
@@ -109,7 +109,7 @@ void omap_iommu_restore_ctx(struct device *dev)
 {
 	struct omap_iommu *obj = dev_to_omap_iommu(dev);
 
-	arch_iommu->restore_ctx(obj);
+	pm_runtime_get_sync(obj->dev);
 }
 EXPORT_SYMBOL_GPL(omap_iommu_restore_ctx);
 
@@ -1001,11 +1001,36 @@ static int __devexit omap_iommu_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int omap_iommu_runtime_suspend(struct device *dev)
+{
+	struct omap_iommu *obj = to_iommu(dev);
+
+	arch_iommu->save_ctx(obj);
+
+	return 0;
+}
+
+static int omap_iommu_runtime_resume(struct device *dev)
+{
+	struct omap_iommu *obj = to_iommu(dev);
+
+	arch_iommu->restore_ctx(obj);
+
+	return 0;
+}
+
+static const struct dev_pm_ops iommu_pm_ops = {
+	SET_RUNTIME_PM_OPS(omap_iommu_runtime_suspend,
+			   omap_iommu_runtime_resume,
+			   NULL)
+};
+
 static struct platform_driver omap_iommu_driver = {
 	.probe	= omap_iommu_probe,
 	.remove	= __devexit_p(omap_iommu_remove),
 	.driver	= {
 		.name	= "omap-iommu",
+		.pm	= &iommu_pm_ops,
 	},
 };
 
-- 
1.7.9.5

