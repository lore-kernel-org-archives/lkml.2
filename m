Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab2LPRZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:25:04 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43780 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab2LPRZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:25:01 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH/WIP/RFC 12/14] shmobile-ipmmu: Store ipmmu pointer in iommu arch data and iommu domain
Date: Sun, 16 Dec 2012 18:25:58 +0100
Message-Id: <1355678760-27357-13-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1350290093-998-1-git-send-email-hdk@igel.co.jp>
 <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gets rid of the global ipmmu_access_device pointer.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/iommu/shmobile-iommu.c |   37 ++++++++++++++++++++++++++-----------
 include/linux/sh_iommu.h       |    2 ++
 2 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/shmobile-iommu.c b/drivers/iommu/shmobile-iommu.c
index f27d842..bf1d0a4 100644
--- a/drivers/iommu/shmobile-iommu.c
+++ b/drivers/iommu/shmobile-iommu.c
@@ -41,6 +41,7 @@ struct shmobile_iommu_domain_pgtable {
 };
 
 struct shmobile_iommu_domain {
+	struct shmobile_ipmmu *ipmmu;
 	struct shmobile_iommu_domain_pgtable l1, l2[L1_LEN];
 	spinlock_t map_lock;
 	atomic_t active;
@@ -53,7 +54,17 @@ static spinlock_t lock;
 static DEFINE_SPINLOCK(lock_add);
 static struct shmobile_iommu_domain *attached;
 static int num_attached_devices;
-static struct shmobile_ipmmu *ipmmu_access_device;
+
+/**
+ * dev_to_ipmmu() - retrieves an shmobile ipmmu object from a user device
+ * @dev: ipmmu client device
+ */
+static inline struct shmobile_ipmmu *dev_to_ipmmu(struct device *dev)
+{
+	struct shmobile_iommu_arch_data *arch_data = dev->archdata.iommu;
+
+	return arch_data->ipmmu;
+}
 
 static int shmobile_iommu_domain_init(struct iommu_domain *domain)
 {
@@ -97,6 +108,7 @@ static int shmobile_iommu_attach_device(struct iommu_domain *domain,
 					struct device *dev)
 {
 	struct shmobile_iommu_domain *sh_domain = domain->priv;
+	struct shmobile_ipmmu *ipmmu = dev_to_ipmmu(dev);
 	int ret = -EBUSY;
 
 	spin_lock(&lock);
@@ -104,12 +116,12 @@ static int shmobile_iommu_attach_device(struct iommu_domain *domain,
 		if (attached)
 			goto err;
 		atomic_set(&sh_domain->active, 1);
-		ipmmu_tlb_set(ipmmu_access_device, sh_domain->l1.handle, L1_SIZE,
-			      0);
+		ipmmu_tlb_set(ipmmu, sh_domain->l1.handle, L1_SIZE, 0);
 		wmb();
-		ipmmu_tlb_flush(ipmmu_access_device);
+		ipmmu_tlb_flush(ipmmu);
 		attached = sh_domain;
 		num_attached_devices = 0;
+		sh_domain->ipmmu = ipmmu;
 	}
 	num_attached_devices++;
 	ret = 0;
@@ -122,14 +134,16 @@ static void shmobile_iommu_detach_device(struct iommu_domain *domain,
 					 struct device *dev)
 {
 	struct shmobile_iommu_domain *sh_domain = domain->priv;
+	struct shmobile_ipmmu *ipmmu = dev_to_ipmmu(dev);
 
 	spin_lock(&lock);
 	atomic_set(&sh_domain->active, 0);
 	num_attached_devices--;
 	if (!num_attached_devices) {
-		ipmmu_tlb_set(ipmmu_access_device, 0, 0, 0);
-		ipmmu_tlb_flush(ipmmu_access_device);
+		ipmmu_tlb_set(ipmmu, 0, 0, 0);
+		ipmmu_tlb_flush(ipmmu);
 		attached = NULL;
+		sh_domain->ipmmu = NULL;
 	}
 	spin_unlock(&lock);
 }
@@ -208,7 +222,7 @@ static int shmobile_iommu_map(struct iommu_domain *domain, unsigned long iova,
 	}
 	if (!ret && atomic_read(&sh_domain->active)) {
 		wmb();
-		ipmmu_tlb_flush(ipmmu_access_device);
+		ipmmu_tlb_flush(sh_domain->ipmmu);
 		l2realfree(&l2);
 	}
 	return ret;
@@ -252,7 +266,7 @@ static size_t shmobile_iommu_unmap(struct iommu_domain *domain,
 done:
 	if (ret && atomic_read(&sh_domain->active)) {
 		wmb();
-		ipmmu_tlb_flush(ipmmu_access_device);
+		ipmmu_tlb_flush(sh_domain->ipmmu);
 		l2realfree(&l2);
 	}
 	return ret;
@@ -296,7 +310,7 @@ static struct iommu_ops shmobile_iommu_ops = {
 	.pgsize_bitmap = 0x111000,
 };
 
-static int shmobile_iommu_attach_all_devices(void)
+static int shmobile_iommu_attach_all_devices(struct shmobile_ipmmu *ipmmu)
 {
 	struct device *dev;
 	int ret = 0;
@@ -311,6 +325,8 @@ static int shmobile_iommu_attach_all_devices(void)
 	for (dev = ipmmu_devices; dev; ) {
 		struct shmobile_iommu_arch_data *data = dev->archdata.iommu;
 
+		data->ipmmu = ipmmu;
+
 		if (arm_iommu_attach_device(dev, iommu_mapping))
 			pr_err("arm_iommu_attach_device failed\n");
 
@@ -356,9 +372,8 @@ int ipmmu_iommu_init(struct shmobile_ipmmu *ipmmu)
 		goto nomem_pool2;
 	spin_lock_init(&lock);
 	attached = NULL;
-	ipmmu_access_device = ipmmu;
 	bus_set_iommu(&platform_bus_type, &shmobile_iommu_ops);
-	if (shmobile_iommu_attach_all_devices())
+	if (shmobile_iommu_attach_all_devices(ipmmu))
 		pr_err("shmobile_iommu_attach_all_devices failed\n");
 	return 0;
 nomem_pool2:
diff --git a/include/linux/sh_iommu.h b/include/linux/sh_iommu.h
index 8b7b51d..76b6e51 100644
--- a/include/linux/sh_iommu.h
+++ b/include/linux/sh_iommu.h
@@ -2,8 +2,10 @@
 #define __SH_IOMMU_H__
 
 struct device;
+struct shmobile_ipmmu;
 
 struct shmobile_iommu_arch_data {
+	struct shmobile_ipmmu *ipmmu;
 	struct device *next;
 };
 
-- 
1.7.8.6

