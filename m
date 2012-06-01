Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab2FAJsF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:48:05 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:59964 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754448Ab2FAJsB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:48:01 -0400
MIME-Version: 1.0
In-Reply-To: <1337781350-1411-1-git-send-email-sourav.poddar@ti.com>
References: <1337781350-1411-1-git-send-email-sourav.poddar@ti.com>
Date: Fri, 1 Jun 2012 15:17:58 +0530
Message-ID: <CAKdam559t0tFTZuRq8Ese0hULrtMRTaqUvSMb=rPUtdJunKQzw@mail.gmail.com>
Subject: Re: [PATCHv5 1/2] drivers: input: keypad: Add device tree support
From: "Poddar, Sourav" <sourav.poddar@ti.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, sourav.poddar@ti.com,
        Benoit Cousson <b-cousson@ti.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Dmitry Torokhov <dtor@mail.ru>, Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Gentle ping on this..

~Sourav
On Wed, May 23, 2012 at 7:25 PM, Sourav Poddar <sourav.poddar@ti.com> wrote:
> Update the Documentation with omap4 keypad device tree
> binding information.
> Add device tree support for omap4 keypad driver.
>
> Tested on omap4430 sdp.
>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ---
> changes since v4:
> - Developed it on top of dmitry's 'next' branch due to
> dependency on generic "matrix_keypad_build_keymap" api
> patches queued in that branch
> - Adapted the driver to fill "keymap" in device tree
> using "matrix_keypad_build_keymap" api defined in
> drivers/input/matrix-keymap.c
>  .../devicetree/bindings/input/omap-keypad.txt      |   31 ++++++
>  drivers/input/keyboard/omap4-keypad.c              |  108 +++++++++++++++-----
>  2 files changed, 111 insertions(+), 28 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/input/omap-keypad.txt
>
> diff --git a/Documentation/devicetree/bindings/input/omap-keypad.txt b/Documentation/devicetree/bindings/input/omap-keypad.txt
> new file mode 100644
> index 0000000..722425b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/omap-keypad.txt
> @@ -0,0 +1,31 @@
> +* TI's Keypad Controller device tree bindings
> +
> +TI's Keypad controller is used to interface a SoC with a matrix-type
> +keypad device. The keypad controller supports multiple row and column lines.
> +A key can be placed at each intersection of a unique row and a unique column.
> +The keypad controller can sense a key-press and key-release and report the
> +event using a interrupt to the cpu.
> +
> +Required SoC Specific Properties:
> +- compatible: should be one of the following
> +   - "ti,omap4-keypad": For controllers compatible with omap4 keypad
> +      controller.
> +
> +Required Board Specific Properties, in addition to those specified by
> +the shared matrix-keyboard bindings:
> +- keypad,num-rows: Number of row lines connected to the keypad
> +  controller.
> +
> +- keypad,num-columns: Number of column lines connected to the
> +  keypad controller.
> +
> +Optional Properties specific to linux:
> +- linux,keypad-no-autorepeat: do no enable autorepeat feature.
> +
> +Example:
> +        keypad@4ae1c000{
> +                compatible = "ti,omap4-keypad";
> +                keypad,num-rows = <2>;
> +                keypad,num-columns = <8>;
> +               linux,keypad-no-autorepeat;
> +       };
> diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboard/omap4-keypad.c
> index aed5f69..d5a2d1a 100644
> --- a/drivers/input/keyboard/omap4-keypad.c
> +++ b/drivers/input/keyboard/omap4-keypad.c
> @@ -27,6 +27,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/errno.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
>  #include <linux/input.h>
>  #include <linux/slab.h>
>  #include <linux/pm_runtime.h>
> @@ -75,6 +76,7 @@ enum {
>
>  struct omap4_keypad {
>        struct input_dev *input;
> +       struct matrix_keymap_data *keymap_data;
>
>        void __iomem *base;
>        unsigned int irq;
> @@ -84,6 +86,7 @@ struct omap4_keypad {
>        u32 reg_offset;
>        u32 irqreg_offset;
>        unsigned int row_shift;
> +       bool no_autorepeat;
>        unsigned char key_state[8];
>        unsigned short keymap[];
>  };
> @@ -208,25 +211,74 @@ static void omap4_keypad_close(struct input_dev *input)
>        pm_runtime_put_sync(input->dev.parent);
>  }
>
> +static struct omap4_keypad *omap_keypad_parse_dt(struct device *dev,
> +                               uint32_t rows, uint32_t cols,
> +                               struct input_dev *input_dev)
> +{
> +       struct device_node *np = dev->of_node;
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct omap4_keypad *keypad_data = platform_get_drvdata(pdev);
> +       int error;
> +
> +       error = matrix_keypad_build_keymap(NULL, "linux,keymap",
> +                               rows, cols, keypad_data->keymap, input_dev);
> +       if (error) {
> +               dev_err(&pdev->dev, "failed to build keymap\n");
> +               input_free_device(input_dev);
> +       }
> +
> +       if (of_get_property(np, "linux,input-no-autorepeat", NULL))
> +               keypad_data->no_autorepeat = true;
> +
> +       return keypad_data;
> +}
> +
>  static int __devinit omap4_keypad_probe(struct platform_device *pdev)
>  {
> +       struct device *dev = &pdev->dev;
> +       struct device_node *np = dev->of_node;
>        const struct omap4_keypad_platform_data *pdata;
>        struct omap4_keypad *keypad_data;
>        struct input_dev *input_dev;
>        struct resource *res;
>        resource_size_t size;
> -       unsigned int row_shift, max_keys;
> +       unsigned int row_shift = 0, max_keys = 0;
> +       uint32_t num_rows = 0, num_cols = 0;
>        int rev;
>        int irq;
>        int error;
>
>        /* platform data */
>        pdata = pdev->dev.platform_data;
> -       if (!pdata) {
> +       if (np) {
> +               of_property_read_u32(np, "keypad,num-rows", &num_rows);
> +               of_property_read_u32(np, "keypad,num-columns", &num_cols);
> +               if (!num_rows || !num_cols) {
> +                       dev_err(&pdev->dev, "number of keypad rows/columns not specified\n");
> +                       return -EINVAL;
> +               }
> +       } else if (pdata) {
> +               num_rows = pdata->rows;
> +               num_cols = pdata->cols;
> +       } else {
>                dev_err(&pdev->dev, "no platform data defined\n");
>                return -EINVAL;
>        }
>
> +       row_shift = get_count_order(num_cols);
> +       max_keys = num_rows << row_shift;
> +
> +       keypad_data = devm_kzalloc(dev, sizeof(struct omap4_keypad) +
> +                       max_keys * sizeof(keypad_data->keymap[0]),
> +                               GFP_KERNEL);
> +
> +       if (!keypad_data) {
> +               dev_err(&pdev->dev, "keypad_data memory allocation failed\n");
> +               return -ENOMEM;
> +       }
> +
> +       platform_set_drvdata(pdev, keypad_data);
> +
>        res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>        if (!res) {
>                dev_err(&pdev->dev, "no base address specified\n");
> @@ -239,22 +291,6 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
>                return -EINVAL;
>        }
>
> -       if (!pdata->keymap_data) {
> -               dev_err(&pdev->dev, "no keymap data defined\n");
> -               return -EINVAL;
> -       }
> -
> -       row_shift = get_count_order(pdata->cols);
> -       max_keys = pdata->rows << row_shift;
> -
> -       keypad_data = kzalloc(sizeof(struct omap4_keypad) +
> -                               max_keys * sizeof(keypad_data->keymap[0]),
> -                             GFP_KERNEL);
> -       if (!keypad_data) {
> -               dev_err(&pdev->dev, "keypad_data memory allocation failed\n");
> -               return -ENOMEM;
> -       }
> -
>        size = resource_size(res);
>
>        res = request_mem_region(res->start, size, pdev->name);
> @@ -271,10 +307,10 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
>                goto err_release_mem;
>        }
>
> +       keypad_data->rows = num_rows;
> +       keypad_data->cols = num_cols;
>        keypad_data->irq = irq;
>        keypad_data->row_shift = row_shift;
> -       keypad_data->rows = pdata->rows;
> -       keypad_data->cols = pdata->cols;
>
>        /*
>        * Enable clocks for the keypad module so that we can read
> @@ -322,15 +358,25 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
>        input_dev->open = omap4_keypad_open;
>        input_dev->close = omap4_keypad_close;
>
> -       error = matrix_keypad_build_keymap(pdata->keymap_data, NULL,
> -                                          pdata->rows, pdata->cols,
> -                                          keypad_data->keymap, input_dev);
> -       if (error) {
> -               dev_err(&pdev->dev, "failed to build keymap\n");
> -               goto err_free_input;
> +       if (np) {
> +               keypad_data = omap_keypad_parse_dt(&pdev->dev,
> +                               keypad_data->rows, keypad_data->cols,
> +                               input_dev);
> +       } else {
> +               keypad_data->keymap_data =
> +                       (struct matrix_keymap_data *)pdata->keymap_data;
> +               error = matrix_keypad_build_keymap(keypad_data->keymap_data,
> +                               NULL, keypad_data->rows, keypad_data->cols,
> +                               keypad_data->keymap, input_dev);
> +               if (error) {
> +                       dev_err(&pdev->dev, "failed to build keymap\n");
> +                       goto err_free_input;
> +               }
>        }
>
> -       __set_bit(EV_REP, input_dev->evbit);
> +       if (!keypad_data->no_autorepeat)
> +               __set_bit(EV_REP, input_dev->evbit);
> +
>        input_set_capability(input_dev, EV_MSC, MSC_SCAN);
>
>        input_set_drvdata(input_dev, keypad_data);
> @@ -351,7 +397,6 @@ static int __devinit omap4_keypad_probe(struct platform_device *pdev)
>                goto err_pm_disable;
>        }
>
> -       platform_set_drvdata(pdev, keypad_data);
>        return 0;
>
>  err_pm_disable:
> @@ -392,12 +437,19 @@ static int __devexit omap4_keypad_remove(struct platform_device *pdev)
>        return 0;
>  }
>
> +static const struct of_device_id omap_keypad_dt_match[] = {
> +       { .compatible = "ti,omap4-keypad" },
> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, omap_keypad_dt_match);
> +
>  static struct platform_driver omap4_keypad_driver = {
>        .probe          = omap4_keypad_probe,
>        .remove         = __devexit_p(omap4_keypad_remove),
>        .driver         = {
>                .name   = "omap4-keypad",
>                .owner  = THIS_MODULE,
> +               .of_match_table = of_match_ptr(omap_keypad_dt_match),
>        },
>  };
>  module_platform_driver(omap4_keypad_driver);
> --
> 1.7.1
>
