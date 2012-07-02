Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab2GBQAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:00:04 -0400
Received: from smtp-out-137.synserver.de ([212.40.185.137]:1100 "EHLO
	smtp-out-137.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2GBQAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:00:01 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 2598
Message-ID: <4FF1C666.40106@metafoo.de>
Date: Mon, 02 Jul 2012 18:03:50 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Saranya Gopal <saranya.gopal@intel.com>
CC: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] bq27x00_battery: Add support for BQ27425 chip
References: <1341075374-31704-1-git-send-email-saranya.gopal@intel.com>
In-Reply-To: <1341075374-31704-1-git-send-email-saranya.gopal@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2012 06:56 PM, Saranya Gopal wrote:
> This patch adds support for BQ27425 (TI) chip. This chip is same as
> BQ27500 with few registers removed and register address map changed.
> The data sheet for this chip is publicly available at
>  http://www.ti.com/product/bq27425-g1
> 
> Changes since v2:
>         Remove register address definitions of bq27425 and
>           use register address offset instead.
>         Add a small helper function to decide if the chip version
>           is higher than bq27200 to make it less noisy
>           to add another chip with similar register layout.
> 
> Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>

Looks good to me.

Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>

Two minor suggestions though:

>[...]
>  
>  #include <linux/module.h>
> @@ -67,6 +68,10 @@
>  #define BQ27500_FLAG_SOC1		BIT(2) /* State-of-Charge threshold 1 */
>  #define BQ27500_FLAG_FC			BIT(9)
>  
> +/* bq27425 register addresses are same as bq27x00 addresses minus 4 */
> +#define BQ27425_REG_OFFSET		0x04
> +#define BQ27425_REG_SOC			0x1C
> +

I'd have added the offset to REG_SOC here, ...

> @@ -150,6 +183,9 @@ static int bq27x00_battery_read_rsoc(struct
bq27x00_device_info *di)
>
>  	if (di->chip == BQ27500)
>  		rsoc = bq27x00_read(di, BQ27500_REG_SOC, false);
> +	else if (di->chip == BQ27425)
> +		rsoc = bq27x00_read(di, BQ27425_REG_SOC+BQ27425_REG_OFFSET,
> +								false);

... instead of here.

>  /*
> + * Higher versions of the chip like BQ27425 and BQ27500
> + * differ from BQ27000 and BQ27200 in calculation of certain
> + * parameters. Hence we need to check for the chip type.
> + */
> +static bool is_chip_version_higher(struct bq27x00_device_info *di)

Maybe a prefix for the function is not such a bad idea, e.g. bq27xxx_...

> +{
> +	if (di->chip == BQ27425 || di->chip == BQ27500)
> +		return true;
> +	return false;
> +}
> +
