Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab1LVJTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 04:19:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:25177 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab1LVJS5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 04:18:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="88433007"
From: "Hao, Xudong" <xudong.hao@intel.com>
To: Chris Wright <chrisw@sous-sol.org>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Thu, 22 Dec 2011 17:17:42 +0800
Subject: [PATCH v2] intel-iommu: Add device info into list before doing
 context mapping
Thread-Topic: [PATCH v2] intel-iommu: Add device info into list before doing
 context mapping
Thread-Index: AczAiGvqkE33aB24TxWfj60400kzKw==
Message-ID: <BC00F5384FCFC9499AF06F92E8B78A9E28907BAB30@shsmsx502.ccr.corp.intel.com>
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

Add device info into list before do context mapping, because device info will be used by iommu_enable_dev_iotlb function, in this function, pci_enable_ats would not be called without this patch.

Signed-off-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/iommu/intel-iommu.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c index bdc447f..ccf347f 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2267,12 +2267,6 @@ static int domain_add_dev_info(struct dmar_domain *domain,
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
@@ -2285,6 +2279,17 @@ static int domain_add_dev_info(struct dmar_domain *domain,
 	pdev->dev.archdata.iommu = info;
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 
+	ret = domain_context_mapping(domain, pdev, translation);
+	if (ret) {
+		spin_lock_irqsave(&device_domain_lock, flags);
+		list_del(&info->link);
+		list_del(&info->global);
+		pdev->dev.archdata.iommu = NULL;
+		spin_unlock_irqrestore(&device_domain_lock, flags);
+		free_devinfo_mem(info);
+		return ret;
+	}
+
 	return 0;
 }
 
--
1.6.0.rc1

