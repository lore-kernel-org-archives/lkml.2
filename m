Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab1FOOkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:40:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58695 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab1FOOka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=w818a2cSOHhtX2kFzkU/3+A+YUgFWPICYmJf221EIQdrYctJHXb2zVY8USuwRu2Xww
         gywEJ39laTEDnLzFOWVUpfJDiz6tfVIFTQT8smOKurZHtyLvVFgTb9CqcF9MTuWud5ua
         Khg8ycYQPtU5Tje9PAAKn9UNI0JUgXxc8KllU=
MIME-Version: 1.0
In-Reply-To: <1307711394-7827-1-git-send-email-minipli@googlemail.com>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com>
	<1307642718-22257-1-git-send-email-minipli@googlemail.com>
	<20110609155630.0f734351.akpm@linux-foundation.org>
	<BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
	<1307711394-7827-1-git-send-email-minipli@googlemail.com>
Date: Wed, 15 Jun 2011 16:40:28 +0200
X-Google-Sender-Auth: gfQG4NJkibzET9qSMMi2J7JFhXo
Message-ID: <BANLkTin214-RYxJUQ-uM6iYz1NQLBKRH2Q@mail.gmail.com>
Subject: Re: [PATCH] m68k, exec: remove redundant set_fs(USER_DS)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 15:09, Mathias Krause <minipli@googlemail.com> wrote:
> The address limit is already set in flush_old_exec() so those calls to
> set_fs(USER_DS) are redundant.
>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Cc: Greg Ungerer <gerg@uclinux.org>
> ---
>
> Note: I'm not sure about the assignment to current->thread.fs in
> flush_thread() -- shouldn't this be done in set_fs() itself?

set_fs() is used to temporary set the address space to be used from the
kernel.
current->thread.fs is the address space that will be used when the
thread returns
to userspace.
So I think it's correct.

For nommu, thread.fs is set, but not really used.

>  arch/m68k/include/asm/processor.h |    4 ----
>  arch/m68k/kernel/process_mm.c     |    2 +-
>  arch/m68k/kernel/process_no.c     |    2 +-
>  3 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/arch/m68k/include/asm/processor.h b/arch/m68k/include/asm/processor.h
> index f111b02..d8ef53a 100644
> --- a/arch/m68k/include/asm/processor.h
> +++ b/arch/m68k/include/asm/processor.h
> @@ -105,9 +105,6 @@ struct thread_struct {
>  static inline void start_thread(struct pt_regs * regs, unsigned long pc,
>                                unsigned long usp)
>  {
> -       /* reads from user space */
> -       set_fs(USER_DS);
> -
>        regs->pc = pc;
>        regs->sr &= ~0x2000;
>        wrusp(usp);
> @@ -129,7 +126,6 @@ extern int handle_kernel_fault(struct pt_regs *regs);
>
>  #define start_thread(_regs, _pc, _usp)                  \
>  do {                                                    \
> -       set_fs(USER_DS); /* reads from user space */    \
>        (_regs)->pc = (_pc);                            \
>        ((struct switch_stack *)(_regs))[-1].a6 = 0;    \
>        reformat(_regs);                                \
> diff --git a/arch/m68k/kernel/process_mm.c b/arch/m68k/kernel/process_mm.c
> index c2a1fc2..1bc223a 100644
> --- a/arch/m68k/kernel/process_mm.c
> +++ b/arch/m68k/kernel/process_mm.c
> @@ -185,7 +185,7 @@ EXPORT_SYMBOL(kernel_thread);
>  void flush_thread(void)
>  {
>        unsigned long zero = 0;
> -       set_fs(USER_DS);
> +
>        current->thread.fs = __USER_DS;
>        if (!FPU_IS_EMU)
>                asm volatile (".chip 68k/68881\n\t"
> diff --git a/arch/m68k/kernel/process_no.c b/arch/m68k/kernel/process_no.c
> index 9b86ad1..69c1803 100644
> --- a/arch/m68k/kernel/process_no.c
> +++ b/arch/m68k/kernel/process_no.c
> @@ -158,7 +158,7 @@ void flush_thread(void)
>  #ifdef CONFIG_FPU
>        unsigned long zero = 0;
>  #endif
> -       set_fs(USER_DS);
> +
>        current->thread.fs = __USER_DS;
>  #ifdef CONFIG_FPU
>        if (!FPU_IS_EMU)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
