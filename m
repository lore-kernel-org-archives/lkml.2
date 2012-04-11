Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739Ab2DKQqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:46:46 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:39430
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760685Ab2DKQqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:46:44 -0400
X-SpamScore: -5
X-BigFish: VPS-5(z6c9Mzzz1202hzz8275bhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2BQLO-01-3CT-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH v3.0-stable] iommu/amd: Make sure IOMMU interrupts are re-enabled on resume
Date: Wed, 11 Apr 2012 18:45:52 +0200
Message-ID: <1334162752-18625-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9ddd592a191b32f2ee6c4b6ed2bd52665c3a49f5 upstream.

Unfortunatly the interrupts for the event log and the
peripheral page-faults are only enabled at boot but not
re-enabled at resume. Fix that.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
[bwh: Backport to 3.0:
 - Drop change to PPR log which was added in 3.3
  - Source is under arch/x86/kernel]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/amd_iommu_init.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index bfc8453..33df6e8 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1031,8 +1031,9 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
 {
 	int r;
 
-	if (pci_enable_msi(iommu->dev))
-		return 1;
+	r = pci_enable_msi(iommu->dev);
+	if (r)
+		return r;
 
 	r = request_threaded_irq(iommu->dev->irq,
 				 amd_iommu_int_handler,
@@ -1042,24 +1043,33 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
 
 	if (r) {
 		pci_disable_msi(iommu->dev);
-		return 1;
+		return r;
 	}
 
 	iommu->int_enabled = true;
-	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
 
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
+	return 0;
 }
 
 /****************************************************************************
-- 
1.7.5.4


