Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468Ab1LENfd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:35:33 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:42341
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932455Ab1LENfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:31 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LVQGE9-02-AU7-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/22] iommu/amd: Fix wrong address masks in tlb flush code
Date: Mon, 5 Dec 2011 14:34:17 +0100
Message-ID: <1323092077-25501-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using PAGE_MASK is not sufficient because it masks out the
high bits too. But the IOMMU supports 64 bits and not only
52. So change the masks to only mask out the low 12 bits.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c       |    4 ++--
 drivers/iommu/amd_iommu_types.h |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 661e2bb..f2eec1c 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -551,7 +551,7 @@ static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
 		s = 1;
 	}
 
-	address &= PAGE_MASK;
+	address &= IOMMU_IO_PAGE_MASK;
 
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->data[1] |= domid;
@@ -582,7 +582,7 @@ static void build_inv_iotlb_pages(struct iommu_cmd *cmd, u16 devid, int qdep,
 		s = 1;
 	}
 
-	address &= PAGE_MASK;
+	address &= IOMMU_IO_PAGE_MASK;
 
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->data[0]  = devid;
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index f8dd9ae..a8a994b 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -233,6 +233,7 @@
 #define DTE_FLAG_IOTLB	(0x01UL << 32)
 
 #define IOMMU_PAGE_MASK (((1ULL << 52) - 1) & ~0xfffULL)
+#define IOMMU_IO_PAGE_MASK	(~(0xfffULL))
 #define IOMMU_PTE_PRESENT(pte) ((pte) & IOMMU_PTE_P)
 #define IOMMU_PTE_PAGE(pte) (phys_to_virt((pte) & IOMMU_PAGE_MASK))
 #define IOMMU_PTE_MODE(pte) (((pte) >> 9) & 0x07)
-- 
1.7.5.4


