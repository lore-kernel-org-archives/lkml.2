Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab0GMWJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 18:09:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483Ab0GMWJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 18:09:38 -0400
Date: Tue, 13 Jul 2010 18:28:01 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/4] KVM: MMU: fix forgot reserved bits check in
 speculative path
Message-ID: <20100713212801.GA6370@amt.cnet>
References: <4C3C3518.7080505@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3C3518.7080505@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 05:42:48PM +0800, Xiao Guangrong wrote:
> In the speculative path, we should check guest pte's reserved bits just as
> the real processor does
> 
> Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c         |    8 ++++++++
>  arch/x86/kvm/paging_tmpl.h |    5 +++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index b93b94f..9fc1524 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2783,6 +2783,9 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>  		break;
>  	}
>  
> +	if (is_rsvd_bits_set(vcpu, gentry, PT_PAGE_TABLE_LEVEL))
> +		gentry = 0;
> +
>  	mmu_guess_page_from_pte_write(vcpu, gpa, gentry);
>  	spin_lock(&vcpu->kvm->mmu_lock);
>  	if (atomic_read(&vcpu->kvm->arch.invlpg_counter) != invlpg_counter)
> @@ -2851,6 +2854,11 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>  		while (npte--) {
>  			entry = *spte;
>  			mmu_pte_write_zap_pte(vcpu, sp, spte);
> +
> +			if (!!is_pae(vcpu) != sp->role.cr4_pae ||
> +			      is_nx(vcpu) != sp->role.nxe)
> +				continue;
> +

This breaks remote_flush assignment below.

