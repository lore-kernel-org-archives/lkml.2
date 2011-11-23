Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1KWQSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:18:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51130 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab1KWQSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:18:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nikolaus Voss <n.voss@weinmann.de>
Subject: Re: [PATCH v7 3/5] drivers/i2c/busses/i2c-at91.c: add new driver
Date: Wed, 23 Nov 2011 16:18:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, ben-linux@fluff.org,
        carsten.behling@garz-fricke.com
References: <cover.1322062555.git.n.voss@weinmann.de> <ee23c49c5a190a2cce0859f7828c2dc771ff3207.1322062555.git.n.voss@weinmann.de>
In-Reply-To: <ee23c49c5a190a2cce0859f7828c2dc771ff3207.1322062555.git.n.voss@weinmann.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111231618.45951.arnd@arndb.de>
X-Provags-ID: V02:K0:PfCPnkvu1cheSqwIUmLT9Prfah4J2lN3PPQwH/xmbCs
 n4HfXAwZk46DcRX7APU9jq0blpOMJx79MN2yHxMZhRBv5Y6kcZ
 lvI7sBWpowtOmTpRekv9cDjrFioWvheNSynLY4tlTEjmYYJHqy
 cng/ns/RtDfzsqh4N+G4TfevIIG28esppEZK3x5rau4NlSqe6V
 DAFm57DTi9vF3McByufvK8obwbMkidhH6LJ4LR5oX72eNtvQyl
 qUGlC44MPJjpAwqRkDXtTogEAPrkPHpWTN1dv3YxOvtIOxVA9P
 e5dsS26Zg3vy3fpEOtwTZzbqOBq15Gpd2U+Rmmrn9IT8IPGQOo
 ShkjuncpkJH1BF/JsKkA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 November 2011, Nikolaus Voss wrote:


> +
> +static unsigned at91_twi_read(struct at91_twi_dev *dev, unsigned reg)
> +{
> +	return __raw_readl(dev->base + reg);
> +}
> +
> +static void at91_twi_write(struct at91_twi_dev *dev, unsigned reg, unsigned val)
> +{
> +	__raw_writel(val, dev->base + reg);
> +}

Better use readl/writel or readl_relaxed/writel_relaxed.

> +/*
> + * Calculate and set symmetric clock as stated in datasheet:
> + * twi_clk = F_MAIN / (2 * cdiv * (1 << ckdiv) + 4)
> + */
> +static void __devinit at91_set_twi_clock(struct at91_twi_dev *dev, int twi_clk)
> +{
> +	const int div = DIV_ROUND_UP(clk_get_rate(dev->clk), 2 * twi_clk) - 2;
> +	int ckdiv = fls(div >> 8);
> +	const int cdiv = div >> ckdiv;
> +
> +	if (cpu_is_at91rm9200() && (ckdiv > 5)) {
> +		dev_warn(dev->dev, "AT91RM9200 erratum 22: using ckdiv = 5.\n");
> +		ckdiv = 5;
> +	}

Don't check a global property like this locally in the driver. Instead,
make it a property of the device that you check here and set it based on
the the device name set by the platform, or by a device tree property.

> diff --git a/drivers/i2c/busses/i2c-at91.h b/drivers/i2c/busses/i2c-at91.h
> new file mode 100644
> index 0000000..a898159
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-at91.h
> @@ -0,0 +1,80 @@
> +
> +#ifndef AT91_TWI_H
> +#define AT91_TWI_H
> +

No need for a header file if all the values in it are used in only one
source file. Just move everything to i2c_at91.c

> +#define	AT91_TWI_MMR		0x04		/* Master Mode Register */
> +#define	AT91_TWI_IADRSZ		(3    <<  8)	/* Internal Device Address
> +						 *  Size */
> +#define	AT91_TWI_IADRSZ_NO	(0 << 8)
> +#define	AT91_TWI_IADRSZ_1	(1 << 8)
> +#define	AT91_TWI_IADRSZ_2	(2 << 8)
> +#define	AT91_TWI_IADRSZ_3	(3 << 8)
> +#define	AT91_TWI_MREAD		(1    << 12)	/* Master Read Direction */
> +#define	AT91_TWI_DADR		(0x7f << 16)	/* Device Address */

These are harder to read than just using hexadecimal bitmasks:

#define	AT91_TWI_MMR		0x00000004
#define	AT91_TWI_IADRSZ		0x00000300
#define	AT91_TWI_IADRSZ_NO	0x00000000
#define	AT91_TWI_IADRSZ_1	0x00000100
...

	Arnd
