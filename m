Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108Ab2KWJe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:34:27 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:57188 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759095Ab2KWJeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:34:24 -0500
MIME-Version: 1.0
In-Reply-To: <1352894295-14339-2-git-send-email-alban.bedel@avionic-design.de>
References: <1352894295-14339-1-git-send-email-alban.bedel@avionic-design.de>
	<1352894295-14339-2-git-send-email-alban.bedel@avionic-design.de>
Date: Fri, 23 Nov 2012 07:34:23 -0200
Message-ID: <CAAAP30GUM31pcHxXfWJnuUBN2jYHbWz0XFX7o6x=_2wNtbHroQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] pwm: lpc32xx - Fix the PWM polarity
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Roland Stigge <stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 9:58 AM, Alban Bedel
<alban.bedel@avionic-design.de> wrote:
> The duty cycles value goes from 1 (99% HIGH) to 256 (0% HIGH) but it
> is stored modulo 256 in the register as it is only 8 bits wide.
>
> Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>

Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

> ---
>  drivers/pwm/pwm-lpc32xx.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
> index adb87f0..03ec3ff 100644
> --- a/drivers/pwm/pwm-lpc32xx.c
> +++ b/drivers/pwm/pwm-lpc32xx.c
> @@ -49,9 +49,24 @@ static int lpc32xx_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
>                 c = 0; /* 0 set division by 256 */
>         period_cycles = c;
>
> +       /* The duty value is a follow:
> +        *
> +        *  DUTY     HIGH LEVEL
> +        *   1         99.9%
> +        *   25        90.0%
> +        *   128       50.0%
> +        *   220       10.0%
> +        *   255        0.1%
> +        *   0          0.0%
> +        *
> +        * In other word the in-register value is duty % 256 with duty
> +        * in the range 1-256.
> +        */
>         c = 256 * duty_ns;
>         do_div(c, period_ns);
> -       duty_cycles = c;
> +       if (c > 255)
> +               c = 255;
> +       duty_cycles = 256 - c;
>
>         writel(PWM_ENABLE | PWM_RELOADV(period_cycles) | PWM_DUTY(duty_cycles),
>                 lpc32xx->base + (pwm->hwpwm << 2));
> --
> 1.7.0.4
>
