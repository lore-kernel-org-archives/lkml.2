Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab2LPRZG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:25:06 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43799 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab2LPRZC (ORCPT
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
Subject: [PATCH/WIP/RFC 13/14] shmobile-ipmmu: Remove unneeded lock_add spinlock
Date: Sun, 16 Dec 2012 18:25:59 +0100
Message-Id: <1355678760-27357-14-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1350290093-998-1-git-send-email-hdk@igel.co.jp>
 <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ipmmu_add_device() can never race with
shmobile_iommu_attach_all_devices(), called by ipmmu_iommu_init() as the
former is called from an arch initcall and the later from a subsys
initcall.

Remove the unneeded spinlock as well as the arm_iommu_attach_device() in
ipmmu_add_device(), as the condition that guards the call is always
false.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/iommu/shmobile-iommu.c |   18 +++---------------
 1 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/shmobile-iommu.c b/drivers/iommu/shmobile-iommu.c
index bf1d0a4..2592d25 100644
--- a/drivers/iommu/shmobile-iommu.c
+++ b/drivers/iommu/shmobile-iommu.c
@@ -51,7 +51,6 @@ static struct dma_iommu_mapping *iommu_mapping;
 static struct device *ipmmu_devices;
 static struct dma_pool *l1pool, *l2pool;
 static spinlock_t lock;
-static DEFINE_SPINLOCK(lock_add);
 static struct shmobile_iommu_domain *attached;
 static int num_attached_devices;
 
@@ -313,15 +312,12 @@ static struct iommu_ops shmobile_iommu_ops = {
 static int shmobile_iommu_attach_all_devices(struct shmobile_ipmmu *ipmmu)
 {
 	struct device *dev;
-	int ret = 0;
 
-	spin_lock(&lock_add);
 	iommu_mapping = arm_iommu_create_mapping(&platform_bus_type, 0x0,
 						 L1_LEN << 20, 0);
-	if (IS_ERR_OR_NULL(iommu_mapping)) {
-		ret = PTR_ERR(iommu_mapping);
-		goto err;
-	}
+	if (IS_ERR_OR_NULL(iommu_mapping))
+		return PTR_ERR(iommu_mapping);
+
 	for (dev = ipmmu_devices; dev; ) {
 		struct shmobile_iommu_arch_data *data = dev->archdata.iommu;
 
@@ -332,8 +328,6 @@ static int shmobile_iommu_attach_all_devices(struct shmobile_ipmmu *ipmmu)
 
 		dev = data->next;
 	}
-err:
-	spin_unlock(&lock_add);
 	return 0;
 }
 
@@ -347,14 +341,8 @@ int ipmmu_add_device(struct device *dev)
 
 	dev->archdata.iommu = data;
 
-	spin_lock(&lock_add);
 	data->next = ipmmu_devices;
 	ipmmu_devices = dev;
-	if (!IS_ERR_OR_NULL(iommu_mapping)) {
-		if (arm_iommu_attach_device(dev, iommu_mapping))
-			pr_err("arm_iommu_attach_device failed\n");
-	}
-	spin_unlock(&lock_add);
 
 	return 0;
 }
-- 
1.7.8.6

