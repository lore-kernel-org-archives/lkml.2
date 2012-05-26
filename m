Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab2EZNMe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:12:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61402 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab2EZNMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:12:30 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH-RESEND] GPIO/TCA6424: merge I2C transactions, remove cast
To: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        linus.walleij@stericsson.com
Cc: linux-kernel@vger.kernel.org,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>
In-Reply-To: <0LrHzA-1S4duI0urs-013Ke8@mrelayeu.kundenserver.de>
References: <0LrHzA-1S4duI0urs-013Ke8@mrelayeu.kundenserver.de>
Date: Fri, 25 May 2012 18:52:21 -0600
Message-Id: <20120526005221.5FE113E20AE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012 09:52:43 +0200, Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com> wrote:
> This is a follow-up to "[PATCH v2] Add support for TCA6424":
> - Use 3 byte transfers instead of two separate transfers (2+1 byte)
> - An unnecessary cast removed
> 
> Signed-off-by: Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>

Applied, thanks.

g.

> 
> ---
>  drivers/gpio/gpio-pca953x.c |   27 ++++++++++++++++-----------
>  1 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
> index 1c313c7..5eee524 100644
> --- a/drivers/gpio/gpio-pca953x.c
> +++ b/drivers/gpio/gpio-pca953x.c
> @@ -98,12 +98,11 @@ static int pca953x_write_reg(struct pca953x_chip *chip, int reg, u32 val)
>  	if (chip->gpio_chip.ngpio <= 8)
>  		ret = i2c_smbus_write_byte_data(chip->client, reg, val);
>  	else if (chip->gpio_chip.ngpio == 24) {
> -		ret = i2c_smbus_write_word_data(chip->client,
> +		cpu_to_le32s(&val);
> +		ret = i2c_smbus_write_i2c_block_data(chip->client,
>  						(reg << 2) | REG_ADDR_AI,
> -						val & 0xffff);
> -		ret = i2c_smbus_write_byte_data(chip->client,
> -						(reg << 2) + 2,
> -						(val & 0xff0000) >> 16);
> +						3,
> +						(u8 *) &val);
>  	}
>  	else {
>  		switch (chip->chip_type) {
> @@ -135,22 +134,27 @@ static int pca953x_read_reg(struct pca953x_chip *chip, int reg, u32 *val)
>  {
>  	int ret;
>  
> -	if (chip->gpio_chip.ngpio <= 8)
> +	if (chip->gpio_chip.ngpio <= 8) {
>  		ret = i2c_smbus_read_byte_data(chip->client, reg);
> +		*val = ret;
> +	}
>  	else if (chip->gpio_chip.ngpio == 24) {
> -		ret =  i2c_smbus_read_word_data(chip->client, reg << 2);
> -		ret |= (i2c_smbus_read_byte_data(chip->client,
> -						 (reg << 2) + 2)<<16);
> +		*val = 0;
> +		ret = i2c_smbus_read_i2c_block_data(chip->client,
> +						(reg << 2) | REG_ADDR_AI,
> +						3,
> +						(u8 *) val);
> +		le32_to_cpus(val);
> -	}
> -	else
> +	} else {
>  		ret = i2c_smbus_read_word_data(chip->client, reg << 1);
> +		*val = ret;
> +	}
>  
>  	if (ret < 0) {
>  		dev_err(&chip->client->dev, "failed reading register\n");
>  		return ret;
>  	}
>  
> -	*val = (u32)ret;
>  	return 0;
>  }
>  
> -- 
> 1.7.3.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
