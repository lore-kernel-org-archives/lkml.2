Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2FTGcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 02:32:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55960 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab2FTGcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 02:32:53 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1340169088-4401-2-git-send-email-gshark.jeong@gmail.com>
References: <1340169088-4401-1-git-send-email-gshark.jeong@gmail.com> <1340169088-4401-2-git-send-email-gshark.jeong@gmail.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 20 Jun 2012 14:32:32 +0800
Message-ID: <CAF+7xWks9G297rCk_q6W3VLdHVNVresTYCHz2GOjNDP9eLa3sw@mail.gmail.com>
Subject: Re: [PATCH 1/1 v3] leds: Add LED driver for lm3556 chip
To: "G.Shark Jeong" <gshark.jeong@gmail.com>
Cc: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>,
        Daniel Jeong <daniel.jeong@ti.com>, linux-kernel@vger.kernel.org,
        milo kim <milo.kim@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config LEDS_LM3556
> +       tristate "LED support for LM3556 Chip"
> +       depends on LEDS_CLASS && I2C

select REGMAP_I2C

> +       help
> +         This option enables support for LEDs connected LM3556.
> +         LM3556 includes Torch, Flash and Indicator functions.
> +

> +/* chip initialize */
> +static int lm3556_chip_init(struct lm3556_chip_data *chip)

__devinit



> +/* torch */
> +static void lm3556_torch_brightness_set(struct led_classdev *cdev,
> +                                       enum led_brightness brightness)
> +{
> +       struct lm3556_chip_data *chip =
> +           container_of(cdev, struct lm3556_chip_data, cdev_torch);
> +
> +       mutex_lock(&chip->lock);
> +       lm3556_control(chip, brightness, MODES_TORCH);
> +       mutex_unlock(&chip->lock);
> +       return;
            ^^^^^^ you don't need this return!!
> +}
> +
> +/* flash */
> +static void lm3556_strobe_brightness_set(struct led_classdev *cdev,
> +                                        enum led_brightness brightness)
> +{
> +       struct lm3556_chip_data *chip =
> +           container_of(cdev, struct lm3556_chip_data, cdev_flash);
> +
> +       mutex_lock(&chip->lock);
> +       lm3556_control(chip, brightness, MODES_FLASH);
> +       mutex_unlock(&chip->lock);
> +       return;
            ^^^^^^ you don't need this return!!
> +}
> +
> +/* indicator */
> +static void lm3556_indicator_brightness_set(struct led_classdev *cdev,
> +                                           enum led_brightness brightness)
> +{
> +       struct lm3556_chip_data *chip =
> +           container_of(cdev, struct lm3556_chip_data, cdev_indicator);
> +
> +       mutex_lock(&chip->lock);
> +       lm3556_control(chip, brightness, MODES_INDIC);
> +       mutex_unlock(&chip->lock);
> +       return;
            ^^^^^^ you don't need this return!!
> +}
> +

> +/* module initialize */
> +static int lm3556_probe(struct i2c_client *client,
> +                       const struct i2c_device_id *id)
__devinit
> +{
> +       struct lm3556_platform_data *pdata = client->dev.platform_data;
> +       struct lm3556_chip_data *chip;
> +
> +       int err;
> +
> +       if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +               dev_err(&client->dev, "i2c functionality check fail.\n");
> +               return -EOPNOTSUPP;
> +       }
> +
> +       if (pdata == NULL) {
> +               dev_err(&client->dev, "Needs Platform Data.\n");
> +               return -ENODATA;
> +       }
> +
> +       chip =
> +           devm_kzalloc(&client->dev, sizeof(struct lm3556_chip_data),
> +                        GFP_KERNEL);
> +       if (!chip)
> +               return -ENOMEM;
> +
> +       chip->client = client;
> +       chip->pdata = pdata;
> +
> +       chip->regmap = regmap_init_i2c(client, &lm3556_regmap);
devm_regmap_init_i2c

