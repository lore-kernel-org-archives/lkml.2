Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab1FIG7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 02:59:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5932 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab1FIG7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 02:59:50 -0400
Message-ID: <4DF06F5E.9070608@redhat.com>
Date: Thu, 09 Jun 2011 09:59:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 03/15] KVM: x86: avoid unnecessarily guest page table
 walking
References: <4DEE205E.8000601@cn.fujitsu.com> <4DEE20CA.90206@cn.fujitsu.com>
In-Reply-To: <4DEE20CA.90206@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 03:59 PM, Xiao Guangrong wrote:
> We already get the guest physical address, so use it to read guest data
> directly to avoid walking guest page table again
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/x86.c |    3 +--
>   1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 694538a..8be9ff6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3930,8 +3930,7 @@ static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
>   	if ((gpa&  PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
>   		goto mmio;
>
> -	if (kvm_read_guest_virt(ctxt, addr, val, bytes, exception)
> -	    == X86EMUL_CONTINUE)
> +	if (!kvm_read_guest(vcpu->kvm, gpa, val, bytes))
>   		return X86EMUL_CONTINUE;

This breaks is addr/bytes spans a page boundary.

(the current code is also broken, but only for mmio; the new code is 
broken for ram as well).

We need a gva_to_gpa() that returns a range of pages.

-- 
error compiling committee.c: too many arguments to function

