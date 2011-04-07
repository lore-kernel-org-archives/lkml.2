Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab1DGNbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 09:31:49 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:45905
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755413Ab1DGNaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 09:30:21 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJAAU6-02-JOH-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/9] x86/amd-iommu: Cleanup inv_pages command handling
Date: Thu, 7 Apr 2011 15:29:58 +0200
Message-ID: <1302183004-4081-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
References: <1302183004-4081-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reworks the processing of invalidate-pages
commands to the IOMMU. The function building the the command
is extended so we can get rid of another function. It was
also renamed to match with the other function names.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |   83 ++++++++++++++++++------------------------
 1 files changed, 36 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 4e5631a..f8ec28e 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -397,6 +397,37 @@ static void build_inv_dte(struct iommu_cmd *cmd, u16 devid)
 	CMD_SET_TYPE(cmd, CMD_INV_DEV_ENTRY);
 }
 
+static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
+				  size_t size, u16 domid, int pde)
+{
+	u64 pages;
+	int s;
+
+	pages = iommu_num_pages(address, size, PAGE_SIZE);
+	s     = 0;
+
+	if (pages > 1) {
+		/*
+		 * If we have to flush more than one page, flush all
+		 * TLB entries for this domain
+		 */
+		address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
+		s = 1;
+	}
+
+	address &= PAGE_MASK;
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->data[1] |= domid;
+	cmd->data[2]  = lower_32_bits(address);
+	cmd->data[3]  = upper_32_bits(address);
+	CMD_SET_TYPE(cmd, CMD_INV_IOMMU_PAGES);
+	if (s) /* size bit - we flush more than one 4kb page */
+		cmd->data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
+	if (pde) /* PDE bit - we wan't flush everything not only the PTEs */
+		cmd->data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
+}
+
 /*
  * Writes the command to the IOMMUs command buffer and informs the
  * hardware about the new command. Must be called with iommu->lock held.
@@ -545,37 +576,6 @@ static int iommu_flush_device(struct device *dev)
 	return iommu_queue_command(iommu, &cmd);
 }
 
-static void __iommu_build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
-					  u16 domid, int pde, int s)
-{
-	memset(cmd, 0, sizeof(*cmd));
-	address &= PAGE_MASK;
-	CMD_SET_TYPE(cmd, CMD_INV_IOMMU_PAGES);
-	cmd->data[1] |= domid;
-	cmd->data[2] = lower_32_bits(address);
-	cmd->data[3] = upper_32_bits(address);
-	if (s) /* size bit - we flush more than one 4kb page */
-		cmd->data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
-	if (pde) /* PDE bit - we wan't flush everything not only the PTEs */
-		cmd->data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
-}
-
-/*
- * Generic command send function for invalidaing TLB entries
- */
-static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
-		u64 address, u16 domid, int pde, int s)
-{
-	struct iommu_cmd cmd;
-	int ret;
-
-	__iommu_build_inv_iommu_pages(&cmd, address, domid, pde, s);
-
-	ret = iommu_queue_command(iommu, &cmd);
-
-	return ret;
-}
-
 /*
  * TLB invalidation function which is called from the mapping functions.
  * It invalidates a single PTE if the range to flush is within a single
@@ -584,20 +584,10 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 static void __iommu_flush_pages(struct protection_domain *domain,
 				u64 address, size_t size, int pde)
 {
-	int s = 0, i;
-	unsigned long pages = iommu_num_pages(address, size, PAGE_SIZE);
-
-	address &= PAGE_MASK;
-
-	if (pages > 1) {
-		/*
-		 * If we have to flush more than one page, flush all
-		 * TLB entries for this domain
-		 */
-		address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
-		s = 1;
-	}
+	struct iommu_cmd cmd;
+	int ret = 0, i;
 
+	build_inv_iommu_pages(&cmd, address, size, domain->id, pde);
 
 	for (i = 0; i < amd_iommus_present; ++i) {
 		if (!domain->dev_iommu[i])
@@ -607,11 +597,10 @@ static void __iommu_flush_pages(struct protection_domain *domain,
 		 * Devices of this domain are behind this IOMMU
 		 * We need a TLB flush
 		 */
-		iommu_queue_inv_iommu_pages(amd_iommus[i], address,
-					    domain->id, pde, s);
+		ret |= iommu_queue_command(amd_iommus[i], &cmd);
 	}
 
-	return;
+	WARN_ON(ret);
 }
 
 static void iommu_flush_pages(struct protection_domain *domain,
-- 
1.7.1


