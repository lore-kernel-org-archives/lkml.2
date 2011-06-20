Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1FTDnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 23:43:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:9624 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab1FTDnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 23:43:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,391,1304319600"; 
   d="scan'208";a="18209475"
From: "Ma, Ling" <ling.ma@intel.com>
To: "Ma, Ling" <ling.ma@intel.com>, "mingo@elte.hu" <mingo@elte.hu>
CC: "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 20 Jun 2011 11:42:42 +0800
Subject: RE: [PATCH RFC V2] [x86] Optimize copy-page by reducing impact from
 HW prefetch
Thread-Topic: [PATCH RFC V2] [x86] Optimize copy-page by reducing impact
 from HW prefetch
Thread-Index: AcwtCPR7PTfgtKlbQE+JLjlj37jy1gB7ZGdw
Message-ID: <C10D3FB0CD45994C8A51FEC1227CE22F239E58D6FA@shsmsx502.ccr.corp.intel.com>
References: <1308353053-1928-1-git-send-email-ling.ma@intel.com>
In-Reply-To: <1308353053-1928-1-git-send-email-ling.ma@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New experiment shows, for 4096 bytes no improvement on snb,
10~15% improvement on Core2, 11.6% improvement on 64bit atom.

Thanks
Ling
> -----Original Message-----
> From: Ma, Ling
> Sent: Saturday, June 18, 2011 7:24 AM
> To: mingo@elte.hu
> Cc: hpa@zytor.com; tglx@linutronix.de; linux-kernel@vger.kernel.org; Ma,
> Ling
> Subject: [PATCH RFC V2] [x86] Optimize copy-page by reducing impact
> from HW prefetch
> 
> From: Ma Ling <ling.ma@intel.com>
> 
> Program's temporal & spatial locality introduce cache unit to overcome
> the processor-memory performance gap, hardware prefetch is very
> important
> to improve performance by reducing cache miss. Modern CPU micro-
> architecture
> mainly support two kinds of prefetch mechanism in L1 data cache:
> 
> a. Data cache unit (DCU) prefetcher. Data spatial locality ask us to
> provide
>    adjacent data while handling current data. larger cache line size
>    is one choice, but it would cause more cached data to be evicted and
> latency
>    to load, so we simply prefetch next line when accessing current data.
>    This mode only prefetch data of ascending address.
> 
> b. Instruction pointer (IP)- based strided prefetcher. Based on
> Load/write
>    instruction address the mechanism predicate to prefetch data with
> adaptive stride,
>    including ascending and descending address
> 
> DCU mode is good when time program data operation spend is longer than
> that of
> prefetch next line, however copy-page function breaks the assumption,
> DCU mode is hardly helpful, specially we append software prefetch and
> data is
> in cache, so bus traffic is more busy that impact perforamnce seriously.
> 
> In this patch we introduce backward copy to successfully avoid HW
> prfetch
> impact(DCU prefetcher), and simplify original code.
> The performance is improved about 15% on core2, 36% on snb respectively.
> (We use our micro-benchmark, and will do further test according to your
> requirment)
> 
> Thanks
> Ling
> 
> ---
>  arch/x86/lib/copy_page_64.S |  124 +++++++++++++++++++----------------
> -------
>  1 files changed, 56 insertions(+), 68 deletions(-)
> 
> diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
> index 6fec2d1..0a60705 100644
> --- a/arch/x86/lib/copy_page_64.S
> +++ b/arch/x86/lib/copy_page_64.S
> @@ -1,4 +1,5 @@
>  /* Written 2003 by Andi Kleen, based on a kernel by Evandro Menezes */
> +/* Updated 2011 by Ma Ling to introduce backward copy */
> 
>  #include <linux/linkage.h>
>  #include <asm/dwarf2.h>
> @@ -17,83 +18,70 @@ ENDPROC(copy_page_c)
> 
>  /* Could vary the prefetch distance based on SMP/UP */
> 
> +/*
> + * By backward copy we manage to reduce impact from HW prefetch
> + * when data is in L1 cache, and get benefit when data is not in L1
> cache.
> + */
>  ENTRY(copy_page)
>  	CFI_STARTPROC
> -	subq	$3*8,%rsp
> -	CFI_ADJUST_CFA_OFFSET 3*8
> -	movq	%rbx,(%rsp)
> -	CFI_REL_OFFSET rbx, 0
> -	movq	%r12,1*8(%rsp)
> -	CFI_REL_OFFSET r12, 1*8
> -	movq	%r13,2*8(%rsp)
> -	CFI_REL_OFFSET r13, 2*8
> -
> -	movl	$(4096/64)-5,%ecx
> -	.p2align 4
> +	lea	4096(%rsi), %rsi
> +	lea	4096(%rdi), %rdi
> +	mov	$(4096/64)-5,	%cl
> +	mov	$5,	%dl
> +	/*
> +	 * Nop force following instruction to be 16 bytes aligned.
> +	 */
> +	nop
>  .Loop64:
> -  	dec     %rcx
> -
> -	movq        (%rsi), %rax
> -	movq      8 (%rsi), %rbx
> -	movq     16 (%rsi), %rdx
> -	movq     24 (%rsi), %r8
> -	movq     32 (%rsi), %r9
> -	movq     40 (%rsi), %r10
> -	movq     48 (%rsi), %r11
> -	movq     56 (%rsi), %r12
> -
> -	prefetcht0 5*64(%rsi)
> -
> -	movq     %rax,    (%rdi)
> -	movq     %rbx,  8 (%rdi)
> -	movq     %rdx, 16 (%rdi)
> -	movq     %r8,  24 (%rdi)
> -	movq     %r9,  32 (%rdi)
> -	movq     %r10, 40 (%rdi)
> -	movq     %r11, 48 (%rdi)
> -	movq     %r12, 56 (%rdi)
> -
> -	leaq    64 (%rsi), %rsi
> -	leaq    64 (%rdi), %rdi
> +	prefetchnta	-5*64(%rsi)
> +  	dec	%cl
> +
> +	movq	-0x8*1(%rsi),	%rax
> +	movq	-0x8*2(%rsi),	%r8
> +	movq	-0x8*3(%rsi),	%r9
> +	movq	-0x8*4(%rsi),	%r10
> +	movq	%rax,	-0x8*1(%rdi)
> +	movq	%r8,	-0x8*2(%rdi)
> +	movq	%r9,	-0x8*3(%rdi)
> +	movq	%r10,	-0x8*4(%rdi)
> +
> +	movq	-0x8*5(%rsi),	%rax
> +	movq	-0x8*6(%rsi),	%r8
> +	movq	-0x8*7(%rsi),	%r9
> +	movq	-0x8*8(%rsi),	%r10
> +	leaq	-64(%rsi),	%rsi
> +	movq	%rax,	-0x8*5(%rdi)
> +	movq	%r8,	-0x8*6(%rdi)
> +	movq	%r9,	-0x8*7(%rdi)
> +	movq	%r10,	-0x8*8(%rdi)
> +	leaq	-64(%rdi),	%rdi
> 
>  	jnz     .Loop64
> 
> -	movl	$5,%ecx
> -	.p2align 4
>  .Loop2:
> -	decl   %ecx
> -
> -	movq        (%rsi), %rax
> -	movq      8 (%rsi), %rbx
> -	movq     16 (%rsi), %rdx
> -	movq     24 (%rsi), %r8
> -	movq     32 (%rsi), %r9
> -	movq     40 (%rsi), %r10
> -	movq     48 (%rsi), %r11
> -	movq     56 (%rsi), %r12
> -
> -	movq     %rax,    (%rdi)
> -	movq     %rbx,  8 (%rdi)
> -	movq     %rdx, 16 (%rdi)
> -	movq     %r8,  24 (%rdi)
> -	movq     %r9,  32 (%rdi)
> -	movq     %r10, 40 (%rdi)
> -	movq     %r11, 48 (%rdi)
> -	movq     %r12, 56 (%rdi)
> -
> -	leaq	64(%rdi),%rdi
> -	leaq	64(%rsi),%rsi
> -
> +	dec	%dl
> +
> +	movq	-0x8*1(%rsi),	%rax
> +	movq	-0x8*2(%rsi),	%r8
> +	movq	-0x8*3(%rsi),	%r9
> +	movq	-0x8*4(%rsi),	%r10
> +	movq	%rax,	-0x8*1(%rdi)
> +	movq	%r8,	-0x8*2(%rdi)
> +	movq	%r9,	-0x8*3(%rdi)
> +	movq	%r10,	-0x8*4(%rdi)
> +
> +	movq	-0x8*5(%rsi),	%rax
> +	movq	-0x8*6(%rsi),	%r8
> +	movq	-0x8*7(%rsi),	%r9
> +	movq	-0x8*8(%rsi),	%r10
> +	leaq	-64(%rsi),	%rsi
> +	movq	%rax,	-0x8*5(%rdi)
> +	movq	%r8,	-0x8*6(%rdi)
> +	movq	%r9,	-0x8*7(%rdi)
> +	movq	%r10,	-0x8*8(%rdi)
> +	leaq	-64(%rdi),	%rdi
>  	jnz	.Loop2
> 
> -	movq	(%rsp),%rbx
> -	CFI_RESTORE rbx
> -	movq	1*8(%rsp),%r12
> -	CFI_RESTORE r12
> -	movq	2*8(%rsp),%r13
> -	CFI_RESTORE r13
> -	addq	$3*8,%rsp
> -	CFI_ADJUST_CFA_OFFSET -3*8
>  	ret
>  .Lcopy_page_end:
>  	CFI_ENDPROC
> --
> 1.6.5.2

