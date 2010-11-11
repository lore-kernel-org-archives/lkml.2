Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0KKRVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 12:21:39 -0500
Received: from claw.goop.org ([74.207.240.146]:35395 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754405Ab0KKRVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 12:21:38 -0500
Message-ID: <4CDC261E.5060106@goop.org>
Date: Thu, 11 Nov 2010 09:21:34 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com, Ian Campbell <Ian.Campbell@citrix.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen: set vma flag VM_PFNMAP in the privcmd
 mmap file_op
References: <alpine.DEB.2.00.1011111550230.1407@kaball-desktop> <20101111164029.GB29405@dumpdata.com>
In-Reply-To: <20101111164029.GB29405@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2010 08:40 AM, Konrad Rzeszutek Wilk wrote:
> On Thu, Nov 11, 2010 at 03:55:49PM +0000, Stefano Stabellini wrote:
>> Hi all,
>> this patch fixes the dom0 kernel crash when creating a VM.
>> Now I am able to create VMs successfully on 2.6.37 rc1, even though
>> without disk or network access.
>>
>> ---
>>
>> xen: set vma flag VM_PFNMAP in the privcmd mmap file_op
>>
>> Set VM_PFNMAP in the privcmd mmap file_op, rather than later in
>> xen_remap_domain_mfn_range when it is too late because
>> vma_wants_writenotify has already been called and vm_page_prot has
> So vma_wants_writenotify sets the invalid flags on vma->vm_flags?
>> already been modified.
> By whom? vma_wants_writenotify looks to just return 0 or 1
>
> Ah, depending on that return value it sets vma->vm_page_prot.
> That looks odd, so if this:
>
> 1215         if (vma_wants_writenotify(vma))
> 1216                 vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
> 1217 
>
> does not set the vma->vm_page_prot we never set the vm_page_prot?
>
> .. and it looks to not set that value earlier on either.
>
> So VM_PFNMAP inhibits the mmap code from setting the vm_page_prot.
> Is that what we want, not have vma->vm_page_prot set anything? Why?

It is already set unconditionally earlier in mmap_region().  The
writenotify stuff will knobble the mapping to be RO so we can track the
first write with faults, but we don't want that in this case.

The VM_PFNMAP flag is generally correct anyway, since it means that the
mapping is of a random PFN which no corresponding struct page.

    J

>> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>
>> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
>> index c237b81..2be1f36 100644
>> --- a/arch/x86/xen/mmu.c
>> +++ b/arch/x86/xen/mmu.c
>> @@ -2627,7 +2627,7 @@ int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
>>  
>>  	prot = __pgprot(pgprot_val(prot) | _PAGE_IOMAP);
>>  
>> -	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
>> +	BUG_ON(!(vma->vm_flags & (VM_PFNMAP | VM_RESERVED | VM_IO)));
>>  
>>  	rmd.mfn = mfn;
>>  	rmd.prot = prot;
>> diff --git a/drivers/xen/xenfs/privcmd.c b/drivers/xen/xenfs/privcmd.c
>> index f80be7f..9aab216 100644
>> --- a/drivers/xen/xenfs/privcmd.c
>> +++ b/drivers/xen/xenfs/privcmd.c
>> @@ -385,7 +385,7 @@ static int privcmd_mmap(struct file *file, struct vm_area_struct *vma)
>>  		return -ENOSYS;
>>  
>>  	/* DONTCOPY is essential for Xen as copy_page_range is broken. */
>> -	vma->vm_flags |= VM_RESERVED | VM_IO | VM_DONTCOPY;
>> +	vma->vm_flags |= VM_RESERVED | VM_IO | VM_DONTCOPY | VM_PFNMAP;
>>  	vma->vm_ops = &privcmd_vm_ops;
>>  	vma->vm_private_data = NULL;
>>  
>>
>> _______________________________________________
>> Xen-devel mailing list
>> Xen-devel@lists.xensource.com
>> http://lists.xensource.com/xen-devel
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
>

