Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0CWQN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 12:13:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab0CWQN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 12:13:28 -0400
Date: Tue, 23 Mar 2010 12:32:01 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v3] KVM MMU:  check reserved bits only  if CR4.PSE=1 or
 CR4.PAE=1
Message-ID: <20100323153201.GA16878@amt.cnet>
References: <4BA34ADD.9040903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA34ADD.9040903@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 05:58:53PM +0800, Xiao Guangrong wrote:
> - Check reserved bits only if CR4.PAE=1 or CR4.PSE=1 when guest #PF occurs
> - Fix a typo in reset_rsvds_bits_mask()
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>

> ---
>  arch/x86/kvm/mmu.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index b137515..d6c1f03 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2293,13 +2293,19 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
>  		/* no rsvd bits for 2 level 4K page table entries */
>  		context->rsvd_bits_mask[0][1] = 0;
>  		context->rsvd_bits_mask[0][0] = 0;
> +		context->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[0][0];
> +
> +		if (!is_pse(vcpu)) {
> +			context->rsvd_bits_mask[1][1] = 0;
> +			break;
> +		}
> +
>  		if (is_cpuid_PSE36())
>  			/* 36bits PSE 4MB page */
>  			context->rsvd_bits_mask[1][1] = rsvd_bits(17, 21);
>  		else
>  			/* 32 bits PSE 4MB page */
>  			context->rsvd_bits_mask[1][1] = rsvd_bits(13, 21);
> -		context->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[1][0];
>  		break;
>  	case PT32E_ROOT_LEVEL:
>  		context->rsvd_bits_mask[0][2] =
> @@ -2312,7 +2318,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
>  		context->rsvd_bits_mask[1][1] = exb_bit_rsvd |
>  			rsvd_bits(maxphyaddr, 62) |
>  			rsvd_bits(13, 20);		/* large page */
> -		context->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[1][0];
> +		context->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[0][0];
>  		break;
>  	case PT64_ROOT_LEVEL:
>  		context->rsvd_bits_mask[0][3] = exb_bit_rsvd |
> @@ -2330,7 +2336,7 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
>  		context->rsvd_bits_mask[1][1] = exb_bit_rsvd |
>  			rsvd_bits(maxphyaddr, 51) |
>  			rsvd_bits(13, 20);		/* large page */
> -		context->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[1][0];
> +		context->rsvd_bits_mask[1][0] = context->rsvd_bits_mask[0][0];
>  		break;
>  	}
>  }
> -- 
> 1.6.6.1
