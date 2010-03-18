Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab0CRCuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 22:50:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab0CRCun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 22:50:43 -0400
Date: Wed, 17 Mar 2010 23:49:48 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Sheng Yang <sheng@linux.intel.com>,
       KVM list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] KVM MMU: check reserved bits only when CR4.PSE=1 or
 CR4.PAE=1
Message-ID: <20100318024948.GB23995@amt.cnet>
References: <4BA04FCA.40308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA04FCA.40308@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 11:43:06AM +0800, Xiao Guangrong wrote:
> - The RSV bit is possibility set in error code when #PF occurred
>   only if CR4.PSE=1 or CR4.PAE=1
>   
> - context->rsvd_bits_mask[1][0] is always 0
> 
> Changlog:
> Move this operation to reset_rsvds_bits_mask() address Avi Kivity's suggestion
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index b137515..c49f8ec 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2288,18 +2288,26 @@ static void reset_rsvds_bits_mask(struct kvm_vcpu *vcpu, int level)
>  
>  	if (!is_nx(vcpu))
>  		exb_bit_rsvd = rsvd_bits(63, 63);
> +
> +	context->rsvd_bits_mask[1][0] = 0;

So if the guest enables PAT at PTE level you completly disable reserved
bit checking? You should only disable checking for [1][1] if !PSE.

