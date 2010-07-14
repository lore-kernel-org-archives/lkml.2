Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0GNNHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:07:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab0GNNHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:07:02 -0400
Message-ID: <4C3DB671.1090802@redhat.com>
Date: Wed, 14 Jul 2010 16:06:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 1/4] KVM: MMU: fix forgot reserved bits check in speculative
 path
References: <4C3C3518.7080505@cn.fujitsu.com>
In-Reply-To: <4C3C3518.7080505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 12:42 PM, Xiao Guangrong wrote:
> In the speculative path, we should check guest pte's reserved bits just as
> the real processor does
>
> Reported-by: Marcelo Tosatti<mtosatti@redhat.com>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/mmu.c         |    8 ++++++++
>   arch/x86/kvm/paging_tmpl.h |    5 +++--
>   2 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index b93b94f..9fc1524 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2783,6 +2783,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>   		break;
>   	}
>
> +	if (is_rsvd_bits_set(vcpu, gentry, PT_PAGE_TABLE_LEVEL))
> +		gentry = 0;
> +
>   	mmu_guess_page_from_pte_write(vcpu, gpa, gentry);
>   	spin_lock(&vcpu->kvm->mmu_lock);
>   	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
> @@ -2851,6 +2854,11 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>   		while (npte--) {
>   			entry = *spte;
>   			mmu_pte_write_zap_pte(vcpu, sp, spte);
> +
> +			if (!!is_pae(vcpu) != sp->role.cr4_pae ||
> +			      is_nx(vcpu) != sp->role.nxe)
> +				continue;
> +
>    

Do we also need to check cr0.wp?  I think so.

>   			if (gentry)
>   				mmu_pte_write_new_pte(vcpu, sp, spte,&gentry);
>    

Please move the checks to mmu_pte_write_new_pte(), it's a more logical 
place.

It means the reserved bits check happens multiple times, but that's ok.

Also, you can use arch.mmu.base_role to compare:

     static const kvm_mmu_page_role mask = { .level = -1U, .cr4_pae = 1, 
... };

     if ((sp->role.word ^ base_role.word) & mask.word)
          return;

> @@ -640,8 +640,9 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   			return -EINVAL;
>
>   		gfn = gpte_to_gfn(gpte);
> -		if (gfn != sp->gfns[i] ||
> -		      !is_present_gpte(gpte) || !(gpte&  PT_ACCESSED_MASK)) {
> +		if (is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL) ||
> +		      gfn != sp->gfns[i] || !is_present_gpte(gpte) ||
> +		      !(gpte&  PT_ACCESSED_MASK)) {
>   			u64 nonpresent;
>
>   			if (is_present_gpte(gpte) || !clear_unsync)
>    

Eventually we have to reduce the number of paths.  But lets fix things 
first.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

