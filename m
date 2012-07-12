Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161693Ab2GLXip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:38:45 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34975 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab2GLWjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:39:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefan Assmann <sassmann@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 054/187] iommu/amd: Initialize dma_ops for hotplug and sriov devices
Date: Thu, 12 Jul 2012 15:33:30 -0700
Message-Id: <20120712191527.356049087@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu.c |    9 +++++++++
 1 file changed, 9 insertions(+)

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
@@ -2267,6 +2269,13 @@ static int device_change_notifier(struct
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
 


