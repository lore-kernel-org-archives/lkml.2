Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab2IJT7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 15:59:38 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17196 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab2IJT4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 15:56:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        stefano.stabellini@eu.citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 01/10] xen/swiotlb: Simplify the logic.
Date: Mon, 10 Sep 2012 15:45:58 -0400
Message-Id: <1347306367-28669-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its pretty easy:
 1). We only check to see if we need Xen SWIOTLB for PV guests.
 2). If swiotlb=force or iommu=soft is set, then Xen SWIOTLB will
     be enabled.
 3). If it is an initial domain, then Xen SWIOTLB will be enabled.
 4). Native SWIOTLB must be disabled for PV guests.

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
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

