Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab0FAJEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 05:04:06 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:2711 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753837Ab0FAJEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 05:04:01 -0400
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i2a8h87h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L3BVUE-01-T61-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>, <stable@kernel.org>
Subject: [PATCH 3/3] x86/amd-iommu: Fall back to GART if initialization fails
Date: Tue, 1 Jun 2010 11:03:41 +0200
Message-ID: <1275383021-20172-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275383021-20172-1-git-send-email-joerg.roedel@amd.com>
References: <1275383021-20172-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a fallback to the GART IOMMU if this
is possible and the AMD IOMMU initialization failed.
Otherwise the fallback would be nommu which is very
problematic on machines with more than 4GB of memory or
swiotlb which hurts io-performance.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c      |    4 ----
 arch/x86/kernel/amd_iommu_init.c |    9 +++++++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 8a9aaa8..0d20286 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2330,10 +2330,6 @@ int __init amd_iommu_init_dma_ops(void)
 
 	iommu_detected = 1;
 	swiotlb = 0;
-#ifdef CONFIG_GART_IOMMU
-	gart_iommu_aperture_disabled = 1;
-	gart_iommu_aperture = 0;
-#endif
 
 	/* Make the driver finally visible to the drivers */
 	dma_ops = &amd_iommu_dma_ops;
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 1405346..3cc63e2 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1358,6 +1358,15 @@ free:
 
 	free_unity_maps();
 
+#ifdef CONFIG_GART_IOMMU
+	/*
+	 * We failed to initialize the AMD IOMMU - try fallback to GART
+	 * if possible.
+	 */
+	gart_iommu_init();
+
+#endif
+
 	goto out;
 }
 
-- 
1.7.1


