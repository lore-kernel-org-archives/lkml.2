Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab0ILIvB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 04:51:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab0ILIvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 04:51:00 -0400
Message-ID: <4C8C946C.80106@redhat.com>
Date: Sun, 12 Sep 2010 10:50:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/29] KVM: MMU: Propagate the right fault back to the
 guest after gva_to_gpa
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com> <1284132667-18620-19-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1284132667-18620-19-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/10/2010 06:30 PM, Joerg Roedel wrote:
> This patch implements logic to make sure that either a
> page-fault/page-fault-vmexit or a nested-page-fault-vmexit
> is propagated back to the guest.
>
> @@ -338,6 +338,22 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu)
>   	kvm_queue_exception_e(vcpu, PF_VECTOR, error_code);
>   }
>
> +void kvm_propagate_fault(struct kvm_vcpu *vcpu)
> +{
> +	u32 nested, error;
> +
> +	error   = vcpu->arch.fault.error_code;
> +	nested  = error&   PFERR_NESTED_MASK;
> +	error   = error&  ~PFERR_NESTED_MASK;
> +
> +	vcpu->arch.fault.error_code = error;
> +
> +	if (mmu_is_nested(vcpu)&&  !nested)
> +		vcpu->arch.nested_mmu.inject_page_fault(vcpu);
> +	else
> +		vcpu->arch.mmu.inject_page_fault(vcpu);
> +}
> +

Tacking a non-architectural bit on top of the error code is not very 
nice.  Can you move it to a separate vcpu->arch.fault.nested?

-- 
error compiling committee.c: too many arguments to function

