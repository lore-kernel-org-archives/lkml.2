Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab2CIMmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 07:42:11 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:29735
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab2CIMmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 07:42:09 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0MBA1-02-5XQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Don Dutile <ddutile@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] iommu/amd: Fix double free of mem-region in error-path
Date: Fri, 9 Mar 2012 13:41:37 +0100
Message-ID: <1331296897-11212-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ioremap_nocache fails in iommu initialization the code
calls release_mem_region immediatly. But the function is
called again when the propagates into the upper init
functions leading to a double-free. Fix that.

Reported-by: Don Dutile <ddutile@redhat.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 75653da..526652a 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -358,8 +358,6 @@ static void iommu_disable(struct amd_iommu *iommu)
  */
 static u8 * __init iommu_map_mmio_space(u64 address)
 {
-	u8 *ret;
-
 	if (!request_mem_region(address, MMIO_REGION_LENGTH, "amd_iommu")) {
 		pr_err("AMD-Vi: Can not reserve memory region %llx for mmio\n",
 			address);
@@ -367,13 +365,7 @@ static u8 * __init iommu_map_mmio_space(u64 address)
 		return NULL;
 	}
 
-	ret = ioremap_nocache(address, MMIO_REGION_LENGTH);
-	if (ret != NULL)
-		return ret;
-
-	release_mem_region(address, MMIO_REGION_LENGTH);
-
-	return NULL;
+	return ioremap_nocache(address, MMIO_REGION_LENGTH);
 }
 
 static void __init iommu_unmap_mmio_space(struct amd_iommu *iommu)
-- 
1.7.5.4


