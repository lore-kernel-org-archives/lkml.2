Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab2FDIR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 04:17:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56482 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753445Ab2FDIRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 04:17:25 -0400
Message-ID: <1338797843.8574.2.camel@joe2Laptop>
Subject: Re: [PATCH RESEND v2] mfd/ab8500: print switch off cause
From: Joe Perches <joe@perches.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 04 Jun 2012 01:17:23 -0700
In-Reply-To: <1338797436-12927-1-git-send-email-linus.walleij@stericsson.com>
References: <1338797436-12927-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 10:10 +0200, Linus Walleij wrote:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>
> 
> Instead of just printing the register value, also output some
> description of the value.
> 
> Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
> Reviewed-by: Mattias Wallin <mattias.wallin@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Sam, this seems to have gone missing in the v3.5 merge window,
> it was sent out and IIRC accepted. Anyway, no big deal but
> consider pushing this for the -rc:s.
> 
> ChangeLog v1->v2:
> - Print each cause on its own line with a tab to avoid missing
>   initial cause heading if loglevel < info.
> ---
>  drivers/mfd/ab8500-core.c |   25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
> index dac0e29..6c81dc0 100644
> --- a/drivers/mfd/ab8500-core.c
> +++ b/drivers/mfd/ab8500-core.c
> @@ -1217,6 +1217,15 @@ static const struct of_device_id ab8500_match[] = {
>  
>  static int __devinit ab8500_probe(struct platform_device *pdev)
>  {
> +	static char *switch_off_status[] = {
> +		"Swoff bit programming",
> +		"Thermal protection activation",
> +		"Vbat lower then BattOk falling threshold",
> +		"Watchdog expired",
> +		"Non presence of 32kHz clock",
> +		"Battery level lower than power on reset threshold",
> +		"Power on key 1 pressed longer than 10 seconds",
> +		"DB8500 thermal shutdown"};
>  	struct ab8500_platform_data *plat = dev_get_platdata(&pdev->dev);
>  	const struct platform_device_id *platid = platform_get_device_id(pdev);
>  	enum ab8500_version version = AB8500_VERSION_UNDEFINED;
> @@ -1323,7 +1332,21 @@ static int __devinit ab8500_probe(struct platform_device *pdev)
>  		AB8500_SWITCH_OFF_STATUS, &value);
>  	if (ret < 0)
>  		return ret;
> -	dev_info(ab8500->dev, "switch off status: %#x", value);
> +	dev_info(ab8500->dev, "switch off cause(s) (%#x): ", value);
> +
> +	if (value) {
> +		for (i = 0; i < ARRAY_SIZE(switch_off_status); i++) {
> +			if (value & 1)
> +				dev_info(ab8500->dev,
> +					 "\"\t%s\" ", switch_off_status[i]);

This should be printk with or without KERN_CONT

The tab use is also not necessary, a single space
or a comma would probably be better.

