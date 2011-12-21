Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab1LUBeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 20:34:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45555 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754082Ab1LUBeF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 20:34:05 -0500
Message-ID: <1324431239.2844.149.camel@deadeye>
Subject: [PATCH 4/8] drm: Pass pointers to virt_to_page()
From: Ben Hutchings <ben@decadent.org.uk>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 21 Dec 2011 01:33:59 +0000
In-Reply-To: <1324430940.2844.144.camel@deadeye>
References: <1324430940.2844.144.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most architectures define virt_to_page() as a macro that casts its
argument such that an argument of type unsigned long will be accepted
without complaint.  However, the proper type is void *, and passing
unsigned long results in a warning on MIPS.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_pci.c |    4 ++--
 drivers/gpu/drm/drm_vm.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index d4d10b7..2e19fcc 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -82,7 +82,7 @@ drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t ali
 	/* Reserve */
 	for (addr = (unsigned long)dmah->vaddr, sz = size;
 	     sz > 0; addr += PAGE_SIZE, sz -= PAGE_SIZE) {
-		SetPageReserved(virt_to_page(addr));
+		SetPageReserved(virt_to_page((void *)addr));
 	}
 
 	return dmah;
@@ -107,7 +107,7 @@ void __drm_pci_free(struct drm_device * dev, drm_dma_handle_t * dmah)
 		/* Unreserve */
 		for (addr = (unsigned long)dmah->vaddr, sz = dmah->size;
 		     sz > 0; addr += PAGE_SIZE, sz -= PAGE_SIZE) {
-			ClearPageReserved(virt_to_page(addr));
+			ClearPageReserved(virt_to_page((void *)addr));
 		}
 		dma_free_coherent(&dev->pdev->dev, dmah->size, dmah->vaddr,
 				  dmah->busaddr);
diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index 98c3922..8cc1c06 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -306,7 +306,7 @@ static int drm_do_vm_dma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	offset = (unsigned long)vmf->virtual_address - vma->vm_start;	/* vm_[pg]off[set] should be 0 */
 	page_nr = offset >> PAGE_SHIFT; /* page_nr could just be vmf->pgoff */
-	page = virt_to_page(dma->pagelist[page_nr]);
+	page = virt_to_page((void *)dma->pagelist[page_nr]);
 
 	get_page(page);
 	vmf->page = page;
-- 
1.7.7.3



