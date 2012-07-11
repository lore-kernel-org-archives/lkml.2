Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab2GKNnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:43:43 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:37160
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757737Ab2GKNjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:39:24 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M700LG-01-AXP-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/27] iommu/amd: Split enable_iommus() routine
Date: Wed, 11 Jul 2012 15:38:53 +0200
Message-ID: <1342013952-10174-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
References: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the enable_iommus() routine so that a part of it can
run in early code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 49e16bb..4912eca 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1379,7 +1379,7 @@ static void iommu_apply_resume_quirks(struct amd_iommu *iommu)
  * This function finally enables all IOMMUs found in the system after
  * they have been initialized
  */
-static void enable_iommus(void)
+static void early_enable_iommus(void)
 {
 	struct amd_iommu *iommu;
 
@@ -1389,14 +1389,29 @@ static void enable_iommus(void)
 		iommu_set_device_table(iommu);
 		iommu_enable_command_buffer(iommu);
 		iommu_enable_event_buffer(iommu);
-		iommu_enable_ppr_log(iommu);
-		iommu_enable_gt(iommu);
 		iommu_set_exclusion_range(iommu);
 		iommu_enable(iommu);
 		iommu_flush_all_caches(iommu);
 	}
 }
 
+static void enable_iommus_v2(void)
+{
+	struct amd_iommu *iommu;
+
+	for_each_iommu(iommu) {
+		iommu_enable_ppr_log(iommu);
+		iommu_enable_gt(iommu);
+	}
+}
+
+static void enable_iommus(void)
+{
+	early_enable_iommus();
+
+	enable_iommus_v2();
+}
+
 static void disable_iommus(void)
 {
 	struct amd_iommu *iommu;
-- 
1.7.9.5


