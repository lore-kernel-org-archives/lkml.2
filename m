Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab0JVPIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 11:08:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35091 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab0JVPIk (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 22 Oct 2010 11:08:40 -0400
Date: Fri, 22 Oct 2010 11:08:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: define arch_vm_get_page_prot to set _PAGE_IOMAP
 on VM_IO vmas
Message-ID: <20101022150826.GA23325@dumpdata.com>
References: <4CC0C14E.5080205@goop.org>
 <4CC0C318.90401@zytor.com>
 <4CC0CA07.3000306@goop.org>
 <4CC0DEB8.1060309@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC0DEB8.1060309@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 05:45:44PM -0700, H. Peter Anvin wrote:
> On 10/21/2010 04:17 PM, Jeremy Fitzhardinge wrote:
> > 
> > Xen PV guests are always responsible for constructing ptes with machine
> > addresses in them (ie, doing their own pseudo-physical to machine
> > address conversion), and Xen verifies that the pages they want to map
> > either belong to them or have been granted to them.  The _PAGE_IOMAP
> > flag is a kernel-internal one which allows us to distinguish between
> > ptes intended to map memory vs machine hardware addresses; it is not
> > part of the Xen ABI.
> > 
> > If you're passing a device through to a domain, the domain is given
> > access to the device's address space so it can legally map those pages
> > (and if an IOMMU is available, the device is constrained to only DMA
> > that domain's memory).
> > 
> 
> Okay, could you clarify this part a bit?  Why does the kernel need to
> know the difference between "pseudo-physical" and "machine addresses" at
> all?  If they overlap, there is a problem, and if they don't overlap, it
> will be a 1:1 mapping anyway...

The flag (_PAGE_IOMAP) is used when we set the PTE so that the MFN value is
used instead of the PFN. We need that b/c when a driver does page_to_pfn()
it ends up using the PFN as bus address to write out registers data.

Without this patch, the page->virt->PFN value is used and the PFN != to real MFN
so we end up writing in a memory address that the PCI device has no idea about.
By setting the PTE with the MFN, the virt->PFN gets the real MFN value.

The drivers I am talking about are mostly, if not all, located in drivers/gpu
and it looks that we are missing two more patches to utilize the patch
that Jeremy posted.

Please note that I am _not_ suggesting that the two patches
below should go out - I still need to post them on drm mailing list.


commit 1b5a6e09831f44445cdb96f29c287e18d0317136
Author: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date:   Fri Oct 2 09:49:05 2009 -0700

    drm: recompute vma->vm_page_prot after changing vm_flags
    
    vm_get_page_prot() computes vm_page_prot depending on vm_flags, so
    we need to re-call it if we change flags.
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
index 1c040d0..3dc8d6b 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -272,6 +272,7 @@ int ttm_bo_mmap(struct file *filp, struct vm_area_struct *vma,
 
 	vma->vm_private_data = bo;
 	vma->vm_flags |= VM_RESERVED | VM_IO | VM_MIXEDMAP | VM_DONTEXPAND;
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	return 0;
 out_unref:
 	ttm_bo_unref(&bo);
@@ -287,6 +288,7 @@ int ttm_fbdev_mmap(struct vm_area_struct *vma, struct ttm_buffer_object *bo)
 	vma->vm_ops = &ttm_bo_vm_ops;
 	vma->vm_private_data = ttm_bo_reference(bo);
 	vma->vm_flags |= VM_RESERVED | VM_IO | VM_MIXEDMAP | VM_DONTEXPAND;
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	return 0;
 }
 EXPORT_SYMBOL(ttm_fbdev_mmap);

commit 9551827190db2d34f106255f0b5bfdc452e85cd8
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Mon Jul 26 14:15:55 2010 -0400

    ttm: Set VM_IO only on pages with TTM_MEMTYPE_FLAG_NEEDS_IOREMAP set.
    
    This patch is based on "[Patch RFC] ttm: nouveau accelerated on Xen
    pv-ops kernel"
    http://lists.freedesktop.org/archives/nouveau/2010-March/005326.html
    
    Under Xen, the PFN of page is virtualized. The physical addresses used
    for DMA programming needs to be the Machine Frame Number (MFN).
    Xen transparently does the correct translation using the _PAGE_IOMEM
    PTE bit. If the bit is set, Xen assumes that the backing memory is in
    the IOMEM space, and PFN equals MFN. If not set, page_to_pfn() returns
    a phantom MFN.
    
    The patch enables the ttm_bo_vm_fault() handler to behave correctly
    under Xen, and has no side-effects on normal (not under Xen) operations.
    
    The use of TTM_MEMTYPE_FLAG_NEEDS_IOREMAP in the check assumes that
    only pages which have this flag are backed by device memory or IO.
    
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    Signed-off-by: Arvind R <arvino55@gmail.com>

diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
index 3dc8d6b..ea3b8fb 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -239,6 +239,7 @@ int ttm_bo_mmap(struct file *filp, struct vm_area_struct *vma,
 {
 	struct ttm_bo_driver *driver;
 	struct ttm_buffer_object *bo;
+	struct ttm_mem_type_manager *man;
 	int ret;
 
 	read_lock(&bdev->vm_lock);
@@ -271,7 +272,10 @@ int ttm_bo_mmap(struct file *filp, struct vm_area_struct *vma,
 	 */
 
 	vma->vm_private_data = bo;
-	vma->vm_flags |= VM_RESERVED | VM_IO | VM_MIXEDMAP | VM_DONTEXPAND;
+	vma->vm_flags |= VM_RESERVED | VM_MIXEDMAP | VM_DONTEXPAND;
+	man = &bdev->man[bo->mem.mem_type];
+	if (man->flags & TTM_MEMTYPE_FLAG_NEEDS_IOREMAP)
+		vma->vm_flags |= VM_IO;
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	return 0;
 out_unref:
@@ -288,7 +292,6 @@ int ttm_fbdev_mmap(struct vm_area_struct *vma, struct ttm_buffer_object *bo)
 	vma->vm_ops = &ttm_bo_vm_ops;
 	vma->vm_private_data = ttm_bo_reference(bo);
 	vma->vm_flags |= VM_RESERVED | VM_IO | VM_MIXEDMAP | VM_DONTEXPAND;
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
 	return 0;
 }
 EXPORT_SYMBOL(ttm_fbdev_mmap);
> 
> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
