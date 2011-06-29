Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1F2IVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:21:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab1F2IVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:21:36 -0400
Message-ID: <4E0AE088.2070703@redhat.com>
Date: Wed, 29 Jun 2011 11:21:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 03/22] KVM: x86: fix broken read emulation spans a
 page boundary
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FC39.2080709@cn.fujitsu.com>
In-Reply-To: <4E01FC39.2080709@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2011 05:29 PM, Xiao Guangrong wrote:
> If the range spans a boundary, the mmio access can be broke, fix it as
> write emulation.
>
> And we already get the guest physical address, so use it to read guest data
> directly to avoid walking guest page table again
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/x86.c |   41 ++++++++++++++++++++++++++++++++---------
>   1 files changed, 32 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0b803f0..eb27be4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3944,14 +3944,13 @@ out:
>   }
>   EXPORT_SYMBOL_GPL(kvm_write_guest_virt_system);
>
> -static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
> -				  unsigned long addr,
> -				  void *val,
> -				  unsigned int bytes,
> -				  struct x86_exception *exception)
> +static int emulator_read_emulated_onepage(unsigned long addr,
> +					  void *val,
> +					  unsigned int bytes,
> +					  struct x86_exception *exception,
> +					  struct kvm_vcpu *vcpu)
>   {
> -	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
> -	gpa_t                 gpa;
> +	gpa_t gpa;
>   	int handled;
>
>   	if (vcpu->mmio_read_completed) {
> @@ -3971,8 +3970,7 @@ static int emulator_read_emulated(struct x86_emulate_ctxt *ctxt,
>   	if ((gpa&  PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
>   		goto mmio;
>
> -	if (kvm_read_guest_virt(ctxt, addr, val, bytes, exception)
> -	    == X86EMUL_CONTINUE)
> +	if (!kvm_read_guest(vcpu->kvm, gpa, val, bytes))
>   		return X86EMUL_CONTINUE;

This doesn't perform the cpl check.

I suggest dropping this part for now and doing it later.

-- 
error compiling committee.c: too many arguments to function

