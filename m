Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab2HaJ6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:58:06 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:47119 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab2HaJ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:58:04 -0400
X-IronPort-AV: E=Sophos;i="4.80,346,1344211200"; 
   d="scan'208";a="14284817"
From: Stefano Panella <stefano.panella@citrix.com>
To: <linux-kernel@vger.kernel.org>, <konrad.wilk@oracle.com>,
        <xen-devel@lists.xensource.com>
CC: Stefano Panella <stefano.panella@citrix.com>
Subject: [PATCH 1/1] XEN: Use correct masking in xen_swiotlb_alloc_coherent.
Date: Fri, 31 Aug 2012 10:57:52 +0100
Message-ID: <1346407072-6405-1-git-send-email-stefano.panella@citrix.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running 32-bit pvops-dom0 and a driver tries to allocate a coherent
DMA-memory the xen swiotlb-implementation returned memory beyond 4GB.

This caused for example not working sound on a system with 4 GB and a 64-bit
compatible sound-card with sets the DMA-mask to 64bit.

On bare-metal and the forward-ported xen-dom0 patches from OpenSuse a coherent
DMA-memory is always allocated inside the 32-bit address-range by calling
dma_alloc_coherent_mask.

This patch adds the same functionality to xen swiotlb and is a rebase of the
original patch from Ronny Hegewald which never got upstream for some reason.

The original email with the original patch is in:

http://old-list-archives.xen.org/archives/html/xen-devel/2010-02/msg00038.html

the original thread from where the deiscussion started is in:

http://old-list-archives.xen.org/archives/html/xen-devel/2010-01/msg00928.html

Signed-off-by: Ronny Hegewald
Signed-off-by: Stefano Panella <stefano.panella@citrix.com>
---
 drivers/xen/swiotlb-xen.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 1afb4fb..4d51948 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -232,7 +232,7 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		return ret;
 
 	if (hwdev && hwdev->coherent_dma_mask)
-		dma_mask = hwdev->coherent_dma_mask;
+		dma_mask = dma_alloc_coherent_mask(hwdev, flags);
 
 	phys = virt_to_phys(ret);
 	dev_addr = xen_phys_to_bus(phys);
-- 
1.7.4.1

