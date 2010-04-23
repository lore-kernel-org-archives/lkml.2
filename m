Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335Ab0DWL1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 07:27:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab0DWL1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 07:27:18 -0400
Message-ID: <4BD18410.6030509@redhat.com>
Date: Fri, 23 Apr 2010 14:27:12 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/10] KVM MMU: Move invlpg code out of paging_tmpl.h
References: <4BCFE3D5.5070105@cn.fujitsu.com> <4BCFE8E2.8080302@cn.fujitsu.com>
In-Reply-To: <4BCFE8E2.8080302@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2010 09:12 AM, Xiao Guangrong wrote:
> Using '!sp->role.cr4_pae' replaces 'PTTYPE == 32' and using
> 'pte_size = sp->role.cr4_pae ? 8 : 4' replaces sizeof(pt_element_t)
>
> Then no need compile twice for this code
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/mmu.c         |   60 ++++++++++++++++++++++++++++++++++++++++++-
>   arch/x86/kvm/paging_tmpl.h |   56 -----------------------------------------
>   2 files changed, 58 insertions(+), 58 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index abf8bd4..fac7c09 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2256,6 +2256,62 @@ static bool is_rsvd_bits_set(struct kvm_vcpu *vcpu, u64 gpte, int level)
>   	return (gpte&  vcpu->arch.mmu.rsvd_bits_mask[bit7][level-1]) != 0;
>   }
>
> +static void paging_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
> +{
> +	struct kvm_shadow_walk_iterator iterator;
> +	gpa_t pte_gpa = -1;
> +	int level;
> +	u64 *sptep;
> +	int need_flush = 0;
> +	unsigned pte_size = 0;
> +
> +	spin_lock(&vcpu->kvm->mmu_lock);
> +
> +	for_each_shadow_entry(vcpu, gva, iterator) {
> +		level = iterator.level;
> +		sptep = iterator.sptep;
> +
> +		if (level == PT_PAGE_TABLE_LEVEL  ||
> +		    ((level == PT_DIRECTORY_LEVEL&&  is_large_pte(*sptep))) ||
> +		    ((level == PT_PDPE_LEVEL&&  is_large_pte(*sptep)))) {
> +			struct kvm_mmu_page *sp = page_header(__pa(sptep));
> +			int offset = 0;
> +
> +			if (!sp->role.cr4_pae)
> +				offset = sp->role.quadrant<<  PT64_LEVEL_BITS;;
> +			pte_size = sp->role.cr4_pae ? 8 : 4;
> +			pte_gpa = (sp->gfn<<  PAGE_SHIFT);
> +			pte_gpa += (sptep - sp->spt + offset) * pte_size;
> +
> +			if (is_shadow_present_pte(*sptep)) {
> +				rmap_remove(vcpu->kvm, sptep);
> +				if (is_large_pte(*sptep))
> +					--vcpu->kvm->stat.lpages;
> +				need_flush = 1;
> +			}
> +			__set_spte(sptep, shadow_trap_nonpresent_pte);
> +			break;
> +		}
> +
> +		if (!is_shadow_present_pte(*sptep))
> +			break;
> +	}
> +
> +	if (need_flush)
> +		kvm_flush_remote_tlbs(vcpu->kvm);
> +
> +	atomic_inc(&vcpu->kvm->arch.invlpg_counter);
> +
> +	spin_unlock(&vcpu->kvm->mmu_lock);
> +
> +	if (pte_gpa == -1)
> +		return;
> +
> +	if (mmu_topup_memory_caches(vcpu))
> +		return;
> +	kvm_mmu_pte_write(vcpu, pte_gpa, NULL, pte_size, 0);
> +}
> +
>    

I think we should keep it in - kvm_mmu_pte_write() calls back to 
FNAME(update_pte), we could make the call directly from here speed 
things up, since we already have the spte and don't need to look it up.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

