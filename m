Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760934Ab2COJxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 05:53:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab2COJxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 05:53:13 -0400
Message-ID: <4F61BC02.6070607@redhat.com>
Date: Thu, 15 Mar 2012 11:53:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: dave@gnu.org
CC: Marcelo Tosatti <mtosatti@redhat.com>, Sheng Yang <sheng.yang@intel.com>,
        KVM <kvm@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: call invvpid only when EPT is disabled
References: <1331775884.20336.2.camel@offbook>
In-Reply-To: <1331775884.20336.2.camel@offbook>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 03:44 AM, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
>
> With EPT enabled it is not required to explicitly run invvpid to invalidate tagged TLB entries, as
> KVM does not force vm-exits for cr3 writes and invlpg. Run invvpid only when these instructions
> are emulated and shadow pages are used.
>
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  arch/x86/kvm/vmx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 2c22fc7..51c7fb9 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -2861,12 +2861,13 @@ static void exit_lmode(struct kvm_vcpu *vcpu)
>  
>  static void vmx_flush_tlb(struct kvm_vcpu *vcpu)
>  {
> -	vpid_sync_context(to_vmx(vcpu));
>  	if (enable_ept) {
>  		if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
>  			return;
>  		ept_sync_context(construct_eptp(vcpu->arch.mmu.root_hpa));
>  	}
> +	else
> +		vpid_sync_context(to_vmx(vcpu));
>  }
>  
>  static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)

This is wrong, cr3 can still be written from host userspace.

To perform this optimization you need to separate the concept of
flushing the guest tlb and the host tlb.  I doubt it's worthwhile
though, won't the ept invalidation flush the entire tlb anyway?

-- 
error compiling committee.c: too many arguments to function

