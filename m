Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab2CZJWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 05:22:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab2CZJWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 05:22:07 -0400
Message-ID: <4F703536.3040904@redhat.com>
Date: Mon, 26 Mar 2012 11:21:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC dontapply] kvm_para: add mmio word store hypercall
References: <20120325220518.GA27879@redhat.com>
In-Reply-To: <20120325220518.GA27879@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 12:05 AM, Michael S. Tsirkin wrote:
> We face a dilemma: IO mapped addresses are legacy,
> so, for example, PCI express bridges waste 4K
> of this space for each link, in effect limiting us
> to 16 devices using this space.
>
> Memory is supposed to replace them, but memory
> exits are much slower than PIO because of the need for
> emulation and page walks.
>
> As a solution, this patch adds an MMIO hypercall with
> the guest physical address + data.
>
> I did test that this works but didn't benchmark yet.
>
> TODOs:
> This only implements a 2 bytes write since this is
> the minimum required for virtio, but we'll probably need
> at least 1 byte reads (for ISR read).
> We can support up to 8 byte reads/writes for 64 bit
> guests and up to 4 bytes for 32 ones - better limit
> to 4 bytes for everyone for consistency, or support
> the maximum that we can?

Let's support the maximum we can.

>  
>  static int handle_invd(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9cbfc06..7bc00ae 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4915,7 +4915,9 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  
>  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_run *run = vcpu->run;
>  	unsigned long nr, a0, a1, a2, a3, ret;
> +	gpa_t gpa;
>  	int r = 1;
>  
>  	if (kvm_hv_hypercall_enabled(vcpu->kvm))
> @@ -4946,12 +4948,24 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  	case KVM_HC_VAPIC_POLL_IRQ:
>  		ret = 0;
>  		break;
> +	case KVM_HC_MMIO_STORE_WORD:

HC_MEMORY_WRITE

> +		gpa = hc_gpa(vcpu, a1, a2);
> +		if (!write_mmio(vcpu, gpa, 2, &a0) && run) {

What's this && run thing?

> +			run->exit_reason = KVM_EXIT_MMIO;
> +			run->mmio.phys_addr = gpa;
> +			memcpy(run->mmio.data, &a0, 2);
> +			run->mmio.len = 2;
> +			run->mmio.is_write = 1;
> +                        r = 0;
> +		}
> +		goto noret;

What if the address is in RAM?

Note the guest can't tell if a piece of memory is direct mapped or
implemented as mmio.


-- 
error compiling committee.c: too many arguments to function

