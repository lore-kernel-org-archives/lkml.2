Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab2JHUw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 16:52:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58466 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab2JHUwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 16:52:54 -0400
Date: Mon, 8 Oct 2012 22:52:48 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: kernel@pengutronix.de, FlorianSchandinat@gmx.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: imxfb: Do not crash on reboot
Message-ID: <20121008205248.GU1322@pengutronix.de>
References: <1349703336-8105-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349703336-8105-1-git-send-email-fabio.estevam@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:50:47 up 107 days, 12:02, 29 users,  load average: 9.36, 12.18,
 12.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 10:35:36AM -0300, Fabio Estevam wrote:
> Issuing a "reboot" command after the LCD times out causes the following
> warnings:
> 
> Requesting system reboot

[...]

> 
> This happens because "reboot" triggers imxfb_shutdown(), which calls
> imxfb_disable_controller with the clocks already disabled.
> 
> To prevent this, add a clock enabled status so that we can check if the clocks
> are enabled before disabling them. 
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/video/imxfb.c |   19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
> index f3363b2..6acf98a 100644
> --- a/drivers/video/imxfb.c
> +++ b/drivers/video/imxfb.c
> @@ -134,6 +134,7 @@ struct imxfb_info {
>  	struct clk		*clk_ipg;
>  	struct clk		*clk_ahb;
>  	struct clk		*clk_per;
> +	int			enabled;
>  
>  	/*
>  	 * These are the addresses we mapped
> @@ -530,9 +531,12 @@ static void imxfb_enable_controller(struct imxfb_info *fbi)
>  	 */
>  	writel(RMCR_LCDC_EN_MX1, fbi->regs + LCDC_RMCR);
>  
> -	clk_prepare_enable(fbi->clk_ipg);
> -	clk_prepare_enable(fbi->clk_ahb);
> -	clk_prepare_enable(fbi->clk_per);
> +	if (!fbi->enabled) {
> +		clk_prepare_enable(fbi->clk_ipg);
> +		clk_prepare_enable(fbi->clk_ahb);
> +		clk_prepare_enable(fbi->clk_per);
> +		fbi->enabled = 1;
> +	}
>  
>  	if (fbi->backlight_power)
>  		fbi->backlight_power(1);
> @@ -551,9 +555,12 @@ static void imxfb_disable_controller(struct imxfb_info *fbi)
>  
>  	writel(0, fbi->regs + LCDC_RMCR);
>  
> -	clk_disable_unprepare(fbi->clk_per);
> -	clk_disable_unprepare(fbi->clk_ipg);
> -	clk_disable_unprepare(fbi->clk_ahb);
> +	if (fbi->enabled) {
> +		clk_disable_unprepare(fbi->clk_per);
> +		clk_disable_unprepare(fbi->clk_ipg);
> +		clk_disable_unprepare(fbi->clk_ahb);
> +		fbi->enabled = 0;
> +	}

I think the complete functions should be protected, not only the clocks.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
