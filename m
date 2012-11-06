Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab2KFSZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 13:25:15 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38766 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2KFSZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 13:25:12 -0500
MIME-Version: 1.0
In-Reply-To: <1351633534-20817-1-git-send-email-marek.belisko@open-nandra.com>
References: <1351633534-20817-1-git-send-email-marek.belisko@open-nandra.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Tue, 6 Nov 2012 10:24:51 -0800
Message-ID: <CAK5ve-+fE7T3U9KZ-C5-sZN9PUPq6RybCu+nv9UDb2x0bnarzw@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds/tca6507: Add support for devicetree.
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: rpurdie@rpsys.net, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 2:45 PM, Marek Belisko
<marek.belisko@open-nandra.com> wrote:
> Support added only for leds (not for gpio's).
>
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> ---
>  drivers/leds/leds-tca6507.c |   73 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 70 insertions(+), 3 deletions(-)
>

Overall, this looks good to me. Maybe some question as below,

-Bryan

> diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
> index dabcf7a..496dd98 100644
> --- a/drivers/leds/leds-tca6507.c
> +++ b/drivers/leds/leds-tca6507.c
> @@ -667,6 +667,69 @@ static void tca6507_remove_gpio(struct tca6507_chip *tca)
>  }
>  #endif /* CONFIG_GPIOLIB */
>
> +#ifdef CONFIG_OF
> +static struct tca6507_platform_data * __devinit tca6507_led_dt_init(struct i2c_client *client)
> +{
> +       struct device_node *np = client->dev.of_node, *child;
> +       struct tca6507_platform_data *pdata;
> +       struct led_info *tca_leds;
> +       int count = 0;
> +
> +       for_each_child_of_node(np, child)
> +               count++;
> +       if (!count)
> +               return NULL;
> +

I saw many 'return NULL' here, why not return some error code in ERR_PTR?

> +       if (count > NUM_LEDS)
> +               return NULL;
> +
> +       tca_leds = devm_kzalloc(&client->dev, sizeof(struct led_info) * NUM_LEDS, GFP_KERNEL);
> +

useless empty line.

> +       if (!tca_leds)
> +               return NULL;
> +
> +

useless empty line.

> +       for_each_child_of_node(np, child) {
> +               struct led_info led;
> +               u32 reg;
> +               int ret;
> +
> +               led.name = of_get_property(child, "label", NULL) ? : child->name;
> +               led.default_trigger =
> +                       of_get_property(child, "linux,default-trigger", NULL);
> +
> +               ret = of_property_read_u32(child, "reg", &reg);
> +
> +               if (ret != 0)
> +                       continue;
> +               tca_leds[reg] = led;
> +       }
> +       pdata = devm_kzalloc(&client->dev, sizeof(struct tca6507_platform_data), GFP_KERNEL);
> +       if (!pdata) {
> +               kfree(tca_leds);

Do we need to kfree here? I think devm_zalloc() will take care of this
if the driver failed to register.

> +               return NULL;
> +       }
> +
> +       pdata->leds.leds = tca_leds;
> +       pdata->leds.num_leds = NUM_LEDS;
> +
> +       return pdata;
> +}
> +
> +static const struct of_device_id of_tca6507_leds_match[] = {
> +       { .compatible = "leds-tca6507", },
> +       {},
> +};
> +
> +#else
> +static int __devinit tca6507_led_dt_init(struct i2c_client *client, struct tca6507_platform_data *data)
> +{
> +       return -1;
> +}
> +
> +#define of_tca6507_leds_match NULL
> +#endif
> +
>  static int __devinit tca6507_probe(struct i2c_client *client,
>                                    const struct i2c_device_id *id)
>  {
> @@ -683,9 +746,12 @@ static int __devinit tca6507_probe(struct i2c_client *client,
>                 return -EIO;
>
>         if (!pdata || pdata->leds.num_leds != NUM_LEDS) {
> -               dev_err(&client->dev, "Need %d entries in platform-data list\n",
> -                       NUM_LEDS);
> -               return -ENODEV;
> +               pdata = tca6507_led_dt_init(client);
> +               if (!pdata) {
> +                       dev_err(&client->dev, "Need %d entries in platform-data list\n",
> +                               NUM_LEDS);
> +                       return -ENODEV;
> +               }
>         }
>         tca = devm_kzalloc(&client->dev, sizeof(*tca), GFP_KERNEL);
>         if (!tca)
> @@ -750,6 +816,7 @@ static struct i2c_driver tca6507_driver = {
>         .driver   = {
>                 .name    = "leds-tca6507",
>                 .owner   = THIS_MODULE,
> +               .of_match_table = of_tca6507_leds_match,
>         },
>         .probe    = tca6507_probe,
>         .remove   = __devexit_p(tca6507_remove),
> --
> 1.7.9.5
>
