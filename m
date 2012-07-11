Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab2GKNo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:44:28 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:14519
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757631Ab2GKNjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:39:22 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M700LF-02-1PD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/27] iommu/amd: Introduce amd_iommu_init_dma routine
Date: Wed, 11 Jul 2012 15:38:55 +0200
Message-ID: <1342013952-10174-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
References: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function will initialize everthing necessary so that
devices can do DMA. This includes dma_ops and iommu_ops.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 514556c..5311a88 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1627,8 +1627,6 @@ int __init amd_iommu_init_hardware(void)
 
 	enable_iommus();
 
-	amd_iommu_init_notifier();
-
 	register_syscore_ops(&amd_iommu_syscore_ops);
 
 	return ret;
@@ -1669,6 +1667,25 @@ static bool detect_ivrs(void)
 	return true;
 }
 
+static int amd_iommu_init_dma(void)
+{
+	int ret;
+
+	if (iommu_pass_through)
+		ret = amd_iommu_init_passthrough();
+	else
+		ret = amd_iommu_init_dma_ops();
+
+	if (ret)
+		return ret;
+
+	amd_iommu_init_api();
+
+	amd_iommu_init_notifier();
+
+	return 0;
+}
+
 /*
  * This is the core init function for AMD IOMMU hardware in the system.
  * This function is called from the generic x86 DMA layer initialization
@@ -1690,11 +1707,7 @@ static int __init amd_iommu_init(void)
 	if (ret)
 		goto free;
 
-	if (iommu_pass_through)
-		ret = amd_iommu_init_passthrough();
-	else
-		ret = amd_iommu_init_dma_ops();
-
+	ret = amd_iommu_init_dma();
 	if (ret)
 		goto free;
 
-- 
1.7.9.5


