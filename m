Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab2JKOfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:35:46 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:41646 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab2JKOfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:35:42 -0400
Date: Thu, 11 Oct 2012 10:35:28 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: ling.ma@intel.com
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] [x86] Optimize copy_page by re-arranging
 instruction sequence and saving register
Message-ID: <20121011143527.GA2408@localhost.localdomain>
References: <1349958548-1868-1-git-send-email-ling.ma@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349958548-1868-1-git-send-email-ling.ma@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 08:29:08PM +0800, ling.ma@intel.com wrote:
> From: Ma Ling <ling.ma@intel.com>
> 
> Load and write operation occupy about 35% and 10% respectively
> for most industry benchmarks. Fetched 16-aligned bytes code include 
> about 4 instructions, implying 1.34(0.35 * 4) load, 0.4 write.  
> Modern CPU support 2 load and 1 write per cycle, so throughput from write is
> bottleneck for memcpy or copy_page, and some slight CPU only support one mem
> operation per cycle. So it is enough to issue one read and write instruction
> per cycle, and we can save registers. 

So is that also true for AMD CPUs?
> 
> In this patch we also re-arrange instruction sequence to improve performance
> The performance on atom is improved about 11%, 9% on hot/cold-cache case respectively.
> 
> Signed-off-by: Ma Ling <ling.ma@intel.com>
> 
> ---
>  arch/x86/lib/copy_page_64.S |  103 +++++++++++++++++-------------------------
>  1 files changed, 42 insertions(+), 61 deletions(-)
> 
> diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
> index 3da5527..13c97f4 100644
> --- a/arch/x86/lib/copy_page_64.S
> +++ b/arch/x86/lib/copy_page_64.S
> @@ -20,76 +20,57 @@ ENDPROC(copy_page_rep)
>  
>  ENTRY(copy_page)
>  	CFI_STARTPROC
> -	subq	$2*8,	%rsp
> -	CFI_ADJUST_CFA_OFFSET 2*8
> -	movq	%rbx,	(%rsp)
> -	CFI_REL_OFFSET rbx, 0
> -	movq	%r12,	1*8(%rsp)
> -	CFI_REL_OFFSET r12, 1*8
> +	mov	$(4096/64)-5, %ecx
>  
> -	movl	$(4096/64)-5,	%ecx
> -	.p2align 4
>  .Loop64:
> -  	dec	%rcx
> -
> -	movq	0x8*0(%rsi), %rax
> -	movq	0x8*1(%rsi), %rbx
> -	movq	0x8*2(%rsi), %rdx
> -	movq	0x8*3(%rsi), %r8
> -	movq	0x8*4(%rsi), %r9
> -	movq	0x8*5(%rsi), %r10
> -	movq	0x8*6(%rsi), %r11
> -	movq	0x8*7(%rsi), %r12
> -
>  	prefetcht0 5*64(%rsi)
> -
> -	movq	%rax, 0x8*0(%rdi)
> -	movq	%rbx, 0x8*1(%rdi)
> -	movq	%rdx, 0x8*2(%rdi)
> -	movq	%r8,  0x8*3(%rdi)
> -	movq	%r9,  0x8*4(%rdi)
> -	movq	%r10, 0x8*5(%rdi)
> -	movq	%r11, 0x8*6(%rdi)
> -	movq	%r12, 0x8*7(%rdi)
> -
> -	leaq	64 (%rsi), %rsi
> -	leaq	64 (%rdi), %rdi
> -
> +	decb	%cl
> +
> +	movq	0x8*0(%rsi), %r10
> +	movq	0x8*1(%rsi), %rax
> +	movq	0x8*2(%rsi), %r8
> +	movq	0x8*3(%rsi), %r9
> +	movq	%r10, 0x8*0(%rdi)
> +	movq	%rax, 0x8*1(%rdi)
> +	movq	%r8, 0x8*2(%rdi)
> +	movq	%r9, 0x8*3(%rdi)
> +
> +	movq	0x8*4(%rsi), %r10
> +	movq	0x8*5(%rsi), %rax
> +	movq	0x8*6(%rsi), %r8
> +	movq	0x8*7(%rsi), %r9
> +	leaq	64(%rsi), %rsi
> +	movq	%r10, 0x8*4(%rdi)
> +	movq	%rax, 0x8*5(%rdi)
> +	movq	%r8, 0x8*6(%rdi)
> +	movq	%r9, 0x8*7(%rdi)
> +	leaq	64(%rdi), %rdi
>  	jnz	.Loop64
>  
> -	movl	$5, %ecx
> -	.p2align 4
> +	mov	$5, %dl
>  .Loop2:
> -	decl	%ecx
> -
> -	movq	0x8*0(%rsi), %rax
> -	movq	0x8*1(%rsi), %rbx
> -	movq	0x8*2(%rsi), %rdx
> -	movq	0x8*3(%rsi), %r8
> -	movq	0x8*4(%rsi), %r9
> -	movq	0x8*5(%rsi), %r10
> -	movq	0x8*6(%rsi), %r11
> -	movq	0x8*7(%rsi), %r12
> -
> -	movq	%rax, 0x8*0(%rdi)
> -	movq	%rbx, 0x8*1(%rdi)
> -	movq	%rdx, 0x8*2(%rdi)
> -	movq	%r8,  0x8*3(%rdi)
> -	movq	%r9,  0x8*4(%rdi)
> -	movq	%r10, 0x8*5(%rdi)
> -	movq	%r11, 0x8*6(%rdi)
> -	movq	%r12, 0x8*7(%rdi)
> -
> -	leaq	64(%rdi), %rdi
> +	decb	%dl
> +	movq	0x8*0(%rsi), %r10
> +	movq	0x8*1(%rsi), %rax
> +	movq	0x8*2(%rsi), %r8
> +	movq	0x8*3(%rsi), %r9
> +	movq	%r10, 0x8*0(%rdi)
> +	movq	%rax, 0x8*1(%rdi)
> +	movq	%r8, 0x8*2(%rdi)
> +	movq	%r9, 0x8*3(%rdi)
> +
> +	movq	0x8*4(%rsi), %r10
> +	movq	0x8*5(%rsi), %rax
> +	movq	0x8*6(%rsi), %r8
> +	movq	0x8*7(%rsi), %r9
>  	leaq	64(%rsi), %rsi
> +	movq	%r10, 0x8*4(%rdi)
> +	movq	%rax, 0x8*5(%rdi)
> +	movq	%r8, 0x8*6(%rdi)
> +	movq	%r9, 0x8*7(%rdi)
> +	leaq	64(%rdi), %rdi
>  	jnz	.Loop2
>  
> -	movq	(%rsp), %rbx
> -	CFI_RESTORE rbx
> -	movq	1*8(%rsp), %r12
> -	CFI_RESTORE r12
> -	addq	$2*8, %rsp
> -	CFI_ADJUST_CFA_OFFSET -2*8
>  	ret
>  .Lcopy_page_end:
>  	CFI_ENDPROC
> -- 
> 1.6.5.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
