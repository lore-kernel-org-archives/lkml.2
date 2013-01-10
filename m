Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932635Ab3AJBVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 20:21:41 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:45468 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab3AJBVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 20:21:39 -0500
X-Greylist: delayed 341 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jan 2013 20:21:38 EST
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E11A6C@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E11A6C@DQHE02.ent.ti.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 9 Jan 2013 17:15:36 -0800
Message-ID: <CAK5ve-+mork5jCziq64zcHC09fATth9mRCoJFiRDsFSO=+B0JA@mail.gmail.com>
Subject: Re: [PATCH] leds-lm355x: support LED trigger functionality
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "Jeong, Daniel" <Daniel.Jeong@ti.com>,
        "gshark.jeong@gmail.com" <gshark.jeong@gmail.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 10:35 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
>  LM355x family devices provide flash, torch and indicator functions.
>  This patch support LED trigger feature.
>  Using LED trigger APIs(), other driver simply turn on/off the flash, torch
>  and indicator.
>
>  Platform data
>   the name of LED trigger is configurable.
>
>  Documentation
>   example and detailed description added.
>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  Documentation/leds/leds-lm3556.txt        |   62 +++++++++++++++++++++++++++++
>  drivers/leds/leds-lm355x.c                |    3 ++
>  include/linux/platform_data/leds-lm355x.h |    8 ++++
>  3 files changed, 73 insertions(+)
>
> diff --git a/Documentation/leds/leds-lm3556.txt b/Documentation/leds/leds-lm3556.txt
> index d9eb91b..73244cd 100644
> --- a/Documentation/leds/leds-lm3556.txt
> +++ b/Documentation/leds/leds-lm3556.txt
> @@ -83,3 +83,65 @@ and register it in the platform init function
>  Example:
>         board_register_i2c_bus(4, 400,
>                                 board_i2c_ch4, ARRAY_SIZE(board_i2c_ch4));
> +
> +Support LED Triggers
> +--------------------
> +Flash, torch and indicator can be controlled not only by an user-space but also
> +by other drivers, kernel space.
> +For example, flash turns on by camera driver internally.
> +To support this functionality, LED trigger is registered.
> +The name of LED trigger is configurable in the platform data.
> +
> +Example: LED trigger name for flash
> +#include <linux/platform_data/leds-lm355x.h>
> +
> +struct lm355x_trigger_name lm3556_trigger_name = {
> +       .flash = "flash",
> +};
> +
> +struct lm355x_platform_data lm3556_pdata = {
> +       ...
> +       .trigger = &lm3556_trigger_name,
> +};
> +
> +Example: Flash control in simple camera driver

Hi Milo,

Can we share this camera flash trigger with other users? just
introduce a new trigger in drivers/leds/ledtrig-flash.c,
drivers/leds/ledtrig-torch.c, drivers/leds/ledtrig-indicator.c. So it
can shared by plenty of users.

And this trigger can be independent with LM355x and use other LED
hardware driver underneath.

So I expect such trigger driver instead of a specific trigger in LED
hardware driver and in other subsystem.

-Bryan

> +#include <linux/leds.h>
> +
> +#ifdef CONFIG_LEDS_TRIGGERS
> +DEFINE_LED_TRIGGER(flash_led_trigger);
> +#endif
> +
> +static int foo_camera_init()
> +{
> +       ...
> +
> +#ifdef CONFIG_LEDS_TRIGGERS
> +       /* should be same name as in lm355x_platform_data */
> +       led_trigger_register_simple("flash", &flash_led_trigger);
> +#endif
> +
> +       ...
> +}
> +
> +static void foo_camera_exit()
> +{
> +       ...
> +
> +#ifdef CONFIG_LEDS_TRIGGERS
> +       led_trigger_unregister_simple(flash_led_trigger);
> +#endif
> +
> +       ...
> +}
> +
> +#ifdef CONFIG_LEDS_TRIGGERS
> +static void foo_camera_flash_ctrl(bool on)
> +{
> +       if (on)
> +               led_trigger_event(flash_led_trigger, LED_FULL);
> +       else
> +               led_trigger_event(flash_led_trigger, LED_OFF);
> +}
> +#else
> +#define foo_camera_flash_ctrl  NULL
> +#endif
> diff --git a/drivers/leds/leds-lm355x.c b/drivers/leds/leds-lm355x.c
> index 65d7928..29df4c0 100644
> --- a/drivers/leds/leds-lm355x.c
> +++ b/drivers/leds/leds-lm355x.c
> @@ -477,6 +477,7 @@ static int lm355x_probe(struct i2c_client *client,
>         chip->cdev_flash.name = "flash";
>         chip->cdev_flash.max_brightness = 16;
>         chip->cdev_flash.brightness_set = lm355x_strobe_brightness_set;
> +       chip->cdev_flash.default_trigger = pdata->trigger->flash;
>         err = led_classdev_register((struct device *)
>                                     &client->dev, &chip->cdev_flash);
>         if (err < 0)
> @@ -486,6 +487,7 @@ static int lm355x_probe(struct i2c_client *client,
>         chip->cdev_torch.name = "torch";
>         chip->cdev_torch.max_brightness = 8;
>         chip->cdev_torch.brightness_set = lm355x_torch_brightness_set;
> +       chip->cdev_torch.default_trigger = pdata->trigger->torch;
>         err = led_classdev_register((struct device *)
>                                     &client->dev, &chip->cdev_torch);
>         if (err < 0)
> @@ -499,6 +501,7 @@ static int lm355x_probe(struct i2c_client *client,
>         else
>                 chip->cdev_indicator.max_brightness = 8;
>         chip->cdev_indicator.brightness_set = lm355x_indicator_brightness_set;
> +       chip->cdev_indicator.default_trigger = pdata->trigger->indicator;
>         err = led_classdev_register((struct device *)
>                                     &client->dev, &chip->cdev_indicator);
>         if (err < 0)
> diff --git a/include/linux/platform_data/leds-lm355x.h b/include/linux/platform_data/leds-lm355x.h
> index b88724b..b64d312 100644
> --- a/include/linux/platform_data/leds-lm355x.h
> +++ b/include/linux/platform_data/leds-lm355x.h
> @@ -42,6 +42,12 @@ enum lm355x_pmode {
>         LM355x_PMODE_ENABLE = 0x04,
>  };
>
> +struct lm355x_trigger_name {
> +       const char *flash;
> +       const char *torch;
> +       const char *indicator;
> +};
> +
>  /*
>   * struct lm3554_platform_data
>   * @pin_strobe: strobe input
> @@ -55,6 +61,7 @@ enum lm355x_pmode {
>   *              lm3554-ledi/ntc
>   *              lm3556-temp pin
>   * @pass_mode : pass mode
> + * @triger    : led triggers for flash, torch and indicator
>   */
>  struct lm355x_platform_data {
>         enum lm355x_strobe pin_strobe;
> @@ -63,4 +70,5 @@ struct lm355x_platform_data {
>         enum lm355x_ntc ntc_pin;
>
>         enum lm355x_pmode pass_mode;
> +       struct lm355x_trigger_name *trigger;
>  };
> --
> 1.7.9.5
>
> Best Regards,
> Milo
>
>
