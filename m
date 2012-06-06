Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab2FFD6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 23:58:33 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40454 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2FFD6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 23:58:32 -0400
MIME-Version: 1.0
In-Reply-To: <1338932339-1660-2-git-send-email-fabio.baltieri@gmail.com>
References: <1338932339-1660-1-git-send-email-fabio.baltieri@gmail.com> <1338932339-1660-2-git-send-email-fabio.baltieri@gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 6 Jun 2012 11:58:10 +0800
X-Google-Sender-Auth: O8Z91sFlZ70CfXnsNNk_o1gCbyQ
Message-ID: <CAK5ve-J1Oo3Xkr=LMxVkG0F-in3VDbB+RfB1O835vPKVzpGu6A@mail.gmail.com>
Subject: Re: [PATCH 2/2] leds: fix led_brightness_set when soft-blinking
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 5:38 AM, Fabio Baltieri <fabio.baltieri@gmail.com> wrote:
> Change led_brightness_set to ensure software blink timer is stopped
> before calling led_stop_software_blink() and use led_set_brightness()
> instead of calling led_cdev->brightness_set() directly to ensure
> led_cdev->brightness is always consistent with current LED status.
>
> This ensure proper cleaning when changing triggers, as without this fix
> a LED may be turned off while leaving it's led_cdev->brightness = 1,
> leading to an erratic software-blink behaviour.
>
> The problem was easy to reproduce by changing the trigger from "timer"
> to "oneshot".
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> Cc: Bryan Wu <bryan.wu@canonical.com>
> ---
>  drivers/leds/led-core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> index 579eb78..3e9f934 100644
> --- a/drivers/leds/led-core.c
> +++ b/drivers/leds/led-core.c
> @@ -115,7 +115,8 @@ EXPORT_SYMBOL(led_blink_set_oneshot);
>  void led_brightness_set(struct led_classdev *led_cdev,
>                        enum led_brightness brightness)
>  {
> +       del_timer_sync(&led_cdev->blink_timer);

This is not necessary, since led_stop_software_blink() will call
del_timer_sync() as you want.

>        led_stop_software_blink(led_cdev);
> -       led_cdev->brightness_set(led_cdev, brightness);
> +       led_set_brightness(led_cdev, brightness);
>  }
>  EXPORT_SYMBOL(led_brightness_set);
> --
> 1.7.10.2.520.g6a4a482.dirty
>

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
