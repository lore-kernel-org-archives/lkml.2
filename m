Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab2JXHxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 03:53:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35211 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757956Ab2JXHxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 03:53:08 -0400
MIME-Version: 1.0
In-Reply-To: <201210231724.33927.poeschel@lemonage.de>
References: <20120925085559.GL28670@sortiz-mobl>
	<201210161538.29571.poeschel@lemonage.de>
	<CACRpkdauWR-ndvPA4Q5k_boh1OvYpPWMcfSkCdvRTK9wjHLo3Q@mail.gmail.com>
	<201210231724.33927.poeschel@lemonage.de>
Date: Wed, 24 Oct 2012 09:53:06 +0200
Message-ID: <CACRpkdZ3=VFOHqmo=XbyDGUKoxFaG+PpzDUsBQTQ1O3F-DhTvg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] gpio: add viperboard gpio driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars Poeschel <poeschel@lemonage.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, khali@linux-fr.org,
        ben-linux@fluff.org, w.sang@pengutronix.de, grant.likely@secretlab.ca
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 5:24 PM, Lars Poeschel <poeschel@lemonage.de> wrote:
> On Tuesday 16 October 2012 at 19:11:10, Linus Walleij wrote:
>> On Tue, Oct 16, 2012 at 3:38 PM, Lars Poeschel <poeschel@lemonage.de> wrote:
>> > I had a look at regmap. This is interesting. But there is no regmap_bus
>> > implementation for usb. Are you pointing me in this direction ? ;-)
>>
>> I was more thinking about whether it would be useful to use for this
>> MFD hub. So that for this MFD and it's children, you would use
>> regmap to:
>>
>> 1) Cache registers
>> 2) Marshall the register read/writes across USB
>>
>> I don't think it would be applicable for USB, as reading & writing
>> registers across USB is a pretty odd usecase. (IIRC using control
>> transfers
>> right?)
>
> Yes, right.
>
>> > And it is not guaranteed, that this "address" and "value"
>> > are at the same position for other usb adapters. And this is getting even
>> > worse, if I think of reading values out of the viperboard...
>>
>> I was mainly thinking about the Viperboard MFD complex.
>
> Ok, I tried to implement it (at least for the gpioa part of the driver).
> It does not work. I got stuck. There are three problems I could not solve:

So I'm looping in Mark Brown to get some hints whether the following
can be resolved easily or needs to be given up on...

> To be able to use the caching, I have to implement a volatile_reg function. I
> have to do this, because caching can only happen, when the gpio pin is an
> output. If it is an input, I want to read the pin - caching has to be turned
> off. So in my vprbrd_volatile_reg function I have to check if a pin is set to
> output and return false or true. I can not query a regmap register inside that
> function if a pin is an output or not, this would deadlock, because there is
> a mutex lock inside regmap, so I have to cache this outside of regmap.
> This is a bit strange, to use the cache, setup another own cache. (1st
> problem)
> I chose my per device structure struct vprbrd_gpio to hold this cache, but I
> can not reach it. You see in the patch, I try to container_of up to my
> structure. This does not work, because struct regmap is not public available.
> (2nd problem)

The idea is that regmap is self-contained. If you need to change
it's semantics the place to patch is in regmap itself.

> Setting the direction to output is an atomic set direction and set value.
> The register number is different from setting the value only. So after a
> successful call, I want to update the cache of output value using
> regcache_write. This is also not publicy available api. The only thing I could
> do is invalidate the whole cache using regcache_mark_dirty. (3rd problem)

Same thing.

> I attach my current working state here. This is NOT WORKING and only as
> reference.

So if you want to do this with regmap, I suggest the way forward would
be to go solve it at the root by implementing something like
drivers/base/regmap/regmap-usb-ctrl.c with your desired semantics
and using that.

However I *do* understand that requesting this may be a bit thick,
so I'm happy to accept the older patch with custom caching
now.

