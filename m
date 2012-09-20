Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab2ITK5s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:57:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782Ab2ITK5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:57:46 -0400
Message-ID: <505AF6A6.4070106@redhat.com>
Date: Thu, 20 Sep 2012 13:57:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] KVM: MMU: introduce page_fault_start and page_fault_end
References: <5052FF61.3070600@linux.vnet.ibm.com> <5052FFEA.1040607@linux.vnet.ibm.com>
In-Reply-To: <5052FFEA.1040607@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 12:59 PM, Xiao Guangrong wrote:
> Wrap the common operations into these two functions
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c         |   53 +++++++++++++++++++++++++++----------------
>  arch/x86/kvm/paging_tmpl.h |   16 +++++--------
>  2 files changed, 39 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 29ce28b..7e7b8cd 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2825,6 +2825,29 @@ exit:
>  static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
>  			 gva_t gva, pfn_t *pfn, bool write, bool *writable);
> 
> +static bool
> +page_fault_start(struct kvm_vcpu *vcpu, gfn_t *gfnp, pfn_t *pfnp, int *levelp,
> +		 bool force_pt_level, unsigned long mmu_seq)
> +{
> +	spin_lock(&vcpu->kvm->mmu_lock);
> +	if (mmu_notifier_retry(vcpu, mmu_seq))
> +		return false;
> +
> +	kvm_mmu_free_some_pages(vcpu);
> +	if (likely(!force_pt_level))
> +		transparent_hugepage_adjust(vcpu, gfnp, pfnp, levelp);
> +
> +	return true;
> +}
> +
> +static void page_fault_end(struct kvm_vcpu *vcpu, pfn_t pfn)
> +{
> +	spin_unlock(&vcpu->kvm->mmu_lock);
> +
> +	if (!is_error_pfn(pfn))
> +		kvm_release_pfn_clean(pfn);
> +}

Needs sparse annotations (__acquires, __releases).

These code blocks have nothing in common except for being shared.  Often
that's not good for maintainability because it means that further
changes can affect one path but not the other.  But we can try it out
and see.



-- 
error compiling committee.c: too many arguments to function
