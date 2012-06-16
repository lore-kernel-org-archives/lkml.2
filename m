Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab2FPCR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 22:17:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab2FPCR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 22:17:57 -0400
Date: Fri, 15 Jun 2012 23:11:51 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 6/6] KVM: introduce readonly memslot
Message-ID: <20120616021150.GA3870@amt.cnet>
References: <4FD6ADA6.40008@linux.vnet.ibm.com>
 <4FD6AE3B.9020508@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD6AE3B.9020508@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 10:49:31AM +0800, Xiao Guangrong wrote:
> In current code, if we map a readonly memory space from host to guest
> and the page is not currently mapped in the host, we will get a fault-pfn
> and async is not allowed, then the vm will crash
> 
> Address Avi's idea, we introduce readonly memory region to map ROM/ROMD
> to the guest

Please detail what is the idea in the changelog (a commit message should 
contain information or precise references to discussions).

> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  Documentation/virtual/kvm/api.txt |    9 ++++--
>  arch/x86/kvm/x86.c                |    1 +
>  include/linux/kvm.h               |    4 ++-
>  virt/kvm/kvm_main.c               |   61 ++++++++++++++++++++++++++++--------
>  4 files changed, 57 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 310fe50..a97ee90 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -857,7 +857,8 @@ struct kvm_userspace_memory_region {
>  };
> 
>  /* for kvm_memory_region::flags */
> -#define KVM_MEM_LOG_DIRTY_PAGES  1UL
> +#define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
> +#define KVM_MEM_READONLY	(1UL << 1)
> 
>  This ioctl allows the user to create or modify a guest physical memory
>  slot.  When changing an existing slot, it may be moved in the guest
> @@ -873,9 +874,11 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
>  be identical.  This allows large pages in the guest to be backed by large
>  pages in the host.
> 
> -The flags field supports just one flag, KVM_MEM_LOG_DIRTY_PAGES, which
> +The flags field supports two flag, KVM_MEM_LOG_DIRTY_PAGES, which
>  instructs kvm to keep track of writes to memory within the slot.  See
> -the KVM_GET_DIRTY_LOG ioctl.
> +the KVM_GET_DIRTY_LOG ioctl. Another flag is KVM_MEM_READONLY, which
> ++indicates the guest memory is read-only, that means, guest is only allowed
> ++to read it. Writes will be posted to userspace as KVM_EXIT_MMIO exits.

Can you introduce a separate exit reason, say KVM_EXIT_READ_FAULT, with
information about the fault?

Then perform this exit only if userspace allows it by explicit enable, 
and by default have the exit_read_fault handler jump to the mmio
handler. 

> 
> +static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
> +{
> +	if (unlikely(!(vma->vm_flags & VM_READ)))
> +		return false;
> +
> +	if (write_fault && (unlikely(!(vma->vm_flags & VM_WRITE))))
> +		return false;
> +
> +	return true;
> +}
> +
> +static int hva_to_pfn_fast(unsigned long addr, bool atomic, bool *async,
> +			bool slot_writable, bool *writable, struct page **page)
> +{
> +	int npages = 0;
> +
> +	if (!slot_writable)
> +		return 0;
> +
> +	if (writable)
> +		*writable = true;
> +
> +	if (atomic || async)
> +		npages = __get_user_pages_fast(addr, 1, 1, page);
> +
> +	return npages;
> +}
> +
>  static pfn_t hva_to_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  			unsigned long addr, bool atomic, bool *async,
>  			bool write_fault, bool *writable)
> @@ -1105,18 +1140,16 @@ static pfn_t hva_to_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	struct page *page[1];
>  	int npages = 0;
>  	pfn_t pfn;
> +	bool slot_writable = !(slot->flags & KVM_MEM_READONLY);
> 
>  	/* we can do it either atomically or asynchronously, not both */
>  	BUG_ON(atomic && async);
> 
>  	BUG_ON(!write_fault && !writable);
> +	BUG_ON(write_fault && !slot_writable);

Why BUG_ON on this condition?


