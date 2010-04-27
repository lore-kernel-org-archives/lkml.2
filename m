Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab0D0Hre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 03:47:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab0D0Hrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 03:47:32 -0400
Message-ID: <4BD69680.10402@redhat.com>
Date: Tue, 27 Apr 2010 10:47:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, masbock@linux.vnet.ibm.com
Subject: Re: [PATCH 2/2] KVM, Fix QEMU-KVM is killed by guest SRAO MCE
References: <1272351860.24125.15.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1272351860.24125.15.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(please copy kvm@vger.kernel.org on kvm patches)


On 04/27/2010 10:04 AM, Huang Ying wrote:
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
>
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -32,6 +32,7 @@
>   #include<linux/compiler.h>
>   #include<linux/srcu.h>
>   #include<linux/slab.h>
> +#include<linux/uaccess.h>
>
>   #include<asm/page.h>
>   #include<asm/cmpxchg.h>
> @@ -1972,6 +1973,17 @@ static int __direct_map(struct kvm_vcpu
>   	return pt_write;
>   }
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
>    

No error check?  What will a copy_from_user() of poisoned page expected 
to return?

Best to return -EFAULT on failure for consistency.

> +}
> +
>   static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
>   {
>   	int r;
> @@ -1997,7 +2009,11 @@ static int nonpaging_map(struct kvm_vcpu
>   	/* mmio */
>   	if (is_error_pfn(pfn)) {
>   		kvm_release_pfn_clean(pfn);
> -		return 1;
> +		if (is_hwpoison_pfn(pfn)) {
> +			kvm_send_hwpoison_signal(vcpu->kvm, gfn);
> +			return 0;
> +		} else
> +			return 1;
>   	}
>    

This is duplicated several times.  Please introduce a kvm_handle_bad_page():

     if (is_error_pfn(pfn))
         return kvm_handle_bad_page(vcpu->kvm, gfn, pfn);

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

