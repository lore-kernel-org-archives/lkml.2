Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab2FYLRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 07:17:30 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:30900
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755729Ab2FYLR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 07:17:29 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M667CW-02-1RS-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Stefan Assmann <sassmann@redhat.com>, Joerg Roedel <joerg.roedel@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] iommu/amd: Initialize dma_ops for hotplug and sriov devices
Date: Mon, 25 Jun 2012 13:17:23 +0200
Message-ID: <1340623043-29780-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a device is added to the system at runtime the AMD
IOMMU driver initializes the necessary data structures to
handle translation for it. But it forgets to change the
per-device dma_ops to point to the AMD IOMMU driver. So
mapping actually never happens and all DMA accesses end in
an IO_PAGE_FAULT. Fix this.

Reported-by: Stefan Assmann <sassmann@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index a2e418c..dfe7d37 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -83,6 +83,8 @@ static struct iommu_ops amd_iommu_ops;
 static ATOMIC_NOTIFIER_HEAD(ppr_notifier);
 int amd_iommu_max_glx_val = -1;
 
+static struct dma_map_ops amd_iommu_dma_ops;
+
 /*
  * general struct to manage commands send to an IOMMU
  */
@@ -2267,6 +2269,13 @@ static int device_change_notifier(struct notifier_block *nb,
 		list_add_tail(&dma_domain->list, &iommu_pd_list);
 		spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
 
+		dev_data = get_dev_data(dev);
+
+		if (!dev_data->passthrough)
+			dev->archdata.dma_ops = &amd_iommu_dma_ops;
+		else
+			dev->archdata.dma_ops = &nommu_dma_ops;
+
 		break;
 	case BUS_NOTIFY_DEL_DEVICE:
 
-- 
1.7.9.5


