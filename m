Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab1HaWhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 18:37:16 -0400
Received: from claw.goop.org ([74.207.240.146]:39507 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756941Ab1HaWhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 18:37:13 -0400
Message-ID: <4E5EB794.7050909@goop.org>
Date: Wed, 31 Aug 2011 15:37:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Igor Mammedov <imammedo@redhat.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH] xen: x86_32: do not enable iterrupts when returning from
 exception in interrupt context
References: <20110829194633.GB16530@dumpdata.com> <1314834438-3181-1-git-send-email-imammedo@redhat.com>
In-Reply-To: <1314834438-3181-1-git-send-email-imammedo@redhat.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2011 04:47 PM, Igor Mammedov wrote:
> If vmalloc page_fault happens inside of interrupt handler with interrupts
> disabled then on exit path from exception handler when there is no pending
> interrupts, the following code (arch/x86/xen/xen-asm_32.S:112):
>
> 	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
> 	sete XEN_vcpu_info_mask(%eax)
>
> will enable interrupts even if they has been previously disabled according to
> eflags from the bounce frame (arch/x86/xen/xen-asm_32.S:99)
>
> 	testb $X86_EFLAGS_IF>>8, 8+1+ESP_OFFSET(%esp)
> 	setz XEN_vcpu_info_mask(%eax)
>
> Solution is in setting XEN_vcpu_info_mask only when it should be set
> according to
> 	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
> but not clearing it if there isn't any pending events.

Wow, that's a great find.  I guess it shows how rarely we end up doing
an exception return with interrupts disabled, since that's been there
since, erm, 2.6.23?

But this could definitely explain some bugs where interrupts became
unexpectedly re-enabled.  Were you tracking one down when you found this?

> Signed-off-by: Igor Mammedov <imammedo@redhat.com>
> ---
>  arch/x86/xen/xen-asm_32.S |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
> index 22a2093..313dca7 100644
> --- a/arch/x86/xen/xen-asm_32.S
> +++ b/arch/x86/xen/xen-asm_32.S
> @@ -113,10 +113,14 @@ xen_iret_start_crit:
>  
>  	/*
>  	 * If there's something pending, mask events again so we can
> -	 * jump back into xen_hypervisor_callback
> +	 * jump back into xen_hypervisor_callback. Otherwise do not
> +	 * touch XEN_vcpu_info_mask.
>  	 */
> +	jne ignore_vcpu_info_mask
>  	sete XEN_vcpu_info_mask(%eax)
>  
> +ignore_vcpu_info_mask:
> +

This should be:

	jne 1f
	movb $1, XEN_vcpu_info_mask(%eax)

1:	popl %eax 


There's no point in using sete if we're already using a conditional jump
to avoid the write, and it's better to use local labels for little
control flow changes like this.

Thanks,
    J
