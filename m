Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab1ESLKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 07:10:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64328 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1ESLKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 07:10:49 -0400
Date: Thu, 19 May 2011 12:10:43 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: linux@arm.linux.org.uk,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arm: Add unwinding support for division functions
Message-ID: <20110519111043.GC2431@arm.com>
References: <f16b4b8d7735148b133e23547a7963b3.squirrel@www.codeaurora.org>
 <1305740006-11389-2-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305740006-11389-2-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 10:33:26AM -0700, Laura Abbott wrote:
> The software division functions never had unwinding annotations
> added. Currently, when a division by zero occurs the backtrace shown
> will stop at Ldiv0 or some completely unrelated function. Add
> unwinding annotations in hopes of getting a more useful backtrace
> when a division by zero occurs.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---
>  arch/arm/lib/lib1funcs.S |   25 ++++++++++++++++++++-----
>  1 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/lib/lib1funcs.S b/arch/arm/lib/lib1funcs.S
> index 6dc0648..c562f64 100644
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
>  Ldiv0:
> -
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
> 

OK, that looks good to me.

Tested with CONFIG_THUMB2_KERNEL on omap4.

Acked-by: Dave Martin <dave.martin@linaro.org>
