Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab2HPQGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:06:07 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20864 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774Ab2HPQEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:04:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/5] xen/swiotlb: Simplify the logic.
Date: Thu, 16 Aug 2012 11:54:44 -0400
Message-Id: <1345132488-27323-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345132488-27323-1-git-send-email-konrad.wilk@oracle.com>
References: <1345132488-27323-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its pretty easy:
 1). We only check to see if we need Xen SWIOTLB for PV guests.
 2). If swiotlb=force or iommu=soft is set, then Xen SWIOTLB will
     be enabled.
 3). If it is an initial domain, then Xen SWIOTLB will be enabled.
 4). Native SWIOTLB must be disabled for PV guests.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/pci-swiotlb-xen.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index 967633a..b6a5340 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -34,19 +34,20 @@ static struct dma_map_ops xen_swiotlb_dma_ops = {
 int __init pci_xen_swiotlb_detect(void)
 {
 
+	if (!xen_pv_domain())
+		return 0;
+
 	/* If running as PV guest, either iommu=soft, or swiotlb=force will
 	 * activate this IOMMU. If running as PV privileged, activate it
 	 * irregardless.
 	 */
-	if ((xen_initial_domain() || swiotlb || swiotlb_force) &&
-	    (xen_pv_domain()))
+	if ((xen_initial_domain() || swiotlb || swiotlb_force))
 		xen_swiotlb = 1;
 
 	/* If we are running under Xen, we MUST disable the native SWIOTLB.
 	 * Don't worry about swiotlb_force flag activating the native, as
 	 * the 'swiotlb' flag is the only one turning it on. */
-	if (xen_pv_domain())
-		swiotlb = 0;
+	swiotlb = 0;
 
 	return xen_swiotlb;
 }
-- 
1.7.7.6

