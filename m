Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab2I1C7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 22:59:42 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:59156 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab2I1C7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 22:59:40 -0400
Date: Thu, 27 Sep 2012 19:56:59 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: mathieu.poirier@linaro.org
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH 54/57] power: ab8500_charger: Use USBLink1Status Register
Message-ID: <20120928025659.GM5040@lizard>
References: <1348589574-25655-1-git-send-email-mathieu.poirier@linaro.org>
 <1348589574-25655-55-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1348589574-25655-55-git-send-email-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:12:51AM -0600, mathieu.poirier@linaro.org wrote:
> From: Marcus Cooper <marcus.xm.cooper@stericsson.com>
> 
> The newer AB's such as the AB8505, AB9540 etc include a
> USBLink1 Status register which detects a larger range of
> external devices. This should be used instead of the
> USBLine Status register.
> 
> Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Reviewed-by: Hakan BERG <hakan.berg@stericsson.com>
> Reviewed-by: Yang QU <yang.qu@stericsson.com>
> Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
> ---
>  drivers/power/ab8500_charger.c |   22 ++++++++++++++++------
>  1 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
> index 3a97012..7f8f362 100644
> --- a/drivers/power/ab8500_charger.c
> +++ b/drivers/power/ab8500_charger.c
> @@ -2258,8 +2258,13 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
>  	 * to start the charging process. but by jumping
>  	 * thru a few hoops it can be forced to start.
>  	 */
> -	ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
> -			AB8500_USB_LINE_STAT_REG, &val);
> +	if (is_ab8500(di->parent))
> +		ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
> +					AB8500_USB_LINE_STAT_REG, &val);
> +	else
> +		ret = abx500_get_register_interruptible(di->dev, AB8500_USB,
> +					AB8500_USB_LINK1_STAT_REG, &val);

How about

	int reg = is_ab8500(di->parent) ? AB8500_USB_LINE_STAT_REG :
					  AB8500_USB_LINK1_STAT_REG;

	ret = abx500_get_register_interruptible(di->dev, AB8500_USB, reg, &val);

Shorter, clearer, and precisely fits into 80 columns -- must be good. :-)

> +
>  	if (ret >= 0)
>  		dev_dbg(di->dev, "UsbLineStatus register = 0x%02x\n", val);
>  	else
> @@ -2299,10 +2304,15 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
>  						AB8500_MCH_IPT_CURLVL_REG,
>  						0x01, 0x00);
>  			/*Check link status*/
> -			ret = abx500_get_register_interruptible(di->dev,
> -						AB8500_USB,
> -						AB8500_USB_LINE_STAT_REG,
> -						&val);
> +			if (is_ab8500(di->parent))
> +				ret = abx500_get_register_interruptible(di->dev,
> +					AB8500_USB, AB8500_USB_LINE_STAT_REG,
> +					&val);
> +			else
> +				ret = abx500_get_register_interruptible(di->dev,
> +					AB8500_USB, AB8500_USB_LINK1_STAT_REG,
> +					&val);
> +

Same here. Actually, isn't it exactly the same as above? If so, then just
factor it into its own function.

>  			dev_dbg(di->dev, "USB link status= 0x%02x\n",
>  				(val & link_status) >> USB_LINK_STATUS_SHIFT);
>  			di->invalid_charger_detect_state = 2;
> -- 
> 1.7.5.4
