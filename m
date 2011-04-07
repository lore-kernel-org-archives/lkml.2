Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1DGKJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 06:09:54 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:43711 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab1DGKJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 06:09:52 -0400
Date: Thu, 7 Apr 2011 12:09:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Chew <achew@nvidia.com>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: (lm90) Add support for ADT7461A and NCT1008
Message-ID: <20110407120936.5a095862@endymion.delvare>
In-Reply-To: <1302104479-13363-1-git-send-email-guenter.roeck@ericsson.com>
References: <1302104479-13363-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Wed, 6 Apr 2011 08:41:19 -0700, Guenter Roeck wrote:
> This patch adds support for ADT7461A and NCT1008 to the lm90 driver.
> Both chips have identical functionality and report the same manufacturing ID
> and device ID values.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
> Would this be a candidate for 2.6.39 and possibly -stable ?

2.6.39, why not. Stable, don't ask me, I have never been keen on the
"support for new devices doesn't have to follow the stability rules"
policy, but apparently I am in the minority.

In this specific case, please keep in mind that people can easily
instantiate I2C devices from user-space now, and the chip you are adding
support for is 100% compatible with one we already support, so a
workaround already exists in the absence of official support.

> 
>  drivers/hwmon/Kconfig |    8 ++++----
>  drivers/hwmon/lm90.c  |    6 ++++++

Please follow your own brand new hwmon patch submission guide and
update Documentation/hwmon/lm90 as well. SCNR :)

>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 060ef63..92d0251 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -618,10 +618,10 @@ config SENSORS_LM90
>  	depends on I2C
>  	help
>  	  If you say yes here you get support for National Semiconductor LM90,
> -	  LM86, LM89 and LM99, Analog Devices ADM1032 and ADT7461, Maxim
> -	  MAX6646, MAX6647, MAX6648, MAX6649, MAX6657, MAX6658, MAX6659,
> -	  MAX6680, MAX6681, MAX6692, MAX6695, MAX6696, and Winbond/Nuvoton
> -	  W83L771W/G/AWG/ASG sensor chips.
> +	  LM86, LM89 and LM99, Analog Devices ADM1032, ADT7461, and ADT7461A,
> +	  Maxim MAX6646, MAX6647, MAX6648, MAX6649, MAX6657, MAX6658, MAX6659,
> +	  MAX6680, MAX6681, MAX6692, MAX6695, MAX6696, ON Semiconductor NCT1008,
> +	  and Winbond/Nuvoton W83L771W/G/AWG/ASG sensor chips.

As a side note, I find it weird that On Semi uses the same chip name
prefix (NCT) has Nuvoton...

>  
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called lm90.
> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> index 812781c..0aa892c 100644
> --- a/drivers/hwmon/lm90.c
> +++ b/drivers/hwmon/lm90.c

This source file includes a list of supported chips in its header
comment. The "Addresses to scan" comment also lists which chips can
live at which address. Please update both sections.

It might make sense to drop the big header comment in the future, and
redirect the reader to the documentation file, after ensuring that it
contains all the required information. This would avoid having to
update two different lists which are essentially redundant with each
new chip we add support for.

> @@ -174,6 +174,7 @@ enum chips { lm90, adm1032, lm99, lm86, max6657, max6659, adt7461, max6680,
>  static const struct i2c_device_id lm90_id[] = {
>  	{ "adm1032", adm1032 },
>  	{ "adt7461", adt7461 },
> +	{ "adt7461a", adt7461 },
>  	{ "lm90", lm90 },
>  	{ "lm86", lm86 },
>  	{ "lm89", lm86 },
> @@ -1153,6 +1154,11 @@ static int lm90_detect(struct i2c_client *new_client,
>  		 && (reg_config1 & 0x1B) == 0x00
>  		 && reg_convrate <= 0x0A) {
>  			name = "adt7461";
> +		} else
> +		if (chip_id == 0x57 /* ADT7461A, NCT1008 */
> +		 && (reg_config1 & 0x1B) == 0x00
> +		 && reg_convrate <= 0x0A) {
> +			name = "adt7461a";
>  		}
>  	} else
>  	if (man_id == 0x4D) { /* Maxim */

Other than this, these changes look good and I'll be happy to pick the
patch in my tree when it's ready.

-- 
Jean Delvare
