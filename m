Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1DRNrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 09:47:11 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:42979
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754439Ab1DRNq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 09:46:29 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bh8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJUOWF-01-FT7-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, <stable@kernel.org>
Subject: [PATCH 4/4] x86, gart: Make sure GART does not map physmem above 1TB
Date: Mon, 18 Apr 2011 15:45:46 +0200
Message-ID: <1303134346-5805-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com>
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GART can only map physical memory below 1TB. Make sure
the gart driver in the kernel does not try to map memory
above 1TB.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/pci-gart_64.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 82ada01..b117efd 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -81,6 +81,9 @@ static u32 gart_unmapped_entry;
 #define AGPEXTERN
 #endif
 
+/* GART can only remap to physical addresses < 1TB */
+#define GART_MAX_PHYS_ADDR	(1ULL << 40)
+
 /* backdoor interface to AGP driver */
 AGPEXTERN int agp_memory_reserved;
 AGPEXTERN __u32 *agp_gatt_table;
@@ -212,9 +215,13 @@ static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
 				size_t size, int dir, unsigned long align_mask)
 {
 	unsigned long npages = iommu_num_pages(phys_mem, size, PAGE_SIZE);
-	unsigned long iommu_page = alloc_iommu(dev, npages, align_mask);
+	unsigned long iommu_page;
 	int i;
 
+	if (unlikely(phys_mem + size > GART_MAX_PHYS_ADDR))
+		return bad_dma_addr;
+
+	iommu_page = alloc_iommu(dev, npages, align_mask);
 	if (iommu_page == -1) {
 		if (!nonforced_iommu(dev, phys_mem, size))
 			return phys_mem;
-- 
1.7.1


