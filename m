Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab1LQNGl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 08:06:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:40284 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab1LQNGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 08:06:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="97366534"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Date: Sat, 17 Dec 2011 21:06:30 +0800
Subject: [PATCH] intel-iommu: Add device info into list before doing context
 mapping
Thread-Topic: [PATCH] intel-iommu: Add device info into list before doing
 context mapping
Thread-Index: Acy8u746aXLTiGjsR8aCXu7ZvAWHAA==
Message-ID: <BC00F5384FCFC9499AF06F92E8B78A9E2890486DD3@shsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add device info into list before do context mapping. Because device info will be used by iommu_enable_dev_iotlb function, in this function, pci_enable_ats would not be called without this patch, so ATS did not enable while a PCI device which has ATS capability is assigned to a guest.

Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
---
 drivers/iommu/intel-iommu.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c0c7820..f0b5d38 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2264,12 +2264,6 @@ static int domain_add_dev_info(struct dmar_domain *domain,
 	if (!info)
 		return -ENOMEM;
 
-	ret = domain_context_mapping(domain, pdev, translation);
-	if (ret) {
-		free_devinfo_mem(info);
-		return ret;
-	}
-
 	info->segment = pci_domain_nr(pdev->bus);
 	info->bus = pdev->bus->number;
 	info->devfn = pdev->devfn;
@@ -2282,6 +2276,14 @@ static int domain_add_dev_info(struct dmar_domain *domain,
 	pdev->dev.archdata.iommu = info;
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 
+	ret = domain_context_mapping(domain, pdev, translation);
+	if (ret) {
+		list_del(&info->link);
+		list_del(&info->global);
+		free_devinfo_mem(info);
+		return ret;
+	}
+
 	return 0;
 }
