Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab2GSOuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 10:50:54 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61512 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2GSOuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 10:50:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120719072751.GC3300@core.coreip.homeip.net>
References: <1341858707-1771-1-git-send-email-aletes.xgr@gmail.com>
	<20120719072751.GC3300@core.coreip.homeip.net>
Date: Thu, 19 Jul 2012 11:50:50 -0300
Message-ID: <CAAAP30HbPV2WuMKVn1RfxxkX5eYiVNg7Vmy05fCBmzPSWEqFRA@mail.gmail.com>
Subject: Re: [PATCH RESEND V2] input: gpio_keys_polled: convert to dt
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Tobias Klauser <tklauser@distanz.ch>, David Jander <david@protonic.nl>,
        JJ Ding <dgdunix@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Dmitry

On Thu, Jul 19, 2012 at 4:27 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Alexandre,
>
> On Mon, Jul 09, 2012 at 03:31:43PM -0300, Alexandre Pereira da Silva wrote:
>> @@ -38,7 +40,7 @@ struct gpio_keys_button_data {
>>  struct gpio_keys_polled_dev {
>>       struct input_polled_dev *poll_dev;
>>       struct device *dev;
>> -     struct gpio_keys_platform_data *pdata;
>> +     struct gpio_keys_platform_data pdata;
>>       struct gpio_keys_button_data data[0];
>>  };
>
> Instead of using a copy of pdata how about the patch below?

This solution looks fine to me.

> Thanks.
>
> --
> Dmitry
>
>
> Input: gpio_keys_polled - convert to dt
>
> From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
>
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>
>  .../devicetree/bindings/input/gpio-keys-polled.txt |   38 ++++++
>  drivers/input/keyboard/gpio_keys_polled.c          |  124 +++++++++++++++++++-
>  2 files changed, 157 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/input/gpio-keys-polled.txt
>
>
> diff --git a/Documentation/devicetree/bindings/input/gpio-keys-polled.txt b/Documentation/devicetree/bindings/input/gpio-keys-polled.txt
> new file mode 100644
> index 0000000..313abef
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/gpio-keys-polled.txt
> @@ -0,0 +1,38 @@
> +Device-Tree bindings for input/gpio_keys_polled.c keyboard driver
> +
> +Required properties:
> +       - compatible = "gpio-keys-polled";
> +       - poll-interval: Poll interval time in milliseconds
> +
> +Optional properties:
> +       - autorepeat: Boolean, Enable auto repeat feature of Linux input
> +         subsystem.
> +
> +Each button (key) is represented as a sub-node of "gpio-keys-polled":
> +Subnode properties:
> +
> +       - gpios: OF device-tree gpio specification.
> +       - label: Descriptive name of the key.
> +       - linux,code: Keycode to emit.
> +
> +Optional subnode-properties:
> +       - linux,input-type: Specify event type this button/key generates.
> +         If not specified defaults to <1> == EV_KEY.
> +       - debounce-interval: Debouncing interval time in milliseconds.
> +         If not specified defaults to 5.
> +       - gpio-key,wakeup: Boolean, button can wake-up the system.
> +
> +Example nodes:
> +
> +       gpio_keys_polled {
> +                       compatible = "gpio-keys-polled";
> +                       #address-cells = <1>;
> +                       #size-cells = <0>;
> +                       poll-interval = <100>;
> +                       autorepeat;
> +                       button@21 {
> +                               label = "GPIO Key UP";
> +                               linux,code = <103>;
> +                               gpios = <&gpio1 0 1>;
> +                       };
> +                       ...
> diff --git a/drivers/input/keyboard/gpio_keys_polled.c b/drivers/input/keyboard/gpio_keys_polled.c
> index 2619297..5a8856e6 100644
> --- a/drivers/input/keyboard/gpio_keys_polled.c
> +++ b/drivers/input/keyboard/gpio_keys_polled.c
> @@ -25,6 +25,8 @@
>  #include <linux/platform_device.h>
>  #include <linux/gpio.h>
>  #include <linux/gpio_keys.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_gpio.h>
>
>  #define DRV_NAME       "gpio-keys-polled"
>
> @@ -100,6 +102,96 @@ static void gpio_keys_polled_close(struct input_polled_dev *dev)
>                 pdata->disable(bdev->dev);
>  }
>
> +#ifdef CONFIG_OF
> +static struct gpio_keys_platform_data * __devinit
> +gpio_keys_polled_get_devtree_pdata(struct device *dev)
> +{
> +       struct device_node *node, *pp;
> +       struct gpio_keys_platform_data *pdata;
> +       struct gpio_keys_button *button;
> +       int error;
> +       int nbuttons;
> +       int i;
> +
> +       node = dev->of_node;
> +       if (!node) {
> +               error = -ENODEV;
> +               goto err_out;
> +       }
> +
> +       nbuttons = of_get_child_count(node);
> +       if (nbuttons == 0) {
> +               error = -ENODEV;
> +               goto err_out;
> +       }
> +
> +       pdata = kzalloc(sizeof(*pdata) + nbuttons * (sizeof *button),
> +                       GFP_KERNEL);
> +       if (!pdata) {
> +               error = -ENOMEM;
> +               goto err_out;
> +       }
> +
> +       pdata->rep = !!of_get_property(node, "autorepeat", NULL);
> +       of_property_read_u32(node, "poll-interval", &pdata->poll_interval);
> +
> +       i = 0;
> +       for_each_child_of_node(node, pp) {
> +               enum of_gpio_flags flags;
> +
> +               if (!of_find_property(pp, "gpios", NULL)) {
> +                       pdata->nbuttons--;
> +                       dev_warn(dev, "Found button without gpios\n");
> +                       continue;
> +               }
> +
> +               button = &pdata->buttons[i++];
> +
> +               button->gpio = of_get_gpio_flags(pp, 0, &flags);
> +               button->active_low = flags & OF_GPIO_ACTIVE_LOW;
> +
> +               if (of_property_read_u32(pp, "linux,code", &button->code)) {
> +                       dev_err(dev, "Button without keycode: 0x%x\n",
> +                               button->gpio);
> +                       error = -EINVAL;
> +                       goto err_free_pdata;
> +               }
> +
> +               button->desc = of_get_property(pp, "label", NULL);
> +
> +               if (of_property_read_u32(pp, "linux,input-type", &button->type))
> +                       button->type = EV_KEY;
> +
> +               button->wakeup = !!of_get_property(pp, "gpio-key,wakeup", NULL);
> +
> +               if (of_property_read_u32(pp, "debounce-interval",
> +                                        &button->debounce_interval))
> +                       button->debounce_interval = 5;
> +       }
> +
> +       return pdata;
> +
> +err_free_pdata:
> +       kfree(pdata);
> +err_out:
> +       return ERR_PTR(error);
> +}
> +
> +static struct of_device_id gpio_keys_polled_of_match[] = {
> +       { .compatible = "gpio-keys-polled", },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, gpio_keys_polled_of_match);
> +
> +#else
> +
> +static inline struct gpio_keys_platform_data *
> +gpio_keys_polled_get_devtree_pdata(struct device *dev)
> +{
> +       return ERR_PTR(-ENODEV);
> +}
> +#endif
> +
>  static int __devinit gpio_keys_polled_probe(struct platform_device *pdev)
>  {
>         struct device *dev = &pdev->dev;
> @@ -110,15 +202,24 @@ static int __devinit gpio_keys_polled_probe(struct platform_device *pdev)
>         int error;
>         int i;
>
> -       if (!pdata || !pdata->poll_interval)
> -               return -EINVAL;
> +       if (!pdata) {
> +               pdata = gpio_keys_polled_get_devtree_pdata(dev);
> +               if (IS_ERR(pdata))
> +                       return PTR_ERR(pdata);
> +       }
> +
> +       if (!pdata->poll_interval) {
> +               error = -EINVAL;
> +               goto err_free_pdata;
> +       }
>
>         bdev = kzalloc(sizeof(struct gpio_keys_polled_dev) +
>                        pdata->nbuttons * sizeof(struct gpio_keys_button_data),
>                        GFP_KERNEL);
>         if (!bdev) {
>                 dev_err(dev, "no memory for private data\n");
> -               return -ENOMEM;
> +               error = -ENOMEM;
> +               goto err_free_pdata;
>         }
>
>         poll_dev = input_allocate_polled_device();
> @@ -197,7 +298,7 @@ static int __devinit gpio_keys_polled_probe(struct platform_device *pdev)
>         /* report initial state of the buttons */
>         for (i = 0; i < pdata->nbuttons; i++)
>                 gpio_keys_polled_check_state(input, &pdata->buttons[i],
> -                                        &bdev->data[i]);
> +                                            &bdev->data[i]);
>
>         return 0;
>
> @@ -209,8 +310,13 @@ err_free_gpio:
>
>  err_free_bdev:
>         kfree(bdev);
> -
>         platform_set_drvdata(pdev, NULL);
> +
> +err_free_pdata:
> +       /* If we have no platform_data, we allocated pdata dynamically.  */
> +       if (!dev_get_platdata(&pdev->dev))
> +               kfree(pdata);
> +
>         return error;
>  }
>
> @@ -227,6 +333,13 @@ static int __devexit gpio_keys_polled_remove(struct platform_device *pdev)
>
>         input_free_polled_device(bdev->poll_dev);
>
> +       /*
> +        * If we had no platform_data, we allocated pdata dynamically and
> +        * must free it here.
> +        */
> +       if (!dev_get_platdata(&pdev->dev))
> +               kfree(pdata);
> +
>         kfree(bdev);
>         platform_set_drvdata(pdev, NULL);
>
> @@ -239,6 +352,7 @@ static struct platform_driver gpio_keys_polled_driver = {
>         .driver = {
>                 .name   = DRV_NAME,
>                 .owner  = THIS_MODULE,
> +               .of_match_table = of_match_ptr(gpio_keys_polled_of_match),
>         },
>  };
>  module_platform_driver(gpio_keys_polled_driver);
