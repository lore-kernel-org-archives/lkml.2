Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab0IFSSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 14:18:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab0IFSSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 14:18:03 -0400
Message-ID: <4C853051.7080706@redhat.com>
Date: Mon, 06 Sep 2010 21:17:53 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Alexander Graf <agraf@suse.de>,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/27] KVM: MMU: Track page fault data in struct vcpu
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com> <1283788566-29186-18-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1283788566-29186-18-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 06:55 PM, Joerg Roedel wrote:
> This patch introduces a struct with two new fields in
> vcpu_arch for x86:
>
> 	* fault.address
> 	* fault.error_code
>
> This will be used to correctly propagate page faults back
> into the guest when we could have either an ordinary page
> fault or a nested page fault. In the case of a nested page
> fault the fault-address is different from the original
> address that should be walked. So we need to keep track
> about the real fault-address.
>
>
>
> -static void emulate_pf(struct x86_emulate_ctxt *ctxt, unsigned long addr,
> -		       int err)
> +static void emulate_pf(struct x86_emulate_ctxt *ctxt)
>   {
> -	ctxt->cr2 = addr;
> -	emulate_exception(ctxt, PF_VECTOR, err, true);
> +	emulate_exception(ctxt, PF_VECTOR, 0, true);
>   }

What happened to the error code?

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b2fe9e7..38d482d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4130,7 +4130,8 @@ static void inject_emulated_exception(struct kvm_vcpu *vcpu)
>   {
>   	struct x86_emulate_ctxt *ctxt =&vcpu->arch.emulate_ctxt;
>   	if (ctxt->exception == PF_VECTOR)
> -		kvm_inject_page_fault(vcpu, ctxt->cr2, ctxt->error_code);
> +		kvm_inject_page_fault(vcpu, vcpu->arch.fault.address,
> +					    vcpu->arch.fault.error_code);
>   	else if (ctxt->error_code_valid)
>   		kvm_queue_exception_e(vcpu, ctxt->exception, ctxt->error_code);
>   	else

Ah.  Not lovely, but it was ugly before as well.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

