Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab2DSRw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 13:52:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59235 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575Ab2DSRwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 13:52:24 -0400
MIME-Version: 1.0
In-Reply-To: <1334834109-30183-3-git-send-email-ldewangan@nvidia.com>
References: <1334834109-30183-1-git-send-email-ldewangan@nvidia.com>
	<1334834109-30183-3-git-send-email-ldewangan@nvidia.com>
Date: Thu, 19 Apr 2012 10:52:23 -0700
X-Google-Sender-Auth: bw2ZIG_FxHGJPpWnLGNPlxOr61Q
Message-ID: <CANEJEGtvfwUmtXjsu_PTWP2zCRAbYMJh_jJp-c6Ex2ca=Sietg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] staging: iio: light: isl29018: use regmap for
 register access
From: Grant Grundler <grundler@chromium.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: jic23@cam.ac.uk, gregkh@linuxfoundation.org, max@stro.at,
        jbrenner@taosinc.com, bfreed@chromium.org, lars@metafoo.de,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 4:15 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> Using regmap for accessing register through i2c bus. This will
> remove the code for caching registers, read-modify-write logics.
> Also it will provide the debugfs feature to dump register
> through regmap debugfs.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Reviewed-by: Grant Grundler <grundler@chromium.org>

Laxman,
Thanks for reposting this patch. I was talking with Bryan Freed and it
looks like the caching of registers will change the usage of
ADD_COMMAND1. More details below.

...
> -static int isl29018_write_data(struct i2c_client *client, u8 reg,
> -                       u8 val, u8 mask, u8 shift)
> -{
> -       u8 regval = val;
> -       int ret;
> -       struct isl29018_chip *chip = iio_priv(i2c_get_clientdata(client));
> -
> -       /* don't cache or mask REG_TEST */
> -       if (reg < ISL29018_MAX_REGS) {
> -               regval = chip->reg_cache[reg];
> -               regval &= ~mask;
> -               regval |= val << shift;
> -       }

Note the only REG_TEST isn't cached. Everything else updates the cache
on write.

> -
> -       ret = i2c_smbus_write_byte_data(client, reg, regval);
> -       if (ret) {
> -               dev_err(&client->dev, "Write to device fails status %x\n", ret);
> -       } else {
> -               /* don't update cache on err */
> -               if (reg < ISL29018_MAX_REGS)
> -                       chip->reg_cache[reg] = regval;
> -       }
> -
> -       return ret;
> -}

...
> -static int isl29018_read_sensor_input(struct i2c_client *client, int mode)
> +static int isl29018_read_sensor_input(struct isl29018_chip *chip, int mode)
>  {
>        int status;
> -       int lsb;
> -       int msb;
> +       unsigned int lsb;
> +       unsigned int msb;
>
>        /* Set mode */
> -       status = isl29018_write_data(client, ISL29018_REG_ADD_COMMAND1,
> -                       mode, COMMMAND1_OPMODE_MASK, COMMMAND1_OPMODE_SHIFT);
> +       status = regmap_update_bits(chip->regmap, ISL29018_REG_ADD_COMMAND1,
> +                       COMMMAND1_OPMODE_MASK, mode << COMMMAND1_OPMODE_SHIFT);

The old code will do a single I2C write. The new code will do a
read+write for ADD_COMMAND1 register. I reviewed the behaviors in
drivers/base/regmap/regmap.c and regcache.c.

I can't judge if this is a "real" problem. Given the limited BW on
I2C, someone with more I2C experience should carefully consider and
share their opinion.

>        if (status) {
> -               dev_err(&client->dev, "Error in setting operating mode\n");
> +               dev_err(chip->dev,
> +                       "Error in setting operating mode err %d\n", status);
>                return status;
>        }
>        msleep(CONVERSION_TIME_MS);
> -       lsb = i2c_smbus_read_byte_data(client, ISL29018_REG_ADD_DATA_LSB);

Old code for DATA_LSB and DATA_MSB ignored the "write cache" for reads
- so marking these as volatile looks correct to me.

...
> +static bool is_volatile_reg(struct device *dev, unsigned int reg)
> +{
> +       switch (reg) {
> +       case ISL29018_REG_ADD_DATA_LSB:
> +       case ISL29018_REG_ADD_DATA_MSB:
> +       case ISL29018_REG_ADD_COMMAND1:
> +       case ISL29018_REG_TEST:

Of these four, I think only ADD_COMMAND1 wasn't treated as volatile in
the old code. Am I overlooking something?

My concern is only about the additional I2C read traffic this patch
might generate. It's possible *some* bits in that register are
volatile and we could previously ignore them.

cheers,
grant
