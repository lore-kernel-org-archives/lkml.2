Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab1IVRUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 13:20:42 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48736 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1IVRUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 13:20:40 -0400
Date: Thu, 22 Sep 2011 11:20:33 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        patches@linaro.org
Subject: Re: [PATCH] serial/imx: add of_alias_get_id() reference back
Message-ID: <20110922172033.GJ17168@ponder.secretlab.ca>
References: <20110921204545.19871.99088.stgit@ponder>
 <1316674093-14802-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316674093-14802-1-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 02:48:13PM +0800, Shawn Guo wrote:
> As of_alias_get_id() gets fixed and ready for use, the patch adds the
> of_alias_get_id() reference back to imx serial driver.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  drivers/tty/serial/imx.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> index 4a36470..b550cff 100644
> --- a/drivers/tty/serial/imx.c
> +++ b/drivers/tty/serial/imx.c
> @@ -1318,17 +1318,22 @@ static int serial_imx_resume(struct platform_device *dev)
>  static int serial_imx_probe_dt(struct imx_port *sport,
>  		struct platform_device *pdev)
>  {
> -	static int portnum = 0;
>  	struct device_node *np = pdev->dev.of_node;
>  	const struct of_device_id *of_id =
>  			of_match_device(imx_uart_dt_ids, &pdev->dev);
> +	int ret;
>  
>  	if (!np)
>  		return -ENODEV;
>  
> -	sport->port.line = portnum++;
> -	if (sport->port.line >= UART_NR)
> -		return -EINVAL;
> +	ret = of_alias_get_id(np, "serial");
> +	if (ret < 0) {
> +		pr_err("%s: failed to get alias id, errno %d\n",
> +			__func__, ret);

Should really be using dev_err();

> +		return -ENODEV;
> +	} else {
> +		sport->port.line = ret;
> +	}

The 'else' is unnecessary.  I've removed it.

Merged, thanks.

g.

>  
>  	if (of_get_property(np, "fsl,uart-has-rtscts", NULL))
>  		sport->have_rtscts = 1;
> -- 
> 1.7.4.1
> 
> 
