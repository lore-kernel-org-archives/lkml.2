Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030450Ab2GKW34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:29:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58456 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030333Ab2GKW3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:29:55 -0400
Date: Wed, 11 Jul 2012 15:29:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Len Brown <len.brown@intel.com>, Joe Perches <joe@perches.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        linux-kernel@vger.kernel.org, Magnus <magnus.damm@gmail.com>
Subject: Re: [PATCH] thermal: add Renesas R-Car thermal sensor support
Message-Id: <20120711152953.ea267370.akpm@linux-foundation.org>
In-Reply-To: <87ipdw9oj3.wl%kuninori.morimoto.gx@renesas.com>
References: <87ipdw9oj3.wl%kuninori.morimoto.gx@renesas.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012 11:59:42 +0900
Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> wrote:

> This patch add basic Renesas R-Car thermal sensor support.
> It was tested on R-Car H1 Marzen board.
> 
> ...
>
> +static void rcar_thermal_bset(struct rcar_thermal_priv *priv, u32 reg,
> +			      u32 mask, u32 data)
> +{
> +	u32 val = rcar_thermal_read(priv, reg);
> +
> +	val &= ~mask;
> +	val |= (data & mask);
> +
> +	rcar_thermal_write(priv, reg, val);
> +}

The driver generally looks terribly racy on SMP or uniprocessor with
preemption.

> +/*
> + *		zone device functions
> + */
> +static int rcar_thermal_get_temp(struct thermal_zone_device *zone,
> +			   unsigned long *temp)
> +{
> +	struct rcar_thermal_priv *priv = zone->devdata;
> +	int val, min, max, tmp;
> +
> +	tmp = -200; /* default */
> +	while (1) {
> +		if (priv->comp < 1 || priv->comp > 12) {
> +			dev_err(priv->dev,
> +				"THSSR invalid data (%d)\n", priv->comp);
> +			priv->comp = 4; /* for next thermal */
> +			return -EINVAL;
> +		}
> +
> +		/*
> +		 * THS comparator offset and the reference temperature
> +		 *
> +		 * Comparator	| reference	| Temperature field
> +		 * offset	| temperature	| measurement
> +		 *		| (degrees C)	| (degrees C)
> +		 * -------------+---------------+-------------------
> +		 *  1		|  -45		|  -45 to  -30
> +		 *  2		|  -30		|  -30 to  -15
> +		 *  3		|  -15		|  -15 to    0
> +		 *  4		|    0		|    0 to  +15
> +		 *  5		|  +15		|  +15 to  +30
> +		 *  6		|  +30		|  +30 to  +45
> +		 *  7		|  +45		|  +45 to  +60
> +		 *  8		|  +60		|  +60 to  +75
> +		 *  9		|  +75		|  +75 to  +90
> +		 * 10		|  +90		|  +90 to +105
> +		 * 11		| +105		| +105 to +120
> +		 * 12		| +120		| +120 to +135
> +		 */
> +
> +		rcar_thermal_bset(priv, THSCR, CPTAP, priv->comp);
> +		udelay(300);

Please try to avoid bare a udelay() like this.  It is very hard for the
reader to understand why the delay is in there, and why it has tahe
particular duration So a comment explaining the reasons is often
beneficial.

> +		/*
> +		 * calculate thermal limitation.
> +		 * see above "Temperature field measurement"
> +		 */
> +		min = (priv->comp * 15) - 60;
> +		max = min + 15;
> +
> +		/*
> +		 * get current temperature,
> +		 */
> +		val = rcar_thermal_read(priv, THSSR) & CTEMP;
> +		val = (val * 5) - 65;
> +
> +		dev_dbg(priv->dev, "comp/min/max/val = %d/%d/%d/%d\n",
> +			priv->comp, min, max, val);
> +
> +		/*
> +		 * If val is same as min/max, then,
> +		 * it should try again on next comparator.
> +		 * But the val might be correct temperature.
> +		 * Keep it on "tmp" and compare with next val.
> +		 */
> +		if (val <= min) {
> +			if (tmp == min)
> +				break;
> +
> +			tmp = min;
> +			priv->comp--; /* try again */
> +		} else if (val >= max) {
> +			if (tmp == max)
> +				break;
> +
> +			tmp = max;
> +			priv->comp++; /* try again */
> +		} else {
> +			tmp = val;
> +			break;
> +		}
> +	}
> +
> +	*temp = tmp;
> +	return 0;
> +}
>
> ...
>

> +	priv->comp	= 4; /* basic setup */
> +	priv->dev	= &pdev->dev;
> +
> +	priv->base	= devm_ioremap_nocache(&pdev->dev,
> +					       res->start, resource_size(res));

A single space before the "=" is conventional.
