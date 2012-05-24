Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab2EXMKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 08:10:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab2EXMKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 08:10:20 -0400
Message-ID: <4FBE2521.1050800@redhat.com>
Date: Thu, 24 May 2012 15:10:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2] KVM: introduce readonly memory region
References: <4FBDFE52.5090902@linux.vnet.ibm.com>
In-Reply-To: <4FBDFE52.5090902@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 12:24 PM, Xiao Guangrong wrote:
> In current code, if we map a readonly memory space from host to guest
> and the page is not currently mapped in the host, we will get a fault-pfn
> and async is not allowed, then the vm will crash
> 
> Address Avi's idea, we introduce readonly memory region to map ROM/ROMD
> to the guest
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  Documentation/virtual/kvm/api.txt |    9 +++++--
>  include/linux/kvm.h               |    5 ++-
>  virt/kvm/kvm_main.c               |   43 ++++++++++++++++++++++++++++++-------
>  3 files changed, 44 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 9301266..e2a82c3 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -857,7 +857,8 @@ struct kvm_userspace_memory_region {
>  };
> 
>  /* for kvm_memory_region::flags */
> -#define KVM_MEM_LOG_DIRTY_PAGES  1UL
> +#define KVM_MEM_LOG_DIRTY_PAGES		1UL
> +#define KVM_MEM_READ_ONLY		(1UL << 2)

Bit 1 should be fine too, see below.

> 
>  This ioctl allows the user to create or modify a guest physical memory
>  slot.  When changing an existing slot, it may be moved in the guest
> @@ -873,9 +874,11 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
>  be identical.  This allows large pages in the guest to be backed by large
>  pages in the host.
> 
> -The flags field supports just one flag, KVM_MEM_LOG_DIRTY_PAGES, which
> +The flags field supports two flags, KVM_MEM_LOG_DIRTY_PAGES, which
>  instructs kvm to keep track of writes to memory within the slot.  See
> -the KVM_GET_DIRTY_LOG ioctl.
> +the KVM_GET_DIRTY_LOG ioctl. Another flag is KVM_MEM_READ_ONLY, which
> +indicates the guest memory is read-only, that means, guest is only allowed
> +to read it.

+ Writes will be posted to userspace as KVM_EXIT_MMIO exits.

> 
>  /* for kvm_memory_region::flags */
> -#define KVM_MEM_LOG_DIRTY_PAGES  1UL
> -#define KVM_MEMSLOT_INVALID      (1UL << 1)
> +#define KVM_MEM_LOG_DIRTY_PAGES		1UL
> +#define KVM_MEMSLOT_INVALID		(1UL << 1)
> +#define KVM_MEM_READ_ONLY		(1UL << 2)

KVM_MEMSLOT_INVALID is actually an internal symbol, not used by
userspace.  Please move it to kvm_host.h.

I see that we don't check flags for validity.  Please add a check that
we don't use undefined flags and return -EINVAL.  Should be a separate
patch since we may want to backport it.

We need a KVM_CAP_ so userspace knows it can use the feature.  Only x86
should respond to it now, until (or if) other archs are updated.

> 
> +static bool vma_is_avalid(struct vm_area_struct *vma, bool write_fault)

s/avalid/valid/.

> +{
> +	if (write_fault) {
> +		if (unlikely(!(vma->vm_flags & VM_WRITE)))
> +			return false;
> +
> +		return true;
> +	}
> +
> +	if (unlikely(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE))))
> +		return false;
> +

Strange check.  VM_EXEC doesn't concern us at all.  Maybe we should
check for VM_READ always, and VM_WRITE for write faults.

> +	return true;
> +}
> +
>  static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
>  			bool *async, bool write_fault, bool *writable)
>  {
> @@ -1076,7 +1103,6 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
> 
>  		if (writable)
>  			*writable = write_fault;
> -
>  		if (async) {
>  			down_read(&current->mm->mmap_sem);
>  			npages = get_user_page_nowait(current, current->mm,
> @@ -1123,8 +1149,9 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
>  				vma->vm_pgoff;
>  			BUG_ON(!kvm_is_mmio_pfn(pfn));
>  		} else {
> -			if (async && (vma->vm_flags & VM_WRITE))
> +			if (async && vma_is_avalid(vma, write_fault))
>  				*async = true;
> +


This checks based on the fault type, not memslot type.  So we have the
risk of the pfn later used for writes?

>  			pfn = get_fault_pfn();
>  		}
>  		up_read(&current->mm->mmap_sem);
> @@ -1148,7 +1175,7 @@ static pfn_t __gfn_to_pfn(struct kvm *kvm, gfn_t gfn, bool atomic, bool *async,
>  	if (async)
>  		*async = false;
> 
> -	addr = gfn_to_hva(kvm, gfn);
> +	addr = gfn_to_hva_prot(kvm, gfn, write_fault);
>  	if (kvm_is_error_hva(addr)) {
>  		get_page(bad_page);
>  		return page_to_pfn(bad_page);
> @@ -1293,7 +1320,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
>  	int r;
>  	unsigned long addr;
> 
> -	addr = gfn_to_hva(kvm, gfn);
> +	addr = gfn_to_hva_prot(kvm, gfn, false);
>  	if (kvm_is_error_hva(addr))
>  		return -EFAULT;
>  	r = __copy_from_user(data, (void __user *)addr + offset, len);
> @@ -1331,7 +1358,7 @@ int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
>  	gfn_t gfn = gpa >> PAGE_SHIFT;
>  	int offset = offset_in_page(gpa);
> 
> -	addr = gfn_to_hva(kvm, gfn);
> +	addr = gfn_to_hva_prot(kvm, gfn, false);
>  	if (kvm_is_error_hva(addr))
>  		return -EFAULT;
>  	pagefault_disable();

Surprised only those places.

How do we make sure a pfn obtained with write = false isn't later used
for writing?



-- 
error compiling committee.c: too many arguments to function
