Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2DCCUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:20:25 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21898 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab2DCCUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:20:21 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 08/14] IOMMU: iommu_unique_seq_id()
Date: Mon,  2 Apr 2012 19:19:35 -0700
Message-Id: <1333419581-7836-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
References: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090202.4F7A5E4C.0066,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So for hot-remove/hot-add will reuse seq_id.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/iommu/dmar.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index fde4991..043192e 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -707,13 +707,23 @@ int __init detect_intel_iommu(void)
 	return ret ? 1 : -ENODEV;
 }
 
+static DECLARE_BITMAP(iommu_allocated, 1024);
+
+static int iommu_unique_seq_id(void)
+{
+	int id;
+
+	id = find_first_zero_bit(iommu_allocated, 1024);
+	__set_bit(id, iommu_allocated);
+
+	return id;
+}
 
 int alloc_iommu(struct dmar_drhd_unit *drhd)
 {
 	struct intel_iommu *iommu;
 	int map_size;
 	u32 ver;
-	static int iommu_allocated = 0;
 	int agaw = 0;
 	int msagaw = 0;
 
@@ -726,7 +736,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 	if (!iommu)
 		return -ENOMEM;
 
-	iommu->seq_id = iommu_allocated++;
+	iommu->seq_id = iommu_unique_seq_id();
 	sprintf (iommu->name, "dmar%d", iommu->seq_id);
 
 	iommu->reg = ioremap(drhd->reg_base_addr, VTD_PAGE_SIZE);
@@ -790,6 +800,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
  err_unmap:
 	iounmap(iommu->reg);
  error:
+	__clear_bit(iommu->seq_id, iommu_allocated);
 	kfree(iommu);
 	return -1;
 }
@@ -803,6 +814,7 @@ void free_iommu(struct intel_iommu *iommu)
 
 	if (iommu->reg)
 		iounmap(iommu->reg);
+	__clear_bit(iommu->seq_id, iommu_allocated);
 	kfree(iommu);
 }
 
-- 
1.7.7

