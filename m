Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab2DKQ0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:26:08 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:40660
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932471Ab2DKQ0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:26:06 -0400
X-SpamScore: -5
X-BigFish: VPS-5(z6c9Mzzz1202hzz8275bh8275dhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2BPNC-01-1TZ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 3.2-stable] iommu/amd: Make sure IOMMU interrupts are re-enabled on resume
Date: Wed, 11 Apr 2012 18:25:46 +0200
Message-ID: <1334161546-11110-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9ddd592a191b32f2ee6c4b6ed2bd52665c3a49f5 upstream

Unfortunatly the interrupts for the event log and the
peripheral page-faults are only enabled at boot but not
re-enabled at resume. Fix that for 3.2.

Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 5c74179..c90a709 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1033,8 +1033,9 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
 {
 	int r;
 
-	if (pci_enable_msi(iommu->dev))
-		return 1;
+	r = pci_enable_msi(iommu->dev);
+	if (r)
+		return r;
 
 	r = request_threaded_irq(iommu->dev->irq,
 				 amd_iommu_int_handler,
@@ -1044,24 +1045,36 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
 
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
+	if (iommu->ppr_log != NULL)
+		iommu_feature_enable(iommu, CONTROL_PPFINT_EN);
+
+	return 0;
 }
 
 /****************************************************************************
-- 
1.7.5.4


