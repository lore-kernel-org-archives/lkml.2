Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2GaEuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 00:50:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48733 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755502Ab2GaEui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:38 -0400
Message-Id: <20120731044319.439409567@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:44:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 51/73] iommu/amd: Fix hotplug with iommu=pt
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 2c9195e990297068d0f1f1bd8e2f1d09538009da upstream.

This did not work because devices are not put into the
pt_domain. Fix this.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
[bwh: Backported to 3.2: do not use iommu_dev_data::passthrough]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iommu/amd_iommu.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -1865,6 +1865,11 @@ static int device_change_notifier(struct
 
 		iommu_init_device(dev);
 
+		if (iommu_pass_through) {
+			attach_device(dev, pt_domain);
+			break;
+		}
+
 		domain = domain_for_device(dev);
 
 		/* allocate a protection domain if a device is added */
@@ -1880,10 +1885,7 @@ static int device_change_notifier(struct
 		list_add_tail(&dma_domain->list, &iommu_pd_list);
 		spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
 
-		if (!iommu_pass_through)
-			dev->archdata.dma_ops = &amd_iommu_dma_ops;
-		else
-			dev->archdata.dma_ops = &nommu_dma_ops;
+		dev->archdata.dma_ops = &amd_iommu_dma_ops;
 
 		break;
 	case BUS_NOTIFY_DEL_DEVICE:


