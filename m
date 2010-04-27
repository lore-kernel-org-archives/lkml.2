Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab0D0Mwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:52:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0D0Mwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:52:43 -0400
Message-ID: <4BD6DE15.8070409@redhat.com>
Date: Tue, 27 Apr 2010 15:52:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/22] KVM: MMU: Introduce kvm_read_guest_page_x86()
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-16-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1272364712-17425-16-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 01:38 PM, Joerg Roedel wrote:
> This patch introduces the kvm_read_guest_page_x86 function
> which reads from the physical memory of the guest. If the
> guest is running in guest-mode itself with nested paging
> enabled it will read from the guest's guest physical memory
> instead.
> The patch also changes changes the code to use this function
> where it is necessary.
>
>
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7851bbc..d9dfc8c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -254,6 +254,13 @@ struct kvm_mmu {
>   	union kvm_mmu_page_role base_role;
>   	bool direct_map;
>
> +	/*
> +	 * If true the mmu runs in two-level mode.
> +	 * vcpu->arch.nested_mmu needs to contain meaningful values in
> +	 * this case.
> +	 */
> +	bool nested;
> +
>    

struct mmu_context *active_mmu? (in vcpu->arch)

>   	u64 *pae_root;
>   	u64 rsvd_bits_mask[2][4];
>   };
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 558d995..317ad26 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -379,6 +379,20 @@ int kvm_read_guest_page_tdp(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>   }
>   EXPORT_SYMBOL_GPL(kvm_read_guest_page_tdp);
>
> +int kvm_read_guest_page_x86(struct kvm_vcpu *vcpu, gfn_t gfn,
> +			    void *data, int offset, int len, u32 *error)
> +{
> +	struct kvm_mmu *mmu;
> +
> +	if (vcpu->arch.mmu.nested)
> +		mmu =&vcpu->arch.nested_mmu;
> +	else
> +		mmu =&vcpu->arch.mmu;
> +
> +	return kvm_read_guest_page_tdp(vcpu, mmu, gfn, data, offset, len,
> +				       error);
> +}
>    

This is really not x86 specific (though the implementation certainly 
is).  s390 will have exactly the same need when it gets nested virt.  I 
think this can be folded into 
kvm_read_guest_page_tdp()/kvm_read_nested_guest_page().


-- 
error compiling committee.c: too many arguments to function

