Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab2EUIJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:09:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab2EUII6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:08:58 -0400
Date: Mon, 21 May 2012 11:08:56 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: fix async page fault working for readonly mapping
Message-ID: <20120521080856.GS10209@redhat.com>
References: <4FB9E499.2010505@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB9E499.2010505@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 02:45:45PM +0800, Xiao Guangrong wrote:
> If we map a readonly memory space from host to guest and the page is
> not currently mapped in the host, we will get a fault-pfn and async
> is not allowed, then the vm will crash
> 
Why would we want to map a readonly memory space from host to guest?
We may want to do it to support memory semantics on read and mmio on
write, but do not right now unless something changed while I was not
looking.

> The reason is only writable vma can be allowed to be async in current
> code
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  virt/kvm/kvm_main.c |   19 +++++++++++++++++--
>  1 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6bd34a6..b6c8962 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1052,6 +1052,21 @@ static inline int check_user_page_hwpoison(unsigned long addr)
>  	return rc == -EHWPOISON;
>  }
> 
> +static bool vma_is_avalid(struct vm_area_struct *vma, bool write_fault)
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
> +	return true;
> +}
> +
>  static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
>  			bool *async, bool write_fault, bool *writable)
>  {
> @@ -1075,7 +1090,6 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
> 
>  		if (writable)
>  			*writable = write_fault;
> -
>  		if (async) {
>  			down_read(&current->mm->mmap_sem);
>  			npages = get_user_page_nowait(current, current->mm,
> @@ -1122,8 +1136,9 @@ static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr, bool atomic,
>  				vma->vm_pgoff;
>  			BUG_ON(!kvm_is_mmio_pfn(pfn));
>  		} else {
> -			if (async && (vma->vm_flags & VM_WRITE))
> +			if (async && vma_is_avalid(vma, write_fault))
>  				*async = true;
> +
>  			pfn = get_fault_pfn();
>  		}
>  		up_read(&current->mm->mmap_sem);
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
