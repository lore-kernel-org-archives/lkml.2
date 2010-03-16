Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935141Ab0CPFbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 01:31:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756830Ab0CPFbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 01:31:47 -0400
Message-ID: <4B9F17BC.50108@redhat.com>
Date: Tue, 16 Mar 2010 07:31:40 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Sheng Yang <sheng@linux.intel.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM MMU: check reserved bits only if CR4.PSE=1 or CR4.PAE=1
References: <4B9FCC42.2080709@cn.fujitsu.com>
In-Reply-To: <4B9FCC42.2080709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 08:21 PM, Xiao Guangrong wrote:
> The RSV bit is possibility set in error code when #PF occurred
> only if CR4.PSE=1 or CR4.PAE=1
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/mmu.c |    3 +++
>   1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 741373e..36e50ab 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2270,6 +2270,9 @@ static bool is_rsvd_bits_set(struct kvm_vcpu *vcpu, u64 gpte, int level)
>   {
>   	int bit7;
>
> +	if (!is_pae(vcpu)&&  !is_pse(vcpu))
> +		return 0;
> +
>   	bit7 = (gpte>>  7)&  1;
>   	return (gpte&  vcpu->arch.mmu.rsvd_bits_mask[bit7][level-1]) != 0;
>   }
>    

Should be handled by reset_rsvd_bits_mask(), so that all reserved bit 
handling happens in one place.

I think the only change is that is !is_pse(vcpu) we ignore bit 7?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

