Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab2IZKRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:17:23 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:32859 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab2IZKRV convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 26 Sep 2012 06:17:21 -0400
Message-Id: <5062F267020000780009DF06@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 26 Sep 2012 11:17:43 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Tao Guo" <glorioustao@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: Work around old gas bug
References: <1348648102-12653-1-git-send-email-glorioustao@gmail.com>
In-Reply-To: <1348648102-12653-1-git-send-email-glorioustao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.09.12 at 10:28, Tao Guo <glorioustao@gmail.com> wrote:
> gas in binutils(2.16.91) could not parse parentheses within macro
> parameters unless fully parenthesized, and this is a workaround to
> make old gas work without generating below errors:
> arch/x86/kernel/entry_64.S: Assembler messages:
> arch/x86/kernel/entry_64.S:387: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:389: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:390: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:391: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:392: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:393: Error: too many positional arguments
> arch/x86/kernel/entry_64.S:394: Error: too many positional arguments
> 
> Signed-off-by: Tao Guo <glorioustao@gmail.com>

This looks okay now to me, but I'm somewhat reluctant to formally
ack it given that we know how broken those particular gas
versions are.

Jan

> ---
>  arch/x86/include/asm/calling.h |   48 +++++++++++++++++++--------------------
>  arch/x86/kernel/entry_64.S     |   20 ++++++++--------
>  2 files changed, 33 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/x86/include/asm/calling.h b/arch/x86/include/asm/calling.h
> index a9e3a74..7f8422a 100644
> --- a/arch/x86/include/asm/calling.h
> +++ b/arch/x86/include/asm/calling.h
> @@ -49,38 +49,36 @@ For 32-bit we have the following conventions - kernel is 
> built with
>  #include "dwarf2.h"
>  
>  /*
> - * 64-bit system call stack frame layout defines and helpers, for
> - * assembly code (note that the seemingly unnecessary parentheses
> - * are to prevent cpp from inserting spaces in expressions that get
> - * passed to macros):
> + * 64-bit system call stack frame layout defines and helpers,
> + * for assembly code:
>   */
>  
> -#define R15		  (0)
> -#define R14		  (8)
> -#define R13		 (16)
> -#define R12		 (24)
> -#define RBP		 (32)
> -#define RBX		 (40)
> +#define R15		  0
> +#define R14		  8
> +#define R13		 16
> +#define R12		 24
> +#define RBP		 32
> +#define RBX		 40
>  
>  /* arguments: interrupts/non tracing syscalls only save up to here: */
> -#define R11		 (48)
> -#define R10		 (56)
> -#define R9		 (64)
> -#define R8		 (72)
> -#define RAX		 (80)
> -#define RCX		 (88)
> -#define RDX		 (96)
> -#define RSI		(104)
> -#define RDI		(112)
> -#define ORIG_RAX	(120)       /* + error_code */
> +#define R11		 48
> +#define R10		 56
> +#define R9		 64
> +#define R8		 72
> +#define RAX		 80
> +#define RCX		 88
> +#define RDX		 96
> +#define RSI		104
> +#define RDI		112
> +#define ORIG_RAX	120       /* + error_code */
>  /* end of arguments */
>  
>  /* cpu exception frame or undefined in case of fast syscall: */
> -#define RIP		(128)
> -#define CS		(136)
> -#define EFLAGS		(144)
> -#define RSP		(152)
> -#define SS		(160)
> +#define RIP		128
> +#define CS		136
> +#define EFLAGS		144
> +#define RSP		152
> +#define SS		160
>  
>  #define ARGOFFSET	R11
>  #define SWFRAME		ORIG_RAX
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 69babd8..bf77e70 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -342,15 +342,15 @@ ENDPROC(native_usergs_sysret64)
>  	.macro SAVE_ARGS_IRQ
>  	cld
>  	/* start from rbp in pt_regs and jump over */
> -	movq_cfi rdi, RDI-RBP
> -	movq_cfi rsi, RSI-RBP
> -	movq_cfi rdx, RDX-RBP
> -	movq_cfi rcx, RCX-RBP
> -	movq_cfi rax, RAX-RBP
> -	movq_cfi  r8,  R8-RBP
> -	movq_cfi  r9,  R9-RBP
> -	movq_cfi r10, R10-RBP
> -	movq_cfi r11, R11-RBP
> +	movq_cfi rdi, (RDI-RBP)
> +	movq_cfi rsi, (RSI-RBP)
> +	movq_cfi rdx, (RDX-RBP)
> +	movq_cfi rcx, (RCX-RBP)
> +	movq_cfi rax, (RAX-RBP)
> +	movq_cfi  r8,  (R8-RBP)
> +	movq_cfi  r9,  (R9-RBP)
> +	movq_cfi r10, (R10-RBP)
> +	movq_cfi r11, (R11-RBP)
>  
>  	/* Save rbp so that we can unwind from get_irq_regs() */
>  	movq_cfi rbp, 0
> @@ -384,7 +384,7 @@ ENDPROC(native_usergs_sysret64)
>  	.endm
>  
>  ENTRY(save_rest)
> -	PARTIAL_FRAME 1 REST_SKIP+8
> +	PARTIAL_FRAME 1 (REST_SKIP+8)
>  	movq 5*8+16(%rsp), %r11	/* save return address */
>  	movq_cfi rbx, RBX+16
>  	movq_cfi rbp, RBP+16
> -- 
> 1.7.7.6


