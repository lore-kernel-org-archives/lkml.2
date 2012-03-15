Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761785Ab2COLuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 07:50:05 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:16668
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758537Ab2COLuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 07:50:02 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0XCV6-01-0GS-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] iommu/amd: Don't initialize IOMMUv2 resources when not required
Date: Thu, 15 Mar 2012 12:49:21 +0100
Message-ID: <1331812161-5294-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a check to the init-path of the AMD IOMMUv2 driver if
the hardware is available in the system. Only allocate all
the resources if it is really available.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 8add9f1..036fe9b 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -921,7 +921,16 @@ static int __init amd_iommu_v2_init(void)
 	size_t state_table_size;
 	int ret;
 
-	pr_info("AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>");
+	pr_info("AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>\n");
+
+	if (!amd_iommu_v2_supported()) {
+		pr_info("AMD IOMMUv2 functionality not available on this sytem\n");
+		/*
+		 * Load anyway to provide the symbols to other modules
+		 * which may use AMD IOMMUv2 optionally.
+		 */
+		return 0;
+	}
 
 	spin_lock_init(&state_lock);
 
@@ -961,6 +970,9 @@ static void __exit amd_iommu_v2_exit(void)
 	size_t state_table_size;
 	int i;
 
+	if (!amd_iommu_v2_supported())
+		return;
+
 	profile_event_unregister(PROFILE_TASK_EXIT, &profile_nb);
 	amd_iommu_unregister_ppr_notifier(&ppr_nb);
 
-- 
1.7.5.4


