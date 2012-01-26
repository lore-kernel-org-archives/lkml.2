Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab2AZRaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:30:10 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:35162
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176Ab2AZRaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:30:08 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dhc1bhc31hc1ah668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYF1Y1-01-2M5-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
        David Brown <davidb@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH] iommu/msm: Fix error handling in msm_iommu_unmap()
Date: Thu, 26 Jan 2012 18:29:44 +0100
Message-ID: <1327598984-20662-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Error handling in msm_iommu_unmap() is broken. On some error
conditions retval is set to a non-zero value which causes
the function to return 'len' at the end. This hides the
error from the user. Zero should be returned in those error
cases.

Cc: David Brown <davidb@codeaurora.org>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/msm_iommu.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index 08a90b8..cee307e 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -482,23 +482,19 @@ static size_t msm_iommu_unmap(struct iommu_domain *domain, unsigned long va,
 
 	priv = domain->priv;
 
-	if (!priv) {
-		ret = -ENODEV;
+	if (!priv)
 		goto fail;
-	}
 
 	fl_table = priv->pgtable;
 
 	if (len != SZ_16M && len != SZ_1M &&
 	    len != SZ_64K && len != SZ_4K) {
 		pr_debug("Bad length: %d\n", len);
-		ret = -EINVAL;
 		goto fail;
 	}
 
 	if (!fl_table) {
 		pr_debug("Null page table\n");
-		ret = -EINVAL;
 		goto fail;
 	}
 
@@ -507,7 +503,6 @@ static size_t msm_iommu_unmap(struct iommu_domain *domain, unsigned long va,
 
 	if (*fl_pte == 0) {
 		pr_debug("First level PTE is 0\n");
-		ret = -ENODEV;
 		goto fail;
 	}
 
-- 
1.7.5.4


