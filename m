Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066Ab2LPRZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:25:10 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43780 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab2LPRZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:25:02 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH/WIP/RFC 14/14] shmobile-ipmmu: Store iommu_mapping in struct shmobile_ipmmu
Date: Sun, 16 Dec 2012 18:26:00 +0100
Message-Id: <1355678760-27357-15-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1350290093-998-1-git-send-email-hdk@igel.co.jp>
 <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And remove the global iommu_mapping variable.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/iommu/shmobile-iommu.c |   14 ++++++++------
 drivers/iommu/shmobile-ipmmu.h |    4 ++++
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/shmobile-iommu.c b/drivers/iommu/shmobile-iommu.c
index 2592d25..8cf45df 100644
--- a/drivers/iommu/shmobile-iommu.c
+++ b/drivers/iommu/shmobile-iommu.c
@@ -47,7 +47,6 @@ struct shmobile_iommu_domain {
 	atomic_t active;
 };
 
-static struct dma_iommu_mapping *iommu_mapping;
 static struct device *ipmmu_devices;
 static struct dma_pool *l1pool, *l2pool;
 static spinlock_t lock;
@@ -311,19 +310,22 @@ static struct iommu_ops shmobile_iommu_ops = {
 
 static int shmobile_iommu_attach_all_devices(struct shmobile_ipmmu *ipmmu)
 {
+	struct dma_iommu_mapping *mapping;
 	struct device *dev;
 
-	iommu_mapping = arm_iommu_create_mapping(&platform_bus_type, 0x0,
-						 L1_LEN << 20, 0);
-	if (IS_ERR_OR_NULL(iommu_mapping))
-		return PTR_ERR(iommu_mapping);
+	mapping = arm_iommu_create_mapping(&platform_bus_type, 0,
+					   L1_LEN << 20, 0);
+	if (IS_ERR(mapping))
+		return PTR_ERR(mapping);
+
+	ipmmu->iommu_mapping = mapping;
 
 	for (dev = ipmmu_devices; dev; ) {
 		struct shmobile_iommu_arch_data *data = dev->archdata.iommu;
 
 		data->ipmmu = ipmmu;
 
-		if (arm_iommu_attach_device(dev, iommu_mapping))
+		if (arm_iommu_attach_device(dev, mapping))
 			pr_err("arm_iommu_attach_device failed\n");
 
 		dev = data->next;
diff --git a/drivers/iommu/shmobile-ipmmu.h b/drivers/iommu/shmobile-ipmmu.h
index 1458a97..f8f0f57 100644
--- a/drivers/iommu/shmobile-ipmmu.h
+++ b/drivers/iommu/shmobile-ipmmu.h
@@ -1,11 +1,15 @@
 #ifndef __SHMOBILE_IPMMU_H__
 #define __SHMOBILE_IPMMU_H__
 
+struct dma_iommu_mapping;
+
 struct shmobile_ipmmu {
 	struct device *dev;
 	void __iomem *ipmmu_base;
 	int tlb_enabled;
 	struct mutex flush_lock;
+
+	struct dma_iommu_mapping *iommu_mapping;
 };
 
 #ifdef CONFIG_SHMOBILE_IPMMU_TLB
-- 
1.7.8.6

