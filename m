Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341Ab0IGVel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 17:34:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756461Ab0IGVed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 17:34:33 -0400
Date: Tue, 7 Sep 2010 17:39:52 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/27] KVM: MMU: Refactor mmu_alloc_roots function
Message-ID: <20100907203952.GA14489@amt.cnet>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
 <1283788566-29186-23-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283788566-29186-23-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 05:56:01PM +0200, Joerg Roedel wrote:
> This patch factors out the direct-mapping paths of the
> mmu_alloc_roots function into a seperate function. This
> makes it a lot easier to avoid all the unnecessary checks
> done in the shadow path which may break when running direct.
> In fact, this patch already fixes a problem when running PAE
> guests on a PAE shadow page table.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/mmu.c |   82 ++++++++++++++++++++++++++++++++++++++--------------
>  1 files changed, 60 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 3663d1c..e7e5527 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c

> +
> +static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  {
>  	int i;
>  	gfn_t root_gfn;
>  	struct kvm_mmu_page *sp;
> -	int direct = 0;
>  	u64 pdptr;
>  
>  	root_gfn = vcpu->arch.mmu.get_cr3(vcpu) >> PAGE_SHIFT;
>  
> -	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
> +	if (mmu_check_root(vcpu, root_gfn))
> +		return 1;
> +
> +	/*
> +	 * Do we shadow a long mode page table? If so we need to
> +	 * write-protect the guests page table root.
> +	 */
> +	if (vcpu->arch.mmu.root_level == PT64_ROOT_LEVEL) {
>  		hpa_t root = vcpu->arch.mmu.root_hpa;
>  
>  		ASSERT(!VALID_PAGE(root));
> -		if (mmu_check_root(vcpu, root_gfn))
> -			return 1;
> -		if (vcpu->arch.mmu.direct_map) {
> -			direct = 1;
> -			root_gfn = 0;
> -		}
> +
>  		spin_lock(&vcpu->kvm->mmu_lock);
>  		kvm_mmu_free_some_pages(vcpu);
> -		sp = kvm_mmu_get_page(vcpu, root_gfn, 0,
> -				      PT64_ROOT_LEVEL, direct,
> -				      ACC_ALL, NULL);
> +		sp = kvm_mmu_get_page(vcpu, root_gfn, 0, PT64_ROOT_LEVEL,
> +				      0, ACC_ALL, NULL);
>  		root = __pa(sp->spt);
>  		++sp->root_count;
>  		spin_unlock(&vcpu->kvm->mmu_lock);
>  		vcpu->arch.mmu.root_hpa = root;
>  		return 0;
>  	}
> -	direct = !is_paging(vcpu);
> -
> -	if (mmu_check_root(vcpu, root_gfn))
> -		return 1;
>  
> +	/*
> +	 * We shadow a 32 bit page table. This may be a legacy 2-level
> +	 * or a PAE 3-level page table.
> +	 */
>  	for (i = 0; i < 4; ++i) {
>  		hpa_t root = vcpu->arch.mmu.pae_root[i];
>  
> @@ -2406,16 +2441,11 @@ static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
>  			root_gfn = pdptr >> PAGE_SHIFT;
>  			if (mmu_check_root(vcpu, root_gfn))
>  				return 1;
> -		} else if (vcpu->arch.mmu.root_level == 0)
> -			root_gfn = 0;
> -		if (vcpu->arch.mmu.direct_map) {
> -			direct = 1;
> -			root_gfn = i << 30;
>  		}
>  		spin_lock(&vcpu->kvm->mmu_lock);
>  		kvm_mmu_free_some_pages(vcpu);
>  		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
> -				      PT32_ROOT_LEVEL, direct,
> +				      PT32_ROOT_LEVEL, 0,
>  				      ACC_ALL, NULL);

Should not write protect the gfn for nonpaging mode.

