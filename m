Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab2HVOym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:54:42 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61843 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2HVOyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:54:39 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF0C3F@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0C3F@DQHE02.ent.ti.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 22 Aug 2012 22:54:16 +0800
X-Google-Sender-Auth: LNbhCQQjXpA8k41hOQH-Veprj1Q
Message-ID: <CAK5ve-+umR2-8P46bZaDzqQBKotLTNb-Jg8xYBAP_kjWCK04LA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] leds-lp5523: add channel name in the platform data
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 3:32 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
> The name of each led channel is configurable.
> If the name is NULL, just use the channel id for making the channel name
>

OK, merged to my for-next branch.

-Bryan

> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  Documentation/leds/leds-lp5523.txt |   21 ++++++++++++++++++---
>  drivers/leds/leds-lp5523.c         |   10 +++++++---
>  include/linux/leds-lp5523.h        |    1 +
>  3 files changed, 26 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/leds/leds-lp5523.txt b/Documentation/leds/leds-lp5523.txt
> index fad2feb..c2743f5 100644
> --- a/Documentation/leds/leds-lp5523.txt
> +++ b/Documentation/leds/leds-lp5523.txt
> @@ -10,8 +10,22 @@ Contact: Samu Onkalo (samu.p.onkalo-at-nokia.com)
>  Description
>  -----------
>  LP5523 can drive up to 9 channels. Leds can be controlled directly via
> -the led class control interface. Channels have generic names:
> -lp5523:channelx where x is 0...8
> +the led class control interface.
> +The name of each channel is configurable in the platform data - name and label.
> +There are three options to make the channel name.
> +
> +a) Define the 'name' in the platform data
> +To make specific channel name, then use 'name' platform data.
> +/sys/class/leds/R1               (name: 'R1')
> +/sys/class/leds/B1               (name: 'B1')
> +
> +b) Use the 'label' with no 'name' field
> +For one device name with channel number, then use 'label'.
> +/sys/class/leds/RGB:channelN     (label: 'RGB', N: 0 ~ 8)
> +
> +c) Default
> +If both fields are NULL, 'lp5523' is used by default.
> +/sys/class/leds/lp5523:channelN  (N: 0 ~ 8)
>
>  The chip provides 3 engines. Each engine can control channels without
>  interaction from the main CPU. Details of the micro engine code can be found
> @@ -46,12 +60,13 @@ Note - chan_nr can have values between 0 and 8.
>
>  static struct lp5523_led_config lp5523_led_config[] = {
>          {
> +               .name           = "D1",
>                  .chan_nr        = 0,
>                  .led_current    = 50,
>                 .max_current    = 130,
>          },
>  ...
> -        }, {
> +        {
>                  .chan_nr        = 8,
>                  .led_current    = 50,
>                 .max_current    = 130,
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index fbc12ac..9fd9a92 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -846,10 +846,14 @@ static int __devinit lp5523_init_led(struct lp5523_led *led, struct device *dev,
>                         return -EINVAL;
>                 }
>
> -               snprintf(name, sizeof(name), "%s:channel%d",
> -                       pdata->label ?: "lp5523", chan);
> +               if (pdata->led_config[chan].name) {
> +                       led->cdev.name = pdata->led_config[chan].name;
> +               } else {
> +                       snprintf(name, sizeof(name), "%s:channel%d",
> +                               pdata->label ?: "lp5523", chan);
> +                       led->cdev.name = name;
> +               }
>
> -               led->cdev.name = name;
>                 led->cdev.brightness_set = lp5523_set_brightness;
>                 res = led_classdev_register(dev, &led->cdev);
>                 if (res < 0) {
> diff --git a/include/linux/leds-lp5523.h b/include/linux/leds-lp5523.h
> index 2694289..727877f 100644
> --- a/include/linux/leds-lp5523.h
> +++ b/include/linux/leds-lp5523.h
> @@ -26,6 +26,7 @@
>  /* See Documentation/leds/leds-lp5523.txt */
>
>  struct lp5523_led_config {
> +       const char      *name;
>         u8              chan_nr;
>         u8              led_current; /* mA x10, 0 if led is not connected */
>         u8              max_current;
> --
> 1.7.2.5
>
>
> Best Regards,
> Milo
>
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
