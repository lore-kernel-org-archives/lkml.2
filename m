Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab2HSJBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 05:01:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53015 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab2HSJBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 05:01:18 -0400
Message-ID: <5030AB00.3090908@redhat.com>
Date: Sun, 19 Aug 2012 11:59:44 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, mmarek@suse.cz,
        linux-kbuild@vger.kernel.org, JBeulich@suse.com,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 37/74] lto, KVM: Don't assume asm statements end up in
 the same assembler file
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-38-git-send-email-andi@firstfloor.org>
In-Reply-To: <1345345030-22211-38-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2012 05:56 AM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The VMX code references a local assembler label between two inline
> assembler statements. This assumes they both end up in the same
> assembler files. In some experimental builds of gcc this is not
> necessarily true, causing linker failures.
> 
> Replace the local label reference with a more traditional asmlinkage
> extern.
> 
> This also eliminates one assembler statement and
> generates a bit better code on 64bit: the compiler can
> use a RIP relative LEA instead of a movabs, saving
> a few bytes.

I'm happy to see work on lto-enabling the kernel.

>  
> +extern __visible unsigned long kvm_vmx_return;
> +
>  /*
>   * Set up the vmcs's constant host-state fields, i.e., host-state fields that
>   * will not change in the lifetime of the guest.
> @@ -3753,8 +3755,7 @@ static void vmx_set_constant_host_state(void)
>  	native_store_idt(&dt);
>  	vmcs_writel(HOST_IDTR_BASE, dt.address);   /* 22.2.4 */
>  
> -	asm("mov $.Lkvm_vmx_return, %0" : "=r"(tmpl));
> -	vmcs_writel(HOST_RIP, tmpl); /* 22.2.5 */
> +	vmcs_writel(HOST_RIP, (unsigned long)&kvm_vmx_return); /* 22.2.5 */
>  
>  	rdmsr(MSR_IA32_SYSENTER_CS, low32, high32);
>  	vmcs_write32(HOST_IA32_SYSENTER_CS, low32);
> @@ -6305,9 +6306,10 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
>  		/* Enter guest mode */
>  		"jne .Llaunched \n\t"
>  		__ex(ASM_VMX_VMLAUNCH) "\n\t"
> -		"jmp .Lkvm_vmx_return \n\t"
> +		"jmp kvm_vmx_return \n\t"
>  		".Llaunched: " __ex(ASM_VMX_VMRESUME) "\n\t"
> -		".Lkvm_vmx_return: "
> +	        ".globl kvm_vmx_return\n"
> +		"kvm_vmx_return: "
>  		/* Save guest registers, load host registers, keep flags */
>  		"mov %0, %c[wordsize](%%"R"sp) \n\t"
>  		"pop %0 \n\t"
> 

The reason we use a local label is so that we the function isn't split
into two from the profiler's point of view.  See cd2276a795b013d1.

One way to fix this is to have a .data variable initialized to point to
.Lkvm_vmx_return (this can be done from the same asm statement in
vmx_vcpu_run), and reference that variable in
vmx_set_constant_host_state().  If no one comes up with a better idea,
I'll write a patch doing this.

-- 
error compiling committee.c: too many arguments to function
