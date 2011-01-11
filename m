Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab1AKPu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:50:57 -0500
Received: from smtp.nokia.com ([147.243.1.47]:46382 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160Ab1AKPu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:50:56 -0500
Date: Tue, 11 Jan 2011 17:50:06 +0200 (EET)
From: Aaro Koskinen <aaro.koskinen@nokia.com>
X-X-Sender: aakoskin@esdhcp041196.research.nokia.com
To: Jamie Iles <jamie@jamieiles.com>
cc: linux-kernel@vger.kernel.org, Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 07/16] staging: tidspbridge: don't treat NULL clk as an
 error
In-Reply-To: <1294749833-32019-8-git-send-email-jamie@jamieiles.com>
Message-ID: <alpine.DEB.1.10.1101111739400.18906@esdhcp041196.research.nokia.com>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com> <1294749833-32019-8-git-send-email-jamie@jamieiles.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 11 Jan 2011, Jamie Iles wrote:
> clk_get() returns a struct clk cookie to the driver and some platforms
> may return NULL if they only support a single clock.  clk_get() has only
> failed if it returns a ERR_PTR() encoded pointer.
>
> Cc: Omar Ramirez Luna <omar.ramirez@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> ---
> drivers/staging/tidspbridge/core/wdt.c |    9 +++++----
> 1 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/tidspbridge/core/wdt.c b/drivers/staging/tidspbridge/core/wdt.c
> index 2126f59..bfbf88d 100644
> --- a/drivers/staging/tidspbridge/core/wdt.c
> +++ b/drivers/staging/tidspbridge/core/wdt.c
> @@ -15,6 +15,7 @@
>  * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
>  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
>  */
> +#include <linux/err.h>
> #include <linux/types.h>
>
> #include <dspbridge/dbdefs.h>
> @@ -60,15 +61,15 @@ int dsp_wdt_init(void)
>
> 	dsp_wdt.fclk = clk_get(NULL, "wdt3_fck");
>
> -	if (dsp_wdt.fclk) {
> +	if (!IS_ERR(dsp_wdt.fclk)) {
> 		dsp_wdt.iclk = clk_get(NULL, "wdt3_ick");
> -		if (!dsp_wdt.iclk) {
> +		if (IS_ERR(dsp_wdt.iclk)) {
> 			clk_put(dsp_wdt.fclk);
> 			dsp_wdt.fclk = NULL;
> -			ret = -EFAULT;
> +			ret = PTR_ERR(dsp_wdt.iclk);
> 		}
> 	} else
> -		ret = -EFAULT;
> +		ret = PTR_ERR(dsp_wdt.fclk);

There are also other places in this driver where dsp_wdt.[if]clk is
checked against NULL, so this change alone is not sufficient.


> 	if (!ret)
> 		ret = request_irq(INT_34XX_WDT3_IRQ, dsp_wdt_isr, 0,
> -- 
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
