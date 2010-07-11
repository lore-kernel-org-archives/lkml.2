Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab0GKMZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 08:25:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab0GKMZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 08:25:02 -0400
Message-ID: <4C39B81A.5080000@redhat.com>
Date: Sun, 11 Jul 2010 15:24:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 1/9] KVM: MMU: fix forgot reserved bits check in speculative
 path
References: <4C330918.6040709@cn.fujitsu.com>
In-Reply-To: <4C330918.6040709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2010 01:44 PM, Xiao Guangrong wrote:
> In the speculative path, we should check guest pte's reserved bits just as
> the real processor does
>
> Reported-by: Marcelo Tosatti<mtosatti@redhat.com>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/mmu.c         |    3 +++
>   arch/x86/kvm/paging_tmpl.h |    3 ++-
>   2 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 104756b..3dcd55d 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2781,6 +2781,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>   		break;
>   	}
>
> +	if (is_rsvd_bits_set(vcpu, gentry, PT_PAGE_TABLE_LEVEL))
> +		gentry = 0;
> +
>    

That only works if the gpte is for the same mode as the current vcpu mmu 
mode.  In some cases it is too strict (vcpu in pae mode writing a 32-bit 
gpte), which is not too bad, in some cases it is too permissive (vcpu in 
nonpae mode writing a pae gpte).

(once upon a time mixed modes were rare, only on OS setup, but with 
nested virt they happen all the time).

>   	mmu_guess_page_from_pte_write(vcpu, gpa, gentry);
>   	spin_lock(&vcpu->kvm->mmu_lock);
>   	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index dfb2720..19f0077 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -628,7 +628,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>   		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
>
>   		if (kvm_read_guest_atomic(vcpu->kvm, pte_gpa,&gpte,
> -					  sizeof(pt_element_t)))
> +					  sizeof(pt_element_t)) ||
> +		      is_rsvd_bits_set(vcpu, gpte, PT_PAGE_TABLE_LEVEL))
>   			return -EINVAL;
>    

This is better done a few lines down where we check for 
!is_present_gpte(), no?

-- 
error compiling committee.c: too many arguments to function

