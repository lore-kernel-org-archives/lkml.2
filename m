Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab2KRJnI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 04:43:08 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39157 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2KRJnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 04:43:04 -0500
MIME-Version: 1.0
In-Reply-To: <m28v9zzzrr.fsf@igel.home>
References: <m28v9zzzrr.fsf@igel.home>
Date: Sun, 18 Nov 2012 10:43:03 +0100
X-Google-Sender-Auth: u_aOfRxQoJSEoENqvNm4_CGwM7s
Message-ID: <CAMuHMdU8DB4sq35KaN2L5b-QSt8BBhwEHNixuqgFqJOoOdqKZA@mail.gmail.com>
Subject: Re: [PATCH] m68k: fix sigset_t accessor functions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On Sat, Nov 17, 2012 at 10:27 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> The sigaddset/sigdelset/sigismember functions that are implemented with
> bitfield insn cannot allow the sigset argument to be placed in a data
> register since the sigset is wider than 32 bits.  Remove the "d"
> constraint from the asm statements.
>
> The effect of the bug is that sending RT signals does not work, the signal
> number is truncated modulo 32.

Thanks, applied and queued for 3.7 and stable.

> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> ---
>  arch/m68k/include/asm/signal.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/m68k/include/asm/signal.h b/arch/m68k/include/asm/signal.h
> index 60e8866..93fe83e 100644
> --- a/arch/m68k/include/asm/signal.h
> +++ b/arch/m68k/include/asm/signal.h
> @@ -156,7 +156,7 @@ typedef struct sigaltstack {
>  static inline void sigaddset(sigset_t *set, int _sig)
>  {
>         asm ("bfset %0{%1,#1}"
> -               : "+od" (*set)
> +               : "+o" (*set)
>                 : "id" ((_sig - 1) ^ 31)
>                 : "cc");
>  }
> @@ -164,7 +164,7 @@ static inline void sigaddset(sigset_t *set, int _sig)
>  static inline void sigdelset(sigset_t *set, int _sig)
>  {
>         asm ("bfclr %0{%1,#1}"
> -               : "+od" (*set)
> +               : "+o" (*set)
>                 : "id" ((_sig - 1) ^ 31)
>                 : "cc");
>  }
> @@ -180,7 +180,7 @@ static inline int __gen_sigismember(sigset_t *set, int _sig)
>         int ret;
>         asm ("bfextu %1{%2,#1},%0"
>                 : "=d" (ret)
> -               : "od" (*set), "id" ((_sig-1) ^ 31)
> +               : "o" (*set), "id" ((_sig-1) ^ 31)
>                 : "cc");
>         return ret;
>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
