Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab0KKRms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:42:48 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:21750 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab0KKRmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:42:47 -0500
X-IronPort-AV: E=Sophos;i="4.59,184,1288569600"; 
   d="scan'208";a="2824382"
Date: Thu, 11 Nov 2010 17:42:45 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: set vma flag VM_PFNMAP in the privcmd
 mmap file_op
In-Reply-To: <4CDC261E.5060106@goop.org>
Message-ID: <alpine.DEB.2.00.1011111737130.2373@kaball-desktop>
References: <alpine.DEB.2.00.1011111550230.1407@kaball-desktop> <20101111164029.GB29405@dumpdata.com> <4CDC261E.5060106@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 11 Nov 2010, Jeremy Fitzhardinge wrote:

> On 11/11/2010 08:40 AM, Konrad Rzeszutek Wilk wrote:
> > On Thu, Nov 11, 2010 at 03:55:49PM +0000, Stefano Stabellini wrote:
> >> Hi all,
> >> this patch fixes the dom0 kernel crash when creating a VM.
> >> Now I am able to create VMs successfully on 2.6.37 rc1, even though
> >> without disk or network access.
> >>
> >> ---
> >>
> >> xen: set vma flag VM_PFNMAP in the privcmd mmap file_op
> >>
> >> Set VM_PFNMAP in the privcmd mmap file_op, rather than later in
> >> xen_remap_domain_mfn_range when it is too late because
> >> vma_wants_writenotify has already been called and vm_page_prot has
> > So vma_wants_writenotify sets the invalid flags on vma->vm_flags?
> >> already been modified.
> > By whom? vma_wants_writenotify looks to just return 0 or 1
> >
> > Ah, depending on that return value it sets vma->vm_page_prot.
> > That looks odd, so if this:
> >
> > 1215         if (vma_wants_writenotify(vma))
> > 1216                 vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
> > 1217 
> >
> > does not set the vma->vm_page_prot we never set the vm_page_prot?
> >
> > .. and it looks to not set that value earlier on either.
> >
> > So VM_PFNMAP inhibits the mmap code from setting the vm_page_prot.
> > Is that what we want, not have vma->vm_page_prot set anything? Why?
> 
> It is already set unconditionally earlier in mmap_region().  The
> writenotify stuff will knobble the mapping to be RO so we can track the
> first write with faults, but we don't want that in this case.
> 

exactly.

> The VM_PFNMAP flag is generally correct anyway, since it means that the
> mapping is of a random PFN which no corresponding struct page.
> 

I think so too.

This is an update of the patch, with a more correct BUG_ON condition.

---

xen: set vma flag VM_PFNMAP in the privcmd mmap file_op

Set VM_PFNMAP in the privcmd mmap file_op, rather than later in
xen_remap_domain_mfn_range when it is too late because
vma_wants_writenotify has already been called and vm_page_prot has
already been modified.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index c237b81..f61b75d 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2627,7 +2627,8 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 
 	prot = __pgprot(pgprot_val(prot) | _PAGE_IOMAP);
 
-	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
+	BUG_ON(!((vma->vm_flags & (VM_PFNMAP | VM_RESERVED | VM_IO)) ==
+				(VM_PFNMAP | VM_RESERVED | VM_IO)));
 
 	rmd.mfn = mfn;
 	rmd.prot = prot;
diff --git a/drivers/xen/xenfs/privcmd.c b/drivers/xen/xenfs/privcmd.c
index f80be7f..48f7b0f 100644
--- a/drivers/xen/xenfs/privcmd.c
+++ b/drivers/xen/xenfs/privcmd.c
@@ -384,8 +384,9 @@ static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
 	if (xen_feature(XENFEAT_auto_translated_physmap))
 		return -ENOSYS;
 
-	/* DONTCOPY is essential for Xen as copy_page_range is broken. */
-	vma->vm_flags |= VM_RESERVED | VM_IO | VM_DONTCOPY;
+	/* DONTCOPY is essential for Xen because copy_page_range doesn't know
+	 * how to recreate these mappings */
+	vma->vm_flags |= VM_RESERVED | VM_IO | VM_DONTCOPY | VM_PFNMAP;
 	vma->vm_ops = &privcmd_vm_ops;
 	vma->vm_private_data = NULL;
 
