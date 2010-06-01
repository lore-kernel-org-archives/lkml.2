Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab0FAJED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 05:04:03 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:14645
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753328Ab0FAJEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 05:04:00 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i87h2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L3BVUD-01-T5Y-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>, <stable@kernel.org>
Subject: [PATCH 2/3] x86/amd-iommu: Fix crash when request_mem_region fails
Date: Tue, 1 Jun 2010 11:03:40 +0200
Message-ID: <1275383021-20172-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275383021-20172-1-git-send-email-joerg.roedel@amd.com>
References: <1275383021-20172-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When request_mem_region fails the error path tries to
disable the IOMMUs. This accesses the mmio-region which was
not allocated leading to a kernel crash. This patch fixes
the issue.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 3bacb4d..1405346 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -287,8 +287,12 @@ static u8 * __init iommu_map_mmio_space(u64 address)
 {
 	u8 *ret;
 
-	if (!request_mem_region(address, MMIO_REGION_LENGTH, "amd_iommu"))
+	if (!request_mem_region(address, MMIO_REGION_LENGTH, "amd_iommu")) {
+		pr_err("AMD-Vi: Can not reserve memory region %llx for mmio\n",
+			address);
+		pr_err("AMD-Vi: This is a BIOS bug. Please contact your hardware vendor\n");
 		return NULL;
+	}
 
 	ret = ioremap_nocache(address, MMIO_REGION_LENGTH);
 	if (ret != NULL)
@@ -1314,7 +1318,7 @@ static int __init amd_iommu_init(void)
 		ret = amd_iommu_init_dma_ops();
 
 	if (ret)
-		goto free;
+		goto free_disable;
 
 	amd_iommu_init_api();
 
@@ -1332,9 +1336,10 @@ static int __init amd_iommu_init(void)
 out:
 	return ret;
 
-free:
+free_disable:
 	disable_iommus();
 
+free:
 	amd_iommu_uninit_devices();
 
 	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
-- 
1.7.1


