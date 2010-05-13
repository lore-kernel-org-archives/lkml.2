Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab0EMVrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:47:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932519Ab0EMVrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:47:12 -0400
Date: Thu, 13 May 2010 18:43:07 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Avi Kivity <avi@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, masbock@linux.vnet.ibm.com,
       "Wu, Fengguang" <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH -v2] KVM, Fix QEMU-KVM is killed by guest SRAO MCE
Message-ID: <20100513214307.GA25003@amt.cnet>
References: <1273646643.3564.51.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273646643.3564.51.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 02:44:03PM +0800, Huang Ying wrote:
> In common cases, guest SRAO MCE will cause corresponding poisoned page
> be un-mapped and SIGBUS be sent to QEMU-KVM, then QEMU-KVM will relay
> the MCE to guest OS.
> 
> But it is reported that if the poisoned page is accessed in guest
> after un-mapped and before MCE is relayed to guest OS, QEMU-KVM will
> be killed.
> 
> The reason is as follow. Because poisoned page has been un-mapped,
> guest access will cause guest exit and kvm_mmu_page_fault will be
> called. kvm_mmu_page_fault can not get the poisoned page for fault
> address, so kernel and user space MMIO processing is tried in turn. In
> user MMIO processing, poisoned page is accessed again, then QEMU-KVM
> is killed by force_sig_info.
> 
> To fix the bug, kvm_mmu_page_fault send HWPOISON signal to QEMU-KVM
> and do not try kernel and user space MMIO processing for poisoned
> page.
> 
> 
> Changelog:
> 
> v2:
> 
> - Use page table walker to determine whether the virtual address is
>   poisoned to avoid change user space interface (via changing
>   get_user_pages).
> 
> - Wrap bad page processing into kvm_handle_bad_page to avoid code
>   duplicating.
> 
> Reported-by: Max Asbock <masbock@linux.vnet.ibm.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  arch/x86/kvm/mmu.c         |   34 ++++++++++++++++++++++++++--------
>  arch/x86/kvm/paging_tmpl.h |    7 ++-----
>  include/linux/kvm_host.h   |    1 +
>  include/linux/mm.h         |    8 ++++++++
>  mm/memory-failure.c        |   28 ++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c        |   30 ++++++++++++++++++++++++++++--
>  6 files changed, 93 insertions(+), 15 deletions(-)
> 
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -32,6 +32,7 @@
>  #include <linux/compiler.h>
>  #include <linux/srcu.h>
>  #include <linux/slab.h>
> +#include <linux/uaccess.h>
>  
>  #include <asm/page.h>
>  #include <asm/cmpxchg.h>
> @@ -1975,6 +1976,27 @@ static int __direct_map(struct kvm_vcpu
>  	return pt_write;
>  }
>  
> +static void kvm_send_hwpoison_signal(struct kvm *kvm, gfn_t gfn)
> +{
> +	char buf[1];
> +	void __user *hva;
> +	int r;
> +
> +	/* Touch the page, so send SIGBUS */
> +	hva = (void __user *)gfn_to_hva(kvm, gfn);
> +	r = copy_from_user(buf, hva, 1);
> +}

A SIGBUS signal has been raised by memory poisoning already, so i don't
see why this is needed?

To avoid the MMIO processing in userspace before the MCE is sent to the
guest you can just return -EAGAIN from the page fault handlers back to
kvm_mmu_page_fault.

> +int is_hwpoison_pfn(pfn_t pfn)
> +{
> +	return pfn == hwpoison_pfn;
> +}
> +EXPORT_SYMBOL_GPL(is_hwpoison_pfn);
> +
>  static inline unsigned long bad_hva(void)
>  {
>  	return PAGE_OFFSET;
> @@ -939,6 +948,11 @@ static pfn_t hva_to_pfn(struct kvm *kvm,
>  	if (unlikely(npages != 1)) {
>  		struct vm_area_struct *vma;
>  
> +		if (is_hwpoison_address(addr)) {
> +			get_page(hwpoison_page);
> +			return page_to_pfn(hwpoison_page);
> +		}
> +
>  		down_read(&current->mm->mmap_sem);
>  		vma = find_vma(current->mm, addr);
>  
> @@ -2198,6 +2212,15 @@ int kvm_init(void *opaque, unsigned int
>  
>  	bad_pfn = page_to_pfn(bad_page);
>  
> +	hwpoison_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +
> +	if (hwpoison_page == NULL) {
> +		r = -ENOMEM;
> +		goto out_free_0;
> +	}
> +
> +	hwpoison_pfn = page_to_pfn(hwpoison_page);
> +
>  	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
>  		r = -ENOMEM;
>  		goto out_free_0;
> @@ -2269,6 +2292,8 @@ out_free_1:
>  out_free_0a:
>  	free_cpumask_var(cpus_hardware_enabled);
>  out_free_0:
> +	if (hwpoison_page)
> +		__free_page(hwpoison_page);
>  	__free_page(bad_page);
>  out:
>  	kvm_arch_exit();
> @@ -2291,6 +2316,7 @@ void kvm_exit(void)
>  	kvm_arch_hardware_unsetup();
>  	kvm_arch_exit();
>  	free_cpumask_var(cpus_hardware_enabled);
> +	__free_page(hwpoison_page);
>  	__free_page(bad_page);
>  }
>  EXPORT_SYMBOL_GPL(kvm_exit);
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -45,6 +45,7 @@
>  #include <linux/page-isolation.h>
>  #include <linux/suspend.h>
>  #include <linux/slab.h>
> +#include <linux/swapops.h>
>  #include "internal.h"
>  
>  int sysctl_memory_failure_early_kill __read_mostly = 0;
> @@ -1296,3 +1297,30 @@ done:
>  	/* keep elevated page count for bad page */
>  	return ret;
>  }
> +
> +int is_hwpoison_address(unsigned long addr)
> +{
> +	pgd_t *pgdp;
> +	pud_t *pudp;
> +	pmd_t *pmdp;
> +	pte_t pte, *ptep;
> +	swp_entry_t entry;
> +
> +	pgdp = pgd_offset(current->mm, addr);
> +	if (!pgd_present(*pgdp))
> +		return 0;
> +	pudp = pud_offset(pgdp, addr);
> +	if (!pud_present(*pudp))
> +		return 0;
> +	pmdp = pmd_offset(pudp, addr);
> +	if (!pmd_present(*pmdp))
> +		return 0;

Need to bail out if pmd is huge.

> +	ptep = pte_offset_map(pmdp, addr);
> +	pte = *ptep;
> +	pte_unmap(ptep);
> +	if (!is_swap_pte(pte))
> +		return 0;
> +	entry = pte_to_swp_entry(pte);
> +	return is_hwpoison_entry(entry);
> +}
> +EXPORT_SYMBOL_GPL(is_hwpoison_address);
