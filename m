Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2GSLpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 07:45:50 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:14685
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701Ab2GSLpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 07:45:49 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M7EOO8-02-770-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
        <stable@vger.kernel.org>
Subject: [PATCH 2/2] iommu/amd: Fix hotplug with iommu=pt
Date: Thu, 19 Jul 2012 13:45:21 +0200
Message-ID: <1342698321-21720-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342698321-21720-1-git-send-email-joerg.roedel@amd.com>
References: <1342698321-21720-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This did not work because devices are not put into the
pt_domain. Fix this.

Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 6256263..3f365ab 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2254,6 +2254,18 @@ static int device_change_notifier(struct notifier_block *nb,
 
 		iommu_init_device(dev);
 
+		/*
+		 * dev_data is still NULL and
+		 * got initialized in iommu_init_device
+		 */
+		dev_data = get_dev_data(dev);
+
+		if (iommu_pass_through || dev_data->iommu_v2) {
+			dev_data->passthrough = true;
+			attach_device(dev, pt_domain);
+			break;
+		}
+
 		domain = domain_for_device(dev);
 
 		/* allocate a protection domain if a device is added */
@@ -2271,10 +2283,7 @@ static int device_change_notifier(struct notifier_block *nb,
 
 		dev_data = get_dev_data(dev);
 
-		if (!dev_data->passthrough)
-			dev->archdata.dma_ops = &amd_iommu_dma_ops;
-		else
-			dev->archdata.dma_ops = &nommu_dma_ops;
+		dev->archdata.dma_ops = &amd_iommu_dma_ops;
 
 		break;
 	case BUS_NOTIFY_DEL_DEVICE:
-- 
1.7.9.5


