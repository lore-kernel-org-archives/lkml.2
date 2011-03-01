Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab1CATq5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:46:57 -0500
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:56090 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757236Ab1CATqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:46:55 -0500
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <hiroshi.doyu@nokia.com>
Cc: <tony@atomide.com>, <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Hari Kanigeri <h-kanigeri2@ti.com>
Subject: [PATCH] OMAP:iommu - pgd and pte entries weren't getting flushed out
Date: Tue,  1 Mar 2011 13:46:33 -0600
Message-Id: <1299008793-27428-2-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1299008793-27428-1-git-send-email-fernando.lugo@ti.com>
References: <1299008793-27428-1-git-send-email-fernando.lugo@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hari Kanigeri <h-kanigeri2@ti.com>

pgd and pte entries weren't getting flushed out leading to MMU faults.

Signed-off-by: Hari Kanigeri <h-kanigeri2@ti.com>
---
 arch/arm/plat-omap/iommu.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
index aeb2c33..e9473ff 100644
--- a/arch/arm/plat-omap/iommu.c
+++ b/arch/arm/plat-omap/iommu.c
@@ -508,7 +508,7 @@ static u32 *iopte_alloc(struct iommu *obj, u32 *iopgd, u32 da)
 			return ERR_PTR(-ENOMEM);
 
 		*iopgd = virt_to_phys(iopte) | IOPGD_TABLE;
-		flush_iopgd_range(iopgd, iopgd);
+		flush_iopgd_range(iopgd, iopgd + 1);
 
 		dev_vdbg(obj->dev, "%s: a new pte:%p\n", __func__, iopte);
 	} else {
@@ -537,7 +537,7 @@ static int iopgd_alloc_section(struct iommu *obj, u32 da, u32 pa, u32 prot)
 	}
 
 	*iopgd = (pa & IOSECTION_MASK) | prot | IOPGD_SECTION;
-	flush_iopgd_range(iopgd, iopgd);
+	flush_iopgd_range(iopgd, iopgd + 1);
 	return 0;
 }
 
@@ -554,7 +554,7 @@ static int iopgd_alloc_super(struct iommu *obj, u32 da, u32 pa, u32 prot)
 
 	for (i = 0; i < 16; i++)
 		*(iopgd + i) = (pa & IOSUPER_MASK) | prot | IOPGD_SUPER;
-	flush_iopgd_range(iopgd, iopgd + 15);
+	flush_iopgd_range(iopgd, iopgd + 16);
 	return 0;
 }
 
@@ -567,7 +567,7 @@ static int iopte_alloc_page(struct iommu *obj, u32 da, u32 pa, u32 prot)
 		return PTR_ERR(iopte);
 
 	*iopte = (pa & IOPAGE_MASK) | prot | IOPTE_SMALL;
-	flush_iopte_range(iopte, iopte);
+	flush_iopte_range(iopte, iopte + 1);
 
 	dev_vdbg(obj->dev, "%s: da:%08x pa:%08x pte:%p *pte:%08x\n",
 		 __func__, da, pa, iopte, *iopte);
@@ -592,7 +592,7 @@ static int iopte_alloc_large(struct iommu *obj, u32 da, u32 pa, u32 prot)
 
 	for (i = 0; i < 16; i++)
 		*(iopte + i) = (pa & IOLARGE_MASK) | prot | IOPTE_LARGE;
-	flush_iopte_range(iopte, iopte + 15);
+	flush_iopte_range(iopte, iopte + 16);
 	return 0;
 }
 
@@ -763,7 +763,7 @@ void iopgtable_clear_entry_all(struct iommu *obj)
 			iopte_free(iopte_offset(iopgd, 0));
 
 		*iopgd = 0;
-		flush_iopgd_range(iopgd, iopgd);
+		flush_iopgd_range(iopgd, iopgd + 1);
 	}
 
 	flush_iotlb_all(obj);
-- 
1.7.0.4

