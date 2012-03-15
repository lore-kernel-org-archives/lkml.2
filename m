Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031729Ab2COQ2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:28:09 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:19487
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031680Ab2COQ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:28:05 -0400
X-SpamScore: -5
X-BigFish: VPS-5(z6c9Mzzz1202hzz8275bh8275dhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0XPQG-02-PI4-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/2] iommu/amd: Make sure IOMMU interrupts are re-enabled on resume
Date: Thu, 15 Mar 2012 17:27:43 +0100
Message-ID: <1331828864-25213-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunatly the interrupts for the event log and the
peripheral page-faults are only enabled at boot but not
re-enabled at resume. Fix that.

Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |   30 ++++++++++++++++++++----------
 1 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 526652a..182b80b 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1123,8 +1123,9 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
 {
 	int r;
 
-	if (pci_enable_msi(iommu->dev))
-		return 1;
+	r = pci_enable_msi(iommu->dev);
+	if (r)
+		return r;
 
 	r = request_threaded_irq(iommu->dev->irq,
 				 amd_iommu_int_handler,
@@ -1134,27 +1135,36 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
 
 	if (r) {
 		pci_disable_msi(iommu->dev);
-		return 1;
+		return r;
 	}
 
 	iommu->int_enabled = true;
-	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
-
-	if (iommu->ppr_log != NULL)
-		iommu_feature_enable(iommu, CONTROL_PPFINT_EN);
 
 	return 0;
 }
 
 static int iommu_init_msi(struct amd_iommu *iommu)
 {
+	int ret;
+
 	if (iommu->int_enabled)
-		return 0;
+		goto enable_faults;
 
 	if (pci_find_capability(iommu->dev, PCI_CAP_ID_MSI))
-		return iommu_setup_msi(iommu);
+		ret = iommu_setup_msi(iommu);
+	else
+		ret = -ENODEV;
 
-	return 1;
+	if (ret)
+		return ret;
+
+enable_faults:
+	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
+
+	if (iommu->ppr_log != NULL)
+		iommu_feature_enable(iommu, CONTROL_PPFINT_EN);
+
+	return 0;
 }
 
 /****************************************************************************
-- 
1.7.5.4