> Regards,
> Lars
> ---
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index 8382dc8..48be4ba 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -636,4 +636,17 @@ config GPIO_MSIC
>           Enable support for GPIO on intel MSIC controllers found in
>           intel MID devices
>
> +comment "USB GPIO expanders:"
> +
> +config GPIO_VIPERBOARD
> +       tristate "Viperboard GPIO a & b support"
> +       depends on MFD_VIPERBOARD && USB
> +       help
> +         Say yes here to access the GPIO signals of Nano River
> +         Technologies Viperboard. There are two GPIO chips on the
> +         board: gpioa and gpiob.
> +          See viperboard API specification and Nano
> +          River Tech's viperboard.h for detailed meaning
> +          of the module parameters.
> +
>  endif
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 0ffaa84..71cc896 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -69,6 +69,7 @@ obj-$(CONFIG_GPIO_TPS65910)   += gpio-tps65910.o
>  obj-$(CONFIG_GPIO_TPS65912)    += gpio-tps65912.o
>  obj-$(CONFIG_GPIO_TWL4030)     += gpio-twl4030.o
>  obj-$(CONFIG_GPIO_UCB1400)     += gpio-ucb1400.o
> +obj-$(CONFIG_GPIO_VIPERBOARD)  += gpio-viperboard.o
>  obj-$(CONFIG_GPIO_VR41XX)      += gpio-vr41xx.o
>  obj-$(CONFIG_GPIO_VT8500)      += gpio-vt8500.o
>  obj-$(CONFIG_GPIO_VX855)       += gpio-vx855.o
> diff --git a/drivers/gpio/gpio-viperboard.c b/drivers/gpio/gpio-viperboard.c
> new file mode 100644
> index 0000000..2dc6c9f
> --- /dev/null
> +++ b/drivers/gpio/gpio-viperboard.c
> @@ -0,0 +1,618 @@
> +/*
> + *  Nano River Technologies viperboard GPIO lib driver
> + *
> + *  (C) 2012 by Lemonage GmbH
> + *  Author: Lars Poeschel <poeschel@lemonage.de>
> + *  All rights reserved.
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/mutex.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +
> +#include <linux/usb.h>
> +#include <linux/gpio.h>
> +
> +#include <linux/mfd/viperboard.h>
> +
> +#define VPRBRD_GPIOA_CLK_1MHZ          0
> +#define VPRBRD_GPIOA_CLK_100KHZ                1
> +#define VPRBRD_GPIOA_CLK_10KHZ         2
> +#define VPRBRD_GPIOA_CLK_1KHZ          3
> +#define VPRBRD_GPIOA_CLK_100HZ         4
> +#define VPRBRD_GPIOA_CLK_10HZ          5
> +
> +#define VPRBRD_GPIOA_FREQ_DEFAULT      1000
> +
> +#define VPRBRD_GPIOA_CMD_CONT          0x00
> +#define VPRBRD_GPIOA_CMD_PULSE         0x01
> +#define VPRBRD_GPIOA_CMD_PWM           0x02
> +#define VPRBRD_GPIOA_CMD_SETOUT                0x03
> +#define VPRBRD_GPIOA_CMD_SETIN         0x04
> +#define VPRBRD_GPIOA_CMD_SETINT                0x05
> +#define VPRBRD_GPIOA_CMD_GETIN         0x06
> +
> +#define VPRBRD_GPIOB_CMD_SETDIR                0x00
> +#define VPRBRD_GPIOB_CMD_SETVAL                0x01
> +
> +#define VPRBRD_GPIOA_NUM_PINS          16
> +#define VPRBRD_GPIOA_REG_VAL_BASE      0
> +#define VPRBRD_GPIOA_REG_VAL_MAX       (1 * VPRBRD_GPIOA_NUM_PINS - 1)
> +#define VPRBRD_GPIOA_REG_DIR_BASE      (VPRBRD_GPIOA_REG_VAL_MAX + 1)
> +#define VPRBRD_GPIOA_REG_DIR_MAX       (2 * VPRBRD_GPIOA_NUM_PINS - 1)
> +#define VPRBRD_GPIOA_NUM_REGS          (VPRBRD_GPIOA_REG_DIR_MAX + 1)
> +
> +struct vprbrd_gpioa_msg {
> +       u8 cmd;
> +       u8 clk;
> +       u8 offset;
> +       u8 t1;
> +       u8 t2;
> +       u8 invert;
> +       u8 pwmlevel;
> +       u8 outval;
> +       u8 risefall;
> +       u8 answer;
> +       u8 __fill;
> +} __packed;
> +
> +struct vprbrd_gpiob_msg {
> +       u8 cmd;
> +       u16 val;
> +       u16 mask;
> +} __packed;
> +
> +struct vprbrd_gpio {
> +       struct gpio_chip gpioa; /* gpio a related things */
> +       u32 gpioa_out;
> +       u32 gpioa_val;
> +       struct gpio_chip gpiob; /* gpio b related things */
> +       u32 gpiob_out;
> +       u32 gpiob_val;
> +       struct vprbrd *vb;
> +       struct regmap *regmap;
> +};
> +
> +/* gpioa sampling clock module parameter */
> +static unsigned char gpioa_clk;
> +static unsigned int gpioa_freq = VPRBRD_GPIOA_FREQ_DEFAULT;
> +module_param(gpioa_freq, uint, 0);
> +MODULE_PARM_DESC(gpioa_freq, "gpio a sampling freq in Hz (default is 1000Hz)"
> +       "valid values: 10, 100, 1000, 10000, 100000, 1000000");
> +
> +/* ----- begin of gipo a chip -------------------------------------------- */
> +
> +static int regmap_vb_gpio_write(void *context, const void *data, size_t count)
> +{
> +       struct vprbrd *vb = (struct vprbrd *)context;
> +       struct vprbrd_gpioa_msg *gamsg = (struct vprbrd_gpioa_msg *)vb->buf;
> +       int ret;
> +       const u8 reg = ((const u8 *)data)[0];
> +       const u8 val = ((const u8 *)data)[1];
> +
> +       dev_dbg(&vb->pdev.dev, "%s count:%i reg:%i, val:%i\n", __FUNCTION__, count, reg, val);
> +
> +       if (count != 2)
> +               return -ENOTSUPP;
> +
> +       mutex_lock(&vb->lock);
> +
> +       gamsg->clk = 0x00;
> +       gamsg->t1 = 0x00;
> +       gamsg->t2 = 0x00;
> +       gamsg->invert = 0x00;
> +       gamsg->pwmlevel = 0x00;
> +       gamsg->outval = val;
> +       gamsg->risefall = 0x00;
> +       gamsg->answer = 0x00;
> +       gamsg->__fill = 0x00;
> +
> +       if (reg >= VPRBRD_GPIOA_REG_VAL_BASE &&
> +                       reg <= VPRBRD_GPIOA_REG_VAL_MAX) {
> +               gamsg->cmd = VPRBRD_GPIOA_CMD_SETOUT;
> +               gamsg->offset = reg;
> +               gamsg->outval = val;
> +       } else if (reg >= VPRBRD_GPIOA_REG_DIR_BASE &&
> +                       reg <= VPRBRD_GPIOA_REG_DIR_MAX) {
> +               gamsg->offset = reg - VPRBRD_GPIOA_REG_DIR_BASE;
> +               if (val > 0) {
> +                       gamsg->cmd = VPRBRD_GPIOA_CMD_SETIN;
> +                       gamsg->clk = gpioa_clk;
> +               } else {
> +                       gamsg->cmd = VPRBRD_GPIOA_CMD_SETOUT;
> +               }
> +       }
> +       ret = usb_control_msg(vb->usb_dev, usb_sndctrlpipe(vb->usb_dev, 0),
> +               VPRBRD_USB_REQUEST_GPIOA, VPRBRD_USB_TYPE_OUT, 0x0000,
> +               0x0000, gamsg, sizeof(struct vprbrd_gpioa_msg),
> +               VPRBRD_USB_TIMEOUT_MS);
> +
> +       mutex_unlock(&vb->lock);
> +
> +       if (ret != sizeof(struct vprbrd_gpioa_msg))
> +               return -EREMOTEIO;
> +
> +       return 0;
> +}
> +
> +static int regmap_vb_gpio_read(void *context, const void *reg_buf,
> +       size_t reg_size, void *val_buf, size_t val_size)
> +{
> +       struct vprbrd *vb = (struct vprbrd *)context;
> +       struct vprbrd_gpioa_msg *gamsg = (struct vprbrd_gpioa_msg *)vb->buf;
> +       int ret, error = 0;
> +       const u8 *reg8 = reg_buf;
> +
> +       dev_dbg(&vb->pdev.dev, "%s reg_size:%i val_size:%i\n", __FUNCTION__, reg_size, val_size);
> +
> +       if (val_size != 1 || reg_size != 1)
> +               return -ENOTSUPP;
> +
> +       mutex_lock(&vb->lock);
> +
> +       gamsg->cmd = VPRBRD_GPIOA_CMD_GETIN;
> +       gamsg->clk = 0x00;
> +       gamsg->offset = reg8[0];
> +       gamsg->t1 = 0x00;
> +       gamsg->t2 = 0x00;
> +       gamsg->invert = 0x00;
> +       gamsg->pwmlevel = 0x00;
> +       gamsg->outval = 0x00;
> +       gamsg->risefall = 0x00;
> +       gamsg->answer = 0x00;
> +       gamsg->__fill = 0x00;
> +
> +       ret = usb_control_msg(vb->usb_dev, usb_sndctrlpipe(vb->usb_dev, 0),
> +               VPRBRD_USB_REQUEST_GPIOA, VPRBRD_USB_TYPE_OUT, 0x0000,
> +               0x0000, gamsg, sizeof(struct vprbrd_gpioa_msg),
> +               VPRBRD_USB_TIMEOUT_MS);
> +       if (ret != sizeof(struct vprbrd_gpioa_msg))
> +               error = -EREMOTEIO;
> +
> +       ret = usb_control_msg(vb->usb_dev, usb_rcvctrlpipe(vb->usb_dev, 0),
> +               VPRBRD_USB_REQUEST_GPIOA, VPRBRD_USB_TYPE_IN, 0x0000,
> +               0x0000, gamsg, sizeof(struct vprbrd_gpioa_msg),
> +               VPRBRD_USB_TIMEOUT_MS);
> +       *(u8 *)val_buf = gamsg->answer & 0x01;
> +
> +       dev_dbg(&vb->pdev.dev, "%s gamsg->answer:%i val:%i\n", __FUNCTION__, gamsg->answer, *(u8 *)val_buf);
> +
> +       mutex_unlock(&vb->lock);
> +
> +       if (ret != sizeof(struct vprbrd_gpioa_msg))
> +               error = -EREMOTEIO;
> +
> +       if (error)
> +               return error;
> +
> +       return 0;
> +}
> +
> +static const struct regmap_bus regmap_vb_gpio = {
> +       .write = regmap_vb_gpio_write,
> +       .read = regmap_vb_gpio_read,
> +};
> +
> +static bool vprbrd_volatile_reg(struct device *device, unsigned int reg)
> +{
> +       struct regmap *regmap = container_of(device, struct regmap, dev);
> +       struct vprbrd_gpio *gpio =
> +                       container_of(regmap, struct vprbrd_gpio, regmap);
> +
> +       dev_dbg(device, "%s reg:%i\n", __FUNCTION__, reg);
> +
> +       /* if the pin is an output, we are not volatile and can cache */
> +       if (gpio->gpioa_out & (1 << reg))
> +               return false;
> +
> +       return true;
> +}
> +
> +static struct reg_default vprbrd_regdefaults[] = {
> +       {0x00, 0x00},   /* 0x00 - 0x0f pin values */
> +       {0x01, 0x00},
> +       {0x02, 0x00},
> +       {0x03, 0x00},
> +       {0x04, 0x00},
> +       {0x05, 0x00},
> +       {0x06, 0x00},
> +       {0x07, 0x00},
> +       {0x08, 0x00},
> +       {0x09, 0x00},
> +       {0x0a, 0x00},
> +       {0x0b, 0x00},
> +       {0x0c, 0x00},
> +       {0x0d, 0x00},
> +       {0x0e, 0x00},
> +       {0x0f, 0x00},
> +       {0x10, 0x00},   /* 0x10 - 0x1f pin direction */
> +       {0x11, 0x00},
> +       {0x12, 0x00},
> +       {0x13, 0x00},
> +       {0x14, 0x00},
> +       {0x15, 0x00},
> +       {0x16, 0x00},
> +       {0x17, 0x00},
> +       {0x18, 0x00},
> +       {0x19, 0x00},
> +       {0x1a, 0x00},
> +       {0x1b, 0x00},
> +       {0x1c, 0x00},
> +       {0x1d, 0x00},
> +       {0x1e, 0x00},
> +       {0x1f, 0x00},
> +};
> +
> +static const struct regmap_config vprbrd_regmap_config = {
> +       .name = "gpio_regmap",
> +       .reg_bits = 8,
> +       .val_bits = 8,
> +       .volatile_reg = vprbrd_volatile_reg,
> +       .max_register = VPRBRD_GPIOA_NUM_REGS,
> +       .reg_defaults = vprbrd_regdefaults,
> +       .num_reg_defaults = ARRAY_SIZE(vprbrd_regdefaults),
> +       .cache_type = REGCACHE_RBTREE,
> +};
> +
> +static int vprbrd_gpioa_get(struct gpio_chip *chip,
> +               unsigned offset)
> +{
> +       int ret;
> +       struct vprbrd_gpio *gpio =
> +                       container_of(chip, struct vprbrd_gpio, gpioa);
> +       unsigned int val;
> +
> +       ret = regmap_read(gpio->regmap, offset, &val);
> +
> +       dev_dbg(chip->dev, "%s offset:%i val:%x ret:%i\n", __FUNCTION__, offset, val, ret);
> +
> +       if (ret < 0)
> +               return ret;
> +       else
> +               return val;
> +}
> +
> +static void vprbrd_gpioa_set(struct gpio_chip *chip,
> +               unsigned offset, int value)
> +{
> +       int ret;
> +       struct vprbrd_gpio *gpio =
> +                       container_of(chip, struct vprbrd_gpio, gpioa);
> +
> +       dev_dbg(chip->dev, "%s offset:%i, value:%i\n", __FUNCTION__, offset, value);
> +
> +       ret = regmap_write(gpio->regmap, offset, value);
> +       if (ret < 0)
> +               dev_err(chip->dev, "usb error setting pin value\n");
> +}
> +
> +static int vprbrd_gpioa_direction_input(struct gpio_chip *chip,
> +                       unsigned offset)
> +{
> +       int ret;
> +       struct vprbrd_gpio *gpio =
> +                       container_of(chip, struct vprbrd_gpio, gpioa);
> +
> +       dev_dbg(chip->dev, "%s offset:%i\n", __FUNCTION__, offset);
> +
> +       ret = regmap_write(gpio->regmap,
> +               offset + VPRBRD_GPIOA_REG_DIR_BASE, 0);
> +
> +       if (ret < 0) {
> +               dev_err(chip->dev, "usb error setting pin to output\n");
> +               return ret;
> +       }
> +
> +       gpio->gpioa_out &= ~(1 << offset);
> +
> +       return 0;
> +}
> +
> +static int vprbrd_gpioa_direction_output(struct gpio_chip *chip,
> +                       unsigned offset, int value)
> +{
> +       int ret;
> +       struct vprbrd_gpio *gpio =
> +                       container_of(chip, struct vprbrd_gpio, gpioa);
> +
> +       dev_dbg(chip->dev, "%s offset:%i, value:%i\n", __FUNCTION__, offset, value);
> +
> +       ret = regmap_write(gpio->regmap,
> +               offset + VPRBRD_GPIOA_REG_DIR_BASE, value);
> +
> +       if (ret < 0) {
> +               dev_err(chip->dev, "usb error setting pin to output\n");
> +               return ret;
> +       }
> +
> +       gpio->gpioa_out |= (1 << offset);
> +       ret = regcache_write(gpio->regmap, offset, value);
> +
> +       return 0;
> +}
> +
> +/* ----- end of gpio a chip ---------------------------------------------- */
> +
> +/* ----- begin of gipo b chip -------------------------------------------- */
> +
> +static int vprbrd_gpiob_setdir(struct vprbrd *vb, unsigned offset,
> +       unsigned dir)
> +{
> +       struct vprbrd_gpiob_msg *gbmsg = (struct vprbrd_gpiob_msg *)vb->buf;
> +       int ret;
> +
> +       gbmsg->cmd = VPRBRD_GPIOB_CMD_SETDIR;
> +       gbmsg->val = cpu_to_be16(dir << offset);
> +       gbmsg->mask = cpu_to_be16(0x0001 << offset);
> +
> +       ret = usb_control_msg(vb->usb_dev, usb_sndctrlpipe(vb->usb_dev, 0),
> +               VPRBRD_USB_REQUEST_GPIOB, VPRBRD_USB_TYPE_OUT, 0x0000,
> +               0x0000, gbmsg, sizeof(struct vprbrd_gpiob_msg),
> +               VPRBRD_USB_TIMEOUT_MS);
> +
> +       if (ret != sizeof(struct vprbrd_gpiob_msg))
> +               return -EREMOTEIO;
> +
> +       return 0;
> +}
> +
> +static int vprbrd_gpiob_get(struct gpio_chip *chip,
> +               unsigned offset)
> +{
> +       int ret;
> +       u16 val;
> +       struct vprbrd_gpio *gpio =
> +                       container_of(chip, struct vprbrd_gpio, gpiob);
> +       struct vprbrd *vb = gpio->vb;
> +       struct vprbrd_gpiob_msg *gbmsg = (struct vprbrd_gpiob_msg *)vb->buf;
> +
> +       /* if io is set to output, just return the saved value */
> +       if (gpio->gpiob_out & (1 << offset))
> +               return gpio->gpiob_val & (1 << offset);
> +
> +       mutex_lock(&vb->lock);
> +
> +       ret = usb_control_msg(vb->usb_dev, usb_rcvctrlpipe(vb->usb_dev, 0),
> +               VPRBRD_USB_REQUEST_GPIOB, VPRBRD_USB_TYPE_IN, 0x0000,
> +               0x0000, gbmsg,  sizeof(struct vprbrd_gpiob_msg),
> +               VPRBRD_USB_TIMEOUT_MS);
> +       val = gbmsg->val;
> +
> +       mutex_unlock(&vb->lock);
> +
> +       if (ret != sizeof(struct vprbrd_gpiob_msg))
> +               return ret;
> +
> +       /* cache the read values */
> +       gpio->gpiob_val = be16_to_cpu(val);
> +
> +       return (gpio->gpiob_val >> offset) & 0x1;
> +}
> +
> +static void vprbrd_gpiob_set(struct gpio_chip *chip,
> +               unsigned offset, int value)
> +{
> +       int ret;
> +       struct vprbrd_gpio *gpio =
> +                       container_of(chip, struct vprbrd_gpio, gpiob);
> +       struct vprbrd *vb = gpio->vb;
> +       struct vprbrd_gpiob_msg *gbmsg = (struct vprbrd_gpiob_msg *)vb->buf;
> +
> +       if (gpio->gpiob_out & (1 << offset)) {
> +               if (value)
> +                       gpio->gpiob_val |= (1 << offset);
> +               else
> +                       gpio->gpiob_val &= ~(1 << offset);
> +
> +               mutex_lock(&vb->lock);
> +
> +               gbmsg->cmd = VPRBRD_GPIOB_CMD_SETVAL;
> +               gbmsg->val = cpu_to_be16(value << offset);
> +               gbmsg->mask = cpu_to_be16(0x0001 << offset);
> +
> +               ret = usb_control_msg(vb->usb_dev,
> +                       usb_sndctrlpipe(vb->usb_dev, 0),
> +                       VPRBRD_USB_REQUEST_GPIOB, VPRBRD_USB_TYPE_OUT,
> +                       0x0000, 0x0000, gbmsg,
> +                       sizeof(struct vprbrd_gpiob_msg), VPRBRD_USB_TIMEOUT_MS);
> +
> +               mutex_unlock(&vb->lock);
> +
> +               if (ret != sizeof(struct vprbrd_gpiob_msg))
> +                       dev_err(chip->dev, "usb error setting pin value\n");
> +       }
> +}
> +
> +static int vprbrd_gpiob_direction_input(struct gpio_chip *chip,
> +                       unsigned offset)
> +{
> +       int ret;
> +       struct vprbrd_gpio *gpio =
> +                       container_of(chip, struct vprbrd_gpio, gpiob);
> +       struct vprbrd *vb = gpio->vb;
> +
> +       gpio->gpiob_out &= ~(1 << offset);
> +
> +       mutex_lock(&vb->lock);
> +
> +       ret = vprbrd_gpiob_setdir(vb, offset, 0);
> +
> +       mutex_unlock(&vb->lock);
> +
> +       if (ret)
> +               dev_err(chip->dev, "usb error setting pin to input\n");
> +
> +       return ret;
> +}
> +
> +static int vprbrd_gpiob_direction_output(struct gpio_chip *chip,
> +                       unsigned offset, int value)
> +{
> +       int ret;
> +       struct vprbrd_gpio *gpio =
> +                       container_of(chip, struct vprbrd_gpio, gpiob);
> +       struct vprbrd *vb = gpio->vb;
> +
> +       gpio->gpiob_out |= (1 << offset);
> +       if (value)
> +               gpio->gpiob_val |= (1 << offset);
> +       else
> +               gpio->gpiob_val &= ~(1 << offset);
> +
> +       mutex_lock(&vb->lock);
> +
> +       ret = vprbrd_gpiob_setdir(vb, offset, 1);
> +       if (ret)
> +               dev_err(chip->dev, "usb error setting pin to output\n");
> +
> +       mutex_unlock(&vb->lock);
> +
> +       vprbrd_gpiob_set(chip, offset, value);
> +
> +       return ret;
> +}
> +
> +/* ----- end of gpio b chip ---------------------------------------------- */
> +
> +static int __devinit vprbrd_gpio_probe(struct platform_device *pdev)
> +{
> +       struct vprbrd *vb = dev_get_drvdata(pdev->dev.parent);
> +       struct vprbrd_gpio *vb_gpio;
> +       int ret, ret_err;
> +
> +       vb_gpio = kzalloc(sizeof(*vb_gpio), GFP_KERNEL);
> +       if (vb_gpio == NULL)
> +               return -ENOMEM;
> +
> +       vb_gpio->vb = vb;
> +       /* registering gpio a */
> +       vb_gpio->gpioa.label = "viperboard gpio a";
> +       vb_gpio->gpioa.dev = &pdev->dev;
> +       vb_gpio->gpioa.owner = THIS_MODULE;
> +       vb_gpio->gpioa.base = -1;
> +       vb_gpio->gpioa.ngpio = 16;
> +       vb_gpio->gpioa.can_sleep = 1;
> +       vb_gpio->gpioa.set = vprbrd_gpioa_set;
> +       vb_gpio->gpioa.get = vprbrd_gpioa_get;
> +       vb_gpio->gpioa.direction_input = vprbrd_gpioa_direction_input;
> +       vb_gpio->gpioa.direction_output = vprbrd_gpioa_direction_output;
> +       ret = gpiochip_add(&vb_gpio->gpioa);
> +       if (ret < 0) {
> +               dev_err(vb_gpio->gpioa.dev, "could not add gpio a");
> +               goto err_gpioa;
> +       }
> +
> +       /* registering gpio b */
> +       vb_gpio->gpiob.label = "viperboard gpio b";
> +       vb_gpio->gpiob.dev = &pdev->dev;
> +       vb_gpio->gpiob.owner = THIS_MODULE;
> +       vb_gpio->gpiob.base = -1;
> +       vb_gpio->gpiob.ngpio = 16;
> +       vb_gpio->gpiob.can_sleep = 1;
> +       vb_gpio->gpiob.set = vprbrd_gpiob_set;
> +       vb_gpio->gpiob.get = vprbrd_gpiob_get;
> +       vb_gpio->gpiob.direction_input = vprbrd_gpiob_direction_input;
> +       vb_gpio->gpiob.direction_output = vprbrd_gpiob_direction_output;
> +       ret = gpiochip_add(&vb_gpio->gpiob);
> +       if (ret < 0) {
> +               dev_err(vb_gpio->gpiob.dev, "could not add gpio b");
> +               goto err_gpiob;
> +       }
> +
> +       platform_set_drvdata(pdev, vb_gpio);
> +
> +       vb_gpio->regmap = devm_regmap_init(vb_gpio->gpioa.dev,
> +               &regmap_vb_gpio, vb, &vprbrd_regmap_config);
> +       if (IS_ERR(vb_gpio->regmap)) {
> +               ret = PTR_ERR(vb_gpio->regmap);
> +               dev_err(vb_gpio->gpioa.dev,
> +                       "regmap_init failed with err: %d\n", ret);
> +               goto err_gpiob;
> +       }
> +
> +       return ret;
> +
> +err_gpiob:
> +       ret_err = gpiochip_remove(&vb_gpio->gpioa);
> +
> +err_gpioa:
> +       kfree(vb_gpio);
> +       return ret;
> +}
> +
> +static int __devexit vprbrd_gpio_remove(struct platform_device *pdev)
> +{
> +       struct vprbrd_gpio *vb_gpio = platform_get_drvdata(pdev);
> +       int ret;
> +
> +/*
> +       ret = regmap_exit(vbgpio->regmap);
> +       if (ret == 0)
> +*/
> +               ret = gpiochip_remove(&vb_gpio->gpiob);
> +       if (ret == 0)
> +               ret = gpiochip_remove(&vb_gpio->gpioa);
> +       if (ret == 0)
> +               kfree(vb_gpio);
> +
> +       return ret;
> +}
> +
> +static struct platform_driver vprbrd_gpio_driver = {
> +       .driver.name    = "viperboard-gpio",
> +       .driver.owner   = THIS_MODULE,
> +       .probe          = vprbrd_gpio_probe,
> +       .remove         = __devexit_p(vprbrd_gpio_remove),
> +};
> +
> +static int __init vprbrd_gpio_init(void)
> +{
> +       switch (gpioa_freq) {
> +       case 1000000:
> +               gpioa_clk = VPRBRD_GPIOA_CLK_1MHZ;
> +               break;
> +       case 100000:
> +               gpioa_clk = VPRBRD_GPIOA_CLK_100KHZ;
> +               break;
> +       case 10000:
> +               gpioa_clk = VPRBRD_GPIOA_CLK_10KHZ;
> +               break;
> +       case 1000:
> +               gpioa_clk = VPRBRD_GPIOA_CLK_1KHZ;
> +               break;
> +       case 100:
> +               gpioa_clk = VPRBRD_GPIOA_CLK_100HZ;
> +               break;
> +       case 10:
> +               gpioa_clk = VPRBRD_GPIOA_CLK_10HZ;
> +               break;
> +       default:
> +               pr_warn("invalid gpioa_freq (%d)\n", gpioa_freq);
> +               gpioa_clk = VPRBRD_GPIOA_CLK_1KHZ;
> +       }
> +
> +       return platform_driver_register(&vprbrd_gpio_driver);
> +}
> +subsys_initcall(vprbrd_gpio_init);
> +
> +static void __exit vprbrd_gpio_exit(void)
> +{
> +       platform_driver_unregister(&vprbrd_gpio_driver);
> +}
> +module_exit(vprbrd_gpio_exit);
> +
> +MODULE_AUTHOR("Lars Poeschel <poeschel@lemonage.de>");
> +MODULE_DESCRIPTION("GPIO driver for Nano River Techs Viperboard");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:viperboard-gpio");
> diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
> index de368b7..9ad06cd 100644
> --- a/drivers/mfd/viperboard.c
> +++ b/drivers/mfd/viperboard.c
> @@ -49,6 +49,9 @@ static void vprbrd_free(struct vprbrd *dev)
>  }
>
>  static struct mfd_cell vprbrd_devs[] = {
> +       {
> +               .name = "viperboard-gpio",
> +       },
>  };
>
>  static int vprbrd_probe(struct usb_interface *interface,
> diff --git a/include/linux/mfd/viperboard.h b/include/linux/mfd/viperboard.h
> index 1c23c79..d3c9ad2 100644
> --- a/include/linux/mfd/viperboard.h
> +++ b/include/linux/mfd/viperboard.h
> @@ -44,6 +44,8 @@
>  #define VPRBRD_USB_TIMEOUT_MS       100
>  #define VPRBRD_USB_REQUEST_MAJOR    0xea
>  #define VPRBRD_USB_REQUEST_MINOR    0xeb
> +#define VPRBRD_USB_REQUEST_GPIOA    0xed
> +#define VPRBRD_USB_REQUEST_GPIOB    0xdd
>
>  struct __packed vprbrd_i2c_write_hdr {
>         u8 cmd;


Yours,
Linus Walleij
