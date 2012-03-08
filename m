Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272Ab2CHEiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 23:38:00 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:60164 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2CHEh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 23:37:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Fernando Luis =?utf-8?Q?V=C3=A1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: Don Zickus <dzickus@redhat.com>, linux-tip-commits@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, mingo@elte.hu,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, vgoyal@redhat.com
References: <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com>
	<20120216172735.GX9751@redhat.com>
	<CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com>
	<20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org>
	<m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com>
	<m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com>
	<m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com>
	<m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp>
	<4F573E74.5040504@oss.ntt.co.jp>
Date: Wed, 07 Mar 2012 20:41:05 -0800
In-Reply-To: <4F573E74.5040504@oss.ntt.co.jp> ("Fernando Luis =?utf-8?Q?V?=
 =?utf-8?Q?=C3=A1zquez?= Cao"'s
	message of "Wed, 07 Mar 2012 19:54:44 +0900")
Message-ID: <m1eht31z8e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19CBQYt1L8SGQosuJLJU+8dtPVoDUZikPc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?;Fernando Luis V=c3=a1zquez Cao <fernando@oss.ntt.co.jp>?=
X-Spam-Relay-Country: **
Subject: Re: [PATCH 1/2] boot: ignore early NMIs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp> writes:

> Subject: [PATCH] boot: ignore early NMIs
>
> From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
>
> NMIs very early in the boot process are rarely critical (usually
> it just means that there was a spurious bit flip somewhere in the
> hardware, or that this is a kdump kernel and we received an NMI
> generated in the previous context), so the current behavior of
> halting the system when one occurs is probably a bit over the top.
>
> This patch changes the early IDT so that NMIs are ignored and the
> kernel can, hopefully, continue executing other code. Harsher
> measures (panic, etc) are defered to the final NMI handler, which
> can actually make an informed decision.
>
> This issue presented itself in our environment as seemingly
> random hangs in kdump.
>
> Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
> ---
>
> diff -urNp linux-3.3-rc6-orig/arch/x86/kernel/head64.c linux-3.3-rc6/arch/x86/kernel/head64.c
> --- linux-3.3-rc6-orig/arch/x86/kernel/head64.c	2012-03-07 15:49:01.834241787 +0900
> +++ linux-3.3-rc6/arch/x86/kernel/head64.c	2012-03-07 18:39:03.173732875 +0900
> @@ -71,7 +71,7 @@ void __init x86_64_start_kernel(char * r
>  				(__START_KERNEL & PGDIR_MASK)));
>  	BUILD_BUG_ON(__fix_to_virt(__end_of_fixed_addresses) <= MODULES_END);
>  
> -	/* clear bss before set_intr_gate with early_idt_handler */
> +	/* clear bss before set_intr_gate with early_idt_handlers */
>  	clear_bss();
>  
>  	/* Make NULL pointers segfault */
> @@ -79,13 +79,8 @@ void __init x86_64_start_kernel(char * r
>  
>  	max_pfn_mapped = KERNEL_IMAGE_SIZE >> PAGE_SHIFT;
>  
> -	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++) {
> -#ifdef CONFIG_EARLY_PRINTK
> +	for (i = 0; i < NUM_EXCEPTION_VECTORS; i++)
>  		set_intr_gate(i, &early_idt_handlers[i]);
> -#else
> -		set_intr_gate(i, early_idt_handler);
> -#endif
> -	}
>  	load_idt((const struct desc_ptr *)&idt_descr);
>  
>  	if (console_loglevel == 10)
> diff -urNp linux-3.3-rc6-orig/arch/x86/kernel/head_64.S linux-3.3-rc6/arch/x86/kernel/head_64.S
> --- linux-3.3-rc6-orig/arch/x86/kernel/head_64.S	2012-03-07 15:49:01.838241839 +0900
> +++ linux-3.3-rc6/arch/x86/kernel/head_64.S	2012-03-07 18:41:21.811516876 +0900
> @@ -270,18 +270,29 @@ bad_address:
>  	jmp bad_address
>  
>  	.section ".init.text","ax"
> -#ifdef CONFIG_EARLY_PRINTK
>  	.globl early_idt_handlers
>  early_idt_handlers:
> -	i = 0
> +	vector = 0
>  	.rept NUM_EXCEPTION_VECTORS
> -	movl $i, %esi
> -	jmp early_idt_handler
> -	i = i + 1
> +	/*
> +	 * NMIs (vector 2) this early in the boot process are rarely critical
> +	 * (usually it just means that there was a spurious bit flip somewhere
> +	 * in the hardware, or that this is a kdump kernel and we received an
> +	 * NMI generated in the previous context), so we ignore them here and
> +	 * try to continue (see early_nmi_handler implementation below).
> +	 * Harsher measures (panic, etc) are defered to the final NMI handler,
> +	 * which can actually make an informed decision.
> +	 */
> +	.if vector == 2
> +	jmp early_nmi_handler

Is just a jump and not a move followed by a jump still 10 bytes?
I hate to say it but I think this fails miserably for any exception
after a nmi.

I expect the simplest solution is to modify early_idt_handler to test
for vector == 2.

Doing something less brittle than:
> extern const char early_idt_handlers[NUM_EXCEPTION_VECTORS][10];
in segment.h might be a good idea as well.

Eric

> +	.else
> +	movl $vector, %esi
> +	jmp early_exception_handler
> +	.endif
> +	vector = vector + 1
>  	.endr
> -#endif
>  
> -ENTRY(early_idt_handler)
> +early_exception_handler:
>  #ifdef CONFIG_EARLY_PRINTK
>  	cmpl $2,early_recursion_flag(%rip)
>  	jz  1f
> @@ -315,6 +326,9 @@ ENTRY(early_idt_handler)
>  1:	hlt
>  	jmp 1b
>  
> +early_nmi_handler:
> +	iretq
> +
>  #ifdef CONFIG_EARLY_PRINTK
>  early_recursion_flag:
>  	.long 0
