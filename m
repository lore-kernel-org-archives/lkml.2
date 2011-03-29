Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab1C2X3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:29:30 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57786 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1C2X33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:29:29 -0400
Subject: Re: [PATCH] regulator: When constraining modes fall back to higher
 power modes
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Collins <collinsd@codeaurora.org>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
In-Reply-To: <1301434152-16393-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1301434152-16393-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Mar 2011 00:29:24 +0100
Message-ID: <1301441364.3402.41.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 06:29 +0900, Mark Brown wrote:
> If a mode requested by a consumer is not allowed by constraints
> automatically fall back to a higher power mode if possible. This
> ensures that consumers get at least the output they requested while
> allowing machine drivers to transparently limit lower power modes
> if required.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> I've not actually had a chance to test this but throwing it out there
> for comment and testing now; someone with an OMAP board can probably
> test fairly quickly as the OMAP HSMMC driver is using set_mode().
> 
>  drivers/regulator/core.c |   24 +++++++++++++++---------
>  1 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 3ffc697..a634946 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -197,9 +197,9 @@ static int regulator_check_current_limit(struct regulator_dev *rdev,
>  }
>  
>  /* operating mode constraint check */
> -static int regulator_check_mode(struct regulator_dev *rdev, int mode)
> +static int regulator_mode_constrain(struct regulator_dev *rdev, int *mode)
>  {
> -	switch (mode) {
> +	switch (*mode) {
>  	case REGULATOR_MODE_FAST:
>  	case REGULATOR_MODE_NORMAL:
>  	case REGULATOR_MODE_IDLE:
> @@ -217,11 +217,17 @@ static int regulator_check_mode(struct regulator_dev *rdev, int mode)
>  		rdev_err(rdev, "operation not allowed\n");
>  		return -EPERM;
>  	}
> -	if (!(rdev->constraints->valid_modes_mask & mode)) {
> -		rdev_err(rdev, "invalid mode %x\n", mode);
> -		return -EINVAL;
> +
> +	/* The modes are bitmasks, the most power hungry modes having
> +	 * the lowest values. If the requested mode isn't supported
> +	 * try higher modes. */
> +	while (*mode) {
> +		if (rdev->constraints->valid_modes_mask & *mode)
> +			return 0;
> +		*mode /= 2;
>  	}
> -	return 0;
> +
> +	return -EINVAL;
>  }

It's late and I'm wondering if it's cleaner here just to :-

if (mask & *mode)
	return 0;

*mode = fls(mask);
if (*mode)
	return 0;

return -EINVAL;


What do you think ?

Liam

