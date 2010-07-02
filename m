Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab0GBU7z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 16:59:55 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:1116 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520Ab0GBU7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 16:59:54 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,528,1272844800"; 
   d="scan'208";a="553775595"
Date: Fri, 02 Jul 2010 13:56:14 -0700
From: "Tom Lyon" <pugs@cisco.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, chrisw@sous-sol.org, mst@redhat.com,
       dwmw2@infradead.org, joerg.roedel@amd.com
Cc: aafabbri@cisco.com, scofeldm@cisco.com
Subject: [PATCH V3] 2.6.34: simple IOMMU API extension to check safe
 interrupt remapping
Message-ID: <4c2e526e.HXT+zIj7fSMwTdy/%pugs@cisco.com>
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
Version 3: shorter name requested by Joerg.
Version 2: previous ifdefs not needed.

MST has convinced me that any user level driver for PCI master devices can't 
be safe unless there is an IOMMU protecting the APIC MSI/MSI-X interrupt 
addresses from device writes.  This interrupt remapping is not present in all
Intel IOMMUs and the code for the interrupt mapping in the AMD IOMMUs is not
implemented yet.

Needed by not-yet-accepted VFIO driver.

diff -uprN linux-2.6.34/drivers/pci/intel-iommu.c iommuapi-linux-2.6.34/drivers/pci/intel-iommu.c
--- linux-2.6.34/drivers/pci/intel-iommu.c	2010-05-16 14:17:36.000000000 -0700
+++ iommuapi-linux-2.6.34/drivers/pci/intel-iommu.c	2010-07-02 12:39:19.000000000 -0700
@@ -3705,6 +3705,8 @@ static int intel_iommu_domain_has_cap(st
 
 	if (cap == IOMMU_CAP_CACHE_COHERENCY)
 		return dmar_domain->iommu_snooping;
+	if (cap == IOMMU_CAP_INTR_REMAP)
+		return intr_remapping_enabled;
 
 	return 0;
 }
diff -uprN linux-2.6.34/include/linux/iommu.h iommuapi-linux-2.6.34/include/linux/iommu.h
--- linux-2.6.34/include/linux/iommu.h	2010-05-16 14:17:36.000000000 -0700
+++ iommuapi-linux-2.6.34/include/linux/iommu.h	2010-07-02 12:38:45.000000000 -0700
@@ -30,6 +30,7 @@ struct iommu_domain {
 };
 
 #define IOMMU_CAP_CACHE_COHERENCY	0x1
+#define IOMMU_CAP_INTR_REMAP		0x2	/* isolates device intrs */
 
 struct iommu_ops {
 	int (*domain_init)(struct iommu_domain *domain);
