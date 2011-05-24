Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591Ab1EXXI5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:08:57 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:56318 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382Ab1EXXIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:08:55 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, kees.cook@canonical.com,
        davem@davemloft.net, eranian@google.com, torvalds@linux-foundation.org,
        adobriyan@gmail.com, penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
In-Reply-To: <1306269105.21443.20.camel@dan>
References: <1306269105.21443.20.camel@dan>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 19:08:45 -0400
Message-ID: <1306278525.1921.14.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 16:31 -0400, Dan Rosenberg wrote:
> This introduces CONFIG_RANDOMIZE_BASE, which randomizes the address at
> which the kernel is decompressed at boot as a security feature that
> deters exploit attempts relying on knowledge of the location of kernel
> internals.  The default values of the kptr_restrict and dmesg_restrict
> sysctls are set to (1) when this is enabled, since hiding kernel
> pointers is necessary to preserve the secrecy of the randomized base
> address.

> diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
> index 67a655a..2680db0 100644
> --- a/arch/x86/boot/compressed/head_32.S
> +++ b/arch/x86/boot/compressed/head_32.S
> @@ -69,12 +69,75 @@ ENTRY(startup_32)
>   */
>  
>  #ifdef CONFIG_RELOCATABLE
> +#ifdef CONFIG_RANDOMIZE_BASE
> +
> +	/* Standard check for cpuid */
> +	pushfl
> +	popl	%eax
> +	movl	%eax, %ebx
> +	xorl	$0x200000, %eax
> +	pushl	%eax
> +	popfl
> +	pushfl
> +	popl	%eax
> +	cmpl	%eax, %ebx
> +	jz	4f
> +
> +	/* Check for cpuid 1 */
> +	movl	$0x0, %eax
> +	cpuid
> +	cmpl	$0x1, %eax
> +	jb	4f
> +
> +	movl	$0x1, %eax
> +	cpuid
> +	xor	%eax, %eax
> +
> +	/* RDRAND is bit 30 */
> +	testl	$0x4000000, %ecx
> +	jnz	1f
> +
> +	/* RDTSC is bit 4 */
> +	testl	$0x10, %edx
> +	jnz	3f
> +
> +	/* Nothing is supported */
> +	jmp	4f
> +1:
> +	/* RDRAND sets carry bit on success, otherwise we should try
> +	 * again. */
> +	movl	$0x10, %ecx
> +2:
> +	/* rdrand %eax */
> +	.byte	0x0f, 0xc7, 0xf0
> +	jc	4f
> +	loop	2b
> +
> +	/* Fall through: if RDRAND is supported but fails, use RDTSC,
> +	 * which is guaranteed to be supported. */
> +3:
> +	rdtsc
> +	shll	$0xc, %eax
> +4:
> +	/* Maximum offset at 64mb to be safe */
> +	andl	$0x3ffffff, %eax
> +	movl	%ebp, %ebx
> +	addl	%eax, %ebx
> +#else
>  	movl	%ebp, %ebx
> +#endif
>  	movl	BP_kernel_alignment(%esi), %eax
>  	decl	%eax
>  	addl    %eax, %ebx
>  	notl	%eax
>  	andl    %eax, %ebx
> +
> +	/* LOAD_PHSYICAL_ADDR is the minimum safe address we can
> +	 * decompress at. */
> +	cmpl	$LOAD_PHYSICAL_ADDR, %ebx
> +	jae	1f
> +	movl	$LOAD_PHYSICAL_ADDR, %ebx
> +1:
>  #else
>  	movl	$LOAD_PHYSICAL_ADDR, %ebx
>  #endif
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index 35af09d..6a05219 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -90,6 +90,13 @@ ENTRY(startup_32)
>  	addl	%eax, %ebx
>  	notl	%eax
>  	andl	%eax, %ebx
> +
> +	/* LOAD_PHYSICAL_ADDR is the minimum safe address we can
> +	 * decompress at. */
> +	cmpl	$LOAD_PHYSICAL_ADDR, %ebx
> +	jae	1f
> +	movl	$LOAD_PHYSICAL_ADDR, %ebx
> +1:
>  #else
>  	movl	$LOAD_PHYSICAL_ADDR, %ebx
>  #endif
> @@ -191,7 +198,7 @@ no_longmode:
>  	 * it may change in the future.
>  	 */
>  	.code64
> -	.org 0x200
> +	.org 0x300
>  ENTRY(startup_64)
>  	/*
>  	 * We come here either from startup_32 or directly from a
> @@ -232,6 +239,13 @@ ENTRY(startup_64)
>  	addq	%rax, %rbp
>  	notq	%rax
>  	andq	%rax, %rbp
> +
> +	/* LOAD_PHYSICAL_ADDR is the minimum safe address we can
> +	 * decompress at. */
> +	cmpq	$LOAD_PHYSICAL_ADDR, %rbp
> +	jae	1f
> +	movq	$LOAD_PHYSICAL_ADDR, %rbp
> +1:
>  #else
>  	movq	$LOAD_PHYSICAL_ADDR, %rbp
>  #endif

Thanks to Kees Cook for noticing that I didn't clear %eax before jumping
to my "nothing supported" (4) label.  This would have just used the
flags as "randomness", but it's still wrong and I'll fix it.  Next
version will have a fallback of using the BIOS signature instead anyway.

-Dan

