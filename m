Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab1D2S6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:58:18 -0400
Received: from kroah.org ([198.145.64.141]:50209 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698Ab1D2S6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:53 2011
Message-Id: <20110429185653.658083663@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [11/55] x86, gart: Make sure GART does not map physmem above 1TB
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 665d3e2af83c8fbd149534db8f57d82fa6fa6753 upstream.

The GART can only map physical memory below 1TB. Make sure
the gart driver in the kernel does not try to map memory
above 1TB.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Link: http://lkml.kernel.org/r/1303134346-5805-5-git-send-email-joerg.roedel@amd.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/pci-gart_64.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

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
@@ -212,9 +215,13 @@ static dma_addr_t dma_map_area(struct de
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


