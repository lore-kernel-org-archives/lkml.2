Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab2GWBqo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:46:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54493 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753631Ab2GWBnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:49 -0400
Message-Id: <20120723010655.323382582@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Joerg Roedel <joerg.roedel@amd.com>,
        Stefan Assmann <sassmann@redhat.com>
Subject: [ 025/108] iommu/amd: Initialize dma_ops for hotplug and sriov devices
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit ac1534a55d1e87d59a21c09c570605933b551480 upstream.

When a device is added to the system at runtime the AMD
IOMMU driver initializes the necessary data structures to
handle translation for it. But it forgets to change the
per-device dma_ops to point to the AMD IOMMU driver. So
mapping actually never happens and all DMA accesses end in
an IO_PAGE_FAULT. Fix this.

Reported-by: Stefan Assmann <sassmann@redhat.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
[bwh: Backported to 3.2:
 - Adjust context
 - Use global iommu_pass_through; there is no per-device pass_through]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -59,6 +59,8 @@ static struct protection_domain *pt_doma
 
 static struct iommu_ops amd_iommu_ops;
 
+static struct dma_map_ops amd_iommu_dma_ops;
+
 /*
  * general struct to manage commands send to an IOMMU
  */
@@ -1878,6 +1880,11 @@ static int device_change_notifier(struct
 		list_add_tail(&dma_domain->list, &iommu_pd_list);
 		spin_unlock_irqrestore(&iommu_pd_list_lock, flags);
 
+		if (!iommu_pass_through)
+			dev->archdata.dma_ops = &amd_iommu_dma_ops;
+		else
+			dev->archdata.dma_ops = &nommu_dma_ops;
+
 		break;
 	case BUS_NOTIFY_DEL_DEVICE:
 


