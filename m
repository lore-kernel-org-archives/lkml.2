Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab0FVTrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:47:42 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32972 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281Ab0FVTrh (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:47:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 19/19] x86: Detect whether we should use Xen SWIOTLB.
Date: Tue, 22 Jun 2010 15:42:52 -0400
Message-Id: <1277235772-26757-20-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4C2112D7.0170:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is paramount that we call pci_xen_swiotlb_detect before
pci_swiotlb_detect as both implementations use the 'swiotlb'
and 'swiotlb_force' flags. The pci-xen_swiotlb_detect inhibits
the swiotlb_force and swiotlb flag so that the native SWIOTLB
implementation is not enabled when running under Xen.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/kernel/pci-dma.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 4b7e3d8..9f07cfc 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -13,6 +13,7 @@
 #include <asm/calgary.h>
 #include <asm/amd_iommu.h>
 #include <asm/x86_init.h>
+#include <asm/xen/swiotlb-xen.h>
 
 static int forbid_dac __read_mostly;
 
@@ -132,7 +133,7 @@ void __init pci_iommu_alloc(void)
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 
-	if (pci_swiotlb_detect())
+	if (pci_xen_swiotlb_detect() || pci_swiotlb_detect())
 		goto out;
 
 	gart_iommu_hole_init();
@@ -144,6 +145,8 @@ void __init pci_iommu_alloc(void)
 	/* needs to be called after gart_iommu_hole_init */
 	amd_iommu_detect();
 out:
+	pci_xen_swiotlb_init();
+
 	pci_swiotlb_init();
 }
 
@@ -296,7 +299,7 @@ static int __init pci_iommu_init(void)
 #endif
 	x86_init.iommu.iommu_init();
 
-	if (swiotlb) {
+	if (swiotlb || xen_swiotlb) {
 		printk(KERN_INFO "PCI-DMA: "
 		       "Using software bounce buffering for IO (SWIOTLB)\n");
 		swiotlb_print_info();
-- 
1.7.0.1

