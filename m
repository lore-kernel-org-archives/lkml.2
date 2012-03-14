Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab2CNLPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 07:15:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44021 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab2CNLPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 07:15:14 -0400
Date: Wed, 14 Mar 2012 11:15:04 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.pitre@linaro.org, catalin.marinas@arm.com,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] arm: Add unwinding support for memset and memzero.
Message-ID: <20120314111504.GA2033@linaro.org>
References: <1331574027-28542-1-git-send-email-lauraa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331574027-28542-1-git-send-email-lauraa@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 10:40:27AM -0700, Laura Abbott wrote:
> Both memset and memzero lack unwinding annoations. If
> an abort occurs trying to access the pointer, the backtrace
> is incomplete. Add unwinding annotations to both functions
> so we can actually get a useful backtrace.
> 
> Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
> ---
>  arch/arm/lib/memset.S  |    7 +++++--
>  arch/arm/lib/memzero.S |    7 +++++--
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/lib/memset.S b/arch/arm/lib/memset.S
> index 650d592..4379912 100644
> --- a/arch/arm/lib/memset.S
> +++ b/arch/arm/lib/memset.S
> @@ -11,6 +11,7 @@
>   */
>  #include <linux/linkage.h>
>  #include <asm/assembler.h>
> +#include <asm/unwind.h>
>  
>  	.text
>  	.align	5
> @@ -29,6 +30,7 @@
>   */
>  
>  ENTRY(memset)
> +UNWIND(.fnstart)
>  	ands	r3, r0, #3		@ 1 unaligned?
>  	bne	1b			@ 1
>  /*
> @@ -41,7 +43,7 @@ ENTRY(memset)
>  	blt	4f
>  
>  #if ! CALGN(1)+0
> -
> +UNWIND(.save {lr})
>  /*
>   * We need an extra register for this loop - save the return address and
>   * use the LR
> @@ -68,7 +70,7 @@ ENTRY(memset)
>  	ldr	lr, [sp], #4
>  
>  #else
> -
> +UNWIND(.save {r4, r5, r6, r7, lr})

For functions like this, the unwinding requirements are different
depending on where we are in the function.  But the unwinder annotations
don't remember exact instruction locations; only the extent of the
whole unwind block is recorded, along with the sequence (but not
location) of unwinder directives.

As is, the unwinding may be wrong depending on which part of the function
is executing when the fault occurs.

It may be possible to split the function into multiple unwind blocks,
e.g.:

ENTRY(somefunc)
UNWIND(.fnstart)

UNWIND(.save {r4,lr})
	stfmd	sp!, {r4,lr}

	/* check something */

	blt	_the_other_way
	/* maybe carry out our job this way */

	ldmfd	sp!, {r4,lr}
UNWIND(.fnend)

_the_other_way:
UNWIND(.fnstart)
UNWIND(.save {r4,lr})
UNWIND(.save {r5-r8})
	stmfd	sp!, {r5-r8}	/* !! */

	/* carry out our job the other way */

	ldmfd	sp!, {r5-r8}
	ldmfd	sp!, {r4,pc}	/* !! */
UNWIND(.fnend)


This is still not exactly right (it's hard to be exactly right,
since the unwind tables are not meant for handling asynchronous
unwinding), but unwinding should be correct for the main bits of code
where most time is spent and/or faults are most likely (the "carry out
our job" comments).

You'd have to experiment to see whether the backtracer does something
sensible with unwind tables like this.  It might need tweaking to
find the correct function symbol if a fault occurs in the second
unwind block for example ... that perhaps it will already do the
right thing.

Cheers
---Dave

