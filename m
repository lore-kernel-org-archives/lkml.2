Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab0F3WzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:55:17 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:57371 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0F3WzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:55:15 -0400
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,515,1272844800"; 
   d="scan'208";a="228800825"
Date: Wed, 30 Jun 2010 15:51:37 -0700
From: "Tom Lyon" <pugs@cisco.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, chrisw@sous-sol.org, mst@redhat.com,
       dwmw2@infradead.org, joerg.roedel@amd.com
Cc: aafabbri@cisco.com, scofeldm@cisco.com
Subject: [PATCH] 2.6.34: simple IOMMU API extension to check safe
 interrupt remapping
Message-ID: <4c2bca79.ZO9rQQJbYvPk39gc%pugs@cisco.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows IOMMU users to determine whether the hardware and software
support safe, isolated interrupt remapping.  Not all Intel IOMMUs have the
hardware, and the software for AMD is not there yet.
	Signed-off-by: Tom Lyon <pugs@cisco.com>
---

MST has convinced me that any user level driver for PCI master devices can't 
be safe unless there is an IOMMU protecting the APIC MSI/MSI-X interrupt 
addresses from device writes.  This interrupt remapping is not present in all
Intel IOMMUs and the code for the interrupt mapping in the AMD IOMMUs is not
implemented yet.

Needed by not-yet-accepted VFIO driver.

diff -uprN linux-2.6.34/drivers/pci/intel-iommu.c iommuapi-linux-2.6.34/drivers/pci/intel-iommu.c
--- linux-2.6.34/drivers/pci/intel-iommu.c	2010-05-16 14:17:36.000000000 -0700
+++ iommuapi-linux-2.6.34/drivers/pci/intel-iommu.c	2010-06-30 15:47:10.000000000 -0700
@@ -3705,6 +3705,10 @@ static int intel_iommu_domain_has_cap(st
 
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
 		return dmar_domain->iommu_snooping;
+#ifdef CONFIG_INTR_REMAP
+	if (cap == IOMMU_CAP_SAFE_INTR_REMAP)
+		return intr_remapping_enabled;
+#endif
 
 	return 0;
 }
diff -uprN linux-2.6.34/include/linux/iommu.h iommuapi-linux-2.6.34/include/linux/iommu.h
--- linux-2.6.34/include/linux/iommu.h	2010-05-16 14:17:36.000000000 -0700
+++ iommuapi-linux-2.6.34/include/linux/iommu.h	2010-06-30 15:47:34.000000000 -0700
@@ -30,6 +30,7 @@ struct iommu_domain {
 };
 
 #define IOMMU_CAP_CACHE_COHERENCY	0x1
+#define IOMMU_CAP_SAFE_INTR_REMAP	0x2	/* isolates device intrs */
 
 struct iommu_ops {
 	int (*domain_init)(struct iommu_domain *domain);
