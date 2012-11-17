Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab2KQDsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 22:48:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:27372 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab2KQDk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 22:40:27 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 13/46] x86, mm: use pfn_range_is_mapped() with gart
Date: Fri, 16 Nov 2012 19:38:50 -0800
Message-Id: <1353123563-3103-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are going to map ram only, so under max_low_pfn_mapped,
between 4g and max_pfn_mapped does not mean mapped at all.

Use pfn_range_is_mapped() directly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/amd_gart_64.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
index e663112..b574b29 100644
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -768,10 +768,9 @@ int __init gart_iommu_init(void)
 	aper_base	= info.aper_base;
 	end_pfn		= (aper_base>>PAGE_SHIFT) + (aper_size>>PAGE_SHIFT);
 
-	if (end_pfn > max_low_pfn_mapped) {
-		start_pfn = (aper_base>>PAGE_SHIFT);
+	start_pfn = PFN_DOWN(aper_base);
+	if (!pfn_range_is_mapped(start_pfn, end_pfn))
 		init_memory_mapping(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT);
-	}
 
 	pr_info("PCI-DMA: using GART IOMMU.\n");
 	iommu_size = check_iommu_size(info.aper_base, aper_size);
-- 
1.7.7

