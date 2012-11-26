Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2KZNqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:46:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52999 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab2KZNqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:46:32 -0500
Date: Mon, 26 Nov 2012 14:46:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Axel Lin <axel.lin@ingics.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: as3711: Fix the logic in as3711_sel_check
In-Reply-To: <1353689602.3260.7.camel@phoenix>
Message-ID: <Pine.LNX.4.64.1211261445550.11501@axis700.grange>
References: <1353689452.3260.4.camel@phoenix> <1353689602.3260.7.camel@phoenix>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:2eW+JvVOAPf4LxiaxTo5Jt3atjEG+ho0dbakuJXctFl
 w6AUPbmg4aL8hSm9qwxpAe54DZ61KAZyOE5PljR2xmYdqwqhi5
 A1RQwNhU1xl0/upshyF8bijLVMRydhtmTEh+2RP9VWy3whZS39
 KOxsFe1XPQDx+CSCE/+g33htCKZ9650f1ZbODtPN8k2HXyOnMX
 JCI/3ZNHiPqLxpwO0a6yeLrbrtw1ESbWQlXoznE2/ZS9FyEB19
 BOhJEnS9+igIE2YOqkMYdaTnBG84I/8CpRUFoWOP0lmm7JzKSQ
 kyLztBmtbm/sUJa/gpr8hFE9XXsMnHpfmDkEOUKRmm6JHMhvfH
 eKVcVy/sR3iAxp/XGjWQrQ4XG8S415piCCNSJ/48GTHe34BLN9
 wuy3Oc9B/87IA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2012, Axel Lin wrote:

> Below equation means the "voltage" is the "smallest" voltage within specific
> range.
> 
> ret = DIV_ROUND_UP(min - bottom) / step;
> voltage = ret * step + bottom;
> 
> If we do try 1 down when (voltage > max), new voltage is then less than min
> voltage. Which means the new voltage is not in the requested voltage range.
> 
> This patch also includes below cleanups:
> - Use DIV_ROUND_UP
> - rename variable 'ret' to 'sel' for better readability because as3711_sel_check
>   returns the selector.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/regulator/as3711-regulator.c |   23 ++++++++---------------
>  1 file changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
> index 5e813b9..2f1341d 100644
> --- a/drivers/regulator/as3711-regulator.c
> +++ b/drivers/regulator/as3711-regulator.c
> @@ -93,24 +93,17 @@ static int as3711_bound_check(struct regulator_dev *rdev,
>  
>  static int as3711_sel_check(int min, int max, int bottom, int step)
>  {
> -	int ret, voltage;
> +	int sel, voltage;
>  
>  	/* Round up min, when dividing: keeps us within the range */
> -	ret = (min - bottom + step - 1) / step;
> -	voltage = ret * step + bottom;
> +	sel = DIV_ROUND_UP(min - bottom, step);
> +	voltage = sel * step + bottom;
>  	pr_debug("%s(): select %d..%d in %d+N*%d: %d\n", __func__,
> -	       min, max, bottom, step, ret);
> -	if (voltage > max) {
> -		/*
> -		 * Try 1 down. It will take us below min, but as long we stay
> -		 * above bottom, we're fine.
> -		 */
> -		ret--;
> -		voltage = ret * step + bottom;
> -		if (voltage < bottom)
> -			return -EINVAL;
> -	}
> -	return ret;
> +	       min, max, bottom, step, sel);
> +	if (voltage > max)
> +		return -EINVAL;
> +
> +	return sel;
>  }
>  
>  static int as3711_map_voltage_sd(struct regulator_dev *rdev,
> -- 
> 1.7.9.5
> 
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