> +       if (IS_ERR(chip->regmap)) {
> +               err = PTR_ERR(chip->regmap);
> +               dev_err(&client->dev, "Failed to allocate register map: %d\n",
> +                       err);
> +               return err;
> +       }
> +
> +       mutex_init(&chip->lock);
> +       i2c_set_clientdata(client, chip);
> +
> +       err = lm3556_chip_init(chip);
> +       if (err < 0)
> +               goto err_chip_init;
> +
> +       /* flash */
> +       chip->cdev_flash.name = "flash";
> +       chip->cdev_flash.max_brightness = 16;
> +       chip->cdev_flash.brightness_set = lm3556_strobe_brightness_set;
> +       err = led_classdev_register((struct device *)
> +                                   &client->dev, &chip->cdev_flash);
> +       if (err < 0)
> +               goto err_create_flash_file;
> +       /* torch */
> +       chip->cdev_torch.name = "torch";
> +       chip->cdev_torch.max_brightness = 8;
> +       chip->cdev_torch.brightness_set = lm3556_torch_brightness_set;
> +       err = led_classdev_register((struct device *)
> +                                   &client->dev, &chip->cdev_torch);
> +       if (err < 0)
> +               goto err_create_torch_file;
> +       /* indicator */
> +       chip->cdev_indicator.name = "indicator";
> +       chip->cdev_indicator.max_brightness = 8;
> +       chip->cdev_indicator.brightness_set = lm3556_indicator_brightness_set;
> +       err = led_classdev_register((struct device *)
> +                                   &client->dev, &chip->cdev_indicator);
> +       if (err < 0)
> +               goto err_create_indicator_file;
> +
> +       err = device_create_file(chip->cdev_indicator.dev, &dev_attr_pattern);
> +       if (err < 0)
> +               goto err_create_pattern_file;
> +
> +       dev_info(&client->dev, "LM3556 is initialized\n");
> +       return 0;
> +
> +err_create_pattern_file:
> +       led_classdev_unregister(&chip->cdev_indicator);
> +err_create_indicator_file:
> +       led_classdev_unregister(&chip->cdev_torch);
> +err_create_torch_file:
> +       led_classdev_unregister(&chip->cdev_flash);
> +err_create_flash_file:
> +err_chip_init:
> +       i2c_set_clientdata(client, NULL);
No need to set this to NULL, it is done by i2c core.

> +       return err;
> +}
> +
> +static int lm3556_remove(struct i2c_client *client)
__devexit

> +{
> +       struct lm3556_chip_data *chip = i2c_get_clientdata(client);
> +
> +       device_remove_file(chip->cdev_indicator.dev, &dev_attr_pattern);
> +       led_classdev_unregister(&chip->cdev_indicator);
> +       led_classdev_unregister(&chip->cdev_torch);
> +       led_classdev_unregister(&chip->cdev_flash);
> +       regmap_write(chip->regmap, REG_ENABLE, 0);
> +       regmap_exit(chip->regmap);
If you are using devm_regmap_init_i2c, you don't need regmap_exit call here.

> +       return 0;
> +}
> +
> +static const struct i2c_device_id lm3556_id[] = {
> +       {LM3556_NAME, 0},
> +       {}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, lm3556_id);
> +
> +static struct i2c_driver lm3556_i2c_driver = {
> +       .driver = {
> +                  .name = LM3556_NAME,
> +                  .owner = THIS_MODULE,
> +                  .pm = NULL,
> +                  },
> +       .probe = lm3556_probe,
> +       .remove = __devexit_p(lm3556_remove),
> +       .id_table = lm3556_id,
> +};
> +
> +static int __init lm3556_init(void)
> +{
> +       return i2c_add_driver(&lm3556_i2c_driver);
> +}
> +
> +static void __exit lm3556_exit(void)
> +{
> +       i2c_del_driver(&lm3556_i2c_driver);
> +}
> +
> +module_init(lm3556_init);
> +module_exit(lm3556_exit);

module_i2c_driver(lm3556_i2c_driver);
