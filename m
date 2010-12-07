Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0LGCIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:08:42 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47206 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab0LGCIl (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 21:08:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [RFC PATCH] Utilize the PCI API in TTM framework.
Date: Mon,  6 Dec 2010 21:07:19 -0500
Message-Id: <1291687646-31994-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached is a set of patches that make it possible for drivers using TTM API
(nouveau and radeon graphic drivers) to work under Xen. The explanation
is a bit complex and I am not sure if I am explaining it that well..so if
something is unclear please do ping me.

Short explanation of problem: What we are hitting under Xen is that instead
of programming the GART with the physical DMA address of the TTM page, we
end up programming the bounce buffer DMA (bus) address!

Long explanation:
The reason we end up doing this is that:

 1). alloc_page with GFP_DMA32 does not allocate "real" (Machine Frame Numbers
     - MFN) under the 4GB in Xen. That is b/c if actually made the pages underneath
     4GB available to the the Linux page allocator we would not be able to
     give those to other guest devices. This would mean if we tried to pass
     in a USB device to one guest and in another were running the Xorg server
     we wouldn't be able to do so as we would run out of pages under 4GB. So
     pages that we get from alloc_page have a PFN that is under 4GB but in
     reality the real physical address (MFN) is above 4GB. Ugh..

 2). The backends for "struct ttm_backend_func" utilize the PCI API. When
     they get a page allocated via alloc_page, the use 'pci_map_page' and
     program the DMA (bus) address in the GART - which is correct. But then
     the calls that kick off the graphic driver to process the pages do not
     use the pci_page_sync_* calls. If the physical address of the page
     is the same as the DMA bus address returned from pci_map_page then there
     are no trouble. But if they are different:
	virt_to_phys(page_address(p)) != pci_map_page(p,..)
     then the graphic card fetches data from the DMA (bus) address (so the
     value returned from pci_map_page). The data however that the user wrote
     to (the page p) ends up being untouched. You are probably saying:
     "What? Nonsense, we stitch the page in ttm_bo_vm_fault using the PFN
     and .. and even if the virt_to_phys(page_address(p)) != pci_map_page(p)
     the GART ends up with the bus (DMA) address of the PFN!" That is true.
     But if you combine this with 1) where you end up with page that is
     above the dma_mask (even if you called it with GFP_DMA32) and then
     make a call on pci_map_page you would end up with a bounce buffer!
     

The problem above can be easily reproduced on bare-metal if you pass in
"swiotlb=force iommu=soft". 


There are two ways of fixing this:
 
 1). Use the 'dma_alloc_coherent' (or pci_alloc_consistent if there is
     struct pcidev present), instead of alloc_page for GFP_DMA32. The
     'dma_alloc_coherent' guarantess that the allocated page fits
     within the device dma_mask (or uses the default DMA32 if no device
     is passed in). This also guarantess that any subsequent call
     to the PCI API for this page will return the same DMA (bus) address
     as the first call (so pci_alloc_consistent, and then pci_map_page
     will give the same DMA bus address).

 2). Use the pci_sync_range_* after sending a page to the graphics
     engine. If the bounce buffer is used then we end up copying the
     pages.

 3). This one I really don't want to think about, but I should mention
     it. Alter the alloc_page and its backend to know about Xen.
     The pushback from the MM guys will be probably: "why not use the PCI API.."
    

So attached is a draft set of patches that use solution #1. I've tested
this on baremetal (and Xen) on PCIe Radeon and nouveau cards with success,
but would need to do more testing.. 

This patch-set is also available at:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/ttm.pci-api


 drivers/gpu/drm/nouveau/nouveau_sgdma.c |   31 +++++++++++++++++++-------
 drivers/gpu/drm/radeon/radeon.h         |    4 ++-
 drivers/gpu/drm/radeon/radeon_gart.c    |   36 ++++++++++++++++++++++--------
 drivers/gpu/drm/radeon/radeon_ttm.c     |    8 +++++-
 drivers/gpu/drm/ttm/ttm_agp_backend.c   |    5 ++-
 drivers/gpu/drm/ttm/ttm_page_alloc.c    |   35 +++++++++++++++++++++++++-----
 drivers/gpu/drm/ttm/ttm_tt.c            |   12 +++++++--
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c  |    3 +-
 include/drm/ttm/ttm_bo_driver.h         |    6 ++++-
 include/drm/ttm/ttm_page_alloc.h        |    8 +++++-
 10 files changed, 112 insertions(+), 36 deletions(-)
