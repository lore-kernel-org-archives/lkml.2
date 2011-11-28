Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab1K1WdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 17:33:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab1K1WdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 17:33:08 -0500
Date: Mon, 28 Nov 2011 17:33:05 -0500
From: Jason Baron <jbaron@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/5] KVM: MMU: audit: replace mmu audit tracepoint with
 jump-lable
Message-ID: <20111128223305.GB2519@redhat.com>
References: <4ED3811F.1070101@linux.vnet.ibm.com>
 <4ED3815C.9060901@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED3815C.9060901@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 08:41:00PM +0800, Xiao Guangrong wrote:
> +static void kvm_mmu_audit(struct kvm_vcpu *vcpu, int point)
>  {
>  	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);
> 
> -	if (!__ratelimit(&ratelimit_state))
> -		return;
> +	if (static_branch((&mmu_audit_key))) {
> +		if (!__ratelimit(&ratelimit_state))
> +			return;
> 
> -	vcpu->kvm->arch.audit_point = point;
> -	audit_all_active_sps(vcpu->kvm);
> -	audit_vcpu_spte(vcpu);
> +		vcpu->kvm->arch.audit_point = point;
> +		audit_all_active_sps(vcpu->kvm);
> +		audit_vcpu_spte(vcpu);
> +	}
>  }

hmmm..this always going to do a call to 'kvm_mmu_audit' and then return.
I think you want to avoid the function call altogether. You could do
something like:

#define kvm_mmu_audit()
	if (static_branch((&mmu_audit_key))) {
		__kvm_mmu_audit();
	}

and s/kvm_mmu_audit/__kvm_mmu_audit

That should give you a single nop for the case where kvm_mmu_audit is
disabled instead of a function call.

Thanks,

-Jason
