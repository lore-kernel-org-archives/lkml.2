Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab0IGVej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 17:34:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3110 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051Ab0IGVed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 17:34:33 -0400
Date: Tue, 7 Sep 2010 15:43:16 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/27] KVM: X86: Propagate fetch faults
Message-ID: <20100907184316.GA11990@amt.cnet>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
 <1283788566-29186-20-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283788566-29186-20-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 05:55:58PM +0200, Joerg Roedel wrote:
> KVM currently ignores fetch faults in the instruction
> emulator. With nested-npt we could have such faults. This
> patch adds the code to handle these.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kvm/emulate.c |    3 +++
>  arch/x86/kvm/x86.c     |    4 ++++
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 2b08b78..aead72e 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -1198,6 +1198,9 @@ static int emulate_popf(struct x86_emulate_ctxt *ctxt,
>  	*(unsigned long *)dest =
>  		(ctxt->eflags & ~change_mask) | (val & change_mask);
>  
> +	if (rc == X86EMUL_PROPAGATE_FAULT)
> +		emulate_pf(ctxt);
> +
>  	return rc;
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 65b00f0..ca69dcc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4237,6 +4237,9 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
>  		vcpu->arch.emulate_ctxt.perm_ok = false;
>  
>  		r = x86_decode_insn(&vcpu->arch.emulate_ctxt);
> +		if (r == X86EMUL_PROPAGATE_FAULT)
> +			goto done;
> +

x86_decode_insn returns -1 / 0 ? 

>  		trace_kvm_emulate_insn_start(vcpu);
>  
>  		/* Only allow emulation of specific instructions on #UD
> @@ -4295,6 +4298,7 @@ restart:
>  		return handle_emulation_failure(vcpu);
>  	}
>  
> +done:
>  	if (vcpu->arch.emulate_ctxt.exception >= 0) {
>  		inject_emulated_exception(vcpu);
>  		r = EMULATE_DONE;
> -- 
> 1.7.0.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
