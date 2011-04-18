Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab1DRQlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:41:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:39602 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057Ab1DRQlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:41:00 -0400
Date: Mon, 18 Apr 2011 16:40:51 GMT
From: tip-bot for Joerg Roedel <joerg.roedel@amd.com>
Message-ID: <tip-665d3e2af83c8fbd149534db8f57d82fa6fa6753@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        joerg.roedel@amd.com, stable@kernel.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, stable@kernel.org, tglx@linutronix.de
In-Reply-To: <1303134346-5805-5-git-send-email-joerg.roedel@amd.com>
References: <1303134346-5805-5-git-send-email-joerg.roedel@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, gart: Make sure GART does not map physmem above 1TB
Git-Commit-ID: 665d3e2af83c8fbd149534db8f57d82fa6fa6753
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Apr 2011 16:40:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  665d3e2af83c8fbd149534db8f57d82fa6fa6753
Gitweb:     http://git.kernel.org/tip/665d3e2af83c8fbd149534db8f57d82fa6fa6753
Author:     Joerg Roedel <joerg.roedel@amd.com>
AuthorDate: Mon, 18 Apr 2011 15:45:46 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 18 Apr 2011 09:26:49 -0700

x86, gart: Make sure GART does not map physmem above 1TB

The GART can only map physical memory below 1TB. Make sure
the gart driver in the kernel does not try to map memory
above 1TB.

Cc: <stable@kernel.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Link: http://lkml.kernel.org/r/1303134346-5805-5-git-send-email-joerg.roedel@amd.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
