Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859Ab2GDKsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:48:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46020 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab2GDKsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:48:45 -0400
Date: Wed, 4 Jul 2012 12:48:40 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
Message-ID: <20120704104840.GJ24458@pengutronix.de>
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340976167-27298-1-git-send-email-acourbot@nvidia.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:45:32 up 11 days,  1:57, 78 users,  load average: 0.36, 0.63,
 1.92
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexandre,

On Fri, Jun 29, 2012 at 10:22:47PM +0900, Alexandre Courbot wrote:
> @@ -221,8 +263,6 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> -	dev_dbg(&pdev->dev, "got pwm for backlight\n");
> -
>  	/*
>  	 * The DT case will set the pwm_period_ns field to 0 and store the
>  	 * period, parsed from the DT, in the PWM device. For the non-DT case,
> @@ -231,6 +271,22 @@ static int pwm_backlight_probe(struct platform_device *pdev)
>  	if (data->pwm_period_ns > 0)
>  		pwm_set_period(pb->pwm, data->pwm_period_ns);
>  
> +
> +	pb->power_reg = devm_regulator_get(&pdev->dev, "power");
> +	if (IS_ERR(pb->power_reg))
> +		return PTR_ERR(pb->power_reg);

This looses several resources allocated earlier, like the enable gpio
and the pwm. This is really bad here since I have no regulator specified
and devm_regulator_get returns with -EPROBE_DEFER. Next time the core
tries to probe the driver the driver bails out because the gpio and the
pwm is already requested.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
