Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946252Ab2ERXoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:44:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57741 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946137Ab2ERXoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:44:12 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] GPIO/TCA6424: merge I2C transactions, remove cast
To: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        linus.walleij@stericsson.com, linux-kernel@vger.kernel.org
In-Reply-To: <0M9AKX-1SNwZq1JrJ-00CWsH@mrelayeu.kundenserver.de>
References: <0M9AKX-1SNwZq1JrJ-00CWsH@mrelayeu.kundenserver.de>
Date: Fri, 18 May 2012 17:44:10 -0600
Message-Id: <20120518234410.E079C3E07C8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012 17:01:36 +0200, Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com> wrote:
> From 1a80280e20dfef57c6bc6429e5bdf7e10d10fda9 Mon Sep 17 00:00:00 2001
> From: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
> Date: Fri, 18 May 2012 16:20:31 +0200
> Subject: [PATCH] GPIO/TCA6424: merge I2C transactions, remove cast
> 
> This is a follow-up to "[PATCH v2] Add support for TCA6424":
> - Use 3 byte transfers instead of two separate transfers (2+1 byte)
> - An unnecessary cast removed
> 
> Please check especially if endianness conversion is done the way it should be.

It works I suppose.  Personally, I'd explicitly use a byte array, but
I'll apply this patch as-is anyway.

g.

> 
> Signed-off-by: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
> 
> ---
>  drivers/gpio/gpio-pca953x.c |   27 ++++++++++++++++-----------
>  1 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
> index 1c313c7..5eee524 100644
> --- a/drivers/gpio/gpio-pca953x.c
> +++ b/drivers/gpio/gpio-pca953x.c
> @@ -98,12 +98,11 @@ static int pca953x_write_reg(struct pca953x_chip *chip, 
> int reg, u32 val)
>         if (chip->gpio_chip.ngpio <= 8)
>                 ret = i2c_smbus_write_byte_data(chip->client, reg, val);
>         else if (chip->gpio_chip.ngpio == 24) {
> -               ret = i2c_smbus_write_word_data(chip->client,
> +               cpu_to_le32s(&val);
> +               ret = i2c_smbus_write_i2c_block_data(chip->client,
>                                                 (reg << 2) | REG_ADDR_AI,
> -                                               val & 0xffff);
> -               ret = i2c_smbus_write_byte_data(chip->client,
> -                                               (reg << 2) + 2,
> -                                               (val & 0xff0000) >> 16);
> +                                               3,
> +                                               (u8 *) &val);
>         }
>         else {
>                 switch (chip->chip_type) {
> @@ -135,22 +134,28 @@ static int pca953x_read_reg(struct pca953x_chip *chip, 
> int reg, u32 *val)
>  {
>         int ret;
>  
> -       if (chip->gpio_chip.ngpio <= 8)
> +       if (chip->gpio_chip.ngpio <= 8) {
>                 ret = i2c_smbus_read_byte_data(chip->client, reg);
> +               *val = ret;
> +       }
>         else if (chip->gpio_chip.ngpio == 24) {
> -               ret =  i2c_smbus_read_word_data(chip->client, reg << 2);
> -               ret |= (i2c_smbus_read_byte_data(chip->client,
> -                                                (reg << 2) + 2)<<16);
> +               *val = 0;
> +               ret = i2c_smbus_read_i2c_block_data(chip->client,
> +                                               (reg << 2) | REG_ADDR_AI,
> +                                               3,
> +                                               (u8 *) val);
> +               le32_to_cpus(val);
>         }
> -       else
> +       else {
>                 ret = i2c_smbus_read_word_data(chip->client, reg << 1);
> +               *val = ret;
> +       }
>  
>         if (ret < 0) {
>                 dev_err(&chip->client->dev, "failed reading register\n");
>                 return ret;
>         }
>  
> -       *val = (u32)ret;
>         return 0;
>  }
>  
> -- 
> 1.7.3.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
