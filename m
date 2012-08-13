Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2HMVra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:47:30 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:31656 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125Ab2HMVr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:47:27 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M8PR6X-01-KI0-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: X86-ML <x86@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Tejun Heo <tj@kernel.org>, Borislav Petkov <borislav.petkov@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 3/5] x86: Keep track of direct mapped pfn ranges
Date: Mon, 13 Aug 2012 16:47:02 -0500
Message-ID: <1344894424-4434-4-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344894424-4434-1-git-send-email-jacob.shin@amd.com>
References: <1344894424-4434-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update later calls to init_memory_mapping to keep track of direct mapped
pfn ranges so that at any point in time we can accurately represent what
memory ranges are direct mapped or not.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/amd_gart_64.c  |    4 +++-
 arch/x86/mm/init_64.c          |    3 +--
 arch/x86/platform/efi/efi_64.c |    2 ++
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
index e663112..5ac26b9 100644
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -770,7 +770,9 @@ int __init gart_iommu_init(void)
 
 	if (end_pfn > max_low_pfn_mapped) {
 		start_pfn = (aper_base>>PAGE_SHIFT);
-		init_memory_mapping(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
+		end_pfn = init_memory_mapping(start_pfn<<PAGE_SHIFT,
+					      end_pfn<<PAGE_SHIFT);
+		add_pfn_range_mapped(start_pfn, end_pfn);
 	}
 
 	pr_info("PCI-DMA: using GART IOMMU.\n");
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 2b6b4a3..cbed965 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -662,8 +662,7 @@ int arch_add_memory(int nid, u64 start, u64 size)
 	int ret;
 
 	last_mapped_pfn = init_memory_mapping(start, start + size);
-	if (last_mapped_pfn > max_pfn_mapped)
-		max_pfn_mapped = last_mapped_pfn;
+	add_pfn_range_mapped(start_pfn, last_mapped_pfn);
 
 	ret = __add_pages(nid, zone, start_pfn, nr_pages);
 	WARN_ON_ONCE(ret);
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index ac3aa54..e822c89 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -90,6 +90,8 @@ void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 		return ioremap(phys_addr, size);
 
 	last_map_pfn = init_memory_mapping(phys_addr, phys_addr + size);
+	add_pfn_range_mapped(phys_addr >> PAGE_SHIFT, last_map_pfn);
+
 	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size) {
 		unsigned long top = last_map_pfn << PAGE_SHIFT;
 		efi_ioremap(top, size - (top - phys_addr), type);
-- 
1.7.9.5


