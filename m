Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795Ab2HVILf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:11:35 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61246 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758762Ab2HVILN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:11:13 -0400
MIME-Version: 1.0
In-Reply-To: <1345595449-34965-4-git-send-email-john.stultz@linaro.org>
References: <1345595449-34965-1-git-send-email-john.stultz@linaro.org>
	<1345595449-34965-4-git-send-email-john.stultz@linaro.org>
Date: Wed, 22 Aug 2012 10:11:11 +0200
X-Google-Sender-Auth: Idev8OuKT7iyrlQ3zfTZeNU6s2Y
Message-ID: <CAMuHMdWPixVG3u17WNJEUv3YYbATy-GVVqR8w6+0H+Fi4xi29g@mail.gmail.com>
Subject: Re: [PATCH 3/4] time: Avoid potential shift-overflow with large shift values
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Schwab <schwab@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Wed, Aug 22, 2012 at 2:30 AM, John Stultz <john.stultz@linaro.org> wrote:
> Andreas Schwab noted that the 1 << tk->shift could overflow
> if the shift value was greater then 30, since 1 would be
> a 32bit long on 32bit architectures.

This comment is not entirely correct: "1" is not a long, but an
(32-bit signed) int,
so it can overflow on 64-bit platforms, too.

> This patch uses 1ULL instead to ensure we don't overflow on
> the shift.
>
> This issue was introduced by 1e75fa8be9fb61e1af46b5b3b176347a4c958ca1
>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Prarit Bhargava <prarit@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andreas Schwab <schwab@linux-m68k.org>
> Reported-by: Andreas Schwab <schwab@linux-m68k.org>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  kernel/time/timekeeping.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 1dbf80e..a5a9389 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1184,9 +1184,9 @@ static void update_wall_time(void)
>         * the vsyscall implementations are converted to use xtime_nsec
>         * (shifted nanoseconds), this can be killed.
>         */
> -       remainder = tk->xtime_nsec & ((1 << tk->shift) - 1);
> +       remainder = tk->xtime_nsec & ((1ULL << tk->shift) - 1);
>         tk->xtime_nsec -= remainder;
> -       tk->xtime_nsec += 1 << tk->shift;
> +       tk->xtime_nsec += 1ULL << tk->shift;
>         tk->ntp_error += remainder << tk->ntp_error_shift;
>
>         /*

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
