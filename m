Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab2DSNtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 09:49:13 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:18322
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755429Ab2DSNtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 09:49:12 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839hd24h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2QBA7-02-3P3-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] iommu/amd: Check for the right TLP prefix bit
Date: Thu, 19 Apr 2012 15:39:36 +0200
Message-ID: <1334842777-23214-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunatly the PRI spec changed and moved the
TLP-prefix-required bit to a different location. This patch
makes the necessary change in the AMD IOMMU driver.
Regressions are not expected because all hardware
implementing the PRI capability sets this bit to zero
anyway.

Cc: stable@vger.kernel.org # v3.3
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index a5bee8e..08f3eec 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2035,20 +2035,20 @@ out_err:
 }
 
 /* FIXME: Move this to PCI code */
-#define PCI_PRI_TLP_OFF		(1 << 2)
+#define PCI_PRI_TLP_OFF		(1 << 15)
 
 bool pci_pri_tlp_required(struct pci_dev *pdev)
 {
-	u16 control;
+	u16 status;
 	int pos;
 
 	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_PRI);
 	if (!pos)
 		return false;
 
-	pci_read_config_word(pdev, pos + PCI_PRI_CTRL, &control);
+	pci_read_config_word(pdev, pos + PCI_PRI_STATUS, &status);
 
-	return (control & PCI_PRI_TLP_OFF) ? true : false;
+	return (status & PCI_PRI_TLP_OFF) ? true : false;
 }
 
 /*
-- 
1.7.5.4


