Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab0KKQkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 11:40:51 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22488 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab0KKQku (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 11 Nov 2010 11:40:50 -0500
Date: Thu, 11 Nov 2010 11:40:29 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Ian Campbell <Ian.Campbell@citrix.com>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen: set vma flag VM_PFNMAP in the privcmd
 mmap file_op
Message-ID: <20101111164029.GB29405@dumpdata.com>
References: <alpine.DEB.2.00.1011111550230.1407@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011111550230.1407@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 03:55:49PM +0000, Stefano Stabellini wrote:
> Hi all,
> this patch fixes the dom0 kernel crash when creating a VM.
> Now I am able to create VMs successfully on 2.6.37 rc1, even though
> without disk or network access.
> 
> ---
> 
> xen: set vma flag VM_PFNMAP in the privcmd mmap file_op
> 
> Set VM_PFNMAP in the privcmd mmap file_op, rather than later in
> xen_remap_domain_mfn_range when it is too late because
> vma_wants_writenotify has already been called and vm_page_prot has

So vma_wants_writenotify sets the invalid flags on vma->vm_flags?
> already been modified.

By whom? vma_wants_writenotify looks to just return 0 or 1

Ah, depending on that return value it sets vma->vm_page_prot.
That looks odd, so if this:

1215         if (vma_wants_writenotify(vma))
1216                 vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
1217 

does not set the vma->vm_page_prot we never set the vm_page_prot?

.. and it looks to not set that value earlier on either.

So VM_PFNMAP inhibits the mmap code from setting the vm_page_prot.
Is that what we want, not have vma->vm_page_prot set anything? Why?

> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index c237b81..2be1f36 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -2627,7 +2627,7 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
>  
>  	prot = __pgprot(pgprot_val(prot) | _PAGE_IOMAP);
>  
> -	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
> +	BUG_ON(!(vma->vm_flags & (VM_PFNMAP | VM_RESERVED | VM_IO)));
>  
>  	rmd.mfn = mfn;
>  	rmd.prot = prot;
> diff --git a/drivers/xen/xenfs/privcmd.c b/drivers/xen/xenfs/privcmd.c
> index f80be7f..9aab216 100644
> --- a/drivers/xen/xenfs/privcmd.c
> +++ b/drivers/xen/xenfs/privcmd.c
> @@ -385,7 +385,7 @@ static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
>  		return -ENOSYS;
>  
>  	/* DONTCOPY is essential for Xen as copy_page_range is broken. */
> -	vma->vm_flags |= VM_RESERVED | VM_IO | VM_DONTCOPY;
> +	vma->vm_flags |= VM_RESERVED | VM_IO | VM_DONTCOPY | VM_PFNMAP;
>  	vma->vm_ops = &privcmd_vm_ops;
>  	vma->vm_private_data = NULL;
>  
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
