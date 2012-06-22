Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455Ab2FVHHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 03:07:08 -0400
Received: from smtp-out-128.synserver.de ([212.40.185.128]:1045 "EHLO
	smtp-out-127.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761427Ab2FVHHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 03:07:06 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22388
Message-ID: <4FE41A77.40103@metafoo.de>
Date: Fri, 22 Jun 2012 09:10:47 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Saranya Gopal <saranya.gopal@intel.com>
CC: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] bq27x00_battery: Add support for BQ27425 chip
References: <1340035678-2195-1-git-send-email-saranya.gopal@intel.com>
In-Reply-To: <1340035678-2195-1-git-send-email-saranya.gopal@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 06:07 PM, Saranya Gopal wrote:
> This patch adds support for BQ27425 (TI) chip. This
> chip is same as BQ27500 with few registers removed
> and register address map changed. The data sheet for
> this chip is publicly available at
> http://www.ti.com/product/bq27425-g1
> 
> Changes since v1:
> 	Remove the additional Kconfig entry
> 	Add a second power_supply_property array for bq27425
> 	 and assign the appropriate array at run-time based
> 	 on battery type.
> Signed-off-by: Saranya Gopal <saranya.gopal@intel.com>

Looks mostly good. Two comments inline.

> ---
>  drivers/power/bq27x00_battery.c |   99 +++++++++++++++++++++++++++++++--------
>  1 files changed, 79 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index f5d6d37..58775ea 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -22,6 +22,7 @@
>   * Datasheets:
>   * http://focus.ti.com/docs/prod/folders/print/bq27000.html
>   * http://focus.ti.com/docs/prod/folders/print/bq27500.html
> + * http://www.ti.com/product/bq27425-g1
>   */
>  
>  #include <linux/module.h>
> @@ -67,6 +68,14 @@
>  #define BQ27500_FLAG_SOC1		BIT(2) /* State-of-Charge threshold 1 */
>  #define BQ27500_FLAG_FC			BIT(9)
>  
> +#define BQ27425_REG_TEMP		0x02
> +#define BQ27425_REG_VOLT		0x04
> +#define BQ27425_REG_FLAGS		0x06
> +#define BQ27425_REG_NAC			0x08
> +#define BQ27425_REG_FCC			0x0E
> +#define BQ27425_REG_AI			0x10
> +#define BQ27425_REG_SOC			0x1C

It looks as if all these register addresses (with the exception of REG_SOC)
are the same as the BQ27X00 register address minus 4.

What do you think about applying this offset in bq27x00_read? This would
safe us a lot of these

	if (di->chip == BQ27425)
		curr = bq27x00_read(di, BQ27425_REG_..., false);
	else
		curr = bq27x00_read(di, BQ27x00_REG_..., false);


> [...]
>  
> -	if (di->chip == BQ27500)
> +	if (di->chip == BQ27500  || di->chip == BQ27425)

Maybe it makes sense to put this check in a small helper function, this will
make it less noisy to add another chip with a similar register layout.

> [...]

