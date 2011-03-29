Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab1C2XgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:36:09 -0400
Received: from relay1.sgi.com ([192.48.179.29]:41805 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752123Ab1C2XgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:36:04 -0400
Message-Id: <20110329233602.585251738@gulag1.americas.sgi.com>
References: <20110329233602.272459647@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Mar 2011 18:36:04 -0500
From: Mike Travis <travis@sgi.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Mike Habeck <habeck@sgi.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] Intel iommu: Speed up processing of the identity_mapping function
Content-Disposition: inline; filename=speed-up-iommu_no_mapping
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    On Nahelem systems, there are 43 Host Bridges exposed to the kernel
    for each System Socket.  With a large socket count, and the pass
    through option for iommu is set, too much time is spent in the
    identity_mapping function, hunting though the iommu domains to
    check if a specific device is "identity mapped".

    Speed up the function by setting an "is_identity_mapped" flag in
    the pci_dev struct, if this device is mapped to the static identity
    domain.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 drivers/pci/intel-iommu.c |   11 +++++------
 include/linux/pci.h       |    1 +
 2 files changed, 6 insertions(+), 6 deletions(-)

--- linux.orig/drivers/pci/intel-iommu.c
+++ linux/drivers/pci/intel-iommu.c
@@ -2102,11 +2102,7 @@ static int identity_mapping(struct pci_d
 	if (likely(!iommu_identity_mapping))
 		return 0;
 
-
-	list_for_each_entry(info, &si_domain->devices, link)
-		if (info->dev == pdev)
-			return 1;
-	return 0;
+	return pdev->is_identity_mapped;
 }
 
 static int domain_add_dev_info(struct dmar_domain *domain,
@@ -2138,6 +2134,7 @@ static int domain_add_dev_info(struct dm
 	list_add(&info->global, &device_domain_list);
 	pdev->dev.archdata.iommu = info;
 	spin_unlock_irqrestore(&device_domain_lock, flags);
+	pdev->is_identity_mapped = (domain == si_domain);
 
 	return 0;
 }
@@ -3404,8 +3401,10 @@ static void domain_remove_one_dev_info(s
 		 * update iommu count and coherency
 		 */
 		if (iommu == device_to_iommu(info->segment, info->bus,
-					    info->devfn))
+					    info->devfn)) {
 			found = 1;
+			pdev->is_identity_mapped = 0;
+		}
 	}
 
 	if (found == 0) {
--- linux.orig/include/linux/pci.h
+++ linux/include/linux/pci.h
@@ -314,6 +314,7 @@ struct pci_dev {
 	unsigned int	is_virtfn:1;
 	unsigned int	reset_fn:1;
 	unsigned int    is_hotplug_bridge:1;
+	unsigned int	is_identity_mapped:1;
 	unsigned int    __aer_firmware_first_valid:1;
 	unsigned int	__aer_firmware_first:1;
 	pci_dev_flags_t dev_flags;

-- 
