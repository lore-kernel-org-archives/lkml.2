Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2LPRZI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 12:25:08 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:43788 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab2LPRZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:25:00 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Katsuya MATSUBARA <matsu@igel.co.jp>,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH/WIP/RFC 11/14] shmobile-ipmmu: Store a struct shmobile_iommu_arch_data in archdata.iommu
Date: Sun, 16 Dec 2012 18:25:57 +0100
Message-Id: <1355678760-27357-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1350290093-998-1-git-send-email-hdk@igel.co.jp>
 <1355678760-27357-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/iommu/shmobile-iommu.c |   20 +++++++++++++++++---
 include/linux/sh_iommu.h       |   10 ++++++++--
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/shmobile-iommu.c b/drivers/iommu/shmobile-iommu.c
index 423993c..f27d842 100644
--- a/drivers/iommu/shmobile-iommu.c
+++ b/drivers/iommu/shmobile-iommu.c
@@ -308,25 +308,39 @@ static int shmobile_iommu_attach_all_devices(void)
 		ret = PTR_ERR(iommu_mapping);
 		goto err;
 	}
-	for (dev = ipmmu_devices; dev; dev = dev->archdata.iommu) {
+	for (dev = ipmmu_devices; dev; ) {
+		struct shmobile_iommu_arch_data *data = dev->archdata.iommu;
+
 		if (arm_iommu_attach_device(dev, iommu_mapping))
 			pr_err("arm_iommu_attach_device failed\n");
+
+		dev = data->next;
 	}
 err:
 	spin_unlock(&lock_add);
 	return 0;
 }
 
-void ipmmu_add_device(struct device *dev)
+int ipmmu_add_device(struct device *dev)
 {
+	struct shmobile_iommu_arch_data *data;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	dev->archdata.iommu = data;
+
 	spin_lock(&lock_add);
-	dev->archdata.iommu = ipmmu_devices;
+	data->next = ipmmu_devices;
 	ipmmu_devices = dev;
 	if (!IS_ERR_OR_NULL(iommu_mapping)) {
 		if (arm_iommu_attach_device(dev, iommu_mapping))
 			pr_err("arm_iommu_attach_device failed\n");
 	}
 	spin_unlock(&lock_add);
+
+	return 0;
 }
 
 int ipmmu_iommu_init(struct shmobile_ipmmu *ipmmu)
diff --git a/include/linux/sh_iommu.h b/include/linux/sh_iommu.h
index cc669a0..8b7b51d 100644
--- a/include/linux/sh_iommu.h
+++ b/include/linux/sh_iommu.h
@@ -1,10 +1,16 @@
 #ifndef __SH_IOMMU_H__
 #define __SH_IOMMU_H__
 
+struct device;
+
+struct shmobile_iommu_arch_data {
+	struct device *next;
+};
+
 #ifdef CONFIG_SHMOBILE_IPMMU_TLB
-void ipmmu_add_device(struct device *dev);
+int ipmmu_add_device(struct device *dev);
 #else
-static inline void ipmmu_add_device(struct device *dev)
+static inline int ipmmu_add_device(struct device *dev)
 {
 }
 #endif
-- 
1.7.8.6

