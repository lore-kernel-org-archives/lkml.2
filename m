Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823Ab2IEW5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 18:57:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34141 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab2IEW5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 18:57:37 -0400
Message-ID: <5047D8DD.10604@gmail.com>
Date: Wed, 05 Sep 2012 17:57:33 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: David Daney <ddaney.cavm@gmail.com>
CC: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Michael Hennerich <michael.hennerich@analog.com>,
        David Daney <david.daney@cavium.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Axel Lin <axel.lin@gmail.com>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Subject: Re: [PATCH 1/2] misc/at25, dt: Improve at25 SPI eeprom device tree
 bindings.
References: <1345662238-15211-1-git-send-email-ddaney.cavm@gmail.com> <1345662238-15211-2-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1345662238-15211-2-git-send-email-ddaney.cavm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 02:03 PM, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Commit 002176db (misc: at25: Parse dt settings) added device tree
> bindings the differ significantly in style from the I2C EEPROM
> bindings and don't seem well vetted.  Here I deprecate (but still
> support) the "at25,*" properties, and add what I hope is a better
> alternative.  These new bindings also happen to be deployed in the
> field and were previously submitted for consideration here:
> 
> https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-May/015556.html
> 
> The advantages of the new bindings are that they are similar to the
> I2C EEPROMs and they don't conflate read-only and the address width
> modes in a binary encoded blob.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Michael Hennerich <michael.hennerich@analog.com>
> Cc: Axel Lin <axel.lin@gmail.com>

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
>  Documentation/devicetree/bindings/misc/at25.txt | 34 +++++++---
>  drivers/misc/eeprom/at25.c                      | 83 +++++++++++++++++--------
>  2 files changed, 82 insertions(+), 35 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/misc/at25.txt b/Documentation/devicetree/bindings/misc/at25.txt
> index ab3c327..1d34471 100644
> --- a/Documentation/devicetree/bindings/misc/at25.txt
> +++ b/Documentation/devicetree/bindings/misc/at25.txt
> @@ -1,21 +1,35 @@
> -Atmel AT25 eeprom
> +EEPROMs (SPI) compatible with Atmel at25.
>  
>  Required properties:
>  - compatible : "atmel,at25".
>  - reg : chip select number
>  - spi-max-frequency : max spi frequency to use
> +- pagesize : size of the eeprom page
> +- size : total eeprom size in bytes
> +- address-width : number of address bits (one of 8, 16, or 24)
>  
> +Optional properties:
> +- spi-cpha : SPI shifted clock phase, as per spi-bus bindings.
> +- spi-cpol : SPI inverse clock polarity, as per spi-bus bindings.
> +- read-only : this parameter-less property disables writes to the eeprom
> +
> +Obsolete legacy properties are can be used in place of "size", "pagesize",
> +"address-width", and "read-only":
>  - at25,byte-len : total eeprom size in bytes
>  - at25,addr-mode : addr-mode flags, as defined in include/linux/spi/eeprom.h
>  - at25,page-size : size of the eeprom page
>  
> -Examples:
> -at25@0 {
> -	compatible = "atmel,at25";
> -	reg = <0>
> -	spi-max-frequency = <5000000>;
> +Additional compatible properties are also allowed.
> +
> +Example:
> +	at25@0 {
> +		compatible = "atmel,at25", "st,m95256";
> +		reg = <0>
> +		spi-max-frequency = <5000000>;
> +		spi-cpha;
> +		spi-cpol;
>  
> -	at25,byte-len = <0x8000>;
> -	at25,addr-mode = <2>;
> -	at25,page-size = <64>;
> -};
> +		pagesize = <64>;
> +		size = <32768>;
> +		address-width = <16>;
> +	};
> diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
> index 25003d6..4ed93dd 100644
> --- a/drivers/misc/eeprom/at25.c
> +++ b/drivers/misc/eeprom/at25.c
> @@ -302,6 +302,61 @@ static ssize_t at25_mem_write(struct memory_accessor *mem, const char *buf,
>  
>  /*-------------------------------------------------------------------------*/
>  
> +static int at25_np_to_chip(struct device *dev,
> +			   struct device_node *np,
> +			   struct spi_eeprom *chip)
> +{
> +	u32 val;
> +
> +	memset(chip, 0, sizeof(*chip));
> +	strncpy(chip->name, np->name, sizeof(chip->name));
> +
> +	if (of_property_read_u32(np, "size", &val) == 0 ||
> +	    of_property_read_u32(np, "at25,byte-len", &val) == 0) {
> +		chip->byte_len = val;
> +	} else {
> +		dev_err(dev, "Error: missing \"size\" property\n");
> +		return -ENODEV;
> +	}
> +
> +	if (of_property_read_u32(np, "pagesize", &val) == 0 ||
> +	    of_property_read_u32(np, "at25,page-size", &val) == 0) {
> +		chip->page_size = (u16)val;
> +	} else {
> +		dev_err(dev, "Error: missing \"pagesize\" property\n");
> +		return -ENODEV;
> +	}
> +
> +	if (of_property_read_u32(np, "at25,addr-mode", &val) == 0) {
> +		chip->flags = (u16)val;
> +	} else {
> +		if (of_property_read_u32(np, "address-width", &val)) {
> +			dev_err(dev,
> +				"Error: missing \"address-width\" property\n");
> +			return -ENODEV;
> +		}
> +		switch (val) {
> +		case 8:
> +			chip->flags |= EE_ADDR1;
> +			break;
> +		case 16:
> +			chip->flags |= EE_ADDR2;
> +			break;
> +		case 24:
> +			chip->flags |= EE_ADDR3;
> +			break;
> +		default:
> +			dev_err(dev,
> +				"Error: bad \"address-width\" property: %u\n",
> +				val);
> +			return -ENODEV;
> +		}
> +		if (of_find_property(np, "read-only", NULL))
> +			chip->flags |= EE_READONLY;
> +	}
> +	return 0;
> +}
> +
>  static int at25_probe(struct spi_device *spi)
>  {
>  	struct at25_data	*at25 = NULL;
> @@ -314,33 +369,11 @@ static int at25_probe(struct spi_device *spi)
>  	/* Chip description */
>  	if (!spi->dev.platform_data) {
>  		if (np) {
> -			u32 val;
> -
> -			memset(&chip, 0, sizeof(chip));
> -			strncpy(chip.name, np->name, 10);
> -
> -			err = of_property_read_u32(np, "at25,byte-len", &val);
> -			if (err) {
> -				dev_dbg(&spi->dev, "invalid chip dt description\n");
> -				goto fail;
> -			}
> -			chip.byte_len = val;
> -
> -			err = of_property_read_u32(np, "at25,addr-mode", &val);
> -			if (err) {
> -				dev_dbg(&spi->dev, "invalid chip dt description\n");
> -				goto fail;
> -			}
> -			chip.flags = (u16)val;
> -
> -			err = of_property_read_u32(np, "at25,page-size", &val);
> -			if (err) {
> -				dev_dbg(&spi->dev, "invalid chip dt description\n");
> +			err = at25_np_to_chip(&spi->dev, np, &chip);
> +			if (err)
>  				goto fail;
> -			}
> -			chip.page_size = (u16)val;
>  		} else {
> -			dev_dbg(&spi->dev, "no chip description\n");
> +			dev_err(&spi->dev, "Error: no chip description\n");
>  			err = -ENODEV;
>  			goto fail;
>  		}
> 

