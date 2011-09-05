Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab1IEO5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 10:57:44 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:23628
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754399Ab1IEO5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 10:57:19 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bh8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR21J8-01-GDY-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>,
        <stable@kernel.org>
Subject: [PATCH 2/2] iommu/amd: Don't take domain->lock recursivly
Date: Mon, 5 Sep 2011 16:57:01 +0200
Message-ID: <1315234621-26694-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315234621-26694-1-git-send-email-joerg.roedel@amd.com>
References: <1315234621-26694-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The domain_flush_devices() function takes the domain->lock.
But this function is only called from update_domain() which
itself is already called unter the domain->lock. This causes
a deadlock situation when the dma-address-space of a domain
grows larger than 1GB.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 4565223..0e4227f 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -847,14 +847,9 @@ static void domain_flush_complete(struct protection_domain *domain)
 static void domain_flush_devices(struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data;
-	unsigned long flags;
-
-	spin_lock_irqsave(&domain->lock, flags);
 
 	list_for_each_entry(dev_data, &domain->dev_list, list)
 		device_flush_dte(dev_data);
-
-	spin_unlock_irqrestore(&domain->lock, flags);
 }
 
 /****************************************************************************
-- 
1.7.4.1


