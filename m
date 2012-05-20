Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2ETGOq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 02:14:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46562 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2ETGOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 02:14:44 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/3] eeprom/of: Add device tree bindings to at25.
To: David Daney <ddaney.cavm@gmail.com>, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        linux-doc@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Lin <axel.lin@gmail.com>
In-Reply-To: <1336773923-17866-4-git-send-email-ddaney.cavm@gmail.com>
References: <1336773923-17866-1-git-send-email-ddaney.cavm@gmail.com> <1336773923-17866-4-git-send-email-ddaney.cavm@gmail.com>
Date: Sun, 20 May 2012 00:14:41 -0600
Message-Id: <20120520061441.D5C9B3E03B8@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 15:05:23 -0700, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
> 
> We can extract the "pagesize", "size" and "address-width" from the
> device tree so that SPI eeproms can be fully specified in the device
> tree.
> 
> Also add a MODULE_DEVICE_TABLE so the drivers can be automatically bound.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Cc: Michael Hennerich <michael.hennerich@analog.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/misc/eeprom/at25.c |   61 +++++++++++++++++++++++++++++++++++++++++---

Documentation on binding?  It needs to be there before merging.

g.

>  1 files changed, 57 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
> index 01ab3c9..609ee72 100644
> --- a/drivers/misc/eeprom/at25.c
> +++ b/drivers/misc/eeprom/at25.c
> @@ -16,6 +16,7 @@
>  #include <linux/delay.h>
>  #include <linux/device.h>
>  #include <linux/sched.h>
> +#include <linux/of.h>
>  
>  #include <linux/spi/spi.h>
>  #include <linux/spi/eeprom.h>
> @@ -293,6 +294,9 @@ static int at25_probe(struct spi_device *spi)
>  {
>  	struct at25_data	*at25 = NULL;
>  	const struct spi_eeprom *chip;
> +#ifdef CONFIG_OF
> +	struct spi_eeprom of_chip;
> +#endif
>  	int			err;
>  	int			sr;
>  	int			addrlen;
> @@ -300,9 +304,51 @@ static int at25_probe(struct spi_device *spi)
>  	/* Chip description */
>  	chip = spi->dev.platform_data;
>  	if (!chip) {
> -		dev_dbg(&spi->dev, "no chip description\n");
> -		err = -ENODEV;
> -		goto fail;
> +#ifdef CONFIG_OF
> +		if (spi->dev.of_node) {
> +			u32 val;
> +			memset(&of_chip, 0, sizeof(of_chip));
> +			if (of_property_read_u32(spi->dev.of_node, "pagesize", &val)) {
> +				dev_dbg(&spi->dev, "no \"pagesize\" property\n");
> +				err = -ENODEV;
> +				goto fail;
> +			}
> +			of_chip.page_size = val;
> +			if (of_property_read_u32(spi->dev.of_node, "size", &val)) {
> +				dev_dbg(&spi->dev, "no \"size\" property\n");
> +				err = -ENODEV;
> +				goto fail;
> +			}
> +			of_chip.byte_len = val;
> +			if (of_property_read_u32(spi->dev.of_node, "address-width", &val)) {
> +				dev_dbg(&spi->dev, "no \"address-width\" property\n");
> +				err = -ENODEV;
> +				goto fail;
> +			}
> +			switch (val) {
> +			case 8:
> +				of_chip.flags |= EE_ADDR1;
> +				break;
> +			case 16:
> +				of_chip.flags |= EE_ADDR2;
> +				break;
> +			case 24:
> +				of_chip.flags |= EE_ADDR3;
> +				break;
> +			default:
> +				dev_dbg(&spi->dev, "bad \"address-width\" property: %u\n", val);
> +				err = -EINVAL;
> +				goto fail;
> +			}
> +			strlcpy(of_chip.name, spi->dev.of_node->name, sizeof(of_chip.name));
> +			chip = &of_chip;
> +		} else
> +#endif
> +		{
> +			dev_dbg(&spi->dev, "no chip description\n");
> +			err = -ENODEV;
> +			goto fail;
> +		}
>  	}
>  
>  	/* For now we only support 8/16/24 bit addressing */
> @@ -396,11 +442,19 @@ static int __devexit at25_remove(struct spi_device *spi)
>  
>  /*-------------------------------------------------------------------------*/
>  
> +static const struct spi_device_id at25_id[] = {
> +	{"at25", 0},
> +	{"m95256", 0},
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(spi, at25_id);
> +
>  static struct spi_driver at25_driver = {
>  	.driver = {
>  		.name		= "at25",
>  		.owner		= THIS_MODULE,
>  	},
> +	.id_table	= at25_id,
>  	.probe		= at25_probe,
>  	.remove		= __devexit_p(at25_remove),
>  };
> @@ -410,4 +464,3 @@ module_spi_driver(at25_driver);
>  MODULE_DESCRIPTION("Driver for most SPI EEPROMs");
>  MODULE_AUTHOR("David Brownell");
>  MODULE_LICENSE("GPL");
> -MODULE_ALIAS("spi:at25");
> -- 
> 1.7.2.3
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
