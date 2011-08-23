Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1HWIBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:01:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352Ab1HWIBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:01:08 -0400
Date: Tue, 23 Aug 2011 05:00:24 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 11/11] KVM: MMU: improve write flooding detected
Message-ID: <20110823080024.GA2297@amt.cnet>
References: <4E4A10E8.5090705@cn.fujitsu.com>
 <4E4A1257.5080204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4A1257.5080204@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 02:46:47PM +0800, Xiao Guangrong wrote:
> Detecting write-flooding does not work well, when we handle page written, if
> the last speculative spte is not accessed, we treat the page is
> write-flooding, however, we can speculative spte on many path, such as pte
> prefetch, page synced, that means the last speculative spte may be not point
> to the written page and the written page can be accessed via other sptes, so
> depends on the Accessed bit of the last speculative spte is not enough

Yes, a stale last_speculative_spte is possible, but is this fact a
noticeable problem in practice?

Was this detected by code inspection?

> Instead of detected page accessed, we can detect whether the spte is accessed
> or not, if the spte is not accessed but it is written frequently, we treat is
> not a page table or it not used for a long time
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/include/asm/kvm_host.h |    6 +---
>  arch/x86/kvm/mmu.c              |   48 +++++++++------------------------------
>  arch/x86/kvm/paging_tmpl.h      |    9 +-----
>  3 files changed, 15 insertions(+), 48 deletions(-)
>
 
> -static bool detect_write_flooding(struct kvm_vcpu *vcpu, gfn_t gfn)
> +static bool detect_write_flooding(struct kvm_mmu_page *sp, u64 *spte)
>  {
> -	bool flooded = false;
> -
> -	if (gfn == vcpu->arch.last_pt_write_gfn
> -	    && !last_updated_pte_accessed(vcpu)) {
> -		++vcpu->arch.last_pt_write_count;
> -		if (vcpu->arch.last_pt_write_count >= 3)
> -			flooded = true;
> -	} else {
> -		vcpu->arch.last_pt_write_gfn = gfn;
> -		vcpu->arch.last_pt_write_count = 1;
> -		vcpu->arch.last_pte_updated = NULL;
> -	}
> +	if (spte && !(*spte & shadow_accessed_mask))
> +		sp->write_flooding_count++;
> +	else
> +		sp->write_flooding_count = 0;

This relies on the sptes being created by speculative means
or by pressure on the host clearing the accessed bit for the
shadow page to be zapped. 

There is no guarantee that either of these is true for a given
spte.

And if the sptes do not have accessed bit set, any nonconsecutive 3 pte
updates will zap the page.

Back to the first question, what is the motivation for this heuristic
change? Do you have any numbers?

If its a significant problem, perhaps getting rid of the
'last_spte_accessed' part is enough.
