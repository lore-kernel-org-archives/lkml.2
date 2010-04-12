Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab0DLIe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 04:34:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab0DLIez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 04:34:55 -0400
Message-ID: <4BC2DB27.7060005@redhat.com>
Date: Mon, 12 Apr 2010 11:34:47 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] KVM MMU: optimize for writing cr4
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D3E0.8070602@cn.fujitsu.com>
In-Reply-To: <4BC2D3E0.8070602@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 11:03 AM, Xiao Guangrong wrote:
> Usually, OS changes CR4.PGE bit to flush all global page, under this
> case, no need reset mmu and just flush tlb
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/x86.c |    9 +++++++++
>   1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fd5c3d3..2aaa6fb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -463,6 +463,15 @@ void kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>   	unsigned long old_cr4 = kvm_read_cr4(vcpu);
>   	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE;
>
> +	if (cr4 == old_cr4)
> +		return;
> +
> +	if ((cr4 ^ old_cr4) == X86_CR4_PGE) {
> +		kvm_mmu_sync_roots(vcpu);
> +		kvm_mmu_flush_tlb(vcpu);
> +		return;
> +	}
> +
>   	if (cr4&  CR4_RESERVED_BITS) {
>   		kvm_inject_gp(vcpu, 0);
>   		return;
>    

Later we have:

>         kvm_x86_ops->set_cr4(vcpu, cr4);
>         vcpu->arch.cr4 = cr4;
>         vcpu->arch.mmu.base_role.cr4_pge = (cr4 & X86_CR4_PGE) && 
> !tdp_enabled;

All of which depend on cr4.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

