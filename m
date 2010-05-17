Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab0EQTup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:50:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45087 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab0EQTuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:50:44 -0400
Subject: Re: [PATCH 1/1] regulator: return set_mode is same mode is
 requested
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: sundar.iyer@stericsson.com
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>
In-Reply-To: <1274111688.20589.54.camel@bnru01>
References: <1274105393-32197-1-git-send-email-sundar.iyer@stericsson.com>
	 <20100517144411.GD5257@opensource.wolfsonmicro.com>
	 <1274108214.20589.28.camel@bnru01> <1274109402.20589.39.camel@bnru01>
	 <20100517153431.GA6218@opensource.wolfsonmicro.com>
	 <1274111688.20589.54.camel@bnru01>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 20:44:19 +0100
Message-ID: <1274125459.3185.18.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 21:24 +0530, Sundar R Iyer wrote:
> On Mon, 2010-05-17 at 17:34 +0200, Mark Brown wrote:
> > This doesn't seem like the right error handling - if the driver has a
> > set_mode() you'd *expect* it to have a get_mode() but there's no need
> > for it to be a strict requirement.
> True. In such a case, even a valid request would be lost! So now
> in the updated patch:
>  - check if get_mode is present to avoid oops;
>  - if get_mode is not present, proceed anyways for the request.
> 
> Here is the updated patch:
> 
> >From bad0d5eb51ef84be5b100e3dd0f5a590ea0529b6 Mon Sep 17 00:00:00 2001
> From: Sundar R Iyer <sundar.iyer@stericsson.com>
> Date: Fri, 14 May 2010 15:14:17 +0530
> Subject: [PATCH 1/1] regulator: return set_mode when same mode is requested
> 
> save I/O costs by returning when the same mode is
> requested for the regulator
> 
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> Signed-off-by: Sundar R Iyer <sundar.iyer@stericsson.com>
> ---
>  drivers/regulator/core.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 98e5d14..2248087 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1745,6 +1745,7 @@ int regulator_set_mode(struct regulator *regulator, unsigned int mode)
>  {
>  	struct regulator_dev *rdev = regulator->rdev;
>  	int ret;
> +	int regulator_curr_mode;
>  
>  	mutex_lock(&rdev->mutex);
>  
> @@ -1754,6 +1755,15 @@ int regulator_set_mode(struct regulator *regulator, unsigned int mode)
>  		goto out;
>  	}
>  
> +	/* return if the same mode is requested */
> +	if (rdev->desc->ops->get_mode) {
> +		regulator_curr_mode = rdev->desc->ops->get_mode(rdev);
> +		if (regulator_curr_mode == mode) {
> +			ret = 0;
> +			goto out;
> +		}
> +	}
> +
>  	/* constraints check */
>  	ret = regulator_check_mode(rdev, mode);
>  	if (ret < 0)


Applied.

Thanks

Liam

-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

