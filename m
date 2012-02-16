Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab2BPKk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 05:40:29 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:61565 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab2BPKk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 05:40:26 -0500
Date: Thu, 16 Feb 2012 11:40:03 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: giancarlo.asnaghi@st.com, alan@linux.intel.com, andrzej.p@samsung.com,
        mingo@elte.hu, jbarnes@virtuousgeek.org
Subject: [PATCH 1/3] x86/PCI: change sta2x11-fixup to account for commit
 aa04651
Message-ID: <b30d620534d0a74feda1fe1fcf23e7891b0d0f03.1329387617.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1329387617.git.rubini@gnudd.com>
In-Reply-To: <cover.1329387617.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit aa04651 changed the prototypes for swiotlb methods, so
the sta2x11 fixup file won't compile any more. This fixes our own
prototypes.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 arch/x86/pci/sta2x11-fixup.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
index f61ce8b..5aaa434 100644
--- a/arch/x86/pci/sta2x11-fixup.c
+++ b/arch/x86/pci/sta2x11-fixup.c
@@ -168,21 +168,23 @@ static dma_addr_t a2p(dma_addr_t a, struct pci_dev *pdev)
 static void *sta2x11_swiotlb_alloc_coherent(struct device *dev,
 					    size_t size,
 					    dma_addr_t *dma_handle,
-					    gfp_t flags)
+					    gfp_t flags,
+					    struct dma_attrs *attrs)
 {
 	void *vaddr;
 
-	vaddr = dma_generic_alloc_coherent(dev, size, dma_handle, flags);
+	vaddr = dma_generic_alloc_coherent(dev, size, dma_handle, flags, attrs);
 	if (!vaddr)
-		vaddr = swiotlb_alloc_coherent(dev, size, dma_handle, flags);
+		vaddr = swiotlb_alloc_coherent(dev, size, dma_handle, flags,
+					       attrs);
 	*dma_handle = p2a(*dma_handle, to_pci_dev(dev));
 	return vaddr;
 }
 
 /* We have our own dma_ops: the same as swiotlb but from alloc (above) */
 static struct dma_map_ops sta2x11_dma_ops = {
-	.alloc_coherent = sta2x11_swiotlb_alloc_coherent,
-	.free_coherent = swiotlb_free_coherent,
+	.alloc = sta2x11_swiotlb_alloc_coherent,
+	.free = swiotlb_free_coherent,
 	.map_page = swiotlb_map_page,
 	.unmap_page = swiotlb_unmap_page,
 	.map_sg = swiotlb_map_sg_attrs,
-- 
1.7.7.2
