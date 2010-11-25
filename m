Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab0KYJTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:19:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45383 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab0KYJTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:19:05 -0500
Date: Thu, 25 Nov 2010 10:19:03 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 7/8] ASoC: imx-ssi: fix resource leak
Message-ID: <20101125091903.GT6017@pengutronix.de>
References: <1290668785.30158.7.camel@mola> <1290669189.30158.20.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290669189.30158.20.camel@mola>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:18:51 up 145 days, 29 min, 59 users,  load average: 3.43,
	1.12, 0.62
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 03:13:09PM +0800, Axel Lin wrote:
> Fix imx_ssi_probe() error path and imx_ssi_remove() to properly free
> allocated resources.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  sound/soc/imx/imx-ssi.c |   15 +++++++++++----
>  1 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/sound/soc/imx/imx-ssi.c b/sound/soc/imx/imx-ssi.c
> index ad21f81..30894ea 100644
> --- a/sound/soc/imx/imx-ssi.c
> +++ b/sound/soc/imx/imx-ssi.c
> @@ -679,8 +679,11 @@ static int imx_ssi_probe(struct platform_device *pdev)
>  	}
>  
>  	ssi->soc_platform_pdev_fiq = platform_device_alloc("imx-fiq-pcm-audio", pdev->id);
> -	if (!ssi->soc_platform_pdev_fiq)
> +	if (!ssi->soc_platform_pdev_fiq) {
> +		ret = -ENOMEM;
>  		goto failed_pdev_fiq_alloc;
> +	}
> +
>  	platform_set_drvdata(ssi->soc_platform_pdev_fiq, ssi);
>  	ret = platform_device_add(ssi->soc_platform_pdev_fiq);
>  	if (ret) {
> @@ -689,8 +692,11 @@ static int imx_ssi_probe(struct platform_device *pdev)
>  	}
>  
>  	ssi->soc_platform_pdev = platform_device_alloc("imx-pcm-audio", pdev->id);
> -	if (!ssi->soc_platform_pdev)
> +	if (!ssi->soc_platform_pdev) {
> +		ret = -ENOMEM;
>  		goto failed_pdev_alloc;
> +	}
> +
>  	platform_set_drvdata(ssi->soc_platform_pdev, ssi);
>  	ret = platform_device_add(ssi->soc_platform_pdev);
>  	if (ret) {
> @@ -703,6 +709,7 @@ static int imx_ssi_probe(struct platform_device *pdev)
>  failed_pdev_add:
>  	platform_device_put(ssi->soc_platform_pdev);
>  failed_pdev_alloc:
> +	platform_device_del(ssi->soc_platform_pdev_fiq);
>  failed_pdev_fiq_add:
>  	platform_device_put(ssi->soc_platform_pdev_fiq);
>  failed_pdev_fiq_alloc:
> @@ -726,8 +733,8 @@ static int __devexit imx_ssi_remove(struct platform_device *pdev)
>  	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	struct imx_ssi *ssi = platform_get_drvdata(pdev);
>  
> -	platform_device_del(ssi->soc_platform_pdev);
> -	platform_device_put(ssi->soc_platform_pdev);
> +	platform_device_unregister(ssi->soc_platform_pdev);
> +	platform_device_unregister(ssi->soc_platform_pdev_fiq);
>  
>  	snd_soc_unregister_dai(&pdev->dev);
>  
> -- 
> 1.7.2
> 
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
