Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927Ab2HJSgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 14:36:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759750Ab2HJSgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 14:36:08 -0400
Date: Fri, 10 Aug 2012 15:03:48 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 11/12] KVM: x86: introduce set_mmio_exit_info
Message-ID: <20120810180348.GB12477@amt.cnet>
References: <5020E423.9080004@linux.vnet.ibm.com>
 <5020E5E2.4080603@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5020E5E2.4080603@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 05:54:42PM +0800, Xiao Guangrong wrote:
> Introduce set_mmio_exit_info to cleanup the common code
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/x86.c |   33 +++++++++++++++++----------------
>  1 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4c86239..8cde327 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3761,9 +3761,6 @@ static int read_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
>  static int write_exit_mmio(struct kvm_vcpu *vcpu, gpa_t gpa,
>  			   void *val, int bytes)
>  {
> -	struct kvm_mmio_fragment *frag = &vcpu->mmio_fragments[0];
> -
> -	memcpy(vcpu->run->mmio.data, frag->data, frag->len);
>  	return X86EMUL_CONTINUE;
>  }
> 
> @@ -3831,6 +3828,20 @@ mmio:
>  	return X86EMUL_CONTINUE;
>  }
> 
> +static void set_mmio_exit_info(struct kvm_vcpu *vcpu,
> +			       struct kvm_mmio_fragment *frag, bool write)
> +{
> +	struct kvm_run *run = vcpu->run;
> +
> +	run->exit_reason = KVM_EXIT_MMIO;
> +	run->mmio.phys_addr = frag->gpa;
> +	run->mmio.len = frag->len;
> +	run->mmio.is_write = vcpu->mmio_is_write = write;
> +
> +	if (write)
> +		memcpy(run->mmio.data, frag->data, frag->len);
> +}
> +
>  int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
>  			void *val, unsigned int bytes,
>  			struct x86_exception *exception,
> @@ -3870,14 +3881,10 @@ int emulator_read_write(struct x86_emulate_ctxt *ctxt, unsigned long addr,
>  		return rc;
> 
>  	gpa = vcpu->mmio_fragments[0].gpa;
> -
>  	vcpu->mmio_needed = 1;
>  	vcpu->mmio_cur_fragment = 0;
> 
> -	vcpu->run->mmio.len = vcpu->mmio_fragments[0].len;
> -	vcpu->run->mmio.is_write = vcpu->mmio_is_write = ops->write;
> -	vcpu->run->exit_reason = KVM_EXIT_MMIO;
> -	vcpu->run->mmio.phys_addr = gpa;
> +	set_mmio_exit_info(vcpu, &vcpu->mmio_fragments[0], ops->write);
> 
>  	return ops->read_write_exit_mmio(vcpu, gpa, val, bytes);
>  }
> @@ -5486,7 +5493,6 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>   */
>  static int complete_mmio(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm_run *run = vcpu->run;
>  	struct kvm_mmio_fragment *frag;
>  	int r;
> 
> @@ -5497,7 +5503,7 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
>  		/* Complete previous fragment */
>  		frag = &vcpu->mmio_fragments[vcpu->mmio_cur_fragment++];
>  		if (!vcpu->mmio_is_write)
> -			memcpy(frag->data, run->mmio.data, frag->len);
> +			memcpy(frag->data, vcpu->run->mmio.data, frag->len);
>  		if (vcpu->mmio_cur_fragment == vcpu->mmio_nr_fragments) {
>  			vcpu->mmio_needed = 0;
>  			if (vcpu->mmio_is_write)
> @@ -5507,12 +5513,7 @@ static int complete_mmio(struct kvm_vcpu *vcpu)
>  		}
>  		/* Initiate next fragment */
>  		++frag;
> -		run->exit_reason = KVM_EXIT_MMIO;
> -		run->mmio.phys_addr = frag->gpa;
> -		if (vcpu->mmio_is_write)
> -			memcpy(run->mmio.data, frag->data, frag->len);
> -		run->mmio.len = frag->len;
> -		run->mmio.is_write = vcpu->mmio_is_write;
> +		set_mmio_exit_info(vcpu, frag, vcpu->mmio_is_write);
>  		return 0;
> 
>  	}
> -- 
> 1.7.7.6

IMO having a function is unnecessary (it makes it harder the code).
