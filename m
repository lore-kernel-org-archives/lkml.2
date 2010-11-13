Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab0KMDaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 22:30:23 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28676 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab0KMDaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 22:30:14 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6165"; a="61810878"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: dwalker@codeaurora.org
Cc: davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 08/14] msm: iommu: Don't flush page tables if no devices attached
Date: Fri, 12 Nov 2010 19:29:54 -0800
Message-Id: <1289619000-13167-9-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
References: <1289619000-13167-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't flush the page tables on an IOMMU domain if there are
no IOMMU devices attached to the domain. The act of
attaching to the domain will cause an implicit flush of
those areas if the page tables are configured to not be L2
cacheable.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/iommu.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-msm/iommu.c b/arch/arm/mach-msm/iommu.c
index 134add7..74f2157 100644
--- a/arch/arm/mach-msm/iommu.c
+++ b/arch/arm/mach-msm/iommu.c
@@ -50,13 +50,16 @@ static void __flush_iotlb(struct iommu_domain *domain)
 	unsigned long *fl_table = priv->pgtable;
 	int i;
 
-	dmac_flush_range(fl_table, fl_table + SZ_16K);
+	if (!list_empty(&priv->list_attached)) {
+		dmac_flush_range(fl_table, fl_table + SZ_16K);
 
-	for (i = 0; i < NUM_FL_PTE; i++)
-		if ((fl_table[i] & 0x03) == FL_TYPE_TABLE) {
-			void *sl_table = __va(fl_table[i] & FL_BASE_MASK);
-			dmac_flush_range(sl_table, sl_table + SZ_4K);
-		}
+		for (i = 0; i < NUM_FL_PTE; i++)
+			if ((fl_table[i] & 0x03) == FL_TYPE_TABLE) {
+				void *sl_table = __va(fl_table[i] &
+								FL_BASE_MASK);
+				dmac_flush_range(sl_table, sl_table + SZ_4K);
+			}
+	}
 #endif
 
 	list_for_each_entry(ctx_drvdata, &priv->list_attached, attached_elm) {
-- 
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

