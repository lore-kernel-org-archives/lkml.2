Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2HVCnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 22:43:17 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44052 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2HVCnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 22:43:14 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF0AD5@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0AD5@DQHE02.ent.ti.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 22 Aug 2012 10:42:52 +0800
X-Google-Sender-Auth: CP7fjVaSlC1Cvfy2Ng1qexhMMos
Message-ID: <CAK5ve-+LWG=YzEy=qWnGvqzw6+tX=7su5NH5V=5g+fjHA6gJrg@mail.gmail.com>
Subject: Re: [PATCH 1/4] leds-lp5523: add channel name in the platform data
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "mathias.nyman@nokia.com" <mathias.nyman@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 5:03 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
> The name of each led channel is configurable.
> If the name is NULL, just use the channel id for making the channel name
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  Documentation/leds/leds-lp5523.txt |    7 +++++--
>  drivers/leds/leds-lp5523.c         |   10 +++++++---
>  include/linux/leds-lp5523.h        |    1 +
>  3 files changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/leds/leds-lp5523.txt b/Documentation/leds/leds-lp5523.txt
> index fad2feb..e958d9a 100644
> --- a/Documentation/leds/leds-lp5523.txt
> +++ b/Documentation/leds/leds-lp5523.txt
> @@ -10,7 +10,9 @@ Contact: Samu Onkalo (samu.p.onkalo-at-nokia.com)
>  Description
>  -----------
>  LP5523 can drive up to 9 channels. Leds can be controlled directly via
> -the led class control interface. Channels have generic names:
> +the led class control interface.
> +The name of each channel is configurable in the platform data.
> +If the name is NULL, channels have generic names:
>  lp5523:channelx where x is 0...8
>
>  The chip provides 3 engines. Each engine can control channels without
> @@ -46,12 +48,13 @@ Note - chan_nr can have values between 0 and 8.
>
>  static struct lp5523_led_config lp5523_led_config[] = {
>          {
> +               .name           = "red",
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

Why we need a test here "pdata->label ?:"? From the document, looks
like we use lp5523:channel%d as default.

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
