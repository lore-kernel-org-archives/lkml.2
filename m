Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab0FBJDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:03:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41231 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab0FBJDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:03:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bo/lLq1aj8oKrZCuc1v+0zeS0sMLOeeK1vemGf6lB5vzqXZS8kiD15CcmsJ7oL5ln6
         0ZXMOO1vh4XKy0A9ZktYdRKnBDC0yOppr45xN/qgg2XQDAYazcNZKo013DFhHc1RXU/+
         mJdKKRlGiUdqeDUYkjofLC83NZpp4blhu2t5Q=
MIME-Version: 1.0
In-Reply-To: <1275468694.2545.1.camel@eight.analog.com>
References: <1275468694.2545.1.camel@eight.analog.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 2 Jun 2010 05:02:58 -0400
Message-ID: <AANLkTinaPmKUx04I1mjNhla4s3S6vmWp8x6eoDTZGRVz@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH v2] regulator: new drivers for AD5398 
	and AD5821
To: sonic zhang <sonic.adi@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 04:51, sonic zhang wrote:
> The AD5398 and AD5821 are single 10-bit DAC with 120 mA output current
> sink capability. They feature an internal reference and operates from
> a single 2.7 V to 5.5 V supply.
>
> This driver supports both the AD5398 and the AD5821.  It adapts into the
> voltage and current framework.
>
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

the "From:" doesnt match your s-o-b tag ...

also, this dropped my s-o-b:
Signed-off-by: Mike Frysinger <vapier@gentoo.org>

> +config REGULATOR_AD5398
> +       tristate "Ananlog Devices AD5398/AD5821 regulators"

Analog

> +       depends on I2C
> +       help
> +         This driver supports AD5398 and AD5821 current regulator chips.

should mention the module name if built as a module

> --- /dev/null
> +++ b/drivers/regulator/ad5398.c
> @@ -0,0 +1,285 @@
> +/*
> + * ad5398.c  --  Voltage and current regulation for AD5398 and AD5821

dont think the filename needs to be here

> + */
> +#include <linux/module.h>

should prob be a newline between these

> +       /* write the new current value back as well as enable bit */
> +       ret = ad5398_write_reg(client, (unsigned short)selector);

the prototype of write_reg takes an unsigned short, so this cast is useless

> +static struct regulator_ops ad5398_ops = {
> +       .get_current_limit = ad5398_get_current_limit,
> +       .set_current_limit = ad5398_set_current_limit,
> +       .enable = ad5398_enable,
> +       .disable = ad5398_disable,
> +       .is_enabled = ad5398_is_enabled,
> +};
> +
> +static struct regulator_desc ad5398_reg = {

not specific to this driver, but it looks like regulator_ops and
regulator_desc really should be constified

> +static const struct ad5398_current_data_format ad5398_df = {10, 4};
> +static const struct ad5398_current_data_format ad5821_df = {10, 4};
> +
> +static const struct i2c_device_id ad5398_id[] = {
> +       { "ad5398", (kernel_ulong_t)&ad5398_df },
> +       { "ad5821", (kernel_ulong_t)&ad5821_df },
> +       { }
> +};

do you really need sep storage for these _df vars ?

> +static int ad5398_probe(struct i2c_client *client,
> +static int ad5398_remove(struct i2c_client *client)
> +       .remove = ad5398_remove,

missing hotplug section markings

> +       struct ad5398_current_data_format *df =
> +                       (struct ad5398_current_data_format *)id->driver_data;

this too should be const

> +       chip = kzalloc(sizeof(struct ad5398_chip_info), GFP_KERNEL);

sizeof(*chip)

> +       dev_dbg(&client->dev, "%s regulator driver loaded\n", id->name);

does the regulator core take care of displaying a notice ?  if not,
i'd make this dev_info().  also, this should be "registered", not
"loaded".

> +MODULE_DESCRIPTION("AD5398 and AD5821 current regulator driver");
> +MODULE_AUTHOR("Sonic Zhang");
> +MODULE_LICENSE("GPL");

should there be a MODULE_ALIAS() ?
-mike
