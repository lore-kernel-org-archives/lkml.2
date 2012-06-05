Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab2FEHUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 03:20:40 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50975 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab2FEHUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 03:20:39 -0400
MIME-Version: 1.0
In-Reply-To: <1338074364-1829-2-git-send-email-fabio.baltieri@gmail.com>
References: <1338074364-1829-1-git-send-email-fabio.baltieri@gmail.com> <1338074364-1829-2-git-send-email-fabio.baltieri@gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Tue, 5 Jun 2012 15:20:17 +0800
X-Google-Sender-Auth: l9s4EMvQPj5UMQAWsm7d167mQ2Q
Message-ID: <CAK5ve-KKM0ieS9-g0NRv=nybxUn9pemSXU_PD_yteTGJSAJ5vQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ledtrig-ide-disk: use generic one-shot blink api
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 27, 2012 at 7:19 AM, Fabio Baltieri
<fabio.baltieri@gmail.com> wrote:
> Convert ledtrig-ide-disk code to use the generic API for one-shot LED
> blinking.
>
> This patch changes slightly the behaviour of the trigger, as while the
> original version kept the LED on under heavy activity, the new one keeps
> a constant on-off blink at 1 / (2 * BLINK_DELAY) Hz.
>

Applied to my for-next branch after removing 2 useless header files,
since with this patch we don't need them.

-Bryan

> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> Cc: Bryan Wu <bryan.wu@canonical.com>
> ---
>  drivers/leds/ledtrig-ide-disk.c | 23 ++++-------------------
>  1 file changed, 4 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/leds/ledtrig-ide-disk.c b/drivers/leds/ledtrig-ide-disk.c
> index ec099fc..0ff16fb 100644
> --- a/drivers/leds/ledtrig-ide-disk.c
> +++ b/drivers/leds/ledtrig-ide-disk.c
> @@ -18,33 +18,18 @@
>  #include <linux/timer.h>
>  #include <linux/leds.h>
>
> -static void ledtrig_ide_timerfunc(unsigned long data);
> +#define BLINK_DELAY 30
>
>  DEFINE_LED_TRIGGER(ledtrig_ide);
> -static DEFINE_TIMER(ledtrig_ide_timer, ledtrig_ide_timerfunc, 0, 0);
> -static int ide_activity;
> -static int ide_lastactivity;
> +static unsigned long ide_blink_delay = BLINK_DELAY;
>
>  void ledtrig_ide_activity(void)
>  {
> -       ide_activity++;
> -       if (!timer_pending(&ledtrig_ide_timer))
> -               mod_timer(&ledtrig_ide_timer, jiffies + msecs_to_jiffies(10));
> +       led_trigger_blink_oneshot(ledtrig_ide,
> +                                 &ide_blink_delay, &ide_blink_delay, 0);
>  }
>  EXPORT_SYMBOL(ledtrig_ide_activity);
>
> -static void ledtrig_ide_timerfunc(unsigned long data)
> -{
> -       if (ide_lastactivity != ide_activity) {
> -               ide_lastactivity = ide_activity;
> -               /* INT_MAX will set each LED to its maximum brightness */
> -               led_trigger_event(ledtrig_ide, INT_MAX);
> -               mod_timer(&ledtrig_ide_timer, jiffies + msecs_to_jiffies(10));
> -       } else {
> -               led_trigger_event(ledtrig_ide, LED_OFF);
> -       }
> -}
> -
>  static int __init ledtrig_ide_init(void)
>  {
>        led_trigger_register_simple("ide-disk", &ledtrig_ide);
> --
> 1.7.10.2.520.g6a4a482.dirty
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
