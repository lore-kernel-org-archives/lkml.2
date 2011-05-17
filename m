Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab1EQPHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 11:07:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37945 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab1EQPHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 11:07:36 -0400
Date: Tue, 17 May 2011 16:07:30 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: linux@arm.linux.org.uk, open list <linux-kernel@vger.kernel.org>,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: Add unwinding support for division functions
Message-ID: <20110517150730.GB27656@arm.com>
References: <1305249893-3427-1-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305249893-3427-1-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 06:24:53PM -0700, Laura Abbott wrote:
> The software division functions never had unwinding annotations
> added. Currently, when a division by zero occurs the backtrace shown
> will stop at Ldiv0 or some completely unrelated function. Add
> unwinding annotations in hopes of getting a more useful backtrace
> when a division by zero occurs.

Definitely a good idea.

> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---
>  arch/arm/lib/lib1funcs.S |   27 +++++++++++++++++++++------
>  1 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/lib/lib1funcs.S b/arch/arm/lib/lib1funcs.S
> index 6dc0648..63b75df 100644
> --- a/arch/arm/lib/lib1funcs.S
> +++ b/arch/arm/lib/lib1funcs.S
> @@ -35,7 +35,7 @@ Boston, MA 02111-1307, USA.  */
>  
>  #include <linux/linkage.h>
>  #include <asm/assembler.h>
> -
> +#include <asm/unwind.h>
>  
>  .macro ARM_DIV_BODY dividend, divisor, result, curbit
>  
> @@ -207,6 +207,7 @@ Boston, MA 02111-1307, USA.  */
>  
>  ENTRY(__udivsi3)
>  ENTRY(__aeabi_uidiv)
> +UNWIND(.fnstart)
>  
>  	subs	r2, r1, #1
>  	moveq	pc, lr
> @@ -230,10 +231,12 @@ ENTRY(__aeabi_uidiv)
>  	mov	r0, r0, lsr r2
>  	mov	pc, lr
>  
> +UNWIND(.fnend)
>  ENDPROC(__udivsi3)
>  ENDPROC(__aeabi_uidiv)
>  
>  ENTRY(__umodsi3)
> +UNWIND(.fnstart)
>  
>  	subs	r2, r1, #1			@ compare divisor with 1
>  	bcc	Ldiv0
> @@ -247,10 +250,12 @@ ENTRY(__umodsi3)
>  
>  	mov	pc, lr
>  
> +UNWIND(.fnend)
>  ENDPROC(__umodsi3)
>  
>  ENTRY(__divsi3)
>  ENTRY(__aeabi_idiv)
> +UNWIND(.fnstart)
>  
>  	cmp	r1, #0
>  	eor	ip, r0, r1			@ save the sign of the result.
> @@ -287,10 +292,12 @@ ENTRY(__aeabi_idiv)
>  	rsbmi	r0, r0, #0
>  	mov	pc, lr
>  
> +UNWIND(.fnend)
>  ENDPROC(__divsi3)
>  ENDPROC(__aeabi_idiv)
>  
>  ENTRY(__modsi3)
> +UNWIND(.fnstart)
>  
>  	cmp	r1, #0
>  	beq	Ldiv0
> @@ -310,11 +317,14 @@ ENTRY(__modsi3)
>  	rsbmi	r0, r0, #0
>  	mov	pc, lr
>  
> +UNWIND(.fnend)
>  ENDPROC(__modsi3)
>  
>  #ifdef CONFIG_AEABI
>  
>  ENTRY(__aeabi_uidivmod)
> +UNWIND(.fnstart)
> +UNWIND(.save {r0, r1, ip, lr}	)
>  
>  	stmfd	sp!, {r0, r1, ip, lr}
>  	bl	__aeabi_uidiv
> @@ -323,10 +333,12 @@ ENTRY(__aeabi_uidivmod)
>  	sub	r1, r1, r3
>  	mov	pc, lr
>  
> +UNWIND(.fnend)
>  ENDPROC(__aeabi_uidivmod)
>  
>  ENTRY(__aeabi_idivmod)
> -
> +UNWIND(.fnstart)
> +UNWIND(.save {r0, r1, ip, lr}	)
>  	stmfd	sp!, {r0, r1, ip, lr}
>  	bl	__aeabi_idiv
>  	ldmfd	sp!, {r1, r2, ip, lr}
> @@ -334,15 +346,18 @@ ENTRY(__aeabi_idivmod)
>  	sub	r1, r1, r3
>  	mov	pc, lr
>  
> +UNWIND(.fnend)
>  ENDPROC(__aeabi_idivmod)
>  
>  #endif
>  
> -Ldiv0:
> -
> +ENTRY(Ldiv0)

There's no reason to make Ldiv0 global and pollute the global namespace.
I suggest you remove ENTRY() here, but keep the ENDPROC() so that the
symbol type and size information is correct.

If CONFIG_KALLSYMS is enabled, local symbols are included in the 
kallsyms table, so you still get a sensibly-named backtrace entry without
needing to make the symbol global.

> +UNWIND(.fnstart)
> +UNWIND(.pad #4)
> +UNWIND(.save {lr})
>  	str	lr, [sp, #-8]!
>  	bl	__div0
>  	mov	r0, #0			@ About as wrong as it could be.
>  	ldr	pc, [sp], #8
> -
> -
> +UNWIND(.fnend)
> +ENDPROC(Ldiv0)
> -- 
> 1.7.3.3

Otherwise, the patch looks sound to me.

With it, I get plausible backtraces, e.g.:
[ 1376.909088] Division by zero in kernel.
[ 1376.909149] [<c0073551>] (unwind_backtrace+0x1/0xa0) from [<c02b83a3>] (Ldiv0+0x9/0x12)
[ 1376.909149] [<c02b83a3>] (Ldiv0+0x9/0x12) from [<bf88c033>] (init+0x32/0x6f [div0])
[ 1376.909179] [<bf88c033>] (init+0x32/0x6f [div0]) from [<c006951b>] (do_one_initcall+0x2b/0x11c)
[ 1376.909210] [<c006951b>] (do_one_initcall+0x2b/0x11c) from [<c00c8c4b>] (sys_init_module+0xc7/0x144c)
[ 1376.909240] [<c00c8c4b>] (sys_init_module+0xc7/0x144c) from [<c006df81>] (ret_fast_syscall+0x1/0x44)

(Tested using a trivial test module which just calls a function which
divides by zero from its init function.)

Tested-by: Dave Martin <dave.martin@linaro.org>

Cheers
---Dave
