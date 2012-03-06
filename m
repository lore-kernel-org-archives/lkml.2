Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab2CFV1t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:27:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58091 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab2CFV1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:27:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Andersson <eric.andersson@unixphere.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCHv2 2/3] misc: add support for bmp18x chips to the bmp085 driver
Date: Tue, 6 Mar 2012 21:27:44 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com
References: <1331068084-17911-1-git-send-email-eric.andersson@unixphere.com> <1331068084-17911-3-git-send-email-eric.andersson@unixphere.com>
In-Reply-To: <1331068084-17911-3-git-send-email-eric.andersson@unixphere.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203062127.44463.arnd@arndb.de>
X-Provags-ID: V02:K0:GNcIP7ZlSeAM1bdmjEMgXSCbLNG0Qyy1HYfBnZzsUGe
 Twv3Y7Z2K6h04UGWTsNyjEXkZpFxZ43eCsoBbgf+G+dCIykmLG
 IyTRZKodY3HnIVKrp/ALLeFSpdvb7Gad0S5HO5ycwD+SzmADaz
 7xiSrD+rw6igBMWcEyNNxwT8vwbzFvZpSNu45PaQNvqQJJ2RbJ
 DvCz/PPri/ECNKTheuNYFUJ4AIgMzOB/vkDY3n3wNLFXQAlGW/
 HQ+fiCmFhFk1b/QCI3SueMXkZShqulyrtLDdvhAsmvjJb+9i3U
 y9zB1YMJUutHWmepDxO+l55YP1ZSUvLFVMyzR2NkHwTNlXzkxQ
 6NGBYOmmY99R1yePpS0o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2012, Eric Andersson wrote:
> The bmp18x chip family comes in an I2C respectively SPI variant.
> Hence, the bmp085 driver was split to support both buses.
> 
> Tested-by: Zhengguang Guo <zhengguang.guo@bosch-sensortec.com>
> Reviewed-by: Stefan Nilsson <stefan.nilsson@unixphere.com>
> Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>

(adding Mark Brown to Cc)

I don't know much about regmap, but your description sounds like you
should be using it here, to simplify the differences between i2c and
spi in your driver instead of implementing your own abstraction
layer.

>  config BMP085
>  	tristate "BMP085 digital pressure sensor"
> -	depends on I2C && SYSFS
> +	depends on (I2C || SPI_MASTER) && SYSFS
>  	help
> -	  If you say yes here you get support for the Bosch Sensortec
> -	  BMP085 digital pressure sensor.
> +	  Say Y here if you want support for Bosch Sensortec's digital
> +	  pressure sensors BMP085 and BMP18x.
>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called bmp085.
>  
> +config BMP085_I2C
> +	tristate "support I2C bus connection"
> +	depends on BMP085 && I2C
> +	help
> +	  Say Y here if you want to support Bosch Sensortec's digital pressure
> +	  sensor hooked to an I2C bus.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called bmp085-i2c.
> +
> +config BMP085_SPI
> +	tristate "support SPI bus connection"
> +	depends on BMP085 && SPI_MASTER
> +	help
> +	  Say Y here if you want to support Bosch Sensortec's digital pressure
> +	  sensor hooked to an SPI bus.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called bmp085-spi.
> +

IMHO this would be better expressed if you make CONFIG_BMP085 a hidden
option that is selected when either BMP085_I2C or BMP085_SPI are enabled.
Otherwise you make it possible to build just the base driver but neither
of the front-ends, which is a bit pointless.

>  }
> +EXPORT_SYMBOL(bmp085_probe);
>  

When you add internal symbols inside of your driver, best always use
EXPORT_SYMBOL_GPL. There is little practical difference here, but it
helps to get used to just always pick that as a default.

	Arnd
