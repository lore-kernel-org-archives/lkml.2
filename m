Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab0ISEvl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 00:51:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37260 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab0ISEvj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 00:51:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sClVAxqeItxNbTHp67lmQhCxXNaVcjqowxfiGqV11aJ3TgXGcKP1L7DtEn3se7ee5m
         AUPTSHV7pFoeEHnAJrbFfcskP24uUwZXbCUCtF+/pL+ce9Def1J2iVG1jBy18DGIERUT
         srWzwCjMuYkwpWhtvm/PzUmhaerdfRM0/+tDY=
MIME-Version: 1.0
In-Reply-To: <1284861940-6571-1-git-send-email-mcree@orcon.net.nz>
References: <1284861940-6571-1-git-send-email-mcree@orcon.net.nz>
From: Matt Turner <mattst88@gmail.com>
Date: Sun, 19 Sep 2010 00:51:18 -0400
Message-ID: <AANLkTimoyT7KLtrNL3Wkvcxg1Da6-EdHP5MaKBbh0B1e@mail.gmail.com>
Subject: Re: [PATCH] alpha: Shift perf event pending work earlier in timer interrupt
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>, mingo@redhat.com,
        a.p.zijlstra@chello.nl, linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 10:05 PM, Michael Cree <mcree@orcon.net.nz> wrote:
> Pending work from the performance event subsystem is executed in
> the timer interrupt.  This patch shifts the call to
> perf_event_do_pending() before the call to update_process_times()
> as the latter may call back into the perf event subsystem and it
> is prudent to have the pending work executed first.
>
> Signed-off-by: Michael Cree <mcree@orcon.net.nz>
> ---
>  arch/alpha/kernel/time.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
> index eacceb2..396af17 100644
> --- a/arch/alpha/kernel/time.c
> +++ b/arch/alpha/kernel/time.c
> @@ -191,16 +191,16 @@ irqreturn_t timer_interrupt(int irq, void *dev)
>
>        write_sequnlock(&xtime_lock);
>
> -#ifndef CONFIG_SMP
> -       while (nticks--)
> -               update_process_times(user_mode(get_irq_regs()));
> -#endif
> -
>        if (test_perf_event_pending()) {
>                clear_perf_event_pending();
>                perf_event_do_pending();
>        }
>
> +#ifndef CONFIG_SMP
> +       while (nticks--)
> +               update_process_times(user_mode(get_irq_regs()));
> +#endif
> +
>        return IRQ_HANDLED;
>  }
>
> --
> 1.7.1

Thanks! Added to my tree and sent to Linus.
