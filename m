Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab0DSVkh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:40:37 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:32806 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab0DSVkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:40:36 -0400
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.52,237,1270425600"; 
   d="scan'208";a="219505617"
Date: Mon, 19 Apr 2010 14:37:46 -0700
From: "Tom Lyon" <pugs@cisco.com>
To: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       joerg.roedel@amd.com, chrisw@sous-sol.org, dwmw2@infradead.org
Subject: [PATCH v3] drivers/pci/intel-iommu.c: intel_iommu_map_range
 failed at very end of address space
Message-ID: <4bcccd2a.zyBgqiTSz4Hheg4k%pugs@cisco.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Bug: intel_iommu_map_range didn't allow allocation at the very
end of the address space.
	Signed-off-by: Tom Lyon <pugs@cisco.com>
---
V1 and V2 of this patch were patch of a larger patch, this is now independent.

--- linux-2.6.33/drivers/pci/intel-iommu.c	2010-02-24 10:52:17.000000000 -0800
+++ mylinux-2.6.33/drivers/pci/intel-iommu.c	2010-04-13 16:51:55.000000000 -0700
@@ -3632,7 +3631,6 @@ static int intel_iommu_map_range(struct
 {
 	struct dmar_domain *dmar_domain = domain->priv;
 	u64 max_addr;
-	int addr_width;
 	int prot = 0;
 	int ret;
 
@@ -3645,18 +3643,14 @@ static int intel_iommu_map_range(struct
 
 	max_addr = iova + size;
 	if (dmar_domain->max_addr < max_addr) {
-		int min_agaw;
 		u64 end;
 
 		/* check if minimum agaw is sufficient for mapped address */
-		min_agaw = vm_domain_min_agaw(dmar_domain);
-		addr_width = agaw_to_width(min_agaw);
-		end = DOMAIN_MAX_ADDR(addr_width);
-		end = end & VTD_PAGE_MASK;
+		end = __DOMAIN_MAX_ADDR(dmar_domain->gaw) + 1;
 		if (end < max_addr) {
-			printk(KERN_ERR "%s: iommu agaw (%d) is not "
+			printk(KERN_ERR "%s: iommu width (%d) is not "
 			       "sufficient for the mapped address (%llx)\n",
-			       __func__, min_agaw, max_addr);
+			       __func__, dmar_domain->gaw, max_addr);
 			return -EFAULT;
 		}
 		dmar_domain->max_addr = max_addr;
