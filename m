Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1DABrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 21:47:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:44322 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab1DABru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 21:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dVsruTmuYB7WFc6nw4hjdedsssqgYau6LGn77GKwQzq2y/kJLINIFnEFgJXOQmSwwc
         bAae4Cw6G/ZW6fMY3IsQ==
MIME-Version: 1.0
In-Reply-To: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com>
References: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com>
Date: Thu, 31 Mar 2011 18:47:47 -0700
X-Google-Sender-Auth: g9hYvQrKyEmUlTW21GAT8oSJSWA
Message-ID: <BANLkTimtAcPLmcFKoHkCtWcJipy+rSSP+A@mail.gmail.com>
Subject: Re: [PATCH] ARM: BUG() dies silently
From: Simon Glass <sjg@chromium.org>
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        lak <linux-arm-kernel@lists.infradead.org>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You might try the generic bug patch and see if it also fixes this
problem - Simon

On Thu, Mar 31, 2011 at 1:15 PM, Omar Ramirez Luna <omar.ramirez@ti.com> wrote:
> There are some cases where the code generated for BUG() results
> into an infinite while loop without causing a null dereference,
> this ends on a kernel being stuck on a loop and the user without
> a clue of what happened.
>
> E.g.: lib/scatterlist.c : __sg_alloc_table
>
>        BUG_ON(nents > max_ents);
>  438:   9a000000        bls     440 <__sg_alloc_table+0x20>
>  43c:   eafffffe        b       43c <__sg_alloc_table+0x1c>
>
> Adding volatile makes the compiler to avoid optimizations on this
> code, which makes the panic to occur:
>
>        BUG_ON(nents > max_ents);
>  438:   9a000002        bls     448 <__sg_alloc_table+0x28>
>  43c:   e3a03000        mov     r3, #0
>  440:   e5833000        str     r3, [r3]
>  444:   eafffffc        b       43c <__sg_alloc_table+0x1c>
>
> Seen with gnu/linux cs arm-2010q1-202 and arm2010.09-50.
>
> Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
> ---
>
> If needed I can change:
> ./arch/arm/mach-clps711x/include/mach/io.h:
>        #define __raw_readsb(p,d,l)  do { *(int *)0 = 0; } while (0)
> ./arch/arm/mach-clps711x/include/mach/io.h:
>        #define __raw_readsl(p,d,l)  do { *(int *)0 = 0; } while (0)
> ./arch/arm/mach-clps711x/include/mach/io.h:
>        #define __raw_writesb(p,d,l) do { *(int *)0 = 0; } while (0)
> ./arch/arm/mach-clps711x/include/mach/io.h:
>        #define __raw_writesl(p,d,l) do { *(int *)0 = 0; } while (0)
> ./arch/arm/kernel/traps.c:      *(int *)0 = 0;
>
>
>  arch/arm/include/asm/bug.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/include/asm/bug.h b/arch/arm/include/asm/bug.h
> index 4d88425..a58d863 100644
> --- a/arch/arm/include/asm/bug.h
> +++ b/arch/arm/include/asm/bug.h
> @@ -12,7 +12,7 @@ extern void __bug(const char *file, int line) __attribute__((noreturn));
>  #else
>
>  /* this just causes an oops */
> -#define BUG()          do { *(int *)0 = 0; } while (1)
> +#define BUG()          do { *(volatile int *)0 = 0; } while(1)
>
>  #endif
>
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
